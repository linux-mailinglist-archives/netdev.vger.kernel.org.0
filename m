Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251BB6CFB68
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjC3GS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjC3GSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60A4C2B;
        Wed, 29 Mar 2023 23:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD5FB8243B;
        Thu, 30 Mar 2023 06:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F057CC433EF;
        Thu, 30 Mar 2023 06:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680157124;
        bh=PAv9z/iIHs5d6Pg/TQqBAHkjXw6uAJFB7HbtADAy++o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDEW8Aq6IZbiai3HRQ1XD2KWihevSQ0QcrtiytkgEgoFI+9pcyq4x6cOXJNwW292e
         GTuwCdtX2oNRa5Hfhzcb5grFBwCBquvdpnudcgqE7vdWLQ77VDBmFUMSwQ8hvJlDXT
         +TIosZvp+avObGOEvzAH7K43v5xGITOdFhP8FJL+l/+2IBopuRUhcaHi4GZgIz4Wc+
         CRUJAF4fKJKi2c+hBJ9+XfE5QURqsWeAFNzTCf3RRgsxFDcmmIzQsstKVYPP+Hchi6
         TjpqxYHxxqMAorNdjB7s6IAMsewpu2BGxo7aRQJ8PGmHeGmPsMvuYFU2i5KvPk5c/F
         HshUFteCY5OLQ==
Date:   Thu, 30 Mar 2023 09:18:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac type
Message-ID: <20230330061840.GM831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-4-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-4-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:15PM +0530, Sai Krishna wrote:
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
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index 724df6398bbe..180aa84cf1c3 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -1231,6 +1231,13 @@ static inline void link_status_user_format(u64 lstat,
>  	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
>  	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
>  	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
> +
> +	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
> +		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
> +			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
> +		return;

You are keeping old lmac_type, which is out-of-sync now.
Why don't you do something like that?

if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
  strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
  return;
}


> +	}
> +
>  	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
>  	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
>  }
> -- 
> 2.25.1
> 
