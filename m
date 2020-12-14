Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8E2D92EA
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 06:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbgLNFpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 00:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388095AbgLNFpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 00:45:08 -0500
Date:   Sun, 13 Dec 2020 23:44:19 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607924661;
        bh=DJCa3Ep1fE3q8qoPvFOhLjfQOS2mVOH2C7wn1utTy9E=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=HFB9xptksT6CmLOqPTwEzxhWM26CBSrGKa9xOWeiBUGY9uQfpfdHb4B1v57WZcz9U
         jhDet5B8MEI10Kq4OTXrktR3yS3QK/J9Lrzl8Ai+bH39JTUvwdOuvIb+zijL5G7WCq
         RH1ricN+sFFOXXe5LLz1GlTDlTcDtOFl4MBJQi81eABv02YZGjb5mdkc+z5hLijfSs
         L2XOqQZspNXj/zUv0momGSNbQ8J9dtD6szRiGt0bfMghnilMbSXUf50lwdHUGHHhLQ
         //XKHTzA3/1SXHoaLOeHIVckxEj+N3oIIcEcRb1mjEA3jqd3UoWSvEXhoJ3LEQk5Kf
         GXxY9Ox7Bcndw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI/ASPM: Use the path max in L1 ASPM latency check
Message-ID: <20201214054419.GA185506@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA85sZuuS=UHzhk0DabN45jCu-GYD-DxMOY8dd68Znnk5wsXVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Jesse, Tony, David, Jakub, Heiner, lists in case there's an ASPM
issue with I211 or Realtek NICs.  Beginning of thread:
https://lore.kernel.org/r/20201024205548.1837770-1-ian.kumlien@gmail.com

Short story: Ian has:

  Root Port --- Switch --- I211 NIC
                       \-- multifunction Realtek NIC, etc

and the I211 performance is poor with ASPM L1 enabled on both links
in the path to it.  The patch here disables ASPM on the upstream link
and fixes the performance, but AFAICT the devices in that path give us
no reason to disable L1.  If I understand the spec correctly, the
Realtek device should not be relevant to the I211 path.]

On Sun, Dec 13, 2020 at 10:39:53PM +0100, Ian Kumlien wrote:
> On Sun, Dec 13, 2020 at 12:47 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Sat, Oct 24, 2020 at 10:55:46PM +0200, Ian Kumlien wrote:
> > > Make pcie_aspm_check_latency comply with the PCIe spec, specifically:
> > > "5.4.1.2.2. Exit from the L1 State"
> > >
> > > Which makes it clear that each switch is required to initiate a
> > > transition within 1μs from receiving it, accumulating this latency and
> > > then we have to wait for the slowest link along the path before
> > > entering L0 state from L1.
> > > ...
> >
> > > On my specific system:
> > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network Connection (rev 03)
> > > 04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device 816e (rev 1a)
> > >
> > >             Exit latency       Acceptable latency
> > > Tree:       L1       L0s       L1       L0s
> > > ----------  -------  -----     -------  ------
> > > 00:01.2     <32 us   -
> > > | 01:00.0   <32 us   -
> > > |- 02:03.0  <32 us   -
> > > | \03:00.0  <16 us   <2us      <64 us   <512ns
> > > |
> > > \- 02:04.0  <32 us   -
> > >   \04:00.0  <64 us   unlimited <64 us   <512ns
> > >
> > > 04:00.0's latency is the same as the maximum it allows so as we walk the path
> > > the first switchs startup latency will pass the acceptable latency limit
> > > for the link, and as a side-effect it fixes my issues with 03:00.0.
> > >
> > > Without this patch, 03:00.0 misbehaves and only gives me ~40 mbit/s over
> > > links with 6 or more hops. With this patch I'm back to a maximum of ~933
> > > mbit/s.
> >
> > There are two paths here that share a Link:
> >
> >   00:01.2 --- 01:00.0 -- 02:03.0 --- 03:00.0 I211 NIC
> >   00:01.2 --- 01:00.0 -- 02:04.0 --- 04:00.x multifunction Realtek
> >
> > 1) The path to the I211 NIC includes four Ports and two Links (the
> >    connection between 01:00.0 and 02:03.0 is internal Switch routing,
> >    not a Link).
> 
> >    The Ports advertise L1 exit latencies of <32us, <32us, <32us,
> >    <16us.  If both Links are in L1 and 03:00.0 initiates L1 exit at T,
> >    01:00.0 initiates L1 exit at T + 1.  A TLP from 03:00.0 may see up
> >    to 1 + 32 = 33us of L1 exit latency.
> >
> >    The NIC can tolerate up to 64us of L1 exit latency, so it is safe
> >    to enable L1 for both Links.
> >
> > 2) The path to the Realtek device is similar except that the Realtek
> >    L1 exit latency is <64us.  If both Links are in L1 and 04:00.x
> >    initiates L1 exit at T, 01:00.0 again initiates L1 exit at T + 1,
> >    but a TLP from 04:00.x may see up to 1 + 64 = 65us of L1 exit
> >    latency.
> >
> >    The Realtek device can only tolerate 64us of latency, so it is not
> >    safe to enable L1 for both Links.  It should be safe to enable L1
> >    on the shared link because the exit latency for that link would be
> >    <32us.
> 
> 04:00.0:
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
> LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
> unlimited, L1 <64us
> 
> So maximum latency for the entire link has to be <64 us
> For the device to leave L1 ASPM takes <64us
> 
> So the device itself is the slowest entry along the link, which
> means that nothing else along that path can have ASPM enabled

