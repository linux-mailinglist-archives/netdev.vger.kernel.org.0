Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA2540A92
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 20:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350892AbiFGSXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 14:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352333AbiFGSRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 14:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE24187200;
        Tue,  7 Jun 2022 10:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 745D6B82354;
        Tue,  7 Jun 2022 17:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC92C36AFF;
        Tue,  7 Jun 2022 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624282;
        bh=r5614ar8AFRRifn5VCsO52srNzCnoert+XWIpkRypVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z48XsQBg8FkTUA/Ajg2CwX6i+bKFTx8EGdMDMm5wmZJKcpBGRit9ZN0KOMTdVC1Y5
         ZkQPkz3k/kBBv+JB/BqOcG2axiWEkiUg3SUVHqLOmV2v9Bmv0KdIKTkaSd/9QMyf+H
         kOlwbT31qqrTvacixz3DVJrSFxM7GFvxxl3X7LshRWOfQupkYPGz2LTo1gkacmaX4j
         LABeug1WliF/OSfDSxKzrbC1AUrVh3UaNi6KHkxhPU/Jem6NqMNMM8z5ruaYpgXf7Y
         vBYkOJJPehWTet8pMhj9m352MfBTMC5+lXhXWgVM7F8PvdmJbLA3uVlkHcmwh7AcQT
         OKzFZaLh5m6GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, dsahern@kernel.org,
        roopa@nvidia.com, yajun.deng@linux.dev, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 44/68] net, neigh: Set lower cap for neigh_managed_work rearming
Date:   Tue,  7 Jun 2022 13:48:10 -0400
Message-Id: <20220607174846.477972-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit ed6cd6a17896561b9f51ab4c0d9bbb29e762b597 ]

Yuwei reported that plain reuse of DELAY_PROBE_TIME to rearm work queue
in neigh_managed_work is problematic if user explicitly configures the
DELAY_PROBE_TIME to 0 for a neighbor table. Such misconfig can then hog
CPU to 100% processing the system work queue. Instead, set lower interval
bound to HZ which is totally sufficient. Yuwei is additionally looking
into making the interval separately configurable from DELAY_PROBE_TIME.

Reported-by: Yuwei Wang <wangyuweihx@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/netdev/797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f64ebd050f6c..fd69133dc7c5 100644
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
2.35.1

