Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90AD133F60
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgAHKhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:37:34 -0500
Received: from a3.inai.de ([88.198.85.195]:35418 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgAHKhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 05:37:33 -0500
Received: by a3.inai.de (Postfix, from userid 65534)
        id 9F60958754CE2; Wed,  8 Jan 2020 11:37:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id DC90658742E69;
        Wed,  8 Jan 2020 11:37:26 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, kadlec@blackhole.kfki.hu,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Subject: [PATCH] netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
Date:   Wed,  8 Jan 2020 11:37:26 +0100
Message-Id: <20200108103726.32253-1-jengelh@inai.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108095938.3704-1-fw@strlen.de>
References: <20200108095938.3704-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set uadt functions assume lineno is never NULL, but it is in
case of ip_set_utest().

syzkaller managed to generate a netlink message that calls this with
LINENO attr present:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:hash_mac4_uadt+0x1bc/0x470 net/netfilter/ipset/ip_set_hash_mac.c:104
Call Trace:
 ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Fixes: a7b4f989a6294 ("netfilter: ipset: IP set core support")
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---

 "Pass a dummy lineno storage, its easier than patching all set
 implementations". This may be so, but that does not mean patching
 the implementations is much harder (does not even warrant running
 coccinelle), so I present this alternative patch.


 net/netfilter/ipset/ip_set_bitmap_ip.c       | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     | 2 +-
 net/netfilter/ipset/ip_set_hash_ip.c         | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipmac.c      | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 4 ++--
 net/netfilter/ipset/ip_set_hash_mac.c        | 2 +-
 net/netfilter/ipset/ip_set_hash_net.c        | 4 ++--
 net/netfilter/ipset/ip_set_hash_netiface.c   | 4 ++--
 net/netfilter/ipset/ip_set_hash_netnet.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_netport.c    | 4 ++--
 net/netfilter/ipset/ip_set_hash_netportnet.c | 4 ++--
 net/netfilter/ipset/ip_set_list_set.c        | 2 +-
 16 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index abe8f77d7d23..9403730ca686 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -137,7 +137,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret = 0;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP]))
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index b618713297da..b16ebdddca83 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -248,7 +248,7 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0;
 	int ret = 0;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP]))
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 23d6095cb196..cb22d85cef01 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -161,7 +161,7 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 	u16 port_to;
 	int ret = 0;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 5d6d68eaf6a9..1195ee3539fb 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -104,7 +104,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0, hosts;
 	int ret = 0;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP]))
@@ -238,7 +238,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP]))
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index eceb7bc4a93a..9a1dc251988e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -126,7 +126,7 @@ hash_ipmac4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
@@ -245,7 +245,7 @@ hash_ipmac6_uadt(struct ip_set *set, struct nlattr *tb[],
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index aba1df617d6e..6b975573db7c 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -103,7 +103,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip, ip_to = 0;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
@@ -228,7 +228,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 1ff228717e29..7cec674af6de 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -112,7 +112,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
@@ -270,7 +270,7 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index fa88afd812fa..9ea4b8119cbe 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -115,7 +115,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
@@ -281,7 +281,7 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index eef6ecfcb409..bf089de34330 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -169,7 +169,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
@@ -419,7 +419,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 0b61593165ef..6cfabfedc44f 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -100,7 +100,7 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_ETHER] ||
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 136cf0781d3a..3d74b249db7b 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -142,7 +142,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
@@ -308,7 +308,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..32fc8f794d6a 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -204,7 +204,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
@@ -416,7 +416,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index da4ef910b12d..789fc367476e 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -170,7 +170,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	hash_netnet4_init(&e);
@@ -401,7 +401,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	hash_netnet6_init(&e);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 34448df80fb9..292aeee525f9 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -162,7 +162,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
@@ -378,7 +378,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	u8 cidr;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 934c1712cba8..35c7b953507e 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -185,7 +185,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	hash_netportnet4_init(&e);
@@ -463,7 +463,7 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	bool with_ports = false;
 	int ret;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	hash_netportnet6_init(&e);
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index cd747c0962fd..36b544c488d1 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -353,7 +353,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set *s;
 	int ret = 0;
 
-	if (tb[IPSET_ATTR_LINENO])
+	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
 	if (unlikely(!tb[IPSET_ATTR_NAME] ||
-- 
2.24.1

