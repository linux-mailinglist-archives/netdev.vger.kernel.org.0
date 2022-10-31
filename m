Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C753D6136BE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiJaMnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiJaMnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:43:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E8DF029
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so7944532wmb.0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMxPzizBadbscVuJ9Hytv5gqKfIS420ghAxYHWb0bUw=;
        b=C6RDn/QxoHCGE9MRDdHqAMajDNUbLvDOOXjB4WNpDQqe1KAAvTh/YQwHrrugQGGPFF
         L+IDVa9OFAvcjLqGCwWm9eree7UkCXVpZqp23XiEUrW5+2DMZsO6kTF8DoFRfVXrNmr7
         ipSFCknMfjrZCTnwNqfAb32pNB23krN+LLjDlLMhqIXytTGASmO5hh8rYcJZ1R4n4NMx
         P3Ou8w585dbu88/Nkv+gDF8sEclkhsFGzkwm/Gci2Lzl7/prnyxt5RbeowL7oYCCnDAY
         Oj3CO25YvLlqo2WEdSASwK1xoqSlZL2Y2HDDMass4nifI3PCALe7rtMcLXZrBny5D+9I
         gU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMxPzizBadbscVuJ9Hytv5gqKfIS420ghAxYHWb0bUw=;
        b=NtNjy2IcvMiEK4JpyNzgkVA3uzNyrNKIr4RRUcSpER3qzEdGZyJbk1FNjtzFLCZbtm
         bnbDSqP49oE9KOy7RcFj9mmngzCtanLUq3ro699otojsDY7/EYgRM+B7V93LE57d/ZXP
         9sr1ajDHHNErMrBLTRVYtJpzTYOx0HpYcVs9r+a8w+skfhVLr4gGUsuSO7/oISgm6y7T
         hvZVfoSzF14C3AFU+GACyF+WRmyuGJcHxflf3uq/fZSjcY9OvtVwG3ffST+8lXSEkCrJ
         msqsHKwOXsgob1+RW/bdLjKQdXdLcaTJ7iGvijWo/oUhQ+JLv395kAcw5xQwEMk/jrEx
         JlRg==
X-Gm-Message-State: ACrzQf13P9QGx9ybl8UaiqnkFTPZaEzWUU+m8C2Fsbywb+cxr5U0vUk1
        JsRenCIiwvTGuVyDuKUEbZ9XRYX0+qEhs303
X-Google-Smtp-Source: AMsMyM6P2u6SwPiek2RGkIBIkzsUSb6jpMauFY6vkb9ifEQByurZwpfY62sriR1PUhxPLoJ1lWpxBA==
X-Received: by 2002:a05:600c:46c7:b0:3c6:f3e6:1f13 with SMTP id q7-20020a05600c46c700b003c6f3e61f13mr18042113wmo.62.1667220183635;
        Mon, 31 Oct 2022 05:43:03 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t128-20020a1c4686000000b003cf7055c057sm3385863wma.3.2022.10.31.05.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:43:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 11/13] net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
Date:   Mon, 31 Oct 2022 13:42:46 +0100
Message-Id: <20221031124248.484405-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Use newly introduced devlink_port pointer instead of getting it calling
to ndo_get_devlink_port op.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c   | 12 ++----------
 net/core/net-sysfs.c |  4 ++--
 net/ethtool/ioctl.c  | 11 ++---------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4a0ba86b86ed..3a454d0045e5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -12505,14 +12505,6 @@ static void __devlink_compat_running_version(struct devlink *devlink,
 	nlmsg_free(msg);
 }
 
-static struct devlink_port *netdev_to_devlink_port(struct net_device *dev)
-{
-	if (!dev->netdev_ops->ndo_get_devlink_port)
-		return NULL;
-
-	return dev->netdev_ops->ndo_get_devlink_port(dev);
-}
-
 void devlink_compat_running_version(struct devlink *devlink,
 				    char *buf, size_t len)
 {
@@ -12558,7 +12550,7 @@ int devlink_compat_phys_port_name_get(struct net_device *dev,
 	 */
 	ASSERT_RTNL();
 
-	devlink_port = netdev_to_devlink_port(dev);
+	devlink_port = dev->devlink_port;
 	if (!devlink_port)
 		return -EOPNOTSUPP;
 
@@ -12574,7 +12566,7 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * devlink_port instance cannot disappear in the middle. No need to take
 	 * any devlink lock as only permanent values are accessed.
 	 */
-	devlink_port = netdev_to_devlink_port(dev);
+	devlink_port = dev->devlink_port;
 	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8409d41405df..679b84cc8794 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -532,7 +532,7 @@ static ssize_t phys_port_name_show(struct device *dev,
 	 * returning early without hitting the trylock/restart below.
 	 */
 	if (!netdev->netdev_ops->ndo_get_phys_port_name &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
+	    !netdev->devlink_port)
 		return -EOPNOTSUPP;
 
 	if (!rtnl_trylock())
@@ -562,7 +562,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	 * because recurse is false when calling dev_get_port_parent_id.
 	 */
 	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
+	    !netdev->devlink_port)
 		return -EOPNOTSUPP;
 
 	if (!rtnl_trylock())
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..b6835136c53f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -44,16 +44,9 @@ struct ethtool_devlink_compat {
 
 static struct devlink *netdev_to_devlink_get(struct net_device *dev)
 {
-	struct devlink_port *devlink_port;
-
-	if (!dev->netdev_ops->ndo_get_devlink_port)
-		return NULL;
-
-	devlink_port = dev->netdev_ops->ndo_get_devlink_port(dev);
-	if (!devlink_port)
+	if (!dev->devlink_port)
 		return NULL;
-
-	return devlink_try_get(devlink_port->devlink);
+	return devlink_try_get(dev->devlink_port->devlink);
 }
 
 /*
-- 
2.37.3

