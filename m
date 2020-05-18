Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF591D70F2
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgERG2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgERG2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 02:28:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D29C061A0C;
        Sun, 17 May 2020 23:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9UtQoI/F5BndnEZjurerNgRQRwh1y2a1S2oOi1HN0Zo=; b=nANZFiqYXc9iU+aJsp2UDfjEPR
        Hay1CYPuS0Xb7sdLpddwbxrs7E+7vCtrQd5FqGY7ClhZGVGZg4lEascDsVZFiktp/NAdHxCe8cE5b
        12uTeEdEcM2oyqdKOcJ3zI8793EUtij3gWI04qPsKdIlsL9R1rn5hWqxdAbVz9bLGFZUoGekj5UkS
        hNqFfPhBXCeB7mu9A5gkqBYbg+nB6Od6KcPNI3p0lvhD2xnhPqnHGHtLY49Ij+M1fnAT/VY1OZnXr
        N+NUwA2kvfKEewEN9LyJ6DP1ujCeDTXiZB77PD4ObWHvBff1/bA2qeOUHgVB6gjPOrPCnk45lC13U
        kQ9k4+DQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaZG8-0002Zx-EC; Mon, 18 May 2020 06:28:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] appletalk: factor out a atrtr_ioctl_addrt helper
Date:   Mon, 18 May 2020 08:28:07 +0200
Message-Id: <20200518062808.756610-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518062808.756610-1-hch@lst.de>
References: <20200518062808.756610-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper than can be shared with the upcoming compat ioctl handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/appletalk/ddp.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index b41375d4d295d..4177a74f65436 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -867,6 +867,24 @@ static int atif_ioctl(int cmd, void __user *arg)
 	return copy_to_user(arg, &atreq, sizeof(atreq)) ? -EFAULT : 0;
 }
 
+static int atrtr_ioctl_addrt(struct rtentry *rt)
+{
+	struct net_device *dev = NULL;
+
+	if (rt->rt_dev) {
+		char name[IFNAMSIZ];
+
+		if (copy_from_user(name, rt->rt_dev, IFNAMSIZ-1))
+			return -EFAULT;
+		name[IFNAMSIZ-1] = '\0';
+
+		dev = __dev_get_by_name(&init_net, name);
+		if (!dev)
+			return -ENODEV;
+	}
+	return atrtr_create(rt, dev);
+}
+
 /* Routing ioctl() calls */
 static int atrtr_ioctl(unsigned int cmd, void __user *arg)
 {
@@ -882,19 +900,8 @@ static int atrtr_ioctl(unsigned int cmd, void __user *arg)
 		return atrtr_delete(&((struct sockaddr_at *)
 				      &rt.rt_dst)->sat_addr);
 
-	case SIOCADDRT: {
-		struct net_device *dev = NULL;
-		if (rt.rt_dev) {
-			char name[IFNAMSIZ];
-			if (copy_from_user(name, rt.rt_dev, IFNAMSIZ-1))
-				return -EFAULT;
-			name[IFNAMSIZ-1] = '\0';
-			dev = __dev_get_by_name(&init_net, name);
-			if (!dev)
-				return -ENODEV;
-		}
-		return atrtr_create(&rt, dev);
-	}
+	case SIOCADDRT:
+		return atrtr_ioctl_addrt(&rt);
 	}
 	return -EINVAL;
 }
-- 
2.26.2

