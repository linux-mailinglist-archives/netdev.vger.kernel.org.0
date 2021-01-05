Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55B22EB326
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbhAETCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbhAETCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9EC0617A3;
        Tue,  5 Jan 2021 11:00:55 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u19so1925350edx.2;
        Tue, 05 Jan 2021 11:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GLvxCKLmR2t5WVjRUZehiWKIjudvryuha5j5MLp+E+U=;
        b=qumLfxH/uosKGVeB1d+uK3MGmbPBDq3Tefsa6LeB4yOaqE4sDVmjq8n88J3Af9SWID
         zE/OzdCWUBmYqSDveMUrnjfExUwlKcXIKocVP4DRlKfB8X7dPGqH22aeXXE/q6RuD9Zb
         LQwfxmfEdGl3TbU+0kKPfiVdt/xC2UzgwNEoAb2tjMddMwrS4DBZLCzfkVXqKzIo0zW3
         CP9CZwsQphbG9aViNf0hnIKUqOBDi3ElTHZlnmNm2VBSM393jCAQK5YMPuys8IGY0V7X
         +dfIzPdUu6R7MiLk9T5blM730FvW/A6il2bYDlUbIgzJ1vBpdu7ow9UXKeZzSiAcXlmL
         98eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GLvxCKLmR2t5WVjRUZehiWKIjudvryuha5j5MLp+E+U=;
        b=MWtGXN+NbRv2wHJEFBYPCFMQ/iOrrzCIDIwwFJBynsegB+rB1cVCx6g23V+vDBPX48
         VD62MXH8CNrzBJgD6OuzXN1DM0dMACtmwgm83vouBqKWeYCin0VwPtfp7o/CT4xcD5I1
         Cz1Y+Wyu+V5/n4UU6zo9K23VTbkBWjhZnI1xjt/qXiTTR+3ovmTGE875l0tewMQTbjR3
         M4ib0aFzwPpVyOJ9Yf1uBsYkWOR7qnCpGwvGP9VZD7ybDvVU28lU1pJOt62HpNblPDr3
         OIhCnR/UBA2hmvesJdxSm29O2Q3N9ea0bCO5V2zHkfPaYPYO6YwHLlY/4CcfbcNWw5NL
         jZVA==
X-Gm-Message-State: AOAM530FSiRNQCUfVs8q+SpBGQcoXhY/dpSqcTBCtMJgB2G0KS3kM6sd
        XXXtNjHUwk7OHrozhADcA2k=
X-Google-Smtp-Source: ABdhPJy8kPqxEk8FQReSydm1oqxA729aS1Dqn6n2NIipxNBNdXArGt1146Pufkl9aVpc3ocJnHwq7g==
X-Received: by 2002:a05:6402:3546:: with SMTP id f6mr1184932edd.242.1609873253835;
        Tue, 05 Jan 2021 11:00:53 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:00:53 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 05/12] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Tue,  5 Jan 2021 20:58:55 +0200
Message-Id: <20210105185902.3922928-6-olteanv@gmail.com>
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

In the case of the appldata driver, an RCU read-side critical section is
used to ensure the integrity of the list of network interfaces, because
the driver iterates through all net devices in the netns to aggregate
statistics. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the netns's
mutex, is fine for that, because it offers sleepable context.

The ops->callback function is called from under appldata_ops_mutex
protection, so this is proof that the context is sleepable and holding
a mutex is therefore fine.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/s390/appldata/appldata_net_sum.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 59c282ca002f..4db886980cba 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -78,8 +78,9 @@ static void appldata_get_net_sum_data(void *data)
 	tx_dropped = 0;
 	collisions = 0;
 
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
 
@@ -95,7 +96,8 @@ static void appldata_get_net_sum_data(void *data)
 		collisions += stats->collisions;
 		i++;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	net_data->nr_interfaces = i;
 	net_data->rx_packets = rx_packets;
-- 
2.25.1

