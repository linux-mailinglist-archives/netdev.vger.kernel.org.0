Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763014C22D1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiBXECm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBXECl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AC61693BB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF75F61706
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 04:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB1C340EF;
        Thu, 24 Feb 2022 04:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645675328;
        bh=Izuxd7Nxyyq05xrgSYqVOg2W2LKEb1jPQ6D78Q9Mg4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hGH9stqOYDYOEXldrc2pm+2rW21LyES6fpBkyxvsjHfDoZbN0e1D1fqimaIVQCysq
         pS/4+kMuG9wJ1ucx10xa58La1Ea4uIZkUJRW2bvAaEN/jdUteobODxxgAOLyJny4jS
         y/4MLA2TGZOYHQvoO19X6YDI37b8ySlWEnxUQoNaRwQQmAkOBL3KhbZjeBfh2pASnO
         wCR7xnAvB6p7C7ZgXcwLPx36dhOcsrLQFoDOf24SV7VcPsQVV5yjpTadbbh2BUl/tF
         PAD6ipzqJBmGp6epNFVFIKl+ULZhPJ+v93Gmf6g9Ez5GIhptwVNa7/dFaoHs+jwITk
         Ico8dePDbl/WA==
Date:   Wed, 23 Feb 2022 20:02:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 11/12] drivers: vxlan: vnifilter: per vni
 stats
Message-ID: <20220223200206.20169386@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222025230.2119189-12-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-12-roopa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 02:52:29 +0000 Roopa Prabhu wrote:
> @@ -164,7 +166,6 @@ int vxlan_vnilist_update_group(struct vxlan_dev *vxlan,
>  			       union vxlan_addr *new_remote_ip,
>  			       struct netlink_ext_ack *extack);
>  
> -

spurious

>  /* vxlan_multicast.c */
>  int vxlan_multicast_join(struct vxlan_dev *vxlan);
>  int vxlan_multicast_leave(struct vxlan_dev *vxlan);

> +void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
> +			   int type, unsigned int len)
> +{
> +	struct vxlan_vni_node *vninode;
> +
> +	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
> +		return;
> +
> +	vninode = vxlan_vnifilter_lookup(vxlan, vni);
> +	if (!vninode)
> +		return;

Don't we end up calling vxlan_vnifilter_lookup() multiple times for
every packet? Can't we remember the vninode from vxlan_vs_find_vni()?

> +	vxlan_vnifilter_stats_add(vninode, type, len);
> +}
