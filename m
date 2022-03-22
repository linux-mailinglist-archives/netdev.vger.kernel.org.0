Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6083D4E38BD
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbiCVGLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbiCVGL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:11:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97E62654
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 23:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 319A2613FB
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5619EC340EC;
        Tue, 22 Mar 2022 06:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647929400;
        bh=ItBxs7tLv0+ISkmLRhm2UAjBn2O/WhkJGrEhIEkR9ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZeGqo60eq0x4UHAgdyAmQBQKUCS4TNjUh5hfmRar2DcdJiY08lTHo3NlezBE4oqPR
         dY48pvjKcwPT/BJd6kZUV+iM+jUYmpz0UkvUI6blIixSM/AiG3CCU/mKAh3wUkaF0d
         DN4vceKMqOZtgloTPDcUY8RW45N8oEqcxfm0gwiJ7/HtlYCi5wTeOsNkajj4wlcDmL
         saSv80g0EiqZ10k5HQHmFu79FLdG53qg5TNK4jx3Abv22CYa0DETZnYuRvuZEVVCY5
         cgKnQ8b+MLz4WZAyCdPfbD8a7iM1XDMcvc3l3jzpupw+MxH2qYIi7DSXb/lTS5q/ji
         /c+y4neyCJbjg==
Date:   Mon, 21 Mar 2022 23:09:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 11/11] bnxt: XDP multibuffer enablement
Message-ID: <20220321230958.784fe3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1647806284-8529-12-git-send-email-michael.chan@broadcom.com>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
        <1647806284-8529-12-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Mar 2022 15:58:04 -0400 Michael Chan wrote:
> From: Andy Gospodarek <gospo@broadcom.com>
> 
> Allow aggregation buffers to be in place in the receive path and
> allow XDP programs to be attached when using a larger than 4k MTU.
> 
> Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 3 +--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 5 -----
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 84c89ee7dc2f..4f7213af1955 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -1937,8 +1937,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
>  		xdp_active = true;
>  	}
>  
> -	/* skip running XDP prog if there are aggregation bufs */
> -	if (!agg_bufs && xdp_active) {
> +	if (xdp_active) {
>  		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &len, event)) {
>  			rc = 1;
>  			goto next_rx;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index adbd92971209..3780b491a1d4 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -374,11 +374,6 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
>  	int tx_xdp = 0, rc, tc;
>  	struct bpf_prog *old;
>  
> -	if (prog && bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {

This seems to be missing taking prog->aux->xdp_has_frags into account.

> -		netdev_warn(dev, "MTU %d larger than largest XDP supported MTU %d.\n",
> -			    bp->dev->mtu, BNXT_MAX_PAGE_MODE_MTU);
> -		return -EOPNOTSUPP;
> -	}
>  	if (!(bp->flags & BNXT_FLAG_SHARED_RINGS)) {
>  		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
>  		return -EOPNOTSUPP;

