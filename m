Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8615A1A6DF8
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388857AbgDMVRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:17:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32944 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388862AbgDMVQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 17:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586812610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=4103XOmTCOkotD6W71w04IIsmGq3Nay8ikvndXgPL5w=;
        b=K8fdAigae0cAaA/AQ/WaouY9ItyGmlL0NayNXqk74dhLvw+TyqLpX9l5SV8bme63wAaIPX
        1Tc4cNWWE6EKarqlN3YaEpOSLN4XcatsjsRmtwacxzM3FIiDp0QeACXLxVIREZ8lcHu7rU
        J/Qh/FMTCeybdWNeQbMTIjNe2Jjntzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-1bUgLejzNxa2v5aK4yBZww-1; Mon, 13 Apr 2020 17:16:44 -0400
X-MC-Unique: 1bUgLejzNxa2v5aK4yBZww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE2001005509;
        Mon, 13 Apr 2020 21:16:39 +0000 (UTC)
Received: from llong.com (ovpn-115-28.rdu2.redhat.com [10.10.115.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3E311D2D1;
        Mon, 13 Apr 2020 21:16:33 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>
Cc:     linux-mm@kvack.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-ppp@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        cocci@systeme.lip6.fr, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, Waiman Long <longman@redhat.com>
Subject: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Date:   Mon, 13 Apr 2020 17:15:49 -0400
Message-Id: <20200413211550.8307-2-longman@redhat.com>
In-Reply-To: <20200413211550.8307-1-longman@redhat.com>
References: <20200413211550.8307-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As said by Linus:

  A symmetric naming is only helpful if it implies symmetries in use.
  Otherwise it's actively misleading.

  In "kzalloc()", the z is meaningful and an important part of what the
  caller wants.

  In "kzfree()", the z is actively detrimental, because maybe in the
  future we really _might_ want to use that "memfill(0xdeadbeef)" or
  something. The "zero" part of the interface isn't even _relevant_.

The main reason that kzfree() exists is to clear sensitive information
that should not be leaked to other future users of the same memory
objects.

Rename kzfree() to kfree_sensitive() to follow the example of the
recently added kvfree_sensitive() and make the intention of the API
more explicit. In addition, memzero_explicit() is used to clear the
memory to make sure that it won't get optimized away by the compiler.

The renaming is done by using the command sequence:

  git grep -w --name-only kzfree |\
  xargs sed -i 's/\bkzfree\b/kfree_sensitive/'

followed by some editing of the kfree_sensitive() kerneldoc and the
use of memzero_explicit() instead of memset().

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 arch/s390/crypto/prng.c                       |  4 +--
 arch/x86/power/hibernate.c                    |  2 +-
 crypto/adiantum.c                             |  2 +-
 crypto/ahash.c                                |  4 +--
 crypto/api.c                                  |  2 +-
 crypto/asymmetric_keys/verify_pefile.c        |  4 +--
 crypto/deflate.c                              |  2 +-
 crypto/drbg.c                                 | 10 +++---
 crypto/ecc.c                                  |  8 ++---
 crypto/ecdh.c                                 |  2 +-
 crypto/gcm.c                                  |  2 +-
 crypto/gf128mul.c                             |  4 +--
 crypto/jitterentropy-kcapi.c                  |  2 +-
 crypto/rng.c                                  |  2 +-
 crypto/rsa-pkcs1pad.c                         |  6 ++--
 crypto/seqiv.c                                |  2 +-
 crypto/shash.c                                |  2 +-
 crypto/skcipher.c                             |  2 +-
 crypto/testmgr.c                              |  6 ++--
 crypto/zstd.c                                 |  2 +-
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  2 +-
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   |  4 +--
 drivers/crypto/atmel-ecc.c                    |  2 +-
 drivers/crypto/caam/caampkc.c                 | 28 +++++++--------
 drivers/crypto/cavium/cpt/cptvf_main.c        |  6 ++--
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c  | 12 +++----
 drivers/crypto/cavium/nitrox/nitrox_lib.c     |  4 +--
 drivers/crypto/cavium/zip/zip_crypto.c        |  6 ++--
 drivers/crypto/ccp/ccp-crypto-rsa.c           |  6 ++--
 drivers/crypto/ccree/cc_aead.c                |  4 +--
 drivers/crypto/ccree/cc_buffer_mgr.c          |  4 +--
 drivers/crypto/ccree/cc_cipher.c              |  6 ++--
 drivers/crypto/ccree/cc_hash.c                |  8 ++---
 drivers/crypto/ccree/cc_request_mgr.c         |  2 +-
 drivers/crypto/marvell/cesa/hash.c            |  2 +-
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |  6 ++--
 .../marvell/octeontx/otx_cptvf_reqmgr.h       |  2 +-
 drivers/crypto/mediatek/mtk-aes.c             |  2 +-
 drivers/crypto/nx/nx.c                        |  4 +--
 drivers/crypto/virtio/virtio_crypto_algs.c    | 12 +++----
 drivers/crypto/virtio/virtio_crypto_core.c    |  2 +-
 drivers/md/dm-crypt.c                         | 34 +++++++++----------
 drivers/md/dm-integrity.c                     |  6 ++--
 drivers/misc/ibmvmc.c                         |  6 ++--
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  6 ++--
 drivers/net/ppp/ppp_mppe.c                    |  6 ++--
 drivers/net/wireguard/noise.c                 |  4 +--
 drivers/net/wireguard/peer.c                  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  6 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  6 ++--
 drivers/net/wireless/intersil/orinoco/wext.c  |  4 +--
 drivers/s390/crypto/ap_bus.h                  |  4 +--
 drivers/staging/ks7010/ks_hostif.c            |  2 +-
 drivers/staging/rtl8723bs/core/rtw_security.c |  2 +-
 drivers/staging/wlan-ng/p80211netdev.c        |  2 +-
 drivers/target/iscsi/iscsi_target_auth.c      |  2 +-
 fs/btrfs/ioctl.c                              |  2 +-
 fs/cifs/cifsencrypt.c                         |  2 +-
 fs/cifs/connect.c                             | 10 +++---
 fs/cifs/dfs_cache.c                           |  2 +-
 fs/cifs/misc.c                                |  8 ++---
 fs/crypto/keyring.c                           |  6 ++--
 fs/crypto/keysetup_v1.c                       |  4 +--
 fs/ecryptfs/keystore.c                        |  4 +--
 fs/ecryptfs/messaging.c                       |  2 +-
 include/crypto/aead.h                         |  2 +-
 include/crypto/akcipher.h                     |  2 +-
 include/crypto/gf128mul.h                     |  2 +-
 include/crypto/hash.h                         |  2 +-
 include/crypto/internal/acompress.h           |  2 +-
 include/crypto/kpp.h                          |  2 +-
 include/crypto/skcipher.h                     |  2 +-
 include/linux/slab.h                          |  2 +-
 lib/mpi/mpiutil.c                             |  6 ++--
 lib/test_kasan.c                              |  6 ++--
 mm/slab_common.c                              | 10 +++---
 net/atm/mpoa_caches.c                         |  4 +--
 net/bluetooth/ecdh_helper.c                   |  6 ++--
 net/bluetooth/smp.c                           | 24 ++++++-------
 net/core/sock.c                               |  2 +-
 net/ipv4/tcp_fastopen.c                       |  2 +-
 net/mac80211/aead_api.c                       |  4 +--
 net/mac80211/aes_gmac.c                       |  2 +-
 net/mac80211/key.c                            |  2 +-
 net/mac802154/llsec.c                         | 20 +++++------
 net/sctp/auth.c                               |  2 +-
 net/sctp/socket.c                             |  2 +-
 net/sunrpc/auth_gss/gss_krb5_crypto.c         |  4 +--
 net/sunrpc/auth_gss/gss_krb5_keys.c           |  6 ++--
 net/sunrpc/auth_gss/gss_krb5_mech.c           |  2 +-
 net/tipc/crypto.c                             | 10 +++---
 net/wireless/core.c                           |  2 +-
 net/wireless/ibss.c                           |  4 +--
 net/wireless/lib80211_crypt_tkip.c            |  2 +-
 net/wireless/lib80211_crypt_wep.c             |  2 +-
 net/wireless/nl80211.c                        | 24 ++++++-------
 net/wireless/sme.c                            |  6 ++--
 net/wireless/util.c                           |  2 +-
 net/wireless/wext-sme.c                       |  2 +-
 scripts/coccinelle/free/devm_free.cocci       |  4 +--
 scripts/coccinelle/free/ifnullfree.cocci      |  4 +--
 scripts/coccinelle/free/kfree.cocci           |  6 ++--
 scripts/coccinelle/free/kfreeaddr.cocci       |  2 +-
 security/apparmor/domain.c                    |  4 +--
 security/apparmor/include/file.h              |  2 +-
 security/apparmor/policy.c                    | 24 ++++++-------
 security/apparmor/policy_ns.c                 |  6 ++--
 security/apparmor/policy_unpack.c             | 14 ++++----
 security/keys/big_key.c                       |  6 ++--
 security/keys/dh.c                            | 14 ++++----
 security/keys/encrypted-keys/encrypted.c      | 14 ++++----
 security/keys/trusted-keys/trusted_tpm1.c     | 34 +++++++++----------
 security/keys/user_defined.c                  |  6 ++--
 116 files changed, 323 insertions(+), 323 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index d977643fa627..04caac037b7a 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -249,7 +249,7 @@ static void prng_tdes_deinstantiate(void)
 {
 	pr_debug("The prng module stopped "
 		 "after running in triple DES mode\n");
-	kzfree(prng_data);
+	kfree_sensitive(prng_data);
 }
 
 
@@ -442,7 +442,7 @@ static int __init prng_sha512_instantiate(void)
 static void prng_sha512_deinstantiate(void)
 {
 	pr_debug("The prng module stopped after running in SHA-512 mode\n");
-	kzfree(prng_data);
+	kfree_sensitive(prng_data);
 }
 
 
diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
index fc413717a45f..45e8b775b88e 100644
--- a/arch/x86/power/hibernate.c
+++ b/arch/x86/power/hibernate.c
@@ -98,7 +98,7 @@ static int get_e820_md5(struct e820_table *table, void *buf)
 	if (crypto_shash_digest(desc, (u8 *)table, size, buf))
 		ret = -EINVAL;
 
-	kzfree(desc);
+	kfree_sensitive(desc);
 
 free_tfm:
 	crypto_free_shash(tfm);
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index cf2b9f4103dd..b7824e214961 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -177,7 +177,7 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keyp += NHPOLY1305_KEY_SIZE;
 	WARN_ON(keyp != &data->derived_keys[ARRAY_SIZE(data->derived_keys)]);
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
 
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 68a0f0cb75c4..d9d65d1cc669 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -183,7 +183,7 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = tfm->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
 
@@ -302,7 +302,7 @@ static void ahash_restore_req(struct ahash_request *req, int err)
 	req->priv = NULL;
 
 	/* Free the req->priv.priv from the ADJUSTED request. */
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
 
 static void ahash_notify_einprogress(struct ahash_request *req)
diff --git a/crypto/api.c b/crypto/api.c
index 7d71a9b10e5f..5fa4fac4bd02 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -564,7 +564,7 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	kzfree(mem);
+	kfree_sensitive(mem);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
 
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index cc9dbcecaaca..7553ab18db89 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -376,7 +376,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	}
 
 error:
-	kzfree(desc);
+	kfree_sensitive(desc);
 error_no_desc:
 	crypto_free_shash(tfm);
 	kleave(" = %d", ret);
@@ -447,6 +447,6 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	ret = pefile_digest_pe(pebuf, pelen, &ctx);
 
 error:
-	kzfree(ctx.digest);
+	kfree_sensitive(ctx.digest);
 	return ret;
 }
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 4c0e6c9d942a..b2a46f6dc961 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -163,7 +163,7 @@ static void __deflate_exit(void *ctx)
 static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
 {
 	__deflate_exit(ctx);
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
 
 static void deflate_exit(struct crypto_tfm *tfm)
diff --git a/crypto/drbg.c b/crypto/drbg.c
index b6929eb5f565..2e4b2189636e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1206,19 +1206,19 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
-	kzfree(drbg->Vbuf);
+	kfree_sensitive(drbg->Vbuf);
 	drbg->Vbuf = NULL;
 	drbg->V = NULL;
-	kzfree(drbg->Cbuf);
+	kfree_sensitive(drbg->Cbuf);
 	drbg->Cbuf = NULL;
 	drbg->C = NULL;
-	kzfree(drbg->scratchpadbuf);
+	kfree_sensitive(drbg->scratchpadbuf);
 	drbg->scratchpadbuf = NULL;
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
 	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
-		kzfree(drbg->prev);
+		kfree_sensitive(drbg->prev);
 		drbg->prev = NULL;
 		drbg->fips_primed = false;
 	}
