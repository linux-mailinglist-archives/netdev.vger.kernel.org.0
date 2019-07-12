Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF3E676E7
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 01:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfGLXnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 19:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfGLXnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 19:43:17 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545C4208E4;
        Fri, 12 Jul 2019 23:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562974996;
        bh=mrk9cM3E/NHi3yeje7o4FJ+IK8GPAiND+eq2kM6sNCo=;
        h=From:To:Cc:Subject:Date:From;
        b=zO6l0Q6fuC9zNfPOJc/TsQOgqldV9G3ZVVKPqNF+wc/rZ7M4njVPPya+edWLLeTZu
         alIMAA3scFEDxW+ZToapkqhkpTf/5xLLBrNr9PNzRzz6nn0cQ5py756cvcooYb9tIL
         6QuXuPOpXg5FK7BjD4udKzQJrtxuBKFoGSrFgLYs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org, linux-ppp@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>
Cc:     linux-crypto@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH net] ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
Date:   Fri, 12 Jul 2019 16:39:31 -0700
Message-Id: <20190712233931.17350-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit 0e5a610b5ca5 ("ppp: mppe: switch to RC4 library interface"),
which was merged through the crypto tree for v5.3, changed ppp_mppe.c to
use the new arc4_crypt() library function rather than access RC4 through
the dynamic crypto_skcipher API.

Meanwhile commit aad1dcc4f011 ("ppp: mppe: Add softdep to arc4") was
merged through the net tree and added a module soft-dependency on "arc4".

The latter commit no longer makes sense because the code now uses the
"libarc4" module rather than "arc4", and also due to the direct use of
arc4_crypt(), no module soft-dependency is required.

So revert the latter commit.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/net/ppp/ppp_mppe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index bd3c80b0bc77d..de3b57d09d0cb 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -64,7 +64,6 @@ MODULE_AUTHOR("Frank Cusack <fcusack@fcusack.com>");
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
-MODULE_SOFTDEP("pre: arc4");
 MODULE_VERSION("1.0.2");
 
 #define SHA1_PAD_SIZE 40
-- 
2.22.0

