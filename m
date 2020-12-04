Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D592CE9FF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgLDIjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:39:00 -0500
Received: from mail.thorsis.com ([92.198.35.195]:33048 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgLDIjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 03:39:00 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2020 03:38:59 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id 09052324B
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 09:29:02 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wq92vdWT0pJY for <netdev@vger.kernel.org>;
        Fri,  4 Dec 2020 09:29:01 +0100 (CET)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id D84BE1FBD; Fri,  4 Dec 2020 09:28:59 +0100 (CET)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.2
From:   Alexander Dahl <ada@thorsis.com>
To:     netdev@vger.kernel.org
Cc:     Grant Edwards <grant.b.edwards@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org
Subject: Re: net: macb: fail when there's no PHY
Date:   Fri, 04 Dec 2020 09:28:53 +0100
Message-ID: <3542036.FvJvBFsO4O@ada>
In-Reply-To: <rqbobm$5qk$1@ciao.gmane.io>
References: <20201202183531.GJ2324545@lunn.ch> <20201203214941.GA2409950@lunn.ch> <rqbobm$5qk$1@ciao.gmane.io>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Grant,

sorry if I just hijack your conversation, but I'm curious, because we are=20
using the same SoC.  Adding linux-arm-kernel to Cc for the general performa=
nce=20
issues and linux-mtd for the ECC questions. O:-)

Am Donnerstag, 3. Dezember 2020, 23:20:38 CET schrieb Grant Edwards:
> On 2020-12-03, Andrew Lunn <andrew@lunn.ch> wrote:
> >> I don't think there's any way I could justify using a kernel that
> >> doesn't have long-term support.
> >=20
> > 5.10 is LTS. Well, it will be, once it is actually released!
>=20
> Convincing people to ship an unreleased kernel would be a whole
> 'nother bucket of worms.

+1

Judging just from the release dates of the last LTS kernels, I would have=20
guessed v5.11 will get LTS.  But there has been no announcement yet and I=20
suppose there will be none before release?  For ordinary users it's just li=
ke=20
staring in a crystal ball, so we aim at v5.4 for our more recent hardware=20
platforms. =C2=AF\_(=E3=83=84)_/=C2=AF

>=20
> It's all moot now. The decision was just made to shelve the 5.4 kernel
> "upgrade" and stick with 2.6.33 for now.
>=20
> >> [It looks like we're going to have to abandon the effort to use
> >> 5.4. The performance is so bad compared to 2.6.33.7 that our product
> >> just plain won't work. We've already had remove features to the get
> >> 5.4 kernel down to a usable size, but we were prepared to live with
> >> that.]
> >=20
> > Ah. Small caches?
>=20
> Yep. It's An old Atmel ARM926T part (at91sam9g20) with 32KB I-cache
> and 32KB D-cache.
>=20
> A simple user-space multi-threaded TCP echo server benchmark showed a
> 30-50% (depending on number of parallel connections) drop in max
> throughput. Our typical applications also show a 15-25% increase in
> CPU usage for an equivalent workload.  Another problem is high
> latencies with 5.4. A thread that is supposed to wake up every 1ms
> works reliably on 2.6.33, but is a long ways from working on 5.4.

We use the exact same SoC with kernel 4.9.220-rt143 (PREEMPT RT) currently,=
=20
after being stuck on 2.6.36.4 for quite a while.  I did not notice signific=
ant=20
performance issues, but I have to admit, we never did extensive benchmarks =
on=20
network or CPU performance, because the workload also changed for that targ=
et.

However what gave us a lot less dropped packages was using the internal SRA=
M=20
as DMA buffer for RX packages received by macb.  That did not make it in=20
mainline however, I did not put enough effort in polishing that patch back=
=20
when we migrated from 2.6 to 4.x.  If you're curious, it's on GitHub:=20
https://github.com/LeSpocky/linux/tree/net-macb-sram-rx

> I asked on the arm kernel mailing list if this was typical/expected,
> but the post never made it past the moderator.
>=20
> > The OpenWRT guys make valid complaints that the code
> > hot path of the network stack is getting too big to fit in the cache
> > of small systems. So there is a lot of cache misses and performance is
> > not good. If i remember correctly, just having netfilter in the build
> > is bad, even if it is not used.
>=20
> We've already disabled absoltely everything we can and still have a
> working system. With the same features enabled, the 5.4 kernel was
> about 75% larger than a 2.6.33 kernel, so we had to trim quite a bit
> of meat to get it to boot on existing units.

Same here.  v4.9 kernel image still fits, v4.14 is already too big for some=
=20
devices we delivered in the early days.

> We also can't get on-die ECC support for Micron NAND flash working
> with 5.4. Even it did work, we'd still have to add the ability to
> fall-back to SW ECC on read operations for the sake of backwards
> compatibility on units that were initially shipped without on-die ECC
> support enabled.

IIRC the SoC itself has issues with its ECC engine? See mainline=20
at91sam9g20ek_common.dtsi for example which sets nand-ecc-mode to "soft".

The SAM9G20 Errata chapter in the complete datasheet from 2015 (Atmel-6384F=
)=20
says two times in Section 44.1.3: "Perform the ECC computation by software."

Greets
Alex



