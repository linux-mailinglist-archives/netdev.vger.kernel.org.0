Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B21422E862
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgG0JGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgG0JGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F3FC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:06:14 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nMlHKOJbfutgR3lt7QzadRSD8L9gtujzw4LZJznC7Xk=;
        b=02XyqCSR7lJJjH8UmcTOGYO3UIrY9kiFfZ2+BjzxuDyqOM6Db15nTI/wOAIRHKGb8ojAN7
        27DkyofsPDpsLrsq0hVfUSaZSbWZVK+W5Wd8oW949Xxk+MMYX4HlSHT3xRZ2M7+XaQ5T9g
        9EwxmmyJRCWtJ7nNQvYlzVINjAbnK34yBdGuqZaaCAjYQk+kz5EB48Ye6mEquTJtoScOZh
        2YKzenBrbqTlmcOE4+Uv3Iu5bSPmDjTs55c03ZJKlMXd+ju19Rz3FDlGClFU3feFwbkeWi
        fZV7kEQWz6UAeagiaxIXqbF6Vi95daTQCxOJW0xBS8ppBDqXGwZ+XYG9+GjGow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nMlHKOJbfutgR3lt7QzadRSD8L9gtujzw4LZJznC7Xk=;
        b=VmdZx6kc1/5KIp3GnB3Pag/K0sgsQwGAqmz+297P48ji4yXxx6IkrgjM0/irkw6TzzGoCA
        5Hnq6qN6dsElRaAA==
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
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 0/9] ptp: Add generic header parsing function
Date:   Mon, 27 Jul 2020 11:05:52 +0200
Message-Id: <20200727090601.6500-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

in order to reduce code duplication in the ptp code of DSA, Ethernet and Phy
drivers, move the header parsing function to ptp_classify. This way all drivers
can share the same implementation. Implemented as discussed [1] [2] [3].

This is version two and contains more driver conversions.

Richard, can you test with your hardware? I'll do the same e.g. on the bbb.

Version 1 can be found here:

 * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/

Thanks,
Kurt

Changes since v1:

 * Fix Kconfig (Richard Cochran)
 * Include more drivers (Richard Cochran)

[1] - https://lkml.kernel.org/netdev/20200713140112.GB27934@hoboy/
[2] - https://lkml.kernel.org/netdev/20200720142146.GB16001@hoboy/
[3] - https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/

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
 net/core/ptp_classifier.c                     | 30 +++++++
 8 files changed, 171 insertions(+), 244 deletions(-)

-- 
2.20.1

