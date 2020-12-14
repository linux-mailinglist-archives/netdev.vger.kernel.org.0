Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74BC2D9B6A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438907AbgLNPs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729628AbgLNPsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:48:25 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CACDC061793;
        Mon, 14 Dec 2020 07:47:45 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id h16so3568275qvu.8;
        Mon, 14 Dec 2020 07:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IvP98dDrq1/PKtiH7hCEfLKCy7yk+zANVEOxxRPRQmc=;
        b=rSYnI2+lzpyzp7Deqn7Slc1nwxCRR2SLTDOXfmcH4ObrdVtnOLmTrlw99zKKZ/svQ+
         zXfNR4EsXdYrhkFk8xVcv7u/rVp5riMWlUdEaYPTjYDfbAPzmVj2Ix8JacYIOfn8O0m4
         nO+RxT0gnRQ78Hnh80fKv9Qrh3aId8Ib0LYsWt75Np33WMFFiDJ9DhdrjHxBHrGeYxDR
         UQSRA3H98c/+x1aKEwj79DKWkZP6V6gTYfLClfvJkGmam0daArLG0qYVCOlziSl0m0r+
         fcrsOGOJJxl/n3BZmpdnb5w0esxZUk/4QGeEYI5oFICLqZAYy9OuX7JDtdfVgJY8Ynqh
         yWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IvP98dDrq1/PKtiH7hCEfLKCy7yk+zANVEOxxRPRQmc=;
        b=IstgpDCPccJhPrq5z5cU458Lv/d2pp51KPxGr9+nub8dGF72zmMdjQ24RhmnsWJBu6
         UnSfpZhlVe9Mkd36Oyk9b1kWnb4w4fFPis3MKWP8+ib1O+CbsLUWD2i35QrK2gtpPZ/n
         DzLfIGLSCKn2Dx3EIEg5b0EMFTYyEiBa9+w6PvzPFO4zdqZL0nKMKNB/p/0EDM6qbuJu
         1M5xPsbgZvxYbNecTgQuIM2fcL3Zx3iuMd+h0DrxbWvYjLZYdLYW5hz3atnDutxU6qEX
         7yeGN2LBepkZOoSpXnmMtVHe2pVm4M8M4RqJauUuWoOuEDuoLqChV/XemjYuZcva4q0F
         GeDw==
X-Gm-Message-State: AOAM530eLw3u/Uck7gnMrT35VW5ADxXdBjyoUmGVEs/RgfbBK44TAixi
        yORq8RP1jGtGqD2kbJxwtKipYpzUCIAc7n+WlY8=
X-Google-Smtp-Source: ABdhPJx7+hNLRfCiJ78tz962L+w32S1uHhD3fyeFjU5tCEc1g8GKaxbrCb/kqziiSuWb4w8V1ZF0U7wuWWqamLJzpF8=
X-Received: by 2002:a0c:c1cd:: with SMTP id v13mr31694711qvh.3.1607960863795;
 Mon, 14 Dec 2020 07:47:43 -0800 (PST)
MIME-Version: 1.0
References: <CAA85sZvw1s-8CTCt5H_OjW-Q821LSzQOmJyyGYdKHfsDS2Z29A@mail.gmail.com>
 <20201214140222.GA202497@bjorn-Precision-5520>
