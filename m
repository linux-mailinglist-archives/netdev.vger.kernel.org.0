Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58C429067D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408380AbgJPNne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 09:43:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38034 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408362AbgJPNnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 09:43:19 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 09:43:18 EDT
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 934DD205CF;
        Fri, 16 Oct 2020 15:36:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OpGi8HVEnYyj; Fri, 16 Oct 2020 15:36:20 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6CC5920523;
        Fri, 16 Oct 2020 15:36:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 16 Oct 2020 15:36:20 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 16 Oct
 2020 15:36:19 +0200
Date:   Fri, 16 Oct 2020 15:36:12 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        "Antony Antony" <antony.antony@secunet.com>,
        Antony Antony <antony@phenome.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] xfrm: redact SA secret with lockdown confidentiality
Message-ID: <20201016133352.GA2338@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200728154342.GA31835@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200728154342.GA31835@moon.secunet.de>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

redact XFRM SA secret in the netlink response to xfrm_get_sa()
or dumpall sa.
Enable this at build time and set kernel lockdown to confidentiality.

e.g.
cat /sys/kernel/security/lockdown
none integrity [confidentiality]

ip xfrm state
src 172.16.1.200 dst 172.16.1.100
	proto esp spi 0x00000002 reqid 2 mode tunnel
	replay-window 0
	aead rfc4106(gcm(aes)) 0x0000000000000000000000000000000000000000 96

note: the aead secret is redacted.
Redacting secret is also a FIPS 140-2 requirement.

v1->v2
 - add size checks before memset calls
v2->v3
 - replace spaces with tabs for consistency
v3->v4
 - use kernel lockdown instead of a /proc setting

Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/linux/security.h |  1 +
 net/xfrm/Kconfig         |  9 +++++
 net/xfrm/xfrm_user.c     | 76 ++++++++++++++++++++++++++++++++++++----
 security/security.c      |  1 +
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 0a0a03b36a3b..8438970473b1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -126,6 +126,7 @@ enum lockdown_reason {
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
+	LOCKDOWN_XFRM_SECRET,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 5b9a5ab48111..cb592524701d 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -91,6 +91,15 @@ config XFRM_ESP
 	select CRYPTO_SEQIV
 	select CRYPTO_SHA256
 
+config XFRM_REDACT_SECRET
+	bool "Redact xfrm SA secret"
+	depends on XFRM && SECURITY_LOCKDOWN_LSM
+	default n
+	help
+	  Redats XFRM SA secret in the netlink message to user space.
+	  Redacting secret is also a FIPS 140-2 requirement.
+	  e.g. ip xfrm state; will show redacted the SA secret.
+
 config XFRM_IPCOMP
 	tristate
 	select XFRM_ALGO
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d06478..b57599d050dc 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/fips.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -848,21 +849,85 @@ static int copy_user_offload(struct xfrm_state_offload *xso, struct sk_buff *skb
 	return 0;
 }
 
+static bool xfrm_redact(void)
+{
+	return IS_ENABLED(CONFIG_SECURITY) &&
+		IS_ENABLED(CONFIG_XFRM_REDACT_SECRET) &&
+		security_locked_down(LOCKDOWN_XFRM_SECRET);
+}
+
 static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_buff *skb)
 {
 	struct xfrm_algo *algo;
+	struct xfrm_algo_auth *ap;
 	struct nlattr *nla;
+	bool redact_secret = xfrm_redact();
 
 	nla = nla_reserve(skb, XFRMA_ALG_AUTH,
 			  sizeof(*algo) + (auth->alg_key_len + 7) / 8);
 	if (!nla)
 		return -EMSGSIZE;
-
 	algo = nla_data(nla);
 	strncpy(algo->alg_name, auth->alg_name, sizeof(algo->alg_name));
-	memcpy(algo->alg_key, auth->alg_key, (auth->alg_key_len + 7) / 8);
+
+	if (redact_secret && auth->alg_key_len)
+		memset(algo->alg_key, 0, (auth->alg_key_len + 7) / 8);
+	else
+		memcpy(algo->alg_key, auth->alg_key,
+		       (auth->alg_key_len + 7) / 8);
 	algo->alg_key_len = auth->alg_key_len;
 
+	nla = nla_reserve(skb, XFRMA_ALG_AUTH_TRUNC, xfrm_alg_auth_len(auth));
+	if (!nla)
+		return -EMSGSIZE;
+	ap = nla_data(nla);
+	memcpy(ap, auth, sizeof(struct xfrm_algo_auth));
+	if (redact_secret && auth->alg_key_len)
+		memset(ap->alg_key, 0, (auth->alg_key_len + 7) / 8);
+	else
+		memcpy(ap->alg_key, auth->alg_key,
+		       (auth->alg_key_len + 7) / 8);
+	return 0;
+}
+
+static int copy_to_user_aead(struct xfrm_algo_aead *aead, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_AEAD, aead_len(aead));
+	struct xfrm_algo_aead *ap;
+	bool redact_secret = xfrm_redact();
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	ap = nla_data(nla);
+	memcpy(ap, aead, sizeof(*aead));
+
+	if (redact_secret && aead->alg_key_len)
+		memset(ap->alg_key, 0, (aead->alg_key_len + 7) / 8);
+	else
+		memcpy(ap->alg_key, aead->alg_key,
+		       (aead->alg_key_len + 7) / 8);
+	return 0;
+}
+
+static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
+{
+	struct xfrm_algo *ap;
+	bool redact_secret = xfrm_redact();
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_CRYPT,
+					 xfrm_alg_len(ealg));
+	if (!nla)
+		return -EMSGSIZE;
+
+	ap = nla_data(nla);
+	memcpy(ap, ealg, sizeof(*ealg));
+
+	if (redact_secret && ealg->alg_key_len)
+		memset(ap->alg_key, 0, (ealg->alg_key_len + 7) / 8);
+	else
+		memcpy(ap->alg_key, ealg->alg_key,
+		       (ealg->alg_key_len + 7) / 8);
+
 	return 0;
 }
 
@@ -906,20 +971,17 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
 			goto out;
 	}
 	if (x->aead) {
-		ret = nla_put(skb, XFRMA_ALG_AEAD, aead_len(x->aead), x->aead);
+		ret = copy_to_user_aead(x->aead, skb);
 		if (ret)
 			goto out;
 	}
 	if (x->aalg) {
 		ret = copy_to_user_auth(x->aalg, skb);
-		if (!ret)
-			ret = nla_put(skb, XFRMA_ALG_AUTH_TRUNC,
-				      xfrm_alg_auth_len(x->aalg), x->aalg);
 		if (ret)
 			goto out;
 	}
 	if (x->ealg) {
-		ret = nla_put(skb, XFRMA_ALG_CRYPT, xfrm_alg_len(x->ealg), x->ealg);
+		ret = copy_to_user_ealg(x->ealg, skb);
 		if (ret)
 			goto out;
 	}
diff --git a/security/security.c b/security/security.c
index 70a7ad357bc6..72d9aac7178a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -64,6 +64,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",
+	[LOCKDOWN_XFRM_SECRET] = "xfrm SA secret",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.20.1

