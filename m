Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF906B696
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 08:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfGQGYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 02:24:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfGQGYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 02:24:22 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 62086F44A6FACF7280D7;
        Wed, 17 Jul 2019 14:24:20 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 17 Jul 2019 14:24:11 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] net: dsa: sja1105: Fix missing unlock on error in sk_buff()
Date:   Wed, 17 Jul 2019 06:29:56 +0000
Message-ID: <20190717062956.127446-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return from function sk_buff()
in the error handling case.

Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/dsa/tag_sja1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1d96c9d4a8e9..26363d72d25b 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -216,6 +216,7 @@ static struct sk_buff
 		if (!skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Failed to copy stampable skb\n");
+			spin_unlock(&sp->data->meta_lock);
 			return NULL;
 		}
 		sja1105_transfer_meta(skb, meta);



