Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A938A670E5B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjARAE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjARADv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:03:51 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D28C8102E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673997416; x=1705533416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4IOTjtpaEwEazVvo8n33Vc60Qzz+ZcH+3g29neag+24=;
  b=srZwcBsO/6jiBD4NYn1zXcWFwPRbZeSV0TXRgc+/+l6+9cjlqOkbkFG4
   guz+IhPFOX68oFfE1ch+/6XKEcksVDt6yJ4W4x1qtOfu/xZP0FhYkbxv4
   R8iTorlNWQdxCFhImpQMcDXGOibrnKMyiyoqsihm0Wc7X8Yysar+wXlG0
   E=;
X-IronPort-AV: E=Sophos;i="5.97,224,1669075200"; 
   d="scan'208";a="283790387"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 23:16:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 996BE60ABA;
        Tue, 17 Jan 2023 23:16:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 17 Jan 2023 23:16:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 17 Jan 2023 23:16:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <sd@queasysnail.net>
CC:     <fkrenzel@redhat.com>, <netdev@vger.kernel.org>,
        <kuniyu@amazon.com>, <apoorvko@amazon.com>
Subject: Re: [PATCH net-next 3/5] tls: implement rekey for TLS1.3
Date:   Tue, 17 Jan 2023 15:16:33 -0800
Message-ID: <20230117231633.21410-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <34e782b6d4f2e611ac8ba380bcf7ca56c40fc52f.1673952268.git.sd@queasysnail.net>
References: <34e782b6d4f2e611ac8ba380bcf7ca56c40fc52f.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for posting this series!
We were working on the same feature.
CC Apoorv from s2n team.

