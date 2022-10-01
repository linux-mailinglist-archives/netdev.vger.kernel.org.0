Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F69B5F1A1F
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJAGCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJAGCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783A7D62E2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:07 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r18so12918344eja.11
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZSUCxj9wdTS5KSDeUaAgEGU+xDzkrY6KowvhlmYUvgU=;
        b=aZsZmz7+H/QW79OdSu+jy+WrtAG1jNRZ+mmnvgLuuQqFk8YE0avUls3Kaj99A8TpSJ
         H8+F++nupAKxoMODgUTACTyPkpPQ117uptV4QUtmZ9XaS0y6WIJ5DNq+Nk1BxSp/uOUR
         2fOSlVDawH8qnoCFl+NbUoSBxLVfhplbgGoHtX3o+ATC2ZUCAJlZvAPw6TrTRAkn2hGK
         32IwRSQuoN2s1XAjtSIhP+HIR4v2HmUd/HIOPmxdXQeq6xQQZNnGLwc+fqeNtfjuf1Ic
         xVB2eS9y0/shnfIVXdfxfVSpJ94ll3TNsQ5FTyIDBLM2XT03WH5wn8Sd5HaYiqpXjO43
         8saA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZSUCxj9wdTS5KSDeUaAgEGU+xDzkrY6KowvhlmYUvgU=;
        b=Et2JOlHo9WT8kIhcPJCTjz6g+zivBBCKMrfgnmNzd09x2kfjrAEaIxO5kNaLjNSSSm
         xtVlzvReXHcYKXUnSrczOp1H3+zgqrOBs0ZKIpe9/N3wKtHcW6dQrTACEKQVWBB0jgMV
         UcUhylBaEIl4QYOn1J2I8qQGLL3lVcWSNS6LAqhyBPvSMD1kgaVudAMAkVNwii/+vae6
         pRmnaFU+k9dAVI89PAO7HHhx7pyqTexWYjRilezrUu9GZWwpi3aWGUhEoafzjWJjk79G
         d+JDXJqkoJghVUkyx8/aze7V4sxw5ilfLKUnnIDg1WEt0t4tNF2kfU6lRpM+6LUQ9c0Q
         aktw==
X-Gm-Message-State: ACrzQf0Scv+95lRKj9WMTxiLo6KXs7ZfiVPb0CdRTbA4+NSN1kmWFQAM
        MEkqNrVo+ypDO0uOwFMwd8dTjuE0KMhny/b5
X-Google-Smtp-Source: AMsMyM6JjS8FCu4hDfZJEJuYiBc3bUax/zFHFXx1sbFefLBckCvI15lYnVs80mQq0bLXjPu9WX22Mw==
X-Received: by 2002:a17:907:2cce:b0:77a:6958:5aaa with SMTP id hg14-20020a1709072cce00b0077a69585aaamr8496170ejc.245.1664604125917;
        Fri, 30 Sep 2022 23:02:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g3-20020a170906538300b0078128c89439sm2226843ejo.6.2022.09.30.23.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 11/13] net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
Date:   Sat,  1 Oct 2022 08:01:43 +0200
Message-Id: <20221001060145.3199964-12-jiri@resnulli.us>
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

