Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B63199B9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 06:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBLF3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 00:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLF3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 00:29:45 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162EFC061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 21:29:05 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id x3so5982185qti.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 21:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDVIwGIYtxnJ9V1W3fHqmI3av5fJsNk1zYug6cZXsUY=;
        b=cimw3HJCGzURPy07YtKweEr4P9jPgYA3xfs4sAZl+6XlOHPhk3EvUL/JXJHxFC1zER
         2qYKJpFPdbEbrFbabc7VPVGr/UgHNHRVo94JPKuR5K+adBMlfyESdr2MN+jUaNxDC5qu
         E6yasiXvqG1N15JH3GZYjMapkxsuMifUPNEKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDVIwGIYtxnJ9V1W3fHqmI3av5fJsNk1zYug6cZXsUY=;
        b=odAmf9CLjlEkzmw66BBX1561xtuwyGn5HViMddbgp2Jfa2GSUQdaeZumdY+i1QQcZk
         YUccxetiSCLG3v1JwdQDKJnGG08Izn64JCAGjjO+T/P2Ymz7A3j9OercEPnKhxtUJ6Rc
         Ofxa5wQyMsRt/JkNAlOdepPfjIYgS/sT9bwIQf8akwG9QY3mDpORd2nEwpLxtCGomZmp
         VIDSZzogdhCs1xep/GxvLthHjU9JBQiJGeT37HmlaQ9M+OPz1tSQUjkOYDHuM0aQY3Hp
         DL6wVlK2+GK77mF9UUCITuhZYW8tzqL7S168yymETZwfsZo/s0/XjquOoPmI0fZ4C/pz
         4kmw==
X-Gm-Message-State: AOAM530OySDMR35kA49el7mr0R/1l1atPAJDq8hTc11jIuOkmd6A4cU4
        JBo+HiVrnDGFd/NM0X6OghJRC70Sbz069PAoCNA=
X-Google-Smtp-Source: ABdhPJxtkjXkC42lk1Y+h4vbTcSAw3QTRHvCjefPV8BjdWEEvz5Ohd8oGQ6F/OKoNuq+ueyuYBuavw==
X-Received: by 2002:ac8:7744:: with SMTP id g4mr1146885qtu.136.1613107744265;
        Thu, 11 Feb 2021 21:29:04 -0800 (PST)
Received: from localhost.localdomain (047-028-046-055.res.spectrum.com. [47.28.46.55])
        by smtp.gmail.com with ESMTPSA id x62sm5397918qkd.1.2021.02.11.21.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 21:29:03 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH] appletalk: Fix skb allocation size in loopback case
Date:   Thu, 11 Feb 2021 21:27:54 -0800
Message-Id: <20210212052754.11271-1-doug@schmorgal.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a DDP broadcast packet is sent out to a non-gateway target, it is
also looped back. There is a potential for the loopback device to have a
longer hardware header length than the original target route's device,
which can result in the skb not being created with enough room for the
loopback device's hardware header. This patch fixes the issue by
determining that a loopback will be necessary prior to allocating the
skb, and if so, ensuring the skb has enough room.

This was discovered while testing a new driver that creates a LocalTalk
network interface (LTALK_HLEN = 1). It caused an skb_under_panic.

Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 net/appletalk/ddp.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index ca1a0d07a087..ebda397fa95a 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1577,8 +1577,8 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct ddpehdr *ddp;
-	int size;
-	struct atalk_route *rt;
+	int size, hard_header_len;
+	struct atalk_route *rt, *rt_lo = NULL;
 	int err;
 
 	if (flags & ~(MSG_DONTWAIT|MSG_CMSG_COMPAT))
@@ -1641,7 +1641,22 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	SOCK_DEBUG(sk, "SK %p: Size needed %d, device %s\n",
 			sk, size, dev->name);
 
-	size += dev->hard_header_len;
+	hard_header_len = dev->hard_header_len;
+	/* Leave room for loopback hardware header if necessary */
+	if (usat->sat_addr.s_node == ATADDR_BCAST &&
+	    (dev->flags & IFF_LOOPBACK || !(rt->flags & RTF_GATEWAY))) {
+		struct atalk_addr at_lo;
+
+		at_lo.s_node = 0;
+		at_lo.s_net  = 0;
+
+		rt_lo = atrtr_find(&at_lo);
+
+		if (rt_lo && rt_lo->dev->hard_header_len > hard_header_len)
+			hard_header_len = rt_lo->dev->hard_header_len;
+	}
+
+	size += hard_header_len;
 	release_sock(sk);
 	skb = sock_alloc_send_skb(sk, size, (flags & MSG_DONTWAIT), &err);
 	lock_sock(sk);
@@ -1649,7 +1664,7 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out;
 
 	skb_reserve(skb, ddp_dl->header_length);
-	skb_reserve(skb, dev->hard_header_len);
+	skb_reserve(skb, hard_header_len);
 	skb->dev = dev;
 
 	SOCK_DEBUG(sk, "SK %p: Begin build.\n", sk);
@@ -1700,18 +1715,12 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		/* loop back */
 		skb_orphan(skb);
 		if (ddp->deh_dnode == ATADDR_BCAST) {
-			struct atalk_addr at_lo;
-
-			at_lo.s_node = 0;
-			at_lo.s_net  = 0;
-
-			rt = atrtr_find(&at_lo);
-			if (!rt) {
+			if (!rt_lo) {
 				kfree_skb(skb);
 				err = -ENETUNREACH;
 				goto out;
 			}
-			dev = rt->dev;
+			dev = rt_lo->dev;
 			skb->dev = dev;
 		}
 		ddp_dl->request(ddp_dl, skb, dev->dev_addr);
-- 
2.25.1

