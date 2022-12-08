Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C864672C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHCnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLHCm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:42:58 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E256566;
        Wed,  7 Dec 2022 18:42:56 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSJMb1zzlzRprN;
        Thu,  8 Dec 2022 10:42:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 10:42:54 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH net-next] net: tso: inline tso_count_descs()
Date:   Thu, 8 Dec 2022 10:43:03 +0800
Message-ID: <20221208024303.11191-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tso_count_descs() is a small function doing simple calculation,
and tso_count_descs() is used in fast path, so inline it to
reduce the overhead of calls.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/tso.h | 8 +++++++-
 net/core/tso.c    | 8 --------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index 62c98a9c60f1..ab6bbf56d984 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -16,7 +16,13 @@ struct tso_t {
 	u32	tcp_seq;
 };
 
-int tso_count_descs(const struct sk_buff *skb);
+/* Calculate expected number of TX descriptors */
+static inline int tso_count_descs(const struct sk_buff *skb)
+{
+	/* The Marvell Way */
+	return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
+}
+
 void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last);
 void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size);
diff --git a/net/core/tso.c b/net/core/tso.c
index 4148f6d48953..e00796e3b146 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -5,14 +5,6 @@
 #include <net/tso.h>
 #include <asm/unaligned.h>
 
-/* Calculate expected number of TX descriptors */
-int tso_count_descs(const struct sk_buff *skb)
-{
-	/* The Marvell Way */
-	return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
-}
-EXPORT_SYMBOL(tso_count_descs);
-
 void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last)
 {
-- 
2.33.0

