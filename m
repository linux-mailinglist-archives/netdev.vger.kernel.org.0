Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDD3209DEC
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404622AbgFYLzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728063AbgFYLzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GyCVjS8LavJYzTtjsaGAZKXMsx/0KStkzJq3dfYbt4=;
        b=jH+e2480V7wuyhJC/bZoAHb++MviINYUzkq/R47cu+6gSNK+/8hfLs0PKqySEeNV4M8H33
        y43gOCjyNwtKktyeSGdpI2VNn0gImOohEUoGE2qiENnWg13Yguh2vrRW7sJzZfoOc1AphE
        NevEVpDNM3WVXnoyDpX3SCDClwkpBr8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-KZNwTZXvPpaQ8abadHxXcg-1; Thu, 25 Jun 2020 07:55:07 -0400
X-MC-Unique: KZNwTZXvPpaQ8abadHxXcg-1
Received: by mail-wm1-f71.google.com with SMTP id l2so6648561wmi.2
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+GyCVjS8LavJYzTtjsaGAZKXMsx/0KStkzJq3dfYbt4=;
        b=Slf8G9OFmVU/Ty8H/E1xyl32+bw9u1A5CTMM9tyxzhu2x1it9Tq7/tv2okm//j5TEk
         SrkLtOHytzy7yE9gP62Gkd8J91A6pJ2yH+RiWeLHRQrczvmLD0me3e3abx4lXHrv7Sh8
         6YEJJEWrcn6u3Bz+x5WSZlkuXDYW/f691xACDS0uGExFNQCL9hQZqW09aBDZF9bk7C0Z
         gIT5mRFOe8CnQdADyPBsFfH5ub98qpVytzOpOs8gPzYXU4/GH6YgLuV1ggzRK2GFnEGp
         oJ5UgKd0Y8cL2QljmHOTqEhLmvBe6NnQifq4QQj6ZI864RZGXvFclFDMF7ZWnyrw5kCa
         vokw==
X-Gm-Message-State: AOAM533ChfeBRtcge7H4SqtPl/ieExNYxUHzIwY4hKpYOoehVoYWaIUw
        GMpm9f32OYE/n4RkUk9jzihgRcFJY9tnvhrzBWR2F0WH6Qm5cGVga65C1Vkjnx1G3j4B3+Gsysf
        crgKtPINKti/RjAQs
X-Received: by 2002:adf:de12:: with SMTP id b18mr29199207wrm.390.1593086106426;
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzixQVDcysECuSK19xqNfgAFGxuWDWVR/lLk1obBH5HLClAUOnlT7+gODGTqff+OoDNWxACMw==
X-Received: by 2002:adf:de12:: with SMTP id b18mr29199182wrm.390.1593086106142;
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d24sm11573252wmb.45.2020.06.25.04.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F201B1814FA; Thu, 25 Jun 2020 13:55:03 +0200 (CEST)
Subject: [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the
 presence of VLAN tags
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:03 +0200
Message-ID: <159308610390.190211.17831843954243284203.stgit@toke.dk>
In-Reply-To: <159308610282.190211.9431406149182757758.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

CAKE was using the return value of tc_skb_protocol() and expecting it to be
the IP protocol type. This can fail in the presence of QinQ VLAN tags,
making CAKE unable to handle ECN marking and diffserv parsing in this case.
Fix this by implementing our own version of tc_skb_protocol(), which will
use skb->protocol directly, but also parse and skip over any VLAN tags and
return the inner protocol number instead.

Also fix CE marking by implementing a version of INET_ECN_set_ce() that
uses the same parsing routine.

Fixes: ea82511518f4 ("sch_cake: Add NAT awareness to packet classifier")
Fixes: b2100cc56fca ("sch_cake: Use tc_skb_protocol() helper for getting packet protocol")
Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
[ squash original two patches, rewrite commit message ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 60f8ae578819..0f594d88a957 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -497,6 +497,52 @@ static bool cobalt_queue_empty(struct cobalt_vars *vars,
 	return down;
 }
 
+static __be16 cake_skb_proto(const struct sk_buff *skb)
+{
+	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
+	__be16 proto = skb->protocol;
+	struct vlan_hdr vhdr, *vh;
+
+	while (proto == htons(ETH_P_8021Q) || proto == htons(ETH_P_8021AD)) {
+		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
+		if (!vh)
+			break;
+
+		proto = vh->h_vlan_encapsulated_proto;
+		offset += sizeof(vhdr);
+	}
+
+	return proto;
+}
+
+static int cake_set_ce(struct sk_buff *skb)
+{
+	int wlen = skb_network_offset(skb);
+
+	switch (cake_skb_proto(skb)) {
+	case htons(ETH_P_IP):
+		wlen += sizeof(struct iphdr);
+		if (!pskb_may_pull(skb, wlen) ||
+		    skb_try_make_writable(skb, wlen))
+			return 0;
+
+		return IP_ECN_set_ce(ip_hdr(skb));
+
+	case htons(ETH_P_IPV6):
+		wlen += sizeof(struct ipv6hdr);
+		if (!pskb_may_pull(skb, wlen) ||
+		    skb_try_make_writable(skb, wlen))
+			return 0;
+
+		return IP6_ECN_set_ce(skb, ipv6_hdr(skb));
+
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 /* Call this with a freshly dequeued packet for possible congestion marking.
  * Returns true as an instruction to drop the packet, false for delivery.
  */
@@ -549,7 +595,7 @@ static bool cobalt_should_drop(struct cobalt_vars *vars,
 
 	if (next_due && vars->dropping) {
 		/* Use ECN mark if possible, otherwise drop */
-		drop = !(vars->ecn_marked = INET_ECN_set_ce(skb));
+		drop = !(vars->ecn_marked = cake_set_ce(skb));
 
 		vars->count++;
 		if (!vars->count)
@@ -592,7 +638,7 @@ static bool cake_update_flowkeys(struct flow_keys *keys,
 	bool rev = !skb->_nfct, upd = false;
 	__be32 ip;
 
-	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
+	if (cake_skb_proto(skb) != htons(ETH_P_IP))
 		return false;
 
 	if (!nf_ct_get_tuple_skb(&tuple, skb))
@@ -1556,7 +1602,7 @@ static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
 	int wlen = skb_network_offset(skb);
 	u8 dscp;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (cake_skb_proto(skb)) {
 	case htons(ETH_P_IP):
 		wlen += sizeof(struct iphdr);
 		if (!pskb_may_pull(skb, wlen) ||

