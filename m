Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C709F66CFF6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjAPUPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjAPUPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:15:12 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74DB2412A
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:11 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso938371wmq.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dypyk6ZgizeLKggHRu4doKP0wIPWphi3ZnBPXRfhuaQ=;
        b=Zc2tNSbZ9p9u6IeEuUGPuMM8mgTRpCMILK7SwLFU5BJ1Z2J2gHIFcOjzm8woT9ZYEm
         wmQYlHNLOsN101wndn4tI822PuJgVUohvqEcqAs+NwtGuPlHZqULY7w5xL1ER3D5SRZS
         oquvk7WMFUZiIpJEF+o/UEYyalmWs9HdN+i8gyujQr94Q+a1GwOoSK5PV64DSp4WuNtp
         wqRInVLlAsMSNooPSZQe35YEhZFvdDSWMBwlsZlzFA5jjZtol2bf09lOO/15Chr7CrtI
         sxqjH16sykUBSNVmqDtrRSH9Vpltkp2lePAOTnpABzutw3NwzoMlp2DjtlnWY+lzWaBh
         nXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dypyk6ZgizeLKggHRu4doKP0wIPWphi3ZnBPXRfhuaQ=;
        b=5uQlOgQGFPpIf/2hvFnq803L+gn1zTTufeg68XpBfGUrdfHAAPmCwm+Gj039IH/wjn
         k/WcVwMM5tXMRU034RWVaqHDNYRsOxEJF/X3PsWlzURjNivmb+0HcuIQy0PSr+dMbcZQ
         V5KAL2rBvzHSJTnDRrNvNPkRlyzgWQHcsFNXEyy9BsVusZV06J6U2paNTlzLWVXYf2ZK
         9+//g4pev/BrDPKW/UopMbrO2DNTmQ/b+c6dmTXR81VuFk36vPnkQHoCmXTCBfho8O61
         mYI31uT7ejYDBBTG9R6/1q1sHpL0P2hzWAE0JQ9G0ZfoZkAT8JwLM+dOhkHzS3cmmP1B
         uTyQ==
X-Gm-Message-State: AFqh2koW0J3VVDKkgzTnXqd7oGuAqERBGtTn98Bgi2PxThuiMIIQHZY0
        fvuO7MVIuMoCHBeLkAjcQ7Yfhg==
X-Google-Smtp-Source: AMrXdXvzWeOKq69D92Si/8hVLqBC08eyIrm4EbsRB58ohgbnlbS+nQHHBPZVMjFJ9XVIVdbDnopGdQ==
X-Received: by 2002:a05:600c:a54:b0:3da:fd1d:98d8 with SMTP id c20-20020a05600c0a5400b003dafd1d98d8mr670161wmq.22.1673900110191;
        Mon, 16 Jan 2023 12:15:10 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id bh13-20020a05600c3d0d00b003d358beab9dsm34549829wmb.47.2023.01.16.12.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:15:09 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/4] crypto/net/ipv6: sr: Switch to using crypto_pool
Date:   Mon, 16 Jan 2023 20:14:57 +0000
Message-Id: <20230116201458.104260-4-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116201458.104260-1-dima@arista.com>
References: <20230116201458.104260-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to use crypto_pool has the following upsides:
- now SR uses asynchronous API which may potentially free CPU cycles and
  improve performance for of CPU crypto algorithm providers;
- hash descriptors now don't have to be allocated on boot, but only at
  the moment SR starts using HMAC and until the last HMAC secret is
  deleted;
- potentially reuse ahash_request(s) for different users
- allocate only one per-CPU scratch buffer rather than a new one for
  each user
- have a common API for net/ users that need ahash on RX/TX fast path

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/seg6_hmac.h |   7 --
 net/ipv6/Kconfig        |   1 +
 net/ipv6/seg6.c         |   3 -
 net/ipv6/seg6_hmac.c    | 207 +++++++++++++++-------------------------
 4 files changed, 79 insertions(+), 139 deletions(-)

diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 2b5d2ee5613e..d6b7820ecda2 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -32,13 +32,6 @@ struct seg6_hmac_info {
 	u8 alg_id;
 };
 
