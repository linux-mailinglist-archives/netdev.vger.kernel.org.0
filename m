Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B406248310
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgHRKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:33:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58218 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgHRKd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:26 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tVc5DhRy0m73sc2qGX7U8AY98Dg5sFmMRBAUlIDK2VM=;
        b=0+NPhxQQFK1oBKTISg10rxq+3Lpy4Iq+1ItSG6EN0Xnns4HwT1rcWyvIQHbpiBpJtXrv/0
        cexTZiKW+9ygRy8zw+WOTqW+j49+SeElHr2l92Ba97wty6VDyy6QYlhV7cgarvv/XeRBe1
        ty9b0MIlbgnmvtQBrSC8cDMnhq7xgdPCpGleEuIY1PQd+GKUFk8r8XSBkeoCz2olO1II4I
        hcUTyqooxdo9chmvidk/mNUHZ95892CWIeMVK+ghxc1r8vKwHBE7xKow0Vr9O1gORgcjUn
        RfLltju19b3wioAgJGRKDwrD490jiQXDape/J++RjcH7yuqb4tlwWDB9r+nKNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tVc5DhRy0m73sc2qGX7U8AY98Dg5sFmMRBAUlIDK2VM=;
        b=2faXyAoxIGDUb9G4l8Bpjl5fbbGgc3dIyY7EeqN/G82BK8oERWvRo67VIgE4TaMMr33Jbp
        dkWdRTxZJsm5I+BQ==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v4 0/9] ptp: Add generic helper functions
Date:   Tue, 18 Aug 2020 12:32:42 +0200
Message-Id: <20200818103251.20421-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

in order to reduce code duplication (and cut'n'paste errors) in the ptp code of
DSA, Ethernet and Phy drivers, create helper functions and move them to
ptp_classify. This way all drivers can share the same implementation.

This is version four and contains bugfixes. Implemented as discussed [1] [2]
[3] [4].

Previous versions can be found here:

 * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200727090601.6500-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200730080048.32553-1-kurt@linutronix.de/

Thanks,
Kurt

Changes sinve v3:

 * Coding style issues (Richard Cochran, Petr Machata)
 * Add better documentation (Grygorii Strashko)
 * Fix cpts code (Grygorii Strashko)
 * Use ntohs() for TI code (Grygorii Strashko)
 * Add tags

Changes since v2:

 * Make ptp_parse_header() work in all scenarios (Russell King)
 * Fix msgtype offset for ptp v1 packets

Changes since v1:

 * Fix Kconfig (Richard Cochran)
 * Include more drivers (Richard Cochran)

[1] - https://lkml.kernel.org/netdev/20200713140112.GB27934@hoboy/
[2] - https://lkml.kernel.org/netdev/20200720142146.GB16001@hoboy/
[3] - https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/
[4] - https://lkml.kernel.org/netdev/20200729100257.GX1551@shell.armlinux.org.uk/

Kurt Kanzenbach (9):
  ptp: Add generic ptp v2 header parsing function
  ptp: Add generic ptp message type function
  net: dsa: mv88e6xxx: Use generic helper function
  mlxsw: spectrum_ptp: Use generic helper function
  ethernet: ti: am65-cpts: Use generic helper function
  ethernet: ti: cpts: Use generic helper function
  net: phy: dp83640: Use generic helper function
  ptp: ptp_ines: Use generic helper function
  ptp: Remove unused macro

 drivers/net/dsa/mv88e6xxx/hwtstamp.c          | 59 +++----------
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 32 ++-----
 drivers/net/ethernet/ti/am65-cpts.c           | 37 ++------
 drivers/net/ethernet/ti/cpts.c                | 42 +++------
 drivers/net/phy/dp83640.c                     | 70 ++++-----------
 drivers/ptp/ptp_ines.c                        | 88 ++++++-------------
 include/linux/ptp_classify.h                  | 70 ++++++++++++++-
 net/core/ptp_classifier.c                     | 30 +++++++
 8 files changed, 183 insertions(+), 245 deletions(-)

-- 
2.20.1

