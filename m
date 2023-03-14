Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015706B9159
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjCNLQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjCNLQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:16:14 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48492521DC
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:41 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so4175760wmi.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678792536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oK+lUDteLqxlsVeIep3uV/LoNK3+4iVj8+DSNqnpdk=;
        b=euxqzPHmqxzv4NnOpUBbKuAHu4ejXrP9hj+fll3Tbc1oXpwlSw1zxL5S70Mlyi0HjN
         cr53RVoU/ng1d3Or5bnp0GgAfjeyrQmjBwbDMAGuAP3SdyyUf8ZSl2RcW5aZougTwiUX
         2EPq5pFP9fdH+HSKqDXIohAc1rcSXJ1EoB6qtA4h7na85zH1+5l5N9WCRTJdQkIPplco
         2BtK79b/t6Hmc3Bc6yIgF7N3/03cRWzTIk/lO5jE+TjGVY/+4XEZEi3bnEzmnRTeu6WD
         dz4fCDBqM/Q4SO1tBi6YtOFJa2y9QXY23CWGY70V/URWSRQ+6PNSjf4gQ6j9RQx77czM
         mHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3oK+lUDteLqxlsVeIep3uV/LoNK3+4iVj8+DSNqnpdk=;
        b=hWhkS0WyrNlzebyKHuM/2ss3R4JRzNb9VGnDj29rJyso2NTtfS19OayEqTPvFnDfBE
         SR0UQZE9fKSv50Odw+fpHMRb0ha9nOW+oknRl8/QTDdc/qAccjoOe+FrJoMJK2oSwhUp
         tV2Yi1XsCq764geSQKYD9T/YOWgU5AoAOtZJm5yOCNTrbWpMxZMSXt/ZVrniav1e7oXW
         BV2R8SDcN5UuxjawliZ5RS94VWsc6AHnJ/yaVAkMf+x1O/pvLkghxmqwEXSNEQwi2XGW
         SJ9WtqNidJanencpH4vERME5/PSazRlICFOssKHsX/tIOF23czUUz2FlbPVUwwsjTKxN
         vWFg==
X-Gm-Message-State: AO0yUKWNekUc7UMWikPuRyNOObCBVgzTRXXtkQdYPfD9wLaUzxLqAx4D
        0MjM75f7cWbUtp0wvKutagcl1+SOUc4kLmooe0Q=
X-Google-Smtp-Source: AK7set8qECUxIPERL3rPSm+H7Hd0ZLce7BoWWGDYrBx1TwxMvj9AlA2DP32WZN6xOQI2iSQC4Hb2dA==
X-Received: by 2002:a05:600c:4f08:b0:3e2:20c7:6544 with SMTP id l8-20020a05600c4f0800b003e220c76544mr13764507wmq.19.1678792535914;
        Tue, 14 Mar 2023 04:15:35 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c2f8f00b003e1fee8baacsm2442323wmn.25.2023.03.14.04.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:15:35 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 2/4] bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
Date:   Tue, 14 Mar 2023 13:14:24 +0200
Message-Id: <20230314111426.1254998-3-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314111426.1254998-1-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the bond enslaves non-ARPHRD_ETHER device (changes its type), then
releases it and enslaves ARPHRD_ETHER device (changes back) then we
use ether_setup() to restore the bond device type but it also resets its
flags and removes IFF_MASTER and IFF_SLAVE[1]. Use the bond_ether_setup
helper to restore both after such transition.

[1] reproduce (nlmon is non-ARPHRD_ETHER):
 $ ip l add nlmon0 type nlmon
 $ ip l add bond2 type bond mode active-backup
 $ ip l set nlmon0 master bond2
 $ ip l set nlmon0 nomaster
 $ ip l add bond1 type bond
 (we use bond1 as ARPHRD_ETHER device to restore bond2's mode)
 $ ip l set bond1 master bond2
 $ ip l sh dev bond2
 37: bond2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether be:d7:c5:40:5b:cc brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
 (notice bond2's IFF_MASTER is missing)

Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/net/bonding/bond_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d41024ad2c18..cd94baccdac5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1878,10 +1878,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 			if (slave_dev->type != ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else {
-				ether_setup(bond_dev);
-				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-			}
+			else
+				bond_ether_setup(bond_dev);
 
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
-- 
2.39.2

