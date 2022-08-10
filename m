Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1AC58E602
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 06:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiHJEHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 00:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiHJEHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 00:07:14 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10E4C74DF5;
        Tue,  9 Aug 2022 21:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=oPlghozXfHqS+pVztD
        9oUcgPWH9ApTg6zFBiMO/W9Ug=; b=Le20Q/qfcmT6qEKRlxq/vgt14WFpX2DSjV
        fWhh4+NUoKDtMa8y3UuC0xEpENjiZTJOWeqQsYBPql8EPx5cBBbCc3ddMSE16Skg
        feJs7sYBXbbJa8i6YKqF61SWXWS76ebGYcH+ObVs7WZHlfNY6uBiz+mmlbxO7kRX
        bFdw81QVU=
Received: from user-virtual-machine.localdomain (unknown [39.79.223.215])
        by smtp3 (Coremail) with SMTP id G9xpCgCXsoxeLvNipShNUw--.49160S4;
        Wed, 10 Aug 2022 12:06:10 +0800 (CST)
From:   Jialiang Wang <wangjialiang0806@163.com>
To:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, wangjialiang0806@163.com,
        niejianglei2021@163.com
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] nfp: fix use-after-free in area_cache_get()
Date:   Wed, 10 Aug 2022 12:04:45 +0800
Message-Id: <20220810040445.46015-1-wangjialiang0806@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: G9xpCgCXsoxeLvNipShNUw--.49160S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF43JFW3tF17WrWrCryfJFb_yoWrJw1kpF
        yUJ3yrCrW8WrsrWw4DJFW8Z3sY939xta43u3WrAw4F9a4a9r47JF1xKr45Xr1UKFW8tFyf
        uryYvr9xJFs8Zw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG1v-UUUUU=
X-Originating-IP: [39.79.223.215]
X-CM-SenderInfo: pzdqwy5ldoxtdqjqmiqw6rljoofrz/1tbivxNZzlWB00EtvAAAss
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

area_cache_get() is used to distribute cache->area and set cache->id,
 and if cache->id is not 0 and cache->area->kref refcount is 0, it will
 release the cache->area by nfp_cpp_area_release(). area_cache_get()
 set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().

But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
 is already set but the refcount is not increased as expected. At this
 time, calling the nfp_cpp_area_release() will cause use-after-free.

To avoid the use-after-free, set cache->id after area_init() and
 nfp_cpp_area_acquire() complete successfully.

Note: This vulnerability is triggerable by providing emulated device
 equipped with specified configuration.

 BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
/x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
  Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1

 Call Trace:
  <TASK>
 nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
 area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)

 Allocated by task 1:
 nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
 nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
 nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
/netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
 nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
 nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
/netronome/nfp/nfp_main.c:744)

 Freed by task 1:
 kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
 area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
 nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
/netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
 nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
/netronome/nfp/nfpcore/nfp_cpplib.c:48)

Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 34c0d2ddf9ef..a83b8ee49062 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -873,10 +873,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		cache->addr = 0;
 	}
 
-	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
-	cache->addr = addr & ~(u64)(cache->size - 1);
-
 	/* Re-init to the new ID and address */
 	if (cpp->op->area_init) {
 		err = cpp->op->area_init(cache->area,
@@ -894,6 +890,10 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		return NULL;
 	}
 
+	/* Adjust the start address to be cache size aligned */
+	cache->id = id;
+	cache->addr = addr & ~(u64)(cache->size - 1);
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;
-- 
2.17.1

