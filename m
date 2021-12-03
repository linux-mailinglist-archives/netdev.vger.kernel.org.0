Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF20467291
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378863AbhLCH2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 02:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378860AbhLCH2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 02:28:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFDAC06174A;
        Thu,  2 Dec 2021 23:25:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so4462827pju.3;
        Thu, 02 Dec 2021 23:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kW18LMYhzGvLx9tYNAEZ66FGMyAdKv0GvbYs8HtrNN4=;
        b=GzOr8Tl/hTqg7wcRuRcAq5KYqyVmxBiy28SPq0VNKYb+uD4i2QWmQt5L8aBLk+h1NH
         eaOou1ayfr4DI2GKjefGMR9+PhlVrqJBMECbXlUx1fWR2GdX1QwapcaWSjilgiv/hDxC
         IVravDkN2ul4yOVra2vpvxoPGMiUL7TlpAKRlj5IJ3ADxIGRvQd1pcEy8kT49rvohkyP
         DY/wwYSHYENpMJVs3q8wATOyAU/KTEMTIA2iZTbsLj02O2ksCB8KHoLgf6RGnlRBGZvf
         0hz59/ZIvVXxdbdTsjzd0oJHVtIJ00JPdo6HOBVZ5jNpmFS3Nx2KfqKclyTRHhkGLlOl
         fvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kW18LMYhzGvLx9tYNAEZ66FGMyAdKv0GvbYs8HtrNN4=;
        b=4Wi1ruGC92I18m2br6PCx+NWio5QciQu0mugnbYZR4vIaf5jFO2xGsFsiRqDwV3bUS
         d/fkMDr4TXR/gH8S97zrHaDbnqYHvSe0i4/N1paRZl5hDaMiddIuAdqitXXZZTDmC8x3
         6seQCslskLYgSJR9T9yQr7VHc8DZDfKNS73+sZdn8yQ/hrX3C9ozla1/pgEVKS0bIlV/
         LJbIYjITGF6ao/lINF79jONx40CTcvwC+xNIQbsPyR3PFssgAZV2GOIy+YL/MHMycpS7
         4yQicZOFvDMbpjXEAFQeA4q6MwWGdJZc91x5kctxAFcjmTo1t4MQ2wXvn1VnG7aDQ2WB
         XdAg==
X-Gm-Message-State: AOAM532/ZPPNbnbYXH978bT9oP5P0oAPboeEEVz/sn2lRK2bV4NF536G
        eJ1O/CTMOhf8kdJPqyh955k=
X-Google-Smtp-Source: ABdhPJydusav1cMxVCbJ45XqL5yXPSRhDKMBHQ+jNALu2QZ8dZtufRTdzXJgao2m4rTrHXOfb69XyQ==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr11852086pjb.96.1638516323644;
        Thu, 02 Dec 2021 23:25:23 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e13sm1602476pgb.8.2021.12.02.23.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 23:25:23 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.yunkai@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: [PATCH linux-next] macvlan: judge ACCEPT_LOCAL before broadcast
Date:   Fri,  3 Dec 2021 07:25:15 +0000
Message-Id: <20211203072515.345503-1-zhang.yunkai@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>

When macvlan send broadcast，it need judge accept_local.If you don’t do
this, it will be received in the same namespace and treated as an
invalid source address.If open log_martians,it will also print an error
like this:
IPv4: martian source 173.254.95.16 from 173.254.100.109,
on dev eth0
ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
08 06        ......@...dm..
IPv4: martian source 173.254.95.16 from 173.254.100.109,
on dev eth1
ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
08 06        ......@...dm..

Modify the sender, or modify the receiver, or modify the printing error,
this is not an invalid source address, or it is clearly stated in the
RFC1812 whether this is an invalid source address.

Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
---
 drivers/net/macvlan.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d2f830ec2969..3a16139e7b47 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -19,6 +19,7 @@
 #include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/ethtool.h>
@@ -268,6 +269,7 @@ static void macvlan_broadcast(struct sk_buff *skb,
 	unsigned int i;
 	int err;
 	unsigned int hash;
+	struct in_device *in_dev;
 
 	if (skb->protocol == htons(ETH_P_PAUSE))
 		return;
@@ -280,6 +282,18 @@ static void macvlan_broadcast(struct sk_buff *skb,
 		if (!test_bit(hash, vlan->mc_filter))
 			continue;
 
+		rcu_read_lock();
+		if (src && net_eq(dev_net(vlan->dev), dev_net(src))) {
+			in_dev = __in_dev_get_rcu(src);
+			if (!IN_DEV_ACCEPT_LOCAL(in_dev)) {
+				in_dev_put(in_dev);
+				rcu_read_unlock();
+				continue;
+			}
+			in_dev_put(in_dev);
+		}
+		rcu_read_unlock();
+
 		err = NET_RX_DROP;
 		nskb = skb_clone(skb, GFP_ATOMIC);
 		if (likely(nskb))
-- 
2.25.1

