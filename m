Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA1468913
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhLEE0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhLEE0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40090C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:53 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id m15so7090100pgu.11
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCVrtbrupO2p3CSbIlgpBTs9TIXh0ks/7pAWJkZoW3E=;
        b=PWuT52dDo7AhMh1ukX0XxpAHSCFCSxkWmteNGUnZlf3ZURi1I/k6ft83vAoFbqLChI
         sG5yTtTM7LFo6TQvkkTCv/vdZBAublm6cHVAHFztGqzD4bMdzy179fa9e/DwtHmRZGIW
         shXaY8DN7UH8yimCYw+hkzsoUFYGcgyEw5ZWunN/K7hh5cpfObIFawzGf/YwAC5485jv
         Qkb0hV8xPlKa2NisOOohKF1rA4m+hVtZS8maa4aWnzvvtC0FxSJgZPbn6IDT29jv4V23
         c1X0PLjBW7gSlTy9YJOmfi2kavYYs8NIesgNI7OkuJolaG5aT+mDVTYFesc3VZwA9sp1
         3iLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCVrtbrupO2p3CSbIlgpBTs9TIXh0ks/7pAWJkZoW3E=;
        b=b+LGy0IfRZVzQxdTqDiFGX/M70M65mVrmkqFQ3mudKcyfFBczTvrG90dyomXD2+txX
         lB6kbMxhawge1E0sPj/wbvvCz9vI7b+ScaofR43ki3gJoNQYxlHhNGPoEgmbuosuz5Kv
         U42h6721BXHtNWo6IH80pYIbecHAUsBusJ9afC0weHTZz2Au2gdvOhb11cvbUKHtHTGd
         8CFyJ6p61x3w3e3W2NZ3mjieAvtb8+qqChF9EI06yo5/iEldkE3fjA3ysVvfWOPe8li7
         umDyVmSqWjcxvMFjTIvLxdYgjthkE2C7VSFF8/ZH52IY8YZ7pJO95Kpf2CIl43TKUH/G
         oBQA==
X-Gm-Message-State: AOAM531ab5TvbSZy5ztcf9HW60/7dXIOQbB2aGp+ocinzRXZOp3MF37E
        lsTHz5QNEqf4/p3uTCceXP8=
X-Google-Smtp-Source: ABdhPJyL1/E5g89wtD/bqXfalmNLPQwtmOiA/Dhtg+QNxTs/fmu/t40HEuFBo3oQw/IjL4CI+/fD1w==
X-Received: by 2002:aa7:9d1e:0:b0:494:6dec:6425 with SMTP id k30-20020aa79d1e000000b004946dec6425mr28813778pfp.83.1638678172840;
        Sat, 04 Dec 2021 20:22:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 07/23] net: add net device refcount tracker to dev_ifsioc()
Date:   Sat,  4 Dec 2021 20:22:01 -0800
Message-Id: <20211205042217.982127-8-eric.dumazet@gmail.com>
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
 net/core/dev_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index cbab5fec64b12df9355b154bdcaa0f48701966e8..1d309a6669325ad26c59892c4e78ca14dec017d9 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -313,6 +313,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	int err;
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
 	const struct net_device_ops *ops;
+	netdevice_tracker dev_tracker;
 
 	if (!dev)
 		return -ENODEV;
@@ -381,10 +382,10 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 			return -ENODEV;
 		if (!netif_is_bridge_master(dev))
 			return -EOPNOTSUPP;
-		dev_hold(dev);
+		dev_hold_track(dev, &dev_tracker, GFP_KERNEL);
 		rtnl_unlock();
 		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
-		dev_put(dev);
+		dev_put_track(dev, &dev_tracker);
 		rtnl_lock();
 		return err;
 
-- 
2.34.1.400.ga245620fadb-goog

