Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528F940FC39
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhIQP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhIQP1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EFCE60E08;
        Fri, 17 Sep 2021 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631892373;
        bh=UZqfTYO7RI9M+7Vxrv3DWw7RCxWe7AbDW1byXQjcEYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=jjqePD6AzWn+Hen3UKqGFgCjQuKC561K7fvobsKR6kTj9I03GXn0dhABnk0/Dbj6m
         Di870ru5X8c8V3GEdHcXzBjzq60KuxU/LMXL5jHJ/RFyaJQCOLh4dcitg2KsHmk2ID
         yskcHVUTdnu8lJE//948lBkRGt9RdfX4lo/Ufx9hgnlz9R+LXS4SR+XqIcoAP2i+1c
         bqkitcYuQgzKVqdNKiwXZY02UiSRw/MwY9q9MQFSblEowBf1lQJgvhqsXsEawDzg/Y
         VMbMzjRSCvblIyse53ZzBViADeqllirMQwD87etmwyJakdSBbRNLGlcV3qbg8qpQ6A
         HKy5tGL5v/Pkw==
Date:   Fri, 17 Sep 2021 10:26:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH net-next v5 2/3] r8169: Use PCIe ASPM status for
 NIC ASPM enablement
Message-ID: <20210917152612.GA1717817@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p445rDeL1VFRYFA3QEbKZ6JtjzhCb9fxpR3eZ9E9NAETA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 12:09:08PM +0800, Kai-Heng Feng wrote:
> On Fri, Sep 17, 2021 at 1:07 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Thu, Sep 16, 2021 at 11:44:16PM +0800, Kai-Heng Feng wrote:
> > > Because ASPM control may not be granted by BIOS while ASPM is enabled,
> > > and ASPM can be enabled via sysfs, so use pcie_aspm_enabled() directly
> > > to check current ASPM enable status.
> > >
> > > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > ---
> > > v5:
> > >  - New patch.
> > >
> > >  drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
> > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > > index 0199914440abc..6f1a9bec40c05 100644
> > > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > > @@ -622,7 +622,6 @@ struct rtl8169_private {
> > >       } wk;
> > >
> > >       unsigned supports_gmii:1;
> > > -     unsigned aspm_manageable:1;
> > >       dma_addr_t counters_phys_addr;
> > >       struct rtl8169_counters *counters;
> > >       struct rtl8169_tc_offsets tc_offset;
> > > @@ -2664,8 +2663,13 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
> > >
> > >  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> > >  {
> > > -     /* Don't enable ASPM in the chip if OS can't control ASPM */
> > > -     if (enable && tp->aspm_manageable) {
> > > +     struct pci_dev *pdev = tp->pci_dev;
> > > +
> > > +     /* Don't enable ASPM in the chip if PCIe ASPM isn't enabled */
> > > +     if (!pcie_aspm_enabled(pdev) && enable)
> > > +             return;
> >
> > What happens when the user enables or disables ASPM via sysfs (see
> > https://git.kernel.org/linus/72ea91afbfb0)?
> >
> > The driver is not going to know about that change.
> 
> So it's still better to fold this patch into next one? So the periodic
> delayed_work can toggle ASPM accordingly.

No, my point is that the user can enable/disable ASPM via sysfs, and
the driver will not know anything about it.  There's no callback that
tells the driver when this happens.

My question is whether this code works when that happens.  I doubt it
works, because if ASPM is not enabled at this moment, you return
without doing enabling ASPM in the chip below.

If the user subsequently enables ASPM via sysfs, the chip setup below
will not be done.

If there's chip-specific setup to make ASPM work, I think the
chip-specific part needs to be done unconditionally.

> > > +     if (enable) {
> > >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> > >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> > >       } else {
> > > @@ -5272,8 +5276,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> > >       /* Disable ASPM L1 as that cause random device stop working
> > >        * problems as well as full system hangs for some PCIe devices users.
> > >        */
> > > -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > > -     tp->aspm_manageable = !rc;
> > > +     pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > >
> > >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> > >       rc = pcim_enable_device(pdev);
> > > --
> > > 2.32.0
> > >
