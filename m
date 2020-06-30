Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3907A20F729
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388937AbgF3O15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:27:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47963 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388137AbgF3O15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:27:57 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jqHEg-0000Ds-8j; Tue, 30 Jun 2020 14:27:46 +0000
From:   Colin King <colin.king@canonical.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/tls: fix sign extension issue when left shifting u16 value
Date:   Tue, 30 Jun 2020 15:27:46 +0100
Message-Id: <20200630142746.516188-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Left shifting the u16 value promotes it to a int and then it
gets sign extended to a u64.  If len << 16 is greater than 0x7fffffff
then the upper bits get set to 1 because of the implicit sign extension.
Fix this by casting len to u64 before shifting it.

Addresses-Coverity: ("integer handling issues")
Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 include/net/tls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index c875c0a445a6..e5dac7e74e79 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -637,7 +637,7 @@ tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 
 	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
-		     (len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
+		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
 	rx_ctx->resync_async->loglen = 0;
 }
 
-- 
2.27.0

