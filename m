Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7935EB362
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIZVoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIZVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:44:03 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CD4A347C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 14:44:00 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A6517504D58;
        Tue, 27 Sep 2022 00:40:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A6517504D58
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1664228445; bh=TFRXKakhYievnFFp/2/fNyliYAIZ+1nh4H5ZnxSj8sc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=0EjNZREwX7nsmlkZz6JSvgOsFM7L7gm0+7gGMcGQDxWEVKEoozsMLlkblfwuBtmnJ
         cx/cMr74/xw6CbDexVEVBE1PvBX3nIXrUQOE9f3f0BwqLtwYCxShtvXogPvzEDMzY7
         DJxHMB4/PQsZoSoiYvY878rJvoOofRL9RApJ/YkY=
Message-ID: <4f41365d-2c34-32e0-9683-75557912522f@novek.ru>
Date:   Mon, 26 Sep 2022 22:43:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 net-next] net: tls: Add ARIA-GCM algorithm
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        borisp@nvidia.com, john.fastabend@gmail.com
References: <20220925150033.24615-1-ap420073@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220925150033.24615-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.09.2022 16:00, Taehee Yoo wrote:
> RFC 6209 describes ARIA for TLS 1.2.
> ARIA-128-GCM and ARIA-256-GCM are defined in RFC 6209.
> 
> This patch would offer performance increment and an opportunity for
> hardware offload.
> 
> Benchmark results:
> iperf-ssl are used.
> CPU: intel i3-12100.
> 
>    TLS(openssl-3.0-dev)
> [  3]  0.0- 1.0 sec   185 MBytes  1.55 Gbits/sec
> [  3]  1.0- 2.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  2.0- 3.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  3.0- 4.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  4.0- 5.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  0.0- 5.0 sec   927 MBytes  1.56 Gbits/sec
>    kTLS(aria-generic)
> [  3]  0.0- 1.0 sec   198 MBytes  1.66 Gbits/sec
> [  3]  1.0- 2.0 sec   194 MBytes  1.62 Gbits/sec
> [  3]  2.0- 3.0 sec   194 MBytes  1.63 Gbits/sec
> [  3]  3.0- 4.0 sec   194 MBytes  1.63 Gbits/sec
> [  3]  4.0- 5.0 sec   194 MBytes  1.62 Gbits/sec
> [  3]  0.0- 5.0 sec   974 MBytes  1.63 Gbits/sec
>    kTLS(aria-avx wirh GFNI)
> [  3]  0.0- 1.0 sec   632 MBytes  5.30 Gbits/sec
> [  3]  1.0- 2.0 sec   657 MBytes  5.51 Gbits/sec
> [  3]  2.0- 3.0 sec   657 MBytes  5.51 Gbits/sec
> [  3]  3.0- 4.0 sec   656 MBytes  5.50 Gbits/sec
> [  3]  4.0- 5.0 sec   656 MBytes  5.50 Gbits/sec
> [  3]  0.0- 5.0 sec  3.18 GBytes  5.47 Gbits/sec
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

It looks like there is nothing special in handling this algo in TLS 
implementation, common GCM way.

Reviewed-by: Vadim Fedorenko <vfedorenko@novek.ru>

