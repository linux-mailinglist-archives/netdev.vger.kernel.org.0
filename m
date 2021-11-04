Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B474453E6
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhKDNfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhKDNfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:35:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61B0C061714;
        Thu,  4 Nov 2021 06:32:33 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636032751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gOrjPBeDo1Vi2nk3QHdW9LyETW9cJ6hj5K5wHyl43zs=;
        b=xzCsRTYwoqKEQbZBNSMZnevPHviJUJw0hEK7oPm7jkVBpiZ73PTzmR3ha8hjUWKuFSiwRi
        Oel1Iy/xb1HbgcEVNdWaSthSkz/mhl9X+UaLnAHmVSO/C0zXyjhAQUSIOAoNlgCJVkcbOs
        gze3UFhTOosT2BTKNKousf6ou9eYXU5tWhcw0sK8PwmTEjRj8DPvY/+YIy4RWTW7DDdIC3
        6FJEmNVkAYfP+fP/0LZfX2XaqKgmoYNy1OUjGk+gHryi9APZc2HmxdE24Kuzi9ypCv9ZCd
        RoGRXmQysH8ecpYZQrchnYQ+V8lMyLnaNgIttUYimbxkJWF7Epfg33XzF/9IDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636032751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gOrjPBeDo1Vi2nk3QHdW9LyETW9cJ6hj5K5wHyl43zs=;
        b=hP1gTNDdFVK+Cvh5bX33Ij59KvtetN2GQfEbvjKFQRVrstECHSKX5hOmudF0v8WRl8Pp1n
        mFkl/Z2TBMv1ciDA==
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
Subject: [PATCH 0/7] Add PTP support for BCM53128 switch
Date:   Thu,  4 Nov 2021 14:31:54 +0100
Message-Id: <20211104133204.19757-1-martin.kaistra@linutronix.de>
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

 drivers/net/dsa/b53/Kconfig      |   7 +
 drivers/net/dsa/b53/Makefile     |   1 +
 drivers/net/dsa/b53/b53_common.c |  21 ++
 drivers/net/dsa/b53/b53_priv.h   |  90 +-------
 drivers/net/dsa/b53/b53_ptp.c    | 366 +++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    |  68 ++++++
 drivers/net/dsa/b53/b53_regs.h   |  38 ++++
 include/linux/dsa/b53.h          | 144 ++++++++++++
 include/linux/timecounter.h      |   3 +
 kernel/time/timecounter.c        |   3 +
 net/dsa/tag_brcm.c               |  85 ++++++-
 11 files changed, 727 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/dsa/b53/b53_ptp.c
 create mode 100644 drivers/net/dsa/b53/b53_ptp.h
 create mode 100644 include/linux/dsa/b53.h

-- 
2.20.1

