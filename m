Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C9D146087
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAWBmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgAWBmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:20 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C23E24673;
        Thu, 23 Jan 2020 01:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743740;
        bh=so29wlnT+j3VmOWq+H8zOVS6CfrmWIRdMsvZ9KITKLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3WL/kU2U9iFxdIQenexTltWB6O7ReZyaBpwVBQlxa71bwEze/WNaBOk2AknnDKEe
         VaTJZHl/mnHpQTZGjNo3xVqGZH9FhzV/NnnOOUirIAl9IY2FUwARdJYM4mP5cinGbx
         9zcCFuuHhevrx86SrjzZJRJIydMnMMmLxwqgJRCU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 04/12] net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
Date:   Wed, 22 Jan 2020 18:42:02 -0700
Message-Id: <20200123014210.38412-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

In skb generic path, we need a way to run XDP program on skb but
to have customized handling of XDP actions. netif_receive_generic_xdp
will be more helpful in such cases than do_xdp_generic.

This patch prepares netif_receive_generic_xdp() to be used as general
purpose function by renaming it and exporting as a general purpose
function. It will just run XDP program on skb but will not handle XDP
actions.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/dev.c            | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9cc326086f4..9c219796691c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3665,6 +3665,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index bf76dbee9d2a..3ba207b4ed79 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4461,9 +4461,8 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog)
 {
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
@@ -4574,6 +4573,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	return act;
 }
+EXPORT_SYMBOL_GPL(do_xdp_generic_core);
 
 /* When doing generic XDP we have to bypass the qdisc layer and the
  * network taps in order to match in-driver-XDP behavior.
@@ -4610,7 +4610,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 		u32 act;
 		int err;
 
-		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
 		if (act != XDP_PASS) {
 			switch (act) {
 			case XDP_REDIRECT:
-- 
2.21.1 (Apple Git-122.3)

