Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FAE623D15
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiKJID1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiKJIDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:03:18 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CBE31EF3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:03:17 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N7Dps6YyJz15MPB;
        Thu, 10 Nov 2022 16:03:01 +0800 (CST)
Received: from dggpeml500003.china.huawei.com (7.185.36.200) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 16:03:15 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500003.china.huawei.com
 (7.185.36.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 10 Nov
 2022 16:03:14 +0800
From:   Yu Liao <liaoyu15@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <gal@nvidia.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <davem@davemloft.net>
CC:     <liaoyu15@huawei.com>, <liwei391@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net/tls: Fix memory leak in tls_enc_skb()
Date:   Thu, 10 Nov 2022 16:01:31 +0800
Message-ID: <20221110080131.1919453-1-liaoyu15@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500003.china.huawei.com (7.185.36.200)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'aead_req' is allocated in tls_alloc_aead_request(), but not freed
in switch case 'default'. This commit fixes the potential memory leak
by freeing 'aead_req' under the situation.

Fixes: ea7a9d88ba21 ("net/tls: Use cipher sizes structs")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
---
 net/tls/tls_device_fallback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index cdb391a8754b..efffceee129f 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -346,7 +346,7 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 		salt = tls_ctx->crypto_send.aes_gcm_256.salt;
 		break;
 	default:
-		return NULL;
+		goto free_req;
 	}
 	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
 	buf_len = cipher_sz->salt + cipher_sz->iv + TLS_AAD_SPACE_SIZE +
-- 
2.25.1

