Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68251D4F19
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEONTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgEONTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:19:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A6EC061A0C;
        Fri, 15 May 2020 06:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9UtQoI/F5BndnEZjurerNgRQRwh1y2a1S2oOi1HN0Zo=; b=ZupbyfjeM93LkXtNJxwmG3ATH4
        e8zE6Zon9u26+ofgNEC/fF4z+OxWnUmq/HVH5TFN90ea9s2eoeuTIvzP1suxH9RDm0xinpxP7JYjc
        ShJYuppddpBzng/pvcE78Efi/TpGyJiv+l4qEJXnL97ny9gDHqx357brYNy4TxTKoIHYM918h377z
        H2Reul/aA00xYVso4zNLjW9KQo9VLNtBQjna9wAIlY6WaIcjSgaXHQUIfquDCsLWZ0mRwRyoGmukQ
        HMEu46rFbudyYtFjmIodYBzk/FK92mVQGBORKI7DlPVIW/0ibK+L2b7lzz6bmJ+dnK4xnMXFbHBsZ
        JMObdqLQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZaFS-0006Zi-MP; Fri, 15 May 2020 13:19:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] appletalk: factor out a atrtr_ioctl_addrt helper
Date:   Fri, 15 May 2020 15:19:24 +0200
Message-Id: <20200515131925.3855053-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515131925.3855053-1-hch@lst.de>
References: <20200515131925.3855053-1-hch@lst.de>
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