@@ -1685,7 +1685,7 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg)
 	struct sdesc *sdesc = (struct sdesc *)drbg->priv_data;
 	if (sdesc) {
 		crypto_free_shash(sdesc->shash.tfm);
-		kzfree(sdesc);
+		kfree_sensitive(sdesc);
 	}
 	drbg->priv_data = NULL;
 	return 0;
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 02d35be7702b..37540332c1f3 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -67,7 +67,7 @@ static u64 *ecc_alloc_digits_space(unsigned int ndigits)
 
 static void ecc_free_digits_space(u64 *space)
 {
-	kzfree(space);
+	kfree_sensitive(space);
 }
 
 static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
@@ -101,9 +101,9 @@ static void ecc_free_point(struct ecc_point *p)
 	if (!p)
 		return;
 
-	kzfree(p->x);
-	kzfree(p->y);
-	kzfree(p);
+	kfree_sensitive(p->x);
+	kfree_sensitive(p->y);
+	kfree_sensitive(p);
 }
 
 static void vli_clear(u64 *vli, unsigned int ndigits)
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index bd599053a8c4..b0232d6ab4ce 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -124,7 +124,7 @@ static int ecdh_compute_value(struct kpp_request *req)
 
 	/* fall through */
 free_all:
-	kzfree(shared_secret);
+	kfree_sensitive(shared_secret);
 free_pubkey:
 	kfree(public_key);
 	return ret;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 0103d28c541e..5c2fbb08be56 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -139,7 +139,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			       CRYPTO_TFM_REQ_MASK);
 	err = crypto_ahash_setkey(ghash, (u8 *)&data->hash, sizeof(be128));
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
 
diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index a4b1c026aaee..a69ae3e6c16c 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -304,8 +304,8 @@ void gf128mul_free_64k(struct gf128mul_64k *t)
 	int i;
 
 	for (i = 0; i < 16; i++)
-		kzfree(t->t[i]);
-	kzfree(t);
+		kfree_sensitive(t->t[i]);
+	kfree_sensitive(t);
 }
 EXPORT_SYMBOL(gf128mul_free_64k);
 
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index a5ce8f96790f..bc5f969360ae 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -57,7 +57,7 @@ void *jent_zalloc(unsigned int len)
 
 void jent_zfree(void *ptr)
 {
-	kzfree(ptr);
+	kfree_sensitive(ptr);
 }
 
 int jent_fips_enabled(void)
diff --git a/crypto/rng.c b/crypto/rng.c
index 1490d210f1a1..a888d84b524a 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -53,7 +53,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 	crypto_stats_rng_seed(alg, err);
 out:
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_rng_reset);
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index d31031de51bc..6c992eb5c72f 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -199,7 +199,7 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	sg_copy_from_buffer(req->dst,
 			    sg_nents_for_len(req->dst, ctx->key_size),
 			    out_buf, ctx->key_size);
-	kzfree(out_buf);
+	kfree_sensitive(out_buf);
 
 out:
 	req->dst_len = ctx->key_size;
@@ -322,7 +322,7 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 				out_buf + pos, req->dst_len);
 
 done:
-	kzfree(req_ctx->out_buf);
+	kfree_sensitive(req_ctx->out_buf);
 
 	return err;
 }
@@ -500,7 +500,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		   req->dst_len) != 0)
 		err = -EKEYREJECTED;
 done:
-	kzfree(req_ctx->out_buf);
+	kfree_sensitive(req_ctx->out_buf);
 
 	return err;
 }
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index f124b9b54e15..27b2387bc972 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -33,7 +33,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	memcpy(req->iv, subreq->iv, crypto_aead_ivsize(geniv));
 
 out:
-	kzfree(subreq->iv);
+	kfree_sensitive(subreq->iv);
 }
 
 static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
diff --git a/crypto/shash.c b/crypto/shash.c
index c075b26c2a1d..fcd8d8c5408b 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -44,7 +44,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	err = shash->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return err;
 }
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7221def7b9a7..1c4a0d2132c3 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -592,7 +592,7 @@ static int skcipher_setkey_unaligned(struct crypto_skcipher *tfm,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cipher->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6863f911fcee..23c27fc96394 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1744,7 +1744,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	kfree(vec.plaintext);
 	kfree(vec.digest);
 	crypto_free_shash(generic_tfm);
-	kzfree(generic_desc);
+	kfree_sensitive(generic_desc);
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
@@ -3665,7 +3665,7 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-		kzfree(buf);
+		kfree_sensitive(buf);
 		return -ENOMEM;
 	}
 
@@ -3712,7 +3712,7 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 
 outbuf:
 	crypto_free_rng(drng);
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return ret;
 }
 
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 5a3ff258d8f7..1a3309f066f7 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -137,7 +137,7 @@ static void __zstd_exit(void *ctx)
 static void zstd_free_ctx(struct crypto_scomp *tfm, void *ctx)
 {
 	__zstd_exit(ctx);
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
 
 static void zstd_exit(struct crypto_tfm *tfm)
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index a5fd8975f3d3..aa4e8fdc2b32 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -257,7 +257,7 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
 			memcpy(areq->iv, backup_iv, ivsize);
-			kzfree(backup_iv);
+			kfree_sensitive(backup_iv);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 84d52fc3a2da..5246ef4f5430 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -250,7 +250,7 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 			if (rctx->op_dir & SS_DECRYPTION) {
 				memcpy(areq->iv, backup_iv, ivsize);
 				memzero_explicit(backup_iv, ivsize);
-				kzfree(backup_iv);
+				kfree_sensitive(backup_iv);
 			} else {
 				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 							 ivsize, 0);
diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 9819dd50fbad..fd1269900d67 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -254,8 +254,8 @@ static int meson_cipher(struct skcipher_request *areq)
 		}
 	}
 theend:
-	kzfree(bkeyiv);
-	kzfree(backup_iv);
+	kfree_sensitive(bkeyiv);
+	kfree_sensitive(backup_iv);
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index ff02cc05affb..9bd8e5167be3 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -69,7 +69,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 
 	/* fall through */
 free_work_data:
-	kzfree(work_data);
+	kfree_sensitive(work_data);
 	kpp_request_complete(req, status);
 }
 
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 4fcae37a2e33..203bcd66f8b0 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -850,14 +850,14 @@ static int caam_rsa_dec(struct akcipher_request *req)
 
 static void caam_rsa_free_key(struct caam_rsa_key *key)
 {
-	kzfree(key->d);
-	kzfree(key->p);
-	kzfree(key->q);
-	kzfree(key->dp);
-	kzfree(key->dq);
-	kzfree(key->qinv);
-	kzfree(key->tmp1);
-	kzfree(key->tmp2);
+	kfree_sensitive(key->d);
+	kfree_sensitive(key->p);
+	kfree_sensitive(key->q);
+	kfree_sensitive(key->dp);
+	kfree_sensitive(key->dq);
+	kfree_sensitive(key->qinv);
+	kfree_sensitive(key->tmp1);
+	kfree_sensitive(key->tmp2);
 	kfree(key->e);
 	kfree(key->n);
 	memset(key, 0, sizeof(*key));
@@ -1014,17 +1014,17 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	return;
 
 free_dq:
-	kzfree(rsa_key->dq);
+	kfree_sensitive(rsa_key->dq);
 free_dp:
-	kzfree(rsa_key->dp);
+	kfree_sensitive(rsa_key->dp);
 free_tmp2:
-	kzfree(rsa_key->tmp2);
+	kfree_sensitive(rsa_key->tmp2);
 free_tmp1:
-	kzfree(rsa_key->tmp1);
+	kfree_sensitive(rsa_key->tmp1);
 free_q:
-	kzfree(rsa_key->q);
+	kfree_sensitive(rsa_key->q);
 free_p:
-	kzfree(rsa_key->p);
+	kfree_sensitive(rsa_key->p);
 }
 
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 0f72e9abdefe..a15245992cf9 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -74,7 +74,7 @@ static void cleanup_worker_threads(struct cpt_vf *cptvf)
 	for (i = 0; i < cptvf->nr_queues; i++)
 		tasklet_kill(&cwqe_info->vq_wqe[i].twork);
 
-	kzfree(cwqe_info);
+	kfree_sensitive(cwqe_info);
 	cptvf->wqe_info = NULL;
 }
 
@@ -88,7 +88,7 @@ static void free_pending_queues(struct pending_qinfo *pqinfo)
 			continue;
 
 		/* free single queue */
-		kzfree((queue->head));
+		kfree_sensitive((queue->head));
 
 		queue->front = 0;
 		queue->rear = 0;
@@ -189,7 +189,7 @@ static void free_command_queues(struct cpt_vf *cptvf,
 			chunk->head = NULL;
 			chunk->dma_addr = 0;
 			hlist_del(&chunk->nextchunk);
-			kzfree(chunk);
+			kfree_sensitive(chunk);
 		}
 
 		queue->nchunks = 0;
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 7a24019356b5..472dbc2d7c5c 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -305,12 +305,12 @@ static void do_request_cleanup(struct cpt_vf *cptvf,
 		}
 	}
 
