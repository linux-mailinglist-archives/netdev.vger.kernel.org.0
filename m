Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9C43D6520
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhGZQYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:24:00 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:51368 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240198AbhGZQVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:21:09 -0400
Received: from MTA-07-3.privateemail.com (mta-07-1.privateemail.com [198.54.122.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id A69DE80AA7;
        Mon, 26 Jul 2021 13:01:36 -0400 (EDT)
Received: from mta-07.privateemail.com (localhost [127.0.0.1])
        by mta-07.privateemail.com (Postfix) with ESMTP id EC71618000A9;
        Mon, 26 Jul 2021 13:01:34 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.236])
        by mta-07.privateemail.com (Postfix) with ESMTPA id 3DC9218000A7;
        Mon, 26 Jul 2021 13:01:33 -0400 (EDT)
From:   Jordy Zomer <jordy@pwning.systems>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: ccm - avoid negative wrapping of integers 
Date:   Mon, 26 Jul 2021 19:01:20 +0200
Message-Id: <20210726170120.410705-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set csize to unsigned int to avoid it from wrapping as a negative number (since format input sends an unsigned integer to this function). This would also result in undefined behavior in the left shift when msg len is checked, potentially resulting in a buffer overflow in the memcpy call.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
To address was corrected, and ccm was added to the topic to indicate that this is just for ccm.

 crypto/ccm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 6b815ece51c6..e14201edf9db 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -66,7 +66,7 @@ static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
 	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
 }
 
-static int set_msg_len(u8 *block, unsigned int msglen, int csize)
+static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 {
 	__be32 data;
 
-- 
2.27.0

