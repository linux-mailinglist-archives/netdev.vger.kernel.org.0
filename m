Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71982EB328
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbhAETCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbhAETCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:07 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22212C0617A5;
        Tue,  5 Jan 2021 11:00:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id q22so1906708eja.2;
        Tue, 05 Jan 2021 11:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pumKytNb6HfM0fji93xr5G/BhQEYT7JsjEW2ZBlR5iU=;
        b=JEckJaQsFgR2VLSNLG5i7z0+KlnFs83ZYxvR0iQpvNPQVQcSticPBwdGCbSF9D1XDP
         faMVx76guT6YBo+oghMniuv45XGzCI9kOXx34jKAUzWzgH3l2lWQ8qRYGB6JP12yfGdf
         PXk1Uyi+mFeT3ptjmyVyAmzEG8s03OO8PMaQEcI5fSbhi+CZdoBgQozSyOlIBYee4ka/
         TuQC8hW7oOtFk41zzRi7d5iy1v8jOvtmUcz3y0ARCtdpxBwKE5wnx5JZLZIicLXqTBHJ
         Aqa1KrvCJBQmuvF7CwMtnx1arxBqIA8R27l2ApWKEoYhQLef8w9qWcrMbb+cWzRe4dls
         E77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pumKytNb6HfM0fji93xr5G/BhQEYT7JsjEW2ZBlR5iU=;
        b=ihVIQGBykCeYFC4LDic7xfQ7ebN7NNGOI3pf6+NsCyNm1GWWxNYOi/qsf56ytEFjDE
         jScEIeZlmwktxfXx+iVfgH0VixxiDedd7bRgU49xkOTjJxuulBkdg5qS2KvZzKtUvMlU
         CBXnc1c7M8IWcmT2EueMaSa5jQ0hRq1Skm9KCTlPCPQP7A9HnW33nvlV6+8v/sXiH+NO
         7VP1lMvd1GbBAYQxin8dRJE1NXIy080mLBTOBwaXGtW9fB5nvoje+nqRwd9fNpgJpUxu
         IEY41GxFgqRuRh7e5ypF+Vjc/AYxTbbda/1MFhqcfMPWl2nB5KTzvhKnaoWxnZnZ670m
         aXvg==
X-Gm-Message-State: AOAM531J2qZQAynWxNTn42JmEvSijqi26/cEOfloB2N63UR7SagY5+dT
        YjWQlxUct51eoVhxicaiGw0=
X-Google-Smtp-Source: ABdhPJz+1ICzC5RVM3oZs0oQoaJmiaftG0zPzA6tae5qdGfc+GpxdTiRp0F9FQexln0n4DdvvvIthg==
X-Received: by 2002:a17:907:d10:: with SMTP id gn16mr478354ejc.496.1609873257847;
        Tue, 05 Jan 2021 11:00:57 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:00:57 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 07/12] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Tue,  5 Jan 2021 20:58:57 +0200
Message-Id: <20210105185902.3922928-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
References: <20210105185902.3922928-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The LED driver for HP-PARISC workstations uses a workqueue to
periodically check for updates in network interface statistics, and
flicker when those have changed (i.e. there has been activity on the
line). Ignoring the fact that this driver is completely duplicating
drivers/leds/trigger/ledtrig-netdev.c, there is an even bigger problem.
Now, the dev_get_stats call can sleep, and iterating through the list of
network interfaces still needs to ensure the integrity of list of
network interfaces. So that leaves us only one locking option given the
current design of the network stack, and that is the netns mutex.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 3cada632a4be..c8c6b2301dc9 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -38,7 +38,6 @@
 #include <linux/ctype.h>
 #include <linux/blkdev.h>
 #include <linux/workqueue.h>
-#include <linux/rcupdate.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/hardware.h>
@@ -355,25 +354,29 @@ static __inline__ int led_get_net_activity(void)
 	int retval;
 
 	rx_total = tx_total = 0;
-	
-	/* we are running as a workqueue task, so we can use an RCU lookup */
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+
+	/* we are running as a workqueue task, so we can sleep */
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
+		struct in_device *in_dev = in_dev_get(dev);
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
-		struct in_device *in_dev = __in_dev_get_rcu(dev);
 
-		if (!in_dev || !in_dev->ifa_list)
+		if (!in_dev || !in_dev->ifa_list ||
+		    ipv4_is_loopback(in_dev->ifa_list->ifa_local)) {
+			in_dev_put(in_dev);
 			continue;
+		}
 
-		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-			continue;
+		in_dev_put(in_dev);
 
 		stats = dev_get_stats(dev, &temp);
 		rx_total += stats->rx_packets;
 		tx_total += stats->tx_packets;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	retval = 0;
 
-- 
2.25.1

