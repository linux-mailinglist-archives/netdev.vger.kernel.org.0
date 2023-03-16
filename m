Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4356BDAE3
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCPVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCPVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:25:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB967B1B03;
        Thu, 16 Mar 2023 14:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F138B82348;
        Thu, 16 Mar 2023 21:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C657FC433EF;
        Thu, 16 Mar 2023 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679001914;
        bh=VJaH2tgvPeEsMZ/rgxzMYg8E8mAp8tb9Qng1bNYTpxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bZi2XUM5r21jfkOq0Abm/JfrNoxElM64/Dl7fAicCcGKs5Zu+IE0j0vdhLIiMp0CO
         +rYGO6f1KxhDkRQz9R9DPexPVYZQeB4Cl7cHZw397OIWV3AFr97QJhEqRXEE56jDUg
         rWdkT90KO4IUerQkyt0CtbRY9eLwEFI9DqqWbO0iCco6B/Mvd+usdtAH9uJr8XfH5f
         hcohtHaZThbaquYRcp3rKq8Z4YwtMHAF4GeCMlIRagEkVj2a8eFZQJY+RMn2L30wh5
         Z5lWZ2l+rqoIvtOTxxfQkhlJQHzvPW62qqMbG3WSowWWDPPB6HZPUshvNCHIJp6AFp
         8ViAfHJfjjRlg==
Date:   Thu, 16 Mar 2023 14:25:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230316142512.4c9a9ff4@kernel.org>
In-Reply-To: <20230315121733.27783-1-louis.peens@corigine.com>
References: <20230315121733.27783-1-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 14:17:33 +0200 Louis Peens wrote:
> From: Xiaoyu Li <xiaoyu.li@corigine.com>
> 
> Before the referenced commit, when we requested a
> certain number of interrupts, if we could not meet
> the requirements, the number of interrupts supported
> by the hardware would be returned. But after the
> referenced commit, if the hardware failed to meet
> the requirements, the error of invalid argument
> would be directly returned, which caused a regression
> in the nfp driver preventing probing to complete.
> 
> Fixes: bab65e48cb06 ("PCI/MSI: Sanitize MSI-X checks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiaoyu Li <xiaoyu.li@corigine.com>

Thomas, is this an expected side effect?

The commit message of bab65e48cb06 ("PCI/MSI: Sanitize MSI-X checks")
makes it sound like only a harmless refactoring was intended.

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 62f0bf91d1e1..0e4cab38f075 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -370,6 +370,12 @@ nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
>  {
>  	unsigned int i;
>  	int got_irqs;
> +	int max_irqs;
> +
> +	max_irqs = pci_msix_vec_count(pdev);
> +	if (max_irqs < 0)
> +		return max_irqs;
> +	wanted_irqs = min_t(unsigned int, max_irqs, wanted_irqs);
>  
>  	for (i = 0; i < wanted_irqs; i++)
>  		irq_entries[i].entry = i;
