Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6B27877D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgIYMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYMo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 08:44:57 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEAAC0613CE;
        Fri, 25 Sep 2020 05:44:57 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y11so2646850lfl.5;
        Fri, 25 Sep 2020 05:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCZD8UTHnmfs2h2ZSbFRWr2HJAvbw3OyNcDZ8aeNLW8=;
        b=Wl8sisiizEKz1tx18uw4vdEpahVK4b8EtKIkWgqdHiF9fUTuY47DZL03xAQ+VzU44H
         e5hDORWoXZIgXdGF/NGg44+YC8HId64bJCZGz2yClGWVSGoCi+O9IpdalI8rD90xwYg7
         wBqBNGb0uJyknn0aIg8ue7Y+fKfGSr7xhq04Qi3JhiLDejyNd8EWIG08NtAN2nzQa/6t
         Z1nv0a8R+CJk2Ky8UYEn5787kqsUHWTlz2EBeh98ybvYLfNoZVXN+INs/srAkv80Xy7D
         j4uBiSPdrhKS+SA6WvBTWnkGvfNXl/pc/NdZ8RlBL+sSLgYsn1gtsnCBWbZ/14bD+VF6
         YZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCZD8UTHnmfs2h2ZSbFRWr2HJAvbw3OyNcDZ8aeNLW8=;
        b=a/8jk4tcT5QgWaGLodwpRpogh0WZpE+Az+WSMMHZatL9lqXdiqbswWlHKvlQeMlbfn
         b5ShB6rod1/sesB5vyEmem6gjfGdBO5S6NYM1xDSMF4enWyyBiear4XgtVHpem0b4WxO
         EOeOe16uxKC7iLCysF830OS1RVDMc6GecvdK7QAGGHObMyjb3u4bcOpnQtGwbUeL1gq6
         XjbBS5Eyp1cl1GV8cL+KNATJ9YMx07V5pezxqEijRxmcscdJsAuMjtnbVqtls/8EVQwT
         90fJ3WzDahwDwIX5RdbXDscYKAQFpTB51ZnE2DmTkqA2f9VIe1NzQmyTxoYtY9FlxE3v
         WKIw==
X-Gm-Message-State: AOAM53303RY1JbaHu2s5E1MmJ2Q/FEwJ7GVmQJe2+/fXRwuqtzLJ4Xiy
        TOkgzJTNd4i4lnOVtyj9eG6PdEhIeEm7Jg==
X-Google-Smtp-Source: ABdhPJyxO/BXEnmblCPQ6UNE32w7YRIWXHbBE1l6kTXCW2Rcs9Cz3heg7PebOL7ktrdXrocqamQh9w==
X-Received: by 2002:a19:dd5:: with SMTP id 204mr1223418lfn.579.1601037895702;
        Fri, 25 Sep 2020 05:44:55 -0700 (PDT)
Received: from localhost.localdomain ([94.153.11.208])
        by smtp.gmail.com with ESMTPSA id m132sm2195163lfa.217.2020.09.25.05.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:44:55 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@gmail.com>
X-Google-Original-From: Ivan Khoronzhuk <ikhoronz@cisco.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     alexander.sverdlin@nokia.com, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ikhoronz@cisco.com>
Subject: [PATCH] net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop
Date:   Fri, 25 Sep 2020 15:44:39 +0300
Message-Id: <20200925124439.19946-1-ikhoronz@cisco.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To start also "phy state machine", with UP state as it should be,
the phy_start() has to be used, in another case machine even is not
triggered. After this change negotiation is supposed to be triggered
by SM workqueue.

It's not correct usage, but it appears after the following patch,
so add it as a fix.

Fixes: 74a992b3598a ("net: phy: add phy_check_link_status")
Signed-off-by: Ivan Khoronzhuk <ikhoronz@cisco.com>
---

Based on net/master

 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 3e17ce0d2314..6cb2162a75d4 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1219,7 +1219,7 @@ static int octeon_mgmt_open(struct net_device *netdev)
 	 */
 	if (netdev->phydev) {
 		netif_carrier_off(netdev);
-		phy_start_aneg(netdev->phydev);
+		phy_start(netdev->phydev);
 	}
 
 	netif_wake_queue(netdev);
@@ -1247,8 +1247,10 @@ static int octeon_mgmt_stop(struct net_device *netdev)
 	napi_disable(&p->napi);
 	netif_stop_queue(netdev);
 
-	if (netdev->phydev)
+	if (netdev->phydev) {
+		phy_stop(netdev->phydev);
 		phy_disconnect(netdev->phydev);
+	}
 
 	netif_carrier_off(netdev);
 
-- 
2.20.1

