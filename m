Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F573598631
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343634AbiHROli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiHROld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:41:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8763DBA9EC
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660833691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0pjfkbUvBiJzKdQKwHEM6d08ZGwc4hgOmUXE/oC5QcU=;
        b=NQJMYVnw13aQ1xWFVOKpRJJkBjKKyveom1C6nGyQix/QF5iNmYsPzUPcBkkGupPNva/81a
        fIQIYFHIbaCDpkLIz1nVlyXxPJ/fTSozrPwQm2BuAHC+fAlwzrt5NNHSWOaet3ugT6WJd9
        CfMUaUSoLvwiyZGnhCt4UGmy7tx0gHs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-xdB4WKmLM-69nHyXEUe2rQ-1; Thu, 18 Aug 2022 10:41:28 -0400
X-MC-Unique: xdB4WKmLM-69nHyXEUe2rQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C6A1824602;
        Thu, 18 Aug 2022 14:41:28 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.33.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A655840CFD05;
        Thu, 18 Aug 2022 14:41:27 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Cc:     liuhangbin@gmail.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net v4 3/3] bonding: 3ad: make ad_ticks_per_sec a const
Date:   Thu, 18 Aug 2022 10:41:12 -0400
Message-Id: <2d2bdb267ac504b1e197fa7316470462a2e8b7a7.1660832962.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660832962.git.jtoppins@redhat.com>
References: <cover.1660832962.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value is only ever set once in bond_3ad_initialize and only ever
read otherwise. There seems to be no reason to set the variable via
bond_3ad_initialize when setting the global variable will do. Change
ad_ticks_per_sec to a const to enforce its read-only usage.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v4:
     * remove passing the value of ad_ticks_per_sec on the stack and
       set ad_ticks_per_sec and make as const

 drivers/net/bonding/bond_3ad.c  | 10 +++-------
 drivers/net/bonding/bond_main.c |  2 +-
 include/net/bond_3ad.h          |  2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 1f0120cbe9e8..2946290ca517 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -84,7 +84,8 @@ enum ad_link_speed_type {
 static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 	0, 0, 0, 0, 0, 0
 };
-static u16 ad_ticks_per_sec;
+
+static const u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
 static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
@@ -2005,7 +2006,7 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
  *
  * Can be called only after the mac address of the bond is set.
  */
-void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
+void bond_3ad_initialize(struct bonding *bond)
 {
 	BOND_AD_INFO(bond).aggregator_identifier = 0;
 	BOND_AD_INFO(bond).system.sys_priority =
@@ -2017,11 +2018,6 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 		BOND_AD_INFO(bond).system.sys_mac_addr =
 		    *((struct mac_addr *)bond->params.ad_actor_system);
 
-	/* initialize how many times this module is called in one
-	 * second (should be about every 100ms)
-	 */
-	ad_ticks_per_sec = tick_resolution;
-
 	bond_3ad_initiate_agg_selection(bond,
 					AD_AGGREGATOR_SELECTION_TIMER *
 					ad_ticks_per_sec);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 50e60843020c..2f4da2c13c0a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2081,7 +2081,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			/* Initialize AD with the number of times that the AD timer is called in 1 second
 			 * can be called only after the mac address of the bond is set
 			 */
-			bond_3ad_initialize(bond, 1000/AD_TIMER_INTERVAL);
+			bond_3ad_initialize(bond);
 		} else {
 			SLAVE_AD_INFO(new_slave)->id =
 				SLAVE_AD_INFO(prev_slave)->id + 1;
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 184105d68294..be2992e6de5d 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -290,7 +290,7 @@ static inline const char *bond_3ad_churn_desc(churn_state_t state)
 }
 
 /* ========== AD Exported functions to the main bonding code ========== */
-void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution);
+void bond_3ad_initialize(struct bonding *bond);
 void bond_3ad_bind_slave(struct slave *slave);
 void bond_3ad_unbind_slave(struct slave *slave);
 void bond_3ad_state_machine_handler(struct work_struct *);
-- 
2.31.1

