Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFDCF73F7
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKKMdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:33:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48237 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKMdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:33:41 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iU8sx-0000T0-6M; Mon, 11 Nov 2019 12:33:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windreiver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] tipc: fix update of the uninitialized variable err
Date:   Mon, 11 Nov 2019 12:33:34 +0000
Message-Id: <20191111123334.68401-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable err is not uninitialized and hence can potentially contain
any garbage value.  This may cause an error when logical or'ing the
return values from the calls to functions crypto_aead_setauthsize or
crypto_aead_setkey.  Fix this by setting err to the return of
crypto_aead_setauthsize rather than or'ing in the return into the
uninitialized variable

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 05f7ca76e8ce..990a872cec46 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -463,7 +463,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 			break;
 		}
 
-		err |= crypto_aead_setauthsize(tfm, TIPC_AES_GCM_TAG_SIZE);
+		err = crypto_aead_setauthsize(tfm, TIPC_AES_GCM_TAG_SIZE);
 		err |= crypto_aead_setkey(tfm, ukey->key, keylen);
 		if (unlikely(err)) {
 			crypto_free_aead(tfm);
-- 
2.20.1

