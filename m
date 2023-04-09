Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE0E6DC0DE
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjDIRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDIRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE10F3580;
        Sun,  9 Apr 2023 10:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA8360C1A;
        Sun,  9 Apr 2023 17:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C97C433EF;
        Sun,  9 Apr 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681061419;
        bh=miZppwDuIavFehIAVJkFCznDhxf9aPcdDB3meGBk/BM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aE4u2QwTbDUH0lJYj8gUPA2oj7mt9givjds+aEDRwEfJMtYHOwfeLQrimgzrEcHTL
         osk2TOg0mP8R22UtkvCO1Tgb/2j0FDkJsXLNI1bbPFWAz74CdbF5JUrBXRwquYf/hm
         2yZWsjpBcVheGC+QQiNjHoobR5iPTwuckS8Pv6b8DCtcJ4Rz7Ht/91LDUwTkAVSv3T
         stxFHM9aKyJl9l0UrTOl+pWg74gU01b/SoL9a+58bGKLh6ehiusNxsRRYsA8SKXKLg
         UIYCiJRxlikbJLWbWg334k9ohSpBNKvhtelcrmNHHiRo3azvUC6Sm1QqTtPFPl+Tcs
         sUy3eIttuEW6g==
Date:   Sun, 9 Apr 2023 20:30:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v2 3/7] octeontx2-af: Add validation for lmac type
Message-ID: <20230409173015.GK182481@unreal>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-4-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-4-saikrishnag@marvell.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:40PM +0530, Sai Krishna wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> Upon physical link change, firmware reports to the kernel about the
> change along with the details like speed, lmac_type_id, etc.
> Kernel derives lmac_type based on lmac_type_id received from firmware.
> 
> In a few scenarios, firmware returns an invalid lmac_type_id, which
> is resulting in below kernel panic. This patch adds the missing
> validation of the lmac_type_id field.
> 
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [   35.321595] Modules linked in:
> [   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
> 5.4.210-g2e3169d8e1bc-dirty #17
> [   35.337014] Hardware name: Marvell CN103XX board (DT)
> [   35.344297] Workqueue: events work_for_cpu_fn
> [   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
> [   35.360267] pc : strncpy+0x10/0x30
> [   35.366595] lr : cgx_link_change_handler+0x90/0x180
> 
> Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> 

Your patch missing --- trailers and probably won't apply correctly.

Thanks

>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index 724df6398bbe..bd77152bb8d7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -1231,6 +1231,14 @@ static inline void link_status_user_format(u64 lstat,
>  	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
>  	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
>  	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
> +
> +	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
> +		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
> +			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
> +		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
> +		return;
> +	}
> +
>  	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
>  	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
>  }
> -- 
> 2.25.1
> 
