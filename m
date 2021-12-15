Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2634475AC0
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243400AbhLOOiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:38:00 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:58104 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243396AbhLOOh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 09:37:57 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowABnSBWs_blh5tBEAw--.62553S2;
        Wed, 15 Dec 2021 22:37:32 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] sfc_ef100: potential dereference of null pointer
Date:   Wed, 15 Dec 2021 22:37:31 +0800
Message-Id: <20211215143731.188026-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowABnSBWs_blh5tBEAw--.62553S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xtry3CFyUJrWUWFW7Arb_yoWDCwb_Kr
        12qwn5CF43Ar4Sk3WUZr42g34jk34kXwn5XryvgrZ5ZryDGry7Jw1q9rn8Cr15WryDCF9r
        tFy7Ga4a9347tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Xryl
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUmzuXUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kmalloc() needs to be checked.
To avoid use in efx_nic_update_stats() in case of the failure of alloc.

Fixes: b593b6f1b492 ("sfc_ef100: statistics gathering")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reported-by: kernel test robot <lkp@intel.com>
---
Changelog:

v1 -> v2

*Change 1. Change the place to check, avoiding the warning.
---
 drivers/net/ethernet/sfc/ef100_nic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 518268ce2064..d35cafd422b1 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -609,6 +609,9 @@ static size_t ef100_update_stats(struct efx_nic *efx,
 	ef100_common_stat_mask(mask);
 	ef100_ethtool_stat_mask(mask);
 
+	if (!mc_stats)
+		return 0;
+
 	efx_nic_copy_stats(efx, mc_stats);
 	efx_nic_update_stats(ef100_stat_desc, EF100_STAT_COUNT, mask,
 			     stats, mc_stats, false);
-- 
2.25.1

