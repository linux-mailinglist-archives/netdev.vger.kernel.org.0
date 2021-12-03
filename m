Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C2B467039
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378255AbhLCCvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350096AbhLCCvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:04 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC60C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p18so1080249plf.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2LwuTZxf6hfMURpQK8QlcUjSRki4HDA2qnkJ82nk9A=;
        b=CQrCdJ+l/g87es3R5DZ/BmNKJJLpl+Luy44nAfpqtReJ3o1YIsg9m2Qym8t7tZ5Z9K
         juIU4yo40dskiBRBxSHXUlLF0z9WoFaxy14NnqqcTgIDxlmbqIpAdnTxaVNIr9A+yexz
         0YY9W+7OEpnrEIu8bKf012K5PCOZ8zMMZR1VwsI83RWgvhiBG78KrIxuoIgixZeQ1RRu
         Uc6wMHGk0G0x7aLVmV+A8CcKBmN1wm0rKNhbSsLpF6HQOnvcJEotzeubuL9Tqm8dnQt6
         T6BgYSsAKUHd74MsWDzbI5LenX99EMvbo9DM1P4G4kxKwr/Ry1G9LcQ39moLUnVFT2V/
         y2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2LwuTZxf6hfMURpQK8QlcUjSRki4HDA2qnkJ82nk9A=;
        b=p4GqFonehAkfFjFSyAcveJ6y5fqplTzpYqhpLezSE/hafBQiR8mPtA41Qh5koKkBe2
         y6NTs+5MN7eaq4qlUs1jiu6rRdp6Qc6kSA+p4P1+4xaRFDIYREAOSkSYoXJab7lr9DhS
         n5QXPR06ttzLVrLCBP6upfh7sCtj4/TFRFuFiqlwFRAFeKblJ3LSX+dqp1xZuduwfZ8K
         seh47b7ZayDeBOCbDASnwEdaeiimCyI5tR699DeiIfh3j7ENSIZhFTTu11fFZXDLlPBt
         Q6CYRX+5VsQdEZJazvBu53mR8JmgIqAisWFTV2/LYjKIr48Km2epPIsLIawZgll47eW9
         BvfA==
X-Gm-Message-State: AOAM5338g/M4l+5LbTmVuAyN7BmbCxrjAtbdfewqasmgOljHvvJecd6w
        +pARLb0f1MPWFkCDwtWAbdY=
X-Google-Smtp-Source: ABdhPJybjWGULJU6D+OOvrl9WC1u2PKujZVWc2Xfyrnllr2X65FT+hrCCKKS+IixwtZtwpYFG+cleA==
X-Received: by 2002:a17:90b:1e51:: with SMTP id pi17mr10699625pjb.245.1638499660847;
        Thu, 02 Dec 2021 18:47:40 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:40 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 08/23] drop_monitor: add net device refcount tracker
Date:   Thu,  2 Dec 2021 18:46:25 -0800
Message-Id: <20211203024640.1180745-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
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
 net/core/drop_monitor.c | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

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
index 49442cae6f69d5e9d93d00b53ab8f5a0563c1d37..3d0ab2eec91667bdfac93878a046fc727fc22b99 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -850,7 +850,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 	}
 
 	hw_metadata->input_dev = metadata->input_dev;
-	dev_hold(hw_metadata->input_dev);
+	dev_hold_track(hw_metadata->input_dev, &hw_metadata->dev_tracker, GFP_ATOMIC);
 
 	return hw_metadata;
 
@@ -864,9 +864,9 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 }
 
 static void
-net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
+net_dm_hw_metadata_free(struct devlink_trap_metadata *hw_metadata)
 {
-	dev_put(hw_metadata->input_dev);
+	dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
 	kfree(hw_metadata->fa_cookie);
 	kfree(hw_metadata->trap_name);
 	kfree(hw_metadata->trap_group_name);
-- 
2.34.1.400.ga245620fadb-goog

