Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A283D599E07
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349688AbiHSPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349682AbiHSPPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:15:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318FE0971
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660922137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGWKh36yCcgT3zsD8zxI3eMgx3q0mMbgDZV6uayiHHw=;
        b=a0jb2tSASFhcLb/QhlhExNcHy4Kef31Ke9/jQjQI4DWrNFsiw7iPFY5zDtRcy7RuIedd+V
        9a9qRBt1o8IvGYCsvpXdRO/0o/rBsllCQKx0QFVcWUSd4fOzxXyv975fVSakSQTFlbCEP5
        rA7xB1dzYG3IUXuRgHAvEF823MyWJLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-kcn-rxo5N5WUQwVDRrF-NA-1; Fri, 19 Aug 2022 11:15:31 -0400
X-MC-Unique: kcn-rxo5N5WUQwVDRrF-NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 299FF811E75;
        Fri, 19 Aug 2022 15:15:31 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2E9F404C6E3;
        Fri, 19 Aug 2022 15:15:30 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Cc:     liuhangbin@gmail.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net v5 3/3] bonding: 3ad: make ad_ticks_per_sec a const
Date:   Fri, 19 Aug 2022 11:15:14 -0400
Message-Id: <396d7dd218ea8e95bd6f1f0e6fc44c696e8c7502.1660919940.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660919940.git.jtoppins@redhat.com>
References: <cover.1660919940.git.jtoppins@redhat.com>
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
    v5:
     * fixup kdoc for bond_3ad_initialize

 drivers/net/bonding/bond_3ad.c  | 11 +++--------
 drivers/net/bonding/bond_main.c |  2 +-
 include/net/bond_3ad.h          |  2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 1f0120cbe9e8..184608bd8999 100644
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
@@ -2001,11 +2002,10 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 /**
  * bond_3ad_initialize - initialize a bond's 802.3ad parameters and structures
  * @bond: bonding struct to work on
- * @tick_resolution: tick duration (millisecond resolution)
  *
  * Can be called only after the mac address of the bond is set.
  */
-void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
+void bond_3ad_initialize(struct bonding *bond)
 {
 	BOND_AD_INFO(bond).aggregator_identifier = 0;
 	BOND_AD_INFO(bond).system.sys_priority =
@@ -2017,11 +2017,6 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
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

