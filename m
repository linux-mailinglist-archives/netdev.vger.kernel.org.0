Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC9A426C2A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhJHN6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJHN6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 09:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE56360F9C;
        Fri,  8 Oct 2021 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633701417;
        bh=E/nSecu6Pc/mRjr9vvflfiRySB+cFKjgQerSAfXXHqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=n+Ok7ebiSA0k2knuTA0LnN+4f/lxSMOQa+QblG8QkqDJSXIpgy/4MGw8ClVgZfobh
         y80316XrhB9VY+QxxdZiykEwbrCLdElV2BetoAMvl9VlYlNQtAmzVTZCdJRw2ZRdHo
         pdmGtX+VeVw+M8/0H5OqQE+XXKOem+UEz2f6XlD+P/PerOZEjRKfVByA7zbfbS0sOR
         I2NAPTO96+pnWn/gHmntaf640enjg8BORFJe8u21CYECF50SkWox6iCaIHbf8fHuoy
         CUJjfnS8GVvPtBrxbINHh+FPOeiOO7AgzNsvmLVvw7zp9DNjVm4Ri4ZG1+m+GgLaka
         DqagQXK4lqfkQ==
Date:   Fri, 8 Oct 2021 08:56:55 -0500
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
Message-ID: <20211008135655.GA1326714@bhelgaas>
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

Do you remember if there were any dropped packets here?  You mentioned
at [1] that you have also seen reports of issues with L0s and L1.1.
If you disable L1.2, L0s and L1.1 *should* still be enabled.

[1] https://lore.kernel.org/r/CAAd53p4v+CmupCu2+3vY5N64WKkxcNvpk1M7+hhNoposx+aYCg@mail.gmail.com
