Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0126B7D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbfEVT0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732148AbfEVT0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:26:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4E97217F9;
        Wed, 22 May 2019 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553209;
        bh=OPj4hyP2iivzFkdQtG2vtTeYaImKjX+wHPT3oJiMBX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jz5kAajdS9PJfdusH0fHOm1UHCMOPv97p1XZb6+V8pb6E/f7K+yO+HLZXCFeTPabK
         NiGTFIUKxMsNhMqh3E0BfetINBRhnNolDt3ub56f9OeJfxr+OtI5yEwVJpqdN42Chy
         8jGCt1rUhVxFV/kFfwIC59dUu5E/4MSQ3lg84HBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephan Klein <stephan.klein@wegfinder.at>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/244] hv_netvsc: fix race that may miss tx queue wakeup
Date:   Wed, 22 May 2019 15:22:39 -0400
Message-Id: <20190522192630.24917-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 93aa4792c3908eac87ddd368ee0fe0564148232b ]

When the ring buffer is almost full due to RX completion messages, a
TX packet may reach the "low watermark" and cause the queue stopped.
If the TX completion arrives earlier than queue stopping, the wakeup
may be missed.

This patch moves the check for the last pending packet to cover both
EAGAIN and success cases, so the queue will be reliably waked up when
necessary.

Reported-and-tested-by: Stephan Klein <stephan.klein@wegfinder.at>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index fb12b63439c67..35413041dcf81 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -872,12 +872,6 @@ static inline int netvsc_send_pkt(
 	} else if (ret == -EAGAIN) {
 		netif_tx_stop_queue(txq);
 		ndev_ctx->eth_stats.stop_queue++;
-		if (atomic_read(&nvchan->queue_sends) < 1 &&
-		    !net_device->tx_disable) {
-			netif_tx_wake_queue(txq);
-			ndev_ctx->eth_stats.wake_queue++;
-			ret = -ENOSPC;
-		}
 	} else {
 		netdev_err(ndev,
 			   "Unable to send packet pages %u len %u, ret %d\n",
@@ -885,6 +879,15 @@ static inline int netvsc_send_pkt(
 			   ret);
 	}
 
+	if (netif_tx_queue_stopped(txq) &&
+	    atomic_read(&nvchan->queue_sends) < 1 &&
+	    !net_device->tx_disable) {
+		netif_tx_wake_queue(txq);
+		ndev_ctx->eth_stats.wake_queue++;
+		if (ret == -EAGAIN)
+			ret = -ENOSPC;
+	}
+
 	return ret;
 }
 
-- 
2.20.1

