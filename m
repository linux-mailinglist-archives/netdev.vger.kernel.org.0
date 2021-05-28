Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885F1393A17
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhE1AOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhE1AOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 20:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D0D613B4;
        Fri, 28 May 2021 00:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622160763;
        bh=WUBHUPxD4MIKAP8w5uv1HpMhuP351bJqyU3oA1erBZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nAk5AhyTXJ1Oi1XuY9qT3BQIJ/Xmk2/Xz6OrVSzyI53wDOJLhJPgbWKPkYs+4wwUV
         wwgXFEBYKH3rGgjwolUEmgS5SooDLPxeIzQZjdZWPQakiUrm86bYvTwelED1BKtsJF
         uQIthITw9SUSu5h2/2n1Sdc0RWkQZHo8pemr6hP05c7DO4dq22Pi93YcZ+QVjkCBrT
         Sr7bazRKISbuVUHngmnOviIP2Fk1H2Cq/f8jCfhBVyJ1yNs7t79BRpAW/LnYOrje4v
         HpaLebnRQGlGIe3wizIBIm4mJpZsu6UlS3e7zE38Cpu6TVZwDArOfiSfgfYH2b/2pa
         GveSEHUmK7Zcg==
Date:   Thu, 27 May 2021 17:12:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, dledford@redhat.com,
        jgg@nvidia.com, linux-rdma@vger.kernel.org, leonro@nvidia.com
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, shiraz.saleem@intel.com
Subject: Re: [PATCH net-next v2 4/7] ice: Implement iidc operations
Message-ID: <20210527171241.3b886692@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527173014.362216-5-anthony.l.nguyen@intel.com>
References: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
        <20210527173014.362216-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 10:30:11 -0700 Tony Nguyen wrote:
> +static enum ice_status
> +ice_aq_add_rdma_qsets(struct ice_hw *hw, u8 num_qset_grps,
> +		      struct ice_aqc_add_rdma_qset_data *qset_list,
> +		      u16 buf_size, struct ice_sq_cd *cd)
> +{
> +	struct ice_aqc_add_rdma_qset_data *list;
> +	struct ice_aqc_add_rdma_qset *cmd;
> +	struct ice_aq_desc desc;
> +	u16 i, sum_size = 0;
> +
> +	cmd = &desc.params.add_rdma_qset;
> +
> +	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_add_rdma_qset);
> +
> +	if (!qset_list)

defensive programming

> +		return ICE_ERR_PARAM;

RDMA folks, are you okay with drivers inventing their own error codes?
Having had to make tree-wide changes and deal with this cruft in 
the past I've developed a strong dislike for it. But if you're okay
I guess it can stay, these are RDMA functions after all.

> +	if (num_qset_grps > ICE_LAN_TXQ_MAX_QGRPS)
> +		return ICE_ERR_PARAM;
> +
> +	for (i = 0, list = qset_list; i < num_qset_grps; i++) {
> +		u16 num_qsets = le16_to_cpu(list->num_qsets);
> +
> +		sum_size += struct_size(list, rdma_qsets, num_qsets);
> +		list = (struct ice_aqc_add_rdma_qset_data *)(list->rdma_qsets +
> +							     num_qsets);
> +	}
> +
> +	if (buf_size != sum_size)
> +		return ICE_ERR_PARAM;
> +
> +	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
> +
> +	cmd->num_qset_grps = num_qset_grps;
> +
> +	return ice_aq_send_cmd(hw, &desc, qset_list, buf_size, cd);
> +}

