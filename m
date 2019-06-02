Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64CE324FD
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfFBVkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34666 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBVkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so1746811wrn.1;
        Sun, 02 Jun 2019 14:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0Tf20jDGMWUcH2Hcx3cmJ4DwwispS2qlIQRFHDPkcQI=;
        b=A4BIpkTuPXp7L16AyptYnM75v5No/tAyjB3AVtK+9VhqbKVCGxEMErhuxuFDHYfJuE
         Atd2b8EssPrhFc/y7UbPgIPnNrzjXI5tFQHfHXN0jOtWQMpyWsfdbPCbGPFMVY0PXNid
         Q0mYnLahI5YRfBsApwkpxSz4CcbcEgk11xixnYXpBbavyDk5onAL6ltKdlEyE6WV5AKD
         YUIa6/iscvfpBsQfaNTewStAsQbQyQWx8D13G4iqwZvaPWOGUnKO6GqAzlwKiuSXlO0T
         fMSiMi3qIwxcFXIKyK+CpULIpNRqMxRiIKIre7NxLWqPvjlYNykKSg1VqHgY38FtT0Ih
         40Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0Tf20jDGMWUcH2Hcx3cmJ4DwwispS2qlIQRFHDPkcQI=;
        b=mRRUYSqFV0saa6hnFOm1hWEGEByP0GOlJ1LcXWPq0oKW444Z/05ZzwXPI2bd+UM6P3
         WFHm5doFir1TwGokg0EWOpR7mLFpGVoDHAGBNo/6NFdLGhV5n0K9Cb15CFLLt4bFJQ1i
         u6zdP/cIOU8BazPmWNrmUv8dL3cLCu083MXAhbcSdfzYkrPUx4IfmpbujMD4ZkGeARvp
         7RnG4aSgLOz/e3pOHuBr4TtqcPfm/a0c61Kf23SC2IO5afij03uPU/+Y0aHPEI/EyPL9
         zT3nGS+FHyevF6Y77RWTwc+MbrKIh6NJipH+PrLWXJLNfvz8iAvbZpZVF/wr3uVdQXSX
         UrQA==
X-Gm-Message-State: APjAAAVJRojPoVnXkFQ3TnieH9Swjv2zfrFjs8p0PKfDrtQKEMr17xxs
        x5udCUVip8IYEfKYM4T0LTs=
X-Google-Smtp-Source: APXvYqzVNB63iJ9xrHZ5YzOTZapHlZRNWawMHdaY5d0DoQDgRibB92wTxvQpezVjfuNE9t8T8ku/OA==
X-Received: by 2002:adf:ce8f:: with SMTP id r15mr2153892wrn.122.1559511600409;
        Sun, 02 Jun 2019 14:40:00 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 00/10] PTP support for the SJA1105 DSA driver
Date:   Mon,  3 Jun 2019 00:39:16 +0300
Message-Id: <20190602213926.2290-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the following:

 - A timecounter/cyclecounter based PHC for the free-running
   timestamping clock of this switch.

 - A state machine implemented in the DSA tagger for SJA1105, which
   keeps track of metadata follow-up Ethernet frames (the switch's way
   of transmitting RX timestamps).

Clock manipulations on the actual hardware PTP clock will have to be
implemented anyway, for the TTEthernet block and the time-based ingress
policer.

This depends upon the "FDB updates for SJA1105 DSA driver" series at:
https://patchwork.ozlabs.org/project/netdev/list/?series=111354&state=*

v1 patchset can be found at:
https://lkml.org/lkml/2019/5/28/1093

Changes from v1:

- Removed the addition of the DSA .can_timestamp callback.

- Waiting for meta frames is done completely inside the tagger, and all
  frames emitted on RX are already partially timestamped.

- Added a global data structure for the tagger common to all ports.

- Made PTP work with ports in standalone mode, by limiting use of the
  DMAC-mangling "incl_srcpt" mode only when ports are bridged, aka when
  the DSA master is already promiscuous and can receive anything.
  Also changed meta frames to be sent at the 01-80-C2-00-00-0E DMAC.

- Made some progress w.r.t. observed negative path delay.  Apparently it
  only appears when the delay mechanism is the delay request-response
  (end-to-end) one. If peer delay is used (-P), the path delay is
  positive and appears reasonable for an 1000Base-T link (485 ns in
  steady state).

  SJA1105 as PTP slave (OC) with E2E path delay:

ptp4l[55.600]: master offset          8 s2 freq  +83677 path delay     -2390
ptp4l[56.600]: master offset         17 s2 freq  +83688 path delay     -2391
ptp4l[57.601]: master offset          6 s2 freq  +83682 path delay     -2391
ptp4l[58.601]: master offset         -1 s2 freq  +83677 path delay     -2391

  SJA1105 as PTP slave (OC) with P2P path delay:

ptp4l[48.343]: master offset          5 s2 freq  +83715 path delay       484
ptp4l[48.468]: master offset         -3 s2 freq  +83705 path delay       485
ptp4l[48.593]: master offset          0 s2 freq  +83708 path delay       485
ptp4l[48.718]: master offset          1 s2 freq  +83710 path delay       485
ptp4l[48.844]: master offset          1 s2 freq  +83710 path delay       485
ptp4l[48.969]: master offset         -5 s2 freq  +83702 path delay       485
ptp4l[49.094]: master offset          3 s2 freq  +83712 path delay       485
ptp4l[49.219]: master offset          4 s2 freq  +83714 path delay       485
ptp4l[49.344]: master offset         -5 s2 freq  +83702 path delay       485
ptp4l[49.469]: master offset          3 s2 freq  +83713 path delay       487

Vladimir Oltean (10):
  net: dsa: Keep a pointer to the skb clone for TX timestamping
  net: dsa: Add teardown callback for drivers
  net: dsa: tag_8021q: Create helper function for removing VLAN header
  net: dsa: sja1105: Move sja1105_change_tpid into
    sja1105_vlan_filtering
  net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
  net: dsa: sja1105: Add support for the PTP clock
  net: dsa: sja1105: Move sja1105_is_link_local to include/linux
  net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
  net: dsa: sja1105: Add support for PTP timestamping
  net: dsa: sja1105: Increase priority of CPU-trapped frames

 drivers/net/dsa/sja1105/Kconfig               |   7 +
 drivers/net/dsa/sja1105/Makefile              |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |  29 ++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 317 ++++++++++++--
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 392 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  64 +++
 drivers/net/dsa/sja1105/sja1105_spi.c         |  33 ++
 .../net/dsa/sja1105/sja1105_static_config.c   |  59 +++
 .../net/dsa/sja1105/sja1105_static_config.h   |  10 +
 include/linux/dsa/8021q.h                     |   7 +
 include/linux/dsa/sja1105.h                   |  51 +++
 include/net/dsa.h                             |   1 +
 net/dsa/dsa2.c                                |   3 +
 net/dsa/slave.c                               |   3 +
 net/dsa/tag_8021q.c                           |  15 +
 net/dsa/tag_sja1105.c                         | 203 ++++++++-
 17 files changed, 1150 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.h

-- 
2.17.1