-struct seg6_hmac_algo {
-	u8 alg_id;
-	char name[64];
-	struct crypto_shash * __percpu *tfms;
-	struct shash_desc * __percpu *shashs;
-};
-
 extern int seg6_hmac_compute(struct seg6_hmac_info *hinfo,
 			     struct ipv6_sr_hdr *hdr, struct in6_addr *saddr,
 			     u8 *output);
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b..e9aa99180f85 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -305,6 +305,7 @@ config IPV6_SEG6_HMAC
 	bool "IPv6: Segment Routing HMAC support"
 	depends on IPV6
 	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 29346a6eec9f..3d66bf6d4c66 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -558,9 +558,6 @@ int __init seg6_init(void)
 
 void seg6_exit(void)
 {
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	seg6_hmac_exit();
-#endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	seg6_iptunnel_exit();
 #endif
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index d43c50a7310d..2395d227018c 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -35,6 +35,7 @@
 #include <net/xfrm.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <net/seg6.h>
 #include <net/genetlink.h>
 #include <net/seg6_hmac.h>
@@ -70,6 +71,12 @@ static const struct rhashtable_params rht_params = {
 	.obj_cmpfn		= seg6_hmac_cmpfn,
 };
 
+struct seg6_hmac_algo {
+	u8 alg_id;
+	char name[64];
+	int crypto_pool_id;
+};
+
 static struct seg6_hmac_algo hmac_algos[] = {
 	{
 		.alg_id = SEG6_HMAC_ALGO_SHA1,
@@ -115,55 +122,17 @@ static struct seg6_hmac_algo *__hmac_get_algo(u8 alg_id)
 	return NULL;
 }
 
-static int __do_hmac(struct seg6_hmac_info *hinfo, const char *text, u8 psize,
-		     u8 *output, int outlen)
-{
-	struct seg6_hmac_algo *algo;
-	struct crypto_shash *tfm;
-	struct shash_desc *shash;
-	int ret, dgsize;
-
-	algo = __hmac_get_algo(hinfo->alg_id);
-	if (!algo)
-		return -ENOENT;
-
-	tfm = *this_cpu_ptr(algo->tfms);
-
-	dgsize = crypto_shash_digestsize(tfm);
-	if (dgsize > outlen) {
-		pr_debug("sr-ipv6: __do_hmac: digest size too big (%d / %d)\n",
-			 dgsize, outlen);
-		return -ENOMEM;
-	}
-
-	ret = crypto_shash_setkey(tfm, hinfo->secret, hinfo->slen);
-	if (ret < 0) {
-		pr_debug("sr-ipv6: crypto_shash_setkey failed: err %d\n", ret);
-		goto failed;
-	}
-
-	shash = *this_cpu_ptr(algo->shashs);
-	shash->tfm = tfm;
-
-	ret = crypto_shash_digest(shash, text, psize, output);
-	if (ret < 0) {
-		pr_debug("sr-ipv6: crypto_shash_digest failed: err %d\n", ret);
-		goto failed;
-	}
-
-	return dgsize;
-
-failed:
-	return ret;
-}
-
 int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 		      struct in6_addr *saddr, u8 *output)
 {
 	__be32 hmackeyid = cpu_to_be32(hinfo->hmackeyid);
-	u8 tmp_out[SEG6_HMAC_MAX_DIGESTSIZE];
+	struct crypto_pool_ahash hp;
+	struct seg6_hmac_algo *algo;
 	int plen, i, dgsize, wrsize;
+	struct crypto_ahash *tfm;
+	struct scatterlist sg;
 	char *ring, *off;
+	int err;
 
 	/* a 160-byte buffer for digest output allows to store highest known
 	 * hash function (RadioGatun) with up to 1216 bits
@@ -176,6 +145,10 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 	if (plen >= SEG6_HMAC_RING_SIZE)
 		return -EMSGSIZE;
 
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (!algo)
+		return -ENOENT;
+
 	/* Let's build the HMAC text on the ring buffer. The text is composed
 	 * as follows, in order:
 	 *
@@ -186,8 +159,36 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 	 * 5. All segments in the segments list (n * 128 bits)
 	 */
 
-	local_bh_disable();
+	err = crypto_pool_start(algo->crypto_pool_id, &hp.base);
+	if (err)
+		return err;
+
 	ring = this_cpu_ptr(hmac_ring);
+
+	sg_init_one(&sg, ring, plen);
+
+	tfm = crypto_ahash_reqtfm(hp.req);
+	dgsize = crypto_ahash_digestsize(tfm);
+	if (dgsize > SEG6_HMAC_MAX_DIGESTSIZE) {
+		pr_debug("digest size too big (%d / %d)\n",
+			 dgsize, SEG6_HMAC_MAX_DIGESTSIZE);
+		err = -ENOMEM;
+		goto err_end_pool;
+	}
+
+	err = crypto_ahash_setkey(tfm, hinfo->secret, hinfo->slen);
+	if (err) {
+		pr_debug("crypto_ahash_setkey failed: err %d\n", err);
+		goto err_end_pool;
+	}
+
+	err = crypto_ahash_init(hp.req);
+	if (err)
+		goto err_end_pool;
+
+	ahash_request_set_crypt(hp.req, &sg,
+				hp.base.scratch, SEG6_HMAC_MAX_DIGESTSIZE);
+
 	off = ring;
 
 	/* source address */
@@ -210,21 +211,25 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 		off += 16;
 	}
 
-	dgsize = __do_hmac(hinfo, ring, plen, tmp_out,
-			   SEG6_HMAC_MAX_DIGESTSIZE);
-	local_bh_enable();
+	err = crypto_ahash_update(hp.req);
+	if (err)
+		goto err_end_pool;
 
-	if (dgsize < 0)
-		return dgsize;
+	err = crypto_ahash_final(hp.req);
+	if (err)
+		goto err_end_pool;
 
 	wrsize = SEG6_HMAC_FIELD_LEN;
 	if (wrsize > dgsize)
 		wrsize = dgsize;
 
 	memset(output, 0, SEG6_HMAC_FIELD_LEN);
-	memcpy(output, tmp_out, wrsize);
+	memcpy(output, hp.base.scratch, wrsize);
+
+err_end_pool:
+	crypto_pool_end();
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(seg6_hmac_compute);
 
@@ -291,12 +296,24 @@ EXPORT_SYMBOL(seg6_hmac_info_lookup);
 int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
-	int err;
+	struct seg6_hmac_algo *algo;
+	int ret;
+
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (!algo)
+		return -ENOENT;
+
+	ret = crypto_pool_alloc_ahash(algo->name, SEG6_HMAC_MAX_DIGESTSIZE);
+	if (ret < 0)
+		return ret;
+	algo->crypto_pool_id = ret;
 
-	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
+	ret = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
+	if (ret)
+		crypto_pool_release(algo->crypto_pool_id);
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL(seg6_hmac_info_add);
 
@@ -304,6 +321,7 @@ int seg6_hmac_info_del(struct net *net, u32 key)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	struct seg6_hmac_info *hinfo;
+	struct seg6_hmac_algo *algo;
 	int err = -ENOENT;
 
 	hinfo = rhashtable_lookup_fast(&sdata->hmac_infos, &key, rht_params);
@@ -315,6 +333,12 @@ int seg6_hmac_info_del(struct net *net, u32 key)
 	if (err)
 		goto out;
 
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (algo)
+		crypto_pool_release(algo->crypto_pool_id);
+	else
+		WARN_ON_ONCE(1);
+
 	seg6_hinfo_release(hinfo);
 
 out:
@@ -348,58 +372,6 @@ int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 }
 EXPORT_SYMBOL(seg6_push_hmac);
 
