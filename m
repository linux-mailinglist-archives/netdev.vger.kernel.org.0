Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87844326DE
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFCDW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:22:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46406 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfFCDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 23:22:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so4653665pls.13;
        Sun, 02 Jun 2019 20:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KmRAPnKxqRKba6oTJsLOzCHLkMezniOe4XDMZ4AA92c=;
        b=g0KUvNSRydARyGLbB2fDMcwQWkqc1M0bE4biJyDclWKRhMYT2mL3T8vmNw1qd+xwxT
         LCQ7TTk2nroh/nOaLz/+/nx3ROzIyTKoAoV2bLbdeGLNVP+G78U804qFUFPrEUQ582dL
         gRTd0BYI+Sd5731NeV/YMbrVIIhmJ3+lJAo4QkPIhXOfHigHpUF8Q5AjUPVAh5685fAN
         H0l6pcr1maOZwuUiTmDvlaRSEGA85x1ryiN8m3dvPN+4lL7PgVPbqeO1hXQ4mAjHdZV9
         6eQVFqVNYg/SzfqX9NJMVyZQ2Xf+1JKrOr4qxwckMAT51gdNO4zrZxrh3/wYU0fwi/su
         aPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KmRAPnKxqRKba6oTJsLOzCHLkMezniOe4XDMZ4AA92c=;
        b=cKXu1fa/Cx9fgQVPSDC1uCGTOvf9ZycBQZW+pbcvMBmeEyVBWaqJ8/sWC6h0r8TJa7
         YuHlGvTpQ6g/AWzp4We2iiLGi6eJMa+oZxaBGq2dKC/dZB+3mlL8FymXgJRlbbs9ln5V
         gHdl/GnZISQwwNMCaWROPA4Xu3zW4c/CgjSu0JFajq7mUS4zi6E4UmxHe87hYq83JzGB
         E5juTp55pD0jMRz/GppOAV/UnSO1Vn1B2p8L1bu8a0SV1WP6n0g2c5a6BzaL5DMDl4RB
         yAsTM01sdR1OVD6nFyL7nWqreFve1OaNjUOcvHmo+eo9IgTLNamRCuEpTMUXw7Jl+i/V
         +dMg==
X-Gm-Message-State: APjAAAV3gIVluTM6dYqKSSJ1veg67b5VNSGMprHQ2B+3d85e7EpyF3Sj
        bcBZdA0Mne/+qWlWIQYXchU=
X-Google-Smtp-Source: APXvYqwpfYH7HkEgILtPPxhVj8ePxi86Gg00rBEHOgWVdZdxe2vAyUmay69NcAybIIUVk2kPaqJ4fA==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr27214564plc.2.1559532148376;
        Sun, 02 Jun 2019 20:22:28 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id g15sm17145279pfm.119.2019.06.02.20.22.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 02 Jun 2019 20:22:27 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     davem@davemloft.net, daniel@iogearbox.net, petrm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com, lucien.xin@gmail.com,
        uehaibing@huawei.com, liuhangbin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] ipvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
Date:   Mon,  3 Jun 2019 11:23:36 +0800
Message-Id: <1559532216-12114-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
overflow on the underlying interface.

Attempting the set IFF_ALLMULTI on the underlying interface would cause an
error and the log message:

"allmulti touches root, set allmulti failed."

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index bbeb162..523bb83 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -242,8 +242,10 @@ static void ipvlan_change_rx_flags(struct net_device *dev, int change)
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	struct net_device *phy_dev = ipvlan->phy_dev;
 
-	if (change & IFF_ALLMULTI)
-		dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI? 1 : -1);
+	if (dev->flags & IFF_UP) {
+		if (change & IFF_ALLMULTI)
+			dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI ? 1 : -1);
+	}
 }
 
 static void ipvlan_set_multicast_mac_filter(struct net_device *dev)
-- 
2.7.4

