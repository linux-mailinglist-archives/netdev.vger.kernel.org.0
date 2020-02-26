Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC1417067B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgBZRsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:48:22 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36044 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:48:22 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so1551839pjb.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6DLzKXwALtpZesLpDIOrxCFZbd63obNFntK9/eaUVBM=;
        b=G9mvHHey0dVN6okTG1AwZBJnla25x14guj/+Fy047GsFx9ltWrLC5gCmOxeIyv6W3Y
         16neI/O3gzQ9rzx5m7FBxcSnyK0y1ic1pViHfWG/7G/sh4tjulc/1WWaBSJr4F3/D+CE
         c4GWIAJRHLelZYw+Vbe35gzLxyzvehbbKLp5nyXpYIry2Riw57bCq0iPAW4kU0sMO2CM
         0Pw7iPF4UGjHmsVgY3t8XKTJIIcv+fyAAItMogyLB/p7dYcTJ5/89Eznz1B0lZtulThx
         12vbogejn8C5lyMzeutc1rPfjbeZwL1TBpCH/y6wpcFY1oSTLJ0WUUtn4MFZ3MqcLpre
         TcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6DLzKXwALtpZesLpDIOrxCFZbd63obNFntK9/eaUVBM=;
        b=pU+TPGd7CbFkbgOStoW3GiPMzH5a7xdupwPfgkAl9Kilbjgq6JeKG1BVx2H3n6lygH
         8DOeFuBx3FgFahRokwEjJ0tjpqYJeRXc60FSa3X2WBVqAOYDKHJHdxBUZa4T3QIxCgwB
         +NHHWe/R5xpRTFJwrGojf/B3h084Yv7DMyQIk927NKpvy0BRPPKNxABaAQJJ6uYfaeam
         wkEWCM8LfwghqqOLV8PfQBFwMXFspE+Xi+zejbYhzEZYZeiNeUehmco0gfL19wBXxQbQ
         VnXFEjpt3HeDEAqXlkDPAcX32QGW/lCxodm6s3sO6T8vnOgQSVj4VNj0Fxoues2YIgPY
         Gk8g==
X-Gm-Message-State: APjAAAUyny1NYqx0sJlkDPlPKTDnIpFwmgXMq/QWPz0bFlYY0t669stG
        Yrc6kSCBQe+F4SBDVGMCWUQ=
X-Google-Smtp-Source: APXvYqx7+WzODygwHRGdh7HfuJg2/5nIDX04vCUhu1A0f11exJKIZ3KvLKIr9YsEXx9BUdUyCR7yjw==
X-Received: by 2002:a17:90a:c706:: with SMTP id o6mr242176pjt.82.1582739301032;
        Wed, 26 Feb 2020 09:48:21 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id ep2sm3458884pjb.31.2020.02.26.09.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:48:20 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 07/10] net: rmnet: do not allow to change mux id if mux id is duplicated
Date:   Wed, 26 Feb 2020 17:48:14 +0000
Message-Id: <20200226174814.5965-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically, duplicate mux id isn't be allowed.
So, the creation of rmnet will be failed if there is duplicate mux id
is existing.
But, changelink routine doesn't check duplicate mux id.

Test commands:
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link add rmnet1 link dummy0 type rmnet mux_id 2
    ip link set rmnet1 type rmnet mux_id 1

Fixes: 23790ef12082 ("net: qualcomm: rmnet: Allow to configure flags for existing devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 93745cd45c29..bdb88472a0a0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -309,6 +309,10 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
+		if (rmnet_get_endpoint(port, mux_id)) {
+			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
+			return -EINVAL;
+		}
 		ep = rmnet_get_endpoint(port, priv->mux_id);
 		if (!ep)
 			return -ENODEV;
-- 
2.17.1

