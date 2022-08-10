Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C017B58E7DD
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiHJHd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiHJHd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:33:29 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F89ABC96;
        Wed, 10 Aug 2022 00:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=qsZhGhdT3szRsO2o56
        6UgdEf7Sy1RjMSfP+2fWpjBWw=; b=oPAt8EjXtTCQPYZYEqB/Jb2Kz2VD330Hku
        iPUWvWwDJu6KWB63F6OD/l/vcvI0PtkNXZYKqFgnm1qwJPuuuNlBD3WBpcRzJj5E
        qXom89mEmGGRjGR5CeEtu+vIWK+R6HWNXDp9dOALkjRMxbd+qv8eGmawx4v1ggNE
        myKUksZRU=
Received: from user-virtual-machine.localdomain (unknown [39.79.223.215])
        by smtp5 (Coremail) with SMTP id HdxpCgBHNCLxXvNi4RODTw--.11815S4;
        Wed, 10 Aug 2022 15:32:55 +0800 (CST)
From:   Jialiang Wang <wangjialiang0806@163.com>
To:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        wangjialiang0806@163.com
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Date:   Wed, 10 Aug 2022 15:30:57 +0800
Message-Id: <20220810073057.4032-1-wangjialiang0806@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HdxpCgBHNCLxXvNi4RODTw--.11815S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF43JFW3tF17WrWrCryfJFb_yoW5KryUpF
        yUJ3yrCrW8WrsrWw4DJFW8Z3sYgwsxt3W3u3WrAw4F9a4a9r47JF1xKr45Xr1UKFW8tFyS
        9ryjvr9xJFs8Zw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UJR67UUUUU=
X-Originating-IP: [39.79.223.215]
X-CM-SenderInfo: pzdqwy5ldoxtdqjqmiqw6rljoofrz/xtbCdQdZzmBbEsLOVwAAsX
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
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 34c0d2ddf9ef..a8286d0032d1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 	}
 
 	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
 	cache->addr = addr & ~(u64)(cache->size - 1);
 
 	/* Re-init to the new ID and address */
@@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		return NULL;
 	}
 
+	cache->id = id;
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;
-- 
2.17.1

