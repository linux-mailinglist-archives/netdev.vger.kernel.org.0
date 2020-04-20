Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E842F1B118F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgDTQ2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729168AbgDTQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:27:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F4EC061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so12933894wrv.10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kq+6zKl2kH0cdZeUWR+SDjo+s3qmvpnmlPh76+3u24A=;
        b=sUu/rdHw/fPlEmCW1DlreiCrXdxVfLYW0KZbW7Df5zDdNRAEnAX1TTi1jcmy6Txzxh
         9mVhvxQaeABcmqqgXJKIhFJeF2kw6SMS3oBs+SJBrfq4SjebvBRx6expuOJJXrpRhUge
         GAxPdvQnC6KRLKaOyMYPa6bdKr03YEEdXjLY8Itrmu+hhtNAQ21DunjMJTHrjl/IYxBg
         0JjqlTiT9rI9R4eRE+gsXP6hKjQLZMUcv/VLiaG2xe0UYhzXcSD8c1RIYiWnbYYM0B9T
         75Q8Si4JKe9bTqEKWXJXy+zrmNxXyVYrJH0/Ckw6Jb7Kuzdz8unfPG1ZVMp3tFVvKm5+
         5Qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kq+6zKl2kH0cdZeUWR+SDjo+s3qmvpnmlPh76+3u24A=;
        b=QJG4pPCVfPPmNPLFpJ98R3eW1UDSzkdj3BcsXvRl3XENB2YcO2fl+A1iA2WfkRY9Vj
         /bkQ8GLVDF95f2FcqaZ8H0AqdKRKa3OFt6bzmcQDIpo3sRliHsgnsII/tVUf99QNSu0O
         AnRc0L7K527m5OgbGHgm+fsdzme3TfJeGKOwON6lYlbdWnhvd+N7GJbOUQAMxp0uiFyW
         7kA96qiZ42eUH1bFeWgBMEwhCxX/hG8MGQCGnTtHYCKYVJEh13BA0ptaMUka0lNOKTPv
         izUkILN9yLLHxm3AJHOGIRdFLHN/C2+GMj7ZEVBs2iF6xihhruyHoUxlqSTKwqzuf6FE
         vUoA==
X-Gm-Message-State: AGi0PuYWjp+g24p9tAvyTmHLrqxhUVxM/Lpg7xh5A6sTsJ8E7LatZOzs
        i1/OT/20MxUDYyzHZQJXebE=
X-Google-Smtp-Source: APiQypLtN3fyAoDN56PPKCcsFprDwsZGCurPqycAuOEFxWwwjyT0jWc/OkZr4LAn7ekLNxJ/cW5LXg==
X-Received: by 2002:a5d:690a:: with SMTP id t10mr17758757wru.225.1587400071054;
        Mon, 20 Apr 2020 09:27:51 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id 185sm146245wmc.32.2020.04.20.09.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:27:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net-next 1/3] net: mscc: ocelot: support matching on EtherType
Date:   Mon, 20 Apr 2020 19:27:41 +0300
Message-Id: <20200420162743.15847-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420162743.15847-1-olteanv@gmail.com>
References: <20200420162743.15847-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently, the filter's protocol is ignored except for a few special
cases (IPv4 and IPv6).

The EtherType can be matched inside VCAP IS2 by using a MAC_ETYPE key.
So there are 2 cases in which EtherType matches are supported:

  - As part of a larger MAC_ETYPE rule, such as:

    tc filter add dev swp0 ingress protocol ip \
            flower skip_sw src_mac 42:be:24:9b:76:20 action drop

  - Standalone (matching on protocol only):

    tc filter add dev swp0 ingress protocol arp \
            flower skip_sw action drop

As before, if the protocol is not specified, is it implicitly "all" and
the EtherType mask in the MAC_ETYPE half key is set to zero.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 954cb67eeaa2..67f0f5455ff0 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -51,6 +51,8 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
+	u16 proto = ntohs(f->common.protocol);
+	bool match_protocol = true;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
@@ -71,7 +73,6 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
-		u16 proto = ntohs(f->common.protocol);
 
 		/* The hw support mac matches only for MAC_ETYPE key,
 		 * therefore if other matches(port, tcp flags, etc) are added
@@ -114,6 +115,7 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 				match.key->ip_proto;
 			ace->frame.ipv4.proto.mask[0] =
 				match.mask->ip_proto;
+			match_protocol = false;
 		}
 		if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
 			ace->type = OCELOT_ACE_TYPE_IPV6;
@@ -121,11 +123,12 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 				match.key->ip_proto;
 			ace->frame.ipv6.proto.mask[0] =
 				match.mask->ip_proto;
+			match_protocol = false;
 		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) &&
-	    ntohs(f->common.protocol) == ETH_P_IP) {
+	    proto == ETH_P_IP) {
 		struct flow_match_ipv4_addrs match;
 		u8 *tmp;
 
@@ -141,10 +144,11 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 
 		tmp = &ace->frame.ipv4.dip.mask.addr[0];
 		memcpy(tmp, &match.mask->dst, 4);
+		match_protocol = false;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) &&
-	    ntohs(f->common.protocol) == ETH_P_IPV6) {
+	    proto == ETH_P_IPV6) {
 		return -EOPNOTSUPP;
 	}
 
@@ -156,6 +160,7 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		ace->frame.ipv4.sport.mask = ntohs(match.mask->src);
 		ace->frame.ipv4.dport.value = ntohs(match.key->dst);
 		ace->frame.ipv4.dport.mask = ntohs(match.mask->dst);
+		match_protocol = false;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
@@ -167,9 +172,20 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		ace->vlan.vid.mask = match.mask->vlan_id;
 		ace->vlan.pcp.value[0] = match.key->vlan_priority;
 		ace->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		match_protocol = false;
 	}
 
 finished_key_parsing:
+	if (match_protocol && proto != ETH_P_ALL) {
+		/* TODO: support SNAP, LLC etc */
+		if (proto < ETH_P_802_3_MIN)
+			return -EOPNOTSUPP;
+		ace->type = OCELOT_ACE_TYPE_ETYPE;
+		*(u16 *)ace->frame.etype.etype.value = htons(proto);
+		*(u16 *)ace->frame.etype.etype.mask = 0xffff;
+	}
+	/* else, a rule of type OCELOT_ACE_TYPE_ANY is implicitly added */
+
 	ace->prio = f->common.prio;
 	ace->id = f->cookie;
 	return ocelot_flower_parse_action(f, ace);
-- 
2.17.1

