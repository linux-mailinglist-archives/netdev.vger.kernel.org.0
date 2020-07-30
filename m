Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE657232CC3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgG3IAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:00:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3IAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:00:53 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cV4LtH8m4IjxWbH8oldUeuo8BRH7WOmNlWTPKqssdBE=;
        b=rhl8tGJcJGL95GNSycQtTre9hv+fFvzcG2LUK6tWgMczO1dtgNP8LM88BtKawkn2uIPin2
        AAYU6NgkHArI/KeQHuKXMPzzG29CaGo6MiT0I9JKGJlv1iwO6FC796pj4ehmLoTnYpO2q7
        zfCVzhyPc4utsp3o7uowSrsQzavSttAjGggKxoHm1cnVdETd5iSC+3G655Q2JOl3VfoBTT
        VS4OrirYBOweuyeqNllIunGAoH0T0fVTfcYuFn8utFTSgKysXzTHE8ZIPv1ZqNQOyZSYqe
        lbxGiZjj/usDiV8+Pe+DfiIVipPcylxJ2DmyaUHE4retT9O4oR1xHHXLge95jw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cV4LtH8m4IjxWbH8oldUeuo8BRH7WOmNlWTPKqssdBE=;
        b=IBlNXKKFUm+fuwSLkgN//oSudiGW0ed8tDsE9TI+sYdKd8VltJHjpQPd0jXMyGxgyE5UED
        zfjDQRZTGx3UWyBg==
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 0/9] ptp: Add generic helper functions
Date:   Thu, 30 Jul 2020 10:00:39 +0200
Message-Id: <20200730080048.32553-1-kurt@linutronix.de>
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

This is version three and contains bugfixes. Implemented as discussed [1] [2]
[3] [4].

Previous versions can be found here:

 * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200727090601.6500-1-kurt@linutronix.de/

Thanks,
Kurt

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
 drivers/net/ethernet/ti/cpts.c                | 37 ++------
 drivers/net/phy/dp83640.c                     | 69 ++++-----------
 drivers/ptp/ptp_ines.c                        | 88 ++++++-------------
 include/linux/ptp_classify.h                  | 63 ++++++++++++-
 net/core/ptp_classifier.c                     | 31 +++++++
 8 files changed, 172 insertions(+), 244 deletions(-)

-- 
2.20.1

