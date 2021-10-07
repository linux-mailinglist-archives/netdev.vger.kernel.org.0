Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22590425B5B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbhJGTMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhJGTMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 15:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5322460F23;
        Thu,  7 Oct 2021 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633633859;
        bh=5FPgGsdS9CGMt/+v0V8mAY3UCQa9nlPwQ/iINFo9MFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VB3rIawLUmFCZHXKhU2KxNoiw0OTAuA0Znwcz4szP2GRoGPFOqjgjxO9YM/n1MSa1
         VTzNkc2D9u1bddWPnTWoeSQEOZMGbDcS8s+hOEC62Aku49LTg4GhA2k6V+thAqCOzf
         DkXP4fZ2JOP2QNEPXLuZ4l0BdG3AXVOEMRkBtE4ablqPkh1Y7ZlNhYtcKuUuP07S5b
         3hshQn1HgbAoP6SrFg3iJeVEFi2AoUvW+H+INv+ITMY32iLjrjDqRNseN7av6xndlj
         b+9jwFNh9GMJhtJwRVJCvrB3zRVKvPUYBOLWydb2+mMQanT12ZUqleXDJu37d0AWRr
         VxTrF0aLgnfuQ==
Date:   Thu, 7 Oct 2021 14:10:57 -0500
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
Subject: Re: [RFC] [PATCH net-next v5 0/3] r8169: Implement dynamic ASPM
 mechanism for recent 1.0/2.5Gbps Realtek NICs
Message-ID: <20211007191057.GA1252539@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p409uhbor1ArZ=kfiMK2JRHVGVyYukDSSyDvFsVSs=ErQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 12:17:26PM +0800, Kai-Heng Feng wrote:
> On Sat, Sep 18, 2021 at 6:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Thu, Sep 16, 2021 at 11:44:14PM +0800, Kai-Heng Feng wrote:
> > > The purpose of the series is to get comments and reviews so we can merge
> > > and test the series in downstream kernel.
> > >
> > > The latest Realtek vendor driver and its Windows driver implements a
> > > feature called "dynamic ASPM" which can improve performance on it's
> > > ethernet NICs.
> > >
> > > Heiner Kallweit pointed out the potential root cause can be that the
> > > buffer is too small for its ASPM exit latency.
> >
> > I looked at the lspci data in your bugzilla
> > (https://bugzilla.kernel.org/show_bug.cgi?id=214307).
> >
> > L1.2 is enabled, which requires the Latency Tolerance Reporting
> > capability, which helps determine when the Link will be put in L1.2.
> > IIUC, these are analogous to the DevCap "Acceptable Latency" values.
> > Zero latency values indicate the device will be impacted by any delay
> > (PCIe r5.0, sec 6.18).
> >
> > Linux does not currently program those values, so the values there
> > must have been set by the BIOS.  On the working AMD system, they're
> > set to 1048576ns, while on the broken Intel system, they're set to
> > 3145728ns.
> >
> > I don't really understand how these values should be computed, and I
> > think they depend on some electrical characteristics of the Link, so
> > I'm not sure it's *necessarily* a problem that they are different.
> > But a 3X difference does seem pretty large.
> >
> > So I'm curious whether this is related to the problem.  Here are some
> > things we could try on the broken Intel system:
> 
> Original network speed, tested via iperf3:
> TX: ~255 Mbps
> RX: ~490 Mbps
> 
> >   - What happens if you disable ASPM L1.2 using
> >     /sys/devices/pci*/.../link/l1_2_aspm?
> 
> TX: ~670 Mbps
> RX: ~670 Mbps
> 
> >   - If that doesn't work, what happens if you also disable PCI-PM L1.2
> >     using /sys/devices/pci*/.../link/l1_2_pcipm?
> 
> Same as only disables l1_2_aspm.
> 
> >   - If either of the above makes things work, then at least we know
> >     the problem is sensitive to L1.2.
> 
> Right now the downstream kernel disables ASPM L1.2 as workaround.
> 
> >   - Then what happens if you use setpci to set the LTR Latency
> >     registers to 0, then re-enable ASPM L1.2 and PCI-PM L1.2?  This
> >     should mean the Realtek device wants the best possible service and
> >     the Link probably won't spend much time in L1.2.
> 
> # setpci -s 01:00.0 ECAP_LTR+4.w=0x0
> # setpci -s 01:00.0 ECAP_LTR+6.w=0x0
> 
> Then re-enable ASPM L1.2, the issue persists - the network speed is
> still very slow.
> 
> >   - What happens if you set the LTR Latency registers to 0x1001
> >     (should be the same as on the AMD system)?
> 
> Same slow speed here.

Thanks a lot for indulging my curiosity and testing this.  So I guess
you confirmed that specifically ASPM L1.2 is the issue, which makes
sense given the current downstream kernel workaround.