Yes.  That's what I said above: "it is not safe to enable L1 for both
Links."  Unless I'm missing something, we agree on that.

I also said that it should be safe to enable L1 on the shared Link
(from 00:01.2 to 01:00.0) because if the downstream Link is always in
L0, the exit latency of the shared Link should be <32us, and 04:00.x
can tolerate 64us.

> > > The original code path did:
> > > 04:00:0-02:04.0 max latency 64    -> ok
> > > 02:04.0-01:00.0 max latency 32 +1 -> ok
> > > 01:00.0-00:01.2 max latency 32 +2 -> ok
> > >
> > > And thus didn't see any L1 ASPM latency issues.
> > >
> > > The new code does:
> > > 04:00:0-02:04.0 max latency 64    -> ok
> > > 02:04.0-01:00.0 max latency 64 +1 -> latency exceeded
> > > 01:00.0-00:01.2 max latency 64 +2 -> latency exceeded
> >
> > [Nit: I don't think we should add 1 for the 02:04.0 -- 01:00.0 piece
> > because that's internal Switch routing, not a Link.  But even without
> > that extra microsecond, this path does exceed the acceptable latency
> > since 1 + 64 = 65us, and 04:00.0 can only tolerate 64us.]
> 
> It does report L1 ASPM on both ends, so the links will be counted as
> such in the code.

This is a bit of a tangent and we shouldn't get too wrapped up in it.
This is a confusing aspect of PCIe.  We're talking about this path:

  00:01.2 --- [01:00.0 -- 02:04.0] --- 04:00.x multifunction Realtek

This path only contains two Links.  The first one is 
00:01.2 --- 01:00.0, and the second one is 02:04.0 --- 04:00.x.

01:00.0 is a Switch Upstream Port and 02:04.0 is a Switch Downstream
Port.  The connection between them is not a Link; it is some internal
wiring of the Switch that is completely opaque to software.

The ASPM information and knobs in 01:00.0 apply to the Link on its
upstream side, and the ASPM info and knobs in 02:04.0 apply to the
Link on its downstream side.

The example in sec 5.4.1.2.2 contains three Links.  The L1 exit latency
for the Link is the max of the exit latencies at each end:

  Link 1: max(32, 8) = 32us
  Link 2: max(8, 32) = 32us
  Link 3: max(32, 8) = 32us

The total delay for a TLP starting at the downstream end of Link 3
is 32 + 2 = 32us.

In the path to your 04:00.x Realtek device:

  Link 1 (from 00:01.2 to 01:00.0): max(32, 32) = 32us
  Link 2 (from 02:04.0 to 04:00.x): max(32, 64) = 64us

If L1 were enabled on both Links, the exit latency would be 64 + 1 =
65us.

> I also assume that it can power down individual ports... and enter
> rest state if no links are up.

I don't think this is quite true -- a Link can't enter L1 unless the
Ports on both ends have L1 enabled, so I don't think it makes sense to
talk about an individual Port being in L1.

> > > It correctly identifies the issue.
> > >
> > > For reference, pcie information:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=209725
> >
> > The "lspci without my patches" [1] shows L1 enabled for the shared
> > Link from 00:01.2 --- 01:00.0 and for the Link to 03:00.0 (I211), but
> > not for the Link to 04:00.x (Realtek).
> >
> > Per my analysis above, that looks like it *should* be a safe
> > configuration.  03:00.0 can tolerate 64us, actual is <33us.  04:00.0
> > can tolerate 64us, actual should be <32us since only the shared Link
> > is in L1.
> 
> See above.