In-Reply-To: <20201214140222.GA202497@bjorn-Precision-5520>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Mon, 14 Dec 2020 16:47:32 +0100
Message-ID: <CAA85sZuG2TbTjOAJ1TRhCbsZ2HRhUzD48b+SQ9JuAmW9gUm_dA@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI/ASPM: Use the path max in L1 ASPM latency check
To:     Bjorn Helgaas <helgaas@kernel.org>
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
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 3:02 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 10:14:18AM +0100, Ian Kumlien wrote:
> > On Mon, Dec 14, 2020 at 6:44 AM Bjorn Helgaas <helgaas@kernel.org> wrot=
e:
> > >
> > > [+cc Jesse, Tony, David, Jakub, Heiner, lists in case there's an ASPM
> > > issue with I211 or Realtek NICs.  Beginning of thread:
> > > https://lore.kernel.org/r/20201024205548.1837770-1-ian.kumlien@gmail.=
com
> > >
> > > Short story: Ian has:
> > >
> > >   Root Port --- Switch --- I211 NIC
> > >                        \-- multifunction Realtek NIC, etc
> > >
> > > and the I211 performance is poor with ASPM L1 enabled on both links
> > > in the path to it.  The patch here disables ASPM on the upstream link
> > > and fixes the performance, but AFAICT the devices in that path give u=
s
> > > no reason to disable L1.  If I understand the spec correctly, the
> > > Realtek device should not be relevant to the I211 path.]
> > >
> > > On Sun, Dec 13, 2020 at 10:39:53PM +0100, Ian Kumlien wrote:
> > > > On Sun, Dec 13, 2020 at 12:47 AM Bjorn Helgaas <helgaas@kernel.org>=
 wrote:
> > > > > On Sat, Oct 24, 2020 at 10:55:46PM +0200, Ian Kumlien wrote:
> > > > > > Make pcie_aspm_check_latency comply with the PCIe spec, specifi=
cally:
> > > > > > "5.4.1.2.2. Exit from the L1 State"
> > > > > >
> > > > > > Which makes it clear that each switch is required to
> > > > > > initiate a transition within 1=CE=BCs from receiving it,
> > > > > > accumulating this latency and then we have to wait for the
> > > > > > slowest link along the path before entering L0 state from
> > > > > > L1.
> > > > > > ...
> > > > >
> > > > > > On my specific system:
> > > > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Net=
work Connection (rev 03)
> > > > > > 04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd=
. Device 816e (rev 1a)
> > > > > >
> > > > > >             Exit latency       Acceptable latency
> > > > > > Tree:       L1       L0s       L1       L0s
> > > > > > ----------  -------  -----     -------  ------
> > > > > > 00:01.2     <32 us   -
> > > > > > | 01:00.0   <32 us   -
> > > > > > |- 02:03.0  <32 us   -
> > > > > > | \03:00.0  <16 us   <2us      <64 us   <512ns
> > > > > > |
> > > > > > \- 02:04.0  <32 us   -
> > > > > >   \04:00.0  <64 us   unlimited <64 us   <512ns
> > > > > >
> > > > > > 04:00.0's latency is the same as the maximum it allows so as
> > > > > > we walk the path the first switchs startup latency will pass
> > > > > > the acceptable latency limit for the link, and as a
> > > > > > side-effect it fixes my issues with 03:00.0.
> > > > > >
> > > > > > Without this patch, 03:00.0 misbehaves and only gives me ~40
> > > > > > mbit/s over links with 6 or more hops. With this patch I'm
> > > > > > back to a maximum of ~933 mbit/s.
> > > > >
> > > > > There are two paths here that share a Link:
> > > > >
> > > > >   00:01.2 --- 01:00.0 -- 02:03.0 --- 03:00.0 I211 NIC
> > > > >   00:01.2 --- 01:00.0 -- 02:04.0 --- 04:00.x multifunction Realte=
k
> > > > >
> > > > > 1) The path to the I211 NIC includes four Ports and two Links (th=
e
> > > > >    connection between 01:00.0 and 02:03.0 is internal Switch rout=
ing,
> > > > >    not a Link).
> > > >
> > > > >    The Ports advertise L1 exit latencies of <32us, <32us, <32us,
> > > > >    <16us.  If both Links are in L1 and 03:00.0 initiates L1 exit =
at T,
> > > > >    01:00.0 initiates L1 exit at T + 1.  A TLP from 03:00.0 may se=
e up
> > > > >    to 1 + 32 =3D 33us of L1 exit latency.
> > > > >
> > > > >    The NIC can tolerate up to 64us of L1 exit latency, so it is s=
afe
> > > > >    to enable L1 for both Links.
> > > > >
> > > > > 2) The path to the Realtek device is similar except that the Real=
tek
> > > > >    L1 exit latency is <64us.  If both Links are in L1 and 04:00.x
> > > > >    initiates L1 exit at T, 01:00.0 again initiates L1 exit at T +=
 1,
