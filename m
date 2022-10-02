Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27C5F2723
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 01:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJBXMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 19:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJBXMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 19:12:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE44056A;
        Sun,  2 Oct 2022 16:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22B45B80DAB;
        Sun,  2 Oct 2022 22:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F39EC433D6;
        Sun,  2 Oct 2022 22:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751170;
        bh=cQxfJ3qsYjvYJ9DIUiqLsyT626Q05v8l6z9zEIm+TSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLgaVMGcmu0yd5ZfHDZ3x740O7DDN4DUL4JeQfFk3nlENoXYVDpyDIQYmVF6zidSr
         VGLWSz5/kncDpn5bex38aMAO12+mFxoNTgxaTn29iz4GUkzL8AdGhP1wfK9qQeTNtc
         ZE0g5K0Nb4hpMeSjQ5oAXao8niBqUxh4qLIcI8ncjOdizaksAHukjzDrKjObX/P2rx
         vtlxBOQpEgFYO/g+MsPQc45/AdfbOIa2vj3nni2dCVVpRJFSbVgM5wod8cXuxiMNOz
         /Kklm7cxJhPwczWm7aRICP8nNVXLVN3gLkzuc2TPhf5laW6ENkOmufx67BKV5PE/bX
         Ij4SPkQA6tkqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, alex.aring@gmail.com,
        stefan@datenfreihafen.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/9] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Sun,  2 Oct 2022 18:52:33 -0400
Message-Id: <20221002225236.239675-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225236.239675-1-sashal@kernel.org>
References: <20221002225236.239675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit 94160108a70c8af17fa1484a37e05181c0e094af ]

There is uninit value bug in dgram_sendmsg function in
net/ieee802154/socket.c when the length of valid data pointed by the
msg->msg_name isn't verified.

We introducing a helper function ieee802154_sockaddr_check_size to
check namelen. First we check there is addr_type in ieee802154_addr_sa.
Then, we check namelen according to addr_type.

Also fixed in raw_bind, dgram_bind, dgram_connect.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ieee802154_netdev.h | 37 +++++++++++++++++++++++++++++
 net/ieee802154/socket.c         | 42 ++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..a8994f307fc3 100644
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
index 9a675ba0bf0a..a92b11999e5f 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -201,8 +201,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(uaddr, len);
+	if (err < 0)
+		return err;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
 	if (uaddr->family != AF_IEEE802154)
@@ -498,7 +499,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
@@ -569,8 +571,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
+		return err;
 
 	if (addr->family != AF_IEEE802154)
 		return -EINVAL;
@@ -609,6 +612,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -617,10 +621,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
@@ -656,16 +670,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
2.35.1

