Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA09230BBD1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBBKL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:11:56 -0500
Received: from novek.ru ([213.148.174.62]:43004 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhBBKLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 05:11:55 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id ACF9050338C;
        Tue,  2 Feb 2021 13:12:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru ACF9050338C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612260756; bh=oPt0WeRFz/78h1dDG8dWA3PO2KaXxhxNLZcvC6o6oBU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=K7iP6A518vg7uYDhp8j+xqbrLD+PNj0ifAp64YhONUq4s0GZeqcpL/br/dI5yZ1f+
         x8I0JILloKIvIPWVI4+yevxWzoDWLTyEVudVBNaqPlAi2Oi/YsO1Xaj68mLix5tbRz
         T3AGWrNP0AyDKphmMjF+gry0b3j7DxaYdWe5tgqE=
Subject: Re: [PATCH] selftests/tls: fix compile errors after adding
 CHACHA20-POLY1305
To:     Rong Chen <rong.a.chen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
References: <20210202094500.679761-1-rong.a.chen@intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <157e79ea-e184-ea67-d1cf-39fa069624ec@novek.ru>
Date:   Tue, 2 Feb 2021 10:11:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202094500.679761-1-rong.a.chen@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.2021 09:45, Rong Chen wrote:
> The kernel test robot reported the following errors:
> 
> tls.c: In function ‘tls_setup’:
> tls.c:136:27: error: storage size of ‘tls12’ isn’t known
>    union tls_crypto_context tls12;
>                             ^~~~~
> tls.c:150:21: error: ‘tls12_crypto_info_chacha20_poly1305’ undeclared (first use in this function)
>     tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tls.c:150:21: note: each undeclared identifier is reported only once for each function it appears in
> tls.c:153:21: error: ‘tls12_crypto_info_aes_gcm_128’ undeclared (first use in this function)
>     tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
> 
> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9020/
> Signed-off-by: Rong Chen <rong.a.chen@intel.com>
> ---
>   include/net/tls.h                 | 9 ---------
>   include/uapi/linux/tls.h          | 9 +++++++++
>   tools/testing/selftests/net/tls.c | 4 ++--
>   3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 3eccb525e8f7..54f7863ad915 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -212,15 +212,6 @@ struct cipher_context {
>   	char *rec_seq;
>   };
>   
> -union tls_crypto_context {
> -	struct tls_crypto_info info;
> -	union {
> -		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
> -		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
> -		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
> -	};
> -};
> -
>   struct tls_prot_info {
>   	u16 version;
>   	u16 cipher_type;
> diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
> index 0d54baea1d8d..9933dd425571 100644
> --- a/include/uapi/linux/tls.h
> +++ b/include/uapi/linux/tls.h
> @@ -124,6 +124,15 @@ struct tls12_crypto_info_chacha20_poly1305 {
>   	unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
>   };
>   
> +union tls_crypto_context {
> +	struct tls_crypto_info info;
> +	union {
> +		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
> +		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
> +		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
> +	};
> +};
> +
>   enum {
>   	TLS_INFO_UNSPEC,
>   	TLS_INFO_VERSION,
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index e0088c2d38a5..6951c8524a27 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -147,10 +147,10 @@ FIXTURE_SETUP(tls)
>   	tls12.info.cipher_type = variant->cipher_type;
>   	switch (variant->cipher_type) {
>   	case TLS_CIPHER_CHACHA20_POLY1305:
> -		tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
> +		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
>   		break;
>   	case TLS_CIPHER_AES_GCM_128:
> -		tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
> +		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
>   		break;
>   	default:
>   		tls12_sz = 0;
> 

I'm not sure that it's a good idea to move tls_crypto_context to uapi as it's
an internal union. Previous patches assumes that user-space uses different
structures for different cipher configurations.
