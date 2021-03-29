Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60E434C4BA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhC2HR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC2HRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 03:17:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70124C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 00:17:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617002257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L5HIuVkKF0vPezJj4rSN8aS2kKQ7urzwesU2/hUKJmg=;
        b=zDxAoQ0mh/FuJhnof5/pW9bE66a1vbugq1AYRbc8wHjTvfVeMFUrHKCNlPekHQvu+/u3j2
        42h9ST4yWauVj4AjgYm1ZjGMfcblZSzgqgT0vvLqDdmk2N3lIJagZKe+73NzgCLP20ckLb
        LcJNpdy1hHIrD7a3N6UGQevtQj1ZycXvcxjU2XPmth5FyQf+8PrEX8zcFX7mRTtogqVIHZ
        x7wyl6QuHpmfMiiU+8BPie1nDv5A8xy3hK5F5TQDv7+QnDZYhPBrWKToHVSq+UGhAubQDe
        q12+jpi+cSd0FvtO0lG9wMk7gIQPwni1BPi77Wvkm5Z9FhpH7SC3S3Zh2gOfIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617002257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L5HIuVkKF0vPezJj4rSN8aS2kKQ7urzwesU2/hUKJmg=;
        b=7N02Vozi9VBf+1biWa1UnHzDuyS+hN3bLrRhhNt7CVUATLeh/Ku2Jobhmaz3wZJRGRT4ME
        3BAXvDxxamU+YADw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net v2] net: Reset MAC header for direct packet transmission
Date:   Mon, 29 Mar 2021 09:17:16 +0200
Message-Id: <20210329071716.12235-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset MAC header in case of using dev_direct_xmit(), e.g. by specifying
PACKET_QDISC_BYPASS. This is needed, because other code such as the HSR layer
expects the MAC header to be correctly set.

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

The MAC header is also reset unconditionally in case of PACKET_QDISC_BYPASS is
not used at the top of __dev_queue_xmit().

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Changes since v1:

 * Move skb_reset_mac_header() to __dev_direct_xmit()
 * Add Fixes tag
 * Target net tree

Previous versions:

 * https://lkml.kernel.org/netdev/20210326154835.21296-1-kurt@linutronix.de/

net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b4c67a5be606..b5088223dc57 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4297,6 +4297,8 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 		     !netif_carrier_ok(dev)))
 		goto drop;
 
+	skb_reset_mac_header(skb);
+
 	skb = validate_xmit_skb_list(skb, dev, &again);
 	if (skb != orig_skb)
 		goto drop;
-- 
2.20.1

