Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE13DCB3A
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhHAKly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhHAKlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:41:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAFDC0613CF
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:41:42 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n11so8667354wmd.2
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IslbLMsuod0jSlf4z955FHKvdh7uY9Nxm+1MXV7oAlk=;
        b=Amq4X3Ai1G2uniprYP8QDwp5LueoyVPVghc0oS9tVGdUYF/WbiGsz/wYCrW5Z9WlOG
         5cJY0gVh8mjSo3mKQzmhivY2xlFiVTopxPfBdAc+TQYCXv+S8xTWxKVX4LW3XCYPe2WW
         UmFWvYHE38mb3HW3fKJyQkrrPkKyFrIk3zvnrLCs6P1qQtPDwyOtENcNbPn+7njJc0P6
         5IqYHGn2pJhf1ST96DLobOmLaaihTx29SAJMUbekWiwx8hH3ixWAwMEh5NfWLJvukr+1
         G0z8C3OKZSnO9/cN3SBfQH6NnmFW+V3bWCx/Q8YOWyiQdixYxzTULaxrbiaDeVhyfWZD
         qrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IslbLMsuod0jSlf4z955FHKvdh7uY9Nxm+1MXV7oAlk=;
        b=Y1d6DmFn49RoDrKF5iHiSVlOsxZ803vM5Fzh9OQ4IGcTYXOgx31Um0hpVn/kAYAiIE
         HvX4zQuQ1hiKAoQX0OPzx2ShgGG0B8JSuvAvYCm7zzrds5vs24u5kQ0YteTa+uWPI4oy
         BJhQkY2cTQIEXHqhwbttRJ6Ro/ahUtzgUSeYMjIBZwlRhldurYXYAcI44nvfesG31ULb
         CfPDfqU6YjSzuUh/K5z22UbxJW/bX7gvE44VurYyDENQu/SxqLos0MTJ+j9m2xQsa6/x
         pWpfCzSnBNv4U2iqW8qMjJxatUeQuwmlYkCLR5xz29Apu7l73kulZievhDnq3LwdvRUr
         0PUA==
X-Gm-Message-State: AOAM530oXkaB+jfrbnhqRSV//5oqDHqoUDt4Zcce4VxkmCJ6ydb6kb0K
        NCdPgD46+57I0AL5uOHJWL8xm3WPzEQ+Xg==
X-Google-Smtp-Source: ABdhPJx4hTxnhO83LsxZQwb6jMK1PkrMF+SQxb9K2q2Lfnxa/evMS+epgkVcVVAUBMEdM2nvrKKinQ==
X-Received: by 2002:a1c:acca:: with SMTP id v193mr11838830wme.107.1627814500920;
        Sun, 01 Aug 2021 03:41:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id v15sm7601822wmj.39.2021.08.01.03.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:41:40 -0700 (PDT)
Subject: [PATCH net-next 4/4] ethtool: runtime-resume netdev parent in
 ethnl_ops_begin
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Message-ID: <05bae6c6-502e-4715-1283-fc4135702515@gmail.com>
Date:   Sun, 1 Aug 2021 12:41:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a network device is runtime-suspended then:
- network device may be flagged as detached and all ethtool ops (even if not
  accessing the device) will fail because netif_device_present() returns
  false
- ethtool ops may fail because device is not accessible (e.g. because being
  in D3 in case of a PCI device)

It may not be desirable that userspace can't use even simple ethtool ops
that not access the device if interface or link is down. To be more friendly
to userspace let's ensure that device is runtime-resumed when executing the
respective ethtool op in kernel.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/netlink.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e628d17f5..417aaf9ca 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -2,6 +2,7 @@
 
 #include <net/sock.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/pm_runtime.h>
 #include "netlink.h"
 
 static struct genl_family ethtool_genl_family;
@@ -31,22 +32,40 @@ const struct nla_policy ethnl_header_policy_stats[] = {
 
 int ethnl_ops_begin(struct net_device *dev)
 {
+	int ret;
+
 	if (!dev)
 		return 0;
 
-	if (!netif_device_present(dev))
-		return -ENODEV;
+	if (dev->dev.parent)
+		pm_runtime_get_sync(dev->dev.parent);
 
-	if (dev->ethtool_ops->begin)
-		return dev->ethtool_ops->begin(dev);
-	else
-		return 0;
+	if (!netif_device_present(dev)) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (dev->ethtool_ops->begin) {
+		ret = dev->ethtool_ops->begin(dev);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	if (dev->dev.parent)
+		pm_runtime_put(dev->dev.parent);
+
+	return ret;
 }
 
 void ethnl_ops_complete(struct net_device *dev)
 {
 	if (dev && dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
+
+	if (dev->dev.parent)
+		pm_runtime_put(dev->dev.parent);
 }
 
 /**
-- 
2.32.0


