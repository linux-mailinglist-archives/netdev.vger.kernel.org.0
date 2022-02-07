Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6D04AC8C8
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiBGSmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiBGSlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:41:13 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD1C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:41:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z17so1826178plb.9
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 10:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1H0Uygqb5520Llf2e13dJNCdO0gBkJ5fbDEosLZnNhc=;
        b=bur6T1dLEc3VHm7nv0YP1Lwlvurq1gGhH+v2vGPQ/4tttt18RgBTb9AC4Bs2xy0Fqr
         UoGszu8G3Gfs9l6t7l8A4DhTDs2sxoWGG+mzMS6ReTcGTFqJirya7uiCbd3UR2ieEtvO
         mQRPE6mRkTGOMab9/UBZZqtLo1/ms0aqgHfp7ZJGKDWlQWh8msBydD9c40ezO2UVyAJZ
         JoQ8WuDqZjS1qEpuoqLA52CI6iSmT0vyEh8M54vjRdpiOWRxGcETF2zO8ASorGHtf9wp
         tIBc9k3YXrO5ll9ehtm8+cMarhreKsSQpGp8M6rpy8bcgdFkzflQpF/5i219XzM3OcEW
         q7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1H0Uygqb5520Llf2e13dJNCdO0gBkJ5fbDEosLZnNhc=;
        b=FDSgSdrcRocWfvveisYF6wc9jpFEgIRGuM9l4KEu8wvFqLRuj336pokNdhlyd9SStn
         Kggv4V4Iwd+CTiHJEQrVMp2B2LSHor8QJo37Gyeb/a9b3tk5wDsPVSOJkbTSUglWwXC2
         1z6fGEmPTpcPcp/zJQP7PLMrjzaJqdT7shcImc5yneIBk291H7eoqi2AeVLzCL0WSEsF
         2H/wdy+W4hXQpouZGyK9ZhsNiPZSWOgMkkMdfoOcH55pThscUWY7151k4QF5yd84jSz2
         DSnC4g7F0oCblF/xII+5H2oVDRJqiqXTMvUiW4IcoiBBXulD/4fnmfrzwTXxqH2Haufl
         Kmmw==
X-Gm-Message-State: AOAM532N54ZakSJLhvEp1Jl+4ID5LfKLucOERW38JpXXBwuA/A7YRpN/
        8oFV9wtowICDLSSRNJR99bg=
X-Google-Smtp-Source: ABdhPJzmZldsauVc2tK/p861/3vVh9W8hMrOeUHcd4VkQs4P0w97QJ8t0q4Yw3coXB9j3KKvcTlo9Q==
X-Received: by 2002:a17:902:758c:: with SMTP id j12mr813111pll.34.1644259271510;
        Mon, 07 Feb 2022 10:41:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id h17sm12912175pfv.198.2022.02.07.10.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:41:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: add dev->dev_registered_tracker
Date:   Mon,  7 Feb 2022 10:41:07 -0800
Message-Id: <20220207184107.1401096-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Convert one dev_hold()/dev_put() pair in register_netdevice()
and unregister_netdevice_many() to dev_hold_track()
and dev_put_track().

This would allow to detect a rogue dev_put() a bit earlier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3fb6fb67ed77e70314a699c9bdf8f4b26acfcc19..cfa1e70c71e48b39ff21140392a2883223a1b839 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2282,6 +2282,7 @@ struct net_device {
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
+	netdevice_tracker	dev_registered_tracker;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index f662c6a7d7b49b836a05efc74aeffc7fc9e4e147..66556a21800a921d543d13ae957650ed80a7ebdd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9683,8 +9683,10 @@ int register_netdevice(struct net_device *dev)
 	linkwatch_init_dev(dev);
 
 	dev_init_scheduler(dev);
-	dev_hold(dev);
+
+	dev_hold_track(dev, &dev->dev_registered_tracker, GFP_KERNEL);
 	list_netdevice(dev);
+
 	add_device_randomness(dev->dev_addr, dev->addr_len);
 
 	/* If the device has permanent device address, driver should
@@ -10449,7 +10451,7 @@ void unregister_netdevice_many(struct list_head *head)
 	synchronize_net();
 
 	list_for_each_entry(dev, head, unreg_list) {
-		dev_put(dev);
+		dev_put_track(dev, &dev->dev_registered_tracker);
 		net_set_todo(dev);
 	}
 
-- 
2.35.0.263.gb82422642f-goog

