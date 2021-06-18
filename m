Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA63AD4C1
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbhFRWFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:05:23 -0400
Received: from novek.ru ([213.148.174.62]:34914 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234710AbhFRWFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:05:21 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8AABE503BBB;
        Sat, 19 Jun 2021 01:01:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8AABE503BBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624053676; bh=Or5GERcBLdJFGD7tDZ2zg/P5FsNM2mzNL1Ozt3PriIA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=biCGIiz6vz7PDRSKjt8amwyM2+n/iYJ6p//P4UNuQmtNQ6eDTN4uti+RFru0JAzQu
         GkRULpXZyKSyYOHfHMRXxS56LRD9zRR27TxVQX/FrYpFEYY9kBfNQbBWuzIUFzzr5Z
         oci+376Si08YIFOljsDWYZHkORgvHxg4Ae7Q9/hE=
Subject: Re: [PATCH net 2/2] selftests: tls: fix chacha+bidir tests
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
References: <20210618202504.1435179-1-kuba@kernel.org>
 <20210618202504.1435179-2-kuba@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <2ab110a6-a2a0-c5c7-29e5-ed38fb438176@novek.ru>
Date:   Fri, 18 Jun 2021 23:03:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210618202504.1435179-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.06.2021 21:25, Jakub Kicinski wrote:
> ChaCha support did not adjust the bidirectional test.
> We need to set up KTLS in reverse direction correctly,
> otherwise these two cases will fail:
> 
>    tls.12_chacha.bidir
>    tls.13_chacha.bidir
> 
> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   tools/testing/selftests/net/tls.c | 67 ++++++++++++++++++-------------
>   1 file changed, 39 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 58fea6eb588d..112d41d01b12 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -25,6 +25,35 @@
>   #define TLS_PAYLOAD_MAX_LEN 16384
>   #define SOL_TLS 282
>   
> +struct tls_crypto_info_keys {
> +	union {
> +		struct tls12_crypto_info_aes_gcm_128 aes128;
> +		struct tls12_crypto_info_chacha20_poly1305 chacha20;
> +	};
> +	size_t len;
> +};
> +
> +static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
> +				 struct tls_crypto_info_keys *tls12)
> +{
> +	memset(tls12, 0, sizeof(*tls12));
> +
> +	switch (cipher_type) {
> +	case TLS_CIPHER_CHACHA20_POLY1305:
> +		tls12->len = sizeof(struct tls12_crypto_info_chacha20_poly1305);
> +		tls12->chacha20.info.version = tls_version;
> +		tls12->chacha20.info.cipher_type = cipher_type;
> +		break;
> +	case TLS_CIPHER_AES_GCM_128:
> +		tls12->len = sizeof(struct tls12_crypto_info_aes_gcm_128);
> +		tls12->aes128.info.version = tls_version;
> +		tls12->aes128.info.cipher_type = cipher_type;
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>   static void memrnd(void *s, size_t n)
>   {
>   	int *dword = s;
> @@ -145,33 +174,16 @@ FIXTURE_VARIANT_ADD(tls, 13_chacha)
>   
>   FIXTURE_SETUP(tls)
>   {
> -	union {
> -		struct tls12_crypto_info_aes_gcm_128 aes128;
> -		struct tls12_crypto_info_chacha20_poly1305 chacha20;
> -	} tls12;
> +	struct tls_crypto_info_keys tls12;
>   	struct sockaddr_in addr;
>   	socklen_t len;
>   	int sfd, ret;
> -	size_t tls12_sz;
>   
>   	self->notls = false;
>   	len = sizeof(addr);
>   
> -	memset(&tls12, 0, sizeof(tls12));
> -	switch (variant->cipher_type) {
> -	case TLS_CIPHER_CHACHA20_POLY1305:
> -		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
> -		tls12.chacha20.info.version = variant->tls_version;
> -		tls12.chacha20.info.cipher_type = variant->cipher_type;
> -		break;
> -	case TLS_CIPHER_AES_GCM_128:
> -		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
> -		tls12.aes128.info.version = variant->tls_version;
> -		tls12.aes128.info.cipher_type = variant->cipher_type;
> -		break;
> -	default:
> -		tls12_sz = 0;
> -	}
> +	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
> +			     &tls12);
>   
>   	addr.sin_family = AF_INET;
>   	addr.sin_addr.s_addr = htonl(INADDR_ANY);
> @@ -199,7 +211,7 @@ FIXTURE_SETUP(tls)
>   
>   	if (!self->notls) {
>   		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
> -				 tls12_sz);
> +				 tls12.len);
>   		ASSERT_EQ(ret, 0);
>   	}
>   
> @@ -212,7 +224,7 @@ FIXTURE_SETUP(tls)
>   		ASSERT_EQ(ret, 0);
>   
>   		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
> -				 tls12_sz);
> +				 tls12.len);
>   		ASSERT_EQ(ret, 0);
>   	}
>   
> @@ -854,18 +866,17 @@ TEST_F(tls, bidir)
>   	int ret;
>   
>   	if (!self->notls) {
> -		struct tls12_crypto_info_aes_gcm_128 tls12;
> +		struct tls_crypto_info_keys tls12;
>   
> -		memset(&tls12, 0, sizeof(tls12));
> -		tls12.info.version = variant->tls_version;
> -		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
> +		tls_crypto_info_init(variant->tls_version, variant->cipher_type,
> +				     &tls12);
>   
>   		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
> -				 sizeof(tls12));
> +				 tls12.len);
>   		ASSERT_EQ(ret, 0);
>   
>   		ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12,
> -				 sizeof(tls12));
> +				 tls12.len);
>   		ASSERT_EQ(ret, 0);
>   	}
>   
> 

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>

