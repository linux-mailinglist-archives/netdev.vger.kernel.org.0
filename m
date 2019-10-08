Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B51AD02BE
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbfJHVUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:20:44 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36100 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730722AbfJHVUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:20:44 -0400
Received: by mail-pg1-f202.google.com with SMTP id h36so114252pgb.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=msiuzG1QorMC5wKGRMOiCfAPdnyVFIjoudQYT8uKr1g=;
        b=fPMqPLwxYK2d8lYzpAbOJgW11iv/ML13RyiJCUh16OsInTrFOE6pgNTSuibSKbFqvC
         /5ZwaasxcJYdwFChftumXry/jIbAjPloQpe9bavtLF1HRZo5FUKN4i4qA3Mu9WNpuWrV
         G1uQrZDYqdEBpGOCGCL7t3NKAvOsUgT7lS8vLM+lqEZU0OEDleROcxvu/3JP9hdH0YXX
         RegEZRo/ZrHWhlHIdvwJSEFxQwEfeYRtyIEm7DiufdH/nRMDcquRYYg03SbIV17gC2Xm
         /lsAeB7QhTCm9Ek5V5xTt9/S/kIQnloELUis8tXQLSA8RsgYAPdDyNsa3xw061SLYs/m
         ulQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=msiuzG1QorMC5wKGRMOiCfAPdnyVFIjoudQYT8uKr1g=;
        b=ikHABxmwfP6EoVLatiSSjWAE7c4lSHC2LIshQKDDVODkMZas73/+gdlGLFT1b9Ry+N
         tzGnDdoPLYdAXlrZOqnP34aU2E5R1Mof3r5yGuhaLULXI4WuZUWgdmB5WXmveRr3IGEE
         UqwJ5VokDJGflnjQtC3poioHto3znKvPT+xmhPEaGhiR2L93pD8L+LcKww2BZ6dpszld
         jpL3oImEE88oen6VQei/GKOH8T7KCgEiWm30R3xByaJbZgScJVi/fIuoKsu1Es2jrhx6
         C9Rb4jRRU2NwDPcrNrD10hs0LA8aOnQ5r0pV5CUAFRGFnWQZ+mcL6dRWAdYYzg3Tb1Em
         MNWg==
X-Gm-Message-State: APjAAAX4VVREh1fr/tbyPDhAFoqznZEVO7jm3MtpGyJJ7x+DtOywZ03u
        QrlcjMFY5iAq+VSzrVPbs+bUJyjxLppc2g==
X-Google-Smtp-Source: APXvYqx1Xffi77LIIpeSdVIedZ8TWLKJ+WpuxlvAo1SnWJDFW45OU2Os2pZ1tICMH7A6r33C5fGJlNOzGOiNkQ==
X-Received: by 2002:a63:ed58:: with SMTP id m24mr519780pgk.344.1570569642321;
 Tue, 08 Oct 2019 14:20:42 -0700 (PDT)
Date:   Tue,  8 Oct 2019 14:20:34 -0700
Message-Id: <20191008212034.172771-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net-next] Revert "tun: call dev_get_valid_name() before register_netdevice()"
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0ad646c81b2182f7fa67ec0c8c825e0ee165696d.

As noticed by Jakub, this is no longer needed after
commit 11fc7d5a0a2d ("tun: fix memory leak in error path")

This no longer exports dev_get_valid_name() for the exclusive
use of tun driver.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/tun.c         | 3 ---
 include/linux/netdevice.h | 3 ---
 net/core/dev.c            | 5 ++---
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1e541b08b136364302aa524e31efb62062c43faa..0413d182d7821ca5bac794df43717149d78a6117 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2788,9 +2788,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		if (!dev)
 			return -ENOMEM;
-		err = dev_get_valid_name(net, dev, name);
-		if (err < 0)
-			goto err_free_dev;
 
 		dev_net_set(dev, net);
 		dev->rtnl_link_ops = &tun_link_ops;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fe45b2c72315f422dfa1b1e74a033777dd83fa21..3207e0b9ec4e3065a4a364b676e3ff3101719fa5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4113,9 +4113,6 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 				    unsigned char name_assign_type,
 				    void (*setup)(struct net_device *),
 				    unsigned int txqs, unsigned int rxqs);
-int dev_get_valid_name(struct net *net, struct net_device *dev,
-		       const char *name);
-
 #define alloc_netdev(sizeof_priv, name, name_assign_type, setup) \
 	alloc_netdev_mqs(sizeof_priv, name, name_assign_type, setup, 1, 1)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d05e042c6bade23c3f253cf73a4f51b9cf71fd7..8bc3dce71fc08e80cfaa151576ff7b8503796791 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1249,8 +1249,8 @@ int dev_alloc_name(struct net_device *dev, const char *name)
 }
 EXPORT_SYMBOL(dev_alloc_name);
 
-int dev_get_valid_name(struct net *net, struct net_device *dev,
-		       const char *name)
+static int dev_get_valid_name(struct net *net, struct net_device *dev,
+			      const char *name)
 {
 	BUG_ON(!net);
 
@@ -1266,7 +1266,6 @@ int dev_get_valid_name(struct net *net, struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL(dev_get_valid_name);
 
 /**
  *	dev_change_name - change name of a device
-- 
2.23.0.581.g78d2f28ef7-goog

