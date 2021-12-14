Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344664743C7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhLNNph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhLNNpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:45:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BB3C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 05:45:35 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639489534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6upzLT69P3sVwByYKQbESny2a1x1JuKG3ngfi5Y3vYw=;
        b=SGdq0ZZLKNTeOjotkPnOxNr/EiLD4hvH8UWQgk8ErAu3MRO8RvYWCMr/T9pi2G9XhT30FW
        XY1wgJTwNIlAe6h69vgYIVxcIni9iTEYVikhj0IGtHRaSxQbcH67XT6zHQvx7VFMK+LEpP
        MFJGYiwyQT8jb8vAm1tlhckiSi0h7Bkmu7S5p23CzUZtM1Gxzbxq2v473ahSu1LKbax6Fb
        3vgogIXHSnX6KCo5oblmdDYeH4BdL27dstuDT+uZLHaf4gOY50C/1kv+RwdJVUVGd8rlWt
        cGui/qTBwoVV7qY/IFiPRNMgPRvZJyqV/Bmk4QQ5h97nXcUP7py0fHeZEN+nAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639489534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6upzLT69P3sVwByYKQbESny2a1x1JuKG3ngfi5Y3vYw=;
        b=fTVb3Ysno6ZpI8WZYSuEkTrDsjUbwNRVl3psQMy2FFE9oJLwcG4FtFrqVGPNyHVCtHkXva
        vdL59FMw2CVig4BA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2 0/4] net: dsa: hellcreek: Fix handling of MGMT protocols
Date:   Tue, 14 Dec 2021 14:45:04 +0100
Message-Id: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series fixes some minor issues with regards to management protocols such as
PTP and STP in the hellcreek DSA driver. Configure static FDB for these
protocols. The end result is:

|root@tsn:~# mv88e6xxx_dump --atu
|Using device <platform/ff240000.switch>
|ATU:
|FID  MAC               0123 Age OBT Pass Static Reprio Prio
|   0 01:1b:19:00:00:00 1100   1               X       X    6
|   1 01:00:5e:00:01:81 1100   1               X       X    6
|   2 33:33:00:00:01:81 1100   1               X       X    6
|   3 01:80:c2:00:00:0e 1100   1        X      X       X    6
|   4 01:00:5e:00:00:6b 1100   1        X      X       X    6
|   5 33:33:00:00:00:6b 1100   1        X      X       X    6
|   6 01:80:c2:00:00:00 1100   1        X      X       X    6

Thanks,
Kurt

Previous version:

 * https://lore.kernel.org/r/20211213101810.121553-1-kurt@linutronix.de/

Changes since v1:

 * Target net-next, as this never worked correctly and is not critical
 * Add STP and PTP over UDP rules
 * Use pass_blocked for PDelay messages only (Richard Cochran)

Kurt Kanzenbach (4):
  net: dsa: hellcreek: Fix insertion of static FDB entries
  net: dsa: hellcreek: Add STP forwarding rule
  net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
  net: dsa: hellcreek: Add missing PTP via UDP rules

 drivers/net/dsa/hirschmann/hellcreek.c | 87 +++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 7 deletions(-)

-- 
2.30.2

