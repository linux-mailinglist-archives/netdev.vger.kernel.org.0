Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97068F808
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfHPApH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36669 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHPApG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so3815717wrt.3;
        Thu, 15 Aug 2019 17:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rbuD1ITMQowPfFNy/cz6ZWEZo9wp5kQvo/8Ha0+7Sw0=;
        b=KoIGwtqSONyt/euNw1uixWESnZaGCmWm/lPK/i0C8IZVD3CPAnvDBL/6CB5FmMjAYu
         vXmDD7/8n/kik5niERUvOdCLaYkp2OOiOwqHNauc5OwZ3otOlusNYzSpFogJ5sbWvDZq
         vOAebT8H5RnlbxtPCfIwW8ePueK0QMJ3ZUoZXqRRmDbtczLXEx2kmthKbSinJTE5Sx7m
         rcJLtPF5SP5PdhNKppJOSjOrZu9MqLEjYrGiDWqgCrMa+MSrPiQfmkNT/zB4U8Xx2d5f
         9U/e4wOZ4ZTctr9lye5gPb6gMV8QNGgnBsa56W+ttPGNF3ePSXrwuwfE/93Mtm6GgLro
         PPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rbuD1ITMQowPfFNy/cz6ZWEZo9wp5kQvo/8Ha0+7Sw0=;
        b=EvlvFSsas/twA/CUKsST+Lv0StqmXdclLiNnZIskkLSQFOlRWr9WpbdRNXgyduCLYC
         7f6eTrgecKx7T/M6Qez0XDDIwdzmxd9iqFXn+vjZyd80jis/OhGbYgS0xV/uWIDDEKVz
         JQ0n2YAiGH/X7MsFtzw9qPl6gArxEc2pF/drkXSpFA6OgFdUi53bOihY57Rvs2eLV0Dg
         3Pb1bs1IxhsaLG7720f+4bJmKFhnp2AaN0kuj0UEyAZZ6MnIkSjbQsksSrghINGmuASz
         DcZHlrEZnZApqTwAxYZzVmQhFkFV3WqnpsMtpXoMxuVtbpN/pKe/n2e2CxRfm03P7I1Z
         vvsA==
X-Gm-Message-State: APjAAAWUSjVj9FLDHCLAdRbYn+b2zbLHoKfAZjIkvZO0nY9Dfum50h4D
        QEYdnt0mqCv4YreItm6tObs=
X-Google-Smtp-Source: APXvYqw+m4qujCWvnCkbg+dJtdcpDWUdjveoYnwwtMUdBeZT72ICgohVT0jsGMzEPqqFppAAxacMmA==
X-Received: by 2002:a5d:4250:: with SMTP id s16mr7676053wrr.318.1565916302158;
        Thu, 15 Aug 2019 17:45:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 00/11] Deterministic SPI latency on NXP
Date:   Fri, 16 Aug 2019 03:44:38 +0300
Message-Id: <20190816004449.10100-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Vladimir Oltean (11):
  net: dsa: sja1105: Add a debugging GPIO for monitoring SPI latency
  net: dsa: sja1105: Implement the .gettimex64 system call for PTP
  spi: Add a PTP system timestamp to the transfer structure
  spi: spi-fsl-dspi: Cosmetic cleanup
  spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
  spi: spi-fsl-dspi: Implement the PTP system timestamping
  spi: spi-fsl-dspi: Add a debugging GPIO for monitoring latency
  spi: spi-fsl-dspi: Disable interrupts and preemption during poll mode
    transfer
  ARM: dts: ls1021a-tsn: Add debugging GPIOs for the SJA1105 and DSPI
    drivers
  ARM: dts: ls1021a-tsn: Use the DSPI controller in poll mode
  ARM: dts: ls1021a-tsn: Reduce the SJA1105 SPI frequency for debug

 arch/arm/boot/dts/ls1021a-tsn.dts      |   8 +-
 drivers/net/dsa/sja1105/sja1105.h      |   8 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  15 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  23 +-
 drivers/net/dsa/sja1105/sja1105_spi.c  |  34 +-
 drivers/spi/spi-fsl-dspi.c             | 518 ++++++++++++++-----------
 include/linux/spi/spi.h                |   4 +
 7 files changed, 365 insertions(+), 245 deletions(-)

-- 
2.17.1