As I said above, if we enabled L1 only on the shared Link from 00:01.2
to 01:00.0, the exit latency should be acceptable.  In that case, a
TLP from 04:00.x would see only 32us of latency:

  Link 1 (from 00:01.2 to 01:00.0): max(32, 32) = 32us

and 04:00.x can tolerate 64us.

> > However, the commit log at [2] shows L1 *enabled* for both the shared
> > Link from 00:01.2 --- 01:00.0 and the 02:04.0 --- 04:00.x Link, and
> > that would definitely be a problem.
> >
> > Can you explain the differences between [1] and [2]?
> 
> I don't understand which sections you're referring to.

[1] is the "lspci without my patches" attachment of bugzilla #209725,
which is supposed to show the problem this patch solves.  We're
talking about the path to 04:00.x, and [1] show this:

  01:00.2 L1+
  01:00.0 L1+
  02:04.0 L1-
  04:00.0 L1-

AFAICT, that should be a legal configuration as far as 04:00.0 is
concerned, so it's not a reason for this patch.

[2] is a previous posting of this same patch, and its commit log
includes information about the same path to 04:00.x, but the "LnkCtl
Before" column shows:

  01:00.2 L1+
  01:00.0 L1+
  02:04.0 L1+
  04:00.0 L1+

I don't know why [1] shows L1 disabled on the downstream Link, while
[2] shows L1 *enabled* on the same Link.

> > > Kai-Heng Feng has a machine that will not boot with ASPM without
> > > this patch, information is documented here:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=209671
> >
> > I started working through this info, too, but there's not enough
> > information to tell what difference this patch makes.  The attachments
> > compare:
> >
> >   1) CONFIG_PCIEASPM_DEFAULT=y without the patch [3] and
> >   2) CONFIG_PCIEASPM_POWERSAVE=y *with* the patch [4]
> >
> > Obviously CONFIG_PCIEASPM_POWERSAVE=y will configure things
> > differently than CONFIG_PCIEASPM_DEFAULT=y, so we can't tell what
> > changes are due to the config change and what are due to the patch.
> >
> > The lspci *with* the patch ([4]) shows L0s and L1 enabled at almost
> > every possible place.  Here are the Links, how they're configured, and
> > my analysis of the exit latencies vs acceptable latencies:
> >
> >   00:01.1 --- 01:00.0      L1+ (                  L1 <64us vs unl)
> >   00:01.2 --- 02:00.0      L1+ (                  L1 <64us vs 64us)
> >   00:01.3 --- 03:00.0      L1+ (                  L1 <64us vs 64us)
> >   00:01.4 --- 04:00.0      L1+ (                  L1 <64us vs unl)
> >   00:08.1 --- 05:00.x L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs unl)
> >   00:08.2 --- 06:00.0 L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs unl)
> >
> > So I can't tell what change prevents the freeze.  I would expect the
> > patch would cause us to *disable* L0s or L1 somewhere.
> >
> > The only place [4] shows ASPM disabled is for 05:00.1.  The spec says
> > we should program the same value in all functions of a multi-function
> > device.  This is a non-ARI device, so "only capabilities enabled in
> > all functions are enabled for the component as a whole."  That would
> > mean that L0s and L1 are effectively disabled for 05:00.x even though
> > 05:00.0 claims they're enabled.  But the latencies say ASPM L0s and L1
> > should be safe to be enabled.  This looks like another bug that's
> > probably unrelated.
> 
> I don't think it's unrelated, i suspect it's how PCIe works with
> multiple links...  a device can cause some kind of head of queue
> stalling - i don't know how but it really looks like it.

The text in quotes above is straight out of the spec (PCIe r5.0, sec
7.5.3.7).  Either the device works that way or it's not compliant.

The OS configures ASPM based on the requirements and capabilities
advertised by the device.  If a device has any head of queue stalling
or similar issues, those must be comprehended in the numbers
advertised by the device.  It's not up to the OS to speculate about
issues like that.

> > The patch might be correct; I haven't actually analyzed the code.  But
> > the commit log doesn't make sense to me yet.
> 
> I personally don't think that all this PCI information is required,
> the linux kernel is currently doing it wrong according to the spec.

We're trying to establish exactly *what* Linux is doing wrong.  So far
we don't have a good explanation of that.

Based on [1], in the path to 03:00.0, both Links have L1 enabled, with
an exit latency of <33us, and 03:00.0 can tolerate 64us.  That should
work fine.

