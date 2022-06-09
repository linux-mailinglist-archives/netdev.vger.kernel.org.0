Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E2B545488
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiFIS6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiFIS6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C773840934;
        Thu,  9 Jun 2022 11:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A830C61DEA;
        Thu,  9 Jun 2022 18:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2AAC34114;
        Thu,  9 Jun 2022 18:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654801093;
        bh=wUtjEva0QOt/F/AmGZ6YQRbUN14ekRRPOGohfdMT0tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=q2s9WFnCQiabNnyMz2aoW0nc152A52YWYLSk/DFNwsZ/P0KGJtQq9Y1qTp1jLUVNm
         zSfXb0qCAjmljii+7u/o2V1tGQl8J1qIXhd7K0ja+agmihQBPX/69QRnoNWLD62VEH
         SbkksDg5Wvb3uiTsuWruFvNCjZ4IgZ4Ybcdh16WrtiATexKkpdHmABPWLO1M62ws7X
         QH1mQiczhvvA4gpYwpgKIASLyNms+96koybkg5/SAgejckpfaH3NKCsF9tzyVzMqEe
         QCwRROfR81z080yAMU8llO/S6HuinvpxVE/C6onrI8XuBT83wiCrt3eBuevGv/1+i/
         e7ygzy9cizXNg==
Date:   Thu, 9 Jun 2022 13:58:11 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, bhelgaas@google.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: Re: [PATCH] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Message-ID: <20220609185811.GA524052@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654796507-28610-1-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 01:41:47PM -0400, Michael Chan wrote:
> From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> 
> The Broadcom BCM5750x NICs may be multi-function devices.  They do
> not advertise ACS capability. Peer-to-peer transactions are not
> possible between the individual functions, so it is safe to treat
> them as fully isolated.
> 
> Add an ACS quirk for these devices so the functions can be in
> independent IOMMU groups and attached individually to userspace
> applications using VFIO.
> 
> Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied to pci/virtualization for v5.20, thanks!

> ---
>  drivers/pci/quirks.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 41aeaa235132..2e68f50bc7ae 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -4924,6 +4924,9 @@ static const struct pci_dev_acs_enabled {
>  	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
>  	/* Broadcom multi-function device */
>  	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
> +	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
> +	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
> +	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
>  	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
>  	/* Amazon Annapurna Labs */
>  	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
> -- 
> 2.18.1
> 


