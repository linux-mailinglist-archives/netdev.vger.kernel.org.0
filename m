Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CFE6F4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfD2PxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:53:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39246 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfD2PxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:53:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id h16so6803202qtk.6
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P18B8NxjrtFMmLzt/ONU7xpDChjUo3Hl7poqevrROOE=;
        b=hAtpDkUIgTTI5AgKy/PxKmJGKobLeJVAU3EX/YM/P4tqVnoto+N/PISKwC8bU2EzTJ
         BprIRHRFNmuEaEs9SV+kaV//vuBPlcx0bJr8IDZQPaygv5ZbHx+BvMkecHXCmeJEp35n
         5y8Uq7snOwFCGB0JDklXVshzAVcib3b6iqWglGHrJPVWt4LQP52/GbN7/N8sh7xnDqKL
         os5bR4C343JcWwdj0ZTqzFfeuMkJrfOPdPt8sPPqdsh85/oZ1uh/SVDynaK21MZYq9h1
         w4LtxZO5iv3AWFYlUNTOyCJYrBpXd+vus/0P+a47xDEuznKzAG5/JTvdl9L2GzdajaOI
         WzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P18B8NxjrtFMmLzt/ONU7xpDChjUo3Hl7poqevrROOE=;
        b=eiUsC/VlN8McM/kekaMn3D67Dd86lo2h3MlM5Auj/8GkyJ746a+KC6fws/VXulnVl3
         3etXkFHIjyvPza7XV0LqqdUZ7iv5mKOyXeuwh+nQj0GrS3x0FMhNSrgpEK/zttu2bPrj
         fqNCRNH1obGI/W1mwi5/e17c9Xa1QiWgj/o1LdFxzFQeaAJIvPOZHOadJr1ZIFAZELRL
         xET7ZhxJbuORwDRXMRvICB06z5W0IV3/wQvxBxSL7H3IAuxfhj27M4FewZmeSb/t7UNX
         mSi+1v/jU/CAo1h7oMwU0HXTvuKjA+UMsztFuEXSkcOHI4Z22595NEJPoWVtnZ6SspYz
         53hw==
X-Gm-Message-State: APjAAAVo9ekDcIn3RTEScbRI2M1klFmnQJFvCg82Xo8PsTxb1v1IEIRA
        kkfvyYl8OZKAqg575jiqTisiQnmy
X-Google-Smtp-Source: APXvYqzT0zRwpRzij2m1PBUyLNfpDJQdZVeW0uj9wKN6bXC89oyaJILH6LKnA3Ed6ubSX19I6Gg1Mw==
X-Received: by 2002:a0c:b505:: with SMTP id d5mr48806498qve.62.1556553201496;
        Mon, 29 Apr 2019 08:53:21 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id w185sm7275219qkd.46.2019.04.29.08.53.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 08:53:20 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, David.Laight@aculab.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2] packet: validate msg_namelen in send directly
Date:   Mon, 29 Apr 2019 11:53:18 -0400
Message-Id: <20190429155318.20433-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Packet sockets in datagram mode take a destination address. Verify its
length before passing to dev_hard_header.

Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
established behavior. Directly compare msg_namelen to dev->addr_len.

Change v1->v2: initialize addr in all paths

Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9419c5cf4de5e..a43876b374da2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2602,8 +2602,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	void *ph;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
 	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
+	unsigned char *addr = NULL;
 	int tp_len, size_max;
-	unsigned char *addr;
 	void *data;
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
@@ -2614,7 +2614,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-		addr	= NULL;
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2624,10 +2623,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 						sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_put;
+		if (po->sk.sk_socket->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_put;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;
@@ -2799,7 +2801,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	unsigned char *addr;
+	unsigned char *addr = NULL;
 	int err, reserve = 0;
 	struct sockcm_cookie sockc;
 	struct virtio_net_hdr vnet_hdr = { 0 };
@@ -2816,7 +2818,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-		addr	= NULL;
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2824,10 +2825,13 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_unlock;
+		if (sock->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_unlock;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;
-- 
2.21.0.593.g511ec345e18-goog

