Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C40593150
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiHOPJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiHOPI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:08:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3587D1CFF4
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660576134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7YHlPDxvn6aKCUYE+2wTzM3aDuBX7cJJssz0Clp2o8=;
        b=J/oFi12Fa/rMMF3ZVHALuy3VjXC1USW4sZc5X+BOYpxoirpBnWQmbfrovv2FDLH0To6pP5
        UxIPCotmWtgt7BlNxQprbe+Xks6BnbMNwBDmoKlg/+jjxquCXGDenfKjyl32reLhQPnUi/
        KdBRFkp4B6olMwvCmQ+O80HmSb00Crg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-N9tP-R2GO2u-RLkm0HYh5g-1; Mon, 15 Aug 2022 11:08:50 -0400
X-MC-Unique: N9tP-R2GO2u-RLkm0HYh5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A8903C02B72;
        Mon, 15 Aug 2022 15:08:50 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D41EB492C3B;
        Mon, 15 Aug 2022 15:08:49 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 2/2] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Mon, 15 Aug 2022 11:08:35 -0400
Message-Id: <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660572700.git.jtoppins@redhat.com>
References: <cover.1660572700.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
     Nothing is run in bond_3ad_initialize() because dev_add equals
     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
     never initialized anywhere else.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     * split this fix from the reproducer
    v3:
     * rebased to latest net/master

 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index d7fb33c078e8..957d30db6f95 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -84,7 +84,8 @@ enum ad_link_speed_type {
 static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 	0, 0, 0, 0, 0, 0
 };
-static u16 ad_ticks_per_sec;
+
+static u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
 static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
-- 
2.31.1

