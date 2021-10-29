Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AB43F9B9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ2JYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJ2JYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 05:24:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D711AC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 02:22:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gn3so6820389pjb.0
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 02:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=H27WTWvMmCfTT7VRFQ1oIGC9zOXNStMn1mii9BR9lJ0=;
        b=fluSYY2IocvR8ZBjkWoUcL5IFeubRAafBzECt55fqK2T4ei0xeGuOQ1N2LF0OqwUei
         IPfgsJjHCvT1C9tcttKemtL3M4H2dfcAcuZ3F1gdcwJ8J3TuX5YHbuJ5DyLrkwwTq+n5
         fjhAgqkxUsf0VeFQn5b98knqI1R/mhcLc7xpkRbzggDGgi28eah//oq4sFKf91xyleT6
         srdR1kHY1fHRvnroOV3jDTmPnxRTYVN748IAOPEYhho3j2CQt3QPjFnSfb0VFVedsQff
         2m/Se9vgAvLNQ+rMuYkfLY6xVJFGw7MGCKS6n1ta9tYNUxVWzmqP6Bp+LVJ7cu2kxb/9
         wE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H27WTWvMmCfTT7VRFQ1oIGC9zOXNStMn1mii9BR9lJ0=;
        b=60FM5bSahMWgcFkbNW+b4MdMXV5AlnAwdoavU3x9RW0XQEBGMvBJaLCvo/19qDvM6G
         t5uuRd3MOHGnU3T2VdR4nTouJX5yNcFpOqhWonfDWdDFW1uNoE9Ja1lROcEXsi70V+Wb
         DMmm2hm7SdKM/32lLj1VJTpB95gg0uT0KodeL+U1QFXXYQIpW9g+BSqZS3ZwibXWVd0a
         C91XLs8xgM3wFjaFAnm2y23tqc+/snjeghL+RnYm3VeQ9cW1i3TyNbpjSTcjhOYbYxXv
         myxO8udnrINo1y2SKwNpIzK+nUH+FQ8wvOgylAcCP5jl1mz09ekBatJ7C114U1m4byAy
         Gi+g==
X-Gm-Message-State: AOAM5304lIbUZNoaz+MjF3z6/wnMS1uPO/mMjFkIDCeL6Q2ds2sDkNd/
        8hXXGmDF3+Tolj9674M+0zI=
X-Google-Smtp-Source: ABdhPJwdsI7JUhTzNoneNssMag1C7Np89BBBkLHll6MHnp211nXn6g4B+jf14tDOJGhrJUuXlQWflw==
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr1695885pjb.113.1635499331282;
        Fri, 29 Oct 2021 02:22:11 -0700 (PDT)
Received: from localhost.localdomain (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id k15sm3808995pff.150.2021.10.29.02.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 02:22:10 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        toshiaki.makita1@gmail.com
Subject: [PATCH net] cls_flower: Fix inability to match GRE/IPIP packets
Date:   Fri, 29 Oct 2021 09:21:41 +0000
Message-Id: <20211029092141.6924-1-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a packet of a new flow arrives in openvswitch kernel module, it dissects
the packet and passes the extracted flow key to ovs-vswtichd daemon. If hw-
offload configuration is enabled, the daemon creates a new TC flower entry to
bypass openvswitch kernel module for the flow (TC flower can also offload flows
to NICs but this time that does not matter).

In this processing flow, I found the following issue in cases of GRE/IPIP
packets.

When ovs_flow_key_extract() in openvswitch module parses a packet of a new
GRE (or IPIP) flow received on non-tunneling vports, it extracts information
of the outer IP header for ip_proto/src_ip/dst_ip match keys.

This means ovs-vswitchd creates a TC flower entry with IP protocol/addresses
match keys whose values are those of the outer IP header. OTOH, TC flower,
which uses flow_dissector (different parser from openvswitch module), extracts
information of the inner IP header.

The following flow is an example to describe the issue in more detail.

   <----------- Outer IP -----------------> <---------- Inner IP ---------->
  +----------+--------------+--------------+----------+----------+----------+
  | ip_proto | src_ip       | dst_ip       | ip_proto | src_ip   | dst_ip   |
  | 47 (GRE) | 192.168.10.1 | 192.168.10.2 | 6 (TCP)  | 10.0.0.1 | 10.0.0.2 |
  +----------+--------------+--------------+----------+----------+----------+

In this case, TC flower entry and extracted information are shown as below:

  - ovs-vswitchd creates TC flower entry with:
      - ip_proto: 47
      - src_ip: 192.168.10.1
      - dst_ip: 192.168.10.2

  - TC flower extracts below for IP header matches:
      - ip_proto: 6
      - src_ip: 10.0.0.1
      - dst_ip: 10.0.0.2

Thus, GRE or IPIP packets never match the TC flower entry, as each
dissector behaves differently.

IMHO, the behavior of TC flower (flow dissector) does not look correct,
as ip_proto/src_ip/dst_ip in TC flower match means the outermost IP
header information except for GRE/IPIP cases. This patch adds a new
flow_dissector flag FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP which skips
dissection of the encapsulated inner GRE/IPIP header in TC flower
classifier.

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 include/net/flow_dissector.h |  1 +
 net/core/flow_dissector.c    | 15 +++++++++++++++
 net/sched/cls_flower.c       |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0dbb..aa33e1092e2c 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -287,6 +287,7 @@ enum flow_dissector_key_id {
 #define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		BIT(0)
 #define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(1)
 #define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(2)
+#define FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP	BIT(3)
 
 struct flow_dissector_key {
 	enum flow_dissector_key_id key_id;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index bac0184cf3de..0d4bbf534c7d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1307,6 +1307,11 @@ bool __skb_flow_dissect(const struct net *net,
 
 	switch (ip_proto) {
 	case IPPROTO_GRE:
+		if (flags & FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP) {
+			fdret = FLOW_DISSECT_RET_OUT_GOOD;
+			break;
+		}
+
 		fdret = __skb_flow_dissect_gre(skb, key_control, flow_dissector,
 					       target_container, data,
 					       &proto, &nhoff, &hlen, flags);
@@ -1364,6 +1369,11 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 	case IPPROTO_IPIP:
+		if (flags & FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP) {
+			fdret = FLOW_DISSECT_RET_OUT_GOOD;
+			break;
+		}
+
 		proto = htons(ETH_P_IP);
 
 		key_control->flags |= FLOW_DIS_ENCAPSULATION;
@@ -1376,6 +1386,11 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 
 	case IPPROTO_IPV6:
+		if (flags & FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP) {
+			fdret = FLOW_DISSECT_RET_OUT_GOOD;
+			break;
+		}
+
 		proto = htons(ETH_P_IPV6);
 
 		key_control->flags |= FLOW_DIS_ENCAPSULATION;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eb6345a027e1..aab13ba11767 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -329,7 +329,8 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map),
 				    post_ct);
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
-		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
+		skb_flow_dissect(skb, &mask->dissector, &skb_key,
+				 FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
 
 		f = fl_mask_lookup(mask, &skb_key);
 		if (f && !tc_skip_sw(f->flags)) {
-- 
2.30.1 (Apple Git-130)

