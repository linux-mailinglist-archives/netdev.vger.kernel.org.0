Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3935467037
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378252AbhLCCu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbhLCCu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CBEC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:34 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r138so1601316pgr.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOkbTqC70cMxk+SiiC//4vDcMoRtO5s+8GF7iQiCxQY=;
        b=ht5nFeUHuKWMoCQigdCou7MA5/wRZtVPypuPAMfCuWHZVTI0zjJSWUBDKV1Uub7yHI
         do3MYwTUyKntCx7xGERunn8jXBUG0zgQGSuDoIYVXP5Ia8IOKDbqpPWchejU22gzcFEq
         2rNZ9Ue7qkTa2cV59021RK1ZwsAgQJ5iv7pYiClwGUbVZXvweiYcQkgMrARitvrriw1A
         THqA7Tto5IzWSJJv//lL3X3dnkHQHrejwD9ZqZyt2nbPVP15Ay2PTsUPylX44rS35tWS
         oRsuR6DuUGtkX4DVdQTtHl6retvxBSofCLvlfnjKyUi0/b5hZgD0oKve1QswYuwWYn1F
         eQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOkbTqC70cMxk+SiiC//4vDcMoRtO5s+8GF7iQiCxQY=;
        b=8KibDtvfuwO+mnSbTchvLuF6mHc68AbMmUtwHwj755pUG1LMlBPL+/AxePInEyi8bB
         Ym6eCAcbMFi1fEFcpYDudLop8pJpQptg4Rv2fbAl6M9VbcX4fLyq9PYMspIANnDT4gdO
         OWnMeSY/tsDpPta4A1d0Go0gYgpnyDhmz3SsuVUZS8QNy+DtEfykqahnXZFR39tI9Ltf
         g7NgzbFOxneSBroTgOHQk9VncNHMyA6f3/7wuPF5Rrfm/Y/arHT5pdb6I2yJqdi5Gy5k
         yLrbdiiqmNOLJZeyXGyfF0+cVHll7RRO223ci2p/tA2XJe5nGtKUkGfXV3wwBRnMhjL1
         OxEw==
X-Gm-Message-State: AOAM531q8qhCvBSN0klQmN5mZsIhvpmCyY+l7HPm2HBD5L8U1iREoJBX
        mNtYlAeITCnPJjda2O0gPXU=
X-Google-Smtp-Source: ABdhPJw3LyI4feNacea/UoPLLweXpLKTh4n8vxg1WNPkBP/HmoYZEscX4nDq9cY+PQE8C3B9vIuICA==
X-Received: by 2002:a05:6a00:1350:b0:49f:e389:8839 with SMTP id k16-20020a056a00135000b0049fe3898839mr16466263pfu.51.1638499653711;
        Thu, 02 Dec 2021 18:47:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 06/23] net: add net device refcount tracker to ethtool_phys_id()
Date:   Thu,  2 Dec 2021 18:46:23 -0800
Message-Id: <20211203024640.1180745-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helper might hold a netdev reference for a long time,
lets add reference tracking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ethtool/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index fa8aa5ec19ba1cfff611a159c5b8bcd02f74c5ca..9a113d89352123acf56ec598c191bb75985c6be5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1989,6 +1989,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	struct ethtool_value id;
 	static bool busy;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	netdevice_tracker dev_tracker;
 	int rc;
 
 	if (!ops->set_phys_id)
@@ -2008,7 +2009,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	 * removal of the device.
 	 */
 	busy = true;
-	dev_hold(dev);
+	dev_hold_track(dev, &dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 
 	if (rc == 0) {
@@ -2032,7 +2033,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	}
 
 	rtnl_lock();
-	dev_put(dev);
+	dev_put_track(dev, &dev_tracker);
 	busy = false;
 
 	(void) ops->set_phys_id(dev, ETHTOOL_ID_INACTIVE);
-- 
2.34.1.400.ga245620fadb-goog