> ---
> 
> v2:
> - This patch was a part of patchset of implementation of aria algorithm[1].
>    There were 3 patches in the patchset, the target branch of the first
>    and second patch were the crypto and these were merged[2].
>    This patch was the last patch of that patchset and the target branch of
>    this patch is net-next, not crypto. So it was not merged by the crypto
>    branch.
>    It waited for merging of these two patches.
> 
> v3:
>   - There are no code changes in this patch.
>   - Update benchmark data with aria-avx.
> 
> [1] https://lore.kernel.org/netdev/20220704094250.4265-4-ap420073@gmail.com/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/crypto/aria.c
> 
>   include/uapi/linux/tls.h | 30 +++++++++++++++++++
>   net/tls/tls_main.c       | 62 ++++++++++++++++++++++++++++++++++++++++
>   net/tls/tls_sw.c         | 34 ++++++++++++++++++++++
>   3 files changed, 126 insertions(+)
> 
> diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
> index f1157d8f4acd..b66a800389cc 100644
> --- a/include/uapi/linux/tls.h
> +++ b/include/uapi/linux/tls.h
> @@ -100,6 +100,20 @@
>   #define TLS_CIPHER_SM4_CCM_TAG_SIZE		16
>   #define TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE		8
>   
> +#define TLS_CIPHER_ARIA_GCM_128				57
> +#define TLS_CIPHER_ARIA_GCM_128_IV_SIZE			8
> +#define TLS_CIPHER_ARIA_GCM_128_KEY_SIZE		16
> +#define TLS_CIPHER_ARIA_GCM_128_SALT_SIZE		4
> +#define TLS_CIPHER_ARIA_GCM_128_TAG_SIZE		16
> +#define TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE		8
> +
> +#define TLS_CIPHER_ARIA_GCM_256				58
> +#define TLS_CIPHER_ARIA_GCM_256_IV_SIZE			8
> +#define TLS_CIPHER_ARIA_GCM_256_KEY_SIZE		32
> +#define TLS_CIPHER_ARIA_GCM_256_SALT_SIZE		4
> +#define TLS_CIPHER_ARIA_GCM_256_TAG_SIZE		16
> +#define TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE		8
> +
>   #define TLS_SET_RECORD_TYPE	1
>   #define TLS_GET_RECORD_TYPE	2
>   
> @@ -156,6 +170,22 @@ struct tls12_crypto_info_sm4_ccm {
>   	unsigned char rec_seq[TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE];
>   };
>   
> +struct tls12_crypto_info_aria_gcm_128 {
> +	struct tls_crypto_info info;
> +	unsigned char iv[TLS_CIPHER_ARIA_GCM_128_IV_SIZE];
> +	unsigned char key[TLS_CIPHER_ARIA_GCM_128_KEY_SIZE];
> +	unsigned char salt[TLS_CIPHER_ARIA_GCM_128_SALT_SIZE];
> +	unsigned char rec_seq[TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE];
> +};
> +
> +struct tls12_crypto_info_aria_gcm_256 {
> +	struct tls_crypto_info info;
> +	unsigned char iv[TLS_CIPHER_ARIA_GCM_256_IV_SIZE];
> +	unsigned char key[TLS_CIPHER_ARIA_GCM_256_KEY_SIZE];
> +	unsigned char salt[TLS_CIPHER_ARIA_GCM_256_SALT_SIZE];
> +	unsigned char rec_seq[TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE];
> +};
> +
>   enum {
>   	TLS_INFO_UNSPEC,
>   	TLS_INFO_VERSION,
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 5cc6911cc97d..3735cb00905d 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -524,6 +524,54 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
>   			rc = -EFAULT;
>   		break;
>   	}
> +	case TLS_CIPHER_ARIA_GCM_128: {
> +		struct tls12_crypto_info_aria_gcm_128 *
> +		  crypto_info_aria_gcm_128 =
> +		  container_of(crypto_info,
> +			       struct tls12_crypto_info_aria_gcm_128,
> +			       info);
> +
> +		if (len != sizeof(*crypto_info_aria_gcm_128)) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +		lock_sock(sk);
> +		memcpy(crypto_info_aria_gcm_128->iv,
> +		       cctx->iv + TLS_CIPHER_ARIA_GCM_128_SALT_SIZE,
> +		       TLS_CIPHER_ARIA_GCM_128_IV_SIZE);
> +		memcpy(crypto_info_aria_gcm_128->rec_seq, cctx->rec_seq,
> +		       TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE);
> +		release_sock(sk);
> +		if (copy_to_user(optval,
> +				 crypto_info_aria_gcm_128,
> +				 sizeof(*crypto_info_aria_gcm_128)))
> +			rc = -EFAULT;
> +		break;
> +	}
> +	case TLS_CIPHER_ARIA_GCM_256: {
> +		struct tls12_crypto_info_aria_gcm_256 *
> +		  crypto_info_aria_gcm_256 =
> +		  container_of(crypto_info,
> +			       struct tls12_crypto_info_aria_gcm_256,
> +			       info);
> +
> +		if (len != sizeof(*crypto_info_aria_gcm_256)) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +		lock_sock(sk);
> +		memcpy(crypto_info_aria_gcm_256->iv,
> +		       cctx->iv + TLS_CIPHER_ARIA_GCM_256_SALT_SIZE,
> +		       TLS_CIPHER_ARIA_GCM_256_IV_SIZE);
> +		memcpy(crypto_info_aria_gcm_256->rec_seq, cctx->rec_seq,
> +		       TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE);
> +		release_sock(sk);
> +		if (copy_to_user(optval,
> +				 crypto_info_aria_gcm_256,
> +				 sizeof(*crypto_info_aria_gcm_256)))
> +			rc = -EFAULT;
> +		break;
> +	}
>   	default:
>   		rc = -EINVAL;
>   	}
> @@ -685,6 +733,20 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>   	case TLS_CIPHER_SM4_CCM:
>   		optsize = sizeof(struct tls12_crypto_info_sm4_ccm);
>   		break;
> +	case TLS_CIPHER_ARIA_GCM_128:
> +		if (crypto_info->version != TLS_1_2_VERSION) {
> +			rc = -EINVAL;
> +			goto err_crypto_info;
> +		}
> +		optsize = sizeof(struct tls12_crypto_info_aria_gcm_128);
> +		break;
> +	case TLS_CIPHER_ARIA_GCM_256:
> +		if (crypto_info->version != TLS_1_2_VERSION) {
> +			rc = -EINVAL;
> +			goto err_crypto_info;
> +		}
> +		optsize = sizeof(struct tls12_crypto_info_aria_gcm_256);
> +		break;
>   	default:
>   		rc = -EINVAL;
>   		goto err_crypto_info;
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index fe27241cd13f..264cf367e265 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2629,6 +2629,40 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>   		cipher_name = "ccm(sm4)";
>   		break;
>   	}
> +	case TLS_CIPHER_ARIA_GCM_128: {
> +		struct tls12_crypto_info_aria_gcm_128 *aria_gcm_128_info;
> +
> +		aria_gcm_128_info = (void *)crypto_info;
> +		nonce_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
> +		tag_size = TLS_CIPHER_ARIA_GCM_128_TAG_SIZE;
> +		iv_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
> +		iv = aria_gcm_128_info->iv;
> +		rec_seq_size = TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE;
> +		rec_seq = aria_gcm_128_info->rec_seq;
> +		keysize = TLS_CIPHER_ARIA_GCM_128_KEY_SIZE;
> +		key = aria_gcm_128_info->key;
> +		salt = aria_gcm_128_info->salt;
> +		salt_size = TLS_CIPHER_ARIA_GCM_128_SALT_SIZE;
> +		cipher_name = "gcm(aria)";
> +		break;
> +	}
> +	case TLS_CIPHER_ARIA_GCM_256: {
> +		struct tls12_crypto_info_aria_gcm_256 *gcm_256_info;
> +
> +		gcm_256_info = (void *)crypto_info;
> +		nonce_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
> +		tag_size = TLS_CIPHER_ARIA_GCM_256_TAG_SIZE;
> +		iv_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
> +		iv = gcm_256_info->iv;
> +		rec_seq_size = TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE;
> +		rec_seq = gcm_256_info->rec_seq;
> +		keysize = TLS_CIPHER_ARIA_GCM_256_KEY_SIZE;
> +		key = gcm_256_info->key;
> +		salt = gcm_256_info->salt;
> +		salt_size = TLS_CIPHER_ARIA_GCM_256_SALT_SIZE;
> +		cipher_name = "gcm(aria)";
> +		break;
> +	}
>   	default:
>   		rc = -EINVAL;
>   		goto free_priv;

