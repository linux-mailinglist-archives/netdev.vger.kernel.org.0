Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4F3A92DF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhFPGm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:42:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4799 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhFPGli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4b520QT8zWt04;
        Wed, 16 Jun 2021 14:34:30 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:23 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 14:39:23 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <rajur@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: chelsio: cxgb4: use eth_zero_addr() to assign zero address
Date:   Wed, 16 Jun 2021 14:43:18 +0800
Message-ID: <20210616064318.2236712-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using eth_zero_addr() to assign zero address insetad of
inefficient copy from an array.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index ae3ad99fbd06..9e3ea5f7be2e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -7782,7 +7782,6 @@ int t4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
 			   int idx, bool sleep_ok)
 {
 	struct fw_vi_mac_exact *p;
-	u8 addr[] = {0, 0, 0, 0, 0, 0};
 	struct fw_vi_mac_cmd c;
 	int ret = 0;
 	u32 exact;
@@ -7799,7 +7798,7 @@ int t4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
 	p = c.u.exact;
 	p->valid_to_idx = cpu_to_be16(FW_VI_MAC_CMD_VALID_F |
 				      FW_VI_MAC_CMD_IDX_V(idx));
-	memcpy(p->macaddr, addr, sizeof(p->macaddr));
+	eth_zero_addr(p->macaddr);
 	ret = t4_wr_mbox_meat(adap, adap->mbox, &c, sizeof(c), &c, sleep_ok);
 	return ret;
 }
-- 
2.25.1

