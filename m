Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD22DA3C8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441354AbgLNW5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441343AbgLNW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:57:24 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2134C0613D6;
        Mon, 14 Dec 2020 14:56:43 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id z11so17368381qkj.7;
        Mon, 14 Dec 2020 14:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=39wreBriIoSTWZSXxpvBMhdWxFEQtcTHD+26xf1dKwo=;
        b=VsetVkf9CwQ5zPAPyoq8i1n9jgVZnpVHtzIL6C5DeBPJtHpC98qXdJv1KXw8ZBemGE
         TeDNaZ3KUhAfFn6VTSbzawsM44ZTGiWg3w4+4V1qgOldjMdcL2GfaQ2aKzU8Plv6zkls
         3qbgdQdDn1w0pi8gPszW6bqFudnmx1IJ+UoyrPx+KtwwtXVwi3mharZ/39hlVMWDc/Ia
         y421FJB38BOGSYgfpIH58loP5bhtkkN3oWrDPv4/OdAHpJk0Nmk0o15O4zKf4xY7d6BJ
         1cm/YpupAmKxYGX9IIEtwUhZNAW5BB14xy+rQ337uRzXDHCbqtV7dNl34e0aBlY8k9x9
         8bVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=39wreBriIoSTWZSXxpvBMhdWxFEQtcTHD+26xf1dKwo=;
        b=D4mImZAWAm6Rz0Y6FfO+RVhmxwSPVqDCcKkV2ZgarYeN2of5IO9K2SvXJiUbmUKXpL
         9frtRxnxV6XaZUvpVTW0r8VqpfSKhH1/BrKzaHOL/x9FwqpKH1f0rYQPMAmkXgzETbxs
         J0QB2EwED7XJ8HjAAAixPgIUJfLomwqCKHs+YGu0aVordSFlClz8nF4nbaA6KKt7cKGH
         y2F7PPsVFmggmVSWFu1PUsa19iZE+N41OVDsv5hZ5+Am2olTAgT+jNTc+b9Zg9HDsryv
         NcjI+U9pZkVXEDn8qPKvrmH2pReqHk2NLiU1O2iqfMSQRV/hCMaI7NqCYf9xwHBFtrtD
         J+Iw==
X-Gm-Message-State: AOAM531hVanLyYazTNGTLickbf39QQ/QMcJtp9xPlGy5x7soGG1ZV2k9
        rh0bmbTn1UdaSKAT5P1zkLQ6Q41cZMmeSODuC8Y=
X-Google-Smtp-Source: ABdhPJxcnrC0dN+W0C5rTDV/NcOKqGEcswfX3MxWcAdwwN6VOjmcGXTNQn8teEQ2dlKrfFbB2vacy44/MYs7tTisfDA=
X-Received: by 2002:a05:620a:2009:: with SMTP id c9mr9297547qka.159.1607986602435;
 Mon, 14 Dec 2020 14:56:42 -0800 (PST)
MIME-Version: 1.0
References: <CAA85sZuG2TbTjOAJ1TRhCbsZ2HRhUzD48b+SQ9JuAmW9gUm_dA@mail.gmail.com>
 <20201214191955.GA228095@bjorn-Precision-5520>
In-Reply-To: <20201214191955.GA228095@bjorn-Precision-5520>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Mon, 14 Dec 2020 23:56:31 +0100
Message-ID: <CAA85sZs8Li7+8BQWj0e+Qrxes1VF6K_Ukqrqgs1E3hHmaXqsbQ@mail.gmail.com>
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

