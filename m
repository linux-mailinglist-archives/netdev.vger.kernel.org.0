Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29F0A97CB
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfIEBIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:08:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36932 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfIEBH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:07:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so95244wro.4;
        Wed, 04 Sep 2019 18:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xHzOeJ2GjpWDvagAJddycosEjEqbzqRuUBuFN6t3XwM=;
        b=meDOEUi1/BjOVnLb5GX6WCD8y2mFj6tRwWxJDEHO2JiJEJQP+yN6LXSn/GHQ5fs0zf
         v5zg3VVSR1vuwfYvnYgS+QLvdKdRgpOEes6bN01NhwVxWXCmytv6YwkHPvN0/mRrefYM
         8WZfUn2VV2npBLweaKxNoRKoIE4XdsO69sNmn5MB2GUjDdN0szK1uXgeD10xlBM0FgJa
         nD7zLFUIdeDW1+LxROWLCUwzgyukb1WvcU3AHB7aHpfeQZJjK/FlW1CtR5VGjubBoc99
         qlWY1OVA4ib05c6dz+apznJiV3bMyhftKKawRf4Whpxd7+fNR0hpuYCyVHhGt8LwEhty
         X/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xHzOeJ2GjpWDvagAJddycosEjEqbzqRuUBuFN6t3XwM=;
        b=iYrxUjfvW2XtDLwLsCZVTX2aBqeWfYFrvN+qCOWuViRaaF6QNToyJ1e0uUqUsL0SOv
         xdtcU4JZXhgHsqsPurb/fMRAGCE2ylUdM0s6KcN8j9XkoaLVgR/GuX9MNuOEkOhK7MIu
         FAAcqIrjLEECRYdpNOoEDUZ9+wcKdphXTmhySZ2rah/6K6QaiZ3rJnW+QB9K3AEFImD+
         nvvf/jMXaNRBK0tcP/T0/us1OAwwrvllt/EeJbJphxXmomz/4PgySjVxSBaRCD7zvPPx
         dS9OgF8PM8aEJf7fDT48jbTdeOAgw5aJZc/hQdGJF2YAwUQv6FHajqvDFjVV/MxtXQa7
         TuxA==
X-Gm-Message-State: APjAAAXs+1l4a9A82o9VzoNRz3YJmauwihXVUs2jWzKqG1+jkvp7QEz9
        nc36FtWbS+gVuk7XxAlrc4PmF40M
X-Google-Smtp-Source: APXvYqzBvRxwtYUy17F54lpQgS9RMJyR4Yqr63uDMmMMaZZG77fNgB9NzCDK5qHJSUkJ5WQ6XliiYQ==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr322562wrt.342.1567645675801;
        Wed, 04 Sep 2019 18:07:55 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b15sm670125wmb.28.2019.09.04.18.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 18:07:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 0/4] Deterministic SPI latency with NXP DSPI driver
Date:   Thu,  5 Sep 2019 04:01:10 +0300
Message-Id: <20190905010114.26718-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since v1, I noticed that under CPU load, the pre-to-post delay gets
reduced to half (i.e. the code runs twice as fast). After a bit of
debugging, turns out this is the effect of the 'ondemand' governor.
Disabling dynamic frequency scaling (either by switching to the
'performance' governor or by making sure that
/sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_min_freq is equal to
/sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_max_freq) is enough for
all readouts to take roughly the same time now. It is an open question
to me: is there any API available to kernel drivers for controlling
this, or is it only a policy for user space to configure?

So here is another test (K) which ran for 36 minutes, with interrupts
disabled during the critical section, poll mode, and with the CPU pegged
at the maximum frequency (1.2 GHz) and SPI controller at 12 MHz.

  offset: min -72 max 64 mean 0.00729594 std dev 21.6964
  delay: min 4400 max 4480 mean 4402.66 std dev 95.8882
  lost servo lock 0 times

While it is clear that the delay is now finally constant, I can't seem
to figure out why it is what it is - 4400 ns, when the bit time on 12
MHz SPI is 83.33 ns, and hence a frame time is 666 ns. Puzzled, I added
a print in dspi_poll and it turns out the status register is always set
on the first access. While this is yet another argument to operate in
poll mode, it is also an indication that the transmission is CPU-bound
and so is the timestamp measurement. Hence it probably makes sense to
revert to an implementation similar to Hubert's - add a fixed timestamp
correction based on frame size and frequency (hardware latencies are
smaller than can be measured from the CPU), and just stop including the
time to poll the TX confirmation status into the measurement.

