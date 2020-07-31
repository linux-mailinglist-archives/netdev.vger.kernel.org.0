Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA42343ED
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgGaKHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:07:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731998AbgGaKHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:07:44 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5E835F3008764DD2A782;
        Fri, 31 Jul 2020 18:07:42 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.238) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 18:07:38 +0800
Subject: [PATCH -next v2] net: ice: Fix pointer cast warnings
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-next@vger.kernel.org>
References: <20200731105721.18511-1-cuibixuan@huawei.com>
Message-ID: <5af7c5af-c45d-2174-de89-8b89eddb4f4d@huawei.com>
Date:   Fri, 31 Jul 2020 18:07:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200731105721.18511-1-cuibixuan@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pointers should be casted to unsigned long to avoid
-Wpointer-to-int-cast warnings:

drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning:
    cast from pointer to integer of different size
drivers/net/ethernet/intel/ice/ice_flow.h:198:32: warning:
    cast to pointer from integer of different size

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
v2->v1: add fix:
 ice_flow.h:198:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define ICE_FLOW_ENTRY_PTR(h) ((struct ice_flow_entry *)(h))

 drivers/net/ethernet/intel/ice/ice_flow.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 3913da2116d2..829f90b1e998 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -194,8 +194,8 @@ struct ice_flow_entry {
 	u16 entry_sz;
 };

-#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
-#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))
+#define ICE_FLOW_ENTRY_HNDL(e)	((u64)(uintptr_t)e)
+#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(uintptr_t)(h))

 struct ice_flow_prof {
 	struct list_head l_entry;
--
2.17.1


.


