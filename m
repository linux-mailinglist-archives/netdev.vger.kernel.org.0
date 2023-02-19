Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E900769BFE3
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBSJxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjBSJxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B626F171A;
        Sun, 19 Feb 2023 01:53:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48079B803F1;
        Sun, 19 Feb 2023 09:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B968C433A1;
        Sun, 19 Feb 2023 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676800101;
        bh=RdGXKg9ll+t6+jvhug7bC+8oJTVfF6ScFK4r5+vlmPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cI6eTRfi9PI61AKC6aJER6BdSPAri3DLYpaGAxJ0KhOzZDLjOvMfzgI0Q86XCMzuB
         iqysAoXR8K9mmIoeKvaAPvNnYxSBM2hpYxpQUTeoEV+deM7eEi63lWd3BjABXLG7b7
         ecsuyPmWhOt/IRiMe3eUqd4KgWt7qzeuDUrdzhpSgRT50pXKGDaQ2gQn/b7lGMiLnH
         x/KaETvPD0SDorZgr2NfxI4zaR4SMfPHoiFJG3ZaaJgaaGa3sknXh4/zHdvYPzbIIm
         aXaIghsCboGzQga7cTAodgpQoYar2L9r6gRRlalnSPgzHFVV7bxGZ6HStT8vdNopc6
         U8kfWoGdsOLAA==
Date:   Sun, 19 Feb 2023 11:48:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] bnx2: remove deadcode in bnx2_init_cpus()
Message-ID: <Y/HwYZFblWkUD2+n@unreal>
References: <20230218130016.42856-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218130016.42856-1-korotkov.maxim.s@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 04:00:16PM +0300, Maxim Korotkov wrote:
> The load_cpu_fw function has no error return code
> and always returns zero. Checking the value returned by
> this function does not make sense.
> As a result, bnx2_init_cpus will also return only zero
> 
> Found by Security Code and Linux Verification
> Center (linuxtesting.org) with SVACE
> 
> Fixes: 57579f7629a3 ("bnx2: Use request_firmware()")
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index 9f473854b0f4..4dacb65a7348 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -3908,37 +3908,27 @@ bnx2_init_cpus(struct bnx2 *bp)
>  		(const struct bnx2_mips_fw_file *) bp->mips_firmware->data;
>  	const struct bnx2_rv2p_fw_file *rv2p_fw =
>  		(const struct bnx2_rv2p_fw_file *) bp->rv2p_firmware->data;
> -	int rc;
>  
>  	/* Initialize the RV2P processor. */
>  	load_rv2p_fw(bp, RV2P_PROC1, &rv2p_fw->proc1);
>  	load_rv2p_fw(bp, RV2P_PROC2, &rv2p_fw->proc2);
>  
>  	/* Initialize the RX Processor. */
> -	rc = load_cpu_fw(bp, &cpu_reg_rxp, &mips_fw->rxp);
> -	if (rc)
> -		goto init_cpu_err;
> +	(void)load_cpu_fw(bp, &cpu_reg_rxp, &mips_fw->rxp);

Please don't cast return types to void. It is useless.

Thanks
