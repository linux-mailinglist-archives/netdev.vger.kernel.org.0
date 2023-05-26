Return-Path: <netdev+bounces-5756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9402712A75
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 932072818FF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C806527727;
	Fri, 26 May 2023 16:17:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE42E742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:17:26 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA94BC;
	Fri, 26 May 2023 09:17:25 -0700 (PDT)
Received: from vefanov-Precision-3650-Tower.intra.ispras.ru (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id 878B644C100F;
	Fri, 26 May 2023 16:17:23 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 878B644C100F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685117843;
	bh=aqS+SmgTj1O1ACMyKobn1Ejjd1RSyeh/KMYxC+E+Wpw=;
	h=From:To:Cc:Subject:Date:From;
	b=WWuzkfeeBYGRMal7EvzSPJ1GwuO9j5aqUIvjRD/XGiesQHPXHBQL4RuXh1Ed4gZfg
	 deRtyLECp5+T7H6Wyse4v5qDYMKCBT0wkBc1y0dCyY6AvrK7HuR9daK5FjFGmpG8yR
	 T57ZgSiCU27zWgZp6IXoHAuFKLuNIOAzmzY/nT8k=
From: Vladislav Efanov <VEfanov@ispras.ru>
To: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Vladislav Efanov <VEfanov@ispras.ru>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Antonio Quartulli <a@unstable.cc>,
	Sven Eckelmann <sven@narfation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	b.a.t.m.a.n@lists.open-mesh.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] batman-adv: Broken sync while rescheduling delayed work
Date: Fri, 26 May 2023 19:16:32 +0300
Message-Id: <20230526161632.1460753-1-VEfanov@ispras.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Syzkaller got a lot of crashes like:
KASAN: use-after-free Write in *_timers*

All of these crashes point to the same memory area:

The buggy address belongs to the object at ffff88801f870000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 5320 bytes inside of
 8192-byte region [ffff88801f870000, ffff88801f872000)

This area belongs to :
        batadv_priv->batadv_priv_dat->delayed_work->timer_list

The reason for these issues is the lack of synchronization. Delayed
work (batadv_dat_purge) schedules new timer/work while the device
is being deleted. As the result new timer/delayed work is set after
cancel_delayed_work_sync() was called. So after the device is freed
the timer list contains pointer to already freed memory.

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

Fixes: 2f1dfbe18507 ("batman-adv: Distributed ARP Table - implement local storage")
Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
---
 net/batman-adv/distributed-arp-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 6968e55eb971..28a939d56090 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -101,7 +101,6 @@ static void batadv_dat_purge(struct work_struct *work);
  */
 static void batadv_dat_start_timer(struct batadv_priv *bat_priv)
 {
-	INIT_DELAYED_WORK(&bat_priv->dat.work, batadv_dat_purge);
 	queue_delayed_work(batadv_event_workqueue, &bat_priv->dat.work,
 			   msecs_to_jiffies(10000));
 }
@@ -819,6 +818,7 @@ int batadv_dat_init(struct batadv_priv *bat_priv)
 	if (!bat_priv->dat.hash)
 		return -ENOMEM;
 
+	INIT_DELAYED_WORK(&bat_priv->dat.work, batadv_dat_purge);
 	batadv_dat_start_timer(bat_priv);
 
 	batadv_tvlv_handler_register(bat_priv, batadv_dat_tvlv_ogm_handler_v1,
-- 
2.34.1


