Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020C46AFD4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351748AbhLGBfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351647AbhLGBeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C3BC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:07 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r5so12155904pgi.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tz9vHdqUZOf4v8FsLoZLubMjatviUY54HDUnECMUfwk=;
        b=ESHN0HD5jb8a83FszD8Y+MAcu/8QPWM8+4Tp5CcNP5YCiSJucZ9VX5GNQwAY9D3+wu
         hNq1o3S41uNQnMdTERp20PkHFz6QcwZVZ+jsUbgLz680GT+FOcVr0nFnOoSHC+ybYGIk
         PCyZXfF6Eevps2lOpk3t7xwGFRLBwEpfFyh6xoUYYRIYosVPHb/30iqs7nxz6H4FqXJT
         9NLhmNWlOFoTL+K/CDn9FSrjTYcyjxosntn8Ci88mNvIFMck3Ey17ZkO+46bIFu8J7lh
         uFo+hMW+sGmL0tJ1T+53g763Cc2bMwyL5lMMzjTTpqBmqdejxrgScUVY/WHLfS2s1zou
         ldWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tz9vHdqUZOf4v8FsLoZLubMjatviUY54HDUnECMUfwk=;
        b=XGA37p5XuWzAGn0qT8reQDfgkAcM8tl2FUytpx11nn9LQ1sVsoX2e4tpqhL8Z4F58M
         xHTXQ0sELWGOPVM0HqzRZm8ijloah9bF+pLF63VPoh5EzF76FCp1k1optW9z9+HU9Qfm
         bgy1VeasxNydltT6XtnJxCggk4ieW+Our0CMJuER+jNK3NlPRkjBQ9ARtvFDn4NJcKlq
         5hjvo6gJNKVsSguWyo7y/GmIl381QgzKr0MQ+2FfMfCEBHUEMHjy9GiCVTg13meOgsUU
         1HEs57WY0iXa8hCQTPjY8/k+/8t+tgjSB7/Kh02Gd22N2H8UQ8vBwhkz6nz2EsGerqY0
         u1IQ==
X-Gm-Message-State: AOAM533XFGghI/Da3FFux3RxPSfEzfbx+AETgnoY6eJA6nHLtkKhXO7T
        Qb7GW5ZJGRMoF05IfsvYHJA=
X-Google-Smtp-Source: ABdhPJzfLnKtdxoHwJklraLzMYgUhOxlRDFAHbL8IAuKbmgTcZt0LMi0ltALJsJM1C2WgN3wiHVD/A==
X-Received: by 2002:a05:6a00:808:b0:49f:f2c0:2c98 with SMTP id m8-20020a056a00080800b0049ff2c02c98mr40870153pfk.58.1638840667263;
        Mon, 06 Dec 2021 17:31:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/13] net: switchdev: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:31 -0800
Message-Id: <20211207013039.1868645-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/switchdev/switchdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 83460470e88315f9bee59271b6955294d0b6f42a..b62565278faccfb7f96228a19304a9ec6c161655 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -28,6 +28,7 @@ typedef void switchdev_deferred_func_t(struct net_device *dev,
 struct switchdev_deferred_item {
 	struct list_head list;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	switchdev_deferred_func_t *func;
 	unsigned long data[];
 };
@@ -63,7 +64,7 @@ void switchdev_deferred_process(void)
 
 	while ((dfitem = switchdev_deferred_dequeue())) {
 		dfitem->func(dfitem->dev, dfitem->data);
-		dev_put(dfitem->dev);
+		dev_put_track(dfitem->dev, &dfitem->dev_tracker);
 		kfree(dfitem);
 	}
 }
@@ -90,7 +91,7 @@ static int switchdev_deferred_enqueue(struct net_device *dev,
 	dfitem->dev = dev;
 	dfitem->func = func;
 	memcpy(dfitem->data, data, data_len);
-	dev_hold(dev);
+	dev_hold_track(dev, &dfitem->dev_tracker, GFP_ATOMIC);
 	spin_lock_bh(&deferred_lock);
 	list_add_tail(&dfitem->list, &deferred);
 	spin_unlock_bh(&deferred_lock);
-- 
2.34.1.400.ga245620fadb-goog

