Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57A176B40
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgCCCtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgCCCtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81477246BB;
        Tue,  3 Mar 2020 02:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203750;
        bh=boJ5gw0h0Qgei1gSZTEeFQR9eGRccGArYE5YnhpcY6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8l1s0eN7dKoa44aGUfqPQweNi1ZLMkA3WNq97rfCo7GAic0d/BxDPqO0j6rWpzIp
         3YOkDC+b8njHRKEr2bK6RRCeyB0mzQq82t3RcppmMDCDUo73BfFfvvpqKKFtI7asdB
         SZH/OE9E9aqINcq62qAjwVrn5bd0gNuAkoNdKbe4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Belous <pbelous@marvell.com>,
        Christophe Vu-Brugier <cvubrugier@fastmail.fm>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/32] net: atlantic: fix use after free kasan warn
Date:   Mon,  2 Mar 2020 21:48:33 -0500
Message-Id: <20200303024851.10054-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

[ Upstream commit a4980919ad6a7be548d499bc5338015e1a9191c6 ]

skb->len is used to calculate statistics after xmit invocation.

Under a stress load it may happen that skb will be xmited,
rx interrupt will come and skb will be freed, all before xmit function
is even returned.

Eventually, skb->len will access unallocated area.

Moving stats calculation into tx_clean routine.

Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
Reported-by: Christophe Vu-Brugier <cvubrugier@fastmail.fm>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 4 ----
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 7 +++++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 8cc34b0bedc3a..d1de11b575f44 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -530,10 +530,6 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-		if (err >= 0) {
-			++ring->stats.tx.packets;
-			ring->stats.tx.bytes += skb->len;
-		}
 	} else {
 		err = NETDEV_TX_BUSY;
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index b3c7994d73eb1..b03e5fd4327e3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -162,9 +162,12 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 			}
 		}
 
-		if (unlikely(buff->is_eop))
-			dev_kfree_skb_any(buff->skb);
+		if (unlikely(buff->is_eop)) {
+			++self->stats.rx.packets;
+			self->stats.tx.bytes += buff->skb->len;
 
+			dev_kfree_skb_any(buff->skb);
+		}
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
 		self->sw_head = aq_ring_next_dx(self, self->sw_head);
-- 
2.20.1

