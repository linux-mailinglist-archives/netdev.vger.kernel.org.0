Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BEE58B615
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiHFOcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiHFOcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:32:18 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6BFCDF43;
        Sat,  6 Aug 2022 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=io15jxipwkxp8dnmKQ
        w0UQoEYG0T27HzvS5H04/lWlA=; b=h+R+2Yg4qw9b3KWTETWmceCkMhBzCnoN9F
        cGCKHNvFMLsZOTPF7Etoxo86gHbFWEEHSN6tFhybBWBsCswzqjS5QvpIN2DLTFtZ
        RI86nWWRDsN1gHndU8wqXFfo8N3HdDYvaSUb4Q/5947Rg3rvewmgt6Y9e63zNexP
        4Wsd/QoDE=
Received: from user-virtual-machine.localdomain (unknown [124.133.191.247])
        by smtp4 (Coremail) with SMTP id HNxpCgDXZ94be+5icYDGTQ--.25852S4;
        Sat, 06 Aug 2022 22:31:19 +0800 (CST)
From:   Jialiang Wang <wangjialiang0806@163.com>
To:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        wangjialiang0806@163.com
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfp: fix use-after-free in area_cache_get()
Date:   Sat,  6 Aug 2022 22:30:43 +0800
Message-Id: <20220806143043.106787-1-wangjialiang0806@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HNxpCgDXZ94be+5icYDGTQ--.25852S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw1Utw1kKryrGr1fWF4rZrb_yoW8Ar1UpF
        WrJ3yFkr48XrsrXw4DJayxX34rCa9xtFyrW345Cw4rua4avr13JF1xKr45ZF4DurW8Jayx
        AFyjqa4fGrs8J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwDGrUUUUU=
X-Originating-IP: [124.133.191.247]
X-CM-SenderInfo: pzdqwy5ldoxtdqjqmiqw6rljoofrz/1tbivxdVzlWB0wjmhAAAse
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

area_cache_get() calls cpp->op->area_init() and uses cache->area by
 nfp_cpp_area_priv(area), but in
 nfp_cpp_area_release()->nfp_cpp_area_put()->__release_cpp_area() we
 already freed the cache->area.

To avoid the use-after-free, reallocate a piece of memory for the
 cache->area by nfp_cpp_area_alloc().

Note: This vulnerability is triggerable by providing emulated device
 equipped with specified configuration.

BUG: KASAN: use-after-free in nfp6000_area_init+0x74/0x1d0 [nfp]
Write of size 4 at addr ffff888005b490a0 by task insmod/226
Call Trace:
  <TASK>
  dump_stack_lvl+0x33/0x46
  print_report.cold.12+0xb2/0x6b7
  ? nfp6000_area_init+0x74/0x1d0 [nfp]
  kasan_report+0xa5/0x120
  ? nfp6000_area_init+0x74/0x1d0 [nfp]
  nfp6000_area_init+0x74/0x1d0 [nfp]
  area_cache_get.constprop.8+0x2da/0x360 [nfp]

Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 34c0d2ddf9ef..99091f24d2ba 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -871,6 +871,10 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		nfp_cpp_area_release(cache->area);
 		cache->id = 0;
 		cache->addr = 0;
+		cache->area = nfp_cpp_area_alloc(cpp,
+						 NFP_CPP_ID(7,
+						 NFP_CPP_ACTION_RW, 0),
+						 0, cache->size);
 	}
 
 	/* Adjust the start address to be cache size aligned */
-- 
2.17.1

