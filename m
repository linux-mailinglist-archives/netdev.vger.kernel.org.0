Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9899A62B079
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiKPBTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiKPBTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:19:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA19E29CAE
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:19:19 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f19-20020a63f113000000b0046fde69a09dso8471047pgi.10
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1IDj+JkYx2pD6pP5wIZwiyrRkDg/+o73QTbIwx2eTEQ=;
        b=FUNvyNtKynfcBj9WRoN8xQMaMahvECsa1QKf2KNHEasY5XwO9CIFUsej9xTg9zmk3x
         an6IH7u6lqERSwOjFZuxmD8KuiXuF2mkEPwD5eTRXg1FBsown3bx6aiKE1ucfexZ1UMw
         KhaHNkyVD04DRFlGy/k9GW+FWvpTAPJZL6EU0B6lpFHQfgc+zMM+WS78ZyV2VIWcWZuA
         /RKiSibzhGckFCX5smQWh0UfHT1/l11MTNRHetDRavB/A0asb5bWYMTNyM20FslkgPk3
         89NWWI/aKoERNOJycbI0n5snn+W3w/fq35CwRC/2E1U1x5zK9khqCQvTEF7wjQKGcvEp
         VcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1IDj+JkYx2pD6pP5wIZwiyrRkDg/+o73QTbIwx2eTEQ=;
        b=v669vihYTFcpRHqgXhaSk51Dx//NZTefCuOXhVh8MHU6rG+uMBolE2QStWuXZbKtLA
         PhXfKHQF0naBkMwKawf4lLJOFUusCnsh86WjX33Z641F/r2oqgQNB7dqRl/8/ruYHqBm
         NTk2htCuCAsMwtad9zGLwElEFIPadCvGT/e+ZMD1iElos0kYxZ37/OPPpRZnfL3gHXLK
         CM6Fw+MUf/yyhmHI6otg3oJi6LNa2hqyPrzgji6zmLFpPJRtC3IkBW/gZpSsq76X/obq
         WtJH7YOyFBfWG2VISl8ii7JuzfiEuO6jkEc6Nq6qii0HIBazI00lK6T2HbFKnyXGjmgW
         Wq8Q==
X-Gm-Message-State: ANoB5plmuseBaQ+JGn5bMhWRXCOon7HsKBzWCmomVDIqXkJbDULAxzMo
        CQ3mjSNcY3+So02NFtpaUjen38F8Ojya2oaRxC2x1FzZNK+Y+YSDS+uVOmmYr0DT1BWJR0htzj4
        e6Rl0+vlaSSSB8Z4JZg4mcEpZxHzuDR9IGWqqja5UGd+NYMwh+ltlHpJ6XM8531Lf
X-Google-Smtp-Source: AA0mqf7RYtyjwLxRaNXcGW2lbo+iaOJj3b9uUIaY0g5yFT3wVGubusQtF4+VURU4x4nLeGqgeOmW6b8NWSrN
X-Received: from coldfire.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b34])
 (user=maheshb job=sendgmr) by 2002:a17:90a:e686:b0:20d:bbe5:f35e with SMTP id
 s6-20020a17090ae68600b0020dbbe5f35emr1125927pjy.120.1668561559227; Tue, 15
 Nov 2022 17:19:19 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:19:14 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116011914.96240-1-maheshb@google.com>
Subject: [PATCH net] ipvlan: hold lower dev to avoid possible use-after-free
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently syzkaller discovered the issue of disappearing lower
device (NETDEV_UNREGISTER) while the virtual device (like
macvlan) is still having it as a lower device. So it's just
a matter of time similar discovery will be made for IPvlan
device setup. So fixing it preemptively. Also while at it,
add a refcount tracker.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/ipvlan/ipvlan.h      | 1 +
 drivers/net/ipvlan/ipvlan_main.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index de94921cbef9..025e0c19ec25 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -98,6 +98,7 @@ struct ipvl_port {
 	struct sk_buff_head	backlog;
 	int			count;
 	struct ida		ida;
+	netdevice_tracker	dev_tracker;
 };
 
 struct ipvl_skb_cb {
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index b6bfa9fdca62..b15dd9a3ad54 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -83,6 +83,7 @@ static int ipvlan_port_create(struct net_device *dev)
 	if (err)
 		goto err;
 
+	netdev_hold(dev, &port->dev_tracker, GFP_KERNEL);
 	return 0;
 
 err:
@@ -95,6 +96,7 @@ static void ipvlan_port_destroy(struct net_device *dev)
 	struct ipvl_port *port = ipvlan_port_get_rtnl(dev);
 	struct sk_buff *skb;
 
+	netdev_put(dev, &port->dev_tracker);
 	if (port->mode == IPVLAN_MODE_L3S)
 		ipvlan_l3s_unregister(port);
 	netdev_rx_handler_unregister(dev);
-- 
2.38.1.431.g37b22c650d-goog