On Mon, Dec 14, 2020 at 8:19 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 04:47:32PM +0100, Ian Kumlien wrote:
> > On Mon, Dec 14, 2020 at 3:02 PM Bjorn Helgaas <helgaas@kernel.org> wrot=
e:
> > > On Mon, Dec 14, 2020 at 10:14:18AM +0100, Ian Kumlien wrote:
> > > > On Mon, Dec 14, 2020 at 6:44 AM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
> > > > >
> > > > > [+cc Jesse, Tony, David, Jakub, Heiner, lists in case there's an =
ASPM
> > > > > issue with I211 or Realtek NICs.  Beginning of thread:
> > > > > https://lore.kernel.org/r/20201024205548.1837770-1-ian.kumlien@gm=
ail.com
> > > > >
> > > > > Short story: Ian has:
> > > > >
> > > > >   Root Port --- Switch --- I211 NIC
> > > > >                        \-- multifunction Realtek NIC, etc
> > > > >
> > > > > and the I211 performance is poor with ASPM L1 enabled on both lin=
ks
> > > > > in the path to it.  The patch here disables ASPM on the upstream =
link
> > > > > and fixes the performance, but AFAICT the devices in that path gi=
ve us
> > > > > no reason to disable L1.  If I understand the spec correctly, the
> > > > > Realtek device should not be relevant to the I211 path.]
> > > > >
> > > > > On Sun, Dec 13, 2020 at 10:39:53PM +0100, Ian Kumlien wrote:
> > > > > > On Sun, Dec 13, 2020 at 12:47 AM Bjorn Helgaas <helgaas@kernel.=
org> wrote:
> > > > > > > On Sat, Oct 24, 2020 at 10:55:46PM +0200, Ian Kumlien wrote:
> > > > > > > > Make pcie_aspm_check_latency comply with the PCIe spec, spe=
cifically:
> > > > > > > > "5.4.1.2.2. Exit from the L1 State"
> > > > > > > >
> > > > > > > > Which makes it clear that each switch is required to
> > > > > > > > initiate a transition within 1=CE=BCs from receiving it,
> > > > > > > > accumulating this latency and then we have to wait for the
> > > > > > > > slowest link along the path before entering L0 state from
> > > > > > > > L1.
> > > > > > > > ...
> > > > > > >
> > > > > > > > On my specific system:
> > > > > > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit=
 Network Connection (rev 03)
> > > > > > > > 04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co.,=
 Ltd. Device 816e (rev 1a)
> > > > > > > >
> > > > > > > >             Exit latency       Acceptable latency
> > > > > > > > Tree:       L1       L0s       L1       L0s
> > > > > > > > ----------  -------  -----     -------  ------
> > > > > > > > 00:01.2     <32 us   -
> > > > > > > > | 01:00.0   <32 us   -
> > > > > > > > |- 02:03.0  <32 us   -
> > > > > > > > | \03:00.0  <16 us   <2us      <64 us   <512ns
> > > > > > > > |
> > > > > > > > \- 02:04.0  <32 us   -
> > > > > > > >   \04:00.0  <64 us   unlimited <64 us   <512ns
> > > > > > > >
> > > > > > > > 04:00.0's latency is the same as the maximum it allows so a=
s
> > > > > > > > we walk the path the first switchs startup latency will pas=
s
> > > > > > > > the acceptable latency limit for the link, and as a
> > > > > > > > side-effect it fixes my issues with 03:00.0.
> > > > > > > >
> > > > > > > > Without this patch, 03:00.0 misbehaves and only gives me ~4=
0
> > > > > > > > mbit/s over links with 6 or more hops. With this patch I'm
> > > > > > > > back to a maximum of ~933 mbit/s.
> > > > > > >
> > > > > > > There are two paths here that share a Link:
> > > > > > >
> > > > > > >   00:01.2 --- 01:00.0 -- 02:03.0 --- 03:00.0 I211 NIC
> > > > > > >   00:01.2 --- 01:00.0 -- 02:04.0 --- 04:00.x multifunction Re=
altek
> > > > > > >
> > > > > > > 1) The path to the I211 NIC includes four Ports and two Links=
 (the
> > > > > > >    connection between 01:00.0 and 02:03.0 is internal Switch =
routing,
> > > > > > >    not a Link).
> > > > > >
> > > > > > >    The Ports advertise L1 exit latencies of <32us, <32us, <32=
us,
> > > > > > >    <16us.  If both Links are in L1 and 03:00.0 initiates L1 e=
xit at T,
> > > > > > >    01:00.0 initiates L1 exit at T + 1.  A TLP from 03:00.0 ma=
y see up
> > > > > > >    to 1 + 32 =3D 33us of L1 exit latency.
> > > > > > >
> > > > > > >    The NIC can tolerate up to 64us of L1 exit latency, so it =
is safe
> > > > > > >    to enable L1 for both Links.
> > > > > > >
> > > > > > > 2) The path to the Realtek device is similar except that the =
Realtek
> > > > > > >    L1 exit latency is <64us.  If both Links are in L1 and 04:=
00.x
> > > > > > >    initiates L1 exit at T, 01:00.0 again initiates L1 exit at=
 T + 1,
> > > > > > >    but a TLP from 04:00.x may see up to 1 + 64 =3D 65us of L1=
 exit
