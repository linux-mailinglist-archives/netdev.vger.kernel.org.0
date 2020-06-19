Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B9F2005AC
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbgFSJpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbgFSJpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 05:45:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF013C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 64so4194616pfv.11
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oneconvergence-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XSVy16fU9BTMGtWMzc5ICVRz6LkcJGA7uzuj4xyvtqw=;
        b=qOAtmDP0BBH2CB/68DQTtvqc/1VCvRxjZ/SdRj7la/mCGeVLt8Rc/3eCwwZUjkra0X
         enq9eO6y0uuTk+n/0CIAb0EVZZINlosUnXqlKrH50lt5y3lswZI5JF9XMBbFZ8WSDtB4
         DG8+0eX8onpVsePnJjY9S/dU1cmON0Up8ahu94JehHBli1WwGPYA4pRejC06lz+4krFG
         r/XD6JBdr3hpxyzoA1jFohmn6uK+NWOU/iaqBbPXzNaaG1+W+TP2us9YoCB7TsU2zpok
         oAn5P1NSHBYFXvJCdyM91jcpIOM5KcEiLl1zU4PJSWiaSZgGgSe1xGamTIUvG8oZgB4a
         sE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XSVy16fU9BTMGtWMzc5ICVRz6LkcJGA7uzuj4xyvtqw=;
        b=VFsHbQUZ9zcwILoBVUU7s2VYNTaDYwewaQq7zEh23dPTSlKQiDsJHDmThdZmcL+Gmc
         28OFIVE3EogkeHP7KcT5MPX5oUMIzIqBRfUWkeGBEWKlnK0HwDKTvfnCzab3BnOkQjHr
         nJR8mM8V4fT4fn3hsIByYTrmdgHdadDxUN6DkjqAmrWTf8qHIjDifSaVwVaIWTkF0zCD
         M0IM8RRBSWPioqHiYCPeuNX22Jp3mfuhP0GhD8uyXYbHAqKe+7tata8bCT5PFOg1wnug
         btt4By39DDnflgYUtAVzsqUjGL5DJgKawq49YG6aL22UjNHkuZTngDQygOTf7pv8s4XO
         4rYQ==
X-Gm-Message-State: AOAM531WzFjRm5Q3qOD/vQg3a3ex2vCPBJO5hxEzQ+QmTJYRvj1Vrqw+
        K3X1GWb6CObCFkt+zKhHXqs++Q==
X-Google-Smtp-Source: ABdhPJyf9V3/e7PAn78N07IN3NI7bcM2yUdzfNmnfqMvxmszh0Uj0xtE9FOCAtb/ZFzbgKcY04XyRA==
X-Received: by 2002:a63:935c:: with SMTP id w28mr2364230pgm.174.1592559936385;
        Fri, 19 Jun 2020 02:45:36 -0700 (PDT)
Received: from localhost.localdomain ([27.57.206.119])
        by smtp.gmail.com with ESMTPSA id m20sm5896306pfk.52.2020.06.19.02.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 02:45:36 -0700 (PDT)
From:   dsatish <satish.d@oneconvergence.com>
To:     davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        satish.d@oneconvergence.com, prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: [PATCH net-next 1/3] cls_flower: Set addr_type when ip mask is non-zero
Date:   Fri, 19 Jun 2020 15:11:54 +0530
Message-Id: <20200619094156.31184-2-satish.d@oneconvergence.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619094156.31184-1-satish.d@oneconvergence.com>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the address type in the flower key and mask structure only if
the mask is non-zero for IPv4 and IPv6 fields.

During classifying packet, address type is set based on mask dissector
of IPv4 and IPV6 keys, hence while inserting flow also addr type should
be set based on the mask availability.

This is required for the upcoming patch in OVS where OVS offloads all
the fields that are part of the flower key irrespective of whether the
mask for those fields are zero or nonzero.

Signed-off-by: Chandra Kesava <kesavac@gmail.com>
Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
---
 net/sched/cls_flower.c | 66 ++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b2da37286082..64b70d396397 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1422,6 +1422,26 @@ static int fl_set_key_ct(struct nlattr **tb,
 	return 0;
 }
 
+#define FL_KEY_MEMBER_OFFSET(member) offsetof(struct fl_flow_key, member)
+#define FL_KEY_MEMBER_SIZE(member) sizeof_field(struct fl_flow_key, member)
+
+#define FL_KEY_IS_MASKED(mask, member)					\
+	memchr_inv(((char *)mask) + FL_KEY_MEMBER_OFFSET(member),	\
+		   0, FL_KEY_MEMBER_SIZE(member))			\
+
+#define FL_KEY_SET(keys, cnt, id, member)				\
+	do {								\
+		keys[cnt].key_id = id;					\
+		keys[cnt].offset = FL_KEY_MEMBER_OFFSET(member);	\
+		cnt++;							\
+	} while (0)
+
+#define FL_KEY_SET_IF_MASKED(mask, keys, cnt, id, member)		\
+	do {								\
+		if (FL_KEY_IS_MASKED(mask, member))			\
+			FL_KEY_SET(keys, cnt, id, member);		\
+	} while (0)
+
 static int fl_set_key(struct net *net, struct nlattr **tb,
 		      struct fl_flow_key *key, struct fl_flow_key *mask,
 		      struct netlink_ext_ack *extack)
