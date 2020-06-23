Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F672062D3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403800AbgFWUep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:45 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63429 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgFWUeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:44 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYeo2019528;
        Tue, 23 Jun 2020 13:34:40 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 03/12] cxgb4: use unaligned conversion for fetching timestamp
Date:   Wed, 24 Jun 2020 01:51:33 +0530
Message-Id: <6e14267d2fd8a4cbc8ef597995852b43938a29bb.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use get_unaligned_be64() to fetch the timestamp needed for ns_to_ktime()
conversion.

Fixes following sparse warning:
sge.c:3282:43: warning: cast to restricted __be64

Fixes: a456950445a0 ("cxgb4: time stamping interface for PTP")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index f7b5a2f11001..3c8b4b153ec4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3312,7 +3312,7 @@ static noinline int t4_systim_to_hwstamp(struct adapter *adapter,
 
 	hwtstamps = skb_hwtstamps(skb);
 	memset(hwtstamps, 0, sizeof(*hwtstamps));
-	hwtstamps->hwtstamp = ns_to_ktime(be64_to_cpu(*((u64 *)data)));
+	hwtstamps->hwtstamp = ns_to_ktime(get_unaligned_be64(data));
 
 	return RX_PTP_PKT_SUC;
 }
-- 
2.24.0

