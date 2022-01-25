Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1394549AD88
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443912AbiAYHV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:21:29 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:35480 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443974AbiAYHSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 02:18:20 -0500
X-UUID: 2c51394019f045a588d334a83e04d3ba-20220125
X-CPASD-INFO: 289dcfeeade14cac8556269bc2fefc8c@e4hzhJCYk5WNhKd9g6asnVhmZWZiYlm
        xpWyGlZSTZIOVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3gXpzhJOUlQ==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: 289dcfeeade14cac8556269bc2fefc8c
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:185.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:127.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:4488.0,FROMTO:0,AD:0,FFOB:0.0,CF
        OB:0.0,SPC:0.0,SIG:-5,AUF:103,DUF:31675,ACD:174,DCD:276,SL:0,AG:0,CFC:0.714,C
        FSR:0.104,UAT:0,RAF:0,VERSION:2.3.4
X-CPASD-ID: 2c51394019f045a588d334a83e04d3ba-20220125
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: 2c51394019f045a588d334a83e04d3ba-20220125
X-User: yinxiujiang@kylinos.cn
Received: from localhost.localdomain [(118.26.139.139)] by nksmu.kylinos.cn
        (envelope-from <yinxiujiang@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1238024265; Tue, 25 Jan 2022 15:30:57 +0800
From:   Yin Xiujiang <yinxiujiang@kylinos.cn>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] batman-adv: Make use of the helper macro kthread_run()
Date:   Tue, 25 Jan 2022 15:18:08 +0800
Message-Id: <20220125071808.459017-1-yinxiujiang@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
---
 net/batman-adv/tp_meter.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 93730d30af54..a36e498c7c8f 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -905,7 +905,7 @@ static void batadv_tp_start_kthread(struct batadv_tp_vars *tp_vars)
 	u32 session_cookie;
 
 	kref_get(&tp_vars->refcount);
-	kthread = kthread_create(batadv_tp_send, tp_vars, "kbatadv_tp_meter");
+	kthread = kthread_run(batadv_tp_send, tp_vars, "kbatadv_tp_meter");
 	if (IS_ERR(kthread)) {
 		session_cookie = batadv_tp_session_cookie(tp_vars->session,
 							  tp_vars->icmp_uid);
@@ -921,8 +921,6 @@ static void batadv_tp_start_kthread(struct batadv_tp_vars *tp_vars)
 		batadv_tp_sender_cleanup(bat_priv, tp_vars);
 		return;
 	}
-
-	wake_up_process(kthread);
 }
 
 /**
-- 
2.30.0

