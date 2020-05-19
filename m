Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63D71DA473
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgESWXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgESWXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:23:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A84C061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:23:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A7E5128EC8C8;
        Tue, 19 May 2020 15:23:39 -0700 (PDT)
Date:   Tue, 19 May 2020 15:23:35 -0700 (PDT)
Message-Id: <20200519.152335.968463052378721004.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     mkalderon@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next,v2 2/2] qed: Add XRC to RoCE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519205126.26987-3-ybason@marvell.com>
References: <20200519205126.26987-1-ybason@marvell.com>
        <20200519205126.26987-3-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:23:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Tue, 19 May 2020 23:51:26 +0300

> @@ -1748,24 +1839,26 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
>  	u16 opaque_fid, srq_id;
>  	struct qed_bmap *bmap;
>  	u32 returned_id;
> +	u16 offset;
>  	int rc;
>  
> -	bmap = &p_hwfn->p_rdma_info->srq_map;
> +	bmap = qed_rdma_get_srq_bmap(p_hwfn, in_params->is_xrc);
>  	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
>  	rc = qed_rdma_bmap_alloc_id(p_hwfn, bmap, &returned_id);
>  	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
>  
>  	if (rc) {
> -		DP_NOTICE(p_hwfn, "failed to allocate srq id\n");
> +		DP_NOTICE(p_hwfn,
> +			  "failed to allocate xrc/srq id (is_xrc=%u)\n",
> +			  in_params->is_xrc);
>  		return rc;
>  	}
>  
> -	elem_type = QED_ELEM_SRQ;
> +	elem_type = (in_params->is_xrc) ? (QED_ELEM_XRC_SRQ) : (QED_ELEM_SRQ);
>  	rc = qed_cxt_dynamic_ilt_alloc(p_hwfn, elem_type, returned_id);
>  	if (rc)
>  		goto err;

This "if (rc)" error path will leak 'returned_id' won't it?
