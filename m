Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706CF96235
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfHTOQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:16:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4737 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729762AbfHTOQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:16:54 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B7B5DFB8E5CA0C1399FE;
        Tue, 20 Aug 2019 22:16:51 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 20 Aug 2019
 22:16:41 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <idosch@mellanox.com>, <jiri@mellanox.com>,
        <mcroce@redhat.com>, <jakub.kicinski@netronome.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] netdevsim: Fix build error without CONFIG_INET
Date:   Tue, 20 Aug 2019 22:14:46 +0800
Message-ID: <20190820141446.71604-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190819120825.74460-1-yuehaibing@huawei.com>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_INET is not set, building fails:

drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
dev.c:(.text+0x67b): undefined reference to `ip_send_check'

Use ip_fast_csum instead of ip_send_check to avoid
dependencies on CONFIG_INET.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: use ip_fast_csum instead of ip_send_check
---
 drivers/net/netdevsim/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c5b0261..39cdb6c 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -389,7 +389,8 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	iph->ihl = 0x5;
 	iph->tot_len = htons(tot_len);
 	iph->ttl = 100;
-	ip_send_check(iph);
+	iph->check = 0;
+	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 
 	udph = skb_put_zero(skb, sizeof(struct udphdr) + data_len);
 	get_random_bytes(&udph->source, sizeof(u16));
-- 
2.7.4