-	kzfree(info->scatter_components);
-	kzfree(info->gather_components);
-	kzfree(info->out_buffer);
-	kzfree(info->in_buffer);
-	kzfree((void *)info->completion_addr);
-	kzfree(info);
+	kfree_sensitive(info->scatter_components);
+	kfree_sensitive(info->gather_components);
+	kfree_sensitive(info->out_buffer);
+	kfree_sensitive(info->in_buffer);
+	kfree_sensitive((void *)info->completion_addr);
+	kfree_sensitive(info);
 }
 
 static void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index 5cbc64b851b9..a5cdc2b48bd6 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -90,7 +90,7 @@ static void nitrox_free_aqm_queues(struct nitrox_device *ndev)
 
 	for (i = 0; i < ndev->nr_queues; i++) {
 		nitrox_cmdq_cleanup(ndev->aqmq[i]);
-		kzfree(ndev->aqmq[i]);
+		kfree_sensitive(ndev->aqmq[i]);
 		ndev->aqmq[i] = NULL;
 	}
 }
@@ -122,7 +122,7 @@ static int nitrox_alloc_aqm_queues(struct nitrox_device *ndev)
 
 		err = nitrox_cmdq_init(cmdq, AQM_Q_ALIGN_BYTES);
 		if (err) {
-			kzfree(cmdq);
+			kfree_sensitive(cmdq);
 			goto aqmq_fail;
 		}
 		ndev->aqmq[i] = cmdq;
diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
index 4985bc812b0e..7df71fcebe8f 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.c
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -260,7 +260,7 @@ void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm)
 	ret = zip_ctx_init(zip_ctx, 0);
 
 	if (ret) {
-		kzfree(zip_ctx);
+		kfree_sensitive(zip_ctx);
 		return ERR_PTR(ret);
 	}
 
@@ -279,7 +279,7 @@ void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm)
 	ret = zip_ctx_init(zip_ctx, 1);
 
 	if (ret) {
-		kzfree(zip_ctx);
+		kfree_sensitive(zip_ctx);
 		return ERR_PTR(ret);
 	}
 
@@ -291,7 +291,7 @@ void zip_free_scomp_ctx(struct crypto_scomp *tfm, void *ctx)
 	struct zip_kernel_ctx *zip_ctx = ctx;
 
 	zip_ctx_exit(zip_ctx);
-	kzfree(zip_ctx);
+	kfree_sensitive(zip_ctx);
 }
 
 int zip_scomp_compress(struct crypto_scomp *tfm,
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index 649c91d60401..1223ac70aea2 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -112,13 +112,13 @@ static int ccp_check_key_length(unsigned int len)
 static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
 {
 	/* Clean up old key data */
-	kzfree(ctx->u.rsa.e_buf);
+	kfree_sensitive(ctx->u.rsa.e_buf);
 	ctx->u.rsa.e_buf = NULL;
 	ctx->u.rsa.e_len = 0;
-	kzfree(ctx->u.rsa.n_buf);
+	kfree_sensitive(ctx->u.rsa.n_buf);
 	ctx->u.rsa.n_buf = NULL;
 	ctx->u.rsa.n_len = 0;
-	kzfree(ctx->u.rsa.d_buf);
+	kfree_sensitive(ctx->u.rsa.d_buf);
 	ctx->u.rsa.d_buf = NULL;
 	ctx->u.rsa.d_len = 0;
 }
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 1cf51edbc4b9..35794c7271fb 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -448,7 +448,7 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *authkey,
 		if (dma_mapping_error(dev, key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
-			kzfree(key);
+			kfree_sensitive(key);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -533,7 +533,7 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *authkey,
 	if (key_dma_addr)
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 
-	kzfree(key);
+	kfree_sensitive(key);
 
 	return rc;
 }
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index b2bd093e7013..a5e041d9d2cf 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -488,7 +488,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	if (areq_ctx->gen_ctx.iv_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
-		kzfree(areq_ctx->gen_ctx.iv);
+		kfree_sensitive(areq_ctx->gen_ctx.iv);
 	}
 
 	/* Release pool */
@@ -559,7 +559,7 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
 		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 			hw_iv_size, req->iv);
-		kzfree(areq_ctx->gen_ctx.iv);
+		kfree_sensitive(areq_ctx->gen_ctx.iv);
 		areq_ctx->gen_ctx.iv = NULL;
 		rc = -ENOMEM;
 		goto chain_iv_exit;
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index a84335328f37..f380a4b5e32b 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -229,7 +229,7 @@ static void cc_cipher_exit(struct crypto_tfm *tfm)
 		&ctx_p->user.key_dma_addr);
 
 	/* Free key buffer in context */
-	kzfree(ctx_p->user.key);
+	kfree_sensitive(ctx_p->user.key);
 	dev_dbg(dev, "Free key buffer in context. key=@%p\n", ctx_p->user.key);
 }
 
@@ -828,7 +828,7 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 		/* Not a BACKLOG notification */
 		cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
 		memcpy(req->iv, req_ctx->iv, ivsize);
-		kzfree(req_ctx->iv);
+		kfree_sensitive(req_ctx->iv);
 	}
 
 	skcipher_request_complete(req, err);
@@ -930,7 +930,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 exit_process:
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		kzfree(req_ctx->iv);
+		kfree_sensitive(req_ctx->iv);
 	}
 
 	return rc;
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index d5310783af15..683c9a430e11 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -764,7 +764,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				ctx->key_params.key, keylen);
-			kzfree(ctx->key_params.key);
+			kfree_sensitive(ctx->key_params.key);
 			return -ENOMEM;
 		}
 		dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -913,7 +913,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 	}
 
-	kzfree(ctx->key_params.key);
+	kfree_sensitive(ctx->key_params.key);
 
 	return rc;
 }
@@ -950,7 +950,7 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 			key, keylen);
-		kzfree(ctx->key_params.key);
+		kfree_sensitive(ctx->key_params.key);
 		return -ENOMEM;
 	}
 	dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -999,7 +999,7 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
-	kzfree(ctx->key_params.key);
+	kfree_sensitive(ctx->key_params.key);
 
 	return rc;
 }
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 1d7649ecf44e..33fb27745d52 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -107,7 +107,7 @@ void cc_req_mgr_fini(struct cc_drvdata *drvdata)
 	/* Kill tasklet */
 	tasklet_kill(&req_mgr_h->comptask);
 #endif
-	kzfree(req_mgr_h);
+	kfree_sensitive(req_mgr_h);
 	drvdata->request_mgr_handle = NULL;
 }
 
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index b971284332b6..2fdd3d55ed08 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -1154,7 +1154,7 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
 		}
 
 		/* Set the memory region to 0 to avoid any leak. */
-		kzfree(keydup);
+		kfree_sensitive(keydup);
 
 		if (ret)
 			return ret;
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index a91860b5dc77..ffd33121bb55 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -68,7 +68,7 @@ static void cleanup_worker_threads(struct otx_cptvf *cptvf)
 	for (i = 0; i < cptvf->num_queues; i++)
 		tasklet_kill(&cwqe_info->vq_wqe[i].twork);
 
-	kzfree(cwqe_info);
+	kfree_sensitive(cwqe_info);
 	cptvf->wqe_info = NULL;
 }
 
@@ -82,7 +82,7 @@ static void free_pending_queues(struct otx_cpt_pending_qinfo *pqinfo)
 			continue;
 
 		/* free single queue */
-		kzfree((queue->head));
+		kfree_sensitive((queue->head));
 		queue->front = 0;
 		queue->rear = 0;
 		queue->qlen = 0;
@@ -176,7 +176,7 @@ static void free_command_queues(struct otx_cptvf *cptvf,
 			chunk->head = NULL;
 			chunk->dma_addr = 0;
 			list_del(&chunk->nextchunk);
-			kzfree(chunk);
+			kfree_sensitive(chunk);
 		}
 		queue->num_chunks = 0;
 		queue->idx = 0;
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
index a4c9ff730b13..cfaaf8e2f9c2 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
@@ -215,7 +215,7 @@ static inline void do_request_cleanup(struct pci_dev *pdev,
 						 DMA_BIDIRECTIONAL);
 		}
 	}
-	kzfree(info);
+	kfree_sensitive(info);
 }
 
 struct otx_cptvf_wqe;
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 78d660d963e2..5c71f85da7e2 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1057,7 +1057,7 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	mtk_aes_write_state_be(ctx->key + ctx->keylen, data->hash,
 			       AES_BLOCK_SIZE);
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
 
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index f03c238f5a31..40882d6d52c1 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -746,7 +746,7 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
 
-	kzfree(nx_ctx->kmem);
+	kfree_sensitive(nx_ctx->kmem);
 	nx_ctx->csbcpb = NULL;
 	nx_ctx->csbcpb_aead = NULL;
 	nx_ctx->in_sg = NULL;
@@ -762,7 +762,7 @@ void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm)
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_aead_ctx(tfm);
 
-	kzfree(nx_ctx->kmem);
+	kfree_sensitive(nx_ctx->kmem);
 }
 
 static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index fd045e64972a..bc575d63dee6 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -167,7 +167,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 				num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		kzfree(cipher_key);
+		kfree_sensitive(cipher_key);
 		return err;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
@@ -184,7 +184,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Create session failed status: %u\n",
 			le32_to_cpu(vcrypto->input.status));
-		kzfree(cipher_key);
+		kfree_sensitive(cipher_key);
 		return -EINVAL;
 	}
 
@@ -197,7 +197,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 
 	spin_unlock(&vcrypto->ctrl_lock);
 
-	kzfree(cipher_key);
+	kfree_sensitive(cipher_key);
 	return 0;
 }
 
@@ -466,9 +466,9 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	return 0;
 
 free_iv:
-	kzfree(iv);
+	kfree_sensitive(iv);
 free:
-	kzfree(req_data);
+	kfree_sensitive(req_data);
 	kfree(sgs);
 	return err;
 }
@@ -579,7 +579,7 @@ static void virtio_crypto_skcipher_finalize_req(
 					 AES_BLOCK_SIZE, 0);
 	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
 					   req, err);
-	kzfree(vc_sym_req->iv);
+	kfree_sensitive(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
 }
 
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index c8a962c62663..ba8a19c72391 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -17,7 +17,7 @@ void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 {
 	if (vc_req) {
-		kzfree(vc_req->req_data);
+		kfree_sensitive(vc_req->req_data);
 		kfree(vc_req->sgs);
 	}
 }
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3df90daba89e..2423eade2ae6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -405,7 +405,7 @@ static void crypt_iv_lmk_dtr(struct crypt_config *cc)
 		crypto_free_shash(lmk->hash_tfm);
 	lmk->hash_tfm = NULL;
 
