Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8410FBEA
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLCKns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:43:48 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39655 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLCKns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:43:48 -0500
Received: by mail-pf1-f194.google.com with SMTP id x28so1657357pfo.6
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 02:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6ZnhHi7K7xtYsCdxw+JUayvelYXGOWzs64a6QGNePwU=;
        b=lUQUm0zOlD+O+q66+d2qnYlXVwoM3t4adCrPJxbkNEQfbDfQ/Zk6sr4JQ02j3bzCMZ
         MxxqW8lemvvCtzKus6DtYcpR6EKjvTcMz3OsDxVjlvoPguus8plSMkZ2WRwd0/DOnQ33
         6E43bpgvwTxlSJkQasP+Iklk3hXAVtiH5drmjtJmQh3Q2KmAOqpQon0vEIAhyg4Ftn+Q
         csQVR/jriuxfybuviklRXpYGNNHKxGuYVqmO9zttBSRoec6TKfYHRrZQ/xuhkB+SFGgf
         c7pVIWqFTMSClQgdBqyAw7QZRQK1bASwNOz5RyS5Qtldnd9e2o5qv1NMToX6CGMJs0ye
         +q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6ZnhHi7K7xtYsCdxw+JUayvelYXGOWzs64a6QGNePwU=;
        b=H7wv6F+7bWyacpbl3tmkQn7ws7XgFJK69dW26H9l7sBaWvbuKbPhKYHHLF1DBPQkSU
         qj2Sib7hTpcK+8JMjNOwvxko0U9aGdLM2DkiaQ6hpZXdKn7cbIefSZA2xXw87KIjunQB
         zTWS5x+eAgsnNJwftIOhNiFljjM6bQLhlyzC8/o7I7o2ie9RmIqaCmGczwFCcufxBPUH
         cnxL0jgUYA8Rf+ZabFklk6o72baOc2iYPZaJw3w+yb1mYJFbaDByrPTJAuP6s7MI5KUk
         wBNnAIrdk+UInxjsjdVjKIc/rJgGqrskHa1Fg0MDVEoKv1jmLLksQzXyyxDQY3GfIDTL
         hIEg==
X-Gm-Message-State: APjAAAULh9kB6IUCpkrz8vQlTGAc+qvWS3fepN2+IPJUYcw+pMwfSufx
        xug7AUNACnthlK0dU9pmG6I=
X-Google-Smtp-Source: APXvYqw8+cR70Ut1J0DWrTAsVi3CrPPSLYtSSV8GihHW0bLbhI3Fd6MSiEG0TpmFkGK0ZinpjLXbSg==
X-Received: by 2002:a63:d501:: with SMTP id c1mr4525215pgg.356.1575369827574;
        Tue, 03 Dec 2019 02:43:47 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h5sm2534700pjc.9.2019.12.03.02.43.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Dec 2019 02:43:47 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net] cls_flower: Fix the behavior using port ranges with hw-offload
Date:   Tue,  3 Dec 2019 19:40:12 +0900
Message-Id: <20191203104012.59113-1-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent commit 5c72299fba9d ("net: sched: cls_flower: Classify
packets using port ranges") had added filtering based on port ranges
to tc flower. However the commit missed necessary changes in hw-offload
code, so the feature gave rise to generating incorrect offloaded flow
keys in NIC.

One more detailed example is below:

$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
  dst_port 100-200 action drop

With the setup above, an exact match filter with dst_port == 0 will be
installed in NIC by hw-offload. IOW, the NIC will have a rule which is
equivalent to the following one.

$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
  dst_port 0 action drop

The behavior was caused by the flow dissector which extracts packet
data into the flow key in the tc flower. More specifically, regardless
of exact match or specified port ranges, fl_init_dissector() set the
FLOW_DISSECTOR_KEY_PORTS flag in struct flow_dissector to extract port
numbers from skb in skb_flow_dissect() called by fl_classify(). Note
that device drivers received the same struct flow_dissector object as
used in skb_flow_dissect(). Thus, offloaded drivers could not identify
which of these is used because the FLOW_DISSECTOR_KEY_PORTS flag was
set to struct flow_dissector in either case.

This patch adds the new FLOW_DISSECTOR_KEY_PORTS_RANGE flag and the new
tp_range field in struct fl_flow_key to recognize which filters are applied
to offloaded drivers. At this point, when filters based on port ranges
passed to drivers, drivers return the EOPNOTSUPP error because they do
not support the feature (the newly created FLOW_DISSECTOR_KEY_PORTS_RANGE
flag).

Fixes: 5c72299fba9d ("net: sched: cls_flower: Classify packets using port ranges")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 include/net/flow_dissector.h |   1 +
 net/core/flow_dissector.c    |  37 ++++++++++----
 net/sched/cls_flower.c       | 118 ++++++++++++++++++++++++-------------------
 3 files changed, 95 insertions(+), 61 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index b8c20e9..d93017a 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -235,6 +235,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_IPV4_ADDRS, /* struct flow_dissector_key_ipv4_addrs */
 	FLOW_DISSECTOR_KEY_IPV6_ADDRS, /* struct flow_dissector_key_ipv6_addrs */
 	FLOW_DISSECTOR_KEY_PORTS, /* struct flow_dissector_key_ports */
+	FLOW_DISSECTOR_KEY_PORTS_RANGE, /* struct flow_dissector_key_ports */
 	FLOW_DISSECTOR_KEY_ICMP, /* struct flow_dissector_key_icmp */
 	FLOW_DISSECTOR_KEY_ETH_ADDRS, /* struct flow_dissector_key_eth_addrs */
 	FLOW_DISSECTOR_KEY_TIPC, /* struct flow_dissector_key_tipc */
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ca87165..69395b8 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -760,6 +760,31 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 }
 
 static void
