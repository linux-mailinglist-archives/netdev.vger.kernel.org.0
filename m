Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827F45F1A21
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJAGCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJAGCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4FD1A598B
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m15so8396580edb.13
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ywL5261cNJ4n9cUsRKA0L0nTXt+4XDcIdnX/SLbDKck=;
        b=bT1AWayJXhC6URGOcUHsjXSYNxzlh77wapFaR7zp4QK4Z9Uadjt426ytYDCht5Tyh5
         MRt2YMd/uE+qYFXaTLd8SbZJZa4HeykrGhm8OAJlo4UEzre0UfdswB9HR3Kl1+/iuNYN
         +j1j/rqnlcr3A3Ij5TCOorr6QORdyYBZpnCOpPlxpS3ZAOjd/BTQYicMBx2s3sk/Qn4u
         02h61T2OWSFkuqeo+cuP0mfOHFuSKW4wcIizLoJxD48lqhP7UXUOThiviOMHIkZPBR9+
         hHAAX4TbpkwdP+mX+Z+q4cKrBT9jtcljJmfORJUz8y6yX4IICmfbWXZR5b1q9x0Djcmj
         C27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ywL5261cNJ4n9cUsRKA0L0nTXt+4XDcIdnX/SLbDKck=;
        b=cYSS/h0NSIU89vQtIl/jTiGkVRRJ7sfdVxoiRRkxmimgn55GqxOPwkctxjl9zjkkib
         sSQ8guKrNb8tSIzfCIzI2jxqRwbNLnGZwnX5Ys6dmsv9dnYAY/rYvMYeoqUNSFAvC8sK
         LMCc86cfKth4W9EuwwOY7DUKLUMQKY4MCNeDoJe3fW5L7YDvsjHLQoLtrd586AMKfROE
         B0/EFmCw7xP8m+Oaq8z5WXOaL2zp4fvJ5JP6WHIwOPTWC8sguVeD9jDlYZXIUyAbVlvb
         +ecKz9X/MZV8U0M1G/8/nmny8/1EMPutQY+sai7HhfaRwLC3a4HQRohA8HPVwX8R4w9E
         OYfA==
X-Gm-Message-State: ACrzQf0ZJ6veIBs4SPQ61lHwR4cQx59mm9v9mpdilVM/7r/4tAn7SnPL
        niUT3YQHMf1zcjuqg1e0NfzXxPKV0BT4ImgV
X-Google-Smtp-Source: AMsMyM6n5OPIiVoYEBxC924s7U64KCvMIxM7wczlhtDs1OycutnUBYRhJFXaVf15fUUv+LKbOtyh+A==
X-Received: by 2002:a05:6402:3408:b0:43c:2dd3:d86b with SMTP id k8-20020a056402340800b0043c2dd3d86bmr10441505edc.108.1664604129642;
        Fri, 30 Sep 2022 23:02:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bl22-20020a170906c25600b007707ec25071sm2156038ejb.220.2022.09.30.23.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 13/13] net: expose devlink port over rtnetlink
Date:   Sat,  1 Oct 2022 08:01:45 +0200
Message-Id: <20221001060145.3199964-14-jiri@resnulli.us>
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

Expose devlink port handle related to netdev over rtnetlink. Introduce a
new nested IFLA attribute to carry the info. Call into devlink code to
fill-up the nest with existing devlink attributes that are used over
devlink netlink.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        | 14 +++++++++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/devlink.c           | 20 ++++++++++++++++++
 net/core/rtnetlink.c         | 39 ++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7befad57afd4..fa6e936af1a5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1873,6 +1873,9 @@ int devlink_compat_phys_port_name_get(struct net_device *dev,
 int devlink_compat_switch_id_get(struct net_device *dev,
 				 struct netdev_phys_item_id *ppid);
 
+int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port);
+size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port);
+
 #else
 
 static inline struct devlink *devlink_try_get(struct devlink *devlink)
@@ -1909,6 +1912,17 @@ devlink_compat_switch_id_get(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
+{
+	return 0;
+}
+
+static inline size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _NET_DEVLINK_H_ */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 3d39fb398d65..27f6ce3a46fc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -372,6 +372,8 @@ enum {
 	IFLA_TSO_MAX_SEGS,
 	IFLA_ALLMULTI,		/* Allmulti count: > 0 means acts ALLMULTI */
 
+	IFLA_DEVLINK_PORT,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2a42e49f6a4e..d2ee33044b2e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -880,6 +880,26 @@ static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *dev
 	return -EMSGSIZE;
 }
 
+int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
+{
+	if (devlink_nl_put_handle(msg, devlink_port->devlink))
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
+		return -EMSGSIZE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_nl_port_handle_fill);
+
+size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
+{
+	struct devlink *devlink = devlink_port->devlink;
+
+	return nla_total_size(strlen(devlink->dev->bus->name) + 1) /* DEVLINK_ATTR_BUS_NAME */
+	     + nla_total_size(strlen(dev_name(devlink->dev)) + 1) /* DEVLINK_ATTR_DEV_NAME */
+	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
+}
+EXPORT_SYMBOL_GPL(devlink_nl_port_handle_size);
+
 struct devlink_reload_combination {
 	enum devlink_reload_action action;
 	enum devlink_reload_limit limit;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..e034c0c8e6cc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -53,6 +53,7 @@
 #include <net/fib_rules.h>
 #include <net/rtnetlink.h>
 #include <net/net_namespace.h>
+#include <net/devlink.h>
 
 #include "dev.h"
 
@@ -1038,6 +1039,16 @@ static size_t rtnl_proto_down_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_devlink_port_size(const struct net_device *dev)
+{
+	size_t size = nla_total_size(0); /* nest IFLA_DEVLINK_PORT */
+
+	if (dev->devlink_port)
+		size += devlink_nl_port_handle_size(dev->devlink_port);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1091,6 +1102,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
+	       + rtnl_devlink_port_size(dev)
 	       + 0;
 }
 
@@ -1728,6 +1740,30 @@ static int rtnl_fill_proto_down(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int rtnl_fill_devlink_port(struct sk_buff *skb,
+				  const struct net_device *dev)
+{
+	struct nlattr *devlink_port_nest;
+	int ret;
+
+	devlink_port_nest = nla_nest_start(skb, IFLA_DEVLINK_PORT);
+	if (!devlink_port_nest)
+		return -EMSGSIZE;
+
+	if (dev->devlink_port) {
+		ret = devlink_nl_port_handle_fill(skb, dev->devlink_port);
+		if (ret < 0)
+			goto nest_cancel;
+	}
+
+	nla_nest_end(skb, devlink_port_nest);
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(skb, devlink_port_nest);
+	return ret;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1865,6 +1901,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			   dev->dev.parent->bus->name))
 		goto nla_put_failure;
 
+	if (rtnl_fill_devlink_port(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.37.1

