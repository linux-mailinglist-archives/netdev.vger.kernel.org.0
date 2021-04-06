Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ADA354DEE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbhDFHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:35:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56006 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbhDFHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:35:36 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617694527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VrVbOO4b9Ber4GqFXFXFHTaJP3U7jex5+rXuxCcYIqM=;
        b=Lqrhzhb6R6U+HOL8yjGURFnJ7Xpz4sB6udEzV4q+yRVPpBkRw2u1lc1vvsVK2KBUXaQFbG
        WWCKwvylSVhBq10KIZ+ajYfi0JwI9MEJVH0E+PU1cd4DhQLoKdam1YwUOX0b/iz7JaoG19
        6OAhmEoMFsLl8jnlxO9s+3vXm7vkSJcBGXrXgkx5D1yO3UCYmnPhOJNvZHuGjtefwgfE0g
        /+7Yeoqbgvk8ZkZY+xL2aCcdjhSJ6jQeRrMuvHEvogSZYw/TnaHu78CgqgEAEiIUFX2CH0
        zI/S+RgDsJFkj0yUlDQb6gyO0NdZpE4G/Rir28hdlBrOg7yuTjH0SRdw23f38A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617694527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VrVbOO4b9Ber4GqFXFXFHTaJP3U7jex5+rXuxCcYIqM=;
        b=OCCTwL3vILBxyHwz4HmHL+lRUS5q5YcYFdc8oJJt6ppAPEHXOo5lfoByIRRC08KZytyZJj
        8oGZX1pVfi6URUAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net v3] net: hsr: Reset MAC header for Tx path
Date:   Tue,  6 Apr 2021 09:35:09 +0200
Message-Id: <20210406073509.13734-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset MAC header in HSR Tx path. This is needed, because direct packet
transmission, e.g. by specifying PACKET_QDISC_BYPASS does not reset the MAC
header.

This has been observed using the following setup:

|$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
|$ ifconfig hsr0 up
|$ ./test hsr0

The test binary is using mmap'ed sockets and is specifying the
PACKET_QDISC_BYPASS socket option.

This patch resolves the following warning on a non-patched kernel:

|[  112.725394] ------------[ cut here ]------------
|[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
|[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)

The warning can be safely removed, because the other call sites of
hsr_forward_skb() make sure that the skb is prepared correctly.

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Changes since v2:

 * Move skb_reset_mac_header() to hsr_dev_xmit()
 * Remove HSR malformed frame warning

Changes since v1:

 * Move skb_reset_mac_header() to __dev_direct_xmit()
 * Add Fixes tag
 * Target net tree

Previous versions:

 * https://lkml.kernel.org/netdev/20210329071716.12235-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20210326154835.21296-1-kurt@linutronix.de/

net/hsr/hsr_device.c  | 1 +
 net/hsr/hsr_forward.c | 6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7444ec6e298e..bfcdc75fc01e 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -217,6 +217,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
+		skb_reset_mac_header(skb);
 		hsr_forward_skb(skb, master);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ed82a470b6e1..b218e4594009 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -555,12 +555,6 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 {
 	struct hsr_frame_info frame;
 
-	if (skb_mac_header(skb) != skb->data) {
-		WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
-			  __FILE__, __LINE__, port->dev->name);
-		goto out_drop;
-	}
-
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
 
-- 
2.20.1