> > > > >    but a TLP from 04:00.x may see up to 1 + 64 =3D 65us of L1 exi=
t
> > > > >    latency.
> > > > >
> > > > >    The Realtek device can only tolerate 64us of latency, so it is=
 not
> > > > >    safe to enable L1 for both Links.  It should be safe to enable=
 L1
> > > > >    on the shared link because the exit latency for that link woul=
d be
> > > > >    <32us.
> > > >
> > > > 04:00.0:
> > > > DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <=
64us
> > > > LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L=
0s
> > > > unlimited, L1 <64us
> > > >
> > > > So maximum latency for the entire link has to be <64 us
> > > > For the device to leave L1 ASPM takes <64us
> > > >
> > > > So the device itself is the slowest entry along the link, which
> > > > means that nothing else along that path can have ASPM enabled
> > >
> > > Yes.  That's what I said above: "it is not safe to enable L1 for both
> > > Links."  Unless I'm missing something, we agree on that.
> > >
> > > I also said that it should be safe to enable L1 on the shared Link
> > > (from 00:01.2 to 01:00.0) because if the downstream Link is always in
> > > L0, the exit latency of the shared Link should be <32us, and 04:00.x
> > > can tolerate 64us.
> >
> > Exit latency of shared link would be max of link, ie 64 + L1-hops, not =
32
>
> I don't think this is true.  The path from 00:01.2 to 04:00.x includes
> two Links, and they are independent.  The exit latency for each Link
> depends only on the Port at each end:

