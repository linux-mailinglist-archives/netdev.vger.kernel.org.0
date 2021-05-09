Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46DD377683
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 13:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhEIL5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 07:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEIL5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 07:57:00 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E649C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 04:55:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d11so13701363wrw.8
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 04:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0hV4iGNIu4ljAp3MSQG/pucaqPLJ1WIQWPk6y7E6xZQ=;
        b=DLDEHgipsm27vWvlz6gRPmlrXobmSlD7uaACZDxI3DJ2QXgaZ1NX0VlGma7iXcgqK3
         ZGtXs4HQyNgX7H7YlkvaZg6fAAEIbsIvb9hmLJMF2A9v8lDMks+44DdpQxXRcHlN86Oc
         dh6anOgHQrPeo3NOc72ocNJhoXZhX8kb0PZGTx/kGUJ+MUNBY62UqgXP5hjrJyOrObR7
         pqWxd6sOBFCC+m48XeGt9zP7RI2TUcJP7p0WcCiPGReP9KN761uj7eDTLE8MPOQrPFUh
         BzB0CXkKTvg1bHMsqECrSjuJGIdwbShtOLL13ou+98HflDLnlvUmuWNFweFLZPKaXqUZ
         xkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0hV4iGNIu4ljAp3MSQG/pucaqPLJ1WIQWPk6y7E6xZQ=;
        b=IoqOADO58IpvtKujUmfpv70usMF+U3ehVI+VGdMv/eqa1lorkG2wdhq5puuubTLd18
         oXK9b+n8OG6C3LXF0TcHFDN6M7nI32XnDpf+on5BXkOhkLswzzlTgIGIQV2KMMr8VkM0
         WhlWLZ+Cy9cpFwsjSF37LOWteVWrB9lvYIftqmejOzGy2jh9bEJDiwouH3DT6d8J1tBz
         pSJWxQ7aYoIz62Or+QKFIj0+SBVFd6oSkf12+GDuFP720xeaVnJQQBqW3+RdH5x8QERZ
         Gt189km/7DuOLwdEZzN4oZ9Y8huWPctAUB5bNSihL0AocUl9Co3gdiazv1xZee2t6MrP
         /axQ==
X-Gm-Message-State: AOAM532/B8QT+KAmSl8/yAdIbn7D/Z3sdM+mtC6jm0KKgfPgMnS62HKm
        92qiBaCy6U2rGAW2/LbrYDU=
X-Google-Smtp-Source: ABdhPJwJsAPaVT7n+ksdN2TolguSsHHhwjhr5ew9cWYAz27O0w8/FHJZidPPmYtg9TbikhKQX/zEcg==
X-Received: by 2002:adf:a316:: with SMTP id c22mr24147411wrb.202.1620561356097;
        Sun, 09 May 2021 04:55:56 -0700 (PDT)
Received: from localhost.localdomain ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id y15sm17920661wrh.8.2021.05.09.04.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 04:55:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
Date:   Sun,  9 May 2021 14:55:13 +0300
Message-Id: <20210509115513.4121549-1-olteanv@gmail.com>
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
---
 net/dsa/slave.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3689ffa2dbb8..dda232a8d6f5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -798,13 +798,15 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 	struct dsa_switch *ds = dp->ds;
 
 	if (sset == ETH_SS_STATS) {
-		int count;
+		int err = 0;
 
-		count = 4;
-		if (ds->ops->get_sset_count)
-			count += ds->ops->get_sset_count(ds, dp->index, sset);
+		if (ds->ops->get_sset_count) {
+			err = ds->ops->get_sset_count(ds, dp->index, sset);
+			if (err < 0)
+				return err;
+		}
 
-		return count;
+		return err + 4;
 	} else if (sset ==  ETH_SS_TEST) {
 		return net_selftest_get_count();
 	}
-- 
2.25.1