From:   Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 17 Jan 2023 14:45:29 +0100
> This adds the possibility to change the key and IV when using
> TLS1.3. Changing the cipher or TLS version is not supported.
> 
> Once we have updated the RX key, we can unblock the receive side.
> 
> This change only affects tls_sw, since 1.3 offload isn't supported.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Tested-by: Frantisek Krenzelok <fkrenzel@redhat.com>
> ---
>  net/tls/tls.h        |   3 +-
>  net/tls/tls_device.c |   2 +-
>  net/tls/tls_main.c   |  32 ++++++++++--
>  net/tls/tls_sw.c     | 120 ++++++++++++++++++++++++++++++++-----------
>  4 files changed, 120 insertions(+), 37 deletions(-)
> 
> diff --git a/net/tls/tls.h b/net/tls/tls.h
> index 34d0fe814600..6f9c85eaa9c5 100644
> --- a/net/tls/tls.h
> +++ b/net/tls/tls.h
> @@ -90,7 +90,8 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
>  		  unsigned int optlen);
>  void tls_err_abort(struct sock *sk, int err);
>  
> -int tls_set_sw_offload(struct sock *sk, int tx);
> +int tls_set_sw_offload(struct sock *sk, int tx,
> +		       struct tls_crypto_info *new_crypto_info);
>  void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
>  void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
>  void tls_sw_strparser_done(struct tls_context *tls_ctx);
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index c149f36b42ee..1ad50c253dfe 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1291,7 +1291,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
>  	context->resync_nh_reset = 1;
>  
>  	ctx->priv_ctx_rx = context;
> -	rc = tls_set_sw_offload(sk, 0);
> +	rc = tls_set_sw_offload(sk, 0, NULL);
>  	if (rc)
>  		goto release_ctx;
>  
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index fb1da1780f50..9be82aecd13e 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -669,9 +669,12 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
>  static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>  				  unsigned int optlen, int tx)
>  {
> +	union tls_crypto_context tmp = {};
> +	struct tls_crypto_info *old_crypto_info = NULL;
>  	struct tls_crypto_info *crypto_info;
>  	struct tls_crypto_info *alt_crypto_info;
>  	struct tls_context *ctx = tls_get_ctx(sk);
> +	bool update = false;
>  	size_t optsize;
>  	int rc = 0;
>  	int conf;
> @@ -687,9 +690,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>  		alt_crypto_info = &ctx->crypto_send.info;
>  	}
>  
> -	/* Currently we don't support set crypto info more than one time */
> -	if (TLS_CRYPTO_INFO_READY(crypto_info))
> -		return -EBUSY;
> +	if (TLS_CRYPTO_INFO_READY(crypto_info)) {
> +		/* Currently we only support setting crypto info more
> +		 * than one time for TLS 1.3
> +		 */
> +		if (crypto_info->version != TLS_1_3_VERSION)
> +			return -EBUSY;
> +

Should we check this ?

                if (!tx && !key_update_pending)
                        return -EBUSY;

Otherwise we can set a new RX key even if the other end has not sent
KeyUpdateRequest.


> +		update = true;
> +		old_crypto_info = crypto_info;
> +		crypto_info = &tmp.info;
> +	}
>  
>  	rc = copy_from_sockptr(crypto_info, optval, sizeof(*crypto_info));
>  	if (rc) {
> @@ -704,6 +715,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>  		goto err_crypto_info;
>  	}
>  
> +	if (update) {
> +		/* Ensure that TLS version and ciphers are not modified */
> +		if (crypto_info->version != old_crypto_info->version ||
> +		    crypto_info->cipher_type != old_crypto_info->cipher_type) {
> +			rc = -EINVAL;
> +			goto err_crypto_info;
> +		}
> +	}
> +
>  	/* Ensure that TLS version and ciphers are same in both directions */
>  	if (TLS_CRYPTO_INFO_READY(alt_crypto_info)) {

We can change this to else-if.


>  		if (alt_crypto_info->version != crypto_info->version ||
> @@ -772,7 +792,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXDEVICE);
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
>  		} else {
> -			rc = tls_set_sw_offload(sk, 1);
> +			rc = tls_set_sw_offload(sk, 1,
> +						update ? crypto_info : NULL);
>  			if (rc)
>  				goto err_crypto_info;
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXSW);
> @@ -786,7 +807,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICE);
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXDEVICE);
>  		} else {
> -			rc = tls_set_sw_offload(sk, 0);
> +			rc = tls_set_sw_offload(sk, 0,
> +						update ? crypto_info : NULL);
>  			if (rc)
>  				goto err_crypto_info;
>  			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXSW);
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 22efea224a04..310135aaa6e6 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2505,11 +2505,19 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
>  		tls_ctx->prot_info.version != TLS_1_3_VERSION;
>  }
>  
> -int tls_set_sw_offload(struct sock *sk, int tx)
> +static void tls_finish_key_update(struct tls_context *tls_ctx)
> +{
> +	struct tls_sw_context_rx *ctx = tls_ctx->priv_ctx_rx;
> +
> +	ctx->key_update_pending = false;
> +}
> +
> +int tls_set_sw_offload(struct sock *sk, int tx,
> +		       struct tls_crypto_info *new_crypto_info)
>  {
>  	struct tls_context *ctx = tls_get_ctx(sk);
>  	struct tls_prot_info *prot = &ctx->prot_info;
> -	struct tls_crypto_info *crypto_info;
> +	struct tls_crypto_info *crypto_info, *src_crypto_info;
>  	struct tls_sw_context_tx *sw_ctx_tx = NULL;
>  	struct tls_sw_context_rx *sw_ctx_rx = NULL;
>  	struct cipher_context *cctx;
> @@ -2517,9 +2525,28 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
>  	struct crypto_tfm *tfm;
>  	char *iv, *rec_seq, *key, *salt, *cipher_name;
> -	size_t keysize;
> +	size_t keysize, crypto_info_size;
>  	int rc = 0;
>  
> +	if (new_crypto_info) {
> +		/* non-NULL new_crypto_info means rekey */
> +		src_crypto_info = new_crypto_info;
> +		if (tx) {
> +			sw_ctx_tx = ctx->priv_ctx_tx;
> +			crypto_info = &ctx->crypto_send.info;
> +			cctx = &ctx->tx;
> +			aead = &sw_ctx_tx->aead_send;
> +			sw_ctx_tx = NULL;

sw_ctx_tx is already initialised.


> +		} else {
> +			sw_ctx_rx = ctx->priv_ctx_rx;
> +			crypto_info = &ctx->crypto_recv.info;
> +			cctx = &ctx->rx;
> +			aead = &sw_ctx_rx->aead_recv;
> +			sw_ctx_rx = NULL;

Same here.


> +		}
> +		goto skip_init;
> +	}
> +
>  	if (tx) {
>  		if (!ctx->priv_ctx_tx) {
>  			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);
> @@ -2566,12 +2593,15 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  		aead = &sw_ctx_rx->aead_recv;
>  		sw_ctx_rx->key_update_pending = false;
>  	}
> +	src_crypto_info = crypto_info;
>  
> +skip_init:
>  	switch (crypto_info->cipher_type) {
>  	case TLS_CIPHER_AES_GCM_128: {
>  		struct tls12_crypto_info_aes_gcm_128 *gcm_128_info;
>  
> -		gcm_128_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_aes_gcm_128);
> +		gcm_128_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
>  		tag_size = TLS_CIPHER_AES_GCM_128_TAG_SIZE;
>  		iv_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
> @@ -2588,7 +2618,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_AES_GCM_256: {
>  		struct tls12_crypto_info_aes_gcm_256 *gcm_256_info;
>  
> -		gcm_256_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_aes_gcm_256);
> +		gcm_256_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_AES_GCM_256_IV_SIZE;
>  		tag_size = TLS_CIPHER_AES_GCM_256_TAG_SIZE;
>  		iv_size = TLS_CIPHER_AES_GCM_256_IV_SIZE;
> @@ -2605,7 +2636,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_AES_CCM_128: {
>  		struct tls12_crypto_info_aes_ccm_128 *ccm_128_info;
>  
> -		ccm_128_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_aes_ccm_128);
> +		ccm_128_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_AES_CCM_128_IV_SIZE;
>  		tag_size = TLS_CIPHER_AES_CCM_128_TAG_SIZE;
>  		iv_size = TLS_CIPHER_AES_CCM_128_IV_SIZE;
> @@ -2622,7 +2654,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_CHACHA20_POLY1305: {
>  		struct tls12_crypto_info_chacha20_poly1305 *chacha20_poly1305_info;
>  
> -		chacha20_poly1305_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_chacha20_poly1305);
> +		chacha20_poly1305_info = (void *)src_crypto_info;
>  		nonce_size = 0;
>  		tag_size = TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE;
>  		iv_size = TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE;
> @@ -2639,7 +2672,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_SM4_GCM: {
>  		struct tls12_crypto_info_sm4_gcm *sm4_gcm_info;
>  
> -		sm4_gcm_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_sm4_gcm);
> +		sm4_gcm_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_SM4_GCM_IV_SIZE;
>  		tag_size = TLS_CIPHER_SM4_GCM_TAG_SIZE;
>  		iv_size = TLS_CIPHER_SM4_GCM_IV_SIZE;
> @@ -2656,7 +2690,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_SM4_CCM: {
>  		struct tls12_crypto_info_sm4_ccm *sm4_ccm_info;
>  
> -		sm4_ccm_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_sm4_ccm);
> +		sm4_ccm_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_SM4_CCM_IV_SIZE;
>  		tag_size = TLS_CIPHER_SM4_CCM_TAG_SIZE;
>  		iv_size = TLS_CIPHER_SM4_CCM_IV_SIZE;
> @@ -2673,7 +2708,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_ARIA_GCM_128: {
>  		struct tls12_crypto_info_aria_gcm_128 *aria_gcm_128_info;
>  
> -		aria_gcm_128_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_aria_gcm_128);
> +		aria_gcm_128_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
>  		tag_size = TLS_CIPHER_ARIA_GCM_128_TAG_SIZE;
>  		iv_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
> @@ -2690,7 +2726,8 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	case TLS_CIPHER_ARIA_GCM_256: {
>  		struct tls12_crypto_info_aria_gcm_256 *gcm_256_info;
>  
> -		gcm_256_info = (void *)crypto_info;
> +		crypto_info_size = sizeof(struct tls12_crypto_info_aria_gcm_256);
> +		gcm_256_info = (void *)src_crypto_info;
>  		nonce_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
>  		tag_size = TLS_CIPHER_ARIA_GCM_256_TAG_SIZE;
>  		iv_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
> @@ -2734,19 +2771,26 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  			      prot->tag_size + prot->tail_size;
>  	prot->iv_size = iv_size;
>  	prot->salt_size = salt_size;
> -	cctx->iv = kmalloc(iv_size + salt_size, GFP_KERNEL);
> -	if (!cctx->iv) {
> -		rc = -ENOMEM;
> -		goto free_priv;
> +	if (!new_crypto_info) {
> +		cctx->iv = kmalloc(iv_size + salt_size, GFP_KERNEL);
> +		if (!cctx->iv) {
> +			rc = -ENOMEM;
> +			goto free_priv;
> +		}
>  	}
>  	/* Note: 128 & 256 bit salt are the same size */
>  	prot->rec_seq_size = rec_seq_size;
>  	memcpy(cctx->iv, salt, salt_size);
>  	memcpy(cctx->iv + salt_size, iv, iv_size);
> -	cctx->rec_seq = kmemdup(rec_seq, rec_seq_size, GFP_KERNEL);
> -	if (!cctx->rec_seq) {
> -		rc = -ENOMEM;
> -		goto free_iv;
> +
> +	if (!new_crypto_info) {
> +		cctx->rec_seq = kmemdup(rec_seq, rec_seq_size, GFP_KERNEL);
> +		if (!cctx->rec_seq) {
> +			rc = -ENOMEM;
> +			goto free_iv;
> +		}
> +	} else {
> +		memcpy(cctx->rec_seq, rec_seq, rec_seq_size);
>  	}
>  
>  	if (!*aead) {
> @@ -2761,13 +2805,20 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	ctx->push_pending_record = tls_sw_push_pending_record;
>  
>  	rc = crypto_aead_setkey(*aead, key, keysize);
> -
> -	if (rc)
> -		goto free_aead;
> +	if (rc) {
> +		if (new_crypto_info)
> +			goto out;
> +		else
> +			goto free_aead;
> +	}
>  
>  	rc = crypto_aead_setauthsize(*aead, prot->tag_size);
> -	if (rc)
> -		goto free_aead;
> +	if (rc) {
> +		if (new_crypto_info)
> +			goto out;
> +		else
> +			goto free_aead;
> +	}
>  
>  	if (sw_ctx_rx) {
>  		tfm = crypto_aead_tfm(sw_ctx_rx->aead_recv);
> @@ -2782,6 +2833,13 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  			goto free_aead;
>  	}
>  
> +	if (new_crypto_info) {
> +		memcpy(crypto_info, new_crypto_info, crypto_info_size);
> +		memzero_explicit(new_crypto_info, crypto_info_size);
> +		if (!tx)
> +			tls_finish_key_update(ctx);
> +	}
> +
>  	goto out;
>  
>  free_aead:
> @@ -2794,12 +2852,14 @@ int tls_set_sw_offload(struct sock *sk, int tx)
>  	kfree(cctx->iv);
>  	cctx->iv = NULL;
>  free_priv:
> -	if (tx) {
> -		kfree(ctx->priv_ctx_tx);
> -		ctx->priv_ctx_tx = NULL;
> -	} else {
> -		kfree(ctx->priv_ctx_rx);
> -		ctx->priv_ctx_rx = NULL;
> +	if (!new_crypto_info) {
> +		if (tx) {
> +			kfree(ctx->priv_ctx_tx);
> +			ctx->priv_ctx_tx = NULL;
> +		} else {
> +			kfree(ctx->priv_ctx_rx);
> +			ctx->priv_ctx_rx = NULL;
> +		}
>  	}
>  out:
>  	return rc;
> -- 
> 2.38.1