-	kzfree(lmk->seed);
+	kfree_sensitive(lmk->seed);
 	lmk->seed = NULL;
 }
 
@@ -556,9 +556,9 @@ static void crypt_iv_tcw_dtr(struct crypt_config *cc)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 
-	kzfree(tcw->iv_seed);
+	kfree_sensitive(tcw->iv_seed);
 	tcw->iv_seed = NULL;
-	kzfree(tcw->whitening);
+	kfree_sensitive(tcw->whitening);
 	tcw->whitening = NULL;
 
 	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
@@ -992,8 +992,8 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 
 	kunmap_atomic(data);
 out:
-	kzfree(ks);
-	kzfree(es);
+	kfree_sensitive(ks);
+	kfree_sensitive(es);
 	skcipher_request_free(req);
 	return r;
 }
@@ -2247,7 +2247,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	key = request_key(key_string[0] == 'l' ? &key_type_logon : &key_type_user,
 			  key_desc + 1, NULL);
 	if (IS_ERR(key)) {
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 		return PTR_ERR(key);
 	}
 
@@ -2257,14 +2257,14 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!ukp) {
 		up_read(&key->sem);
 		key_put(key);
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 		return -EKEYREVOKED;
 	}
 
 	if (cc->key_size != ukp->datalen) {
 		up_read(&key->sem);
 		key_put(key);
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 		return -EINVAL;
 	}
 
@@ -2280,10 +2280,10 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	if (!ret) {
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
-		kzfree(cc->key_string);
+		kfree_sensitive(cc->key_string);
 		cc->key_string = new_key_string;
 	} else
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 
 	return ret;
 }
@@ -2344,7 +2344,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
 	/* wipe references to any kernel keyring key */
-	kzfree(cc->key_string);
+	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 
 	/* Decode key from its hex representation. */
@@ -2376,7 +2376,7 @@ static int crypt_wipe_key(struct crypt_config *cc)
 			return r;
 	}
 
-	kzfree(cc->key_string);
+	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 	r = crypt_setkey(cc);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
@@ -2455,15 +2455,15 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	kzfree(cc->cipher_string);
-	kzfree(cc->key_string);
-	kzfree(cc->cipher_auth);
-	kzfree(cc->authenc_key);
+	kfree_sensitive(cc->cipher_string);
+	kfree_sensitive(cc->key_string);
+	kfree_sensitive(cc->cipher_auth);
+	kfree_sensitive(cc->authenc_key);
 
 	mutex_destroy(&cc->bio_alloc_lock);
 
 	/* Must zero key material before freeing */
-	kzfree(cc);
+	kfree_sensitive(cc);
 
 	spin_lock(&dm_crypt_clients_lock);
 	WARN_ON(!dm_crypt_clients_n);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4094c47eca7f..d08ef3c0d148 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3409,8 +3409,8 @@ static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_int
 
 static void free_alg(struct alg_spec *a)
 {
-	kzfree(a->alg_string);
-	kzfree(a->key);
+	kfree_sensitive(a->alg_string);
+	kfree_sensitive(a->key);
 	memset(a, 0, sizeof *a);
 }
 
@@ -4341,7 +4341,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		for (i = 0; i < ic->journal_sections; i++) {
 			struct skcipher_request *req = ic->sk_requests[i];
 			if (req) {
-				kzfree(req->iv);
+				kfree_sensitive(req->iv);
 				skcipher_request_free(req);
 			}
 		}
diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index 2ed23c99f59f..beda69075a97 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -286,7 +286,7 @@ static void *alloc_dma_buffer(struct vio_dev *vdev, size_t size,
 
 	if (dma_mapping_error(&vdev->dev, *dma_handle)) {
 		*dma_handle = 0;
-		kzfree(buffer);
+		kfree_sensitive(buffer);
 		return NULL;
 	}
 
@@ -310,7 +310,7 @@ static void free_dma_buffer(struct vio_dev *vdev, size_t size, void *vaddr,
 	dma_unmap_single(&vdev->dev, dma_handle, size, DMA_BIDIRECTIONAL);
 
 	/* deallocate memory */
-	kzfree(vaddr);
+	kfree_sensitive(vaddr);
 }
 
 /**
@@ -883,7 +883,7 @@ static int ibmvmc_close(struct inode *inode, struct file *file)
 		spin_unlock_irqrestore(&hmc->lock, flags);
 	}
 
-	kzfree(session);
+	kfree_sensitive(session);
 
 	return rc;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 7f24fcb4f96a..965ada2e9d24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -132,7 +132,7 @@ static void hclge_free_vector_ring_chain(struct hnae3_ring_chain_node *head)
 
 	while (chain) {
 		chain_tmp = chain->next;
-		kzfree(chain);
+		kfree_sensitive(chain);
 		chain = chain_tmp;
 	}
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 113f6087c7c9..e567f4ab8a79 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -960,9 +960,9 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	return 0;
 
 err_aead:
-	kzfree(xs->aead);
+	kfree_sensitive(xs->aead);
 err_xs:
-	kzfree(xs);
+	kfree_sensitive(xs);
 err_out:
 	msgbuf[1] = err;
 	return err;
@@ -1047,7 +1047,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	ixgbe_ipsec_del_sa(xs);
 
 	/* remove the xs that was made-up in the add request */
-	kzfree(xs);
+	kfree_sensitive(xs);
 
 	return 0;
 }
diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index de3b57d09d0c..208f6e24f37c 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -222,7 +222,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 	kfree(state->sha1_digest);
 	if (state->sha1) {
 		crypto_free_shash(state->sha1->tfm);
-		kzfree(state->sha1);
+		kfree_sensitive(state->sha1);
 	}
 	kfree(state);
 out:
@@ -238,8 +238,8 @@ static void mppe_free(void *arg)
 	if (state) {
 		kfree(state->sha1_digest);
 		crypto_free_shash(state->sha1->tfm);
-		kzfree(state->sha1);
-		kzfree(state);
+		kfree_sensitive(state->sha1);
+		kfree_sensitive(state);
 	}
 }
 
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 708dc61c974f..596eb3be2d9e 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -113,7 +113,7 @@ static struct noise_keypair *keypair_create(struct wg_peer *peer)
 
 static void keypair_free_rcu(struct rcu_head *rcu)
 {
-	kzfree(container_of(rcu, struct noise_keypair, rcu));
+	kfree_sensitive(container_of(rcu, struct noise_keypair, rcu));
 }
 
 static void keypair_free_kref(struct kref *kref)
@@ -825,7 +825,7 @@ bool wg_noise_handshake_begin_session(struct noise_handshake *handshake,
 			handshake->entry.peer->device->index_hashtable,
 			&handshake->entry, &new_keypair->entry);
 	} else {
-		kzfree(new_keypair);
+		kfree_sensitive(new_keypair);
 	}
 	rcu_read_unlock_bh();
 
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index 1d634bd3038f..b3b6370e6b95 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -203,7 +203,7 @@ static void rcu_release(struct rcu_head *rcu)
 	/* The final zeroing takes care of clearing any remaining handshake key
 	 * material and other potentially sensitive information.
 	 */
-	kzfree(peer);
+	kfree_sensitive(peer);
 }
 
 static void kref_release(struct kref *refcount)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8c29071cb415..82b449c249a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1369,7 +1369,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 					   &rxcb, rxq->id);
 
 		if (reclaim) {
-			kzfree(txq->entries[cmd_index].free_buf);
+			kfree_sensitive(txq->entries[cmd_index].free_buf);
 			txq->entries[cmd_index].free_buf = NULL;
 		}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 86fc00167817..022f7a069295 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1024,7 +1024,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
 	out_meta->flags = cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
-		kzfree(txq->entries[idx].free_buf);
+		kfree_sensitive(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
@@ -1254,8 +1254,8 @@ static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
 	/* De-alloc array of command/tx buffers */
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < txq->n_window; i++) {
-			kzfree(txq->entries[i].cmd);
-			kzfree(txq->entries[i].free_buf);
+			kfree_sensitive(txq->entries[i].cmd);
+			kfree_sensitive(txq->entries[i].free_buf);
 		}
 	del_timer_sync(&txq->stuck_timer);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 4582d418ba4d..aa8277df2f17 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -724,8 +724,8 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	/* De-alloc array of command/tx buffers */
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < txq->n_window; i++) {
-			kzfree(txq->entries[i].cmd);
-			kzfree(txq->entries[i].free_buf);
+			kfree_sensitive(txq->entries[i].cmd);
+			kfree_sensitive(txq->entries[i].free_buf);
 		}
 
 	/* De-alloc circular buffer of TFDs */
@@ -1768,7 +1768,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
 	out_meta->flags = cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
