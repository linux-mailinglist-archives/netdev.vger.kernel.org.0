Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9C94978C8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 07:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiAXGGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 01:06:17 -0500
Received: from mail-m963.mail.126.com ([123.126.96.3]:7284 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiAXGGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 01:06:16 -0500
X-Greylist: delayed 1843 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2022 01:06:15 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=XYu6s
        9Db7kDwGgFtgnHeOa8tOqzXQ7vZNh8M1bSmULw=; b=JPMQa4nMmlGb2AOLV6dyy
        aXWejwP88CrSyDPM4TwpN4We9MmD/jU6Q3hLkXJByvXD5kTZgXPdWeUBafnU1YV6
        UsbdeZPtC5/vNuxlOLhNfyHTe++KFHIbG0zM2/G7+p9p3tDV/7stxOQOVBeoY56s
        uRCqo/GeDCQ7bLSky4cyC0=
Received: from firebird.. (unknown [222.128.181.171])
        by smtp8 (Coremail) with SMTP id NORpCgAHetyAOu5hNla1Aw--.1441S2;
        Mon, 24 Jan 2022 13:34:57 +0800 (CST)
From:   kai zhang <zhangkaiheb@126.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kai zhang <zhangkaiheb@126.com>
Subject: [PATCH] net: fix duplicate logs of iptables TRACE target
Date:   Mon, 24 Jan 2022 05:34:55 +0000
Message-Id: <20220124053455.55858-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NORpCgAHetyAOu5hNla1Aw--.1441S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4xuF1xKFyDGw18tr43Wrg_yoW8Cw47pF
        98Kas8trs3Xr4jyFs7X3WUAr1rGwsxJrZxGFy3A34rKw4DtrWjga1Skryava1IvrsIgFW5
        XFWYvr4Yyws8Cw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zirb15UUUUU=
X-Originating-IP: [222.128.181.171]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi2QGS-lpEDTKOcgAAsp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Below configuration, mangle,filter and security tables have no rule:

There are 5 logs for incoming ssh packet:

kernel: [ 7018.727278] TRACE: raw:PREROUTING:policy:2 IN=enp9s0 ...
kernel: [ 7018.727304] TRACE: mangle:PREROUTING:policy:1 IN=enp9s0 ...
kernel: [ 7018.727327] TRACE: mangle:INPUT:policy:1 IN=enp9s0 ...
kernel: [ 7018.727343] TRACE: filter:INPUT:policy:1 IN=enp9s0 ...
kernel: [ 7018.727359] TRACE: security:INPUT:policy:1 IN=enp9s0 ...

Signed-off-by: kai zhang <zhangkaiheb@126.com>
---
 net/ipv4/netfilter/ip_tables.c  | 4 +++-
 net/ipv6/netfilter/ip6_tables.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2ed7c58b4..5f0e6096e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -304,9 +304,11 @@ ipt_do_table(void *priv,
 
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
 		/* The packet is traced: log it */
-		if (unlikely(skb->nf_trace))
+		if (unlikely(skb->nf_trace)) {
 			trace_packet(state->net, skb, hook, state->in,
 				     state->out, table->name, private, e);
+			nf_reset_trace(skb);
+		}
 #endif
 		/* Standard target? */
 		if (!t->u.kernel.target->target) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2d816277f..ae842a835 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -327,9 +327,11 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
 		/* The packet is traced: log it */
-		if (unlikely(skb->nf_trace))
+		if (unlikely(skb->nf_trace)) {
 			trace_packet(state->net, skb, hook, state->in,
 				     state->out, table->name, private, e);
+			nf_reset_trace(skb);
+		}
 #endif
 		/* Standard target? */
 		if (!t->u.kernel.target->target) {
-- 
2.30.2

