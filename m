Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C54E1C5CE9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgEEQFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgEEQFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:05:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:05:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x15so1097123pfa.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vq8zwCAErLzihDGK2/c4f9//dSFxtc0H7sJvqOXXN60=;
        b=IUaJSQVe+htR21tN+uNk1snni3EuxNhvfXRler/L8JTjuXKS43kK4pJJyUqBMcH2uZ
         VI6QTRoLxxZPo0ZIeAL2WUuKynI/ApL0f9CEsEWv0NoE9ZH6/FLYClouh1rHYvXeEF6M
         OgREf9svIixsaY9+Ne0oKF6h8tl8qhsHmrVQgNZHEhar+LHoz46noS6RZVsvW+vJx/FM
         HsL4hsclstts+NDFFIUVzEZo8ZBO5OgOLhiHDDFW4+YxE4dUAeWir3lscv1LcNcjUXG4
         N7AYkTRPH5uTn8XfNKLiM76TIY42f2nSIWQyyQaAvB0H6plFAenZzNGqIWGSAto+usKh
         KkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vq8zwCAErLzihDGK2/c4f9//dSFxtc0H7sJvqOXXN60=;
        b=itG8Q2/JkTm9AEmUkzP5LnVrClrdjc7h8X2GEEYh04RnWPRbxhrRSrLtK7b7P3NM2U
         KBOUAO2iIb6agxcsTot3MuAjcivtGz30gfXPBt+yuVTMd68OV186bckiCKWVHzNq/wO5
         V91OS7o34VWtWuMX7wUgbvahIt0LVWrUwXfBMf6ukjrjz+Ouo1qlIIrAhXeQeBquwUrO
         7TpEbBkfzVYpFw2SGkw8Er0GIlAZmF+T1sxfUJR+nHY+os47rlGk6/V8UhSUpownfpcp
         uju+ZA/ObOs5fBctlgjgtn2UmeSemj18ACtIpDPauCmZwGU3cHPtvx2KM/c6R/Q/RLvr
         1dAQ==
X-Gm-Message-State: AGi0PuamM774wZr0FwALdbAwN0WCpzqLbp7qamiBnX3DBC+n4lzTKN1y
        H8wtL0/n4iud9NMC37LCj5y3+qvD
X-Google-Smtp-Source: APiQypJyH8Iu1oXPo400g2viZ/jo4ghwS4R/nKaZUapBIQPGKrbXIPKFC00QMPYuZG2zO6pS72ABUQ==
X-Received: by 2002:a62:144b:: with SMTP id 72mr3880453pfu.246.1588694733128;
        Tue, 05 May 2020 09:05:33 -0700 (PDT)
Received: from sc9-mailhost3.vmware.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id w186sm2458504pff.83.2020.05.05.09.05.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 09:05:32 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net
Subject: [PATCHv2] erspan: Add type I version 0 support.
Date:   Tue,  5 May 2020 09:05:06 -0700
Message-Id: <1588694706-26433-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The Type I ERSPAN frame format is based on the barebones
IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
Both type I and II use 0x88BE as protocol type. Unlike type II
and III, no sequence number or key is required.
To creat a type I erspan tunnel device:
  $ ip link add dev erspan11 type erspan \
            local 172.16.1.100 remote 172.16.1.200 \
            erspan_ver 0

Signed-off-by: William Tu <u9012063@gmail.com>
---
v2:
  remove the inline keyword, let compiler decide.
v1:
I didn't notice there is Type I when I did first erspan implementation
because it is not in the ietf draft 00 and 01. It's until recently I got
request for adding type I. Spec is below at draft 02:
https://tools.ietf.org/html/draft-foschiano-erspan-02#section-4.1

To verify with Wireshark, make sure you have:
commit ef76d65fc61d01c2ce5184140f4b1bba0019078b
Author: Guy Harris <guy@alum.mit.edu>
Date:   Mon Sep 30 16:35:35 2019 -0700

    Fix checks for "do we have an ERSPAN header?"
---
 include/net/erspan.h | 19 +++++++++++++++--
 net/ipv4/ip_gre.c    | 58 ++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/include/net/erspan.h b/include/net/erspan.h
index b39643ef4c95..0d9e86bd9893 100644
--- a/include/net/erspan.h
+++ b/include/net/erspan.h
@@ -2,7 +2,19 @@
 #define __LINUX_ERSPAN_H
 
 /*
- * GRE header for ERSPAN encapsulation (8 octets [34:41]) -- 8 bytes
+ * GRE header for ERSPAN type I encapsulation (4 octets [34:37])
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |0|0|0|0|0|00000|000000000|00000|    Protocol Type for ERSPAN   |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ *  The Type I ERSPAN frame format is based on the barebones IP + GRE
+ *  encapsulation (as described above) on top of the raw mirrored frame.
+ *  There is no extra ERSPAN header.
+ *
+ *
+ * GRE header for ERSPAN type II and II encapsulation (8 octets [34:41])
  *       0                   1                   2                   3
  *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@@ -43,7 +55,7 @@
  * |                  Platform Specific Info                       |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  *
- * GRE proto ERSPAN type II = 0x88BE, type III = 0x22EB
+ * GRE proto ERSPAN type I/II = 0x88BE, type III = 0x22EB
  */
 
 #include <uapi/linux/erspan.h>