> > > > > > >    latency.
> > > > > > >
> > > > > > >    The Realtek device can only tolerate 64us of latency, so i=
t is not
> > > > > > >    safe to enable L1 for both Links.  It should be safe to en=
able L1
> > > > > > >    on the shared link because the exit latency for that link =
would be
> > > > > > >    <32us.
> > > > > >
> > > > > > 04:00.0:
> > > > > > DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, =
L1 <64us
> > > > > > LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Laten=
cy L0s
> > > > > > unlimited, L1 <64us
> > > > > >
> > > > > > So maximum latency for the entire link has to be <64 us
> > > > > > For the device to leave L1 ASPM takes <64us
> > > > > >
> > > > > > So the device itself is the slowest entry along the link, which
> > > > > > means that nothing else along that path can have ASPM enabled
> > > > >
> > > > > Yes.  That's what I said above: "it is not safe to enable L1 for =
both
> > > > > Links."  Unless I'm missing something, we agree on that.
> > > > >
> > > > > I also said that it should be safe to enable L1 on the shared Lin=
k
> > > > > (from 00:01.2 to 01:00.0) because if the downstream Link is alway=
s in
> > > > > L0, the exit latency of the shared Link should be <32us, and 04:0=
0.x
> > > > > can tolerate 64us.
> > > >
> > > > Exit latency of shared link would be max of link, ie 64 + L1-hops, =
not 32
> > >
> > > I don't think this is true.  The path from 00:01.2 to 04:00.x include=
s
> > > two Links, and they are independent.  The exit latency for each Link
> > > depends only on the Port at each end:
> >
> > The full path is what is important, because that is the actual latency
> > (which the current linux code doesn't do)
>
> I think you're saying we need to include the 04:00.x exit latency of
> 64us even though L1 is not enabled for 04:00.x.  I disagree; the L1
> exit latency of Ports where L1 is disabled is irrelevant.

I will redo the without patch and look again, I know that I have to
wait a while for it to happen.

Witch patch 3 i get:
dec 14 13:44:40 localhost kernel: pci 0000:04:00.0: ASPM latency
exceeded, disabling: L1:0000:01:00.0-0000:00:01.2

And it should only check links that has L1 aspm enabled, as per the
original code.

> > >   Link 1 (depends on 00:01.2 and 01:00.0): max(32, 32) =3D 32us
> > >   Link 2 (depends on 02:04.0 and 04:00.x): max(32, 64) =3D 64us
> > >
> > > If L1 is enabled for Link 1 and disabled for Link 2, Link 2 will
> > > remain in L0 so it has no L1 exit latency, and the exit latency of
> > > the entire path should be 32us.
> >
> > My patch disables this so yes.
> >
> > > > > > > > The original code path did:
> > > > > > > > 04:00:0-02:04.0 max latency 64    -> ok
> > > > > > > > 02:04.0-01:00.0 max latency 32 +1 -> ok
> > > > > > > > 01:00.0-00:01.2 max latency 32 +2 -> ok
> > > > > > > >
> > > > > > > > And thus didn't see any L1 ASPM latency issues.
> > > > > > > >
> > > > > > > > The new code does:
> > > > > > > > 04:00:0-02:04.0 max latency 64    -> ok
> > > > > > > > 02:04.0-01:00.0 max latency 64 +1 -> latency exceeded
> > > > > > > > 01:00.0-00:01.2 max latency 64 +2 -> latency exceeded
> > > > > > >
> > > > > > > [Nit: I don't think we should add 1 for the 02:04.0 -- 01:00.=
0 piece
> > > > > > > because that's internal Switch routing, not a Link.  But even=
 without
> > > > > > > that extra microsecond, this path does exceed the acceptable =
latency
> > > > > > > since 1 + 64 =3D 65us, and 04:00.0 can only tolerate 64us.]
> > > > > >
> > > > > > It does report L1 ASPM on both ends, so the links will be count=
ed as
> > > > > > such in the code.
> > > > >
> > > > > This is a bit of a tangent and we shouldn't get too wrapped up in=
 it.
> > > > > This is a confusing aspect of PCIe.  We're talking about this pat=
h:
> > > > >
> > > > >   00:01.2 --- [01:00.0 -- 02:04.0] --- 04:00.x multifunction Real=
tek
> > > > >
> > > > > This path only contains two Links.  The first one is
> > > > > 00:01.2 --- 01:00.0, and the second one is 02:04.0 --- 04:00.x.
> > > > >
> > > > > 01:00.0 is a Switch Upstream Port and 02:04.0 is a Switch Downstr=
eam
> > > > > Port.  The connection between them is not a Link; it is some inte=
rnal
> > > > > wiring of the Switch that is completely opaque to software.
> > > > >
> > > > > The ASPM information and knobs in 01:00.0 apply to the Link on it=
s
> > > > > upstream side, and the ASPM info and knobs in 02:04.0 apply to th=
e
> > > > > Link on its downstream side.
> > > > >
> > > > > The example in sec 5.4.1.2.2 contains three Links.  The L1 exit l=
atency
> > > > > for the Link is the max of the exit latencies at each end:
> > > > >
> > > > >   Link 1: max(32, 8) =3D 32us
> > > > >   Link 2: max(8, 32) =3D 32us
> > > > >   Link 3: max(32, 8) =3D 32us
> > > > >
> > > > > The total delay for a TLP starting at the downstream end of Link =
3
> > > > > is 32 + 2 =3D 32us.
> > > > >
> > > > > In the path to your 04:00.x Realtek device:
> > > > >
> > > > >   Link 1 (from 00:01.2 to 01:00.0): max(32, 32) =3D 32us
> > > > >   Link 2 (from 02:04.0 to 04:00.x): max(32, 64) =3D 64us
> > > > >
> > > > > If L1 were enabled on both Links, the exit latency would be 64 + =
1 =3D
> > > > > 65us.
> > > >
> > > > So one line to be removed from the changelog, i assume... And yes, =
the
> > > > code handles that - first disable is 01:00.0 <-> 00:01.2
> > > >
> > > > > > I also assume that it can power down individual ports... and en=
ter
> > > > > > rest state if no links are up.
> > > > >
> > > > > I don't think this is quite true -- a Link can't enter L1 unless =
the
> > > > > Ports on both ends have L1 enabled, so I don't think it makes sen=
se to
> > > > > talk about an individual Port being in L1.
> > > > >
> > > > > > > > It correctly identifies the issue.
> > > > > > > >
> > > > > > > > For reference, pcie information:
> > > > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D209725
> > > > > > >
> > > > > > > The "lspci without my patches" [1] shows L1 enabled for the s=
hared
> > > > > > > Link from 00:01.2 --- 01:00.0 and for the Link to 03:00.0 (I2=
11), but
> > > > > > > not for the Link to 04:00.x (Realtek).
> > > > > > >
> > > > > > > Per my analysis above, that looks like it *should* be a safe
> > > > > > > configuration.  03:00.0 can tolerate 64us, actual is <33us.  =
04:00.0
> > > > > > > can tolerate 64us, actual should be <32us since only the shar=
ed Link
> > > > > > > is in L1.
> > > > > >
> > > > > > See above.
> > > > >
> > > > > As I said above, if we enabled L1 only on the shared Link from 00=
:01.2
> > > > > to 01:00.0, the exit latency should be acceptable.  In that case,=
 a
> > > > > TLP from 04:00.x would see only 32us of latency:
> > > > >
> > > > >   Link 1 (from 00:01.2 to 01:00.0): max(32, 32) =3D 32us
> > > > >
> > > > > and 04:00.x can tolerate 64us.
> > > >
> > > > But, again, you're completely ignoring the full link, ie 04:00.x wo=
uld
> > > > also have to power on.
> > >
> > > I think you're using "the full link" to refer to the entire path from
> > > 00:01.2 to 04:00.x.  In PCIe, a "Link" directly connects two Ports.
> > > It doesn't refer to the entire path.
> > >
> > > No, if L1 is disabled on 02:04.0 and 04:00.x (as Linux apparently doe=
s
> > > by default), the Link between them never enters L1, so there is no
> > > power-on for this Link.
> >
> > It doesn't do it by default, my patch does
>
> I'm relying on [1], your "lspci without my patches" attachment named
> "lspci-5.9-mainline.txt", which shows:
>
>   02:04.0 LnkCtl: ASPM Disabled
>   04:00.0 LnkCtl: ASPM Disabled
>
> so I assumed that was what Linux did by default.

Interesting, they are disabled.

> > > > > > > However, the commit log at [2] shows L1 *enabled* for both
> > > > > > > the shared Link from 00:01.2 --- 01:00.0 and the 02:04.0
> > > > > > > --- 04:00.x Link, and that would definitely be a problem.
> > > > > > >
> > > > > > > Can you explain the differences between [1] and [2]?
> > > > > >
> > > > > > I don't understand which sections you're referring to.
> > > > >
> > > > > [1] is the "lspci without my patches" attachment of bugzilla #209=
725,
> > > > > which is supposed to show the problem this patch solves.  We're
> > > > > talking about the path to 04:00.x, and [1] show this:
> > > > >
> > > > >   01:00.2 L1+               # <-- my typo here, should be 00:01.2
> > > > >   01:00.0 L1+
> > > > >   02:04.0 L1-
> > > > >   04:00.0 L1-
> > > > >
> > > > > AFAICT, that should be a legal configuration as far as 04:00.0 is
> > > > > concerned, so it's not a reason for this patch.
> > > >
> > > > Actually, no, maximum path latency 64us
> > > >
> > > > 04:00.0 wakeup latency =3D=3D 64us
> > > >
> > > > Again, as stated, it can't be behind any sleeping L1 links
> > >
> > > It would be pointless for a device to advertise L1 support if it coul=
d
> > > never be used.  04:00.0 advertises that it can tolerate L1 latency of
> > > 64us and that it can exit L1 in 64us or less.  So it *can* be behind =
a
> > > Link in L1 as long as nothing else in the path adds more latency.
> >
> > Yes, as long as nothing along the entire path adds latency - and I
> > didn't make the component
> > I can only say what it states, and we have to handle it.
> >
> > > > > [2] is a previous posting of this same patch, and its commit log
> > > > > includes information about the same path to 04:00.x, but the "Lnk=
Ctl
> > > > > Before" column shows:
> > > > >
> > > > >   01:00.2 L1+               # <-- my typo here, should be 00:01.2
> > > > >   01:00.0 L1+
> > > > >   02:04.0 L1+
> > > > >   04:00.0 L1+
> > > > >
> > > > > I don't know why [1] shows L1 disabled on the downstream Link, wh=
ile
> > > > > [2] shows L1 *enabled* on the same Link.
> > > >
> > > > From the data they look switched.
> > > >
> > > > > > > > Kai-Heng Feng has a machine that will not boot with ASPM wi=
thout
> > > > > > > > this patch, information is documented here:
> > > > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D209671
> > > > > > >
> > > > > > > I started working through this info, too, but there's not
> > > > > > > enough information to tell what difference this patch
> > > > > > > makes.  The attachments compare:
> > > > > > >
> > > > > > >   1) CONFIG_PCIEASPM_DEFAULT=3Dy without the patch [3] and
> > > > > > >   2) CONFIG_PCIEASPM_POWERSAVE=3Dy *with* the patch [4]
> > > > > > >
> > > > > > > Obviously CONFIG_PCIEASPM_POWERSAVE=3Dy will configure
> > > > > > > things differently than CONFIG_PCIEASPM_DEFAULT=3Dy, so we
> > > > > > > can't tell what changes are due to the config change and
> > > > > > > what are due to the patch.
> > > > > > >
> > > > > > > The lspci *with* the patch ([4]) shows L0s and L1 enabled
> > > > > > > at almost every possible place.  Here are the Links, how
> > > > > > > they're configured, and my analysis of the exit latencies
> > > > > > > vs acceptable latencies:
> > > > > > >
> > > > > > >   00:01.1 --- 01:00.0      L1+ (                  L1 <64us vs=
 unl)
