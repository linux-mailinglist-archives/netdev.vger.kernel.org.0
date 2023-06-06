Return-Path: <netdev+bounces-8340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E5A723C4D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43F8328141C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA23125C5;
	Tue,  6 Jun 2023 08:56:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6565C3D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:56:07 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE2EF18E;
	Tue,  6 Jun 2023 01:56:04 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,219,1681138800"; 
   d="scan'208";a="162391984"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 06 Jun 2023 17:56:04 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir6.idc.renesas.com (Postfix) with ESMTP id 00CB441A061A;
	Tue,  6 Jun 2023 17:56:03 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v2 0/2] net: renesas: rswitch: Improve perfromance of TX/RX
Date: Tue,  6 Jun 2023 17:55:56 +0900
Message-Id: <20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com>
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
The commit ddb8701dcb67 ("Merge branch 'splice-net-handle-msg_splice_pages-in-af_kcm'")

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
 drivers/net/ethernet/renesas/rswitch.h |  6 ++++
 2 files changed, 21 insertions(+), 23 deletions(-)

-- 
2.25.1


