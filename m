Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A054F3D765D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbhG0N17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236978AbhG0NUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F0D61A88;
        Tue, 27 Jul 2021 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392022;
        bh=VS7vIddUPJA9FndTyAYSL8l/jEgXNGOTOZn/ujc4N3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFVP9v7s3FCn5sgEFXAZYTriYcKIzDO0WYjnyDt4Vkmhh6otZG6sM1tSSzuh1iQLB
         jkAxUxLgsYj2JY5+dC9dm/LXSXYDfyom/UhD+h+ArB8W3hCHur/57SJ8LxrIY70Jqp
         53d4u5RM8bFOYtX1aVtBbet4yYdzLDsWDmnRuX3nT0QbQbpXlSWuDQtOkJq0vU0Uh0
         WDd8nyYle1MPnb/8O+88SXlDG36GPYkj6KczzRsXHSjy8Ii6dSjLNPsqhwZiXNZWSK
         S5HM64NuKm23jHnbwtIprGuQ8uXH/zdh/RUJZ0TNn6RAECJnybyndFEoUK5bDeKgVm
         IKlneYXCJzX3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 5/6] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Tue, 27 Jul 2021 09:20:14 -0400
Message-Id: <20210727132015.835651-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132015.835651-1-sashal@kernel.org>
References: <20210727132015.835651-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Woudstra <ericwouds@gmail.com>

[ Upstream commit 11d8d98cbeef1496469b268d79938b05524731e8 ]

According to reference guides mt7530 (mt7620) and mt7531:

NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to
read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0]
will be used to read/write the address table.

Since the function only fills in CVID and no FID, we need to set the
IVL bit. The existing code does not set it.

This is a fix for the issue I dropped here earlier:

http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html

With this patch, it is now possible to delete the 'self' fdb entry
manually. However, wifi roaming still has the same issue, the entry
does not get deleted automatically. Wifi roaming also needs a fix
somewhere else to function correctly in combination with vlan.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 1 +
 drivers/net/dsa/mt7530.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6335c4ea0957..96dbc51caf48 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -414,6 +414,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
+	reg[1] |= ATA2_IVL;
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 101d309ee445..72f53e6bc145 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -43,6 +43,7 @@
 #define  STATIC_EMP			0
 #define  STATIC_ENT			3
 #define MT7530_ATA2			0x78
+#define  ATA2_IVL			BIT(15)
 
 /* Register for address table write data */
 #define MT7530_ATWD			0x7c
-- 
2.30.2

