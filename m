Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C92B22FCE4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgG0XXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0XXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:23:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C907220786;
        Mon, 27 Jul 2020 23:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892227;
        bh=x7YoQtupH7CiYhIjtuOqqsTxqZZSxlDcl4I1Z5TtKrI=;
        h=From:To:Cc:Subject:Date:From;
        b=Q433sx5jaX7YtQhjB71uXxNSpyaSrya38qdWSyQ5ByJw3awzIE5X0s/Oc638rkU87
         av6JGC54Rs09q3BXtfTmB0Vm73CTzfEbkJ5E20QDUNH5+Nfh2d2G/nLtyGO3N2K6yh
         vF1lmvphvkKD2s7y9vHO0T4CApPGQMuEB7uUjSaI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 01/25] mt76: mt7615: fix lmac queue debugsfs entry
Date:   Mon, 27 Jul 2020 19:23:21 -0400
Message-Id: <20200727232345.717432-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d941f47caa386931c3b598ad1b43d5ddd65869aa ]

acs and wmm index are swapped in mt7615_queues_acq respect to the hw
design

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index b4d0795154e3d..a2afd1a3c51ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -206,10 +206,11 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 	int i;
 
 	for (i = 0; i < 16; i++) {
-		int j, acs = i / 4, index = i % 4;
+		int j, wmm_idx = i % MT7615_MAX_WMM_SETS;
+		int acs = i / MT7615_MAX_WMM_SETS;
 		u32 ctrl, val, qlen = 0;
 
-		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(acs, index));
+		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(acs, wmm_idx));
 		ctrl = BIT(31) | BIT(15) | (acs << 8);
 
 		for (j = 0; j < 32; j++) {
@@ -217,11 +218,11 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 				continue;
 
 			mt76_wr(dev, MT_PLE_FL_Q0_CTRL,
-				ctrl | (j + (index << 5)));
+				ctrl | (j + (wmm_idx << 5)));
 			qlen += mt76_get_field(dev, MT_PLE_FL_Q3_CTRL,
 					       GENMASK(11, 0));
 		}
-		seq_printf(s, "AC%d%d: queued=%d\n", acs, index, qlen);
+		seq_printf(s, "AC%d%d: queued=%d\n", wmm_idx, acs, qlen);
 	}
 
 	return 0;
-- 
2.25.1

