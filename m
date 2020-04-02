Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F319BA18
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 04:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733270AbgDBCCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 22:02:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbgDBCCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 22:02:21 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3FD3FC06D72E6BC5008D;
        Thu,  2 Apr 2020 10:02:18 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 10:02:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <vinay.yadav@chelsio.com>,
        <rohitm@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] crypto: chtls - Fix build error without IPV6
Date:   Thu, 2 Apr 2020 09:43:23 +0800
Message-ID: <20200402014323.36492-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPV6 is not set, build fails:

drivers/crypto/chelsio/chcr_ktls.c: In function ‘chcr_ktls_act_open_req6’:
./include/net/sock.h:380:37: error: ‘struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
 #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                     ^
drivers/crypto/chelsio/chcr_ktls.c:258:37: note: in expansion of macro ‘sk_v6_rcv_saddr’
  cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
                                     ^~~~~~~~~~~~~~~

Add IPV6 dependency to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 62370a4f346d ("cxgb4/chcr: Add ipv6 support and statistics")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index f2756836093f..7bf1d8152a5d 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -47,6 +47,7 @@ config CHELSIO_TLS_DEVICE
 	bool "Chelsio Inline KTLS Offload"
 	depends on CHELSIO_T4
 	depends on TLS_DEVICE
+	depends on IPV6
 	select CRYPTO_DEV_CHELSIO
 	default y
 	help
-- 
2.17.1


