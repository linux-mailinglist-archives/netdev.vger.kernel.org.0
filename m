Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A653EC10
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbiFFP1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240798AbiFFP1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:27:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7922964E6
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654529242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hANCxUkjtJekam2HLSgzp8bKfmmuJSpp+YeIM4LYb4=;
        b=MbXDHFpto27ELnbYKA4OsBb9/cpXJ3r6VDtD7AoPgtpqbBbQVPdwgX7W5fLYmK+xMFQ21P
        XGJx063GJ2oYrcGmVaMNUNsusaQW1AHuhIm9WVoLDo77PUnPQqL9IThIWe81T55z18ulaR
        Ka3oKIDiMm02/zOxeTmZ237jzSViN+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-dqgEHCpIPrSZASKGAJipqA-1; Mon, 06 Jun 2022 11:27:18 -0400
X-MC-Unique: dqgEHCpIPrSZASKGAJipqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19FE329ABA31;
        Mon,  6 Jun 2022 15:27:18 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA66F82882;
        Mon,  6 Jun 2022 15:27:17 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [net-next 2/2] bonding: cleanup bond_create
Date:   Mon,  6 Jun 2022 11:26:53 -0400
Message-Id: <3f69118ff14ac0608810dac8dc1493559cf81640.1654528729.git.jtoppins@redhat.com>
In-Reply-To: <cover.1654528729.git.jtoppins@redhat.com>
References: <cover.1654528729.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting RLB_NULL_INDEX is not needed as this is done in bond_alb_initialize
which is called by bond_open.

Also reduce the number of rtnl_unlock calls by just using the standard
goto cleanup path.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 drivers/net/bonding/bond_main.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f85372adf042..3d427183ec8e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6218,45 +6218,33 @@ int bond_create(struct net *net, const char *name)
 {
 	struct net_device *bond_dev;
 	struct bonding *bond;
-	struct alb_bond_info *bond_info;
-	int res;
+	int res = -ENOMEM;
 
 	rtnl_lock();
 
 	bond_dev = alloc_netdev_mq(sizeof(struct bonding),
 				   name ? name : "bond%d", NET_NAME_UNKNOWN,
 				   bond_setup, tx_queues);
-	if (!bond_dev) {
-		pr_err("%s: eek! can't alloc netdev!\n", name);
-		rtnl_unlock();
-		return -ENOMEM;
-	}
+	if (!bond_dev)
+		goto out;
 
-	/*
-	 * Initialize rx_hashtbl_used_head to RLB_NULL_INDEX.
-	 * It is set to 0 by default which is wrong.
-	 */
 	bond = netdev_priv(bond_dev);
-	bond_info = &(BOND_ALB_INFO(bond));
-	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
-
 	dev_net_set(bond_dev, net);
 	bond_dev->rtnl_link_ops = &bond_link_ops;
 
 	res = register_netdevice(bond_dev);
 	if (res < 0) {
 		free_netdev(bond_dev);
-		rtnl_unlock();
-
-		return res;
+		goto out;
 	}
 
 	netif_carrier_off(bond_dev);
 
 	bond_work_init_all(bond);
 
+out:
 	rtnl_unlock();
-	return 0;
+	return res;
 }
 
 static int __net_init bond_net_init(struct net *net)
-- 
2.27.0