+__skb_flow_dissect_ports(const struct sk_buff *skb,
+			 struct flow_dissector *flow_dissector,
+			 void *target_container, void *data, int nhoff,
+			 u8 ip_proto, int hlen)
+{
+	enum flow_dissector_key_id dissector_ports = FLOW_DISSECTOR_KEY_MAX;
+	struct flow_dissector_key_ports *key_ports;
+
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
+		dissector_ports = FLOW_DISSECTOR_KEY_PORTS;
+	else if (dissector_uses_key(flow_dissector,
+				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
+		dissector_ports = FLOW_DISSECTOR_KEY_PORTS_RANGE;
+
+	if (dissector_ports == FLOW_DISSECTOR_KEY_MAX)
+		return;
+
+	key_ports = skb_flow_dissector_target(flow_dissector,
+					      dissector_ports,
+					      target_container);
+	key_ports->ports = __skb_flow_get_ports(skb, nhoff, ip_proto,
+						data, hlen);
+}
+
+static void
 __skb_flow_dissect_ipv4(const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, void *data, const struct iphdr *iph)
@@ -928,7 +953,6 @@ bool __skb_flow_dissect(const struct net *net,
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
 	struct flow_dissector_key_addrs *key_addrs;
-	struct flow_dissector_key_ports *key_ports;
 	struct flow_dissector_key_tags *key_tags;
 	struct flow_dissector_key_vlan *key_vlan;
 	struct bpf_prog *attached = NULL;
@@ -1383,14 +1407,9 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
-	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS) &&
-	    !(key_control->flags & FLOW_DIS_IS_FRAGMENT)) {
-		key_ports = skb_flow_dissector_target(flow_dissector,
-						      FLOW_DISSECTOR_KEY_PORTS,
-						      target_container);
-		key_ports->ports = __skb_flow_get_ports(skb, nhoff, ip_proto,
-							data, hlen);
-	}
+	if (!(key_control->flags & FLOW_DIS_IS_FRAGMENT))
+		__skb_flow_dissect_ports(skb, flow_dissector, target_container,
+					 data, nhoff, ip_proto, hlen);
 
 	/* Process result of IP proto processing */
 	switch (fdret) {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c307ee1..6c68971 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -56,8 +56,13 @@ struct fl_flow_key {
 	struct flow_dissector_key_ip ip;
 	struct flow_dissector_key_ip enc_ip;
 	struct flow_dissector_key_enc_opts enc_opts;
-	struct flow_dissector_key_ports tp_min;
-	struct flow_dissector_key_ports tp_max;
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	} tp_range;
 	struct flow_dissector_key_ct ct;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
@@ -200,19 +205,19 @@ static bool fl_range_port_dst_cmp(struct cls_fl_filter *filter,
 {
 	__be16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_min.dst);
-	max_mask = htons(filter->mask->key.tp_max.dst);
-	min_val = htons(filter->key.tp_min.dst);
-	max_val = htons(filter->key.tp_max.dst);
+	min_mask = htons(filter->mask->key.tp_range.tp_min.dst);
+	max_mask = htons(filter->mask->key.tp_range.tp_max.dst);
+	min_val = htons(filter->key.tp_range.tp_min.dst);
+	max_val = htons(filter->key.tp_range.tp_max.dst);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp.dst) < min_val ||
-		    htons(key->tp.dst) > max_val)
+		if (htons(key->tp_range.tp.dst) < min_val ||
+		    htons(key->tp_range.tp.dst) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
-		mkey->tp_min.dst = filter->mkey.tp_min.dst;
-		mkey->tp_max.dst = filter->mkey.tp_max.dst;
+		mkey->tp_range.tp_min.dst = filter->mkey.tp_range.tp_min.dst;
+		mkey->tp_range.tp_max.dst = filter->mkey.tp_range.tp_max.dst;
 	}
 	return true;
 }
