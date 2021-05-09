Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E7377818
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 21:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhEITew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 15:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhEITev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 15:34:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20061C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 12:33:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x5so14354592wrv.13
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 12:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ShSnL7vWGYmBedJ33UtO+jy/1lsE5owFEjkB5BgeB4=;
        b=oOBtpoj9z+wHD1kLWO6jscALdLbtYtUztHDYRi2AqjhcbnsfiY7aanvNsn7ldCKAbc
         xyQE+Xq8icJ+votnqRVR+FDXRGjubiCsCem7RXCVBAcdrjRz8dOfr+PwKqZxmEFbHbzq
         v+AyJiC5FW6mR7cLcGWu+MGgDauzlXhA8gFp32nNHKNvmpJdTaxHhQ622PxsjL8BPx1U
         D48Hi1kWvhFy0hNY3izPE3m8Byn5aJxqy8YgxkqE5xvnBmLndGNsyHzckG9LMNyluxUH
         U6iKT4wWNRxsROCk/vPGffCO/ZB3kBhzFZm8QXhM40Ld4iRJ/Tz93/lXUqA+ynH8Ri39
         Ovng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ShSnL7vWGYmBedJ33UtO+jy/1lsE5owFEjkB5BgeB4=;
        b=O6xYRg5/q/4olPvEIeeHLcyGinXhgIo6yitiiKMgm7l+3F3PDBtfzZ7tabXFxjNUiP
         vf7xOLeUKBP5paZm7faaltMjMwz7SZTwcaVaXzVlah9htU1+v4+JXRWy5VYg1ZHtfk2U
         WlvVHPCVMQezK40KmEIm7nHxfAAe6ZABHBm5DkMKCMrAGP2vjp9w8rHeUk/DFk6QJIh5
         C07uDlfooH3pOZ5su55QQko+eojY0VpgFZDUscl06dsBNdBoacl406gtprzioqNsh7g3
         yklvGuGwUdRP+nByEjOc4fSCcnNTI/QQapmq8weXpTwf7WH+XjJ+96Ys0Eo6135Hqnf0
         Zt3Q==
X-Gm-Message-State: AOAM532aw29ktGwg561WRdupKfn09ajtNwgdxMUIL4tq5GiLE1/0meMJ
        6eMZ7R7mwO+kfDY/RVLWSJfkZic7Gx8=
X-Google-Smtp-Source: ABdhPJxpFjHIIzjkjc+B62tYEHkvsWK0M8NF0CGOr1nAkGdV2nK5tO99nHopOIoWhUqTVC1IN4z+Hg==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr25768787wri.86.1620588824377;
        Sun, 09 May 2021 12:33:44 -0700 (PDT)
Received: from localhost.localdomain ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id v17sm18768783wrd.89.2021.05.09.12.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 12:33:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net] net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
Date:   Sun,  9 May 2021 22:33:38 +0300
Message-Id: <20210509193338.451174-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA implements a bunch of 'standardized' ethtool statistics counters,
namely tx_packets, tx_bytes, rx_packets, rx_bytes. So whatever the
hardware driver returns in .get_sset_count(), we need to add 4 to that.

That is ok, except that .get_sset_count() can return a negative error
code, for example:

b53_get_sset_count
-> phy_ethtool_get_sset_count
   -> return -EIO

-EIO is -5, and with 4 added to it, it becomes -1, aka -EPERM. One can
imagine that certain error codes may even become positive, although
based on code inspection I did not see instances of that.

Check the error code first, if it is negative return it as-is.

Based on a similar patch for dsa_master_get_strings from Dan Carpenter:
https://patchwork.kernel.org/project/netdevbpf/patch/YJaSe3RPgn7gKxZv@mwanda/

Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1 -> v2: preserved variable name of "count" instead of "err".

 net/dsa/slave.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3689ffa2dbb8..988af45dd38f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -798,13 +798,15 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 	struct dsa_switch *ds = dp->ds;
 
 	if (sset == ETH_SS_STATS) {
-		int count;
+		int count = 0;
 
-		count = 4;
-		if (ds->ops->get_sset_count)
-			count += ds->ops->get_sset_count(ds, dp->index, sset);
+		if (ds->ops->get_sset_count) {
+			count = ds->ops->get_sset_count(ds, dp->index, sset);
+			if (count < 0)
+				return count;
+		}
 
-		return count;
+		return count + 4;
 	} else if (sset ==  ETH_SS_TEST) {
 		return net_selftest_get_count();
 	}
-- 
2.25.1

