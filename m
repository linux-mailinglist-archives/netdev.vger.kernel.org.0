Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD9D1C355
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 08:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfENGjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 02:39:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfENGjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 02:39:52 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 425E271A0A9898DCDD33;
        Tue, 14 May 2019 14:39:49 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 May 2019
 14:39:39 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <ubraun@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hwippel@linux.ibm.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net/smc: Fix error path in smc_init
Date:   Tue, 14 May 2019 14:39:21 +0800
Message-ID: <20190514063921.41088-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_pernet_subsys success in smc_init,
we should cleanup it in case any other error.

Fixes: 64e28b52c7a6 (net/smc: add pnet table namespace support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/smc/af_smc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6f869ef..7d3207f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2019,7 +2019,7 @@ static int __init smc_init(void)
 
 	rc = smc_pnet_init();
 	if (rc)
-		return rc;
+		goto out_pernet_subsys;
 
 	rc = smc_llc_init();
 	if (rc) {
@@ -2070,6 +2070,9 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto);
 out_pnet:
 	smc_pnet_exit();
+out_pernet_subsys:
+	unregister_pernet_subsys(&smc_net_ops);
+
 	return rc;
 }
 
-- 
1.8.3.1


