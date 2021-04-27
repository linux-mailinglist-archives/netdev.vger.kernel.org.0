Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9464536C3EC
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhD0Kbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:31:40 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39223 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238125AbhD0Kaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:30:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWzqAQd_1619519389;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzqAQd_1619519389)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:29:54 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] llc2: Remove redundant assignment to rc
Date:   Tue, 27 Apr 2021 18:29:48 +0800
Message-Id: <1619519388-60321-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable rc is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

net/llc/llc_station.c:86:2: warning: Value stored to 'rc' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
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