> > > > > > >   00:01.2 --- 02:00.0      L1+ (                  L1 <64us vs=
 64us)
> > > > > > >   00:01.3 --- 03:00.0      L1+ (                  L1 <64us vs=
 64us)
> > > > > > >   00:01.4 --- 04:00.0      L1+ (                  L1 <64us vs=
 unl)
> > > > > > >   00:08.1 --- 05:00.x L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs=
 unl)
> > > > > > >   00:08.2 --- 06:00.0 L0s+ L1+ (L0s <64ns vs 4us, L1  <1us vs=
 unl)
> > > > > > >
> > > > > > > So I can't tell what change prevents the freeze.  I would
> > > > > > > expect the patch would cause us to *disable* L0s or L1
> > > > > > > somewhere.
> > > > > > >
> > > > > > > The only place [4] shows ASPM disabled is for 05:00.1.
> > > > > > > The spec says we should program the same value in all
> > > > > > > functions of a multi-function device.  This is a non-ARI
> > > > > > > device, so "only capabilities enabled in all functions are
> > > > > > > enabled for the component as a whole."  That would mean
> > > > > > > that L0s and L1 are effectively disabled for 05:00.x even
> > > > > > > though 05:00.0 claims they're enabled.  But the latencies
> > > > > > > say ASPM L0s and L1 should be safe to be enabled.  This
> > > > > > > looks like another bug that's probably unrelated.
> > > > > >
> > > > > > I don't think it's unrelated, i suspect it's how PCIe works wit=
h
> > > > > > multiple links...  a device can cause some kind of head of queu=
e
> > > > > > stalling - i don't know how but it really looks like it.
> > > > >
> > > > > The text in quotes above is straight out of the spec (PCIe r5.0, =
sec
> > > > > 7.5.3.7).  Either the device works that way or it's not compliant=
.
> > > > >
> > > > > The OS configures ASPM based on the requirements and capabilities
> > > > > advertised by the device.  If a device has any head of queue stal=
ling
> > > > > or similar issues, those must be comprehended in the numbers
> > > > > advertised by the device.  It's not up to the OS to speculate abo=
ut
> > > > > issues like that.
> > > > >
> > > > > > > The patch might be correct; I haven't actually analyzed
> > > > > > > the code.  But the commit log doesn't make sense to me
> > > > > > > yet.
> > > > > >
> > > > > > I personally don't think that all this PCI information is requi=
red,
> > > > > > the linux kernel is currently doing it wrong according to the s=
pec.
> > > > >
> > > > > We're trying to establish exactly *what* Linux is doing wrong.  S=
o far
> > > > > we don't have a good explanation of that.
> > > >
> > > > Yes we do, linux counts hops + max for "link" while what should be =
done is
> > > > counting hops + max for path
> > >
> > > I think you're saying we need to include L1 exit latency even for
> > > Links where L1 is disabled.  I don't think we should include those.
> >
> > Nope, the code does not do that, it only adds the l1 latency on L1
> > enabled hops
> >
> > > > > Based on [1], in the path to 03:00.0, both Links have L1 enabled,=
 with
