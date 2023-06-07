Return-Path: <netdev+bounces-8666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 521AB7251DC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2F142810F8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5DB65E;
	Wed,  7 Jun 2023 01:56:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7BE64E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:56:55 +0000 (UTC)
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6B8DE43;
	Tue,  6 Jun 2023 18:56:52 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,222,1681138800"; 
   d="scan'208";a="166015942"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 07 Jun 2023 10:56:51 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1C608411C514;
	Wed,  7 Jun 2023 10:56:51 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: maciej.fijalkowski@intel.com,
	netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v3 0/2] net: renesas: rswitch: Improve perfromance of TX/RX
Date: Wed,  7 Jun 2023 10:56:39 +0900
Message-Id: <20230607015641.1724057-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series is based on net-next.git / main branch [1]. This patch
series can improve perfromance of TX in a specific condition. The previous code
used "global rate limiter" feature so that this is possible to cause
performance down if we use multiple ports at the same time. To resolve this
issue, use "hardware pause" features of GWCA and COMA. Note that this is not
related to the ethernet PAUSE frames.

< UDP TX by iperf3 >
 before: about 450Mbps on both tsn0 and tsn1
 after:  about 950Mbps on both tsn0 and tsn1

Also, this patch series can improve performance of RX by using
napi_gro_receive().

< TCP RX by iperf >
 before: about 670Mbps on tsn0
 after:  about 840Mbps on tsn0

[1]
The commit 2dc476404efa ("Merge branch 'tools-ynl-user-space-c'")

Changes from v2:
https://lore.kernel.org/all/20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on the latest net-next.git / main branch.
 - Added Reviewed-by in the patch 1/2. (Maciej, thanks!)
 - Revise the commit description in the patch 2/2.
 - Add definition to remove magic hardcoded numbers in the patch 2/2.

Changes from v1:
https://lore.kernel.org/all/20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on the latest net-next.git / main branch.
 - Use "hardware pause" feature instead of "per-queue limiter" feature.
 - Drop refactaring for "per-queue limiter".
 - Drop dt-bindings update because "hardware pause" doesn't need additional
   clock information.
 - Use napi_gro_receive() to improve RX performance.

Yoshihiro Shimoda (2):
  net: renesas: rswitch: Use napi_gro_receive() in RX
  net: renesas: rswitch: Use hardware pause features

 drivers/net/ethernet/renesas/rswitch.c | 38 ++++++++++----------------
 drivers/net/ethernet/renesas/rswitch.h |  7 +++++
 2 files changed, 22 insertions(+), 23 deletions(-)

-- 
2.25.1


