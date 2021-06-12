Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840983A4D7D
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 10:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFLIOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 04:14:35 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:34376 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhFLIOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 04:14:33 -0400
Received: by mail-wr1-f47.google.com with SMTP id q5so8437383wrm.1
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d82HDQRFWnDbNi3qCp9COZeIUQc4rHUgiYVZqY067LM=;
        b=R6A2j60YLlbeT3YrQ2AiDVrCQIraxuNnUKNiXbFzDcmEJJakInW5Fpowq4zg/uFfFl
         lw/hRSlF1kYbt1qvfKB1eG0l/P3hbe3POyNY+Zd9Y2SAz0PpdN/RpRVjsK1Q81iSjv7b
         gS7nyqaNQG019gyHW3bz2gL8e+ZIygrD47pBeBl+vkAiurO4/ZKpqQZY+1nffrZCeUBS
         msOE1siKqHUpWFr4DF5sqL3hc6qoTIpS7H0FLjeynhLDpijNOxwOuQYjicGma8jO8zzo
         fh9ZAehBMiqZv/JPzZzAivMIXZIY9w2xnvU71i8sBtBwOwKE4Z0XypyyMG61+7Ojbm97
         8NNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d82HDQRFWnDbNi3qCp9COZeIUQc4rHUgiYVZqY067LM=;
        b=PpPhwz2fl3ViK+FWXzsJ+QaHtvIlMXCopEmah/cS8OmbNeCqIxTD5MeQnxY0yfiEWM
         PaCLF5+REKnTCs0pR7XsLYPzCjRLHPNqyXnb7RkDNsOsBKYE8N1sRab8DUtZjxyIaId2
         oumQZhYWAu4gjmeavnOUfPh6cjB+iOgCz9sWSUXAkw1e+MIf++4rolJkT7/D4zNnQrcY
         vbNFxU19zJ9ZYdE75Nf5YVHu889UYuOvElC6DVxBgMdeXH7bB2wIvIfJu7hqGYdjoVqu
         26nhBnzQf9d8HykErRYqZK6e9LnbS3y+xRGe0xm/H1EjJg0DXSCT1GzduK9niKQqqwEs
         HZEg==
X-Gm-Message-State: AOAM531r+HbwPkGIT9VCDcXvthw4d5DALU8StghrlJ0WlxEykjLJDAOZ
        x7/kWotHNr0Xn/r0h1xNAlTScg==
X-Google-Smtp-Source: ABdhPJz+SYU58UXNtLffWwIX10TXOvcwErevlzmrBAvHUCaWHX4cgfovvwUrODkvvvyrOoUsSZ4GqQ==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr7979750wrr.35.1623485481147;
        Sat, 12 Jun 2021 01:11:21 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id w13sm10619313wrc.31.2021.06.12.01.11.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 01:11:20 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        johannes.berg@intel.com, leon@kernel.org, ryazanov.s.a@gmail.com,
        parav@nvidia.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 2/4] rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
Date:   Sat, 12 Jun 2021 10:20:55 +0200
Message-Id: <1623486057-13075-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
References: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases, for example in the upcoming WWAN framework changes,
there's no natural "parent netdev", so sometimes dummy netdevs are
created or similar. IFLA_PARENT_DEV_NAME is a new attribute intended to
contain a device (sysfs, struct device) name that can be used instead
when creating a new netdev, if the rtnetlink family implements it.

As suggested by Parav Pandit, we also introduce IFLA_PARENT_DEV_BUS_NAME
attribute in order to uniquely identify a device on the system (with
bus/name pair).

ip-link(8) support for the generic parent device attributes will help
us avoid code duplication, so no other link type will require a custom
code to handle the parent name attribute. E.g. the WWAN interface
creation command will looks like this:

$ ip link add wwan0-1 parent-dev wwan0 type wwan channel-id 1

So, some future subsystem (or driver) FOO will have an interface
creation command that looks like this:

$ ip link add foo1-3 parent-dev foo1 type foo bar-id 3 baz-type Y

Below is an example of dumping link info of a random device with these
new attributes:

$ ip --details link show wlp0s20f3
  4: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
     state UP mode DORMANT group default qlen 1000
     ...
     parent_bus pci parent_dev 0000:00:14.3

Co-developed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/if_link.h |  7 +++++++
 net/core/rtnetlink.c         | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a5a7f0e..4882e81 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,13 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+	IFLA_PARENT_DEV_BUS_NAME,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 92c3e43..170e97f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_prop_list(skb, dev))
 		goto nla_put_failure;
 
+	if (dev->dev.parent &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
+			   dev_name(dev->dev.parent)))
+		goto nla_put_failure;
+
+	if (dev->dev.parent && dev->dev.parent->bus &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
+			   dev->dev.parent->bus->name))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.7.4

