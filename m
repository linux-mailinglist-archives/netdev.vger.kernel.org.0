Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102D56166D2
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiKBQCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiKBQCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C934D2BB3E
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a14so25228228wru.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8an90UsiLKs2claL8HWs+wiEf3vQhctPHwegzIpH0s=;
        b=tYKwrh+m4lvuvsirgvo0Tj8JdgTrIyW1VMMut3zKjOiMAgPYUsEZo09sL2vd7UWpzZ
         4dIoIONsDIN0Xu6N9U25y/KmOdccrgfyuXs/ocYK+c16Z8buvA9MXTecmbiEwo4mt2xB
         knBuWGFzCkmWOMNt40fIBBRfSnAD7Qu58nOsI/OA+7fPGR96SkggxKuhyzUXkndWT9g2
         qUcKV4fphECYqrOIm+f0WZBtT0exC23SlrILAz13FXXej/TWMcVZNPUvdysjeKDi0wUx
         F1RTp8kzjoNLtz5zDPlaJI2qJO0CdY7Vvo/GI25fR+nWoZQ9TNWlNLLEAgfRmpqEpKsr
         mqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8an90UsiLKs2claL8HWs+wiEf3vQhctPHwegzIpH0s=;
        b=Ffgy2mDFlmP+2oPAf3wjmlGmZtgvpONGCOUiHfBnOxvE/rgyvOugwzRShApQu8Gvuk
         OMe36W3dwZaesLFH960fnhk6Y8SJG3l2o2FXoOnofrWDj9p0f6iBcf/NiyWOJ7F5PgWy
         lVrDLEu4Go7oS1rCT8eon0LKxKpTKReqKF10W+MIcsnPrtdO8+vCDOHjxdAkoV7EF+cb
         gEiJWJnd7V4S+5VY8zmXmHJ9RcBRVVaE5OUk9XolQF79ONjHBMJVxtAw6BjO1TCUe3xe
         NtG0sjzRGCRqEfRl/sWNbQ+epDZJYET5Ng6VrJ2bKLLPTq+pbuJLBoO9iKqKd9/uEtr9
         ui5Q==
X-Gm-Message-State: ACrzQf0dDQC7pvDRimzIEBUpBlm51JkCbWyGMb7JmY6AjHmQqH1ruU2F
        3riQtfFSWsd5jTA4HkUH8KLUAR1O18HBNaMr+T8=
X-Google-Smtp-Source: AMsMyM7ZznZkQ1rKy7DUFeCtAK+cGSrXg9f4wu8qYtNvxFAxCMrLfKvlrzbbiTnZ9trCjFYYHR4xuQ==
X-Received: by 2002:a05:6000:408b:b0:238:238:513d with SMTP id da11-20020a056000408b00b002380238513dmr253249wrb.536.1667404934323;
        Wed, 02 Nov 2022 09:02:14 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y3-20020a05600c17c300b003b4cba4ef71sm2653229wmo.41.2022.11.02.09.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 01/13] net: devlink: convert devlink port type-specific pointers to union
Date:   Wed,  2 Nov 2022 17:01:59 +0100
Message-Id: <20221102160211.662752-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of storing type_dev as a void pointer, convert it to union and
use it to store either struct net_device or struct ib_device pointer.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 13 ++++++++++---
 net/core/devlink.c    | 17 +++++++++++++----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b094943..6c55aabaedf1 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -121,12 +121,19 @@ struct devlink_port {
 	struct list_head region_list;
 	struct devlink *devlink;
 	unsigned int index;
-	spinlock_t type_lock; /* Protects type and type_dev
-			       * pointer consistency.
+	spinlock_t type_lock; /* Protects type and type_eth/ib
+			       * structures consistency.
 			       */
 	enum devlink_port_type type;
 	enum devlink_port_type desired_type;
-	void *type_dev;
+	union {
+		struct {
+			struct net_device *netdev;
+		} type_eth;
+		struct {
+			struct ib_device *ibdev;
+		} type_ib;
+	};
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
 	   switch_port:1,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0a16ad45520e..868d04c2164f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1303,7 +1303,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
 		struct net *net = devlink_net(devlink_port->devlink);
-		struct net_device *netdev = devlink_port->type_dev;
+		struct net_device *netdev = devlink_port->type_eth.netdev;
 
 		if (netdev && net_eq(net, dev_net(netdev)) &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
@@ -1313,7 +1313,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			goto nla_put_failure_type_locked;
 	}
 	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
-		struct ib_device *ibdev = devlink_port->type_dev;
+		struct ib_device *ibdev = devlink_port->type_ib.ibdev;
 
 		if (ibdev &&
 		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
@@ -10003,7 +10003,16 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
-	devlink_port->type_dev = type_dev;
+	switch (type) {
+	case DEVLINK_PORT_TYPE_ETH:
+		devlink_port->type_eth.netdev = type_dev;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		devlink_port->type_ib.ibdev = type_dev;
+		break;
+	default:
+		break;
+	}
 	spin_unlock_bh(&devlink_port->type_lock);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 }
@@ -12016,7 +12025,7 @@ devlink_trap_report_metadata_set(struct devlink_trap_metadata *metadata,
 
 	spin_lock(&in_devlink_port->type_lock);
 	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
-		metadata->input_dev = in_devlink_port->type_dev;
+		metadata->input_dev = in_devlink_port->type_eth.netdev;
 	spin_unlock(&in_devlink_port->type_lock);
 }
 
-- 
2.37.3

