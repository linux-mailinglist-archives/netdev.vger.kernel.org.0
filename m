Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0544AAE6
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbhKIJxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:53:34 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34922 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbhKIJx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:28 -0500
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bw5qBgd0vmub1Pz0L0QBZ2Rcgqf+q4qF+intuloVUEs=;
        b=U0/DZg8u2uFgnNZAOm6vLTWVYKLNlbXJAZTjMTCEM8Ra8jpt/AdJzmFbG7+M8bjTCNQ89S
        7xK8hP52Y3n7DdIWETXT9CNM9RJkUDs+W04HrwKP3u2zkWxA/9S1lfTDw7qlszFxT2XM5x
        zWhn+bJo9D41AZMrfCGPMb616Ca2VaGRZoCC4+s8T9ZlaDm6U4ZhNUYNiF2fKJDuGmPWzs
        yCpN2I5G1ZbuJgt0CK6ju+83uXjT3ciuGdmweLTR3abOM0QeWqupA1S3lT4Llth2v4RRZQ
        J6icNiduVJ1iFcW3Id4ErJNif7y49ac9fOxbfl3FLM1ZG1RQVHLJyIgNLV4gZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bw5qBgd0vmub1Pz0L0QBZ2Rcgqf+q4qF+intuloVUEs=;
        b=Zrisn8IlnnH4WW5dCXEKUchUYFA8khY9U1ug+WU0fP0LFOkGKexrVUMMlVZE4DX4uN4Zv0
        TyXJVO2g0W8068Cg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/7] Add PTP support for BCM53128 switch
Date:   Tue,  9 Nov 2021 10:50:02 +0100
Message-Id: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds PTP support to the b53 DSA driver for the BCM53128
switch using the BroadSync HD feature.

As there seems to be only one filter (either by Ethertype or DA) for
timestamping incoming packets, only L2 is supported.

To be able to use the timecounter infrastructure with a counter that
wraps around at a non-power of two point, patch 2 adds support for such
a custom point. Alternatively I could fix up the delta every time a
wrap-around occurs in the driver itself, but this way it can also be
useful for other hardware.

v1 -> v2: fix compiling each patch with W=1 C=1
          fix compiling when NET_DSA or B53 = m
          return error on request for too broad filters
          use aux_work for overflow check
          fix signature of b53_port_txtstamp() for !CONFIG_B53_PTP
          rework broadsync hd register definitions
          add and use register definitions for multiport control
          remove setting default value for B53_BROADSYNC_TIMEBASE_ADJ
          simplify initialisation of dev->ptp_clock_info
          fix pskb_may_pull() for different tag lengths
          add unlikely() to check for status frames
          add pointer to b53_port_hwtstamp from dp->priv to simplify access from tag_brcm.c

Ideally, for the B53=m case, I would have liked to include the PTP
support in the b53_module itself, however I couldn't find a way to do
that without renaming either the common source file or the module, which
I didn't want to do.

Instead, b53_ptp will be allowed as a loadable module, but only if
b53_common is also a module, otherwise it will be built-in.


This is v2, the previous version can be found here:
https://lore.kernel.org/netdev/20211104133204.19757-1-martin.kaistra@linutronix.de/

Thanks,
Martin

Kurt Kanzenbach (1):
  net: dsa: b53: Add BroadSync HD register definitions

Martin Kaistra (6):
  net: dsa: b53: Move struct b53_device to include/linux/dsa/b53.h
  timecounter: allow for non-power of two overflow
  net: dsa: b53: Add PHC clock support
  net: dsa: b53: Add logic for RX timestamping
  net: dsa: b53: Add logic for TX timestamping
  net: dsa: b53: Expose PTP timestamping ioctls to userspace

 drivers/net/dsa/b53/Kconfig      |   8 +
 drivers/net/dsa/b53/Makefile     |   4 +
 drivers/net/dsa/b53/b53_common.c |  21 ++
 drivers/net/dsa/b53/b53_priv.h   |  90 +-------
 drivers/net/dsa/b53/b53_ptp.c    | 366 +++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    |  67 ++++++
 drivers/net/dsa/b53/b53_regs.h   |  71 ++++++
 include/linux/dsa/b53.h          | 144 ++++++++++++
 include/linux/timecounter.h      |   3 +
 kernel/time/timecounter.c        |   3 +
 net/dsa/tag_brcm.c               |  81 ++++++-
 11 files changed, 760 insertions(+), 98 deletions(-)
 create mode 100644 drivers/net/dsa/b53/b53_ptp.c
 create mode 100644 drivers/net/dsa/b53/b53_ptp.h
 create mode 100644 include/linux/dsa/b53.h

-- 
2.20.1