-static int seg6_hmac_init_algo(void)
-{
-	struct seg6_hmac_algo *algo;
-	struct crypto_shash *tfm;
-	struct shash_desc *shash;
-	int i, alg_count, cpu;
-
-	alg_count = ARRAY_SIZE(hmac_algos);
-
-	for (i = 0; i < alg_count; i++) {
-		struct crypto_shash **p_tfm;
-		int shsize;
-
-		algo = &hmac_algos[i];
-		algo->tfms = alloc_percpu(struct crypto_shash *);
-		if (!algo->tfms)
-			return -ENOMEM;
-
-		for_each_possible_cpu(cpu) {
-			tfm = crypto_alloc_shash(algo->name, 0, 0);
-			if (IS_ERR(tfm))
-				return PTR_ERR(tfm);
-			p_tfm = per_cpu_ptr(algo->tfms, cpu);
-			*p_tfm = tfm;
-		}
-
-		p_tfm = raw_cpu_ptr(algo->tfms);
-		tfm = *p_tfm;
-
-		shsize = sizeof(*shash) + crypto_shash_descsize(tfm);
-
-		algo->shashs = alloc_percpu(struct shash_desc *);
-		if (!algo->shashs)
-			return -ENOMEM;
-
-		for_each_possible_cpu(cpu) {
-			shash = kzalloc_node(shsize, GFP_KERNEL,
-					     cpu_to_node(cpu));
-			if (!shash)
-				return -ENOMEM;
-			*per_cpu_ptr(algo->shashs, cpu) = shash;
-		}
-	}
-
-	return 0;
-}
-
-int __init seg6_hmac_init(void)
-{
-	return seg6_hmac_init_algo();
-}
-
 int __net_init seg6_hmac_net_init(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
@@ -407,29 +379,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
 	return rhashtable_init(&sdata->hmac_infos, &rht_params);
 }
 
-void seg6_hmac_exit(void)
-{
-	struct seg6_hmac_algo *algo = NULL;
-	int i, alg_count, cpu;
-
-	alg_count = ARRAY_SIZE(hmac_algos);
-	for (i = 0; i < alg_count; i++) {
-		algo = &hmac_algos[i];
-		for_each_possible_cpu(cpu) {
-			struct crypto_shash *tfm;
-			struct shash_desc *shash;
-
-			shash = *per_cpu_ptr(algo->shashs, cpu);
-			kfree(shash);
-			tfm = *per_cpu_ptr(algo->tfms, cpu);
-			crypto_free_shash(tfm);
-		}
-		free_percpu(algo->tfms);
-		free_percpu(algo->shashs);
-	}
-}
-EXPORT_SYMBOL(seg6_hmac_exit);
-
 void __net_exit seg6_hmac_net_exit(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
-- 
2.39.0

