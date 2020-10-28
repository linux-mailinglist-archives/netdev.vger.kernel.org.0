Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D54429DAD3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390524AbgJ1XdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:33:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59476 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgJ1XdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:33:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kXjsA-0002fs-SB; Wed, 28 Oct 2020 11:44:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Artur Molchanov <arturmolchanov@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/sunrpc: fix unsigned size_t comparison to less than zero
Date:   Wed, 28 Oct 2020 11:44:10 +0000
Message-Id: <20201028114410.108759-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for *lenp < 0 is always true since the type is a size_t
and can never be negative. Fix this by casting it to ssize_t.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: c09f56b8f68d ("net/sunrpc: Fix return value for sysctl sunrpc.transports")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sunrpc/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index a18b36b5422d..bb62badef6bc 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -72,7 +72,7 @@ static int proc_do_xprt(struct ctl_table *table, int write,
 	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
 	*lenp = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
 
-	if (*lenp < 0) {
+	if ((ssize_t)*lenp < 0) {
 		*lenp = 0;
 		return -EINVAL;
 	}
-- 
2.27.0