-		kzfree(txq->entries[idx].free_buf);
+		kfree_sensitive(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
diff --git a/drivers/net/wireless/intersil/orinoco/wext.c b/drivers/net/wireless/intersil/orinoco/wext.c
index 1d4dae422106..7b6c4ae8ddb3 100644
--- a/drivers/net/wireless/intersil/orinoco/wext.c
+++ b/drivers/net/wireless/intersil/orinoco/wext.c
@@ -31,8 +31,8 @@ static int orinoco_set_key(struct orinoco_private *priv, int index,
 			   enum orinoco_alg alg, const u8 *key, int key_len,
 			   const u8 *seq, int seq_len)
 {
-	kzfree(priv->keys[index].key);
-	kzfree(priv->keys[index].seq);
+	kfree_sensitive(priv->keys[index].key);
+	kfree_sensitive(priv->keys[index].seq);
 
 	if (key_len) {
 		priv->keys[index].key = kzalloc(key_len, GFP_ATOMIC);
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 8e8e37b6c0ee..99125e29b2c6 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -219,8 +219,8 @@ static inline void ap_init_message(struct ap_message *ap_msg)
  */
 static inline void ap_release_message(struct ap_message *ap_msg)
 {
-	kzfree(ap_msg->message);
-	kzfree(ap_msg->private);
+	kfree_sensitive(ap_msg->message);
+	kfree_sensitive(ap_msg->private);
 }
 
 #define for_each_ap_card(_ac) \
diff --git a/drivers/staging/ks7010/ks_hostif.c b/drivers/staging/ks7010/ks_hostif.c
index 2666f9e30c15..d70b671b06aa 100644
--- a/drivers/staging/ks7010/ks_hostif.c
+++ b/drivers/staging/ks7010/ks_hostif.c
@@ -246,7 +246,7 @@ michael_mic(u8 *key, u8 *data, unsigned int len, u8 priority, u8 *result)
 	ret = crypto_shash_finup(desc, data + 12, len - 12, result);
 
 err_free_desc:
-	kzfree(desc);
+	kfree_sensitive(desc);
 
 err_free_tfm:
 	crypto_free_shash(tfm);
diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index 5ebf691bd743..9d7eb027a213 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -2251,7 +2251,7 @@ static void gf_mulx(u8 *pad)
 
 static void aes_encrypt_deinit(void *ctx)
 {
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
 
 
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index b809c0015c0c..7b091c5a2984 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -429,7 +429,7 @@ static netdev_tx_t p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 failed:
 	/* Free up the WEP buffer if it's not the same as the skb */
 	if ((p80211_wep.data) && (p80211_wep.data != skb->data))
-		kzfree(p80211_wep.data);
+		kfree_sensitive(p80211_wep.data);
 
 	/* we always free the skb here, never in a lower level. */
 	if (!result)
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 0e54627d9aa8..62d912b79c61 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -484,7 +484,7 @@ static int chap_server_compute_hash(
 	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
 	auth_ret = 0;
 out:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	if (tfm)
 		crypto_free_shash(tfm);
 	kfree(initiatorchg);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 40b729dce91c..eab3f8510426 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2691,7 +2691,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 	btrfs_put_root(root);
 out_free:
 	btrfs_free_path(path);
-	kzfree(subvol_info);
+	kfree_sensitive(subvol_info);
 	return ret;
 }
 
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 97b7497c13ef..c6baca36b74c 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -797,7 +797,7 @@ calc_seckey(struct cifs_ses *ses)
 	ses->auth_key.len = CIFS_SESS_KEY_SIZE;
 
 	memzero_explicit(sec_key, CIFS_SESS_KEY_SIZE);
-	kzfree(ctx_arc4);
+	kfree_sensitive(ctx_arc4);
 	return 0;
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 95b3ab0ca8c0..cdeac9d66e26 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2177,7 +2177,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			tmp_end++;
 			if (!(tmp_end < end && tmp_end[1] == delim)) {
 				/* No it is not. Set the password to NULL */
-				kzfree(vol->password);
+				kfree_sensitive(vol->password);
 				vol->password = NULL;
 				break;
 			}
@@ -2215,7 +2215,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 					options = end;
 			}
 
-			kzfree(vol->password);
+			kfree_sensitive(vol->password);
 			/* Now build new password string */
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
@@ -3200,7 +3200,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = -ENOMEM;
 			kfree(vol->username);
 			vol->username = NULL;
-			kzfree(vol->password);
+			kfree_sensitive(vol->password);
 			vol->password = NULL;
 			goto out_key_put;
 		}
@@ -4212,7 +4212,7 @@ void
 cifs_cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
 	kfree(volume_info->username);
-	kzfree(volume_info->password);
+	kfree_sensitive(volume_info->password);
 	kfree(volume_info->UNC);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
@@ -5337,7 +5337,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 
 out:
 	kfree(vol_info->username);
-	kzfree(vol_info->password);
+	kfree_sensitive(vol_info->password);
 	kfree(vol_info);
 
 	return tcon;
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index a67f88bf7ae1..a0223b47dc1b 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1131,7 +1131,7 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
 err_free_unc:
 	kfree(new->UNC);
 err_free_password:
-	kzfree(new->password);
+	kfree_sensitive(new->password);
 err_free_username:
 	kfree(new->username);
 	kfree(new);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a456febd4109..503810e9cb76 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -100,12 +100,12 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
-	kzfree(buf_to_free->password);
+	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->user_name);
 	kfree(buf_to_free->domainName);
-	kzfree(buf_to_free->auth_key.response);
+	kfree_sensitive(buf_to_free->auth_key.response);
 	kfree(buf_to_free->iface_list);
-	kzfree(buf_to_free);
+	kfree_sensitive(buf_to_free);
 }
 
 struct cifs_tcon *
@@ -145,7 +145,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
 	}
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
-	kzfree(buf_to_free->password);
+	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->crfid.fid);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	kfree(buf_to_free->dfs_path);
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index ab41b25d4fa1..41460c6331e4 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -49,7 +49,7 @@ static void free_master_key(struct fscrypt_master_key *mk)
 	}
 
 	key_put(mk->mk_users);
-	kzfree(mk);
+	kfree_sensitive(mk);
 }
 
 static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
@@ -491,7 +491,7 @@ static int fscrypt_provisioning_key_preparse(struct key_preparsed_payload *prep)
 static void fscrypt_provisioning_key_free_preparse(
 					struct key_preparsed_payload *prep)
 {
-	kzfree(prep->payload.data[0]);
+	kfree_sensitive(prep->payload.data[0]);
 }
 
 static void fscrypt_provisioning_key_describe(const struct key *key,
@@ -508,7 +508,7 @@ static void fscrypt_provisioning_key_describe(const struct key *key,
 
 static void fscrypt_provisioning_key_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
 
 static struct key_type key_type_fscrypt_provisioning = {
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 801b48c0cd7f..c8a930f8faf2 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -155,7 +155,7 @@ static void free_direct_key(struct fscrypt_direct_key *dk)
 {
 	if (dk) {
 		crypto_free_skcipher(dk->dk_ctfm);
-		kzfree(dk);
+		kfree_sensitive(dk);
 	}
 }
 
@@ -285,7 +285,7 @@ static int setup_v1_file_key_derived(struct fscrypt_info *ci,
 
 	err = fscrypt_set_per_file_enc_key(ci, derived_key);
 out:
-	kzfree(derived_key);
+	kfree_sensitive(derived_key);
 	return err;
 }
 
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index af3eb02bbca1..f6a17d259db7 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -838,7 +838,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 out_release_free_unlock:
 	crypto_free_shash(s->hash_tfm);
 out_free_unlock:
-	kzfree(s->block_aligned_filename);
+	kfree_sensitive(s->block_aligned_filename);
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
@@ -847,7 +847,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		key_put(auth_tok_key);
 	}
 	skcipher_request_free(s->skcipher_req);
-	kzfree(s->hash_desc);
+	kfree_sensitive(s->hash_desc);
 	kfree(s);
 	return rc;
 }
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 8646ba76def3..c0dfd9647627 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -175,7 +175,7 @@ int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon)
 	}
 	hlist_del(&daemon->euid_chain);
 	mutex_unlock(&daemon->mux);
-	kzfree(daemon);
+	kfree_sensitive(daemon);
 out:
 	return rc;
 }
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 62c68550aab6..c32a6f5664e9 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -425,7 +425,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
  */
 static inline void aead_request_free(struct aead_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 /**
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 6924b091adec..1d3aa252caba 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -207,7 +207,7 @@ static inline struct akcipher_request *akcipher_request_alloc(
  */
 static inline void akcipher_request_free(struct akcipher_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 /**
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index fa0a63d298dc..81330c6446f6 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -230,7 +230,7 @@ void gf128mul_4k_bbe(be128 *a, const struct gf128mul_4k *t);
 void gf128mul_x8_ble(le128 *r, const le128 *x);
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
-	kzfree(t);
+	kfree_sensitive(t);
 }
 
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index cee446c59497..cef16b7d153e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -606,7 +606,7 @@ static inline struct ahash_request *ahash_request_alloc(
  */
 static inline void ahash_request_free(struct ahash_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 static inline void ahash_request_zero(struct ahash_request *req)
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index cf478681b53e..cfc47e18820f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -46,7 +46,7 @@ static inline struct acomp_req *__acomp_request_alloc(struct crypto_acomp *tfm)
 
 static inline void __acomp_request_free(struct acomp_req *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 /**
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index cd9a9b500624..88b591215d5c 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -187,7 +187,7 @@ static inline struct kpp_request *kpp_request_alloc(struct crypto_kpp *tfm,
  */
 static inline void kpp_request_free(struct kpp_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 /**
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 141e7690f9c3..1013c9cbae69 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -508,7 +508,7 @@ static inline struct skcipher_request *skcipher_request_alloc(
  */
 static inline void skcipher_request_free(struct skcipher_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
 
 static inline void skcipher_request_zero(struct skcipher_request *req)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 6d454886bcaf..7f2018943997 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -186,7 +186,7 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
  */
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
-void kzfree(const void *);
+void kfree_sensitive(const void *);
 size_t __ksize(const void *);
 size_t ksize(const void *);
 
diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index 20ed0f766787..4cd2b335cb7f 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -69,7 +69,7 @@ void mpi_free_limb_space(mpi_ptr_t a)
 	if (!a)
 		return;
 
-	kzfree(a);
+	kfree_sensitive(a);
 }
 
 void mpi_assign_limb_space(MPI a, mpi_ptr_t ap, unsigned nlimbs)
@@ -95,7 +95,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
-		kzfree(a->d);
+		kfree_sensitive(a->d);
 		a->d = p;
 	} else {
 		a->d = kcalloc(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
@@ -112,7 +112,7 @@ void mpi_free(MPI a)
 		return;
 
 	if (a->flags & 4)
-		kzfree(a->d);
+		kfree_sensitive(a->d);
 	else
 		mpi_free_limb_space(a->d);
 
diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index e3087d90e00d..a1c82aa68a33 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -757,15 +757,15 @@ static noinline void __init kmalloc_double_kzfree(void)
 	char *ptr;
 	size_t size = 16;
 
-	pr_info("double-free (kzfree)\n");
+	pr_info("double-free (kfree_sensitive)\n");
 	ptr = kmalloc(size, GFP_KERNEL);
 	if (!ptr) {
 		pr_err("Allocation failed\n");
 		return;
 	}
 
-	kzfree(ptr);
-	kzfree(ptr);
+	kfree_sensitive(ptr);
+	kfree_sensitive(ptr);
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 23c7500eea7d..c08bc7eb20bd 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1707,17 +1707,17 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
 EXPORT_SYMBOL(krealloc);
 
 /**
- * kzfree - like kfree but zero memory
+ * kfree_sensitive - Clear sensitive information in memory before freeing
  * @p: object to free memory of
  *
  * The memory of the object @p points to is zeroed before freed.
- * If @p is %NULL, kzfree() does nothing.
+ * If @p is %NULL, kfree_sensitive() does nothing.
  *
  * Note: this function zeroes the whole allocated buffer which can be a good
  * deal bigger than the requested buffer size passed to kmalloc(). So be
  * careful when using this function in performance sensitive code.
  */
-void kzfree(const void *p)
+void kfree_sensitive(const void *p)
 {
 	size_t ks;
 	void *mem = (void *)p;
@@ -1725,10 +1725,10 @@ void kzfree(const void *p)
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
 	ks = ksize(mem);
-	memset(mem, 0, ks);
+	memzero_explicit(mem, ks);
 	kfree(mem);
 }
-EXPORT_SYMBOL(kzfree);
+EXPORT_SYMBOL(kfree_sensitive);
 
 /**
  * ksize - get the actual amount of memory allocated for a given object
diff --git a/net/atm/mpoa_caches.c b/net/atm/mpoa_caches.c
index 3286f9d527d3..f7a2f0e41105 100644
--- a/net/atm/mpoa_caches.c
+++ b/net/atm/mpoa_caches.c
@@ -180,7 +180,7 @@ static int cache_hit(in_cache_entry *entry, struct mpoa_client *mpc)
 static void in_cache_put(in_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		kzfree(entry);
+		kfree_sensitive(entry);
 	}
 }
 
@@ -415,7 +415,7 @@ static eg_cache_entry *eg_cache_get_by_src_ip(__be32 ipaddr,
 static void eg_cache_put(eg_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		kzfree(entry);
+		kfree_sensitive(entry);
 	}
 }
 
diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 2155ce802877..3226fe02e875 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -104,7 +104,7 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 free_all:
 	kpp_request_free(req);
 free_tmp:
-	kzfree(tmp);
+	kfree_sensitive(tmp);
 	return err;
 }
 
@@ -151,9 +151,9 @@ int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
 	err = crypto_kpp_set_secret(tfm, buf, buf_len);
 	/* fall through */
 free_all:
-	kzfree(buf);
+	kfree_sensitive(buf);
 free_tmp:
-	kzfree(tmp);
+	kfree_sensitive(tmp);
 	return err;
 }
 
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 1476a91ce935..445ec3d09b01 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -753,9 +753,9 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 	complete = test_bit(SMP_FLAG_COMPLETE, &smp->flags);
 	mgmt_smp_complete(hcon, complete);
 
-	kzfree(smp->csrk);
-	kzfree(smp->slave_csrk);
-	kzfree(smp->link_key);
+	kfree_sensitive(smp->csrk);
+	kfree_sensitive(smp->slave_csrk);
+	kfree_sensitive(smp->link_key);
 
 	crypto_free_shash(smp->tfm_cmac);
 	crypto_free_kpp(smp->tfm_ecdh);
@@ -789,7 +789,7 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 	}
 
 	chan->data = NULL;
-	kzfree(smp);
+	kfree_sensitive(smp);
 	hci_conn_drop(hcon);
 }
 
@@ -1149,7 +1149,7 @@ static void sc_generate_link_key(struct smp_chan *smp)
 		const u8 salt[16] = { 0x31, 0x70, 0x6d, 0x74 };
 
 		if (smp_h7(smp->tfm_cmac, smp->tk, salt, smp->link_key)) {
-			kzfree(smp->link_key);
+			kfree_sensitive(smp->link_key);
 			smp->link_key = NULL;
 			return;
 		}
@@ -1158,14 +1158,14 @@ static void sc_generate_link_key(struct smp_chan *smp)
 		const u8 tmp1[4] = { 0x31, 0x70, 0x6d, 0x74 };
 
 		if (smp_h6(smp->tfm_cmac, smp->tk, tmp1, smp->link_key)) {
-			kzfree(smp->link_key);
+			kfree_sensitive(smp->link_key);
 			smp->link_key = NULL;
 			return;
 		}
 	}
 
 	if (smp_h6(smp->tfm_cmac, smp->link_key, lebr, smp->link_key)) {
-		kzfree(smp->link_key);
+		kfree_sensitive(smp->link_key);
 		smp->link_key = NULL;
 		return;
 	}
@@ -1400,7 +1400,7 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 free_shash:
 	crypto_free_shash(smp->tfm_cmac);
 zfree_smp:
-	kzfree(smp);
+	kfree_sensitive(smp);
 	return NULL;
 }
 
@@ -3263,7 +3263,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 	tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
 	if (IS_ERR(tfm_cmac)) {
 		BT_ERR("Unable to create CMAC crypto context");
-		kzfree(smp);
+		kfree_sensitive(smp);
 		return ERR_CAST(tfm_cmac);
 	}
 
@@ -3271,7 +3271,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
-		kzfree(smp);
+		kfree_sensitive(smp);
 		return ERR_CAST(tfm_ecdh);
 	}
 
