Return-Path: <netdev+bounces-11917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3AE7351A2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 395302810F4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69721C8C9;
	Mon, 19 Jun 2023 10:09:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4FE10799
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:09:25 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0AAE4F;
	Mon, 19 Jun 2023 03:09:18 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1687169348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ifTkOc+IePMxuKDemBz16w3UeJ8myDaZex1J+2pMJyw=;
	b=O1sb0RIn6Hy6jCcn3trgyXlbi2F7M/tZc1oHs55EChHsMkOVxTWEvpmuHRQD3/pEccJKOK
	ESPzMyNi+0R4oVNLy1dZE9I+YAf72swbc0Hr4tWQkM6h6t7IJHZXMCn8EyprCNmUavhT+9
	PyD1MF5FEOLJ42V9fgvPhdq67drLFP7CpJvi+QdHl8SMpz55xilEZDkY7ITwh3vIbGZflN
	etl7jQsCevFxi0nQItYAiuqUXVIKouU7RibrA4IZsWrJHu95WXIDVxnd/MR76PbP5246Yb
	qdIULppA+9QBImqLyo9oK96FGBjP9ZsO3fKw65pU1ATkxQbpFqSf0ozxpWH4MA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1687169348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ifTkOc+IePMxuKDemBz16w3UeJ8myDaZex1J+2pMJyw=;
	b=mvBdAF/iCI7Y3/a7COxWzds9FSCtuMIHxL8z2+O5kNMffu0l3Cxtn9idwFTvT90lVFr1L6
	TJHzDFGhJf1yPRBQ==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Malli C <mallikarjuna.chilakala@intel.com>
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kurt@linutronix.de,
	florian.kauer@linutronix.de
Subject: [PATCH net v2 5/6] igc: Fix launchtime before start of cycle
Date: Mon, 19 Jun 2023 12:08:57 +0200
Message-Id: <20230619100858.116286-6-florian.kauer@linutronix.de>
In-Reply-To: <20230619100858.116286-1-florian.kauer@linutronix.de>
References: <20230619100858.116286-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It is possible (verified on a running system) that frames are processed
by igc_tx_launchtime with a txtime before the start of the cycle
(baset_est).

However, the result of txtime - baset_est is written into a u32,
leading to a wrap around to a positive number. The following
launchtime > 0 check will only branch to executing launchtime = 0
if launchtime is already 0.

Fix it by using a s32 before checking launchtime > 0.

Fixes: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9c04df900b59..565c72bd737d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1017,7 +1017,7 @@ static __le32 igc_tx_launchtime(struct igc_ring *ring, ktime_t txtime,
 	ktime_t base_time = adapter->base_time;
 	ktime_t now = ktime_get_clocktai();
 	ktime_t baset_est, end_of_cycle;
-	u32 launchtime;
+	s32 launchtime;
 	s64 n;
 
 	n = div64_s64(ktime_sub_ns(now, base_time), cycle_time);
-- 
2.39.2