Also based on [1], in the path to 04:00.x, the upstream Link has L1
enabled and the downstream Link has L1 disabled, for an exit latency
of <32us, and 04:00.0 can tolerate 64us.  That should also work fine.

(Alternately, disabling L1 on the upstream Link and enabling it on the
downstream Link should have an exit latency of <64us and 04:00.0 can
tolerate 64us, so that should work fine, too.)

> Also, since it's clearly doing the wrong thing, I'm worried that
> dists will take a kernel enable aspm and there will be alot of
> bugreports of non-booting systems or other weird issues... And the
> culprit was known all along.

There's clearly a problem on your system, but I don't know yet whether
Linux is doing something wrong, a device in your system is designed
incorrectly, or a device is designed correctly but the instance in
your system is defective.

> It's been five months...

I apologize for the delay.  ASPM is a subtle area of PCIe, the Linux
code is complicated, and we have a long history of issues with it.  I
want to fix the problem, but I want to make sure we do it in a way
that matches the spec so the fix applies to all systems.  I don't want
a magic fix that fixes your system in a way I don't quite understand.

Obviously *you* understand this, so hopefully it's just a matter of
pounding it through my thick skull :)

> > [1] https://bugzilla.kernel.org/attachment.cgi?id=293047
> > [2] https://lore.kernel.org/linux-pci/20201007132808.647589-1-ian.kumlien@gmail.com/
> > [3] https://bugzilla.kernel.org/attachment.cgi?id=292955
> > [4] https://bugzilla.kernel.org/attachment.cgi?id=292957
> >
> > > Signed-off-by: Ian Kumlien <ian.kumlien@gmail.com>
> > > Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > ---
> > >  drivers/pci/pcie/aspm.c | 22 ++++++++++++++--------
> > >  1 file changed, 14 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > > index 253c30cc1967..c03ead0f1013 100644
> > > --- a/drivers/pci/pcie/aspm.c
> > > +++ b/drivers/pci/pcie/aspm.c
> > > @@ -434,7 +434,7 @@ static void pcie_get_aspm_reg(struct pci_dev *pdev,
> > >
> > >  static void pcie_aspm_check_latency(struct pci_dev *endpoint)
> > >  {
> > > -     u32 latency, l1_switch_latency = 0;
> > > +     u32 latency, l1_max_latency = 0, l1_switch_latency = 0;
> > >       struct aspm_latency *acceptable;
> > >       struct pcie_link_state *link;
> > >
> > > @@ -456,10 +456,14 @@ static void pcie_aspm_check_latency(struct pci_dev *endpoint)
> > >               if ((link->aspm_capable & ASPM_STATE_L0S_DW) &&
> > >                   (link->latency_dw.l0s > acceptable->l0s))
> > >                       link->aspm_capable &= ~ASPM_STATE_L0S_DW;
> > > +
> > >               /*
> > >                * Check L1 latency.
> > > -              * Every switch on the path to root complex need 1
> > > -              * more microsecond for L1. Spec doesn't mention L0s.
> > > +              *
> > > +              * PCIe r5.0, sec 5.4.1.2.2 states:
> > > +              * A Switch is required to initiate an L1 exit transition on its
> > > +              * Upstream Port Link after no more than 1 μs from the beginning of an
> > > +              * L1 exit transition on any of its Downstream Port Links.
> > >                *
> > >                * The exit latencies for L1 substates are not advertised
> > >                * by a device.  Since the spec also doesn't mention a way
> > > @@ -469,11 +473,13 @@ static void pcie_aspm_check_latency(struct pci_dev *endpoint)
> > >                * L1 exit latencies advertised by a device include L1
> > >                * substate latencies (and hence do not do any check).
> > >                */
> > > -             latency = max_t(u32, link->latency_up.l1, link->latency_dw.l1);
> > > -             if ((link->aspm_capable & ASPM_STATE_L1) &&
> > > -                 (latency + l1_switch_latency > acceptable->l1))
> > > -                     link->aspm_capable &= ~ASPM_STATE_L1;
> > > -             l1_switch_latency += 1000;
> > > +             if (link->aspm_capable & ASPM_STATE_L1) {
> > > +                     latency = max_t(u32, link->latency_up.l1, link->latency_dw.l1);
> > > +                     l1_max_latency = max_t(u32, latency, l1_max_latency);
> > > +                     if (l1_max_latency + l1_switch_latency > acceptable->l1)
> > > +                             link->aspm_capable &= ~ASPM_STATE_L1;
> > > +                     l1_switch_latency += 1000;
> > > +             }
> > >
> > >               link = link->parent;
> > >       }
> > > --
> > > 2.29.1
> > >
