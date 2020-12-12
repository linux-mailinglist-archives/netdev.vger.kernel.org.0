Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C02D85CE
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438596AbgLLKN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:13:59 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48606 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405606AbgLLKNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 05:13:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2263620491;
        Sat, 12 Dec 2020 09:57:41 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GklH7vDJsZat; Sat, 12 Dec 2020 09:57:40 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78953201D3;
        Sat, 12 Dec 2020 09:57:40 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 12 Dec 2020 09:57:40 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 12 Dec
 2020 09:57:40 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B69B93182CE6;
 Sat, 12 Dec 2020 09:57:39 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH] xfrm: redact SA secret with lockdown confidentiality
Date:   Sat, 12 Dec 2020 09:57:37 +0100
Message-ID: <20201212085737.2101294-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201212085737.2101294-1-steffen.klassert@secunet.com>
References: <20201212085737.2101294-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

redact XFRM SA secret in the netlink response to xfrm_get_sa()
or dumpall sa.
Enable lockdown, confidentiality mode, at boot or at run time.

e.g. when enabled:
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
v4->v5
 - remove kconfig option

Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/security.h |  1 +
 net/xfrm/xfrm_user.c     | 74 ++++++++++++++++++++++++++++++++++++----
 security/security.c      |  1 +
 3 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index bc2725491560..1112a79a7dba 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -127,6 +127,7 @@ enum lockdown_reason {
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
+	LOCKDOWN_XFRM_SECRET,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d0c32a8fcc4a..0727ac853b55 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -848,21 +848,84 @@ static int copy_user_offload(struct xfrm_state_offload *xso, struct sk_buff *skb
 	return 0;
 }
 
+static bool xfrm_redact(void)
+{
+	return IS_ENABLED(CONFIG_SECURITY) &&
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
 
@@ -906,20 +969,17 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
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
index a28045dc9e7f..abff77c1c8a7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -65,6 +65,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",
+	[LOCKDOWN_XFRM_SECRET] = "xfrm SA secret",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.25.1

