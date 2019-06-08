Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC6B39F94
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfFHMFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42669 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfFHMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so4637631wrl.9;
        Sat, 08 Jun 2019 05:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=33BZqFnryBBp4WNaTRqIzVCwzWCs5N7VupVpVJEfc6Q=;
        b=n7p8rQIRljbFbpZc2OJQDih1YAFyFWu6/QfhvKvL200uwLNA5qx/RZr8GcZVidjniZ
         PQxe8VcG5GYmzfKsQFWquabFogiJ2wXKfSgTyAPwRKkmSrZEEDE/yj92xADsrPU3zte6
         E2BZK2JORXfCfN/Fmao2yuuBqhtMeLQfg3q+xI258l7PRVtCKPUo0gMkyXLAzlrnR5df
         yfLpBo/lvzkdy131xOQ9VBP5T6ve4ycJzpROavNq3z5H1SAZGcCKapmzUgufqBMYeevg
         v2UANWk74Qir+BV54hqoqWMS3gw7Py+qffacZDPJgpomyXGLzCWCZGlmru6wxlBOb49d
         SOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=33BZqFnryBBp4WNaTRqIzVCwzWCs5N7VupVpVJEfc6Q=;
        b=YvgbJhQctqKN1S3M8h4fkXKL33l2s+OzF/qr1VOkNT528tEtlrWQz07IOItBXLACZ8
         8Zivcn5/m85xH0sEyQjFpnGPCKH9uYrBqEz2ih+6n5mf71pDZhSP1RZAJz29i8ZovlL7
         r7jKHukxwwGrOkLPccZBSN+45of91pVky54HDeys/barSFDZV0vjEidjoejaa/Sd9q8v
         nl5+akOlh+hY9NLI5PILCJutNVpo/jxA6avBgBanjTBOZ0uR/h7sh7ux84Fz7NZgXlh8
         5P6xNyZQUIZNnciaNZiI93UDPyZSxwFZj/ObCgzb0aRDpIWqtzfDxoYiMSmKSaAgBe2G
         mAPw==
X-Gm-Message-State: APjAAAXmvTU4OzxnYuOo/VKoQ+2LpZX2A7Fz6ag7TvogpDioB0El+cBZ
        AxxYWTcp6NjdeBjuUThVSp0=
X-Google-Smtp-Source: APXvYqxTXQUkS6gZyVPbfSZbLSJI9NfjGTBchPVapWqm2RCXOQqaePVN2ms8W614Tsi34Is5weFkZw==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr13434792wrl.134.1559995534381;
        Sat, 08 Jun 2019 05:05:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 00/17] PTP support for the SJA1105 DSA driver
Date:   Sat,  8 Jun 2019 15:04:26 +0300
Message-Id: <20190608120443.21889-1-olteanv@gmail.com>
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

v3 patchset can be found at:
https://lkml.org/lkml/2019/6/4/954

Changes from v3:

- Made it compile with the SJA1105 DSA driver and PTP driver as modules.

- Reworked/simplified/fixed some issues in 03/17
  (dsa_8021q_remove_header) and added an ASCII image that
  illustrates the transformation that is taking place.

- Removed a useless check for sja1105_is_link_local from 16/17 (RX
  timestamping) which also made previous 08/17 patch ("Move
  sja1105_is_link_local to include/linux") useless and therefore dropped.

v2 patchset can be found at:
https://lkml.org/lkml/2019/6/2/146

Changes from v2:

- Broke previous 09/10 patch (timestamping) into multiple smaller
  patches.

- Every patch in the series compiles.

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

Vladimir Oltean (17):
  net: dsa: Keep a pointer to the skb clone for TX timestamping
  net: dsa: Add teardown callback for drivers
  net: dsa: tag_8021q: Create helper function for removing VLAN header
  net: dsa: sja1105: Move sja1105_change_tpid into
    sja1105_vlan_filtering
  net: dsa: sja1105: Reverse TPID and TPID2
  net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
  net: dsa: sja1105: Export symbols for upcoming PTP driver
  net: dsa: sja1105: Add support for the PTP clock
  net: dsa: sja1105: Add logic for TX timestamping
  net: dsa: sja1105: Build a minimal understanding of meta frames
  net: dsa: sja1105: Add support for the AVB Parameters Table
  net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
  net: dsa: sja1105: Receive and decode meta frames
  net: dsa: sja1105: Add a global sja1105_tagger_data structure
  net: dsa: sja1105: Increase priority of CPU-trapped frames
  net: dsa: sja1105: Add a state machine for RX timestamping
  net: dsa: sja1105: Expose PTP timestamping ioctls to userspace

 drivers/net/dsa/sja1105/Kconfig               |   7 +
 drivers/net/dsa/sja1105/Makefile              |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |  29 ++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 316 ++++++++++++--
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 404 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  64 +++
 drivers/net/dsa/sja1105/sja1105_spi.c         |  35 ++
 .../net/dsa/sja1105/sja1105_static_config.c   |  62 +++
 .../net/dsa/sja1105/sja1105_static_config.h   |  10 +
 include/linux/dsa/8021q.h                     |  16 +-
 include/linux/dsa/sja1105.h                   |  34 ++
 include/net/dsa.h                             |   1 +
 net/dsa/dsa2.c                                |   3 +
 net/dsa/slave.c                               |   3 +
 net/dsa/tag_8021q.c                           |  57 ++-
 net/dsa/tag_sja1105.c                         | 213 ++++++++-
 17 files changed, 1184 insertions(+), 73 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.h

-- 
2.17.1

