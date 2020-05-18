Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86A21D8BDD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgERXwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:52:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1BBC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:52:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 996E512744681;
        Mon, 18 May 2020 16:52:53 -0700 (PDT)
Date:   Mon, 18 May 2020 16:52:53 -0700 (PDT)
Message-Id: <20200518.165253.533777581423039318.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com
Subject: Re: [PATCH net-next 2/2] qed: Add XRC to RoCE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518222100.30306-3-ybason@marvell.com>
References: <20200518222100.30306-1-ybason@marvell.com>
        <20200518222100.30306-3-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 16:52:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Tue, 19 May 2020 01:21:00 +0300

> --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> @@ -212,6 +212,15 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
>  		goto free_rdma_port;
>  	}
>  
> +	/* Allocate bit map for XRC Domains */
> +	rc = qed_rdma_bmap_alloc(p_hwfn, &p_rdma_info->xrcd_map,
> +				 QED_RDMA_MAX_XRCDS, "XRCD");
> +	if (rc) {
> +		DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
> +			   "Failed to allocate xrcd_map,rc = %d\n", rc);
> +		return rc;
> +	}

You need to perform cleanups rather than just return 'rc'.

> @@ -271,6 +280,19 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
>  		goto free_cid_map;
>  	}
>  
> +	/* The first SRQ follows the last XRC SRQ. This means that the
> +	 * SRQ IDs start from an offset equals to max_xrc_srqs.
> +	 */
> +	p_rdma_info->srq_id_offset = p_hwfn->p_cxt_mngr->xrc_srq_count;
> +	rc = qed_rdma_bmap_alloc(p_hwfn,
> +				 &p_rdma_info->xrc_srq_map,
> +				 p_hwfn->p_cxt_mngr->xrc_srq_count, "XRC SRQ");
> +	if (rc) {
> +		DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
> +			   "Failed to allocate xrc srq bitmap, rc = %d\n", rc);
> +		return rc;

Likewise.
