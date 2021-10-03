Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6708C420379
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJCSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:47:51 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39516 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhJCSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 14:47:44 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id B4EF0200BE5F;
        Sun,  3 Oct 2021 20:45:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B4EF0200BE5F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633286754;
        bh=fcu9UT/8GA9hWd0EcZQJxJQ9lQ39rm7HNYTQadPU768=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBseIlP8PTVW5PiKCDdoQoQMUIN4np6DD+gqCsi7g6k/wxtlFsut6hHbRC6KLO4lh
         QJLDwFKIaj8xA7LtlEkiPwpEf92TS74uHqc3OmkpxWN+k3EsQRUFUlHL7XDkBaBc6P
         fSoaO6Vhv7p5GG4127RqNbUTw3TkhLvmwzTl6BG2/eNo2AQ4N6zcPB5W6FUDtbTO27
         XIKUdQZiUXPQa/JW/fvZv7RAbPuKESuZd3uwmqDu9jTFq2aXini+fRV68qXhwmQmDK
         K9HouApnbN/jPTVdWZQ5SpHT0ERKp85TD3sZ2TCQXzTF00Ao899pMAM36D5RVdlAzX
         NCVBCvJVM6h+A==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 2/4] ipv6: ioam: Prerequisite patch for ioam6_iptunnel
Date:   Sun,  3 Oct 2021 20:45:37 +0200
Message-Id: <20211003184539.23629-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003184539.23629-1-justin.iurman@uliege.be>
References: <20211003184539.23629-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prerequisite patch provides some minor edits (alignments, renames) and a
minor modification inside a function to facilitate the next patch by using
existing nla_* functions.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6_iptunnel.c | 55 ++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f9ee04541c17..5d03101724b9 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -9,7 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/net.h>
-#include <linux/netlink.h>
 #include <linux/in6.h>
 #include <linux/ioam6.h>
 #include <linux/ioam6_iptunnel.h>
@@ -17,15 +16,16 @@
 #include <net/sock.h>
 #include <net/lwtunnel.h>
 #include <net/ioam6.h>
+#include <net/netlink.h>
 
 #define IOAM6_MASK_SHORT_FIELDS 0xff100000
 #define IOAM6_MASK_WIDE_FIELDS 0xe00000
 
 struct ioam6_lwt_encap {
-	struct ipv6_hopopt_hdr	eh;
-	u8			pad[2];	/* 2-octet padding for 4n-alignment */
-	struct ioam6_hdr	ioamh;
-	struct ioam6_trace_hdr	traceh;
+	struct ipv6_hopopt_hdr eh;
+	u8 pad[2];			/* 2-octet padding for 4n-alignment */
+	struct ioam6_hdr ioamh;
+	struct ioam6_trace_hdr traceh;
 } __packed;
 
 struct ioam6_lwt {
@@ -42,7 +42,7 @@ static struct ioam6_lwt_encap *ioam6_lwt_info(struct lwtunnel_state *lwt)
 	return &ioam6_lwt_state(lwt)->tuninfo;
 }
 
-static struct ioam6_trace_hdr *ioam6_trace(struct lwtunnel_state *lwt)
+static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
 {
 	return &(ioam6_lwt_state(lwt)->tuninfo.traceh);
 }
@@ -51,25 +51,6 @@ static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
 	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
 };
 
-static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
-			       struct ioam6_trace_hdr *trace)
-{
-	struct ioam6_trace_hdr *data;
-	struct nlattr *nla;
-	int len;
-
-	len = sizeof(*trace);
-
-	nla = nla_reserve(skb, attrtype, len);
-	if (!nla)
-		return -EMSGSIZE;
-
-	data = nla_data(nla);
-	memcpy(data, trace, len);
-
-	return 0;
-}
-
 static bool ioam6_validate_trace_hdr(struct ioam6_trace_hdr *trace)
 {
 	u32 fields;
@@ -231,36 +212,40 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 static int ioam6_fill_encap_info(struct sk_buff *skb,
 				 struct lwtunnel_state *lwtstate)
 {
-	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
+	struct ioam6_trace_hdr *trace;
+	int err;
 
-	if (nla_put_ioam6_trace(skb, IOAM6_IPTUNNEL_TRACE, trace))
-		return -EMSGSIZE;
+	trace = ioam6_lwt_trace(lwtstate);
+
+	err = nla_put(skb, IOAM6_IPTUNNEL_TRACE, sizeof(*trace), trace);
+	if (err)
+		return err;
 
 	return 0;
 }
 
 static int ioam6_encap_nlsize(struct lwtunnel_state *lwtstate)
 {
-	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
+	struct ioam6_trace_hdr *trace = ioam6_lwt_trace(lwtstate);
 
 	return nla_total_size(sizeof(*trace));
 }
 
 static int ioam6_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
 {
-	struct ioam6_trace_hdr *a_hdr = ioam6_trace(a);
-	struct ioam6_trace_hdr *b_hdr = ioam6_trace(b);
+	struct ioam6_trace_hdr *a_hdr = ioam6_lwt_trace(a);
+	struct ioam6_trace_hdr *b_hdr = ioam6_lwt_trace(b);
 
 	return (a_hdr->namespace_id != b_hdr->namespace_id);
 }
 
 static const struct lwtunnel_encap_ops ioam6_iptun_ops = {
-	.build_state	= ioam6_build_state,
+	.build_state		= ioam6_build_state,
 	.output		= ioam6_output,
-	.fill_encap	= ioam6_fill_encap_info,
+	.fill_encap		= ioam6_fill_encap_info,
 	.get_encap_size	= ioam6_encap_nlsize,
-	.cmp_encap	= ioam6_encap_cmp,
-	.owner		= THIS_MODULE,
+	.cmp_encap		= ioam6_encap_cmp,
+	.owner			= THIS_MODULE,
 };
 
 int __init ioam6_iptunnel_init(void)
-- 
2.25.1

