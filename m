Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED76A5A8F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjB1OIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjB1OIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:08:02 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A2559CB
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 06:07:56 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PQzfp3G2Zz9tB6;
        Tue, 28 Feb 2023 22:05:54 +0800 (CST)
Received: from huawei.com (10.137.16.107) by canpemm500002.china.huawei.com
 (7.192.104.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 28 Feb
 2023 22:07:52 +0800
From:   Aichun Li <liaichun@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <steffen.klassert@secunet.com>,
        <liaichun@huawei.com>, <yanan@huawei.com>, <zhongxuan2@huawei.com>
Subject: [PATCH] af_key: Fix panic in dump_ah_combs()
Date:   Tue, 28 Feb 2023 22:01:26 +0800
Message-ID: <20230228140126.2208-1-liaichun@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.16.107]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the exclamation mark (!) is removed, the return value calculated by
 count_esp_combs is smaller than that before ealg->available is removed. And in
 dump_esp_combs, the number of struct sadb_combs in skb_put is larger than
 alloc, This result in a buffer overrun.

[ 658.159619] ------------[ cut here ]------------
[ 658.159629] kernel BUG at net/core/skbuff.c:110!
[ 658.159733] invalid opcode: 0000 [#1] SMP KASAN NOPTI
[ 658.160047] CPU: 14 PID: 107946 Comm: kernel_BUG_in_w Kdump: loaded Tainted: G I 5.10.0-60.18.0.50.x86_64 #1
[ 658.160179] Hardware name: Huawei 2288H V5/BC11SPSCB0, BIOS 8.20 10/20/2021
[ 658.160308] RIP: 0010:skb_panic+0xda/0xec
[ 658.160416] Code: e8 48 c7 c7 00 a3 c2 a3 41 56 48 8b 74 24 18 4d 89 f9 56 48 8b 54 24 18 48 89 ee 52 48 8b 44 24 18 4c 89 e2 50 e8 6a 27 f6 ff <0f> 0b 48 c7 c7 a0 63 ca a4 48 83 c4 20 e8 d3 f6 f9 ff e8 2e 13 ea
[ 658.160567] RSP: 0018:ffff88bba055eec8 EFLAGS: 00010282
[ 658.160675] RAX: 0000000000000089 RBX: ffff888265bffac0 RCX: 0000000000000000
[ 658.160795] RDX: ffff88b5af172200 RSI: 0000000000000008 RDI: ffffed17740abdcb
[ 658.160919] RBP: ffffffffa3c2a820 R08: 0000000000000089 R09: ffff88a37a340727
[ 658.161039] R10: ffffed146f4680e4 R11: 0000000000000001 R12: ffffffffc1708e4d
[ 658.161160] R13: 0000000000000048 R14: ffffffffa3c2a2c0 R15: ffff8883f0d73000
[ 658.161281] FS: 00007fd756c30640(0000) GS:ffff88a37a300000(0000) knlGS:0000000000000000
[ 658.161403] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 658.161509] CR2: 00007f40ed3a56e4 CR3: 000000384d578001 CR4: 00000000007706e0
[ 658.161629] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 658.161749] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 658.161867] PKRU: 55555554
[ 658.161966] Call Trace:
[ 658.162181] skb_put.cold+0x24/0x24
[ 658.162288] dump_esp_combs+0x1ad/0x330 [af_key]
[ 658.162396] pfkey_send_acquire+0x66e/0x6b0 [af_key]
[ 658.162508] xfrm_state_find+0x137b/0x1c00
[ 658.163161] xfrm_tmpl_resolve_one+0x171/0x640
[ 658.164651] xfrm_tmpl_resolve+0x14d/0x2e0
[ 658.165077] xfrm_resolve_and_create_bundle+0xb8/0x250

Fixes: 7f57f8165cb6 ("af_key: Fix send_acquire race with pfkey_register")
Signed-off-by: Aichun Li <liaichun@huawei.com>
Signed-off-by: zhongxuan <zhongxuan2@huawei.com>

---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 8bc7d3999..bf2859c37 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2927,7 +2927,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
-- 
2.19.1

