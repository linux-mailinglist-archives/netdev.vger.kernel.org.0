Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4EEFC69
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfKELbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:31:06 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730757AbfKELbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 06:31:05 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 08A5AD5513D0C2584768;
        Tue,  5 Nov 2019 19:31:00 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 5 Nov 2019
 19:30:52 +0800
To:     <dougmill@linux.ibm.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH] ehea: replace with page_shift() in ehea_is_hugepage()
Message-ID: <f581efc8-5d92-fed7-27b5-d5c5e9bce8ee@huawei.com>
Date:   Tue, 5 Nov 2019 19:30:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function page_shift() is supported after the commit 94ad9338109f
("mm: introduce page_shift()").

So replace with page_shift() in ehea_is_hugepage() for readability.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
index 6e70658d50c4..db45373ea31c 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
@@ -670,13 +670,10 @@ int ehea_rem_sect_bmap(unsigned long pfn, unsigned long nr_pages)

 static int ehea_is_hugepage(unsigned long pfn)
 {
-	int page_order;
-
 	if (pfn & EHEA_HUGEPAGE_PFN_MASK)
 		return 0;

-	page_order = compound_order(pfn_to_page(pfn));
-	if (page_order + PAGE_SHIFT != EHEA_HUGEPAGESHIFT)
+	if (page_shift(pfn_to_page(pfn)) != EHEA_HUGEPAGESHIFT)
 		return 0;

 	return 1;
-- 
2.7.4

