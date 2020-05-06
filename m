Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4A1C7C7F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgEFVd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:28 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:53575 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbgEFVdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:24 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d6bef07c;
        Wed, 6 May 2020 21:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=kYi8KCe/dSke//200kwKYMPwC
        Ws=; b=hAPSsmxqfO8x9h3iAXlk7tm1bfYteu7CjlUzD/d4RzRQ2CY4lr/6UZTyW
        2/j3U/J6CpFDzho4nHB1+lJ93YE2k2w3sk4J4pqtCj5b6A2ZxnIg7JBRat9On8b8
        teVQoSy121G9ZLGIlds08OkGofss9C/mltHCTMmlDLUb0UjQ8MHYwFgs5SlRysdC
        eXftaIrtM03zltfmM62ifNtftuukgTsTzv3/W6y9GkesPsorx42WU1XSYkifUA6S
        RImB/EJNxvp7d1kJQ3oDyUBkw+U0Z8kMnkhM2U0yhI0aQAJ1EmvoDJpvi5mKHHsZ
        w3cE8TKGcVZxoJH4YWL741A3NkDfg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 01b67c00 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Wang Jian <larkwang@gmail.com>
Subject: [PATCH net 3/5] wireguard: send/receive: cond_resched() when processing worker ringbuffers
Date:   Wed,  6 May 2020 15:33:04 -0600
Message-Id: <20200506213306.1344212-4-Jason@zx2c4.com>
In-Reply-To: <20200506213306.1344212-1-Jason@zx2c4.com>
References: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users with pathological hardware reported CPU stalls on CONFIG_
PREEMPT_VOLUNTARY=y, because the ringbuffers would stay full, meaning
these workers would never terminate. That turned out not to be okay on
systems without forced preemption, which Sultan observed. This commit
adds a cond_resched() to the bottom of each loop iteration, so that
these workers don't hog the core. Note that we don't need this on the
napi poll worker, since that terminates after its budget is expended.

Suggested-by: Sultan Alsawaf <sultan@kerneltoast.com>
Reported-by: Wang Jian <larkwang@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 2 ++
 drivers/net/wireguard/send.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 267f202f1931..2566e13a292d 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -516,6 +516,8 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 				&PACKET_CB(skb)->keypair->receiving)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(skb, state);
+		if (need_resched())
+			cond_resched();
 	}
 }
 
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 3e030d614df5..dc3079e17c7f 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -281,6 +281,8 @@ void wg_packet_tx_worker(struct work_struct *work)
 
 		wg_noise_keypair_put(keypair, false);
 		wg_peer_put(peer);
+		if (need_resched())
+			cond_resched();
 	}
 }
 
@@ -304,6 +306,8 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
+		if (need_resched())
+			cond_resched();
 	}
 }
 
-- 
2.26.2

