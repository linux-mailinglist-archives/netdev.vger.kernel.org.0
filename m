Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF827B9D1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgI2Bdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbgI2BcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:32:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4522921734;
        Tue, 29 Sep 2020 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343112;
        bh=b5En8k/O97exEZDQzUfNz3XNs7S2smboU+rFFPz3PpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfzP7uZLRLTIxS02WJ4GmR2ZJAbqcgEW2DOZCdqGwhcgGCdj7dEToqC7RM/5d+qJD
         MiTF2g8jVW3xpum7TvpDlSnb7WqdniawsapNWSTASN8ct1r/q/1F7yvtMvkBmhROtv
         ALYC3TP2TsNwEr/YnWECMkQ3seN2QRXz/+47l/+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] drivers/net/wan/lapbether: Make skb->protocol consistent with the header
Date:   Mon, 28 Sep 2020 21:31:40 -0400
Message-Id: <20200929013144.2406985-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013144.2406985-1-sashal@kernel.org>
References: <20200929013144.2406985-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 83f9a9c8c1edc222846dc1bde6e3479703e8e5a3 ]

This driver is a virtual driver stacked on top of Ethernet interfaces.

When this driver transmits data on the Ethernet device, the skb->protocol
setting is inconsistent with the Ethernet header prepended to the skb.

This causes a user listening on the Ethernet interface with an AF_PACKET
socket, to see different sll_protocol values for incoming and outgoing
frames, because incoming frames would have this value set by parsing the
Ethernet header.

This patch changes the skb->protocol value for outgoing Ethernet frames,
making it consistent with the Ethernet header prepended. This makes a
user listening on the Ethernet device with an AF_PACKET socket, to see
the same sll_protocol value for incoming and outgoing frames.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 15177a54b17d7..e5fc1b95cea6a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -201,8 +201,6 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 	struct net_device *dev;
 	int size = skb->len;
 
-	skb->protocol = htons(ETH_P_X25);
-
 	ptr = skb_push(skb, 2);
 
 	*ptr++ = size % 256;
@@ -213,6 +211,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb->protocol = htons(ETH_P_DEC);
+
 	skb_reset_network_header(skb);
 
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
-- 
2.25.1

