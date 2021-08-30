Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD723FB4F2
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbhH3MAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhH3MAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F4861156;
        Mon, 30 Aug 2021 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324788;
        bh=l//wTGK5/8pJwgdXTtA5HPjMBkYPj0M8VbpprPHxyIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB5XN+W1eq20C6J2HT658w8maRwQrnQocIUiFyy9TiCEbEJX2I58FxbiQs4bLGtGV
         Ela2Qj2/Bv2ZAHHJ742cjl1F8UPrefZtHA4cUmn8vu890iDgwAfiyszF2eOMphzfgq
         lIfYcUNtZ0L0Giou/N9as6t54P5lUGMkIWdlju0Ou53cNLJOTwe9ueBFC51VD1BDhD
         BF7EKELrQ2kma4eXHFrbrPUnIQFocTjGW5tRVj1FzHrpIXcW4qiwnqHZIBdKfW1RJo
         UDiEO3TbgusqYF9vTICpaDKEBo9ApvcMGS8KiGIitz9Uk3Rc50FnwMcK1g62h8uXiK
         WBN1OCCSx+1cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Rossi <nathan.rossi@digi.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/14] net: dsa: mv88e6xxx: Update mv88e6393x serdes errata
Date:   Mon, 30 Aug 2021 07:59:32 -0400
Message-Id: <20210830115942.1017300-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit 3b0720ba00a7413997ad331838d22c81f252556a ]

In early erratas this issue only covered port 0 when changing from
[x]MII (rev A 3.6). In subsequent errata versions this errata changed to
cover the additional "Hardware reset in CPU managed mode" condition, and
removed the note specifying that it only applied to port 0.

In designs where the device is configured with CPU managed mode
(CPU_MGD), on reset all SERDES ports (p0, p9, p10) have a stuck power
down bit and require this initial power up procedure. As such apply this
errata to all three SERDES ports of the mv88e6393x.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index b1d46dd8eaab..6ea003678798 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1277,15 +1277,16 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 	int err;
 
 	/* mv88e6393x family errata 4.6:
-	 * Cannot clear PwrDn bit on SERDES on port 0 if device is configured
-	 * CPU_MGD mode or P0_mode is configured for [x]MII.
-	 * Workaround: Set Port0 SERDES register 4.F002 bit 5=0 and bit 15=1.
+	 * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD
+	 * mode or P0_mode is configured for [x]MII.
+	 * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
 	 *
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE) {
-		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
+	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
+	    lane == MV88E6393X_PORT10_LANE) {
+		err = mv88e6390_serdes_read(chip, lane,
 					    MDIO_MMD_PHYXS,
 					    MV88E6393X_SERDES_POC, &reg);
 		if (err)
-- 
2.30.2

