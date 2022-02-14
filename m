Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C714B3F36
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 03:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbiBNCLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 21:11:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiBNCLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 21:11:07 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469F354BF1
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:11:01 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id om7so13124155pjb.5
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rheNOBz9Jn84jNDWwxerVciRKNAi9ptp/E9hKVwOCeQ=;
        b=mJYzAUdOxedidyEkzZlcIK+FNkalgCSwIWAnaBeYjNxujugNpRQ/oUZf5noRoc9Duu
         SL0HgJFj5GjZnYKoIMPKqO94IhDNa0Yvhk58gAJx5ldHqTIKqMT50fJ+dnEAA8Z6PG8B
         SZnVxAwzWWk5vSQpYAgPmzcSp0KiCvqWzIskvYLGz3vW/RcFQTCqAvHg9IKq9ogZFfVk
         NuwB8PiB0Ji2CMfeREjrOf+MpGJ7FDtO+TT1ZzGt2bjCsI3y2A5bPOo7n0NG7ZCaDwRR
         CPw5+DS7ormvPyCZq59mOfgqMfy0z/Tkxf5C/pQK8Nm8gBvdsSgSTVN6DXYvAWwX4iuM
         Mokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rheNOBz9Jn84jNDWwxerVciRKNAi9ptp/E9hKVwOCeQ=;
        b=Gsu/SUA+31y9qx+vMf7kAh4Js1Vm5S/knWbjK/fieDIUBxyr2HoK8cxBgN70lkvJVp
         O58J6GEbHLe1wse/nhk/qEUeR+spLo4FcsEumCA+jGhaaFsec05hTrtnJpi/7chjX0aD
         EPf6QbLMIxa6sSp3sQM4EI/E6+DoVJSvOhci9QJx66fZQZrVCYrGUESV5Z4vJKsvphWH
         XIYlPx13Pm+sbkDMMkBXyVFeIzrCSTNJkKtC97/AQTDmd7pFKexh0Oge3yn42AWCxZ7l
         VckPonbqNfNrcoLhPzRtIJVaYcjFPUFOpAuJCHb3IlDCBj6qvjx0Du+Bqazu4PdJ7tpi
         sizg==
X-Gm-Message-State: AOAM5333ATiIDQBPj/EXhnXrJ2Tmp1C0rPoBtnibP/hK5g5i+rLSbrRX
        rRIajmcIh9C3yxBiT7SaJKc=
X-Google-Smtp-Source: ABdhPJwnJ9kjX4+TDqVuc5U3lcEfuCFvbWInEkxf5bZlvfejjKGCMpxvLEg74M4On7wpuxUVX1aUVA==
X-Received: by 2002:a17:902:8e8a:: with SMTP id bg10mr4512451plb.44.1644804660715;
        Sun, 13 Feb 2022 18:11:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7e68:a272:168b:5cac])
        by smtp.gmail.com with ESMTPSA id s6sm2135208pfk.86.2022.02.13.18.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 18:11:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ipv6: blackhole_netdev needs snmp6 counters
Date:   Sun, 13 Feb 2022 18:10:56 -0800
Message-Id: <20220214021056.389298-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Whenever rt6_uncached_list_flush_dev() swaps rt->rt6_idev
to the blackhole device, parts of IPv6 stack might still need
to increment one SNMP counter.

Root cause, patch from Ido, changelog from Eric :)

This bug suggests that we need to audit rt->rt6_idev usages
and make sure they are properly using RCU protection.

Fixes: e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/addrconf.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 02d31d4fcab3b3d529c4fe3260216ecee1108e82..57fbd6f03ff8d118e50d8aa6ea0ab938a1bb3cbc 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -400,16 +400,16 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	/* We refer to the device */
 	dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
 
-	if (dev != blackhole_netdev) {
-		if (snmp6_alloc_dev(ndev) < 0) {
-			netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
-				   __func__);
-			neigh_parms_release(&nd_tbl, ndev->nd_parms);
-			dev_put_track(dev, &ndev->dev_tracker);
-			kfree(ndev);
-			return ERR_PTR(err);
-		}
+	if (snmp6_alloc_dev(ndev) < 0) {
+		netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
+			   __func__);
+		neigh_parms_release(&nd_tbl, ndev->nd_parms);
+		dev_put_track(dev, &ndev->dev_tracker);
+		kfree(ndev);
+		return ERR_PTR(err);
+	}
 
+	if (dev != blackhole_netdev) {
 		if (snmp6_register_dev(ndev) < 0) {
 			netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
 				   __func__, dev->name);
-- 
2.35.1.265.g69c8d7142f-goog

