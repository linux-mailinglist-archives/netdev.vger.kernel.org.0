Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB823D7619
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhG0NX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236876AbhG0NUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93FCE61AD0;
        Tue, 27 Jul 2021 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391990;
        bh=CpHqBJMBPLIIkdTz32VJBiNhwoL6EL3dIb1W5UgcNEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hY9vxGSK7FUetwYUn6u6PyA45Bb3siYEZ1nC3AOtrQl+LQ0+Ny27EvHHHyiRVoiTj
         Yuzu8YI0F2V5b105VJiff1WWbf1nfs8jYqbFSMYZuT6YDE7o+X/NtLDHhirbcVqB25
         x4ItWoviSzMnii9XA3604JjtEd/oQY9knjAVLy916nnFUqV1fV12dojpbyeh1yyKcE
         QRj+ChfEldmGr/RI4ppma/lFcyIJ1jwixVkrqcap/ZE3eyhUVkz7o7p+eCOqMa/OJn
         rgj61uwCQ9AYOdkEkg0wyVd8l/zEYSY0wFzCVL1ZpK0ODF6gUaQjcUwJx2KMJnyeCf
         sNQTrVwzhi+Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/17] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Tue, 27 Jul 2021 09:19:30 -0400
Message-Id: <20210727131938.834920-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
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
index 190025a0a98e..f6af1b6fa83d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -359,6 +359,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
+	reg[1] |= ATA2_IVL;
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 9278a8e3d04e..319a4d86bea4 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -74,6 +74,7 @@ enum mt753x_bpdu_port_fw {
 #define  STATIC_EMP			0
 #define  STATIC_ENT			3
 #define MT7530_ATA2			0x78
+#define  ATA2_IVL			BIT(15)
 
 /* Register for address table write data */
 #define MT7530_ATWD			0x7c
-- 
2.30.2

