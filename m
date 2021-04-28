Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F436D549
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbhD1KBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:01:38 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:49750 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238658AbhD1KBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 06:01:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UX3G0f2_1619604047;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UX3G0f2_1619604047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 18:00:48 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] llc2: Remove redundant assignment to rc
Date:   Wed, 28 Apr 2021 18:00:46 +0800
Message-Id: <1619604046-118132-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'rc' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

net/llc/llc_station.c:54:2: warning: Value stored to 'rc' is never read
[clang-analyzer-deadcode.DeadStores]
net/llc/llc_station.c:83:2: warning: Value stored to 'rc' is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/llc/llc_station.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/llc/llc_station.c b/net/llc/llc_station.c
index c29170e..05c6ae0 100644
--- a/net/llc/llc_station.c
+++ b/net/llc/llc_station.c
@@ -54,7 +54,6 @@ static int llc_station_ac_send_xid_r(struct sk_buff *skb)
 
 	if (!nskb)
 		goto out;
-	rc = 0;
 	llc_pdu_decode_sa(skb, mac_da);
 	llc_pdu_decode_ssap(skb, &dsap);
 	llc_pdu_header_init(nskb, LLC_PDU_TYPE_U, 0, dsap, LLC_PDU_RSP);
@@ -83,7 +82,6 @@ static int llc_station_ac_send_test_r(struct sk_buff *skb)
 
 	if (!nskb)
 		goto out;
-	rc = 0;
 	llc_pdu_decode_sa(skb, mac_da);
 	llc_pdu_decode_ssap(skb, &dsap);
 	llc_pdu_header_init(nskb, LLC_PDU_TYPE_U, 0, dsap, LLC_PDU_RSP);
-- 
1.8.3.1

