Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F075F2F1F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJCKwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCKw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E445302D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id l22so12542258edj.5
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZSUCxj9wdTS5KSDeUaAgEGU+xDzkrY6KowvhlmYUvgU=;
        b=3X5lq0eh0BvuynXAxwTGe3F26+97ePOOeuq7xi2T/7wWmNywM+KDoqKcqmvRS0SVAk
         5dCQPv4t/ua++bHGCuhEuc2j5IE2BJ3duC9JyWKQaOuGoV2tumN3yoO+GmYtIBhxKP5L
         BXBucyn3HizckWsR0tamHr64gUurVbb8IZ4nunw2H7MOFkWmn54UrLC2jfpmPeh5ovcx
         ZzJECRC6UnWFEn2XUKbapl4LtyJIxp79YVksPfjoRmIcePPAA05cBp5a9Z78hVFEAuJH
         QxvRwuAn7hmnK71erP4VUnQhVI68+I46A09mMyOyLUkI+AXt0aFay5imEH3emvh2pQ6t
         fBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZSUCxj9wdTS5KSDeUaAgEGU+xDzkrY6KowvhlmYUvgU=;
        b=5S4dsk9f5t/A+HqP9mbYnVnGIOQZ3NmjL7D43p5zMFKiMB+v/sAJyiM1HD50eWxA87
         vdEJYJc3UHR/C06hmwMBINlMr33BK0v37+iKEhJhS459bgo5ocvK4UX+Q0wW/Rzjj1YK
         1aWxY9fMA+pMD4A6miAEMshRkAhxSUQXz8EA3cUaTih0kiWyVCxGY92cOn0jC7nH6uAE
         MCQN5D+4YJu8s1wAztODAPRmPlzXubyaDds3stFxdHMjWQEjBaVQe90wSnQZZnYofMcn
         TakG5iAjMl4346YU23Xd4oZMzk9tgGaoFKVU0/Ixw5aFcFinQ799VzsTZq30mjfwb0Zx
         dlFw==
X-Gm-Message-State: ACrzQf23X3XNjRhFO+/NT+Voe/vsJ6DPgWDvOzyAG1x7/wXiETmrzWIe
        wdr40fExqrUrMjwr3kSOwjTT6JPHuaGwvD87yAg=
X-Google-Smtp-Source: AMsMyM57IBDMvHcPVBqxw5kZSB54Q+vt3ln85AXSbE5NwjRCQ4nJNeTncc4T+LMdEynH/L99PhNsUQ==
X-Received: by 2002:a05:6402:430a:b0:451:d8ed:b87e with SMTP id m10-20020a056402430a00b00451d8edb87emr17907003edc.246.1664794340277;
        Mon, 03 Oct 2022 03:52:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e6-20020aa7d7c6000000b00451319a43dasm7209660eds.2.2022.10.03.03.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:19 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 11/13] net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
Date:   Mon,  3 Oct 2022 12:52:02 +0200
Message-Id: <20221003105204.3315337-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
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
index cac0c7852159..2a42e49f6a4e 100644
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
2.37.1

