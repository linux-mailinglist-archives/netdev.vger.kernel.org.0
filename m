Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBF061EB23
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiKGGle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKGGld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:41:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63BF64E9;
        Sun,  6 Nov 2022 22:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CA560C64;
        Mon,  7 Nov 2022 06:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402F0C433D6;
        Mon,  7 Nov 2022 06:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667803291;
        bh=U0SynG610DSqGIW9D//fFEojtynW6o3KzHgwrCnPAUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8fVPl7X6f1QT5qJnoJ+j3q7wWmtwE3H65i/lkp0HHTu8bpRLlkUpp2i/51mrKYSl
         DOXtgnMm0ebCT5sxFwt7vJWA89GA4ymNM3HWOCAzQx8KLe53CPYd4dSUDoEKHwbPjM
         irOij7npoz+f0hhu1LZqE8a6IU74Pp2FJGoPuegysSO5mSC4gk0YPAETSO0ha2QkSN
         ayT0tFn4ALrC8EuhuA+EH5OCUYLXZqAeWuGijC5cHT7qY1GPSWolM9etBBpBMtBqmR
         03EmzmfLEdqhkhwcyykZYRosO+l9z/4oqonMsYmRnILYHJT/a2VsjPJYGvFnwY+0wV
         bJfToVjr3i71Q==
Date:   Mon, 7 Nov 2022 08:41:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v3 5/6] bnxt_en: Use auxiliary bus calls over proprietary
 calls
Message-ID: <Y2iol/ypwVMqrpQT@unreal>
References: <CACZ4nhtmE9Dh9z_O9-A934+q0_8yHEyj+V-DcEsuEWFbPH6BGg@mail.gmail.com>
 <20221104162733.73345-1-ajit.khaparde@broadcom.com>
 <20221104162733.73345-6-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104162733.73345-6-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 09:27:32AM -0700, Ajit Khaparde wrote:
> Wherever possible use the function ops provided by auxiliary bus
> instead of using proprietary ops.
> 
> Defined bnxt_re_suspend and bnxt_re_resume calls which can be
> invoked by the bnxt_en driver instead of the ULP stop/start calls.
> 
> Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/main.c          | 102 +++++++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  40 ++++---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   2 -
>  3 files changed, 87 insertions(+), 57 deletions(-)

<...>

>  void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> index 26b7c627342b..e96f93d38a30 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> @@ -29,8 +29,6 @@ struct bnxt_msix_entry {
>  struct bnxt_ulp_ops {

Once you convert to use AUX bus, this struct should go too.

>  	/* async_notifier() cannot sleep (in BH context) */
>  	void (*ulp_async_notifier)(void *, struct hwrm_async_event_cmpl *);
> -	void (*ulp_stop)(void *);
> -	void (*ulp_start)(void *);
>  	void (*ulp_sriov_config)(void *, int);
>  	void (*ulp_shutdown)(void *);
>  	void (*ulp_irq_stop)(void *);
> -- 
> 2.37.1 (Apple Git-137.1)
> 


