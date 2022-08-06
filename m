Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A403858B677
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 17:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiHFP0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 11:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiHFP0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 11:26:50 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3BBFD2B;
        Sat,  6 Aug 2022 08:26:49 -0700 (PDT)
Received: from [192.168.10.23] (unknown [39.46.64.186])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2DBC66601B6F;
        Sat,  6 Aug 2022 16:26:42 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1659799607;
        bh=HdwNEzS966/lk5zR+dVV1aaOS5MuoSUELdjHQTmX1ck=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=HDDak1UXe3vv3h6kbHJQw7nwZjtGvmIT5Eswp61Mt56xLYkr35C+q+Rxh6u6G/emW
         M+MX2oNqsYx//x0KRiMj6Y5LMa9eWduO6ou/m2yP1QodLjmPMEedsmwlZxCIeidodn
         q8IC1H462Z/ZmRDBNSbwcpTV1D1+lNaao+Ffoqj/pPqOOF2HG0zJXAXYcCL6CMF5pG
         J/1ln4sQOyT1cAfYtvrG73OTbkjpmInT9pkughxsjq6wk4SQ2rR+dqmjSUJKl+cQHG
         Kbhkoo0M61HxjGHIKuV60hsv9Wmu7xVLA0B3LI2xVuZbETd7FhktzCbV5CtcBRTkUX
         E6ALLlo/Nz/wQ==
Message-ID: <55c8de7e-a6e8-fc79-794d-53536ad7a65d@collabora.com>
Date:   Sat, 6 Aug 2022 20:26:38 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Cc:     usama.anjum@collabora.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] selftests/net: Refactor xfrm_fill_key() to use array
 of structs
Content-Language: en-US
To:     Gautam Menghani <gautammenghani201@gmail.com>,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
References: <20220803032312.3939-1-gautammenghani201@gmail.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20220803032312.3939-1-gautammenghani201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/22 8:23 AM, Gautam Menghani wrote:
> A TODO in net/ipsec.c asks to refactor the code in xfrm_fill_key() to
> use set/map to avoid manually comparing each algorithm with the "name" 
> parameter passed to the function as an argument. This patch refactors 
> the code to create an array of structs where each struct contains the 
> algorithm name and its corresponding key length.
> 
> Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
> ---
> changes in v2:
> 1. Fix the compilation warnings for struct and variable declaration
> 
>  tools/testing/selftests/net/ipsec.c | 108 +++++++++++++---------------
>  1 file changed, 49 insertions(+), 59 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
> index cc10c10c5ed9..4a0eeb5b71d2 100644
> --- a/tools/testing/selftests/net/ipsec.c
> +++ b/tools/testing/selftests/net/ipsec.c
> @@ -58,6 +58,8 @@
>  #define VETH_FMT	"ktst-%d"
>  #define VETH_LEN	12
>  
> +#define XFRM_ALGO_NR_KEYS 29
> +
>  static int nsfd_parent	= -1;
>  static int nsfd_childa	= -1;
>  static int nsfd_childb	= -1;
> @@ -75,6 +77,46 @@ const unsigned int ping_timeout		= 300;
>  const unsigned int ping_count		= 100;
>  const unsigned int ping_success		= 80;
>  
> +struct xfrm_key_entry {
> +	char algo_name[35];
> +	int key_len;
> +};
> +
> +struct xfrm_key_entry xfrm_key_entries[XFRM_ALGO_NR_KEYS];
There seems no need to fill up xfrm_key_entries at run time. Please fill
them at compile time.

struct xfrm_key_entry xfrm_key_entries[] = {
	{"digest_null", 0},
	{"ecb(cipher_null)", 0},
	...
};

> +
> +static void init_xfrm_algo_keys(void)
> +{
> +	xfrm_key_entries[0] = (struct xfrm_key_entry) {"digest_null", 0};
> +	xfrm_key_entries[1] = (struct xfrm_key_entry) {"ecb(cipher_null)", 0};
> +	xfrm_key_entries[2] = (struct xfrm_key_entry) {"cbc(des)", 64};
> +	xfrm_key_entries[3] = (struct xfrm_key_entry) {"hmac(md5)", 128};
> +	xfrm_key_entries[4] = (struct xfrm_key_entry) {"cmac(aes)", 128};
> +	xfrm_key_entries[5] = (struct xfrm_key_entry) {"xcbc(aes)", 128};
> +	xfrm_key_entries[6] = (struct xfrm_key_entry) {"cbc(cast5)", 128};
> +	xfrm_key_entries[7] = (struct xfrm_key_entry) {"cbc(serpent)", 128};
> +	xfrm_key_entries[8] = (struct xfrm_key_entry) {"hmac(sha1)", 160};
> +	xfrm_key_entries[9] = (struct xfrm_key_entry) {"hmac(rmd160)", 160};
> +	xfrm_key_entries[10] = (struct xfrm_key_entry) {"cbc(des3_ede)", 192};
> +	xfrm_key_entries[11] = (struct xfrm_key_entry) {"hmac(sha256)", 256};
> +	xfrm_key_entries[12] = (struct xfrm_key_entry) {"cbc(aes)", 256};
> +	xfrm_key_entries[13] = (struct xfrm_key_entry) {"cbc(camellia)", 256};
> +	xfrm_key_entries[14] = (struct xfrm_key_entry) {"cbc(twofish)", 256};
> +	xfrm_key_entries[15] = (struct xfrm_key_entry) {"rfc3686(ctr(aes))", 288};
> +	xfrm_key_entries[16] = (struct xfrm_key_entry) {"hmac(sha384)", 384};
> +	xfrm_key_entries[17] = (struct xfrm_key_entry) {"cbc(blowfish)", 448};
> +	xfrm_key_entries[18] = (struct xfrm_key_entry) {"hmac(sha512)", 512};
> +	xfrm_key_entries[19] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-128", 160};
> +	xfrm_key_entries[20] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-128", 160};
> +	xfrm_key_entries[21] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-128", 152};
> +	xfrm_key_entries[22] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-192", 224};
> +	xfrm_key_entries[23] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-192", 224};
> +	xfrm_key_entries[24] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-192", 216};
> +	xfrm_key_entries[25] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-256", 288};
> +	xfrm_key_entries[26] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-256", 288};
> +	xfrm_key_entries[27] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-256", 280};
> +	xfrm_key_entries[28] = (struct xfrm_key_entry) {"rfc7539(chacha20,poly1305)-128", 0};
> +}

-- 
Muhammad Usama Anjum
