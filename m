Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327012D1DFE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgLGXBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgLGXBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:01:16 -0500
Date:   Mon, 7 Dec 2020 17:00:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607382035;
        bh=fyhd+76aHwPWrk0CPR1KnYMh5mRTqJka/mLial7gWeo=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=B/+Hf8Qey+Ll7oUSZ/eNdnDP7LrALPR0oAwsEilG/2BPImOfqYrgywfv5LgcDXoNI
         2eFRv2q8O1M2rlYeqwWohOiA6akXdCKg4wIhTv4+KXdPayrmE2H0s1y+/0ccwUNTaO
         //hSMsUNnDRIz6bfd83nFcyAGLpNNJCDeODL4oIAN9pZn8FCMEfMhxyI9gO7f8qu/X
         c/J9cLX3pK7EdSWndKf7p5wKf5B94UIsJvoDi+fB8R93vGrmbEBlWCnOxTLHh25TQ1
         uQWrH/gM1F/rAE04p8VO0PeeDPOwDf4JYlCmDlY73BIkoWKLxg5GYzJbs9kwP9dgbJ
         5A3yO+NwAdBRg==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, kuba@kernel.org, netdev@vger.kernel.org,
        bjorn@helgaas.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] drivers: broadcom: save return value of
 pci_find_capability() in u8
Message-ID: <20201207230034.GA2298434@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206201033.21823-1-puranjay12@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 01:40:33AM +0530, Puranjay Mohan wrote:
> Callers of pci_find_capability() should save the return value in u8.
> change the type of pcix_cap from int to u8, to match the specification.
> 
> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
> index 1000c894064f..f1781d2dce0b 100644
> --- a/drivers/net/ethernet/broadcom/tg3.h
> +++ b/drivers/net/ethernet/broadcom/tg3.h
> @@ -3268,7 +3268,7 @@ struct tg3 {
>  
>  	int				pci_fn;
>  	int				msi_cap;
> -	int				pcix_cap;
> +	u8				pcix_cap;

msi_cap is also a u8.

But I don't think it's worth changing either of these unless we take a
broader look and see whether they're needed at all.

msi_cap is used to restore the MSI enable bit after a highly
device-specific reset.

pcix_cap is used for some PCI-X configuration that really should be
done via pcix_set_mmrbc() and possibly some sort of quirk for
PCI_X_CMD_MAX_SPLIT.

But that's all pretty messy and I doubt it's worth doing it at this
point, since PCI-X is pretty much ancient history.

>  	int				pcie_readrq;
>  
>  	struct mii_bus			*mdio_bus;
> -- 
> 2.27.0
> 
