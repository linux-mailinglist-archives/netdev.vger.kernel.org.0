Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740C24A9A77
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359155AbiBDN62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359164AbiBDN6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=huLoFadblEn2s3rt9PCLve07r8DRe9hm65RauLtf9Y8=;
        b=dlGE2ZyCPTnbdXXpZf/voWFK9TeQXQrFgW4MJVycGuC+rEvHh5t87C9ID67wxXpdYH3O6/
        1Av7kSqWDFF2uj3Wog2C5AIo5tgrqwOpwzAAeCCzzMR5pH8/WiQs9e1AZ5jrjKRz8pNPwm
        Igh3I7kOmtyAZAhhl9zc0gy1gGWYkbc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-Sl2TAusrNCyGaSGWGc33ug-1; Fri, 04 Feb 2022 08:58:20 -0500
X-MC-Unique: Sl2TAusrNCyGaSGWGc33ug-1
Received: by mail-wr1-f71.google.com with SMTP id e2-20020adfa442000000b001e2dd248341so592590wra.20
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=huLoFadblEn2s3rt9PCLve07r8DRe9hm65RauLtf9Y8=;
        b=yJc2GRdXCfQ2jaSEXBo+i+CCjmS33kxu453eqMz8eqQ2CHvgcqkel9vE5t+hano0X3
         Tc5Tq1Lf7as9b9jmUZ+6o/NU4rdOlYd6IzINMB3aRoJw07QckXgLJexWmYTu63otQdi+
         3bOrnZ2HozwBgqwch3t4FajUkBXreiI3QA5AUaImgjFPVtIK8IE884JxC1+I66CrPtWI
         V6s4BkNQPG27yyuawPlh+nl5PvD+1RFGsoNs1KXCbvOc1XPWkKIjjmkm6JKt0lIoOWd+
         g7NI5IxymfUxJ/8kqqPqWrzIARUOVwYXPBmA1vsq+mgTLggTtL1oGWFGU6qp7sQPSoeN
         4mNA==
X-Gm-Message-State: AOAM532feN9yqIDNI5qmMiuRjxdOfm9TrXgaxBl2NriLfZGAKQnm4xpR
        yZhuK+V2bBXuL60w9zgJjQYj7KPvjLVWkwlaU9E6QVSy6f8Bzij31c0/xfsyEzC6LRiFz5u4mAP
        FBII1dggN/KqWdLPx
X-Received: by 2002:adf:f750:: with SMTP id z16mr786425wrp.239.1643983099111;
        Fri, 04 Feb 2022 05:58:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9n7xqbaODP/c2niZ8sZmsya6PVRtmFseh5p6sdFV0nfmo3BUQb4qtexbScYv/kP0iTRNYQg==
X-Received: by 2002:adf:f750:: with SMTP id z16mr786414wrp.239.1643983098926;
        Fri, 04 Feb 2022 05:58:18 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id o14sm2280445wry.104.2022.02.04.05.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:18 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:58:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 3/4] ipv4: Reject routes specifying ECN bits in
 rtm_tos
Message-ID: <e59d6861e3c230c9fd1f24f116de38a73fa27773.1643981839.git.gnault@redhat.com>
References: <cover.1643981839.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the fc_tos field of fib_config, to
ensure IPv4 routes aren't influenced by ECN bits when configured with
non-zero rtm_tos.

Before this patch, IPv4 routes specifying an rtm_tos with some of the
ECN bits set were accepted. However they wouldn't work (never match) as
IPv4 normally clears the ECN bits with IPTOS_RT_MASK before doing a FIB
lookup (although a few buggy code paths don't).

After this patch, IPv4 routes specifying an rtm_tos with any ECN bit
set is rejected.

Note: IPv6 routes ignore rtm_tos altogether, any rtm_tos is accepted,
but treated as if it were 0.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
Shuah, FYI, this is the patch I was refering to in our discussion about
testing invalid tos values:
https://lore.kernel.org/netdev/20220202232555.GC15826@pc-4.home/

 include/net/ip_fib.h                     |  3 +-
 net/ipv4/fib_frontend.c                  | 11 +++-
 net/ipv4/fib_trie.c                      |  7 ++-
 tools/testing/selftests/net/fib_tests.sh | 76 ++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index c4297704bbcb..6a82bcb8813b 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <net/fib_notifier.h>
 #include <net/fib_rules.h>
+#include <net/inet_dscp.h>
 #include <net/inetpeer.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
@@ -24,7 +25,7 @@
 
 struct fib_config {
 	u8			fc_dst_len;
-	u8			fc_tos;
+	dscp_t			fc_dscp;
 	u8			fc_protocol;
 	u8			fc_scope;
 	u8			fc_type;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ec..c60e1d1ed2b0 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -32,6 +32,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -735,8 +736,16 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 	memset(cfg, 0, sizeof(*cfg));
 
 	rtm = nlmsg_data(nlh);
+
+	if (!inet_validate_dscp(rtm->rtm_tos)) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid dsfield (tos): ECN bits must be 0");
+		err = -EINVAL;
+		goto errout;
+	}
+	cfg->fc_dscp = inet_dsfield_to_dscp(rtm->rtm_tos);
+
 	cfg->fc_dst_len = rtm->rtm_dst_len;
-	cfg->fc_tos = rtm->rtm_tos;
 	cfg->fc_table = rtm->rtm_table;
 	cfg->fc_protocol = rtm->rtm_protocol;
 	cfg->fc_scope = rtm->rtm_scope;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f4256..d937eeebb812 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -61,6 +61,7 @@
 #include <linux/vmalloc.h>
 #include <linux/notifier.h>
 #include <net/net_namespace.h>
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -1210,9 +1211,9 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	struct fib_info *fi;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
-	u8 tos = cfg->fc_tos;
 	u32 key;
 	int err;
+	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1227,6 +1228,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		goto err;
 	}
 