@@ -223,19 +228,19 @@ static bool fl_range_port_src_cmp(struct cls_fl_filter *filter,
 {
 	__be16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_min.src);
-	max_mask = htons(filter->mask->key.tp_max.src);
-	min_val = htons(filter->key.tp_min.src);
-	max_val = htons(filter->key.tp_max.src);
+	min_mask = htons(filter->mask->key.tp_range.tp_min.src);
+	max_mask = htons(filter->mask->key.tp_range.tp_max.src);
+	min_val = htons(filter->key.tp_range.tp_min.src);
+	max_val = htons(filter->key.tp_range.tp_max.src);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp.src) < min_val ||
-		    htons(key->tp.src) > max_val)
+		if (htons(key->tp_range.tp.src) < min_val ||
+		    htons(key->tp_range.tp.src) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
-		mkey->tp_min.src = filter->mkey.tp_min.src;
-		mkey->tp_max.src = filter->mkey.tp_max.src;
+		mkey->tp_range.tp_min.src = filter->mkey.tp_range.tp_min.src;
+		mkey->tp_range.tp_max.src = filter->mkey.tp_range.tp_max.src;
 	}
 	return true;
 }
@@ -734,23 +739,25 @@ static void fl_set_key_val(struct nlattr **tb,
 static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 				 struct fl_flow_key *mask)
 {
-	fl_set_key_val(tb, &key->tp_min.dst,
-		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_min.dst,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_min.dst));
-	fl_set_key_val(tb, &key->tp_max.dst,
-		       TCA_FLOWER_KEY_PORT_DST_MAX, &mask->tp_max.dst,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_max.dst));
-	fl_set_key_val(tb, &key->tp_min.src,
-		       TCA_FLOWER_KEY_PORT_SRC_MIN, &mask->tp_min.src,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_min.src));
-	fl_set_key_val(tb, &key->tp_max.src,
-		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_max.src,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_max.src));
-
-	if ((mask->tp_min.dst && mask->tp_max.dst &&
-	     htons(key->tp_max.dst) <= htons(key->tp_min.dst)) ||
-	     (mask->tp_min.src && mask->tp_max.src &&
-	      htons(key->tp_max.src) <= htons(key->tp_min.src)))
+	fl_set_key_val(tb, &key->tp_range.tp_min.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_range.tp_min.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.dst));
+	fl_set_key_val(tb, &key->tp_range.tp_max.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MAX, &mask->tp_range.tp_max.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.dst));
+	fl_set_key_val(tb, &key->tp_range.tp_min.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MIN, &mask->tp_range.tp_min.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.src));
+	fl_set_key_val(tb, &key->tp_range.tp_max.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
+
+	if ((mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
+	     htons(key->tp_range.tp_max.dst) <=
+		 htons(key->tp_range.tp_min.dst)) ||
+	    (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
+	     htons(key->tp_range.tp_max.src) <=
+		 htons(key->tp_range.tp_min.src)))
 		return -EINVAL;
 
 	return 0;
@@ -1509,9 +1516,10 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
-	if (FL_KEY_IS_MASKED(mask, tp) ||
-	    FL_KEY_IS_MASKED(mask, tp_min) || FL_KEY_IS_MASKED(mask, tp_max))
-		FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS_RANGE, tp_range);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_IP, ip);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
@@ -1560,8 +1568,10 @@ static struct fl_flow_mask *fl_create_new_mask(struct cls_fl_head *head,
 
 	fl_mask_copy(newmask, mask);
 
-	if ((newmask->key.tp_min.dst && newmask->key.tp_max.dst) ||
-	    (newmask->key.tp_min.src && newmask->key.tp_max.src))
+	if ((newmask->key.tp_range.tp_min.dst &&
+	     newmask->key.tp_range.tp_max.dst) ||
+	    (newmask->key.tp_range.tp_min.src &&
+	     newmask->key.tp_range.tp_max.src))
 		newmask->flags |= TCA_FLOWER_MASK_FLAGS_RANGE;
 
 	err = fl_init_mask_hashtable(newmask);
@@ -2159,18 +2169,22 @@ static int fl_dump_key_val(struct sk_buff *skb,
 static int fl_dump_key_port_range(struct sk_buff *skb, struct fl_flow_key *key,
 				  struct fl_flow_key *mask)
 {
-	if (fl_dump_key_val(skb, &key->tp_min.dst, TCA_FLOWER_KEY_PORT_DST_MIN,
-			    &mask->tp_min.dst, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_min.dst)) ||
-	    fl_dump_key_val(skb, &key->tp_max.dst, TCA_FLOWER_KEY_PORT_DST_MAX,
-			    &mask->tp_max.dst, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_max.dst)) ||
-	    fl_dump_key_val(skb, &key->tp_min.src, TCA_FLOWER_KEY_PORT_SRC_MIN,
-			    &mask->tp_min.src, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_min.src)) ||
-	    fl_dump_key_val(skb, &key->tp_max.src, TCA_FLOWER_KEY_PORT_SRC_MAX,
-			    &mask->tp_max.src, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_max.src)))
+	if (fl_dump_key_val(skb, &key->tp_range.tp_min.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MIN,
+			    &mask->tp_range.tp_min.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.dst)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_max.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MAX,
+			    &mask->tp_range.tp_max.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.dst)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_min.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MIN,
+			    &mask->tp_range.tp_min.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.src)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_max.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MAX,
+			    &mask->tp_range.tp_max.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.src)))
 		return -1;
 
 	return 0;
-- 
1.8.3.1

