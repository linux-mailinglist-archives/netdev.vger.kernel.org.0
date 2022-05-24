Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AFD5333B7
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 00:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242504AbiEXW4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbiEXW4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 18:56:36 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08652694B0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 15:56:34 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntdS3-000G5w-Gd; Wed, 25 May 2022 00:56:31 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     kuba@kernel.org
Cc:     wangyuweihx@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net] net, neigh: Set lower cap for neigh_managed_work rearming
Date:   Wed, 25 May 2022 00:56:18 +0200
Message-Id: <3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26551/Tue May 24 10:06:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuwei reported that plain reuse of DELAY_PROBE_TIME to rearm work queue
in neigh_managed_work is problematic if user explicitly configures the
DELAY_PROBE_TIME to 0 for a neighbor table. Such misconfig can then hog
CPU to 100% processing the system work queue. Instead, set lower interval
bound to HZ which is totally sufficient. Yuwei is additionally looking
into making the interval separately configurable from DELAY_PROBE_TIME.

Reported-by: Yuwei Wang <wangyuweihx@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/netdev/797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f64ebd050f6..fd69133dc7c 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
+			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
 	write_unlock_bh(&tbl->lock);
 }
 
-- 
2.21.0

