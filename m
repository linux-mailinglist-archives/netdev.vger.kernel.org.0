Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BAC3F35D9
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbhHTVDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhHTVDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 17:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABC6C6103B;
        Fri, 20 Aug 2021 21:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629493391;
        bh=VwThOwWPE5ah7M2RNMlkuI70PYe8BX7MFqiL2p7+V4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=IL7alGUYy94QHWEfVdL9LwHa/8uQQOAUeDkP6l+STRyktqrTuM6aZwmW6ZT/vWyg2
         71QbZqQwn/nCJhn8SV4O5+S51qNU3vaHIs+Nb0Wu3n5+T8ZZ0MHVVegsFdTvtPR4V9
         r7UyhWKwJjVpv03y2qiGddGRDbA0BDinKfcCpFfBu8zbo5sMrAP+bgzcmQKH1FgbQK
         fv+J8NV0xxIPgA4WMPEft8LPhib8t0obfWAdNT4m4/wHYlEUE+7hoA1s9FKbx6w18R
         nyvYuRVjp198nEV/a1lwAZjAkLNuqk61A4I7vGbeaQSDt2JRqhPmk/mZdBhS8ooMdg
         C/z/pFEAatw2A==
Date:   Fri, 20 Aug 2021 16:03:09 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
Message-ID: <20210820210309.GA3357515@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ebf8fa1-cbd4-75d6-1099-1a45ca8b8bb0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 05:45:22PM +0200, Heiner Kallweit wrote:
> On 19.08.2021 13:42, Bjorn Helgaas wrote:
> > On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
> >> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> >> Same issue can be observed with older vendor drivers.
> > 
> > On some platforms but not on others?  Maybe the PCIe topology is a
> > factor?  Do you have bug reports with data, e.g., "lspci -vv" output?
> > 
> >> The issue is however solved by the latest vendor driver. There's a new
> >> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> >> more than 10 packets, and vice versa. 
> > 
> > Presumably there's a time interval related to the 10 packets?  For
> > example, do you want to disable ASPM if 10 packets are received (or
> > sent?) in a certain amount of time?
> > 
> >> The possible reason for this is
> >> likely because the buffer on the chip is too small for its ASPM exit
> >> latency.
> > 
> > Maybe this means the chip advertises incorrect exit latencies?  If so,
> > maybe a quirk could override that?
> > 
> >> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> >> use dynamic ASPM under Windows. So implement the same mechanism here to
> >> resolve the issue.
> > 
> > What exactly is "dynamic ASPM"?
> > 
> > I see Heiner's comment about this being intended only for a downstream
> > kernel.  But why?
> > 
> We've seen various more or less obvious symptoms caused by the broken
> ASPM support on Realtek network chips. Unfortunately Realtek releases
> neither datasheets nor errata information.
> Last time we attempted to re-enable ASPM numerous problem reports came
> in. These Realtek chips are used on basically every consumer mainboard.
> The proposed workaround has potential side effects: In case of a
> congestion in the chip it may take up to a second until ASPM gets
> disabled, what may affect performance, especially in case of alternating
> traffic patterns. Also we can't expect support from Realtek.
> Having said that my decision was that it's too risky to re-enable ASPM
> in mainline even with this workaround in place. Kai-Heng weights the
> power saving higher and wants to take the risk in his downstream kernel.
> If there are no problems downstream after few months, then this
> workaround may make it to mainline.

Since ASPM apparently works well on some platforms but not others, I'd
suspect some incorrect exit latencies.

Ideally we'd have some launchpad/bugzilla links, and a better
understanding of the problem, and maybe a quirk that makes this work
on all platforms without mucking up the driver with ASPM tweaks.

But I'm a little out of turn here because the only direct impact to
the PCI core is the pcie_aspm_supported() interface.  It *looks* like
these patches don't actually touch the PCIe architected ASPM controls
in Link Control; all I see is mucking with Realtek-specific registers.

I think this is more work than it should be and likely to be not as
reliable as it should be.  But I guess that's up to you guys.

Bjorn
