Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBD465CAA
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355193AbhLBD0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355189AbhLBDZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B5C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso3487509pjb.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qJ4N3TZkXDp/zFxWJ2xUxDT7iabkYNzhWXo0PGJiX9I=;
        b=m1JDw9mEk6QQypZVRgDVe3gsMes+dmrI8wVgYgX5QCSHfRBdunsKGQ12uKxqLYBde5
         vTwslReDovfQKkRUdeSR/au4Y8v0m9SbGpz3BbWBx/5O2uOnnwkdkTZWMDVeXxSnEBPX
         g6PpTnMUPYuvr+I0d/ctyOv7lzeugvuZEiyBdtGFs6Tn4b7Byah39Xec50ZwnAB9z/n0
         Ksr5tq4/x/Y6DnDbXwygoPzjCGYgUC5lM8UylwMYGPJonoWinPTs3zMjiYKfgaOZSBDv
         2WSm3/mfwSdpv/Or5LqfQvv/9nMyJHmuWBbzl64QpXS3uVg5Y5cuSW2id66jw93+heOB
         X34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qJ4N3TZkXDp/zFxWJ2xUxDT7iabkYNzhWXo0PGJiX9I=;
        b=41UdcKFxrh9TGdsnH0ozEW/rExq8f6CWcM2r3OYFo2hdEYpeA7is9aW6RLFjArFxpk
         JAJlE5dnpXxWgWp20k+ySFIxEJf29H7ennpW+pCfDvn5YKei699SlHjrNbE2TevcgQF+
         CrUZ2au11MReJlvhY8PGSZkurWHWo3glg9BC0jhI7hDFL2TNg3v8SmvuLTFXy9lVgvNR
         0O7gh9oe6WTSNcJZex/FUZRQuSFVC8I7ZfVcJ+2u7LjpXxzSQcYVQRtA/K2nB4WvbTQf
         lSwVGziLZcrYNkXyOmdGMzFI+llJPMWOjl8RO1rZJNLjEk2qLpaEJ9GrGYKRp7G6YxIR
         HjAQ==
X-Gm-Message-State: AOAM530akbqWQnsdRZzQb8c+yZ63oIVmVeDn4bky0Gkag3GTf4NWt9Ul
        djdmPn7KJeoeDxkAnEwRgOs=
X-Google-Smtp-Source: ABdhPJxjNhLyP3s/7Wtz9KuLKeDPsTIm+PgbfyRXADen5O80S3J5alrAtGBRnvgZArqlAYmQNohkGw==
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr2888567pjb.173.1638415347986;
        Wed, 01 Dec 2021 19:22:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/19] net: add net device refcount tracker to dev_ifsioc()
Date:   Wed,  1 Dec 2021 19:21:27 -0800
Message-Id: <20211202032139.3156411-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
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
2.34.0.rc2.393.gf8c9666880-goog

