Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED97C599E08
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349699AbiHSPQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiHSPPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EB8E0971
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660922147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhaID+X1Mqgrgk1tAzS4wrDrYfG7IsiSyF0efNhSA9o=;
        b=IjJW4UDFmFhxeaxmBQiuAbOCSEf9IUTTyndcT+rKnWkuZuNFyJAC9pl49eC4LUe/DlQbpW
        l8MSHVDrGgYOlLkHBmr2Q95F6Iu51viFRy6G3e5L6HFF4bfB9lCQri+Jfa6KJMwU5Fmn7K
        uDFcKhDSnXH8lgmVDJvJ/Bk2KPFvjRU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-ZwCElc1OPm-XVkkuDNlEWQ-1; Fri, 19 Aug 2022 11:15:31 -0400
X-MC-Unique: ZwCElc1OPm-XVkkuDNlEWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5819A101AA4E;
        Fri, 19 Aug 2022 15:15:30 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4A62404C6E3;
        Fri, 19 Aug 2022 15:15:29 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Cc:     liuhangbin@gmail.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v5 2/3] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Fri, 19 Aug 2022 11:15:13 -0400
Message-Id: <5fe2a41fa0c2d726a9ba92244b272b21d4bae3a4.1660919940.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660919940.git.jtoppins@redhat.com>
References: <cover.1660919940.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is caused by the global variable ad_ticks_per_sec being zero as
demonstrated by the reproducer script discussed below. This causes
all timer values in __ad_timer_to_ticks to be zero, resulting
in the periodic timer to never fire.

To reproduce:
Run the script in
`tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh` which
puts bonding into a state where it never transmits LACPDUs.

line 44: ip link add fbond type bond mode 4 miimon 200 \
            xmit_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 48: ip link set fbond address 52:54:00:3B:7C:A6
setting bond MAC addr
call stack:
    bond->dev->dev_addr = new_mac

line 52: ip link set fbond type bond ad_actor_sys_prio 65535
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 60: ip link set veth1-bond down master fbond
given:
    params.ad_actor_system = 0
    params.mode = BOND_MODE_8023AD
    ad.system.sys_mac_addr == bond->dev->dev_addr
call stack:
    bond_enslave
    -> bond_3ad_initialize(); because first slave
       -> if ad.system.sys_mac_addr != bond->dev->dev_addr
          return
results:
     Nothing is run in bond_3ad_initialize() because dev_addr equals
     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
     never initialized anywhere else.

The if check around the contents of bond_3ad_initialize() is no longer
needed due to commit 5ee14e6d336f ("bonding: 3ad: apply ad_actor settings
changes immediately") which sets ad.system.sys_mac_addr if any one of
the bonding parameters whos set function calls
bond_3ad_update_ad_actor_settings(). This is because if
ad.system.sys_mac_addr is zero it will be set to the current bond mac
address, this causes the if check to never be true.

Fixes: 5ee14e6d336f ("bonding: 3ad: apply ad_actor settings changes immediately")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     * split this fix from the reproducer
    v3:
     * rebased to latest net/master
    v4:
     * instead of setting ad_ticks_per_sec remove the if statement around the
       body of the function of bond_3ad_initialize().
    v5:
     * no changes

 drivers/net/bonding/bond_3ad.c | 38 ++++++++++++++--------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index d7fb33c078e8..1f0120cbe9e8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2007,30 +2007,24 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
  */
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 {
-	/* check that the bond is not initialized yet */
-	if (!MAC_ADDRESS_EQUAL(&(BOND_AD_INFO(bond).system.sys_mac_addr),
-				bond->dev->dev_addr)) {
-
-		BOND_AD_INFO(bond).aggregator_identifier = 0;
-
-		BOND_AD_INFO(bond).system.sys_priority =
-			bond->params.ad_actor_sys_prio;
-		if (is_zero_ether_addr(bond->params.ad_actor_system))
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->dev->dev_addr);
-		else
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->params.ad_actor_system);
+	BOND_AD_INFO(bond).aggregator_identifier = 0;
+	BOND_AD_INFO(bond).system.sys_priority =
+		bond->params.ad_actor_sys_prio;
+	if (is_zero_ether_addr(bond->params.ad_actor_system))
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->dev->dev_addr);
+	else
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->params.ad_actor_system);
 
-		/* initialize how many times this module is called in one
-		 * second (should be about every 100ms)
-		 */
-		ad_ticks_per_sec = tick_resolution;
+	/* initialize how many times this module is called in one
+	 * second (should be about every 100ms)
+	 */
+	ad_ticks_per_sec = tick_resolution;
 
-		bond_3ad_initiate_agg_selection(bond,
-						AD_AGGREGATOR_SELECTION_TIMER *
-						ad_ticks_per_sec);
-	}
+	bond_3ad_initiate_agg_selection(bond,
+					AD_AGGREGATOR_SELECTION_TIMER *
+					ad_ticks_per_sec);
 }
 
 /**
-- 
2.31.1