@@ -139,6 +151,9 @@ static inline u8 get_hwid(const struct erspan_md2 *md2)
 
 static inline int erspan_hdr_len(int version)
 {
+	if (version == 0)
+		return 0;
+
 	return sizeof(struct erspan_base_hdr) +
 	       (version == 1 ? ERSPAN_V1_MDSIZE : ERSPAN_V2_MDSIZE);
 }
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 029b24eeafba..e29cd48674d7 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -248,6 +248,15 @@ static void gre_err(struct sk_buff *skb, u32 info)
 	ipgre_err(skb, info, &tpi);
 }
 
+static bool is_erspan_type1(int gre_hdr_len)
+{
+	/* Both ERSPAN type I (version 0) and type II (version 1) use
+	 * protocol 0x88BE, but the type I has only 4-byte GRE header,
+	 * while type II has 8-byte.
+	 */
+	return gre_hdr_len == 4;
+}
+
 static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		      int gre_hdr_len)
 {
@@ -262,17 +271,26 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	int len;
 
 	itn = net_generic(net, erspan_net_id);
-
 	iph = ip_hdr(skb);
-	ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
-	ver = ershdr->ver;
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
-				  tpi->flags | TUNNEL_KEY,
-				  iph->saddr, iph->daddr, tpi->key);
+	if (is_erspan_type1(gre_hdr_len)) {
+		ver = 0;
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
+					  tpi->flags | TUNNEL_NO_KEY,
+					  iph->saddr, iph->daddr, 0);
+	} else {
+		ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
+		ver = ershdr->ver;
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
+					  tpi->flags | TUNNEL_KEY,
+					  iph->saddr, iph->daddr, tpi->key);
+	}
 
 	if (tunnel) {
-		len = gre_hdr_len + erspan_hdr_len(ver);
+		if (is_erspan_type1(gre_hdr_len))
+			len = gre_hdr_len;
+		else
+			len = gre_hdr_len + erspan_hdr_len(ver);
+
 		if (unlikely(!pskb_may_pull(skb, len)))
 			return PACKET_REJECT;
 
@@ -665,7 +683,10 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 	}
 
 	/* Push ERSPAN header */
-	if (tunnel->erspan_ver == 1) {
+	if (tunnel->erspan_ver == 0) {
+		proto = htons(ETH_P_ERSPAN);
+		tunnel->parms.o_flags &= ~TUNNEL_SEQ;
+	} else if (tunnel->erspan_ver == 1) {
 		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
 				    tunnel->index,
 				    truncate, true);
@@ -1066,7 +1087,10 @@ static int erspan_validate(struct nlattr *tb[], struct nlattr *data[],
 	if (ret)
 		return ret;
 
-	/* ERSPAN should only have GRE sequence and key flag */
+	if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
+		return 0;
+
+	/* ERSPAN type II/III should only have GRE sequence and key flag */
 	if (data[IFLA_GRE_OFLAGS])
 		flags |= nla_get_be16(data[IFLA_GRE_OFLAGS]);
 	if (data[IFLA_GRE_IFLAGS])
@@ -1174,7 +1198,7 @@ static int erspan_netlink_parms(struct net_device *dev,
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
 
-		if (t->erspan_ver != 1 && t->erspan_ver != 2)
+		if (t->erspan_ver > 2)
 			return -EINVAL;
 	}
 
@@ -1259,7 +1283,11 @@ static int erspan_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
-	tunnel->tun_hlen = 8;
+	if (tunnel->erspan_ver == 0)
+		tunnel->tun_hlen = 4; /* 4-byte GRE hdr. */
+	else
+		tunnel->tun_hlen = 8; /* 8-byte GRE hdr. */
+
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
 		       erspan_hdr_len(tunnel->erspan_ver);
@@ -1456,8 +1484,8 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver == 1 || t->erspan_ver == 2) {
-		if (!t->collect_md)
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
 			o_flags |= TUNNEL_KEY;
 
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
@@ -1466,7 +1494,7 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		if (t->erspan_ver == 1) {
 			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
 				goto nla_put_failure;
-		} else {
+		} else if (t->erspan_ver == 2) {
 			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
 				goto nla_put_failure;
 			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-- 
2.7.4