The full path is what is important, because that is the actual latency
(which the current linux code doesn't do)

>   Link 1 (depends on 00:01.2 and 01:00.0): max(32, 32) =3D 32us
>   Link 2 (depends on 02:04.0 and 04:00.x): max(32, 64) =3D 64us
>
> If L1 is enabled for Link 1 and disabled for Link 2, Link 2 will
> remain in L0 so it has no L1 exit latency, and the exit latency of
> the entire path should be 32us.

My patch disables this so yes.

> > > > > > The original code path did:
> > > > > > 04:00:0-02:04.0 max latency 64    -> ok
> > > > > > 02:04.0-01:00.0 max latency 32 +1 -> ok
> > > > > > 01:00.0-00:01.2 max latency 32 +2 -> ok
> > > > > >
> > > > > > And thus didn't see any L1 ASPM latency issues.
> > > > > >
> > > > > > The new code does:
> > > > > > 04:00:0-02:04.0 max latency 64    -> ok
> > > > > > 02:04.0-01:00.0 max latency 64 +1 -> latency exceeded
> > > > > > 01:00.0-00:01.2 max latency 64 +2 -> latency exceeded
> > > > >
> > > > > [Nit: I don't think we should add 1 for the 02:04.0 -- 01:00.0 pi=
ece
> > > > > because that's internal Switch routing, not a Link.  But even wit=
hout
> > > > > that extra microsecond, this path does exceed the acceptable late=
ncy
> > > > > since 1 + 64 =3D 65us, and 04:00.0 can only tolerate 64us.]
> > > >
> > > > It does report L1 ASPM on both ends, so the links will be counted a=
s
> > > > such in the code.
> > >
> > > This is a bit of a tangent and we shouldn't get too wrapped up in it.
> > > This is a confusing aspect of PCIe.  We're talking about this path:
> > >
> > >   00:01.2 --- [01:00.0 -- 02:04.0] --- 04:00.x multifunction Realtek
> > >
> > > This path only contains two Links.  The first one is
> > > 00:01.2 --- 01:00.0, and the second one is 02:04.0 --- 04:00.x.
> > >
> > > 01:00.0 is a Switch Upstream Port and 02:04.0 is a Switch Downstream
> > > Port.  The connection between them is not a Link; it is some internal
> > > wiring of the Switch that is completely opaque to software.
> > >
> > > The ASPM information and knobs in 01:00.0 apply to the Link on its
> > > upstream side, and the ASPM info and knobs in 02:04.0 apply to the
> > > Link on its downstream side.
> > >
> > > The example in sec 5.4.1.2.2 contains three Links.  The L1 exit laten=
cy
> > > for the Link is the max of the exit latencies at each end:
> > >
> > >   Link 1: max(32, 8) =3D 32us
> > >   Link 2: max(8, 32) =3D 32us
> > >   Link 3: max(32, 8) =3D 32us
> > >
> > > The total delay for a TLP starting at the downstream end of Link 3
> > > is 32 + 2 =3D 32us.
> > >
> > > In the path to your 04:00.x Realtek device:
> > >
> > >   Link 1 (from 00:01.2 to 01:00.0): max(32, 32) =3D 32us
> > >   Link 2 (from 02:04.0 to 04:00.x): max(32, 64) =3D 64us
> > >
> > > If L1 were enabled on both Links, the exit latency would be 64 + 1 =
=3D
> > > 65us.
> >
> > So one line to be removed from the changelog, i assume... And yes, the
> > code handles that - first disable is 01:00.0 <-> 00:01.2
> >
> > > > I also assume that it can power down individual ports... and enter
> > > > rest state if no links are up.
> > >
> > > I don't think this is quite true -- a Link can't enter L1 unless the
> > > Ports on both ends have L1 enabled, so I don't think it makes sense t=
o
> > > talk about an individual Port being in L1.
> > >
> > > > > > It correctly identifies the issue.
> > > > > >
> > > > > > For reference, pcie information:
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D209725
> > > > >
> > > > > The "lspci without my patches" [1] shows L1 enabled for the share=
d
> > > > > Link from 00:01.2 --- 01:00.0 and for the Link to 03:00.0 (I211),=
 but
> > > > > not for the Link to 04:00.x (Realtek).
> > > > >
> > > > > Per my analysis above, that looks like it *should* be a safe
> > > > > configuration.  03:00.0 can tolerate 64us, actual is <33us.  04:0=
0.0
> > > > > can tolerate 64us, actual should be <32us since only the shared L=
ink
> > > > > is in L1.
> > > >
> > > > See above.
> > >
> > > As I said above, if we enabled L1 only on the shared Link from 00:01.=
2
> > > to 01:00.0, the exit latency should be acceptable.  In that case, a
> > > TLP from 04:00.x would see only 32us of latency:
> > >
> > >   Link 1 (from 00:01.2 to 01:00.0): max(32, 32) =3D 32us
> > >
> > > and 04:00.x can tolerate 64us.
> >
> > But, again, you're completely ignoring the full link, ie 04:00.x would
> > also have to power on.
>
> I think you're using "the full link" to refer to the entire path from
> 00:01.2 to 04:00.x.  In PCIe, a "Link" directly connects two Ports.
> It doesn't refer to the entire path.
>
> No, if L1 is disabled on 02:04.0 and 04:00.x (as Linux apparently does
> by default), the Link between them never enters L1, so there is no
> power-on for this Link.

It doesn't do it by default, my patch does

> > > > > However, the commit log at [2] shows L1 *enabled* for both the sh=
ared
> > > > > Link from 00:01.2 --- 01:00.0 and the 02:04.0 --- 04:00.x Link, a=
nd
> > > > > that would definitely be a problem.
> > > > >
> > > > > Can you explain the differences between [1] and [2]?
> > > >
> > > > I don't understand which sections you're referring to.
> > >
> > > [1] is the "lspci without my patches" attachment of bugzilla #209725,
> > > which is supposed to show the problem this patch solves.  We're
> > > talking about the path to 04:00.x, and [1] show this:
> > >
> > >   01:00.2 L1+               # <-- my typo here, should be 00:01.2
> > >   01:00.0 L1+
> > >   02:04.0 L1-
> > >   04:00.0 L1-
> > >
> > > AFAICT, that should be a legal configuration as far as 04:00.0 is
> > > concerned, so it's not a reason for this patch.
> >
> > Actually, no, maximum path latency 64us
> >
> > 04:00.0 wakeup latency =3D=3D 64us
> >
> > Again, as stated, it can't be behind any sleeping L1 links
>
> It would be pointless for a device to advertise L1 support if it could
> never be used.  04:00.0 advertises that it can tolerate L1 latency of
> 64us and that it can exit L1 in 64us or less.  So it *can* be behind a
> Link in L1 as long as nothing else in the path adds more latency.

Yes, as long as nothing along the entire path adds latency - and I
didn't make the component
I can only say what it states, and we have to handle it.

> > > [2] is a previous posting of this same patch, and its commit log
> > > includes information about the same path to 04:00.x, but the "LnkCtl
> > > Before" column shows:
> > >
> > >   01:00.2 L1+               # <-- my typo here, should be 00:01.2
> > >   01:00.0 L1+
> > >   02:04.0 L1+
> > >   04:00.0 L1+
> > >
> > > I don't know why [1] shows L1 disabled on the downstream Link, while
> > > [2] shows L1 *enabled* on the same Link.
> >
> > From the data they look switched.
> >
> > > > > > Kai-Heng Feng has a machine that will not boot with ASPM withou=
t
> > > > > > this patch, information is documented here:
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D209671
> > > > >
> > > > > I started working through this info, too, but there's not enough
> > > > > information to tell what difference this patch makes.  The attach=
ments
> > > > > compare:
> > > > >
> > > > >   1) CONFIG_PCIEASPM_DEFAULT=3Dy without the patch [3] and
> > > > >   2) CONFIG_PCIEASPM_POWERSAVE=3Dy *with* the patch [4]
> > > > >
> > > > > Obviously CONFIG_PCIEASPM_POWERSAVE=3Dy will configure things
> > > > > differently than CONFIG_PCIEASPM_DEFAULT=3Dy, so we can't tell wh=
at
> > > > > changes are due to the config change and what are due to the patc=
h.
> > > > >
> > > > > The lspci *with* the patch ([4]) shows L0s and L1 enabled at almo=
st
> > > > > every possible place.  Here are the Links, how they're configured=
, and
> > > > > my analysis of the exit latencies vs acceptable latencies:
> > > > >
> > > > >   00:01.1 --- 01:00.0      L1+ (                  L1 <64us vs unl=
)
> > > > >   00:01.2 --- 02:00.0      L1+ (                  L1 <64us vs 64u=
s)
> > > > >   00:01.3 --- 03:00.0      L1+ (                  L1 <64us vs 64u=
s)
> > > > >   00:01.4 --- 04:00.0      L1+ (                  L1 <64us vs unl=
)
> > > > >   00:08.1 --- 05:00.x L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs unl=
)
> > > > >   00:08.2 --- 06:00.0 L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs unl=
)
> > > > >
> > > > > So I can't tell what change prevents the freeze.  I would expect =
the
> > > > > patch would cause us to *disable* L0s or L1 somewhere.
> > > > >
> > > > > The only place [4] shows ASPM disabled is for 05:00.1.  The spec =
says
> > > > > we should program the same value in all functions of a multi-func=
tion
> > > > > device.  This is a non-ARI device, so "only capabilities enabled =
in
> > > > > all functions are enabled for the component as a whole."  That wo=
uld
> > > > > mean that L0s and L1 are effectively disabled for 05:00.x even th=
ough
> > > > > 05:00.0 claims they're enabled.  But the latencies say ASPM L0s a=
nd L1
> > > > > should be safe to be enabled.  This looks like another bug that's
> > > > > probably unrelated.
> > > >
> > > > I don't think it's unrelated, i suspect it's how PCIe works with
> > > > multiple links...  a device can cause some kind of head of queue
> > > > stalling - i don't know how but it really looks like it.
> > >
> > > The text in quotes above is straight out of the spec (PCIe r5.0, sec
> > > 7.5.3.7).  Either the device works that way or it's not compliant.
> > >
> > > The OS configures ASPM based on the requirements and capabilities
> > > advertised by the device.  If a device has any head of queue stalling
> > > or similar issues, those must be comprehended in the numbers
> > > advertised by the device.  It's not up to the OS to speculate about
> > > issues like that.
> > >
> > > > > The patch might be correct; I haven't actually analyzed the code.=
  But
