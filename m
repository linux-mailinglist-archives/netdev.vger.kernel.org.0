Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EAD22FD05
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgG0XYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgG0XYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2083320A8B;
        Mon, 27 Jul 2020 23:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892283;
        bh=vfsrCGu3y+RWfQf9b8AQo6w0S428160Hx9tQUbf2Z/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMmS0QTEOfDQeTLxyQKo647FZJgidO1XjuF/Czaz5V9O3efOr+ItXAo1a1LqQuDa2
         7jmqs3IgkMljN3oLB+swakZpIdErBqcaBmxHG1e6sCg6aEBFGbIaPos0jmjmgMw4u2
         XfvUFEZu1rlWx8IYq2SFPtMfmwnPTFVNSzx899As=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/17] drivers/net/wan: lapb: Corrected the usage of skb_cow
Date:   Mon, 27 Jul 2020 19:24:20 -0400
Message-Id: <20200727232420.717684-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232420.717684-1-sashal@kernel.org>
References: <20200727232420.717684-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 8754e1379e7089516a449821f88e1fe1ebbae5e1 ]

This patch fixed 2 issues with the usage of skb_cow in LAPB drivers
"lapbether" and "hdlc_x25":

1) After skb_cow fails, kfree_skb should be called to drop a reference
to the skb. But in both drivers, kfree_skb is not called.

2) skb_cow should be called before skb_push so that is can ensure the
safety of skb_push. But in "lapbether", it is incorrectly called after
skb_push.

More details about these 2 issues:

1) The behavior of calling kfree_skb on failure is also the behavior of
netif_rx, which is called by this function with "return netif_rx(skb);".
So this function should follow this behavior, too.

2) In "lapbether", skb_cow is called after skb_push. This results in 2
logical issues:
   a) skb_push is not protected by skb_cow;
   b) An extra headroom of 1 byte is ensured after skb_push. This extra
      headroom has no use in this function. It also has no use in the
      upper-layer function that this function passes the skb to
      (x25_lapb_receive_frame in net/x25/x25_dev.c).
So logically skb_cow should instead be called before skb_push.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c  | 4 +++-
 drivers/net/wan/lapbether.c | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index bf78073ee7fd9..e2a83f4cd3bb6 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -62,8 +62,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 	skb_reset_network_header(skb);
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 0f1217b506ad2..65b2202647411 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -128,10 +128,12 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	skb_push(skb, 1);
-
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
+
+	skb_push(skb, 1);
 
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
-- 
2.25.1

