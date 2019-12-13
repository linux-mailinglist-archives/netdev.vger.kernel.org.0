Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB3C11EC4A
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLMU44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:56:56 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:48953 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMU4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:56:55 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M7sUE-1iatty0MiI-004zAm; Fri, 13 Dec 2019 21:56:24 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Simo Sorce <simo@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Bruce Fields <bfields@redhat.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 15/24] sunrpc: convert to time64_t for expiry
Date:   Fri, 13 Dec 2019 21:53:43 +0100
Message-Id: <20191213205417.3871055-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:RkDeIaFu6tTIaveO+DHQKcjxBAB7BEHoQZvY2uFHzWjSYL9X+Lx
 mzQe0jVYOkFmWsPcEWpDftiypK700MdwLlAC5qHAnYw/dM8edUwm+Nvgn59UcxvmMnrXtFC
 BPjnhGYXWorgsajgWORN1DsJp0bCmKmgUk+4B9lqB2Oa400G0AdEjnGetqrNtA3X2c/Cz7w
 3gqATfZJ2wxJUqTZA0O+w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4xIoJv151vc=:EjO59GyBCVMiLbjrWvBAmc
 P1ThtoYjwjePIQ0tzE2plQ54sqhA06sclv6rfW73/e9ZxajyIfvD/CHxMkAk18L5s/8S73GWJ
 HcUYGis6cW7xAPt4vqT0YQNqiJtTBelhYL+NTpNEWuHoRStoRYLypFpJPNXAgXavnYJs0IdPy
 gkgBNDpKsgmL+yBUayrRWobfKhdHffP0LNysiTtzOzx5JmrX57hIdqH2nlHtWOLC/gc+gWNeX
 RU8BWuFrqw+6hELw1Y0jBvNohB6zZTXX+1/twtli6t/poGfEtrI8mhA4YWlvlmya1kjgW3Qo/
 QUGuxQhEEAXcy/D0YmAFM/PxMcM8BAVrvo0MpW8Jo6cB7uSK6GvFZH2hUygcSyjyza09meChQ
 soXDRXWvgjif8CbzDUbZQs9axsgAWoYJy3Q7rLpg7h3qO0nXv3G4LOCrxoxQNS8Z8XXScjb1r
 WUdsIvx7vxmSVyNHQxmHduqCUQ5HTVeUvcegoH1RzkKUlVf4pCEMXxuvsWAcvtnYXmfGgZXoH
 mSVCWIL7x/jAcuDb3fvxpFZZCJh6nWN+2gsN8s0U1l/8vGWF4f3TiAaMVWIPUjFdUSRPtNtsu
 SNhhqwYQwrDxhpOlX5IFrw9IzhZUwS9j3JTVBTHavWtOhjtkTO/7J1v75RP7RlAKE9AOpMANX
 e56lfM1GrecgvziKOwlVbqwNaoCWfd5JAvrl36ceFDGXH1AKLvU/ipR1Kob+jY6hdufwmpC2y
 985ESbrWyeFUJjkGeEKqiPvobI9ubS6kiA1MUpbHU/dLa0VjQ9euq0eC8WB4qIJVCRVLq7tA1
 EN23CSxDp4saTvTzf363IrwVNRFY77HnmVA8qE5f8aUk5H3dq8rPF25okrsT/vdZ/wuyQwDsz
 NPGrVjQVZ3VWo6XU9RHg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using signed 32-bit types for UTC time leads to the y2038 overflow,
which is what happens in the sunrpc code at the moment.

This changes the sunrpc code over to use time64_t where possible.
The one exception is the gss_import_v{1,2}_context() function for
kerberos5, which uses 32-bit timestamps in the protocol. Here,
we can at least treat the numbers as 'unsigned', which extends the
range from 2038 to 2106.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/sunrpc/gss_api.h        |  4 ++--
 include/linux/sunrpc/gss_krb5.h       |  2 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c   | 12 +++++++++---
 net/sunrpc/auth_gss/gss_krb5_seal.c   |  8 ++++----
 net/sunrpc/auth_gss/gss_krb5_unseal.c |  6 +++---
 net/sunrpc/auth_gss/gss_krb5_wrap.c   | 16 ++++++++--------
 net/sunrpc/auth_gss/gss_mech_switch.c |  2 +-
 net/sunrpc/auth_gss/svcauth_gss.c     |  4 ++--
 8 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/sunrpc/gss_api.h b/include/linux/sunrpc/gss_api.h
