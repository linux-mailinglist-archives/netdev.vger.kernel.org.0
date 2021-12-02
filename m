Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57CF465CAB
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355178AbhLBD0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355177AbhLBDZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5476C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so3473057pjb.4
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WK2P6yNg78NxDXxmvRH1elSqJxnqJhGGVYpY4oWpzF4=;
        b=YOK7bmmMul5XdaGGCIT1Oom1vad/uARTX0TgnQOseNCYenWRcVNGjM5AQchPOzL0ma
         mWVl/rrzl4CVggVQ/BcTLWRTLrIPJ1kEODydYXsn3zjbZPWD1Y4iCUI9saXvW1MVIq0V
         qlZz5ABYc3KXw2VWtDuQcWPAxdmPQkFGm+195Lubw0DNqf4uB8g9WMVt+/uDX/8OOUdW
         JeHuDATafrXort8sX3KhorHAkQEbE7grhJs6Zcb+b6RvbbilXZgl9s5rSBHYXTxhKzcz
         q+Ps9rU/W1BoAGx0F8L4hFXzs2fTksoJUDUk56LYc1yS4ezPgfVUIkay/3OOXL5DfmSz
         Lb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WK2P6yNg78NxDXxmvRH1elSqJxnqJhGGVYpY4oWpzF4=;
        b=sajENmHhbVREMHVbrklf3+2JDDo7006v4mo3j55pRC/xhnsJmW94jw6StVTy1jFQ0h
         wM7nXjUJ4ymk48t43Nx75ceelz8XbCH17yjBI0brgAd/dumwztISL+QeWWlrQoMX1jEU
         U+TJLZhSXgc66k8LfPCIRZzJkGyi9V/gex9VYWAcglCz3w1e57LdXzQ8/KHn2dXKt7DH
         wwQ0HezLJSic1wTVR1sfJMrSk+jbhMXIGvDNxtE6OZJiaH7rIB794vMVs5DLy0mxSOJZ
         dDwAlu58Srq7GnqxRW60tLiqNPEQ9627VqinYB7ylfV3MkbEk1PlsrYcLVC3JL9nszxz
         Q+Uw==
X-Gm-Message-State: AOAM531KtjTOieZyUscAzXt3mygV5pQCIdUFv30owQ6ct4mgi18r7NM9
        4qglZkxwXaKqwfg5sHvzdPS2Fi7h5VQ=
X-Google-Smtp-Source: ABdhPJxP/BNWWonp6UurgNkkSFMzH4oWW160qnQO8rqR+0RJlYt2o8rtXgeQkSxdylLwVYkXIstjgA==
X-Received: by 2002:a17:902:7797:b0:143:88c3:7ff1 with SMTP id o23-20020a170902779700b0014388c37ff1mr12315099pll.22.1638415351422;
        Wed, 01 Dec 2021 19:22:31 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/19] drop_monitor: add net device refcount tracker
Date:   Wed,  1 Dec 2021 19:21:28 -0800
Message-Id: <20211202032139.3156411-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We want to track all dev_hold()/dev_put() to ease leak hunting.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/devlink.h   | 3 +++
 net/core/drop_monitor.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 043fcec8b0aadf041aba35b8339c93ac9336b551..09b75fdfa74e268aaeb05ec640fd76ec5ba777ac 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -670,7 +670,10 @@ struct devlink_health_reporter_ops {
 struct devlink_trap_metadata {
 	const char *trap_name;
 	const char *trap_group_name;
+
 	struct net_device *input_dev;
+	netdevice_tracker dev_tracker;
+
 	const struct flow_action_cookie *fa_cookie;
 	enum devlink_trap_type trap_type;
 };
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 49442cae6f69d5e9d93d00b53ab8f5a0563c1d37..dff13c208c1dafac26c3180a37e6e3be5f8fa744 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -850,7 +850,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 	}
 
 	hw_metadata->input_dev = metadata->input_dev;
-	dev_hold(hw_metadata->input_dev);
+	dev_hold_track(hw_metadata->input_dev, &hw_metadata->dev_tracker, GFP_ATOMIC);
 
 	return hw_metadata;
 
@@ -866,7 +866,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 static void
 net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
 {
-	dev_put(hw_metadata->input_dev);
+	dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
 	kfree(hw_metadata->fa_cookie);
 	kfree(hw_metadata->trap_name);
 	kfree(hw_metadata->trap_group_name);
-- 
2.34.0.rc2.393.gf8c9666880-goog

