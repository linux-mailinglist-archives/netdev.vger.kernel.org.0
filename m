Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221A11BB19B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgD0Wqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgD0Wqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:43 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B8D2192A;
        Mon, 27 Apr 2020 22:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027602;
        bh=dSDAO1S5SLNPuConi1L4Icd7VaiDQQr0sWuViwZX41s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiXSS9ubOKKQofDEnlaNUouLo6LmEwynhqkfsSwYG1dLG5IEhdlU1tmgEZ3jraRGX
         mOv+Q91mEuBxDnX1Pdjid/DpKDDKmYPRXabDXMdCeRPpHrr7KjRXc9bZEBS3waork1
         w85J9hSbc47gLEs4aibXTUx94DqXNJ4P+QoFEIOM=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 06/15] net: Rename do_xdp_generic to do_xdp_generic_rx
Date:   Mon, 27 Apr 2020 16:46:24 -0600
Message-Id: <20200427224633.15627-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200427224633.15627-1-dsahern@kernel.org>
References: <20200427224633.15627-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Rename do_xdp_generic to do_xdp_generic_rx to emphasize its use in the
Rx path.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 drivers/net/tun.c         | 4 ++--
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 7 ++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 44889eba1dbc..efe655d27661 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1898,7 +1898,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		rcu_read_lock();
 		xdp_prog = rcu_dereference(tun->xdp_prog);
 		if (xdp_prog) {
-			ret = do_xdp_generic(xdp_prog, skb);
+			ret = do_xdp_generic_rx(xdp_prog, skb);
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
@@ -2463,7 +2463,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_record_rx_queue(skb, tfile->queue_index);
 
 	if (skb_xdp) {
-		err = do_xdp_generic(xdp_prog, skb);
+		err = do_xdp_generic_rx(xdp_prog, skb);
 		if (err != XDP_PASS)
 			goto out;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ee0cb73ca18a..f4d24d9ea4f9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3714,7 +3714,7 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 }
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
-int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 88672ea4fc80..9a352ff32b72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4642,7 +4642,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 
 static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
-int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
+int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
 	if (xdp_prog) {
 		struct xdp_buff xdp;
@@ -4670,7 +4670,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 	kfree_skb(skb);
 	return XDP_DROP;
 }
-EXPORT_SYMBOL_GPL(do_xdp_generic);
+EXPORT_SYMBOL_GPL(do_xdp_generic_rx);
 
 static int netif_rx_internal(struct sk_buff *skb)
 {
@@ -5020,7 +5020,8 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		int ret2;
 
 		preempt_disable();
-		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		ret2 = do_xdp_generic_rx(rcu_dereference(skb->dev->xdp_prog),
+					 skb);
 		preempt_enable();
 
 		if (ret2 != XDP_PASS)
-- 
2.21.1 (Apple Git-122.3)

