Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22DF5F2F08
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJCKwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJCKwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F915302F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id e18so13996720edj.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0ge03VXE8pOK7H5hNbqBvTxxr3X8S7wS5iOCX0ynmdA=;
        b=JmEPxyuyUMFay7dTMWHEn6gZkxoSK8Lkrjun7ncJ/zq3t1uP1UcVRTkr0xmFxD/CIh
         FZlvPRJKM4vWhi7oKbqrxJJ6K7ntpYoxGCJei0/ZBeF0nEKuBwLCzHL1/kX+wV03IDnR
         iBODkOivR7YkJ2CTu7rDtVjKNicgwi+3qJvGeR8mUPjuVqo5/Bx1c9PmOBhnAu7j+FXC
         A6zVlaWY3Kfkw/TBF67ssHmuVN8gl6ZH3wvAE7h49yEMKVMDDFDhv2Ri2yVUk+XK8r7t
         mSEKxiYvgd/ZjnZ5spKBqgFZ7EkNaTj+YEunvp3Ik2p6My0cXAmNv7RYSIdDsfUIThpw
         kZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0ge03VXE8pOK7H5hNbqBvTxxr3X8S7wS5iOCX0ynmdA=;
        b=Csk9TcwwOQSMX/256xEODHG9HJ2GM+eccySA66hZk7CGX5W77I7KcS/qTwshUHq/Lf
         gVbqFB+TpuwzfGiQQUq+xgOjG4Jbm8cNQH5NiL7gWYqmsJYkD5hyY4wCs6KGyE/gxXwO
         sfpxoNlzlAmUmiqsMGGehokWn9kK+2QXC6el1MzhWF66EfnLzaWMTqV/3ES8KYOyjL+h
         7ArlbUifgUDmKTTvnTAM0vpeetWmPaM06ba/7JnIjMMjeyyUpmMVy/DD+hofV4ZGsH0Y
         ihL560iRcixtcakpxT53hLE2AE92eWNOGiYdNwtt62P/iXiiUEoka9V8PdFKvg58fkU2
         NDkw==
X-Gm-Message-State: ACrzQf2gPACWXoACdZVJwEDEreVjnhg6BxXpLTduSY4sij9PebrRo5No
        4GI89ena1FWvvPT3AtyP2z+evc6dkzW6+cqPujg=
X-Google-Smtp-Source: AMsMyM4cgcmfrGwBBaEUwCeW8qOIH4elld3Grss2o3yCy+ECBm68jsIfD//3MkRlnxi3AEXV0FGX2Q==
X-Received: by 2002:a05:6402:5210:b0:451:d4ff:ab02 with SMTP id s16-20020a056402521000b00451d4ffab02mr18119284edd.345.1664794326981;
        Mon, 03 Oct 2022 03:52:06 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f13-20020a17090660cd00b0077a7c01f263sm5214514ejk.88.2022.10.03.03.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 01/13] net: devlink: convert devlink port type-specific pointers to union
Date:   Mon,  3 Oct 2022 12:51:52 +0200
Message-Id: <20221003105204.3315337-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
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