I haven't done this last change yet, however, mostly to collect comments
and make sure I'm not operating on false assumptions. Having the CPU cap
the measurement at 4400 ns makes it difficult to know when does the 666
ns transfer actually happen, and thus what an appropriate offset
correction for the hardware transfer would be.

Cover letter from v1 below.

===========================================================

This patchset proposes an interface from the SPI subsystem for
software timestamping SPI transfers. There is a default implementation
provided in the core, as well as a mechanism for SPI slave drivers to
check which byte was in fact timestamped post-facto. The patchset also
adds the first user of this interface (the NXP DSPI driver in TCFQ mode).

The interface is somewhat similar to Hubert Feurstein's proposal for the
MDIO subsystem: https://lkml.org/lkml/2019/8/16/638

Original cover letter below. Also provided at the end some results with
an extra test (J - phc2sys using the timestamps taken by the SPI core).

===========================================================

Continuing the discussion created by Hubert Feurstein around the
mv88e6xxx driver for MDIO-controlled switches
(https://lkml.org/lkml/2019/8/2/1364), this patchset takes a similar
approach for the NXP LS1021A-TSN board, which has a SPI-controlled DSA
switch (SJA1105).

The patchset is motivated by some experiments done with a logic
analyzer, trying to understand the source of latency (and especially of
the jitter). SJA1105 SPI messages for reading the PTP clock are 12 bytes
in length: 4 for the SPI header and 8 for the timestamp. When looking at
the messages with a scope, there's jitter basically everywhere: between
bits of a frame and between frames in a transfer. The inter-bit jitter
is hardware and impacts us to a lesser extend (is smaller and caused by
the PVT stability of the oscillators, PLLs, etc). We will focus on the
latency between consecutive SPI frames within a 12-byte transfer.

As a preface, revisions of the DSPI controller IP are integrated in many
Freescale/NXP devices. As a result, the driver has 3 modes of operation:
- TCFQ (Transfer Complete Flag mode): The controller signals software
  that data has been sent/received after each individual word.
- EOQ (End of Queue mode): The driver can implement batching by making
  use of the controller's 4-word deep FIFO.
- DMA (Direct Memory Access mode): The SPI controller's FIFO is no
  longer in direct interaction with the driver, but is used to trigger
  the RX and TX channels of the eDMA module on the SoC.

In LS1021A, the driver works in the least efficient mode of the 3
(TCFQ). There is a well-known errata that the DSPI controller is broken
in conjunction with the eDMA module. As for the EOQ mode, I have tried
unsuccessfully for a few days to make use of the 4 entry FIFO, and the
hardware simply fails to reliably acknowledge the transmission when the
FIFO gets full. So it looks like we're stuck with the TCFQ mode.

The problem with phc2sys on the LS1021A-TSN board is that in order for
the gettime64() call to complete on the sja1105, the system has to
service 12 IRQs. Intuitively that is excessive and is the main source of
jitter, but let's not get ahead of ourselves.

An outline of the experiments that were done (unless otherwise
mentioned, all of these ran for 120 seconds):

A. First I have measured the (poor) performance of phc2sys under current
   conditions. (DSPI driver in IRQ mode, no PTP system timestamping)

   offset: min -53310 max 16107 mean -1737.18 std dev 11444.3
   delay: min 163680 max 237360 mean 201149 std dev 22446.6
   lost servo lock 1 times

B. I switched the .gettime64 callback to .gettimex64, snapshotting the
   PTP system timestamp within the sja1105 driver.

   offset: min -48923 max 64217 mean -904.137 std dev 17358.1
   delay: min 149600 max 203840 mean 169045 std dev 17993.3
   lost servo lock 8 times

C. I patched "struct spi_transfer" to contain the PTP system timestamp,
   and from the sja1105 driver, I passed this structure to be
   snapshotted by the SPI controller's driver (spi-fsl-dspi). This is
   the "transfer-level" snapshot.

   offset: min -64979 max 38979 mean -416.197 std dev 15367.9
   delay: min 125120 max 168320 mean 150286 std dev 17675.3
   lost servo lock 10 times

D. I changed the placement of the transfer snapshotting within the DSPI
   driver, from "transfer-level" to "byte-level".

   offset: min -9021 max 7149 mean -0.418803 std dev 3529.81
   delay: min 7840 max 23920 mean 14493.7 std dev 5982.17
   lost servo lock 0 times

E. I moved the DSPI driver to poll mode. I went back to collecting the
   PTP system timestamps from the sja1105 driver (same as B).

   offset: min -4199 max 46643 mean 418.214 std dev 4554.01
   delay: min 84000 max 194000 mean 99463.2 std dev 12936.5
   lost servo lock 1 times

F. Transfer-level snapshotting in the DSPI driver (same as C), but in
   poll mode.

   offset: min -24244 max 1115 mean -230.478 std dev 2297.28
   delay: min 69440 max 119040 mean 70312.9 std dev 8065.34
   lost servo lock 1 times

G. Byte-level snapshotting (same as D) but in poll mode.

   offset: min -314 max 288 mean -2.48718 std dev 118.045
   delay: min 4880 max 6000 mean 5118.63 std dev 507.258
   lost servo lock 0 times

   This seemed suspiciously good to me, so I let it run for longer
   (58 minutes):

   offset: min -26251 max 16416 mean -21.8672 std dev 863.416
   delay: min 4720 max 57280 mean 5182.49 std dev 1607.19
   lost servo lock 3 times

H. Transfer-level snapshotting (same as F), but with IRQs disabled.
   This ran for 86 minutes.

   offset: min -1927 max 1843 mean -0.209203 std dev 529.398
   delay: min 85440 max 93680 mean 88245 std dev 1454.71
   lost servo lock 0 times

I. Byte-level snapshotting (same as G), but with IRQs disabled.
   This ran for 102 minutes.

   offset: min -378 max 381 mean -0.0083089 std dev 101.495
   delay: min 4720 max 5920 mean 5129.38 std dev 154.899
   lost servo lock 0 times

J. Default snapshotting taken by the SPI core, with the DSPI driver
   running in poll mode, IRQs enabled. This ran for 274 minutes.

   offset: min -42568 max 44576 mean 2.91646 std dev 947.467
   delay: min 58480 max 171040 mean 80750.7 std dev 2001.61
   lost servo lock 3 times

As a result, this patchset proposes the implementation of scenario I.
The others were done through temporary patches which are not presented
here due to the difficulty of presenting a coherent git history without
resorting to reverts etc. The gist of each experiment should be clear
though.

The raw data is available for dissection at
https://drive.google.com/open?id=1r9raU9ZeqOqkqts6Lb-ISf5ubLDLP3wk.
The logic analyzer captures can be opened with a free-as-in-beer program
provided by Saleae: https://www.saleae.com/downloads/.

In the capture data one can find the MOSI, SCK SPI signals, as well as a
debug GPIO which was toggled at the same time as the PTP system
timestamp was taken, to give the viewer an impression of what the
software is capturing compared to the actual timing of the SPI transfer.

Attached are also some close-up screenshots of transfers where there is
a clear and huge delay in-between frames of the same 12-byte SPI
transfer. As it turns out, these were all caused by the CPU getting
interrupted by some other IRQ. Approaches H and I are the only ones that
get rid of these glitches. In theory, the byte-level snapshotting should
be less vulnerable to an IRQ interrupting the SPI transfer (because the
time window is much smaller) but as the 58 minutes experiment shows, it
is not immune.

Vladimir Oltean (4):
  spi: Use an abbreviated pointer to ctlr->cur_msg in
    __spi_pump_messages
  spi: Add a PTP system timestamp to the transfer structure
  spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode
  spi: spi-fsl-dspi: Always use the TCFQ devices in poll mode

 drivers/spi/spi-fsl-dspi.c |  20 ++++-
 drivers/spi/spi.c          | 150 ++++++++++++++++++++++++++++++++++---
 include/linux/spi/spi.h    |  61 +++++++++++++++
 3 files changed, 219 insertions(+), 12 deletions(-)

-- 
2.17.1

