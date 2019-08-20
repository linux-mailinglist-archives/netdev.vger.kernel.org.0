Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13505965AD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfHTP5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:57:25 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42338 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHTP5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:57:24 -0400
Received: by mail-ed1-f66.google.com with SMTP id m44so6890956edd.9;
        Tue, 20 Aug 2019 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=isl3LbKr7fl1A/LITi+ciLQC1pyxL9RhGx1tZE0VEYY=;
        b=fcdkBu/vRNQWDSv2mTUTfleV+vCAAHY2q8YK8aaj59xev43S7e0aTkxECZqOyMQgCO
         LwUyL2jYelnwIbEEix/T3PDsdOn7v4CJLBekvo//RM9PSaRmbyaw7NQY6aTOt4fLh/CH
         k/ObGYGOdeMaD8hEPkv+2P9qhU+x4atLaHyA5MSAp1PkDKoS/j1h2aRZ9TlIZweON69+
         1usgGupIqbi2zxfJ4WDdSYa9WaH0adlopP/AgxUtbZ2VrKXFFEchmpHemlcPGAFhZ4WM
         +3ALm6d9HbFGImBVwmArKAeA57+mXWyiGZCC7GT5VIbzlA6nOcE0wqX8HnCLTTnMEVFD
         Xl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=isl3LbKr7fl1A/LITi+ciLQC1pyxL9RhGx1tZE0VEYY=;
        b=jPHe51fq3YMsTUrxYFJ4mqGWMTtItPD8dQne+4CL98IwTuF66pgw30C46f9r4Gw82t
         EdCV+4K5tRSga0quV89jF6O6xmaCTuUqiCg24E2eGKvnoglyjeLbvZOaOVdW+WwN+9bS
         cqN2HFbHSbD2dYfv0TFNvpGIo2fOci44+/v3Q82sWKxHB6tRLkFU+L+/95+W/P8UTJnM
         WO8ZeTgf861TPngCqimG2e20MzguIbfKCCoA/XuXB4nrTya+qRT/p/OC3hMjWkzM74+T
         u68xJbujcNPwh5uKAOAwPTh7xaw3pWXauEoXdmsnxGWW0uRYLtl2B88bzcsaZ4UAGoFd
         a1Tw==
X-Gm-Message-State: APjAAAXv4xQ/FY5Rc/+mF+05RMPLR09cS840BBSB4GAj7HHHdmNsF7HZ
        sehpCe1P2Gns7oyHHJ8pIK9uO0dtEhfd7jPTalY=
