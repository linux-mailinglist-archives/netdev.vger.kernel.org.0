Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD436C3C9
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbhD0K3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:29:42 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42309 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238388AbhD0K3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:29:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWzGZ.v_1619519304;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzGZ.v_1619519304)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:28:30 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     borisp@nvidia.com
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/tls: Remove redundant initialization of record
Date:   Tue, 27 Apr 2021 18:28:22 +0800
Message-Id: <1619519302-59518-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

record is being initialized to ctx->open_record but this is never
read as record is overwritten later on.  Remove the redundant
initialization.

Cleans up the following clang-analyzer warning:

net/tls/tls_device.c:421:26: warning: Value stored to 'record' during
its initialization is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index d9cd229..72227fe 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -418,7 +418,7 @@ static int tls_push_data(struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-	struct tls_record_info *record = ctx->open_record;
+	struct tls_record_info *record;
 	int tls_push_record_flags;
 	struct page_frag *pfrag;
 	size_t orig_size = size;
-- 
1.8.3.1

