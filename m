Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378B04720B5
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 06:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhLMFrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 00:47:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhLMFro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 00:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639374463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jqZjVXuB02/na70pVy+Ypnpg6sqRgLlH0wP5jPX/dC4=;
        b=gM6E3TGVgKZN0HncIvW4vPkUe1LYQROYpO9+ATiplN8n7SlxdFnuWPQI6E2WBew3dkluEi
        wt5uqf9/ASTFsnaC2AfveMCbi/TELXRYfkYTdeLUELv+yM6HaNf2CMVozLSbJMRZVgJSs2
        6PnEsJ2J8y+3Z3Kla9wuGXTZlAMZk2I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-87-drwi0FTKOTCwk_VvwZUJzA-1; Mon, 13 Dec 2021 00:47:40 -0500
X-MC-Unique: drwi0FTKOTCwk_VvwZUJzA-1
Received: by mail-pj1-f71.google.com with SMTP id lj10-20020a17090b344a00b001a653d07ad8so12898921pjb.3
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 21:47:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jqZjVXuB02/na70pVy+Ypnpg6sqRgLlH0wP5jPX/dC4=;
        b=ltXRL99siuf2Oh+i49yamtcNfdiyqy6+3rYhdedep0lh42w5YY/1Du0Iaoae1CJZxO
         GufVooAmgYwcBk4VCLX281RNOwVfFvT/+D/TzpecPT29iTR1HkKgERx4MRzda5wYBYC/
         +f4nwapeeq+wonWVTZUs/0s/GLOAL86uu/xXbMkV2YQo3Sbh0NEvZu4wrVH5HlG7TfwJ
         DlRgqCWjOJhxHDligyQ/jAlRzk5NoUzYJnLC4K2Hn32sV5NyX1TE121VXyclwqvY0K7Q
         2dXxfv/7QAG+ewxoQF6922bURw8FyGBWGmaEy6R3h2Y4O7OlY7Fni+e2XYs0CGSTeFsS
         yaRA==
X-Gm-Message-State: AOAM530wpR8MVhsLhtJ9p/cQVpgmBx2+3Gu3VHekjOOONhnlRhmR42T5
        g3KoLc1t5LvFxo5BSlHFYqYQUa2XU0VjvMqBt6EzAPvSYzvSzDc2CMR2bo5fWJ8YjqYLR/EKx9s
        gSrRWanl8vkI+Gu3t
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr42812686pjb.201.1639374459078;
        Sun, 12 Dec 2021 21:47:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBg/xhnjq3sQ6/B8LuYiHaj91tFcJorpVXkfe/StyvJF3p6PRgEewvHIK4YYtjSSeoz8Es7A==
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr42812666pjb.201.1639374458729;
        Sun, 12 Dec 2021 21:47:38 -0800 (PST)
Received: from localhost.localdomain.com ([103.59.74.139])
        by smtp.gmail.com with ESMTPSA id fs21sm4621888pjb.1.2021.12.12.21.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 21:47:38 -0800 (PST)
From:   Suresh Kumar <surkumar@redhat.com>
X-Google-Original-From: Suresh Kumar <suresh2514@gmail.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Suresh Kumar <suresh2514@gmail.com>
Subject: [PATCH] net: bonding: debug: avoid printing debug logs when bond is not notifying peers
Date:   Mon, 13 Dec 2021 11:17:09 +0530
Message-Id: <20211213054709.158550-1-suresh2514@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently "bond_should_notify_peers: slave ..." messages are printed whenever
"bond_should_notify_peers" function is called.

+++
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Received LACPDU on port 1
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Rx Machine: Port=1, Last State=6, Curr State=6
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): partner sync=1
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
...
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Received LACPDU on port 2
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Rx Machine: Port=2, Last State=6, Curr State=6
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): partner sync=1
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
+++

This is confusing and can also clutter up debug logs.
Print logs only when the peer notification happens.

Signed-off-by: Suresh Kumar <suresh2514@gmail.com>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ff8da720a33a..0ac964359fbf 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1096,9 +1096,6 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	slave = rcu_dereference(bond->curr_active_slave);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
-
 	if (!slave || !bond->send_peer_notif ||
 	    bond->send_peer_notif %
 	    max(1, bond->params.peer_notif_delay) != 0 ||
@@ -1106,6 +1103,9 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
 
+	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
+		   slave ? slave->dev->name : "NULL");
+
 	return true;
 }
 
-- 
2.27.0

