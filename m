Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D77314DC5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhBILCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:02:33 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:59770 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhBIK7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:59:55 -0500
Date:   Tue, 9 Feb 2021 13:59:06 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/24] net: stmmac: Fix clocks/reset-related procedures
Message-ID: <20210209105906.t34g6wly3ilndkwq@mobilestation>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208110521.59804f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210208110521.59804f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 11:05:21AM -0800, Jakub Kicinski wrote:
> On Mon, 8 Feb 2021 16:55:44 +0300 Serge Semin wrote:
> > Baikal-T1 SoC is equipped with two Synopsys DesignWare GMAC v3.73a-based
> > ethernet interfaces with no internal Ethernet PHY attached. The IP-cores
> > are configured as GMAC-AXI with CSR interface clocked by a dedicated
> > signal. Each of which has got Rx/Tx FIFOs of 16KB, up to 8 MAC addresses
> > capability, no embedded filter hash table logic, EEE enabled, IEEE 1588
> > and 1588-2008 Advanced timestamping capabilities, power management with
> > remote wake-up, IP CSUM hardware acceleration, a single PHY interface -
> > RGMII with MDIO bus, 1xGPI and 1xGPO.
> > 
> > This is a very first series of patches with fixes we've found to be
> > required in order to make things working well for our setup. The series
> > has turned to be rather large, but most of the patches are trivial and
> > some of them are just cleanups, so it shouldn't be that hard to review.
> 
> Hi Serge!
> 
> You've submitted 60 patches at once, that's a lot of patches, in netdev
> we limit submissions to 15 patches at a time to avoid overwhelming
> reviewers. 
> 
> At a glance the patches seem to mix fixes which affect existing,
> supported systems (eg. error patch reference leaks) with extensions
> required to support your platform. Can the two be separated?
> The fixes for existing bugs should be targeting net (Subject: 
> [PATCH net]) and patches to support your platform net-next (Subject:
> [PATCH net-next]).
> 
> Right now the patches are not tagged so our build bot tried applying
> them to net-next and they failed to apply, so I need to toss them away.
> 
> Andrew, others, please chime in if I'm misreading the contents of the
> series or if you have additional guidance!

Hi Jakub,
Of course I know about the "too-big-series-to-review" rule. That's why I've
split all my work up into three patchsets. Actually this one is the very
first patchset, which I've submitted over two months ago but noone except
Rob gave me any review comment. So I've decided to post all the work,
to so called depict a scale of the work, which needs to be reviewed.

Anyway I thought it would be obvious from the cover-letters which patchsets
should be applied first, which next. This one states that it's a very
first series. The rest of the patchsets contains a link to the
previous one they were supposed to be applied to. Perhaps I should have
stated that in a clearer way.

Regarding having over 15 patches in this series. Normally it's not that
strict rule. There are even bigger series can be found submitted,
reviewed and accepted in the kernel. Of course sometimes it's hard to
review even 15 patches due to complexity of the changes. But most of
the alterations posted here are trivial and shouldn't be difficult to
review. That's why I felt free to post it as is.

Of course I agree with you. It would be too much to review over 60
patches at once. Let's review one series at a time then. This one is
the very first one. Please start with it.

Regarding splitting this series up. Well, normally there is no such
requirement to split the fixes and feature into different series.
(Though I am not surprised to get such request from net-subsystem. You
always prefer to do things in your special way. ^_^) So in this series
the fixes have been structured together and have been submitted first
in the order, but after DT-bindings related patches. Anyway if you
want it, I'll split the patchset up into two. The first one will be
targeted to "net" and will have all the fixes. The second one will
contain the bindings-related modifications and the clocks-related feature
implementation. It will be sent to net-next. I'll do that in v2. But
at the current stage could you start reviewing this series the way
it is? I'll take into account your comments and add your tags in the
split v2 patchsets if any.

Thanks
-Sergey

