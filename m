Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB9C9A0E8
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392883AbfHVUN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:13:57 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42157 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392871AbfHVUNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:55 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so6299821qkm.9
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kVaKki6ux1xRm53Eihekl0W9/s6CnKLUCdT3K9sahc=;
        b=ieMVSKspTmTDKV9WXhgs/BVVxDZalsOGYV+Bevia4AWFMJdXIficzXCK3zxQiphFkX
         3KDK5tVQR/efl1KIA8G2B8gnJdaNPmjENI8V8SIBobxpnsZR3eE+0xUHEYZNb2sacwze
         q2XLK4MD8wcjgKerQfb8fKI6WHunycMEl902A1L4T5ZXiwpISbpnHpT19lSB6WMRxZF+
         pGih8GcO+K3wDN3jfselJLyp6b+6m7sdnIkN+PNXXpnJY8BO33tnxrlK9ZCyA2+kXtlB
         OBjmqHg/iZjw0PHen16g0QWDqT9T3ZE2J12MpUDCQ8gJ+mjxLhVZdID0T2PGNG2SgbjQ
         TJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kVaKki6ux1xRm53Eihekl0W9/s6CnKLUCdT3K9sahc=;
        b=TWmLySvwqAWIWSuob9nvKSgD1wQw+SnvjM+4hDyKYsFhjtJDVRvwBP35cSAdescla7
         2VxMuqLpJaPxoftrUxs/ZB+d6ilUTAao1jE6inU4bmgUsDsjXNcfbGhvuzCysCCaXkS/
         ev5+37vXz1b0fNbVJYZnIby3NOz8c5vP0Nd9KqbCL6xoEFzKwJI7T2s0/+UAaq9viGPm
         7viVJmS5tj8hq+9OKXaijViqviXXM4fGQXlRRT/0EHmHPKvihodgHS9kxZvbJwJCMkFO
         d460NSQY0cZ86OfoFuFbfUAGU62/Ek+ToaAo0Ze1q8tbKRzVFdokk+Eyy9Zv//0Jfa9A
         GfCw==
X-Gm-Message-State: APjAAAWVcEbI4qSwXGKwr9hNcD5WOH3k0DYyiVrxYX23a6nDhnfz3tjj
        2SJAKeHNh5ug1wBmOHgFDrjeSrKq
X-Google-Smtp-Source: APXvYqyY1qzgpp0zUcWh4QMgHJYd8fc/Cu1rl/O5PL0RQYmNumePFHgZmKKMk7Qljx6Bpe25LRmGiA==
X-Received: by 2002:a37:c20d:: with SMTP id i13mr841041qkm.45.1566504834094;
        Thu, 22 Aug 2019 13:13:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d12sm392159qkk.39.2019.08.22.13.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:53 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 4/6] net: dsa: check bridge VLAN in slave operations
Date:   Thu, 22 Aug 2019 16:13:21 -0400
Message-Id: <20190822201323.1292-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge VLANs are not offloaded by dsa_port_vlan_* if the port is
not bridged or if its bridge is not VLAN aware.

This is a good thing but other corners of DSA, such as the tag_8021q
driver, may need to program VLANs regardless the bridge state.

And also because bridge_dev is specific to user ports anyway, move
these checks were it belongs, one layer up in the slave code.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/port.c  | 10 ++--------
 net/dsa/slave.c | 12 ++++++++++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ef28df7ecbde..9b54e5a76297 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -348,10 +348,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 }
 
 int dsa_port_vlan_del(struct dsa_port *dp,
@@ -363,10 +360,7 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
 int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8f5126c41282..82e48d247b81 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,6 +323,9 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+		return 0;
+
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	err = dsa_port_vlan_add(dp, &vlan, trans);
@@ -377,6 +380,9 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+		return 0;
+
 	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 }
 
@@ -1099,6 +1105,9 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
@@ -1126,6 +1135,9 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
-- 
2.23.0