> > > > > an exit latency of <33us, and 03:00.0 can tolerate 64us.  That sh=
ould
> > > > > work fine.
> > > > >
> > > > > Also based on [1], in the path to 04:00.x, the upstream Link has =
L1
> > > > > enabled and the downstream Link has L1 disabled, for an exit late=
ncy
> > > > > of <32us, and 04:00.0 can tolerate 64us.  That should also work f=
ine.
> > > >
> > > > Again, ignoring the exit latency for 04:00.0
> > > >
> > > > > (Alternately, disabling L1 on the upstream Link and enabling it o=
n the
> > > > > downstream Link should have an exit latency of <64us and 04:00.0 =
can
> > > > > tolerate 64us, so that should work fine, too.)
> > > >
> > > > Then nothing else can have L1 aspm enabled
> > >
> > > Yes, as I said, we should be able to enable L1 on either of the Links
> > > in the path to 04:00.x, but not both.
> >
> > The code works backwards and disables the first hop that exceeds the
> > latency requirements -
> > we could argue that it should try to be smarter about it and try to
> > disable a minimum amount of links
> > while still retaining the minimum latency but... It is what it is and
> > it works when patched.
> >
> > > The original problem here is not with the Realtek device at 04:00.x
> > > but with the I211 NIC at 03:00.0.  So we also need to figure out what
> > > the connection is.  Does the same I211 performance problem occur if
> > > you remove the Realtek device from the system?
> >
> > It's mounted on the motherboard, so no I can't remove it.
>
> If you're interested, you could probably unload the Realtek drivers,
> remove the devices, and set the PCI_EXP_LNKCTL_LD (Link Disable) bit
> in 02:04.0, e.g.,
>
>   # RT=3D/sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/0000:02:04.0
>   # echo 1 > $RT/0000:04:00.0/remove
>   # echo 1 > $RT/0000:04:00.1/remove
>   # echo 1 > $RT/0000:04:00.2/remove
>   # echo 1 > $RT/0000:04:00.4/remove
>   # echo 1 > $RT/0000:04:00.7/remove
>   # setpci -s02:04.0 CAP_EXP+0x10.w=3D0x0010
>
> That should take 04:00.x out of the picture.

