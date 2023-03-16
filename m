Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F5A6BCD9E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCPLJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjCPLJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA63B41B75;
        Thu, 16 Mar 2023 04:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E24761FE0;
        Thu, 16 Mar 2023 11:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE12C433A7;
        Thu, 16 Mar 2023 11:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678964987;
        bh=hnOSAdga4dwfg+vC0c7nURl+qwAE6IfsBcvANIRgu6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epaJzJMMgpNis+F8bnvqlSNgWYYMnAplNoV6qzNzC3LdoOfRd+BxntbZlwGuQzZ3f
         nfaVylK2U1xy0PkcSO6SFQB37vL+HkMetlShViscASgY4acYcd1vD6vtX9YGhx40hx
         0PLGOdKwngyd3xZH+wKLYQK5k/DCfG4cNhuE8A+mX2emCyJXZmFSAdIxnorvCFjdWc
         ZrhuSpENs4wuw+wPi1PkgqHU1r4KFGIZtN9NREL6pjw1I8G0JtXYbPpKdTpLEZP3h7
         d2N8ZW4tG8UxFk3d6B6U4HaA7GPZgVBazNIzJKtQn3mPNZxS0GFkcMzYdpNAWE3Ak0
         ki9sJplDt3itQ==
Date:   Thu, 16 Mar 2023 13:09:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230316110943.GV36557@unreal>
References: <20230315121733.27783-1-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315121733.27783-1-louis.peens@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:33PM +0200, Louis Peens wrote:
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

Please don't break lines. You have upto 80 chars per-line.

> 
> Fixes: bab65e48cb06 ("PCI/MSI: Sanitize MSI-X checks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiaoyu Li <xiaoyu.li@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
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

1. It looks like you need to fix your nfp_net_irqs_alloc() to provide
valid wanted_irqs from the beginning.
2. Both wanted_irqs and min_irqs are wrong type and should be int and
not unsigned int.

Thanks

>  
>  	for (i = 0; i < wanted_irqs; i++)
>  		irq_entries[i].entry = i;
> -- 
> 2.34.1
> 
