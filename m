Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA515B6A4
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 02:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgBMBYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 20:24:50 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:60443 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729369AbgBMBYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 20:24:50 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 20:24:39 EST
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 01D1BTKq030210;
        Thu, 13 Feb 2020 02:11:34 +0100
Received: from utente-Aspire-V3-572G.campusx-relay3.uniroma2.it (wireless-71-132.net.uniroma2.it [160.80.132.71])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id CDA2A120EC9;
        Thu, 13 Feb 2020 02:11:24 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1581556284; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mej9aNRLvDHBYp6C+0JEMnnGVNRirupCbZfr5nASbD0=;
        b=Z0eW+UeQcY7vNJ3q/mp4l3wkW4eZTOqHSIDqVFCsWfsoHQEJCzgN7bNU6NDvjI0C66uAO4
        m9es+uWM4cQXgHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1581556284; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mej9aNRLvDHBYp6C+0JEMnnGVNRirupCbZfr5nASbD0=;
        b=xfTb0kp+lIXL57nYuVAlIDZWofvoE5uGI9H366ObLsjxzi5OwvnDbSX8wnZjdBcGHYlIJa
        I/PvE7Lxz0d0fRc/T+S5KtVwpJSSCypcZwoyHaulMfyPmt2s1E2ncpIAiC0vcH3BCxAqm8
        KmBlhQNHLK9+B/Wy43ciaASXwsvl3XlI4bU1ychZ6jzH7OavtN42w44pwiEELNK3nHCLX1
        8+rb1vm0Du/x/vzAc5EGao7FN761lPyW0vx+WniggFLB8wnOtrYYlRBkHw6569T1PesgJi
        3hMOruhr1L7djVvZhh2wMbegCIwJQVK0vA6pUsBuMf0NbxUlm2bGaXJGMNPNgw==
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it,
        Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Subject: [net-next 2/2] Add support for SRv6 End.DT4 action
Date:   Thu, 13 Feb 2020 02:09:32 +0100
Message-Id: <20200213010932.11817-3-carmine.scarpitta@uniroma2.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SRv6 End.DT4 is defined in the SRv6 Network Programming doc within IETF [1].

End.DT4 is used to implement IPv4 L3VPN use-cases in multi-tenants
environments. It decapsulates the received packets and does IPv4 routing
lookup in the routing table of the tenant.

At JANOG44, LINE corporation presented their multi-tenant DC architecture
using SRv6 [2]. In the slides, they reported that the linux kernel is
missing the support of SRv6 End.DT4 action.

This patch adds support to SRv6 End.DT4 action.

The iproute2 part required for this action was already implemented along
with the other supported SRv6 actions [3].

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-08
[2] https://speakerdeck.com/line_developers/line-data-center-networking-with-srv6
[3] https://patchwork.ozlabs.org/patch/799837/

Signed-off-by: Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
Acked-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Acked-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
---
 net/ipv6/seg6_local.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 7cbc19731997..d54a921ea96d 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -151,6 +151,26 @@ static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
 	*daddr = *addr;
 }
 
+static int seg6_lookup_nexthop_v4(struct sk_buff *skb, u32 tbl_id)
+{
+	struct net *net = dev_net(skb->dev);
+	struct fib_result res;
+	struct iphdr *iph;
+	u8 tos;
+
+	iph = ip_hdr(skb);
+	tos = iph->tos & IPTOS_RT_MASK;
+
+	res.table = fib_get_table(net, tbl_id);
+	if (!res.table)
+		return -ENOENT;
+
+	skb_dst_drop(skb);
+
+	return ip_route_input_rcu(skb, iph->daddr, iph->saddr,
+				  tos, skb->dev, &res, true);
+}
+
 static int
 seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 			u32 tbl_id, bool local_delivery)
@@ -401,6 +421,30 @@ static int input_action_end_dx4(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+static int input_action_end_dt4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
+	int err;
+
+	if (!decap_and_validate(skb, IPPROTO_IPIP))
+		goto drop;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto drop;
+
+	skb_set_transport_header(skb, sizeof(struct iphdr));
+
+	err = seg6_lookup_nexthop_v4(skb, slwt->table);
+	if (err)
+		goto drop;
+
+	return dst_input(skb);
+
+drop:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
 static int input_action_end_dt6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
@@ -589,6 +633,11 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.attrs		= (1 << SEG6_LOCAL_NH4),
 		.input		= input_action_end_dx4,
 	},
+	{
+		.action		= SEG6_LOCAL_ACTION_END_DT4,
+		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.input		= input_action_end_dt4,
+	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
 		.attrs		= (1 << SEG6_LOCAL_TABLE),
-- 
2.17.1

