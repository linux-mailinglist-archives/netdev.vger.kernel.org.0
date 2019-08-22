Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89349A0EA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392918AbfHVUOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:14:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40017 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392846AbfHVUN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id e8so9116556qtp.7
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SlMiGqC3+bIcQkBH2aV46vyGuLLlY9uT74PlVOHOcQw=;
        b=cj9qA+C7bTQkWmXXf/dOLSA1VK1lFsJYL/AmPqJyErNLpJRCY7s6zUndtpOlLWGSNF
         RhO6VQV+PazZU64ggimwh1Gq+SEFr8NBQsZd9vzsAsFTaFSMZ89LRHDJEMEva7Tprj2u
         W+wkx0SCQM9v6i/N9gv0jM1/kmNXzG8Cc0qxyOuDwvXO5GFO+tN9O69zUbm2ntnrHQaw
         xVmyM2xLbO/me8t8zz8mb8iDW+bm60n1VFWJL/sVtqxDTRvrgl9CPKBuxJ+/rmTOlVfT
         TYEJEtnbwnNh9h9fZ0OgpiiuBttV8Duc4BkFKVONExoJwd2Z6OK9Zutc32rUPPuKXp1W
         8WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlMiGqC3+bIcQkBH2aV46vyGuLLlY9uT74PlVOHOcQw=;
        b=SmMtZdtx5vx5srbYqzstdp5Uy1z7JY4ktUFu7vqwS+V6FiWD15Bneqk7f+uBSYEHS8
         sXpbCkPx7N6ppS/2HUzBSjnbb81ZXtfSTsgSv1KqqPSH0TUP+vbJVHdNra19WWiyQ00+
         Lg19ntclwKhnQni/I4y4r7OQm0cFdGVmtalqcg+U5YzqIO0dnSJHxhqpe3ai6AlUx8nV
         PeLidnItgZS+vEJBAYOkh/rtfx/kGbvd6uIw0reHSyVWjUXszyqoZVqH9lG5yFzMyoZp
         F7KQLUvnGnNmmjdktyDOo+MzBS15tadua5BJmGRR8YuFKIH6KtkqVDpqq1g+qdXXhVoC
         4pqw==
X-Gm-Message-State: APjAAAVe4AsnfP5PKMNozZPeKSa3r1EEpjJ3Q/C6049m0aXFqHI2uRQy
        T6th2SPcXgMbpSnjSQP8MvCH3P4S
X-Google-Smtp-Source: APXvYqyiitFSyA7vlijLBNn6dyCeltPqoaKMnT7DBT61F4Qe0c4ajlAtL6LiICsURbdq0YZPvtH0bg==
X-Received: by 2002:ac8:358e:: with SMTP id k14mr1445959qtb.83.1566504835538;
        Thu, 22 Aug 2019 13:13:55 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q42sm336086qtc.52.2019.08.22.13.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:54 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: program VLAN on CPU port from slave
Date:   Thu, 22 Aug 2019 16:13:22 -0400
Message-Id: <20190822201323.1292-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA currently programs a VLAN on the CPU port implicitly after the
related notifier is received by a switch.

While we still need to do this transparent programmation of the DSA
links in the fabric, programming the CPU port this way may cause
problems in some corners such as the tag_8021q driver.

Because the dedicated CPU port is specific to a slave, make their
programmation explicit a few layers up, in the slave code.

Note that technically, DSA links have a dedicated CPU port as well,
but since they are only used as conduit between interconnected switches
of a fabric, programming them transparently this way is fine.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c  | 14 ++++++++++++++
 net/dsa/switch.c |  5 ++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 82e48d247b81..8267c156a51a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -332,6 +332,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -383,6 +387,9 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
+	/* Do not deprogram the CPU port as it may be shared with other user
+	 * ports which can be members of this VLAN as well.
+	 */
 	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 }
 
@@ -1121,6 +1128,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 
+	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
 	return 0;
 }
 
@@ -1151,6 +1162,9 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	if (ret == -EOPNOTSUPP)
 		ret = 0;
 
+	/* Do not deprogram the CPU port as it may be shared with other user
+	 * ports which can be members of this VLAN as well.
+	 */
 	return ret;
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 489eb7b430a4..6a9607518823 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -232,7 +232,7 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 	if (ds->index == info->sw_index && port == info->port)
 		return true;
 
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dsa_is_dsa_port(ds, port))
 		return true;
 
 	return false;
@@ -288,6 +288,9 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	if (ds->index == info->sw_index)
 		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
 
+	/* Do not deprogram the DSA links as they may be used as conduit
+	 * for other VLAN members in the fabric.
+	 */
 	return 0;
 }
 
-- 
2.23.0

