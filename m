Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC44049A26
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfFRHPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:15:36 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:40343 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRHPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 03:15:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M4384-1hd8Kv47Ga-0006FN; Tue, 18 Jun 2019 09:15:22 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipsec: select CRYPTO_HASH for xfrm_algo
Date:   Tue, 18 Jun 2019 09:14:51 +0200
Message-Id: <20190618071514.2222319-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:u3psbrxat/GLqgS5cJ3IaOBxrFJa4MkaDmkx8Unot6fN0EKdDMx
 y3EvyY4XwZeNwCGB7zwuONa0vqHfcJgX0a0YzA1DQxv2snq+zMtTTeUZ4fVDsp/TLnmtZS2
 QISAHpulpONQ/r+eEqK+S+G9A+y/pze7OjmCn3mmE//syAcwak444UsX43iugg0ExoKd063
 Da9wl3RqOOjIgYUhe4ZIA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vpVSPrVCFpY=:gklKkq23m6xWr7LcD0e3DV
 kPvzYTDTt1UybQ2J+7E5RZaFv5W7UIcw8ieP/RtfP0PhJspeHb8/oBr8FZCC5Q0xf/yZPWCVe
 MSGKO45HjS2Q8kg09Sa15Hf7mHXXyCFAcp9KkyOUGcb3kmQmqgw9qhLXNfiODPDNLJq4NjSkz
 TuH0bOoLbiczIImcf69ZA00Vz9Iyy5IMvyI2s/IgjvoGc+1od3TW07N1CNxCAYKejBBZ/UErt
 cgm4rrXnG4PYe1C9b+yDHCCJiGX2VRTFBA4n0W4Mk1MAQd9+9rXECTuDwqK6PAUFv+BNeirxl
 4mZiVWt3AFoZNWu+Bk3t1gqSpx/JPs4eAIJTxJm5TJ4dmGpIXT/llCdVMhUkwZgfPkFhOHug2
 gVj+VWy6w9GH3RSC/GkeeWaOBp4yVvw/FI0PL/Ew+Xoy2/pH2t+1aS0pIaQO4ps8AXJZjV/9c
 lFthLRRE2IBoYdKcnMZ7opmq47Cp133TKbESaF6acf+93Z87Y8La9a/YnouaalsxoHSIhGPGi
 IX8632Q2KuxlXs4rvYn9/vthJvvzAykis291z7HtvMOI0qdzicCLwAeIAwGjw/HuzXL0C/7ZW
 /C5NUKaer/JeTwl4J81/c67okRR4fcITbseyFU2Obxe6t6zXKz57/ddRWsBYukdHxjN5TiscS
 qakAvyqmSUEyKawXH5CxYm9coFZE/flygLitNsUsEgjP2WAMDgAPdoSNMO7L44333VqdJzewA
 wVMhpKcQJx1VMqmTqmYGVwVccbgwcACh/7hTHg==
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
do for all its other users.

Fixes: 17bc19702221 ("ipsec: Use skcipher and ahash when probing algorithms")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/xfrm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index c967fc3c38c8..a5c967efe5f4 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -15,6 +15,7 @@ config XFRM_ALGO
 	tristate
 	select XFRM
 	select CRYPTO
+	select CRYPTO_HASH
 
 if INET
 config XFRM_USER
-- 
2.20.0

