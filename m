Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB832C38F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354290AbhCDAH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:07:58 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:53312 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450166AbhCCFbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 00:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=zTBYrG15e7+QyoK1Kg
        DxPUBW9X3cE5LArQdAaL4Uk44=; b=er4yaXjTtKtxY6+fJKTufcGu8fSnEtkM3w
        KBRDucwPvHpFyIKUcANoxz5lJB5j6+uzFGS87YkUbFLrj/apSXn9l0RpF+Gu4ZPO
        dec1sWPdjgXo6tMeqbpT+nn06a/4kwNlqP9tb0f/IZ/qq2TrHfrMYaLKJZuvl9CB
        X752zaQk4=
Received: from localhost.localdomain (unknown [222.128.173.240])
        by smtp10 (Coremail) with SMTP id NuRpCgBnhIcj3j5gGSY5lQ--.47531S4;
        Wed, 03 Mar 2021 08:53:56 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv6:delete duplicate code for reserved iid check
Date:   Wed,  3 Mar 2021 08:53:21 +0800
Message-Id: <20210303005321.29821-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgBnhIcj3j5gGSY5lQ--.47531S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFyxWF48Zr15Kr48Jry5Jwb_yoW5Cr4xpr
        13Jay5GrW8Cr17GrZ7Jr1jywnxu392y3WUGFy7WwsYkr1agr92vwn8X34ava4FyryfWanx
        tF90ka1F9FsxA3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U59N3UUUUU=
X-Originating-IP: [222.128.173.240]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi2QRK-lpEBAf-tgAAs9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the ipv6_reserved_interfaceid for interface id checking.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/addrconf.c | 45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f2337fb75..e9d13ce62 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -135,6 +135,7 @@ static inline void addrconf_sysctl_unregister(struct inet6_dev *idev)
 }
 #endif
 
+static bool ipv6_reserved_interfaceid(struct in6_addr address);
 static void ipv6_gen_rnd_iid(struct in6_addr *addr);
 
 static int ipv6_generate_eui64(u8 *eui, struct net_device *dev);
@@ -2352,32 +2353,12 @@ static int ipv6_inherit_eui64(u8 *eui, struct inet6_dev *idev)
 
 static void ipv6_gen_rnd_iid(struct in6_addr *addr)
 {
-regen:
-	get_random_bytes(&addr->s6_addr[8], 8);
-
-	/* <draft-ietf-6man-rfc4941bis-08.txt>, Section 3.3.1:
-	 * check if generated address is not inappropriate:
-	 *
-	 * - Reserved IPv6 Interface Identifers
-	 * - XXX: already assigned to an address on the device
-	 */
-
-	/* Subnet-router anycast: 0000:0000:0000:0000 */
-	if (!(addr->s6_addr32[2] | addr->s6_addr32[3]))
-		goto regen;
-
-	/* IANA Ethernet block: 0200:5EFF:FE00:0000-0200:5EFF:FE00:5212
-	 * Proxy Mobile IPv6:   0200:5EFF:FE00:5213
-	 * IANA Ethernet block: 0200:5EFF:FE00:5214-0200:5EFF:FEFF:FFFF
-	 */
-	if (ntohl(addr->s6_addr32[2]) == 0x02005eff &&
-	    (ntohl(addr->s6_addr32[3]) & 0Xff000000) == 0xfe000000)
-		goto regen;
+	struct in6_addr temp;
 
-	/* Reserved subnet anycast addresses */
-	if (ntohl(addr->s6_addr32[2]) == 0xfdffffff &&
-	    ntohl(addr->s6_addr32[3]) >= 0Xffffff80)
-		goto regen;
+	do {
+		get_random_bytes(&addr->s6_addr[8], 8);
+		temp = *addr;
+	} while (ipv6_reserved_interfaceid(temp));
 }
 
 /*
@@ -3189,15 +3170,27 @@ void addrconf_add_linklocal(struct inet6_dev *idev,
 }
 EXPORT_SYMBOL_GPL(addrconf_add_linklocal);
 
+/* <draft-ietf-6man-rfc4941bis-08.txt>, Section 3.3.1:
+ * check if generated address is not inappropriate:
+ *
+ * - Reserved IPv6 Interface Identifers
+ * - XXX: already assigned to an address on the device
+ */
 static bool ipv6_reserved_interfaceid(struct in6_addr address)
 {
+	/* Subnet-router anycast: 0000:0000:0000:0000 */
 	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
 		return true;
 
+	/* IANA Ethernet block: 0200:5EFF:FE00:0000-0200:5EFF:FE00:5212
+	 * Proxy Mobile IPv6:   0200:5EFF:FE00:5213
+	 * IANA Ethernet block: 0200:5EFF:FE00:5214-0200:5EFF:FEFF:FFFF
+	 */
 	if (address.s6_addr32[2] == htonl(0x02005eff) &&
-	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
+	    ((address.s6_addr32[3] & htonl(0xff000000)) == htonl(0xfe000000)))
 		return true;
 
+	/* Reserved subnet anycast addresses */
 	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
 	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
 		return true;
-- 
2.17.1