@@ -3285,7 +3285,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 		if (smp) {
 			crypto_free_shash(smp->tfm_cmac);
 			crypto_free_kpp(smp->tfm_ecdh);
-			kzfree(smp);
+			kfree_sensitive(smp);
 		}
 		return ERR_PTR(-ENOMEM);
 	}
@@ -3332,7 +3332,7 @@ static void smp_del_chan(struct l2cap_chan *chan)
 		chan->data = NULL;
 		crypto_free_shash(smp->tfm_cmac);
 		crypto_free_kpp(smp->tfm_ecdh);
-		kzfree(smp);
+		kfree_sensitive(smp);
 	}
 
 	l2cap_chan_put(chan);
diff --git a/net/core/sock.c b/net/core/sock.c
index ce1d8dce9b7a..e20a672afee5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2182,7 +2182,7 @@ static inline void __sock_kfree_s(struct sock *sk, void *mem, int size,
 	if (WARN_ON_ONCE(!mem))
 		return;
 	if (nullify)
-		kzfree(mem);
+		kfree_sensitive(mem);
 	else
 		kfree(mem);
 	atomic_sub(size, &sk->sk_omem_alloc);
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 19ad9586c720..c1a54f3d58f5 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -38,7 +38,7 @@ static void tcp_fastopen_ctx_free(struct rcu_head *head)
 	struct tcp_fastopen_context *ctx =
 	    container_of(head, struct tcp_fastopen_context, rcu);
 
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
 
 void tcp_fastopen_destroy_cipher(struct sock *sk)
diff --git a/net/mac80211/aead_api.c b/net/mac80211/aead_api.c
index c5fe95e49c68..d7b3d905d535 100644
--- a/net/mac80211/aead_api.c
+++ b/net/mac80211/aead_api.c
@@ -41,7 +41,7 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	aead_request_set_ad(aead_req, sg[0].length);
 
 	crypto_aead_encrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
 
 	return 0;
 }
@@ -76,7 +76,7 @@ int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	aead_request_set_ad(aead_req, sg[0].length);
 
 	err = crypto_aead_decrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
 
 	return err;
 }
diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
index 16ba09cb5def..6f3b3a0cc10a 100644
--- a/net/mac80211/aes_gmac.c
+++ b/net/mac80211/aes_gmac.c
@@ -60,7 +60,7 @@ int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
 	aead_request_set_ad(aead_req, GMAC_AAD_LEN + data_len);
 
 	crypto_aead_encrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
 
 	return 0;
 }
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 8f403c1bb908..6bb765721862 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -732,7 +732,7 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
 		break;
 	}
-	kzfree(key);
+	kfree_sensitive(key);
 }
 
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index c079ee69d3d0..585d33144c33 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -49,7 +49,7 @@ void mac802154_llsec_destroy(struct mac802154_llsec *sec)
 
 		msl = container_of(sl, struct mac802154_llsec_seclevel, level);
 		list_del(&sl->list);
-		kzfree(msl);
+		kfree_sensitive(msl);
 	}
 
 	list_for_each_entry_safe(dev, dn, &sec->table.devices, list) {
@@ -66,7 +66,7 @@ void mac802154_llsec_destroy(struct mac802154_llsec *sec)
 		mkey = container_of(key->key, struct mac802154_llsec_key, key);
 		list_del(&key->list);
 		llsec_key_put(mkey);
-		kzfree(key);
+		kfree_sensitive(key);
 	}
 }
 
@@ -155,7 +155,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 		if (key->tfm[i])
 			crypto_free_aead(key->tfm[i]);
 
-	kzfree(key);
+	kfree_sensitive(key);
 	return NULL;
 }
 
@@ -170,7 +170,7 @@ static void llsec_key_release(struct kref *ref)
 		crypto_free_aead(key->tfm[i]);
 
 	crypto_free_sync_skcipher(key->tfm0);
-	kzfree(key);
+	kfree_sensitive(key);
 }
 
 static struct mac802154_llsec_key*
@@ -261,7 +261,7 @@ int mac802154_llsec_key_add(struct mac802154_llsec *sec,
 	return 0;
 
 fail:
-	kzfree(new);
+	kfree_sensitive(new);
 	return -ENOMEM;
 }
 
@@ -341,10 +341,10 @@ static void llsec_dev_free(struct mac802154_llsec_device *dev)
 				      devkey);
 
 		list_del(&pos->list);
-		kzfree(devkey);
+		kfree_sensitive(devkey);
 	}
 
-	kzfree(dev);
+	kfree_sensitive(dev);
 }
 
 int mac802154_llsec_dev_add(struct mac802154_llsec *sec,
@@ -682,7 +682,7 @@ llsec_do_encrypt_auth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 
 	rc = crypto_aead_encrypt(req);
 
-	kzfree(req);
+	kfree_sensitive(req);
 
 	return rc;
 }
@@ -886,7 +886,7 @@ llsec_do_decrypt_auth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 
 	rc = crypto_aead_decrypt(req);
 
-	kzfree(req);
+	kfree_sensitive(req);
 	skb_trim(skb, skb->len - authlen);
 
 	return rc;
@@ -926,7 +926,7 @@ llsec_update_devkey_record(struct mac802154_llsec_device *dev,
 		if (!devkey)
 			list_add_rcu(&next->devkey.list, &dev->dev.keys);
 		else
-			kzfree(next);
+			kfree_sensitive(next);
 
 		spin_unlock_bh(&dev->lock);
 	}
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 4278764d82b8..3a22e1747712 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -49,7 +49,7 @@ void sctp_auth_key_put(struct sctp_auth_bytes *key)
 		return;
 
 	if (refcount_dec_and_test(&key->refcnt)) {
-		kzfree(key);
+		kfree_sensitive(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
 }
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 827a9903ee28..3392d18a7e44 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3748,7 +3748,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
+	kfree_sensitive(authkey);
 	return ret;
 }
 
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index 6f2d30d7b766..19bb244d2444 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -1003,7 +1003,7 @@ krb5_rc4_setup_seq_key(struct krb5_ctx *kctx,
 	err = 0;
 
 out_err:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	crypto_free_shash(hmac);
 	dprintk("%s: returning %d\n", __func__, err);
 	return err;
@@ -1079,7 +1079,7 @@ krb5_rc4_setup_enc_key(struct krb5_ctx *kctx,
 	err = 0;
 
 out_err:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	crypto_free_shash(hmac);
 	dprintk("%s: returning %d\n", __func__, err);
 	return err;
diff --git a/net/sunrpc/auth_gss/gss_krb5_keys.c b/net/sunrpc/auth_gss/gss_krb5_keys.c
index 3b7f721c023b..726c076950c0 100644
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c
+++ b/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -228,11 +228,11 @@ u32 krb5_derive_key(const struct gss_krb5_enctype *gk5e,
 	ret = 0;
 
 err_free_raw:
-	kzfree(rawkey);
+	kfree_sensitive(rawkey);
 err_free_out:
-	kzfree(outblockdata);
+	kfree_sensitive(outblockdata);
 err_free_in:
-	kzfree(inblockdata);
+	kfree_sensitive(inblockdata);
 err_free_cipher:
 	crypto_free_sync_skcipher(cipher);
 err_return:
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 75b3c2e9e8f8..a84a5b289484 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -443,7 +443,7 @@ context_derive_keys_rc4(struct krb5_ctx *ctx)
 	desc->tfm = hmac;
 
 	err = crypto_shash_digest(desc, sigkeyconstant, slen, ctx->cksum);
-	kzfree(desc);
+	kfree_sensitive(desc);
 	if (err)
 		goto out_err_free_hmac;
 	/*
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c8c47fc72653..001bcb0f2480 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -441,7 +441,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	/* Allocate per-cpu TFM entry pointer */
 	tmp->tfm_entry = alloc_percpu(struct tipc_tfm *);
 	if (!tmp->tfm_entry) {
-		kzfree(tmp);
+		kfree_sensitive(tmp);
 		return -ENOMEM;
 	}
 
@@ -491,7 +491,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	/* Not any TFM is allocated? */
 	if (!tfm_cnt) {
 		free_percpu(tmp->tfm_entry);
-		kzfree(tmp);
+		kfree_sensitive(tmp);
 		return err;
 	}
 
@@ -545,7 +545,7 @@ static int tipc_aead_clone(struct tipc_aead **dst, struct tipc_aead *src)
 
 	aead->tfm_entry = alloc_percpu_gfp(struct tipc_tfm *, GFP_ATOMIC);
 	if (unlikely(!aead->tfm_entry)) {
-		kzfree(aead);
+		kfree_sensitive(aead);
 		return -ENOMEM;
 	}
 
@@ -1352,7 +1352,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	/* Allocate statistic structure */
 	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
-		kzfree(c);
+		kfree_sensitive(c);
 		return -ENOMEM;
 	}
 
@@ -1408,7 +1408,7 @@ void tipc_crypto_stop(struct tipc_crypto **crypto)
 	free_percpu(c->stats);
 
 	*crypto = NULL;
-	kzfree(c);
+	kfree_sensitive(c);
 }
 
 void tipc_crypto_timeout(struct tipc_crypto *rx)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 341402b4f178..cd2c982c5317 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1107,7 +1107,7 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 	}
 
 #ifdef CONFIG_CFG80211_WEXT
