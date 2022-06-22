Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0FA5555A3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiFVU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiFVU7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 16:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C6615FFE;
        Wed, 22 Jun 2022 13:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83B00B82108;
        Wed, 22 Jun 2022 20:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E287FC34114;
        Wed, 22 Jun 2022 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655931544;
        bh=JAuvwzzIc8I0jEMb6uKgOcBoYXCBX/+WPVXr9EWW1kI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=UmGJQPn65btImLAlFTy2bVGaGScB5/S+aZr9e5hvEglA7m4xtXMV/bFBh87LN6eFL
         5i4WUy9cNv8vQEcWWxSzCSmEA8/ukKozHe9EOCm3aS1bWu/NshZkhHiVER55cdGOI7
         bx3Eb1Ls7F6g3a0LrF1gCDSU+Hh0xnB1ujhoRSuhtO49Wj55pIyRlnnahrloi7vzS6
         8+Gl5D5po9yoDzqEiGl7FbF4VNCrPSyJLT1ZDMblKsHiAeTGnrB0qi0y2tIAY5v0tJ
         hMjl3t/agrqYK6qZ0z7FTnNPcSWxGji6jK39zkfrGUDUpEwhOXJjD5/Bh1aZpFXN/P
         WgofHm1Ky4/9g==
Date:   Wed, 22 Jun 2022 15:59:01 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bhelgaas@google.com, Jiawen Wu <jiawenwu@trustnetic.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next v7] net: txgbe: Add build support for txgbe
Message-ID: <20220622205901.GA1390995@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621223315.60b657f4@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 10:33:15PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Jun 2022 10:32:09 +0800 Jiawen Wu wrote:
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -5942,3 +5942,18 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b1, aspm_l1_acceptable_latency
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c0, aspm_l1_acceptable_latency);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c1, aspm_l1_acceptable_latency);
> >  #endif
> > +
> > +static void quirk_wangxun_set_read_req_size(struct pci_dev *pdev)
> > +{
> > +	u16 ctl;
> > +
> > +	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
> > +
> > +	if (((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_128B) &&
> > +	    ((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_256B))
> > +		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> > +						   PCI_EXP_DEVCTL_READRQ,
> > +						   PCI_EXP_DEVCTL_READRQ_256B);
> > +}
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,
> > +			 quirk_wangxun_set_read_req_size);
> 
> Hi Bjorn! Other than the fact that you should obviously have been CCed
> on the patch [1] - what are the general rules on the quirks? Should
> this be sent separately to your PCI tree?

This is a little bit ugly because the PCI core assumes that it
controls PCI_EXP_DEVCTL_READRQ (Max_Read_Request_Size / MRRS) and uses
it as part of the hierarchy-wide strategy for managing
Max_Payload_Size / MPS.

This is all in pcie_bus_configure_settings() and is called after
enumerating all devices, so I think it happens *after* all the quirks
have been run.  So whatever this quirk does might be overwritten by
pcie_bus_configure_settings().

I assume wangxun needs to set MRRS to 128 or 256 bytes.  The power-up
default is supposed to be 512 bytes, and pcie_bus_configure_settings()
may choose something else.  There are some drivers that call
pcie_set_readrq() from their probe functions, and that's probably what
you should do, too.

I do see that quirk_brcm_5719_limit_mrrs() does this as a quirk after
0b471506712d ("tg3: Recode PCI MRRS adjustment as a PCI quirk"), but I
don't think that is reliable.  Apparently it *used* to be done during
probe, and I don't know why it was changed to be a quirk.

> [1]
> https://lore.kernel.org/all/20220621023209.599386-1-jiawenwu@trustnetic.com/