+	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
 	l = fib_find_node(t, &tp, key);
 	fa = l ? fib_find_alias(&l->leaf, slen, tos, fi->fib_priority,
 				tb->tb_id, false) : NULL;
@@ -1703,8 +1705,8 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	struct key_vector *l, *tp;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
-	u8 tos = cfg->fc_tos;
 	u32 key;
+	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1715,6 +1717,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!l)
 		return -ESRCH;
 
+	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
 	fa = fib_find_alias(&l->leaf, slen, tos, 0, tb->tb_id, false);
 	if (!fa)
 		return -ESRCH;
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 996af1ae3d3d..bb73235976b3 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1447,6 +1447,81 @@ ipv4_local_rt_cache()
 	log_test $? 0 "Cached route removed from VRF port device"
 }
 
+ipv4_rt_dsfield()
+{
+	echo
+	echo "IPv4 route with dsfield tests"
+
+	run_cmd "$IP route flush 172.16.102.0/24"
+
+	# New routes should reject dsfield options that interfere with ECN
+	run_cmd "$IP route add 172.16.102.0/24 dsfield 0x01 via 172.16.101.2"
+	log_test $? 2 "Reject route with dsfield 0x01"
+
+	run_cmd "$IP route add 172.16.102.0/24 dsfield 0x02 via 172.16.101.2"
+	log_test $? 2 "Reject route with dsfield 0x02"
+
+	run_cmd "$IP route add 172.16.102.0/24 dsfield 0x03 via 172.16.101.2"
+	log_test $? 2 "Reject route with dsfield 0x03"
+
+	# A generic route that doesn't take DSCP into account
+	run_cmd "$IP route add 172.16.102.0/24 via 172.16.101.2"
+
+	# A more specific route for DSCP 0x10
+	run_cmd "$IP route add 172.16.102.0/24 dsfield 0x10 via 172.16.103.2"
+
+	# DSCP 0x10 should match the specific route, no matter the ECN bits
+	$IP route get fibmatch 172.16.102.1 dsfield 0x10 | \
+		grep -q "via 172.16.103.2"
+	log_test $? 0 "IPv4 route with DSCP and ECN:Not-ECT"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x11 | \
+		grep -q "via 172.16.103.2"
+	log_test $? 0 "IPv4 route with DSCP and ECN:ECT(1)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x12 | \
+		grep -q "via 172.16.103.2"
+	log_test $? 0 "IPv4 route with DSCP and ECN:ECT(0)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x13 | \
+		grep -q "via 172.16.103.2"
+	log_test $? 0 "IPv4 route with DSCP and ECN:CE"
+
+	# Unknown DSCP should match the generic route, no matter the ECN bits
+	$IP route get fibmatch 172.16.102.1 dsfield 0x14 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with unknown DSCP and ECN:Not-ECT"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x15 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with unknown DSCP and ECN:ECT(1)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x16 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with unknown DSCP and ECN:ECT(0)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x17 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with unknown DSCP and ECN:CE"
+
+	# Null DSCP should match the generic route, no matter the ECN bits
+	$IP route get fibmatch 172.16.102.1 dsfield 0x00 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with no DSCP and ECN:Not-ECT"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x01 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with no DSCP and ECN:ECT(1)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x02 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with no DSCP and ECN:ECT(0)"
+
+	$IP route get fibmatch 172.16.102.1 dsfield 0x03 | \
+		grep -q "via 172.16.101.2"
+	log_test $? 0 "IPv4 route with no DSCP and ECN:CE"
+}
+
 ipv4_route_test()
 {
 	route_setup
@@ -1454,6 +1529,7 @@ ipv4_route_test()
 	ipv4_rt_add
 	ipv4_rt_replace
 	ipv4_local_rt_cache
+	ipv4_rt_dsfield
 
 	route_cleanup
 }
-- 
2.21.3

