Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C246891D
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhLEE1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhLEE1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:30 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4A5C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:03 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z6so6902961pfe.7
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K+AadUv33QFmjFDOBOvnFpBm7Lw7zZYJtLUilhe63TU=;
        b=Md260HyCK4F3uCrAYsgidrhyQuqFCVeyJ6DKue7HaWMt0WFnbKi6vSDyj1qPti+lZT
         oMqDYMgbOXORkNmXwZrDGgFuLHaCujEkWO3Gqo8MO5ZUpw2gfAve34aB2IwMtRrUwo0V
         tDySmg2K76cx/94E9dTfAhz+W8Ivw8NEAVmAplBIQqxfady1pIuXYgPND0m/c3PAAd3K
         KpLhzecobRMuA/ivrCYmD2YcBm0k29Lz5d/MPk/o8pLGmZPxio2vH1t+gkv3G1RTxUJD
         SOOOUAjU5kIvFLfybtYMsw2ZbnumHjyPBz5J1vfjuvCa9yy2sgPn8/kIJsgMb2FIWE7A
         5wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+AadUv33QFmjFDOBOvnFpBm7Lw7zZYJtLUilhe63TU=;
        b=BziCJ6Bh3IVtuZywPU4DyBWuSkAdNlUUfRqWiVBmEyOHGLjBlUvfaECTPv1KNv9e2P
         LZtUsucwPBD9Rb0NpOsEb8RZirrPs7S6k4UI9PwzpOiw697hDxqHqc9BEfcsJ5slWZJX
         UEmZ4XXt+X/36DQ7mPQrKDxKvEP+N0q6+zO8I719Wa3eeKh9a9zggLvMneblekv6Xt8d
         zElpmqBqjAF0trurndRTr/wyZ1MKHT/cd2w2nxj2W5ndVgIEeBW8emxk6Ysp2J1YG7kx
         D0H9ktFwgGDiFIMnH325Vdo//x9EaOPfqZICRptmUL69ujUo5hPQQS1McVSv2aj82GrG
         INdg==
X-Gm-Message-State: AOAM530CcmPszJ/Kbw2hua/IHaL/UqKbPbM00hZ9J9nQ2g/fyJXg+YXQ
        FLiXpivyEQ41s3czSaWyt6HoMgQkRH4=
X-Google-Smtp-Source: ABdhPJx8jQoHZSYBeJBIBl7O7Pd/NFWo9GyBJIBy/tvHWWgjZYLK+6JSlCXbGc3dmmNvRUsuqnjNvA==
X-Received: by 2002:a65:5ac7:: with SMTP id d7mr12400242pgt.590.1638678243443;
        Sat, 04 Dec 2021 20:24:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 17/23] ipv6: add net device refcount tracker to struct inet6_dev
Date:   Sat,  4 Dec 2021 20:22:11 -0800
Message-Id: <20211205042217.982127-18-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/if_inet6.h   | 1 +
 net/ipv6/addrconf.c      | 4 ++--
 net/ipv6/addrconf_core.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 653e7d0f65cb7a5e7458daf860215d1873c532e7..f026cf08a8e86c54ea5d9f1abddd5f0e3caf402b 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -160,6 +160,7 @@ struct ipv6_devstat {
 
 struct inet6_dev {
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 
 	struct list_head	addr_list;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3445f8017430f145496bad78afd6378bf5cb1c02..3eee17790a82fe6c528db4e821b11444cfa26866 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -405,13 +405,13 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (ndev->cnf.forwarding)
 		dev_disable_lro(dev);
 	/* We refer to the device */
-	dev_hold(dev);
+	dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
 
 	if (snmp6_alloc_dev(ndev) < 0) {
 		netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
 			   __func__);
 		neigh_parms_release(&nd_tbl, ndev->nd_parms);
-		dev_put(dev);
+		dev_put_track(dev, &ndev->dev_tracker);
 		kfree(ndev);
 		return ERR_PTR(err);
 	}
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 1d4054bb345b72204179c17b4ebc69e11e3faf53..881d1477d24ad5af79fd744bee1e0792fcfa483d 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -263,7 +263,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 #ifdef NET_REFCNT_DEBUG
 	pr_debug("%s: %s\n", __func__, dev ? dev->name : "NIL");
 #endif
-	dev_put(dev);
+	dev_put_track(dev, &idev->dev_tracker);
 	if (!idev->dead) {
 		pr_warn("Freeing alive inet6 device %p\n", idev);
 		return;
-- 
2.34.1.400.ga245620fadb-goog