Didn't actually change the behaviour, I'm suspecting an errata for AMD pcie=
...

So did this, with unpatched kernel:
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  4.56 MBytes  38.2 Mbits/sec    0   67.9 KBytes
[  5]   1.00-2.00   sec  4.47 MBytes  37.5 Mbits/sec    0   96.2 KBytes
[  5]   2.00-3.00   sec  4.85 MBytes  40.7 Mbits/sec    0   50.9 KBytes
[  5]   3.00-4.00   sec  4.23 MBytes  35.4 Mbits/sec    0   70.7 KBytes
[  5]   4.00-5.00   sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
[  5]   5.00-6.00   sec  4.23 MBytes  35.4 Mbits/sec    0   45.2 KBytes
[  5]   6.00-7.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
[  5]   7.00-8.00   sec  3.98 MBytes  33.4 Mbits/sec    0   36.8 KBytes
[  5]   8.00-9.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
[  5]   9.00-10.00  sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  43.2 MBytes  36.2 Mbits/sec    0             sende=
r
[  5]   0.00-10.00  sec  42.7 MBytes  35.8 Mbits/sec                  recei=
ver

and:
echo 0 > /sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/link/l1_aspm

and:
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   951 Mbits/sec  153    772 KBytes
[  5]   1.00-2.00   sec   109 MBytes   912 Mbits/sec  276    550 KBytes
[  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec  123    625 KBytes
[  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec   31    687 KBytes
[  5]   4.00-5.00   sec   110 MBytes   923 Mbits/sec    0    679 KBytes
[  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec  136    577 KBytes
[  5]   6.00-7.00   sec   110 MBytes   923 Mbits/sec  214    645 KBytes
[  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec   32    628 KBytes
[  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec   81    537 KBytes
[  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec   10    577 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   927 Mbits/sec  1056             send=
er
[  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec                  recei=
ver

But this only confirms that the fix i experience is a side effect.

The original code is still wrong :)

> > > 03:00.0 can tolerate 64us of latency, so even if L1 is enabled on bot=
h
> > > Links leading to it, the path exit latency would be <33us, which
> > > should be fine.
> >
> > Yes, it "should be" but due to broken ASPM latency calculations we
> > have some kind of
> > side effect that triggers a racecondition/sideeffect/bug that causes
> > it to misbehave.
> >
> > Since fixing the latency calculation fixes it, I'll leave the rest to
> > someone with a logic
> > analyzer and a die-hard-fetish for pcie links - I can't debug it.
> >
> > > > > > Also, since it's clearly doing the wrong thing, I'm worried tha=
t
> > > > > > dists will take a kernel enable aspm and there will be alot of
> > > > > > bugreports of non-booting systems or other weird issues... And =
the
> > > > > > culprit was known all along.
> > > > >
> > > > > There's clearly a problem on your system, but I don't know yet wh=
ether
> > > > > Linux is doing something wrong, a device in your system is design=
ed
> > > > > incorrectly, or a device is designed correctly but the instance i=
n
> > > > > your system is defective.
> > > >
> > > > According to the spec it is, there is a explanation of how to
> > > > calculate the exit latency
> > > > and when you implement that, which i did (before knowing the actual
> > > > spec) then it works...
> > > >
> > > > > > It's been five months...
> > > > >
> > > > > I apologize for the delay.  ASPM is a subtle area of PCIe, the Li=
nux
> > > > > code is complicated, and we have a long history of issues with it=
.  I
> > > > > want to fix the problem, but I want to make sure we do it in a wa=
y
> > > > > that matches the spec so the fix applies to all systems.  I don't=
 want
> > > > > a magic fix that fixes your system in a way I don't quite underst=
and.
> > > >
> > > > > Obviously *you* understand this, so hopefully it's just a matter =
of
> > > > > pounding it through my thick skull :)
> > > >
> > > > I only understand what I've been forced to understand - and I do
> > > > leverage the existing code without
> > > > knowing what it does underneath, I only look at the links maximum
> > > > latency and make sure that I keep
> > > > the maximum latency along the path and not just link for link
> > > >
> > > > once you realise that the max allowed latency is buffer dependent -
> > > > then this becomes obviously correct,
> > > > and then the pcie spec showed it as being correct as well... so...
> > > >
> > > >
> > > > > > > [1] https://bugzilla.kernel.org/attachment.cgi?id=3D293047
> > > > > > > [2] https://lore.kernel.org/linux-pci/20201007132808.647589-1=
-ian.kumlien@gmail.com/
> > > > > > > [3] https://bugzilla.kernel.org/attachment.cgi?id=3D292955
> > > > > > > [4] https://bugzilla.kernel.org/attachment.cgi?id=3D292957
> > > > > > >
> > > > > > > > Signed-off-by: Ian Kumlien <ian.kumlien@gmail.com>
> > > > > > > > Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > > > > > > ---
> > > > > > > >  drivers/pci/pcie/aspm.c | 22 ++++++++++++++--------
> > > > > > > >  1 file changed, 14 insertions(+), 8 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/asp=
m.c
> > > > > > > > index 253c30cc1967..c03ead0f1013 100644
> > > > > > > > --- a/drivers/pci/pcie/aspm.c
> > > > > > > > +++ b/drivers/pci/pcie/aspm.c
> > > > > > > > @@ -434,7 +434,7 @@ static void pcie_get_aspm_reg(struct pc=
i_dev *pdev,
> > > > > > > >
> > > > > > > >  static void pcie_aspm_check_latency(struct pci_dev *endpoi=
nt)
> > > > > > > >  {
> > > > > > > > -     u32 latency, l1_switch_latency =3D 0;
> > > > > > > > +     u32 latency, l1_max_latency =3D 0, l1_switch_latency =
=3D 0;
> > > > > > > >       struct aspm_latency *acceptable;
> > > > > > > >       struct pcie_link_state *link;
> > > > > > > >
> > > > > > > > @@ -456,10 +456,14 @@ static void pcie_aspm_check_latency(s=
truct pci_dev *endpoint)
> > > > > > > >               if ((link->aspm_capable & ASPM_STATE_L0S_DW) =
&&
> > > > > > > >                   (link->latency_dw.l0s > acceptable->l0s))
> > > > > > > >                       link->aspm_capable &=3D ~ASPM_STATE_L=
0S_DW;
> > > > > > > > +
> > > > > > > >               /*
> > > > > > > >                * Check L1 latency.
> > > > > > > > -              * Every switch on the path to root complex n=
eed 1
> > > > > > > > -              * more microsecond for L1. Spec doesn't ment=
ion L0s.
> > > > > > > > +              *
> > > > > > > > +              * PCIe r5.0, sec 5.4.1.2.2 states:
> > > > > > > > +              * A Switch is required to initiate an L1 exi=
t transition on its
> > > > > > > > +              * Upstream Port Link after no more than 1 =
=CE=BCs from the beginning of an
> > > > > > > > +              * L1 exit transition on any of its Downstrea=
m Port Links.
> > > > > > > >                *
> > > > > > > >                * The exit latencies for L1 substates are no=
t advertised
> > > > > > > >                * by a device.  Since the spec also doesn't =
mention a way
> > > > > > > > @@ -469,11 +473,13 @@ static void pcie_aspm_check_latency(s=
truct pci_dev *endpoint)
> > > > > > > >                * L1 exit latencies advertised by a device i=
nclude L1
> > > > > > > >                * substate latencies (and hence do not do an=
y check).
> > > > > > > >                */
> > > > > > > > -             latency =3D max_t(u32, link->latency_up.l1, l=
ink->latency_dw.l1);
> > > > > > > > -             if ((link->aspm_capable & ASPM_STATE_L1) &&
> > > > > > > > -                 (latency + l1_switch_latency > acceptable=
->l1))
> > > > > > > > -                     link->aspm_capable &=3D ~ASPM_STATE_L=
1;
> > > > > > > > -             l1_switch_latency +=3D 1000;
> > > > > > > > +             if (link->aspm_capable & ASPM_STATE_L1) {
> > > > > > > > +                     latency =3D max_t(u32, link->latency_=
up.l1, link->latency_dw.l1);
> > > > > > > > +                     l1_max_latency =3D max_t(u32, latency=
, l1_max_latency);
> > > > > > > > +                     if (l1_max_latency + l1_switch_latenc=
y > acceptable->l1)
> > > > > > > > +                             link->aspm_capable &=3D ~ASPM=
_STATE_L1;
> > > > > > > > +                     l1_switch_latency +=3D 1000;
> > > > > > > > +             }
> > > > > > > >
> > > > > > > >               link =3D link->parent;
> > > > > > > >       }
> > > > > > > > --
> > > > > > > > 2.29.1
> > > > > > > >