-	kzfree(wdev->wext.keys);
+	kfree_sensitive(wdev->wext.keys);
 	wdev->wext.keys = NULL;
 #endif
 	/* only initialized if we have a netdev */
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index ae8fe66a9bb8..a0621bb76d8e 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -127,7 +127,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	if (WARN_ON(wdev->connect_keys))
-		kzfree(wdev->connect_keys);
+		kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
 
 	wdev->ibss_fixed = params->channel_fixed;
@@ -161,7 +161,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
 	rdev_set_qos_map(rdev, dev, NULL);
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index f5e842ba7673..1b4d6c87a5c5 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -131,7 +131,7 @@ static void lib80211_tkip_deinit(void *priv)
 		crypto_free_shash(_priv->tx_tfm_michael);
 		crypto_free_shash(_priv->rx_tfm_michael);
 	}
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
 
 static inline u16 RotR1(u16 val)
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index dafc6f3571db..6ab9957b8f96 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -56,7 +56,7 @@ static void *lib80211_wep_init(int keyidx)
 
 static void lib80211_wep_deinit(void *priv)
 {
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
 
 /* Add WEP IV/key info to a frame that has at least 4 bytes of headroom */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5fa402144cda..c1b37c798907 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9783,7 +9783,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 
 		if ((ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT) &&
 		    no_ht) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 	}
@@ -9795,7 +9795,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		int r = validate_pae_over_nl80211(rdev, info);
 
 		if (r < 0) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return r;
 		}
 
@@ -9808,7 +9808,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 	else if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
 	wdev_unlock(dev->ieee80211_ptr);
@@ -10228,7 +10228,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.ht_capa,
@@ -10246,7 +10246,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.vht_capa,
@@ -10260,7 +10260,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       (rdev->wiphy.features & NL80211_FEATURE_QUIET)) &&
 		    !wiphy_ext_feature_isset(&rdev->wiphy,
 					     NL80211_EXT_FEATURE_RRM)) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		connect.flags |= ASSOC_REQ_USE_RRM;
@@ -10268,21 +10268,21 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	connect.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
 	if (connect.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ]) {
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 		return -EOPNOTSUPP;
 	}
 
 	if (info->attrs[NL80211_ATTR_BSS_SELECT]) {
 		/* bss selection makes no sense if bssid is set */
 		if (connect.bssid) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 
 		err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
 				       wiphy, &connect.bss_select);
 		if (err) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return err;
 		}
 	}
@@ -10312,13 +10312,13 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
 		   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] ||
 		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 		return -EINVAL;
 	}
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT])) {
 		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			GENL_SET_ERR_MSG(info,
 					 "external auth requires connection ownership");
 			return -EINVAL;
@@ -10331,7 +10331,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_connect(rdev, dev, &connect, connkeys,
 			       connect.prev_bssid);
 	if (err)
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 
 	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
 		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ac3e60aa1fc8..8e60d5a6236c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -741,7 +741,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 	}
 
 	if (cr->status != WLAN_STATUS_SUCCESS) {
-		kzfree(wdev->connect_keys);
+		kfree_sensitive(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
 		wdev->conn_owner_nlportid = 0;
@@ -1096,7 +1096,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
 	wdev->conn_owner_nlportid = 0;
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
@@ -1276,7 +1276,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
 	wdev->conn_owner_nlportid = 0;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6590efbbcbb9..ea172bc244c2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -853,7 +853,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 		}
 	}
 
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 }
 
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 73fd0eae08ca..73df23570d43 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -57,7 +57,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	err = cfg80211_connect(rdev, wdev->netdev,
 			       &wdev->wext.connect, ck, prev_bssid);
 	if (err)
-		kzfree(ck);
+		kfree_sensitive(ck);
 
 	return err;
 }
diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
index 3357bf4dbd7c..da80050b91ff 100644
--- a/scripts/coccinelle/free/devm_free.cocci
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -89,7 +89,7 @@ position p;
 (
  kfree@p(x)
 |
- kzfree@p(x)
+ kfree_sensitive@p(x)
 |
  krealloc@p(x, ...)
 |
@@ -112,7 +112,7 @@ position p != safe.p;
 (
 * kfree@p(x)
 |
-* kzfree@p(x)
+* kfree_sensitive@p(x)
 |
 * krealloc@p(x, ...)
 |
diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
index b3290c4ee239..2045391e36a0 100644
--- a/scripts/coccinelle/free/ifnullfree.cocci
+++ b/scripts/coccinelle/free/ifnullfree.cocci
@@ -21,7 +21,7 @@ expression E;
 (
   kfree(E);
 |
-  kzfree(E);
+  kfree_sensitive(E);
 |
   debugfs_remove(E);
 |
@@ -42,7 +42,7 @@ position p;
 @@
 
 * if (E != NULL)
-*	\(kfree@p\|kzfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|
+*	\(kfree@p\|kfree_sensitive@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|
 *         usb_free_urb@p\|kmem_cache_destroy@p\|mempool_destroy@p\|
 *         dma_pool_destroy@p\)(E);
 
diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
index e9d50e718e46..168568386034 100644
--- a/scripts/coccinelle/free/kfree.cocci
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -24,7 +24,7 @@ position p1;
 (
 * kfree@p1(E)
 |
-* kzfree@p1(E)
+* kfree_sensitive@p1(E)
 )
 
 @print expression@
@@ -68,7 +68,7 @@ while (1) { ...
 (
 * kfree@ok(E)
 |
-* kzfree@ok(E)
+* kfree_sensitive@ok(E)
 )
   ... when != break;
       when != goto l;
@@ -86,7 +86,7 @@ position free.p1!=loop.ok,p2!={print.p,sz.p};
 (
 * kfree@p1(E,...)
 |
-* kzfree@p1(E,...)
+* kfree_sensitive@p1(E,...)
 )
 ...
 (
diff --git a/scripts/coccinelle/free/kfreeaddr.cocci b/scripts/coccinelle/free/kfreeaddr.cocci
index cfaf308328d8..142af6337a04 100644
--- a/scripts/coccinelle/free/kfreeaddr.cocci
+++ b/scripts/coccinelle/free/kfreeaddr.cocci
@@ -20,7 +20,7 @@ position p;
 (
 * kfree@p(&e->f)
 |
-* kzfree@p(&e->f)
+* kfree_sensitive@p(&e->f)
 )
 
 @script:python depends on org@
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 6ceb74e0f789..9e9d4411b96e 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -40,8 +40,8 @@ void aa_free_domain_entries(struct aa_domain *domain)
 			return;
 
 		for (i = 0; i < domain->size; i++)
-			kzfree(domain->table[i]);
-		kzfree(domain->table);
+			kfree_sensitive(domain->table[i]);
+		kfree_sensitive(domain->table);
 		domain->table = NULL;
 	}
 }
diff --git a/security/apparmor/include/file.h b/security/apparmor/include/file.h
index aff26fc71407..d4f8948517d9 100644
--- a/security/apparmor/include/file.h
+++ b/security/apparmor/include/file.h
@@ -72,7 +72,7 @@ static inline void aa_free_file_ctx(struct aa_file_ctx *ctx)
 {
 	if (ctx) {
 		aa_put_label(rcu_access_pointer(ctx->label));
-		kzfree(ctx);
+		kfree_sensitive(ctx);
 	}
 }
 
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 269f2f53c0b1..4ab00ab060f1 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -187,9 +187,9 @@ static void aa_free_data(void *ptr, void *arg)
 {
 	struct aa_data *data = ptr;
 
-	kzfree(data->data);
-	kzfree(data->key);
-	kzfree(data);
+	kfree_sensitive(data->data);
+	kfree_sensitive(data->key);
+	kfree_sensitive(data);
 }
 
 /**
@@ -217,19 +217,19 @@ void aa_free_profile(struct aa_profile *profile)
 	aa_put_profile(rcu_access_pointer(profile->parent));
 
 	aa_put_ns(profile->ns);
-	kzfree(profile->rename);
+	kfree_sensitive(profile->rename);
 
 	aa_free_file_rules(&profile->file);
 	aa_free_cap_rules(&profile->caps);
 	aa_free_rlimit_rules(&profile->rlimits);
 
 	for (i = 0; i < profile->xattr_count; i++)
-		kzfree(profile->xattrs[i]);
-	kzfree(profile->xattrs);
+		kfree_sensitive(profile->xattrs[i]);
+	kfree_sensitive(profile->xattrs);
 	for (i = 0; i < profile->secmark_count; i++)
-		kzfree(profile->secmark[i].label);
-	kzfree(profile->secmark);
-	kzfree(profile->dirname);
+		kfree_sensitive(profile->secmark[i].label);
+	kfree_sensitive(profile->secmark);
+	kfree_sensitive(profile->dirname);
 	aa_put_dfa(profile->xmatch);
 	aa_put_dfa(profile->policy.dfa);
 
@@ -237,13 +237,13 @@ void aa_free_profile(struct aa_profile *profile)
 		rht = profile->data;
 		profile->data = NULL;
 		rhashtable_free_and_destroy(rht, aa_free_data, NULL);
-		kzfree(rht);
+		kfree_sensitive(rht);
 	}
 
-	kzfree(profile->hash);
+	kfree_sensitive(profile->hash);
 	aa_put_loaddata(profile->rawdata);
 
-	kzfree(profile);
+	kfree_sensitive(profile);
 }
 
 /**
diff --git a/security/apparmor/policy_ns.c b/security/apparmor/policy_ns.c
index d7ef540027a5..70921d95fb40 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -121,9 +121,9 @@ static struct aa_ns *alloc_ns(const char *prefix, const char *name)
 	return ns;
 
 fail_unconfined:
-	kzfree(ns->base.hname);
+	kfree_sensitive(ns->base.hname);
 fail_ns:
-	kzfree(ns);
+	kfree_sensitive(ns);
 	return NULL;
 }
 
@@ -145,7 +145,7 @@ void aa_free_ns(struct aa_ns *ns)
 
 	ns->unconfined->ns = NULL;
 	aa_free_profile(ns->unconfined);
-	kzfree(ns);
+	kfree_sensitive(ns);
 }
 
 /**
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 2d743c004bc4..5cfbdc6ad106 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -163,10 +163,10 @@ static void do_loaddata_free(struct work_struct *work)
 		aa_put_ns(ns);
 	}
 
-	kzfree(d->hash);
-	kzfree(d->name);
+	kfree_sensitive(d->hash);
+	kfree_sensitive(d->name);
 	kvfree(d->data);
-	kzfree(d);
+	kfree_sensitive(d);
 }
 
 void aa_loaddata_kref(struct kref *kref)
@@ -890,7 +890,7 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 		while (unpack_strdup(e, &key, NULL)) {
 			data = kzalloc(sizeof(*data), GFP_KERNEL);
 			if (!data) {
-				kzfree(key);
+				kfree_sensitive(key);
 				goto fail;
 			}
 
@@ -898,8 +898,8 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 			data->size = unpack_blob(e, &data->data, NULL);
 			data->data = kvmemdup(data->data, data->size);
 			if (data->size && !data->data) {
-				kzfree(data->key);
-				kzfree(data);
+				kfree_sensitive(data->key);
+				kfree_sensitive(data);
 				goto fail;
 			}
 
@@ -1033,7 +1033,7 @@ void aa_load_ent_free(struct aa_load_ent *ent)
 		aa_put_profile(ent->old);
 		aa_put_profile(ent->new);
 		kfree(ent->ns_name);
-		kzfree(ent);
+		kfree_sensitive(ent);
 	}
 }
 
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 82008f900930..a50094ee405a 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -281,7 +281,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
 err_fput:
 	fput(file);
 err_enckey:
-	kzfree(enckey);
+	kfree_sensitive(enckey);
 error:
 	big_key_free_buffer(buf);
 	return ret;
@@ -297,7 +297,7 @@ void big_key_free_preparse(struct key_preparsed_payload *prep)
 
 		path_put(path);
 	}
-	kzfree(prep->payload.data[big_key_data]);
+	kfree_sensitive(prep->payload.data[big_key_data]);
 }
 
 /*
@@ -329,7 +329,7 @@ void big_key_destroy(struct key *key)
 		path->mnt = NULL;
 		path->dentry = NULL;
 	}
-	kzfree(key->payload.data[big_key_data]);
+	kfree_sensitive(key->payload.data[big_key_data]);
 	key->payload.data[big_key_data] = NULL;
 }
 
diff --git a/security/keys/dh.c b/security/keys/dh.c
index c4c629bb1c03..1abfa70ed6e1 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -58,9 +58,9 @@ static ssize_t dh_data_from_key(key_serial_t keyid, void **data)
 
 static void dh_free_data(struct dh *dh)
 {
-	kzfree(dh->key);
-	kzfree(dh->p);
-	kzfree(dh->g);
+	kfree_sensitive(dh->key);
+	kfree_sensitive(dh->p);
+	kfree_sensitive(dh->g);
 }
 
 struct dh_completion {
@@ -126,7 +126,7 @@ static void kdf_dealloc(struct kdf_sdesc *sdesc)
 	if (sdesc->shash.tfm)
 		crypto_free_shash(sdesc->shash.tfm);
 
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 }
 
 /*
@@ -220,7 +220,7 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 		ret = -EFAULT;
 
 err:
-	kzfree(outbuf);
+	kfree_sensitive(outbuf);
 	return ret;
 }
 
@@ -395,11 +395,11 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 out6:
 	kpp_request_free(req);
 out5:
-	kzfree(outbuf);
+	kfree_sensitive(outbuf);
 out4:
 	crypto_free_kpp(tfm);
 out3:
-	kzfree(secret);
+	kfree_sensitive(secret);
 out2:
 	dh_free_data(&dh_inputs);
 out1:
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index f6797ba44bf7..4b4c1d8c1494 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -382,7 +382,7 @@ static int get_derived_key(u8 *derived_key, enum derived_key_type key_type,
 	memcpy(derived_buf + strlen(derived_buf) + 1, master_key,
 	       master_keylen);
 	ret = calc_hash(hash_tfm, derived_key, derived_buf, derived_buf_len);
-	kzfree(derived_buf);
+	kfree_sensitive(derived_buf);
 	return ret;
 }
 
@@ -824,13 +824,13 @@ static int encrypted_instantiate(struct key *key,
 	ret = encrypted_init(epayload, key->description, format, master_desc,
 			     decrypted_datalen, hex_encoded_iv);
 	if (ret < 0) {
-		kzfree(epayload);
+		kfree_sensitive(epayload);
 		goto out;
 	}
 
 	rcu_assign_keypointer(key, epayload);
 out:
-	kzfree(datablob);
+	kfree_sensitive(datablob);
 	return ret;
 }
 
@@ -839,7 +839,7 @@ static void encrypted_rcu_free(struct rcu_head *rcu)
 	struct encrypted_key_payload *epayload;
 
 	epayload = container_of(rcu, struct encrypted_key_payload, rcu);
-	kzfree(epayload);
+	kfree_sensitive(epayload);
 }
 
 /*
@@ -897,7 +897,7 @@ static int encrypted_update(struct key *key, struct key_preparsed_payload *prep)
 	rcu_assign_keypointer(key, new_epayload);
 	call_rcu(&epayload->rcu, encrypted_rcu_free);
 out:
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return ret;
 }
 
@@ -958,7 +958,7 @@ static long encrypted_read(const struct key *key, char *buffer,
 	memzero_explicit(derived_key, sizeof(derived_key));
 
 	memcpy(buffer, ascii_buf, asciiblob_len);
-	kzfree(ascii_buf);
+	kfree_sensitive(ascii_buf);
 
 	return asciiblob_len;
 out:
@@ -973,7 +973,7 @@ static long encrypted_read(const struct key *key, char *buffer,
  */
 static void encrypted_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
 
 struct key_type key_type_encrypted = {
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 8001ab07e63b..b9fe02e5f84f 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -68,7 +68,7 @@ static int TSS_sha1(const unsigned char *data, unsigned int datalen,
 	}
 
 	ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 
@@ -112,7 +112,7 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 	if (!ret)
 		ret = crypto_shash_final(&sdesc->shash, digest);
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 
@@ -166,7 +166,7 @@ int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 				  paramdigest, TPM_NONCE_SIZE, h1,
 				  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(TSS_authhmac);
@@ -251,7 +251,7 @@ int TSS_checkhmac1(unsigned char *buffer,
 	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(TSS_checkhmac1);
@@ -353,7 +353,7 @@ static int TSS_checkhmac2(unsigned char *buffer,
 	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 
@@ -563,7 +563,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		*bloblen = storedsize;
 	}
 out:
-	kzfree(td);
+	kfree_sensitive(td);
 	return ret;
 }
 
@@ -1031,12 +1031,12 @@ static int trusted_instantiate(struct key *key,
 	if (!ret && options->pcrlock)
 		ret = pcrlock(options->pcrlock);
 out:
-	kzfree(datablob);
-	kzfree(options);
+	kfree_sensitive(datablob);
+	kfree_sensitive(options);
 	if (!ret)
 		rcu_assign_keypointer(key, payload);
 	else
-		kzfree(payload);
+		kfree_sensitive(payload);
 	return ret;
 }
 
@@ -1045,7 +1045,7 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 	struct trusted_key_payload *p;
 
 	p = container_of(rcu, struct trusted_key_payload, rcu);
-	kzfree(p);
+	kfree_sensitive(p);
 }
 
 /*
@@ -1087,13 +1087,13 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = datablob_parse(datablob, new_p, new_o);
 	if (ret != Opt_update) {
 		ret = -EINVAL;
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
 
 	if (!new_o->keyhandle) {
 		ret = -EINVAL;
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
 
@@ -1107,22 +1107,22 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = key_seal(new_p, new_o);
 	if (ret < 0) {
 		pr_info("trusted_key: key_seal failed (%d)\n", ret);
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
 	if (new_o->pcrlock) {
 		ret = pcrlock(new_o->pcrlock);
 		if (ret < 0) {
 			pr_info("trusted_key: pcrlock failed (%d)\n", ret);
-			kzfree(new_p);
+			kfree_sensitive(new_p);
 			goto out;
 		}
 	}
 	rcu_assign_keypointer(key, new_p);
 	call_rcu(&p->rcu, trusted_rcu_free);
 out:
-	kzfree(datablob);
-	kzfree(new_o);
+	kfree_sensitive(datablob);
+	kfree_sensitive(new_o);
 	return ret;
 }
 
@@ -1154,7 +1154,7 @@ static long trusted_read(const struct key *key, char *buffer,
  */
 static void trusted_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
 
 struct key_type key_type_trusted = {
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 07d4287e9084..749e2a4dcb13 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -82,7 +82,7 @@ EXPORT_SYMBOL_GPL(user_preparse);
  */
 void user_free_preparse(struct key_preparsed_payload *prep)
 {
-	kzfree(prep->payload.data[0]);
+	kfree_sensitive(prep->payload.data[0]);
 }
 EXPORT_SYMBOL_GPL(user_free_preparse);
 
@@ -91,7 +91,7 @@ static void user_free_payload_rcu(struct rcu_head *head)
 	struct user_key_payload *payload;
 
 	payload = container_of(head, struct user_key_payload, rcu);
-	kzfree(payload);
+	kfree_sensitive(payload);
 }
 
 /*
@@ -147,7 +147,7 @@ void user_destroy(struct key *key)
 {
 	struct user_key_payload *upayload = key->payload.data[0];
 
-	kzfree(upayload);
+	kfree_sensitive(upayload);
 }
 
 EXPORT_SYMBOL_GPL(user_destroy);
-- 
2.18.1

