Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84B229BC5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390078AbfEXQF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:05:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43035 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389888AbfEXQF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:05:57 -0400
Received: by mail-ed1-f68.google.com with SMTP id w33so11708872edb.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=bZY4LLv8CqltF2pmyoO+/RI0w4gOk7N8hkm5Tp1obbI=;
        b=qbR49NwP6wfK9+E/DWnP+E9vnNTMQfR1IsTrTZIqMcqCrF8jkTv2f618wrJgSehiwa
         0cC3akPMH2oPX1tNbX4SHaNq9V7e1oilcAM3XawYdsDL8t2POarJHniCGADzvHFw2isD
         227qxak+x3ohQgRe6YlCS7dIPCaFj0KcPBsslw1jABZBiGrCBARXHlspb8XUjep6eBHj
         7JkQuXLFofxDn7HWuRkt9nJJrrurjP8J3zWKPCv6jd8Wdl3gA6pZpCo0F0xS759NE7P8
         QbVqeKF4tfMRo8cuRdlxuh/anuq/4I6Bn1OOBl+i/haL3U5n30AdrlQhXNk/No8v8+MM
         qXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bZY4LLv8CqltF2pmyoO+/RI0w4gOk7N8hkm5Tp1obbI=;
        b=ZbcZamhhLkS7geBEcFpArB2dVW+8O1AFQ6bfdNEK+4jAfUwaMjvNnucKQmXSDfjwQn
         YsdfrEAUTDTwX7pMDtTfuU4nI1RyZ1nBRGhJtliqCMa3J5cTsvCSPU25Q770HW4ZTKzi
         GpRrJ20RUOnwYzortFKPWoV+0jvwlaqq6y2JDrFxAEM7TxjJ8bUjpoQVY5aCbI+TSnCa
         wJb9f5hKQ4YvwNbyx5NVT0Jba1R1Anf3FmCr5pNyxXm3WKBx5f5b9az2CIJzTEP6DUsk
         IHC/vQ49o9s9/MvCJ3CvrFXvKGLhQ3+g4ywhFw8MbVnQ2MMa8efOs7bgZG6JPl+9qDS0
         Pb/A==
X-Gm-Message-State: APjAAAUcEylDFVtdyGvFk4N758fMXgWpFPQy79YsDI6DM+Sbj7ocMDZg
        6YnI+5dDx4nu70tCSZ9kstvbaJPI4Yc=
X-Google-Smtp-Source: APXvYqyU4/3jBhR20gcVyM/So0c+ArJEnyjAOtayyeRnoXbo8iBAklQ2UzuOYOv+KsOGinyi5He/SQ==
X-Received: by 2002:aa7:c34f:: with SMTP id j15mr16785554edr.285.1558713954570;
        Fri, 24 May 2019 09:05:54 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u1sm426698ejz.92.2019.05.24.09.05.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 09:05:53 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org, jiri@mellanox.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 1/1] net: sched: protect against loops in TC filter hooks
Date:   Fri, 24 May 2019 17:05:46 +0100
Message-Id: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC hooks allow the application of filters and actions to packets at both
ingress and egress of the network stack. It is possible, with poor
configuration, that this can produce loops whereby an ingress hook calls
a mirred egress action that has an egress hook that redirects back to
the first ingress etc. The TC core classifier protects against loops when
doing reclassifies but, as yet, there is no protection against a packet
looping between multiple hooks. This can lead to stack overflow panics.

Add a per cpu counter that tracks recursion of packets through TC hooks.
The packet will be dropped if a recursive limit is passed and the counter
reset for the next packet.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/core/dev.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505..a6d9ed7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -154,6 +154,9 @@
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
 
+#define SCH_RECURSION_LIMIT	4
+static DEFINE_PER_CPU(int, sch_recursion_level);
+
 static DEFINE_SPINLOCK(ptype_lock);
 static DEFINE_SPINLOCK(offload_lock);
 struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
@@ -3598,16 +3601,42 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(dev_loopback_xmit);
 
+static inline int sch_check_inc_recur_level(void)
+{
+	int rec_level = __this_cpu_inc_return(sch_recursion_level);
+
+	if (rec_level >= SCH_RECURSION_LIMIT) {
+		net_warn_ratelimited("Recursion limit reached on TC datapath, probable configuration error\n");
+		return -ELOOP;
+	}
+
+	return 0;
+}
+
+static inline void sch_dec_recur_level(void)
+{
+	__this_cpu_dec(sch_recursion_level);
+}
+
 #ifdef CONFIG_NET_EGRESS
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
+	int err;
 
 	if (!miniq)
 		return skb;
 
+	err = sch_check_inc_recur_level();
+	if (err) {
+		sch_dec_recur_level();
+		*ret = NET_XMIT_DROP;
+		consume_skb(skb);
+		return NULL;
+	}
+
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
@@ -3620,22 +3649,26 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
 		kfree_skb(skb);
-		return NULL;
+		skb = NULL;
+		break;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		*ret = NET_XMIT_SUCCESS;
 		consume_skb(skb);
-		return NULL;
+		skb = NULL;
+		break;
 	case TC_ACT_REDIRECT:
 		/* No need to push/pop skb's mac_header here on egress! */
 		skb_do_redirect(skb);
 		*ret = NET_XMIT_SUCCESS;
-		return NULL;
+		skb = NULL;
+		break;
 	default:
 		break;
 	}
 
+	sch_dec_recur_level();
 	return skb;
 }
 #endif /* CONFIG_NET_EGRESS */
@@ -4670,6 +4703,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
 	struct tcf_result cl_res;
+	int err;
 
 	/* If there's at least one ingress present somewhere (so
 	 * we get here via enabled static key), remaining devices
@@ -4679,6 +4713,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	if (!miniq)
 		return skb;
 
+	err = sch_check_inc_recur_level();
+	if (err) {
+		sch_dec_recur_level();
+		*ret = NET_XMIT_DROP;
+		consume_skb(skb);
+		return NULL;
+	}
+
 	if (*pt_prev) {
 		*ret = deliver_skb(skb, *pt_prev, orig_dev);
 		*pt_prev = NULL;
@@ -4696,12 +4738,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		kfree_skb(skb);
-		return NULL;
+		skb = NULL;
+		break;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
-		return NULL;
+		skb = NULL;
+		break;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
 		 * we can safely push the L2 header back before
@@ -4709,14 +4753,18 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		 */
 		__skb_push(skb, skb->mac_len);
 		skb_do_redirect(skb);
-		return NULL;
+		skb = NULL;
+		break;
 	case TC_ACT_REINSERT:
 		/* this does not scrub the packet, and updates stats on error */
 		skb_tc_reinsert(skb, &cl_res);
-		return NULL;
+		skb = NULL;
+		break;
 	default:
 		break;
 	}
+
+	sch_dec_recur_level();
 #endif /* CONFIG_NET_CLS_ACT */
 	return skb;
 }
-- 
2.7.4

