Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C92EB311
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbhAETCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAETCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:05 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865D6C0617AA;
        Tue,  5 Jan 2021 11:01:08 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c7so1881250edv.6;
        Tue, 05 Jan 2021 11:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o9S5VetFLcZ6A9nQu4WMhm39cSlo6GMb/Zh6iH2PAWo=;
        b=YWokJ4VPJ94sBnkT+J4C7IXLt2kDzNBiTghXcM82L4KlMYRDSQqifLNZOGQ5Ut9y9y
         ZYiZ82rB9AIHdypa4FsXAC26qJoxHElT0kBMRGUjrsc29JcTFDlY94P4nE2dlq8lkW5p
         RObbbo/amQfqkKgkEHtgtEG6GmOiOS8vXyggValuLbpZUJLcOgUnstTIgSnT4Cl+PF0r
         M7LICV5lt5TZgUn1E3t7REd9NPVkyHWhDTfuYNvSIgwZAWGeCko00gqk4ZhFi44rujaV
         0754bHfrxdO5Y9swDHvq9Ejhryrsc5R+dyJJGPIwMT7udP2PqylpCYgrjVtcl5BRYJ9I
         0TPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9S5VetFLcZ6A9nQu4WMhm39cSlo6GMb/Zh6iH2PAWo=;
        b=liobCGwy7ffWz3HfrUCansUyENiSZvAfkoNT4AxB/b/f55cKdgXp7/yPA6YzIYGckP
         MAVcYLAOWkCv+of2sWHvowTDDI7IWIe0srsb9klMnMumdsDdvNJVoTdXPgEN8fZMJ7jh
         KRizWR5YVr8nkop7Upo/OXv+dKaFuqc3O1TdiSHpuvOHN8f4eNORqBNwvzlLpRDmjegT
         3bqNid7XNmxv4YMmsHw7P8loHurRP/MGo7q9kxY1kYwdaLB+/X1OrRYAsNCo/CWbZK32
         fe4S1H6QSgt1s1mxvzNrd/90zbQyIcV20H9XvqFGyvZTdSjxOIULI/cmn8EGirwTpN/Y
         CEFw==
X-Gm-Message-State: AOAM532LEp7KHnf4/R3iU8ZE8dGC5wM5EvLFZmkIsG+HseV1lM9pFyeh
        PVvHLfPtNaAbAT4Wo1DFHQw=
X-Google-Smtp-Source: ABdhPJxjE2k61m92yxHS+AwU9WB9vDDtGHYZ1kuHbwT7yr8ORT7g6VgNhr8Kz8oPy6UDV4hKTq121A==
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr1186577edb.225.1609873267285;
        Tue, 05 Jan 2021 11:01:07 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:01:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Westphal <fw@strlen.de>, linux-s390@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dev@openvswitch.org
Subject: [RFC PATCH v2 net-next 11/12] net: mark ndo_get_stats64 as being able to sleep
Date:   Tue,  5 Jan 2021 20:59:01 +0200
Message-Id: <20210105185902.3922928-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
References: <20210105185902.3922928-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all callers have been converted to not use atomic context when
calling dev_get_stats, it is time to update the documentation and put a
notice in the function that it expects process context.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/netdevices.rst | 8 ++++++--
 Documentation/networking/statistics.rst | 9 ++++-----
 net/core/dev.c                          | 2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..944599722c76 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,12 @@ ndo_do_ioctl:
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization:
+		none. netif_lists_lock(net) might be held, but not guaranteed.
+		It is illegal to hold rtnl_lock() in this method, since it will
+		cause a lock inversion with netif_lists_lock and a deadlock.
+	Context:
+		process
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 234abedc29b2..ad3e353df0dd 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -155,11 +155,10 @@ Drivers must ensure best possible compliance with
 Please note for example that detailed error statistics must be
 added into the general `rx_error` / `tx_error` counters.
 
-The `.ndo_get_stats64` callback can not sleep because of accesses
-via `/proc/net/dev`. If driver may sleep when retrieving the statistics
-from the device it should do so periodically asynchronously and only return
-a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
-allows setting the frequency of refreshing statistics, if needed.
+Drivers may sleep when retrieving the statistics from the device, or they might
+read the counters periodically and only return in `.ndo_get_stats64` a recent
+copy collected asynchronously. In the latter case, the ethtool interrupt
+coalescing interface allows setting the frequency of refreshing statistics.
 
 Retrieving ethtool statistics is a multi-syscall process, drivers are advised
 to keep the number of statistics constant to avoid race conditions with
diff --git a/net/core/dev.c b/net/core/dev.c
index d48b75479b3e..6b7cdf8ab875 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10389,6 +10389,8 @@ void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

