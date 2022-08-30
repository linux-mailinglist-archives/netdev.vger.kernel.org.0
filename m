Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84B75A6264
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiH3Ls0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiH3LsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:48:25 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72265A832F;
        Tue, 30 Aug 2022 04:48:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r22so10444356pgm.5;
        Tue, 30 Aug 2022 04:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=UNxTL6CeWQB+DQ80rtz+AdW/LBYughSkJq6932n2y50=;
        b=foSFAcZz9dQ+Pcr8MwM1fcE0p/IclBS5/ZQJ8X9SkBLfkEn3gvp6f8+avCx6iag2VO
         ja06jQSSOVN2oKv1tsCfRxG0smAPlxMlgEff+1LLiSMIZSYY597L/lHA9MMdewDL1elw
         HJmD3lD0lWcy23roNmfmP6JqSILbgKlVYBx4XGk8hldwSZHrFFS3w0V/t9B54zjvYgwp
         SDNfTt66kdiobFDAljm3hqu3NWmgPpI8A0tnpKB0Lnf53C0m6vHVfKEfkRjbSh/Byy2m
         OpGpKSQePRDwVSAaOVqQCycdC4PClMhW3Jpv1VCb1mYu0AiTGNGE2Cetsyl6KCkHb4HZ
         MThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=UNxTL6CeWQB+DQ80rtz+AdW/LBYughSkJq6932n2y50=;
        b=NSF4xXoktE3DUW4K8imKgvUtHJ+qVt0eMXhhRESeVsDjH8PZPn14i4LB3xB8NNvaFj
         I5rFXG3PtwdOpshA0FVpAo1HDPfxJLGcmxLkeySEys9giXLErjqsapV+9NXt9OkNvZ8C
         4BefiqZN1h1Os5OEuXqlQsTkxM246+kpHbRPcHfpAFIuznTg/IRwBkcvxmKQTIZxPkIe
         khvxtSrp8STz59l4dhn2NnDh4K8F216fdiUXghIpKr7+EzmyQ7OBOzojZr6TJNK4ALBE
         8xSSn/SMnjPx4k6I9jYJxO8lxvV9+rIzx1lEA2E5R1VbW8ewXBDc2aMWzzmouCW4ODHv
         Uutg==
X-Gm-Message-State: ACgBeo38xn0AJWjdcDI1yIU8kFFAIBwyxKjHgd7+tNiXLDrSniK2qYfW
        hB/sE+tyjMNeNw8R3IQqtAk=
X-Google-Smtp-Source: AA6agR6ZLo8H0UMiseyuyjnDerXCr1rN3m7ZzqglCQxiSCsSuemScWlmw5ye8JCAx1purIx/n8UJGA==
X-Received: by 2002:a05:6a00:1c46:b0:538:2b27:dd7f with SMTP id s6-20020a056a001c4600b005382b27dd7fmr10474024pfw.30.1661860103999;
        Tue, 30 Aug 2022 04:48:23 -0700 (PDT)
Received: from localhost.localdomain ([150.109.151.50])
        by smtp.gmail.com with ESMTPSA id h6-20020aa79f46000000b0052d4b0d0c74sm9122778pfr.70.2022.08.30.04.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 04:48:23 -0700 (PDT)
From:   Haimin Zhang <tcs.kernel@gmail.com>
X-Google-Original-From: Haimin Zhang <tcs_kernel@tencent.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH V2] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Tue, 30 Aug 2022 19:48:18 +0800
Message-Id: <20220830114818.955255-1-tcs_kernel@tencent.com>
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
 net/ieee802154/socket.c         | 51 ++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 22 deletions(-)

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
index 718fb77bb..f598a0241 100644
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
@@ -604,6 +614,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154 *, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -612,10 +623,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
@@ -651,16 +672,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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

