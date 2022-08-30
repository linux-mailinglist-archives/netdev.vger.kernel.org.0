Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193DE5A5C62
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiH3HDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiH3HDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:03:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF109DFA4;
        Tue, 30 Aug 2022 00:03:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y141so10471233pfb.7;
        Tue, 30 Aug 2022 00:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=P+sb9Ku8woiZSO8lvNnm4FCZUFPAW73ZlQftiOI/Zus=;
        b=OEw3+guJoCnoto/64sdCSG4gz1yFKLp9/hy8fRnMHY+gIm2POkhKA9CX1nHQ3s8m6g
         Lck7fa13vgbUEbl/qE/LtlSuEn7M8JTsV0WDj3SsQK8pvm267kO3tK00PGMFdhez+ANt
         6OFjgY16Hs1OP33boCPlpqJP3ePO2sf+lB7z4EHiHaK8EBQcyll76p5YfS8PMlU6rLtA
         Om+phS5zP2xuQrYAMgY6dE73KVxqNmHkA24bZtFIg9XuKVpSrVjk3izTL4Siz+HvO+J0
         HMlMBUYihpkZiQawWaM3efIn0d+yEdoYj1fgxFpOpdKH8r974RVP0mFfVyaPelKoQOqt
         q/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=P+sb9Ku8woiZSO8lvNnm4FCZUFPAW73ZlQftiOI/Zus=;
        b=Gp9pQp4rKey1YVBjJhLpAaC9Aye5PU4i98Y6NlSN9QyVkoeRiwQoY6wZPq0HBDSFhJ
         52OIHrC814gNS+tslit0QgHh+cssTS/3eJvJq+kEuo1IEn91dVXckCSeRpF82ZqVz7zp
         0v0XPbZ8YrkLmrHzgvY0fL8Ztj3xGJbgoEVEcrVGBYUNY/ec/Dz7otuHrG1xr+mU44JH
         yMgh0qlCZ8+N3LCqShxzDFCoxJ+NmpBVPdFj8HLFCAtudSzCzlF6JiRZbC/qYaeY6h+b
         jwbg/o+4ZPQ4IICYAJVRegWCxJbPWSWtLjVv5ZbgBORIyvAq1HKxHPtCLBKueoXEAnAN
         XiRA==
X-Gm-Message-State: ACgBeo0806RDznnC/X1hhmR+JrcVX6M5zhuk3hByXBtiDT0BsesFjEMi
        3WPhzOSlihU0i3y79tWsfxE=
X-Google-Smtp-Source: AA6agR4N6BzPNq3P6D/IwXVxMBqtIkdYQ03y8+U6V2V+FkrtnlyCCXcRI3ouKAja60bzu+Cr+t1pIQ==
X-Received: by 2002:a63:491f:0:b0:41d:89d5:b3e7 with SMTP id w31-20020a63491f000000b0041d89d5b3e7mr16896017pga.18.1661843027489;
        Tue, 30 Aug 2022 00:03:47 -0700 (PDT)
Received: from localhost.localdomain ([150.109.151.50])
        by smtp.gmail.com with ESMTPSA id o186-20020a62cdc3000000b005289a50e4c2sm8473221pfg.23.2022.08.30.00.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:03:47 -0700 (PDT)
From:   Haimin Zhang <tcs.kernel@gmail.com>
X-Google-Original-From: Haimin Zhang <tcs_kernel@tencent.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH V2] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Tue, 30 Aug 2022 15:03:39 +0800
Message-Id: <20220830070339.494695-1-tcs_kernel@tencent.com>
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

We should check the msg_namelen is not less than struct 
sockaddr_ieee802154 when addr_type is SHORT before calling 
ieee802154_addr_from_sa. So we define IEEE802154_MIN_NAMELEN.
And in function ieee802154_addr_from_sa, when 
addr_type is LONG, we check msg_namelen is not less than 
sizeof(struct sockaddr_ieee802154). Meanwhile we check in the 
beginning of function dgram_sendmsg.

Also fixed in raw_bind, dgram_bind, dgram_connect.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
 include/net/ieee802154_netdev.h |  9 ++++--
 net/ieee802154/socket.c         | 52 ++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c32..e1dc3fb02 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -165,8 +165,8 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
 	memcpy(raw, &temp, IEEE802154_ADDR_LEN);
 }
 
-static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
-					   const struct ieee802154_addr_sa *sa)
+static inline int ieee802154_addr_from_sa(struct ieee802154_addr *a,
+					   const struct ieee802154_addr_sa *sa, int len)
 {
 	a->mode = sa->addr_type;
 	a->pan_id = cpu_to_le16(sa->pan_id);
@@ -176,9 +176,14 @@ static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
 		a->short_addr = cpu_to_le16(sa->short_addr);
 		break;
 	case IEEE802154_ADDR_LONG:
+		if (len > sizeof(struct sockaddr_ieee802154))
+			return -EINVAL;
 		a->extended_addr = ieee802154_devaddr_from_raw(sa->hwaddr);
 		break;
+	default:
+		return -EINVAL;
 	}
+	return 0;
 }
 
 static inline void ieee802154_addr_to_sa(struct ieee802154_addr_sa *sa,
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 718fb77bb..4452aaf68 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -27,6 +27,10 @@
 #include <net/af_ieee802154.h>
 #include <net/ieee802154_netdev.h>
 
+#define IEEE802154_MIN_NAMELEN \
+	(offsetof(struct sockaddr_ieee802154, addr) + \
+	 offsetofend(struct ieee802154_addr_sa, short_addr))
+
 /* Utility function for families */
 static struct net_device*
 ieee802154_get_dev(struct net *net, const struct ieee802154_addr *addr)
@@ -200,7 +204,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
+	if (len < IEEE802154_MIN_NAMELEN)
 		return -EINVAL;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
@@ -209,7 +213,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 
 	lock_sock(sk);
 
-	ieee802154_addr_from_sa(&addr, &uaddr->addr);
+	err = ieee802154_addr_from_sa(&addr, &uaddr->addr, len);
+	if (err < 0)
+		goto out;
 	dev = ieee802154_get_dev(sock_net(sk), &addr);
 	if (!dev) {
 		err = -ENODEV;
@@ -493,13 +499,15 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	if (len < IEEE802154_MIN_NAMELEN)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
 		goto out;
 
-	ieee802154_addr_from_sa(&haddr, &addr->addr);
+	err = ieee802154_addr_from_sa(&haddr, &addr->addr, len);
+	if (err < 0)
+		goto out;
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);
 	if (!dev) {
 		err = -ENODEV;
@@ -564,7 +572,7 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
+	if (len < IEEE802154_MIN_NAMELEN)
 		return -EINVAL;
 
 	if (addr->family != AF_IEEE802154)
@@ -577,7 +585,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	ieee802154_addr_from_sa(&ro->dst_addr, &addr->addr);
+	err = ieee802154_addr_from_sa(&ro->dst_addr, &addr->addr, len);
+	if (err < 0)
+		goto out;
 	ro->connected = 1;
 
 out:
@@ -612,10 +622,22 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
+		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
+				 daddr, msg->msg_name);
+		err = ieee802154_addr_from_sa(&dst_addr, &daddr->addr,
+					      msg->msg_namelen);
+		if (err < 0)
+			return err;
+	} else {
+		if (!ro->connected)
+			return -EDESTADDRREQ;
+		dst_addr = ro->dst_addr;
+	}
 
 	if (!ro->bound)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
@@ -651,16 +673,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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

