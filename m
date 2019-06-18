Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F549F13
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfFRLWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:22:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53727 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfFRLWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 07:22:42 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M3D3N-1hcMiR2pDh-003bdJ; Tue, 18 Jun 2019 13:22:30 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] ipsec: select crypto ciphers for xfrm_algo
Date:   Tue, 18 Jun 2019 13:22:13 +0200
Message-Id: <20190618112227.3322313-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lw/hXW2vB3PxvLPFBjrfkYIPVf2yXaIQORIsqAOgDFhnL84DA4J
 dhVA4ckt++OIzSK04xeN0mEfdNrwclg6nZVM/LfQRR/IVWV6eh+enRiuzT2Nc9Rkw5HpaLH
 D3LvW31viw6IbVRcHXwmWTYpE5k8cnUdBPw4R1KmbiJUzXIWv3q1jKmKUa2FVrBlxv9tCTP
 8Wj4xP6RLMsSl0CMVjHbQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m/LZHXpwX90=:mFZxy/qdnw7gHjPsjoAtgb
 r6ENAoh5kpgj/Qwhf9FP/iop2ulo7mBq/tIZbXccWcXekIqWXLyyyddTVMvs1/3VdOWhnfZai
 DeIYmQm02WQku3i+E4KeAVKWIlS3sM8tfW1W7SWH3k0gsVhq14VFxPN2ZQ2n0pC7BhgQYx9zk
 ADiBjsnpNtcGLXQutUWveCLHm9Cjy1K6jfPRYmIIYMNIBzUl+m/oQLiinqmY9Nfq5FYZstdi+
 4JwfeSmW7Nmc6uaNFyuejiUKHikaWybcyRQFgW15/X34RVE15I9BF9MfT79lu8wIx2ZsjeXT9
 bOtOzKiuJGTPEz68rDy8xLeljcb2+XGmRpNATWFr+KDUZ9gF8FvYEtfX9cMCabs1FMEHTcBv+
 XVwa9vvS1sRrG5AC9xqO1WA6pRLAgA2Hcnua52mP8v24sn0KWOG+j6+aROydGKMWRpW/SoopL
 fiXE9JrY8kHH+m3RAT4fC13cVJnnimUbXYvqnB05WVVVVY3w1oVU+ki6OkUrWUse3ZB4igCrc
 C/38/Mqpuk/J2kPwuL8crdpeirfeg6Wa7EAaSS9FjsJUMdcH4/OzFkbS4mCrQfD0H6K2E44ih
 CTeBTGIcXUs6qdaPHfPC7L9gQt+fjoVJ0zV1kwlQ8ZOsYHAXLc0nk8OtRGNoggKgx7rCF9uNG
 Orciti3i/Z3wM2OCJr2pZUL01osHobaTROAdrCbWoEN8MZ++Fo12pnArQ1xBDUaKlBXiaogvi
 +TIU8WOq8OTq88Wogw5P1gvmfF+ZjRzqLFWcCg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernelci.org reports failed builds on arc because of what looks
like an old missed 'select' statement:

net/xfrm/xfrm_algo.o: In function `xfrm_probe_algs':
xfrm_algo.c:(.text+0x1e8): undefined reference to `crypto_has_ahash'

I don't see this in randconfig builds on other architectures, but
it's fairly clear we want to select the hash code for it, like we
do for all its other users. As Herbert points out, CRYPTO_BLKCIPHER
is also required even though it has not popped up in build tests.

Fixes: 17bc19702221 ("ipsec: Use skcipher and ahash when probing algorithms")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/xfrm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index c967fc3c38c8..51bb6018f3bf 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -15,6 +15,8 @@ config XFRM_ALGO
 	tristate
 	select XFRM
 	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
 
 if INET
 config XFRM_USER
-- 
2.20.0