index bd691e08be3b..1cc6cefb1220 100644
--- a/include/linux/sunrpc/gss_api.h
+++ b/include/linux/sunrpc/gss_api.h
@@ -48,7 +48,7 @@ int gss_import_sec_context(
 		size_t			bufsize,
 		struct gss_api_mech	*mech,
 		struct gss_ctx		**ctx_id,
-		time_t			*endtime,
+		time64_t		*endtime,
 		gfp_t			gfp_mask);
 u32 gss_get_mic(
 		struct gss_ctx		*ctx_id,
@@ -108,7 +108,7 @@ struct gss_api_ops {
 			const void		*input_token,
 			size_t			bufsize,
 			struct gss_ctx		*ctx_id,
-			time_t			*endtime,
+			time64_t		*endtime,
 			gfp_t			gfp_mask);
 	u32 (*gss_get_mic)(
 			struct gss_ctx		*ctx_id,
diff --git a/include/linux/sunrpc/gss_krb5.h b/include/linux/sunrpc/gss_krb5.h
index 02c0412e368c..c1d77dd8ed41 100644
--- a/include/linux/sunrpc/gss_krb5.h
+++ b/include/linux/sunrpc/gss_krb5.h
@@ -106,9 +106,9 @@ struct krb5_ctx {
 	struct crypto_sync_skcipher *initiator_enc_aux;
 	u8			Ksess[GSS_KRB5_MAX_KEYLEN]; /* session key */
 	u8			cksum[GSS_KRB5_MAX_KEYLEN];
-	s32			endtime;
 	atomic_t		seq_send;
 	atomic64_t		seq_send64;
+	time64_t		endtime;
 	struct xdr_netobj	mech_used;
 	u8			initiator_sign[GSS_KRB5_MAX_KEYLEN];
 	u8			acceptor_sign[GSS_KRB5_MAX_KEYLEN];
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 6e5d6d240215..75b3c2e9e8f8 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -253,6 +253,7 @@ gss_import_v1_context(const void *p, const void *end, struct krb5_ctx *ctx)
 {
 	u32 seq_send;
 	int tmp;
+	u32 time32;
 
 	p = simple_get_bytes(p, end, &ctx->initiate, sizeof(ctx->initiate));
 	if (IS_ERR(p))
@@ -290,9 +291,11 @@ gss_import_v1_context(const void *p, const void *end, struct krb5_ctx *ctx)
 		p = ERR_PTR(-ENOSYS);
 		goto out_err;
 	}
-	p = simple_get_bytes(p, end, &ctx->endtime, sizeof(ctx->endtime));
+	p = simple_get_bytes(p, end, &time32, sizeof(time32));
 	if (IS_ERR(p))
 		goto out_err;
+	/* unsigned 32-bit time overflows in year 2106 */
+	ctx->endtime = (time64_t)time32;
 	p = simple_get_bytes(p, end, &seq_send, sizeof(seq_send));
 	if (IS_ERR(p))
 		goto out_err;
@@ -587,15 +590,18 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 {
 	u64 seq_send64;
 	int keylen;
+	u32 time32;
 
 	p = simple_get_bytes(p, end, &ctx->flags, sizeof(ctx->flags));
 	if (IS_ERR(p))
 		goto out_err;
 	ctx->initiate = ctx->flags & KRB5_CTX_FLAG_INITIATOR;
 
-	p = simple_get_bytes(p, end, &ctx->endtime, sizeof(ctx->endtime));
+	p = simple_get_bytes(p, end, &time32, sizeof(time32));
 	if (IS_ERR(p))
 		goto out_err;
+	/* unsigned 32-bit time overflows in year 2106 */
+	ctx->endtime = (time64_t)time32;
 	p = simple_get_bytes(p, end, &seq_send64, sizeof(seq_send64));
 	if (IS_ERR(p))
 		goto out_err;
@@ -659,7 +665,7 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 static int
 gss_import_sec_context_kerberos(const void *p, size_t len,
 				struct gss_ctx *ctx_id,
-				time_t *endtime,
+				time64_t *endtime,
 				gfp_t gfp_mask)
 {
 	const void *end = (const void *)((const char *)p + len);
diff --git a/net/sunrpc/auth_gss/gss_krb5_seal.c b/net/sunrpc/auth_gss/gss_krb5_seal.c
index 48fe4a591b54..f1d280accf43 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seal.c
@@ -131,14 +131,14 @@ gss_get_mic_v1(struct krb5_ctx *ctx, struct xdr_buf *text,
 	struct xdr_netobj	md5cksum = {.len = sizeof(cksumdata),
 					    .data = cksumdata};
 	void			*ptr;
-	s32			now;
+	time64_t		now;
 	u32			seq_send;
 	u8			*cksumkey;
 
 	dprintk("RPC:       %s\n", __func__);
 	BUG_ON(ctx == NULL);
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	ptr = setup_token(ctx, token);
 
@@ -170,7 +170,7 @@ gss_get_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *text,
 	struct xdr_netobj cksumobj = { .len = sizeof(cksumdata),
 				       .data = cksumdata};
 	void *krb5_hdr;
-	s32 now;
+	time64_t now;
 	u8 *cksumkey;
 	unsigned int cksum_usage;
 	__be64 seq_send_be64;
@@ -198,7 +198,7 @@ gss_get_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *text,
 
 	memcpy(krb5_hdr + GSS_KRB5_TOK_HDR_LEN, cksumobj.data, cksumobj.len);
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	return (ctx->endtime < now) ? GSS_S_CONTEXT_EXPIRED : GSS_S_COMPLETE;
 }
diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
index ef2b25b86d2f..aaab91cf24c8 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -124,7 +124,7 @@ gss_verify_mic_v1(struct krb5_ctx *ctx,
 
 	/* it got through unscathed.  Make sure the context is unexpired */
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	if (now > ctx->endtime)
 		return GSS_S_CONTEXT_EXPIRED;
@@ -149,7 +149,7 @@ gss_verify_mic_v2(struct krb5_ctx *ctx,
 	char cksumdata[GSS_KRB5_MAX_CKSUM_LEN];
 	struct xdr_netobj cksumobj = {.len = sizeof(cksumdata),
 				      .data = cksumdata};
-	s32 now;
+	time64_t now;
 	u8 *ptr = read_token->data;
 	u8 *cksumkey;
 	u8 flags;
@@ -194,7 +194,7 @@ gss_verify_mic_v2(struct krb5_ctx *ctx,
 		return GSS_S_BAD_SIG;
 
 	/* it got through unscathed.  Make sure the context is unexpired */
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	if (now > ctx->endtime)
 		return GSS_S_CONTEXT_EXPIRED;
 
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 14a0aff0cd84..6c1920eed771 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -163,7 +163,7 @@ gss_wrap_kerberos_v1(struct krb5_ctx *kctx, int offset,
 					    .data = cksumdata};
 	int			blocksize = 0, plainlen;
 	unsigned char		*ptr, *msg_start;
-	s32			now;
+	time64_t		now;
 	int			headlen;
 	struct page		**tmp_pages;
 	u32			seq_send;
@@ -172,7 +172,7 @@ gss_wrap_kerberos_v1(struct krb5_ctx *kctx, int offset,
 
 	dprintk("RPC:       %s\n", __func__);
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	blocksize = crypto_sync_skcipher_blocksize(kctx->enc);
 	gss_krb5_add_padding(buf, offset, blocksize);
@@ -268,7 +268,7 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, struct xdr_buf *buf)
 	char			cksumdata[GSS_KRB5_MAX_CKSUM_LEN];
 	struct xdr_netobj	md5cksum = {.len = sizeof(cksumdata),
 					    .data = cksumdata};
-	s32			now;
+	time64_t		now;
 	int			direction;
 	s32			seqnum;
 	unsigned char		*ptr;
@@ -359,7 +359,7 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, struct xdr_buf *buf)
 
 	/* it got through unscathed.  Make sure the context is unexpired */
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 
 	if (now > kctx->endtime)
 		return GSS_S_CONTEXT_EXPIRED;
@@ -439,7 +439,7 @@ gss_wrap_kerberos_v2(struct krb5_ctx *kctx, u32 offset,
 		     struct xdr_buf *buf, struct page **pages)
 {
 	u8		*ptr, *plainhdr;
-	s32		now;
+	time64_t	now;
 	u8		flags = 0x00;
 	__be16		*be16ptr;
 	__be64		*be64ptr;
@@ -481,14 +481,14 @@ gss_wrap_kerberos_v2(struct krb5_ctx *kctx, u32 offset,
 	if (err)
 		return err;
 
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	return (kctx->endtime < now) ? GSS_S_CONTEXT_EXPIRED : GSS_S_COMPLETE;
 }
 
 static u32
 gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, struct xdr_buf *buf)
 {
-	s32		now;
+	time64_t	now;
 	u8		*ptr;
 	u8		flags = 0x00;
 	u16		ec, rrc;
@@ -557,7 +557,7 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, struct xdr_buf *buf)
 	/* do sequencing checks */
 
 	/* it got through unscathed.  Make sure the context is unexpired */
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	if (now > kctx->endtime)
 		return GSS_S_CONTEXT_EXPIRED;
 
diff --git a/net/sunrpc/auth_gss/gss_mech_switch.c b/net/sunrpc/auth_gss/gss_mech_switch.c
index 30b7de6f3d76..d3685d4ed9e0 100644
--- a/net/sunrpc/auth_gss/gss_mech_switch.c
+++ b/net/sunrpc/auth_gss/gss_mech_switch.c
@@ -376,7 +376,7 @@ int
 gss_import_sec_context(const void *input_token, size_t bufsize,
 		       struct gss_api_mech	*mech,
 		       struct gss_ctx		**ctx_id,
-		       time_t			*endtime,
+		       time64_t			*endtime,
 		       gfp_t gfp_mask)
 {
 	if (!(*ctx_id = kzalloc(sizeof(**ctx_id), gfp_mask)))
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index c62d1f10978b..0c3e22838ddf 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -436,7 +436,7 @@ static int rsc_parse(struct cache_detail *cd,
 	int id;
 	int len, rv;
 	struct rsc rsci, *rscp = NULL;
-	time_t expiry;
+	time64_t expiry;
 	int status = -EINVAL;
 	struct gss_api_mech *gm = NULL;
 
@@ -1221,7 +1221,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 	static atomic64_t ctxhctr;
 	long long ctxh;
 	struct gss_api_mech *gm = NULL;
-	time_t expiry;
+	time64_t expiry;
 	int status = -EINVAL;
 
 	memset(&rsci, 0, sizeof(rsci));
-- 
2.20.0

