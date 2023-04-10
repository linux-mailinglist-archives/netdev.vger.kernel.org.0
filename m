Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F236DC444
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDJIYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDJIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:24:05 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F407430E8
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 01:24:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso12253242pjc.1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 01:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681115043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=onU/a4pRegUaiTG8cIbeJcQZlX67EiQQZDYd/JQ1SbM=;
        b=iY7+H20i6+81z4c6UCCQYlqIQSPyxsZ7ADyZoVEQYnlm8w10V5zNVkhTJ+g+svO55e
         P7OVuKQP9OSUShVQmJ7SvftVFLc6TPKnoV4O3r3XGNt71dJK6Xnm7/5yN8YUW6zjR1vO
         iHE7rDU12aeacfJLzQDcwSwkzidskXmMhQH6mpDiFYRce5MMDBtMLZvAlFAuasNQgrb4
         KqASau4mwU3nkfOnEwBXBpx50qcKT3P77pl8DZUTUNolquhao58JpzgDdq9A9gJISg7E
         Zi2jY6rRy9RXffF5KUYbu5ESGvZNnkc6rHQ8DhXpNCY7sBMv7iRRKIM1xgBGTWz8rIYR
         cY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681115043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=onU/a4pRegUaiTG8cIbeJcQZlX67EiQQZDYd/JQ1SbM=;
        b=NzuctZBxzfqLZCZD6qNeIY8i11xTdk4Y7zhkYEhTwvA9zcW2Z4/NQKySkQghlef6cQ
         VFmdszyjQ0hlLlSl168vlZgTc1l5djdKCHUIf3cKBS7+nU37fei8jBkgOpYpcAY3D2Kn
         JOi9CeumuDTL2Xm5voU6rLJHxEY0s3hQDf8tqarkHIMg01qo0bJrR5PsAuUNQdD4bFRh
         fHrJMx1wjsY+kUYbirv8jVEqLNBK2ktKIvO+N+2Jne8Dl/Fq5VtUsUsS3V1HyTNNHPww
         M7jBQdeS7Pju4mYw7TIxGMCr0A+lcZCwa8ZbC7/NSB4bek+XH2km8dj4eeve6mp1jhry
         Rd9w==
X-Gm-Message-State: AAQBX9eA3rKKEovoy5Av1uIImyXNbcsZdh5EZz7V6HjmSQKQ41VmPXOu
        LQl7frb5ivRMZbkebI5QMe/JDirVjsS4+ZWV
X-Google-Smtp-Source: AKy350ZMbZSeOFauLAbN1mpnSvUV/Qki7N2rL3+hrjQX7PqLXZGlS1W1DFNbQiokE8Avt7c3f4sTjQ==
X-Received: by 2002:a17:903:234c:b0:1a1:8d4e:a71d with SMTP id c12-20020a170903234c00b001a18d4ea71dmr15270821plh.46.1681115043488;
        Mon, 10 Apr 2023 01:24:03 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902bd4c00b001a5023e7395sm6821168plx.135.2023.04.10.01.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 01:24:02 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv3 net-next] bonding: add software tx timestamping support
Date:   Mon, 10 Apr 2023 16:23:51 +0800
Message-Id: <20230410082351.1176466-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bonding only obtain the timestamp (ts) information of
the active slave, which is available only for modes 1, 5, and 6.
For other modes, bonding only has software rx timestamping support.

However, some users who use modes such as LACP also want tx timestamp
support. To address this issue, let's check the ts information of each
slave. If all slaves support tx timestamping, we can enable tx
timestamping support for the bond.

Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: remove dev_hold/dev_put. remove the '\' for line continuation.
v2: check each slave's ts info to make sure bond support sw tx
    timestamping
---
 drivers/net/bonding/bond_main.c | 36 +++++++++++++++++++++++++++++++--
 include/uapi/linux/net_tstamp.h |  3 +++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..3b643739bbe7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5686,9 +5686,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				    struct ethtool_ts_info *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct ethtool_ts_info ts_info;
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	bool soft_support = false;
+	struct list_head *iter;
+	struct slave *slave;
 	int ret = 0;
 
 	rcu_read_lock();
@@ -5707,10 +5711,38 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 			ret = ops->get_ts_info(real_dev, info);
 			goto out;
 		}
+	} else {
+		/* Check if all slaves support software rx/tx timestamping */
+		rcu_read_lock();
+		bond_for_each_slave_rcu(bond, slave, iter) {
+			ret = -1;
+			ops = slave->dev->ethtool_ops;
+			phydev = slave->dev->phydev;
+
+			if (phy_has_tsinfo(phydev))
+				ret = phy_ts_info(phydev, &ts_info);
+			else if (ops->get_ts_info)
+				ret = ops->get_ts_info(slave->dev, &ts_info);
+
+			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) ==
+				    SOF_TIMESTAMPING_SOFTRXTX) {
+				soft_support = true;
+				continue;
+			}
+
+			soft_support = false;
+			break;
+		}
+		rcu_read_unlock();
 	}
 
-	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-				SOF_TIMESTAMPING_SOFTWARE;
+	ret = 0;
+	if (soft_support) {
+		info->so_timestamping = SOF_TIMESTAMPING_SOFTRXTX;
+	} else {
+		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+					SOF_TIMESTAMPING_SOFTWARE;
+	}
 	info->phc_index = -1;
 
 out:
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index a2c66b3d7f0f..2adaa0008434 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -48,6 +48,9 @@ enum {
 					 SOF_TIMESTAMPING_TX_SCHED | \
 					 SOF_TIMESTAMPING_TX_ACK)
 
+#define SOF_TIMESTAMPING_SOFTRXTX (SOF_TIMESTAMPING_TX_SOFTWARE | \
+				   SOF_TIMESTAMPING_RX_SOFTWARE | \
+				   SOF_TIMESTAMPING_SOFTWARE)
 /**
  * struct so_timestamping - SO_TIMESTAMPING parameter
  *
-- 
2.38.1