X-Google-Smtp-Source: APXvYqxD0jQqHkQGlcQZCstMOvbsJYWZ1TS6t72OShznkUka94rvMymMBtP9+uJHQsL9ftWKq1ljOSqopmo2jID5RcQ=
X-Received: by 2002:a50:9dc8:: with SMTP id l8mr32092030edk.108.1566316641907;
 Tue, 20 Aug 2019 08:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com>
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 18:57:10 +0300
Message-ID: <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI driver
To:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Aug 2019 at 21:26, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> This patchset proposes an interface from the SPI subsystem for
> software timestamping SPI transfers. There is a default implementation
> provided in the core, as well as a mechanism for SPI slave drivers to
> check which byte was in fact timestamped post-facto. The patchset also
> adds the first user of this interface (the NXP DSPI driver in TCFQ mode).
>
> The interface is somewhat similar to Hubert Feurstein's proposal for the
> MDIO subsystem: https://lkml.org/lkml/2019/8/16/638
>
> Original cover letter below. Also provided at the end some results with
> an extra test (J - phc2sys using the timestamps taken by the SPI core).
>
> ===========================================================
>
> Continuing the discussion created by Hubert Feurstein around the
> mv88e6xxx driver for MDIO-controlled switches
> (https://lkml.org/lkml/2019/8/2/1364), this patchset takes a similar
> approach for the NXP LS1021A-TSN board, which has a SPI-controlled DSA
> switch (SJA1105).
>
> The patchset is motivated by some experiments done with a logic
> analyzer, trying to understand the source of latency (and especially of
> the jitter). SJA1105 SPI messages for reading the PTP clock are 12 bytes
> in length: 4 for the SPI header and 8 for the timestamp. When looking at
> the messages with a scope, there's jitter basically everywhere: between
> bits of a frame and between frames in a transfer. The inter-bit jitter
> is hardware and impacts us to a lesser extend (is smaller and caused by
> the PVT stability of the oscillators, PLLs, etc). We will focus on the
> latency between consecutive SPI frames within a 12-byte transfer.
>
> As a preface, revisions of the DSPI controller IP are integrated in many
> Freescale/NXP devices. As a result, the driver has 3 modes of operation:
> - TCFQ (Transfer Complete Flag mode): The controller signals software
>   that data has been sent/received after each individual word.
> - EOQ (End of Queue mode): The driver can implement batching by making
>   use of the controller's 4-word deep FIFO.
> - DMA (Direct Memory Access mode): The SPI controller's FIFO is no
>   longer in direct interaction with the driver, but is used to trigger
>   the RX and TX channels of the eDMA module on the SoC.
>
> In LS1021A, the driver works in the least efficient mode of the 3
> (TCFQ). There is a well-known errata that the DSPI controller is broken
> in conjunction with the eDMA module. As for the EOQ mode, I have tried
> unsuccessfully for a few days to make use of the 4 entry FIFO, and the
> hardware simply fails to reliably acknowledge the transmission when the
> FIFO gets full. So it looks like we're stuck with the TCFQ mode.
>
> The problem with phc2sys on the LS1021A-TSN board is that in order for
> the gettime64() call to complete on the sja1105, the system has to
> service 12 IRQs. Intuitively that is excessive and is the main source of
> jitter, but let's not get ahead of ourselves.
>
> An outline of the experiments that were done (unless otherwise
> mentioned, all of these ran for 120 seconds):
>
> A. First I have measured the (poor) performance of phc2sys under current
>    conditions. (DSPI driver in IRQ mode, no PTP system timestamping)
>
>    offset: min -53310 max 16107 mean -1737.18 std dev 11444.3
>    delay: min 163680 max 237360 mean 201149 std dev 22446.6
>    lost servo lock 1 times
>
> B. I switched the .gettime64 callback to .gettimex64, snapshotting the
>    PTP system timestamp within the sja1105 driver.
>
>    offset: min -48923 max 64217 mean -904.137 std dev 17358.1
>    delay: min 149600 max 203840 mean 169045 std dev 17993.3
>    lost servo lock 8 times
>
> C. I patched "struct spi_transfer" to contain the PTP system timestamp,
>    and from the sja1105 driver, I passed this structure to be
>    snapshotted by the SPI controller's driver (spi-fsl-dspi). This is
>    the "transfer-level" snapshot.
>
>    offset: min -64979 max 38979 mean -416.197 std dev 15367.9
>    delay: min 125120 max 168320 mean 150286 std dev 17675.3
>    lost servo lock 10 times
>
> D. I changed the placement of the transfer snapshotting within the DSPI
>    driver, from "transfer-level" to "byte-level".
>
>    offset: min -9021 max 7149 mean -0.418803 std dev 3529.81
>    delay: min 7840 max 23920 mean 14493.7 std dev 5982.17
>    lost servo lock 0 times
>
> E. I moved the DSPI driver to poll mode. I went back to collecting the
>    PTP system timestamps from the sja1105 driver (same as B).
>
>    offset: min -4199 max 46643 mean 418.214 std dev 4554.01
>    delay: min 84000 max 194000 mean 99463.2 std dev 12936.5
>    lost servo lock 1 times
>
> F. Transfer-level snapshotting in the DSPI driver (same as C), but in
>    poll mode.
>
>    offset: min -24244 max 1115 mean -230.478 std dev 2297.28
>    delay: min 69440 max 119040 mean 70312.9 std dev 8065.34
>    lost servo lock 1 times
>
> G. Byte-level snapshotting (same as D) but in poll mode.
>
>    offset: min -314 max 288 mean -2.48718 std dev 118.045
>    delay: min 4880 max 6000 mean 5118.63 std dev 507.258
>    lost servo lock 0 times
>
>    This seemed suspiciously good to me, so I let it run for longer
>    (58 minutes):
>
>    offset: min -26251 max 16416 mean -21.8672 std dev 863.416
>    delay: min 4720 max 57280 mean 5182.49 std dev 1607.19
>    lost servo lock 3 times
>
> H. Transfer-level snapshotting (same as F), but with IRQs disabled.
>    This ran for 86 minutes.
>
>    offset: min -1927 max 1843 mean -0.209203 std dev 529.398
>    delay: min 85440 max 93680 mean 88245 std dev 1454.71
>    lost servo lock 0 times
>
> I. Byte-level snapshotting (same as G), but with IRQs disabled.
>    This ran for 102 minutes.
>
>    offset: min -378 max 381 mean -0.0083089 std dev 101.495
>    delay: min 4720 max 5920 mean 5129.38 std dev 154.899
>    lost servo lock 0 times
>
> J. Default snapshotting taken by the SPI core, with the DSPI driver
>    running in poll mode, IRQs enabled. This ran for 274 minutes.
>
>    offset: min -42568 max 44576 mean 2.91646 std dev 947.467
>    delay: min 58480 max 171040 mean 80750.7 std dev 2001.61
>    lost servo lock 3 times
>
> As a result, this patchset proposes the implementation of scenario I.
> The others were done through temporary patches which are not presented
> here due to the difficulty of presenting a coherent git history without
> resorting to reverts etc. The gist of each experiment should be clear
> though.
>
> The raw data is available for dissection at
> https://drive.google.com/open?id=1r9raU9ZeqOqkqts6Lb-ISf5ubLDLP3wk.
> The logic analyzer captures can be opened with a free-as-in-beer program
> provided by Saleae: https://www.saleae.com/downloads/.
>
> In the capture data one can find the MOSI, SCK SPI signals, as well as a
> debug GPIO which was toggled at the same time as the PTP system
> timestamp was taken, to give the viewer an impression of what the
> software is capturing compared to the actual timing of the SPI transfer.
>
> Attached are also some close-up screenshots of transfers where there is
> a clear and huge delay in-between frames of the same 12-byte SPI
> transfer. As it turns out, these were all caused by the CPU getting
> interrupted by some other IRQ. Approaches H and I are the only ones that
> get rid of these glitches. In theory, the byte-level snapshotting should
> be less vulnerable to an IRQ interrupting the SPI transfer (because the
> time window is much smaller) but as the 58 minutes experiment shows, it
> is not immune.
>
> Vladimir Oltean (5):
>   spi: Use an abbreviated pointer to ctlr->cur_msg in
>     __spi_pump_messages
>   spi: Add a PTP system timestamp to the transfer structure
>   spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
>   spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode
>   spi: spi-fsl-dspi: Disable interrupts and preemption during poll mode
>     transfer
>
>  drivers/spi/spi-fsl-dspi.c | 117 +++++++++++++++++++++++++++++++------
>  drivers/spi/spi.c          |  85 +++++++++++++++++++++++----
>  include/linux/spi/spi.h    |  38 ++++++++++++
>  3 files changed, 210 insertions(+), 30 deletions(-)
>
> --
> 2.17.1
>

To the PTP/DSA people copied,

It's possible that I'm going to get a lot of hate for saying this, but
I think we're all missing the forest for the trees with these
ptp_system_timestamp patches.
I'm going to start off with 4 truisms:
- The best software timestamp is worse than a hardware timestamp
- DSA switches are switches that are connected to their host over Ethernet
- Ethernet has support for hardware timestamping
- The mess of taking precise hardware timestamps is well hidden from the kernel

You might see where I'm going.
Maybe this is all really a DSA-specific problem, and should be treated
as such (kept contained).
The claimed goal is to synchronize the DSA switches' time with phc2sys
to/from something else. The problem is that there is latency for
reading the PHC on a DSA device that is a discrete chip.
What if all we need is just a mini-"phc2sys-over-Ethernet" that runs
on a kernel thread internally to DSA? We say that DSA switches are
"slave" to the "master" netdevice - their PTP clock can be the same.
I am fairly confident that the sja1105 at least can be configured in
hardware to work in this mode. One just needs to enable the CPU port
in its own reachability matrix. None of the switch ports is really a
"CPU port" hardware speaking.
- TX timestamps are taken by installing a management route with a
specified port destination. That destination can be the port the frame
came from (the CPU port) if the above condition is met.
- RX timestamps are taken by the switch for frames matching one of 2
MAC filters. Then a short Ethernet frame containing metadata (RX
timestamp) is created and sent to the CPU port. If I enable RX
timestamping on the CPU port, then every management frame sent from
Linux will also generate an RX timestamp (as well as a TX timestamp,
but that is irrelevant).
I believe something similar should be possible on other hardware as well.

The kernel thread can loop back an Ethernet frame and use the 4
collected timestamps to calculate offset and delay.
The only question is how to manage the sync direction (DSA switch to
master, or vice-versa).
It is assumed that the master netdevice supports hardware timestamping
and has a PHC with lower access jitter. That might be a more common
thing than an MDIO or SPI controller with polled I/O and software
timestamping implemented.

Looking forward to comments. If I'm wrong and we do need to extend the
SPI and MDIO subsystems, then I'd better be wrong in any way we look
at the problem, because the alternative is rather intrusive and
tedious to do right (not to mention, not very reusable).

Thanks,
-Vladimir