> > > > > the commit log doesn't make sense to me yet.
> > > >
> > > > I personally don't think that all this PCI information is required,
> > > > the linux kernel is currently doing it wrong according to the spec.
> > >
> > > We're trying to establish exactly *what* Linux is doing wrong.  So fa=
r
> > > we don't have a good explanation of that.
> >
> > Yes we do, linux counts hops + max for "link" while what should be done=
 is
> > counting hops + max for path
>
> I think you're saying we need to include L1 exit latency even for
> Links where L1 is disabled.  I don't think we should include those.

Nope, the code does not do that, it only adds the l1 latency on L1 enabled =
hops

> > > Based on [1], in the path to 03:00.0, both Links have L1 enabled, wit=
h
> > > an exit latency of <33us, and 03:00.0 can tolerate 64us.  That should
> > > work fine.
> > >
> > > Also based on [1], in the path to 04:00.x, the upstream Link has L1
> > > enabled and the downstream Link has L1 disabled, for an exit latency
> > > of <32us, and 04:00.0 can tolerate 64us.  That should also work fine.
> >
> > Again, ignoring the exit latendy for 04:00.0
> >
> > > (Alternately, disabling L1 on the upstream Link and enabling it on th=
e
> > > downstream Link should have an exit latency of <64us and 04:00.0 can
> > > tolerate 64us, so that should work fine, too.)
> >
> > Then nothing else can have L1 aspm enabled
>
> Yes, as I said, we should be able to enable L1 on either of the Links
> in the path to 04:00.x, but not both.

