Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35DA52A951
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351458AbiEQRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351442AbiEQRd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:33:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28FE839BB5
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652808805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LGLIFlTQ2OG0Nit+kOZYpbPmMvBDDMh/ziDLpygha+E=;
        b=KBbmCrv9WTPTOcjPakXpF6KSzgonfWP/F9PjRhEhHWjFCiq3q1wCfh+lqGFlM5L8ytqHdj
        qGKB30e2QIfH5naTWX+hWa8dUNLDTyF3HWY2vaBPaYQUgXvPays8jO6odgJzwvHvzdoSYg
        BHDmIOcp5nlHZ1IrpVhv/kCmDFk2Ubw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-IzFfBergOc-7ZtGOxWWsKg-1; Tue, 17 May 2022 13:33:22 -0400
X-MC-Unique: IzFfBergOc-7ZtGOxWWsKg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3462685A5BE;
        Tue, 17 May 2022 17:33:21 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F570492C14;
        Tue, 17 May 2022 17:33:19 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     liuhangbin@gmail.com
Cc:     andy@greyhouse.net, davem@davemloft.net, dsahern@gmail.com,
        eric.dumazet@gmail.com, j.vosburgh@gmail.com, jtoppins@redhat.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        vfalico@gmail.com, vladimir.oltean@nxp.com,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Date:   Tue, 17 May 2022 13:32:58 -0400
Message-Id: <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
In-Reply-To: <20220517082312.805824-1-liuhangbin@gmail.com>
References: <20220517082312.805824-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
RESEND, list still didn't receive my last version

The diffstat is slightly larger but IMO a slightly more readable version.
When I was reading v2 I found myself jumping around.
I only compile tested it, so YMMV.

If this amount of change is too much v2 from Hangbin looks correct to
me.

 drivers/net/bonding/bond_main.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..f9d27b63c454 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,23 +5591,32 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
-	if (real_dev) {
-		ops = real_dev->ethtool_ops;
-		phydev = real_dev->phydev;
-
-		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
-		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
-		}
-	}
+	if (real_dev)
+		dev_hold(real_dev);
+	rcu_read_unlock();
+
+	if (!real_dev)
+		goto software;
 
+	ops = real_dev->ethtool_ops;
+	phydev = real_dev->phydev;
+
+	if (phy_has_tsinfo(phydev))
+		ret = phy_ts_info(phydev, info);
+	else if (ops->get_ts_info)
+		ret = ops->get_ts_info(real_dev, info);
+
+	dev_put(real_dev);
+	return ret;
+
+software:
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
-
 	return 0;
 }
 
-- 
2.27.0

