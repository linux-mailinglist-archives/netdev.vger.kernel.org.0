Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C955F1A16
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJAGBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJAGBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C5D58AE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a41so8417864edf.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0ge03VXE8pOK7H5hNbqBvTxxr3X8S7wS5iOCX0ynmdA=;
        b=16TavDO7FyiDOd3dsJYgwgV13KhVsUS0Mo1NY22mT+J0pCVLgtfhxjfP2UAF7bAOiU
         vMZpr9cfK8IIqvDuwCK6TbHXfL1OhOiZ66bSfzyWNJYV7NJGqR9Qdg+2+/BHIwbCjSI7
         Kf9tA3nqV+x6L/+M00VLqfZJ7fX/gjNGVT2ioIyD9vHJRrJSyBwDWINdf5sEtHHj6y9E
         D21GHMURZwiCtyMWxr05UgmGh7aEWy1EnsQkyBBvk1upt4qhEoGExY20bbmP+mbXta67
         Jfu/TKt27kFPPUmyqMe2scJMUjl9egwQsmpTKZYr8mU0z+jwiTqsYyMwyMuSFiABs+VN
         EQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0ge03VXE8pOK7H5hNbqBvTxxr3X8S7wS5iOCX0ynmdA=;
        b=y2GBGnzLu2LKI/04cv0E1taVTCMXz4x2WdbwoQL0+sPr+DQS8M5GjNhsgvefeayVMT
         JE706vUy9uZW2/xezuhY1daceoB1o2p2jDoDVbqPSquDxDdMibOC/YU7Z/mE7BEgYzR0
         NHjQTLHOSrrT4SnHljvvtbmchR8mCKXJuCzPvqHUvPeEVcYC6F6QW9iSKOe4XxsuEhX7
         43RA+QvBA+oEqC33MkBH29YYJ4GPgkdn1wosSc/oXcPesJzHtG85NLjYT5EwvecAmb/S
         PACMxzshxD8YcfoC2Nkx3PhTio/yaQvw36ut8gR2WjjKUiO06J//W6nYHJupPFa7uT9O
         YnwQ==
X-Gm-Message-State: ACrzQf3Om+e1PdGbii7E34gEE9bVOFaJxpt9RTK9bBZfGGCy/I4LC3SH
        xGvFzRSP6h0FVkWAO9k0jQgEgOEcmWPVz3pk
X-Google-Smtp-Source: AMsMyM4rNNIAm0GAfV4D2NAYYcu0H4LChn4ENV8VZTkvkS+G8/SDydsawPNizY0mtQfWkaJu7Uyd+w==
X-Received: by 2002:a50:cdc2:0:b0:456:ecb7:30ad with SMTP id h2-20020a50cdc2000000b00456ecb730admr10635279edj.37.1664604108977;
        Fri, 30 Sep 2022 23:01:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f21-20020a50a6d5000000b00457c321454asm2963172edc.37.2022.09.30.23.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 01/13] net: devlink: convert devlink port type-specific pointers to union
Date:   Sat,  1 Oct 2022 08:01:33 +0200
Message-Id: <20221001060145.3199964-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
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
index 89baa7c0938b..7e7645ae3d89 100644
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
2.37.1