The code works backwards and disables the first hop that exceeds the
latency requirements -
we could argue that it should try to be smarter about it and try to
disable a minimum amount of links
while still retaining the minimum latency but... It is what it is and
it works when patched.

> The original problem here is not with the Realtek device at 04:00.x
> but with the I211 NIC at 03:00.0.  So we also need to figure out what
> the connection is.  Does the same I211 performance problem occur if
> you remove the Realtek device from the system?

It's mounted on the motherboard, so no I can't remove it.

> 03:00.0 can tolerate 64us of latency, so even if L1 is enabled on both
> Links leading to it, the path exit latency would be <33us, which
> should be fine.

Yes, it "should be" but due to broken ASPM latency calculations we
have some kind of
side effect that triggers a racecondition/sideeffect/bug that causes
it to misbehave.

Since fixing the latency calculation fixes it, I'll leave the rest to
someone with a logic
analyzer and a die-hard-fetish for pcie links - I can't debug it.

> > > > Also, since it's clearly doing the wrong thing, I'm worried that
> > > > dists will take a kernel enable aspm and there will be alot of
> > > > bugreports of non-booting systems or other weird issues... And the
> > > > culprit was known all along.
> > >
> > > There's clearly a problem on your system, but I don't know yet whethe=
r
> > > Linux is doing something wrong, a device in your system is designed
> > > incorrectly, or a device is designed correctly but the instance in
> > > your system is defective.
> >
> > According to the spec it is, there is a explanation of how to
> > calculate the exit latency
> > and when you implement that, which i did (before knowing the actual
> > spec) then it works...
> >
> > > > It's been five months...
> > >
> > > I apologize for the delay.  ASPM is a subtle area of PCIe, the Linux
> > > code is complicated, and we have a long history of issues with it.  I
> > > want to fix the problem, but I want to make sure we do it in a way
> > > that matches the spec so the fix applies to all systems.  I don't wan=
t
> > > a magic fix that fixes your system in a way I don't quite understand.
> >
> > > Obviously *you* understand this, so hopefully it's just a matter of
> > > pounding it through my thick skull :)
> >
> > I only understand what I've been forced to understand - and I do
> > leverage the existing code without
> > knowing what it does underneath, I only look at the links maximum
> > latency and make sure that I keep
> > the maximum latency along the path and not just link for link
> >
> > once you realise that the max allowed latency is buffer dependent -
> > then this becomes obviously correct,
> > and then the pcie spec showed it as being correct as well... so...
> >
> >
> > > > > [1] https://bugzilla.kernel.org/attachment.cgi?id=3D293047
> > > > > [2] https://lore.kernel.org/linux-pci/20201007132808.647589-1-ian=
.kumlien@gmail.com/
> > > > > [3] https://bugzilla.kernel.org/attachment.cgi?id=3D292955
> > > > > [4] https://bugzilla.kernel.org/attachment.cgi?id=3D292957
> > > > >
> > > > > > Signed-off-by: Ian Kumlien <ian.kumlien@gmail.com>
> > > > > > Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > > > > ---
> > > > > >  drivers/pci/pcie/aspm.c | 22 ++++++++++++++--------
> > > > > >  1 file changed, 14 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > > > > > index 253c30cc1967..c03ead0f1013 100644
> > > > > > --- a/drivers/pci/pcie/aspm.c
> > > > > > +++ b/drivers/pci/pcie/aspm.c
> > > > > > @@ -434,7 +434,7 @@ static void pcie_get_aspm_reg(struct pci_de=
v *pdev,
> > > > > >
> > > > > >  static void pcie_aspm_check_latency(struct pci_dev *endpoint)
> > > > > >  {
> > > > > > -     u32 latency, l1_switch_latency =3D 0;
> > > > > > +     u32 latency, l1_max_latency =3D 0, l1_switch_latency =3D =
0;
> > > > > >       struct aspm_latency *acceptable;
> > > > > >       struct pcie_link_state *link;
> > > > > >
> > > > > > @@ -456,10 +456,14 @@ static void pcie_aspm_check_latency(struc=
t pci_dev *endpoint)
> > > > > >               if ((link->aspm_capable & ASPM_STATE_L0S_DW) &&
> > > > > >                   (link->latency_dw.l0s > acceptable->l0s))
> > > > > >                       link->aspm_capable &=3D ~ASPM_STATE_L0S_D=
W;
> > > > > > +
> > > > > >               /*
> > > > > >                * Check L1 latency.
> > > > > > -              * Every switch on the path to root complex need =
1
> > > > > > -              * more microsecond for L1. Spec doesn't mention =
L0s.
> > > > > > +              *
> > > > > > +              * PCIe r5.0, sec 5.4.1.2.2 states:
> > > > > > +              * A Switch is required to initiate an L1 exit tr=
ansition on its
> > > > > > +              * Upstream Port Link after no more than 1 =CE=BC=
s from the beginning of an
> > > > > > +              * L1 exit transition on any of its Downstream Po=
rt Links.
> > > > > >                *
> > > > > >                * The exit latencies for L1 substates are not ad=
vertised
> > > > > >                * by a device.  Since the spec also doesn't ment=
ion a way
> > > > > > @@ -469,11 +473,13 @@ static void pcie_aspm_check_latency(struc=
t pci_dev *endpoint)
> > > > > >                * L1 exit latencies advertised by a device inclu=
de L1
> > > > > >                * substate latencies (and hence do not do any ch=
eck).
> > > > > >                */
> > > > > > -             latency =3D max_t(u32, link->latency_up.l1, link-=
>latency_dw.l1);
> > > > > > -             if ((link->aspm_capable & ASPM_STATE_L1) &&
> > > > > > -                 (latency + l1_switch_latency > acceptable->l1=
))
> > > > > > -                     link->aspm_capable &=3D ~ASPM_STATE_L1;
> > > > > > -             l1_switch_latency +=3D 1000;
> > > > > > +             if (link->aspm_capable & ASPM_STATE_L1) {
> > > > > > +                     latency =3D max_t(u32, link->latency_up.l=
1, link->latency_dw.l1);
> > > > > > +                     l1_max_latency =3D max_t(u32, latency, l1=
_max_latency);
> > > > > > +                     if (l1_max_latency + l1_switch_latency > =
acceptable->l1)
> > > > > > +                             link->aspm_capable &=3D ~ASPM_STA=
TE_L1;
> > > > > > +                     l1_switch_latency +=3D 1000;
> > > > > > +             }
> > > > > >
> > > > > >               link =3D link->parent;
> > > > > >       }
> > > > > > --
> > > > > > 2.29.1
> > > > > >
