Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148E75B1CA1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiIHMTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiIHMTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:19:43 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA4413EBF;
        Thu,  8 Sep 2022 05:19:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id jm11so17605194plb.13;
        Thu, 08 Sep 2022 05:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=7PKq4MZv2IFLI2hRaHSRAsoSfQ2wA+Rq0DFFdoFY1mU=;
        b=ptpAf+B8TOlmihW3GRIVgOOobzp38VlL6uIJoQL9BO84EB6U81RGjzeNVHyxFPplNS
         PhICddqhs/p5/DLmhdPhM20OzTzSXiMv9ZkvG39m8i/aQejDTBmTR+9WwPf5P7ALJFAs
         ptDMJjdsiaSth+Yt9A6ufZW9O5jIiovT0LIrbGfrVkupGKdUy2g81Nn933MFjOro0Akz
         PI0Bz/lWDEZ1ksZJaruXmnA6pOOgQQ8Os2qkM/Kmqn2BbC4TWDdimUkRX+DL5050EFiu
         WdHXBEXUpgYarJr319Q04Oq+rZ4+YP7YziPv6PhEVV/NFTqiz67+oM1hgkDX3abTiJqF
         J7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=7PKq4MZv2IFLI2hRaHSRAsoSfQ2wA+Rq0DFFdoFY1mU=;
        b=vpuMTjAm7pSCmKBelzVtHKce5VkXFWBF3XrrPQRnVNfZ2ULc2qQijDcmoMmU/fpv4C
         S1INY2i8sDX2i6FBK+PjJCxQOfm2Z0kByRQ68Hh1g/cb6TJV8cLKLRz6jWGjBx4zwAfx
         HhLnrZxnVGlqOFalR+OyYl3v+4QiIu9tdbDO+j1GVjjtYPB9wAXeUpZe5BQb6QGGvcE8
         XsUz1XrmhL8VDuQJXC5/DBxUiZ/03sF63DR7UMkoB8h9rED/lZfMX3l/Cc/0XoI7wNyQ
         kIXRrti3/e5JWutTs4tGZND8fC4sztflfnCidh55zFUhxpzLvFJBKFmsOAbzKZ2EItjv
         Ch5Q==
X-Gm-Message-State: ACgBeo18RoHrl0QfvfzkJ7lFVtNCWi9ru45YwN5oBz+gCep2Tnq/i4S9
        C3W0+NLdRfQr31a/PRtzATT9RN6OZSb6eg==
X-Google-Smtp-Source: AA6agR6K+qjp/CPtBcZE5AVRQHDrEnz+6gdELLjdwlgT1FIikaNCRAtgs5CL6hHPtlKKDkjg4HUF0g==
X-Received: by 2002:a17:902:e312:b0:176:9348:1f6e with SMTP id q18-20020a170902e31200b0017693481f6emr8836314plc.14.1662639582277;
        Thu, 08 Sep 2022 05:19:42 -0700 (PDT)
Received: from localhost.localdomain ([150.109.151.50])
        by smtp.gmail.com with ESMTPSA id b16-20020a63d310000000b0042b5b036da4sm12477916pgg.68.2022.09.08.05.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:19:42 -0700 (PDT)
From:   Haimin Zhang <tcs.kernel@gmail.com>
X-Google-Original-From: Haimin Zhang <tcs_kernel@tencent.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH V3] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Thu,  8 Sep 2022 20:19:27 +0800
Message-Id: <20220908121927.3074843-1-tcs_kernel@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is uninit value bug in dgram_sendmsg function in
net/ieee802154/socket.c when the length of valid data pointed by the
msg->msg_name isn't verified.

We introducing a helper function ieee802154_sockaddr_check_size to 
check namelen. First we check there is addr_type in ieee802154_addr_sa.
Then, we check namelen according to addr_type.

Also fixed in raw_bind, dgram_bind, dgram_connect.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
 include/net/ieee802154_netdev.h | 37 +++++++++++++++++++++++++++++
 net/ieee802154/socket.c         | 42 ++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c32..a8994f307 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -15,6 +15,22 @@
 #ifndef IEEE802154_NETDEVICE_H
 #define IEEE802154_NETDEVICE_H
 
+#define IEEE802154_REQUIRED_SIZE(struct_type, member) \
+	(offsetof(typeof(struct_type), member) + \
+	sizeof(((typeof(struct_type) *)(NULL))->member))
+
+#define IEEE802154_ADDR_OFFSET \
+	offsetof(typeof(struct sockaddr_ieee802154), addr)
+
+#define IEEE802154_MIN_NAMELEN (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, addr_type))
+
+#define IEEE802154_NAMELEN_SHORT (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, short_addr))
+
+#define IEEE802154_NAMELEN_LONG (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, hwaddr))
+
 #include <net/af_ieee802154.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
@@ -165,6 +181,27 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
 	memcpy(raw, &temp, IEEE802154_ADDR_LEN);
 }
 
+static inline int
+ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
+{
+	struct ieee802154_addr_sa *sa;
+
+	sa = &daddr->addr;
+	if (len < IEEE802154_MIN_NAMELEN)
+		return -EINVAL;
+	switch (sa->addr_type) {
+	case IEEE802154_ADDR_SHORT:
+		if (len < IEEE802154_NAMELEN_SHORT)
+			return -EINVAL;
+		break;
+	case IEEE802154_ADDR_LONG:
+		if (len < IEEE802154_NAMELEN_LONG)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
 					   const struct ieee802154_addr_sa *sa)
 {
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 718fb77bb..7889e1ef7 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -200,8 +200,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(uaddr, len);
+	if (err < 0)
+		return err;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
 	if (uaddr->family != AF_IEEE802154)
@@ -493,7 +494,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
@@ -564,8 +566,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
+		return err;
 
 	if (addr->family != AF_IEEE802154)
 		return -EINVAL;
@@ -604,6 +607,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -612,10 +616,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
-	if (!ro->connected && !msg->msg_name)
-		return -EDESTADDRREQ;
-	else if (ro->connected && msg->msg_name)
-		return -EISCONN;
+	if (msg->msg_name) {
+		if (ro->connected)
+			return -EISCONN;
+		if (msg->msg_namelen < IEEE802154_MIN_NAMELEN)
+			return -EINVAL;
+		err = ieee802154_sockaddr_check_size(daddr, msg->msg_namelen);
+		if (err < 0)
+			return err;
+		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
+	} else {
+		if (!ro->connected)
+			return -EDESTADDRREQ;
+		dst_addr = ro->dst_addr;
+	}
 
 	if (!ro->bound)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
@@ -651,16 +665,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	cb = mac_cb_init(skb);
 	cb->type = IEEE802154_FC_TYPE_DATA;
 	cb->ackreq = ro->want_ack;
-
-	if (msg->msg_name) {
-		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
-				 daddr, msg->msg_name);
-
-		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
-	} else {
-		dst_addr = ro->dst_addr;
-	}
-
 	cb->secen = ro->secen;
 	cb->secen_override = ro->secen_override;
 	cb->seclevel = ro->seclevel;
-- 
2.27.0

