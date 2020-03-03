Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970A1176D3E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgCCDCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgCCCqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8AE2465E;
        Tue,  3 Mar 2020 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203608;
        bh=KN9SO/J+tUto2qJJGvqUlkJWp2gYhmf9sKcl2h9v6Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIws6RM93RKHJrgTQIELZTDwgpA16gOtZpQrXx8ZTjjKrGrjcoJ6AI73PZybSyVBI
         vcenmK/2WZ7NYzgrNxAz8LHFIcs9g0hfideKmib1hZTrxo/E0jkZY0rHNItIxDTsbh
         WuaZ6HTIGz75matxbIo7FxFFtg3ZhJmoXgXclYMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Belous <pbelous@marvell.com>,
        Christophe Vu-Brugier <cvubrugier@fastmail.fm>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 26/66] net: atlantic: fix use after free kasan warn
Date:   Mon,  2 Mar 2020 21:45:35 -0500
Message-Id: <20200303024615.8889-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
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
index c85e3e29012c0..263beea1859c1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -655,10 +655,6 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
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
index 6941999ae845d..bae95a6185608 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -272,9 +272,12 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
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