@@ -1484,23 +1504,27 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 	}
 
 	if (tb[TCA_FLOWER_KEY_IPV4_SRC] || tb[TCA_FLOWER_KEY_IPV4_DST]) {
-		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-		mask->control.addr_type = ~0;
 		fl_set_key_val(tb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
 			       &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
 			       sizeof(key->ipv4.src));
 		fl_set_key_val(tb, &key->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST,
 			       &mask->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST_MASK,
 			       sizeof(key->ipv4.dst));
+		if (FL_KEY_IS_MASKED(mask, ipv4)) {
+			key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+			mask->control.addr_type = ~0;
+		}
 	} else if (tb[TCA_FLOWER_KEY_IPV6_SRC] || tb[TCA_FLOWER_KEY_IPV6_DST]) {
-		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
-		mask->control.addr_type = ~0;
 		fl_set_key_val(tb, &key->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC,
 			       &mask->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC_MASK,
 			       sizeof(key->ipv6.src));
 		fl_set_key_val(tb, &key->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST,
 			       &mask->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST_MASK,
 			       sizeof(key->ipv6.dst));
+		if (FL_KEY_IS_MASKED(mask, ipv6)) {
+			key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+			mask->control.addr_type = ~0;
+		}
 	}
 
 	if (key->basic.ip_proto == IPPROTO_TCP) {
@@ -1581,8 +1605,6 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 
 	if (tb[TCA_FLOWER_KEY_ENC_IPV4_SRC] ||
 	    tb[TCA_FLOWER_KEY_ENC_IPV4_DST]) {
-		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-		mask->enc_control.addr_type = ~0;
 		fl_set_key_val(tb, &key->enc_ipv4.src,
 			       TCA_FLOWER_KEY_ENC_IPV4_SRC,
 			       &mask->enc_ipv4.src,
@@ -1593,12 +1615,15 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       &mask->enc_ipv4.dst,
 			       TCA_FLOWER_KEY_ENC_IPV4_DST_MASK,
 			       sizeof(key->enc_ipv4.dst));
+		if (FL_KEY_IS_MASKED(mask, enc_ipv4)) {
+			key->enc_control.addr_type =
+				FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+			mask->enc_control.addr_type = ~0;
+		}
 	}
 
 	if (tb[TCA_FLOWER_KEY_ENC_IPV6_SRC] ||
 	    tb[TCA_FLOWER_KEY_ENC_IPV6_DST]) {
-		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
-		mask->enc_control.addr_type = ~0;
 		fl_set_key_val(tb, &key->enc_ipv6.src,
 			       TCA_FLOWER_KEY_ENC_IPV6_SRC,
 			       &mask->enc_ipv6.src,
@@ -1609,6 +1634,11 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       &mask->enc_ipv6.dst,
 			       TCA_FLOWER_KEY_ENC_IPV6_DST_MASK,
 			       sizeof(key->enc_ipv6.dst));
+		if (FL_KEY_IS_MASKED(mask, enc_ipv6)) {
+			key->enc_control.addr_type =
+				FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+			mask->enc_control.addr_type = ~0;
+		}
 	}
 
 	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
@@ -1667,26 +1697,6 @@ static int fl_init_mask_hashtable(struct fl_flow_mask *mask)
 	return rhashtable_init(&mask->ht, &mask->filter_ht_params);
 }
 
-#define FL_KEY_MEMBER_OFFSET(member) offsetof(struct fl_flow_key, member)
-#define FL_KEY_MEMBER_SIZE(member) sizeof_field(struct fl_flow_key, member)
-
-#define FL_KEY_IS_MASKED(mask, member)						\
-	memchr_inv(((char *)mask) + FL_KEY_MEMBER_OFFSET(member),		\
-		   0, FL_KEY_MEMBER_SIZE(member))				\
-
-#define FL_KEY_SET(keys, cnt, id, member)					\
-	do {									\
-		keys[cnt].key_id = id;						\
-		keys[cnt].offset = FL_KEY_MEMBER_OFFSET(member);		\
-		cnt++;								\
-	} while(0);
-
-#define FL_KEY_SET_IF_MASKED(mask, keys, cnt, id, member)			\
-	do {									\
-		if (FL_KEY_IS_MASKED(mask, member))				\
-			FL_KEY_SET(keys, cnt, id, member);			\
-	} while(0);
-
 static void fl_init_dissector(struct flow_dissector *dissector,
 			      struct fl_flow_key *mask)
 {
-- 
2.17.1

