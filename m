Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0313554A31A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 02:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiFNAQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 20:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiFNAQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 20:16:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8611F3335F;
        Mon, 13 Jun 2022 17:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CCEB8168C;
        Tue, 14 Jun 2022 00:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE389C34114;
        Tue, 14 Jun 2022 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655165758;
        bh=9vD88Uc8Q5zVQGKFcGIyXFtDgsV/H+C9nV1VBmIMbF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=q0EpGdVEGXm12xuJbkjWUP4Q/THRamBL5ojjx9OVySEU7oBfAdW8F/SEZUvo75UKx
         0C0gen7O8U8Fga9qm7Wz1uNxIW0MpgFMlLZZ0HelFIQP0fnmq3Q6gDcFCJea8FGE/t
         /S0gEV5TnFHdxKLASH/xbgTqE5QCy41gi6Af5KwIBTD8kl67jnKVIs4HskhuFLGjio
         7bu0R3GZ0tca+Fh/jQ6nr5QPd/Ixfhr2nZr84EH6PLONpf4Te1I0hYXwUkSRJzMvrT
         gJXUr6Jm68rB8wV9WUgncIwjDn/8zJGUqmn0/QxuwYgsmxU5ju9d3Vp2bCgGkQHbko
         uuiafqVtamdbg==
Date:   Mon, 13 Jun 2022 19:15:56 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, bhelgaas@google.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: Re: [PATCH] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Message-ID: <20220614001556.GA728570@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609185811.GA524052@bhelgaas>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 01:58:13PM -0500, Bjorn Helgaas wrote:
> On Thu, Jun 09, 2022 at 01:41:47PM -0400, Michael Chan wrote:
> > From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > 
> > The Broadcom BCM5750x NICs may be multi-function devices.  They do
> > not advertise ACS capability. Peer-to-peer transactions are not
> > possible between the individual functions, so it is safe to treat
> > them as fully isolated.
> > 
> > Add an ACS quirk for these devices so the functions can be in
> > independent IOMMU groups and attached individually to userspace
> > applications using VFIO.
> > 
> > Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> 
> Applied to pci/virtualization for v5.20, thanks!

I forgot to ask: is there a plan for future devices to include an ACS
capability?  Or will we be stuck adding quirks forever?

> > ---
> >  drivers/pci/quirks.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 41aeaa235132..2e68f50bc7ae 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -4924,6 +4924,9 @@ static const struct pci_dev_acs_enabled {
> >  	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
> >  	/* Broadcom multi-function device */
> >  	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
> > +	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
> > +	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
> > +	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
> >  	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
> >  	/* Amazon Annapurna Labs */
> >  	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
> > -- 
> > 2.18.1
> > 
> 
> 
