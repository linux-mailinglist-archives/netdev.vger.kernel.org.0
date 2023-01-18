Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2710E672C4D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjARXM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjARXM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:12:26 -0500
X-Greylist: delayed 115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Jan 2023 15:12:22 PST
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3298613E1
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 15:12:21 -0800 (PST)
Received: from [192.168.0.18] (unknown [37.228.234.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 57F0C50509B;
        Thu, 19 Jan 2023 02:07:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 57F0C50509B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674083226; bh=PE96XYmWe17DSxmjI1M79gI08FJwtz4dxwt3OTav3XE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jV1/fdxTK198lunBqn1qT20UcMcjhSCXDV4+pVrMtDszciwOl/w7PW5CiQbYcoiag
         v0eUDxzzqhtuIpH5Othnz2Ge1t37EE2vq733OX7ewMKv9OQlhybO2OADwWCr5TGHVQ
         q3ABKqX9KG2/HtUKh1+SGen4DYm1ua0r/E/W8vIQ=
Message-ID: <ca63fd8b-fc99-6ffb-60a5-20041dd9488d@novek.ru>
Date:   Wed, 18 Jan 2023 23:12:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/5] tls: remove tls_context argument from
 tls_set_sw_offload
Content-Language: en-US
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Frantisek Krenzelok <fkrenzel@redhat.com>
References: <cover.1673952268.git.sd@queasysnail.net>
 <d42dbd07c7f7a9a2ec465fde1badf16a2304b996.1673952268.git.sd@queasysnail.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <d42dbd07c7f7a9a2ec465fde1badf16a2304b996.1673952268.git.sd@queasysnail.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.01.2023 13:45, Sabrina Dubroca wrote:
> It's not really needed since we end up refetching it as tls_ctx. We
> can also remove the NULL check, since we have already dereferenced ctx
> in do_tls_setsockopt_conf.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Tested-by: Frantisek Krenzelok <fkrenzel@redhat.com>
> ---
>   net/tls/tls.h        |  2 +-
>   net/tls/tls_device.c |  2 +-
>   net/tls/tls_main.c   |  4 ++--
>   net/tls/tls_sw.c     | 11 +++--------
>   4 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/net/tls/tls.h b/net/tls/tls.h
> index 0e840a0c3437..34d0fe814600 100644
> --- a/net/tls/tls.h
> +++ b/net/tls/tls.h
> @@ -90,7 +90,7 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
>   		  unsigned int optlen);
>   void tls_err_abort(struct sock *sk, int err);
>   
> -int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
> +int tls_set_sw_offload(struct sock *sk, int tx);
>   void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
>   void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
>   void tls_sw_strparser_done(struct tls_context *tls_ctx);
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 6c593788dc25..c149f36b42ee 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1291,7 +1291,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
>   	context->resync_nh_reset = 1;
>   
>   	ctx->priv_ctx_rx = context;
> -	rc = tls_set_sw_offload(sk, ctx, 0);
> +	rc = tls_set_sw_offload(sk, 0);
>   	if (rc)
>   		goto release_ctx;
>   
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 3735cb00905d..fb1da1780f50 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -772,7 +772,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXDEVICE);
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
>   		} else {
> -			rc = tls_set_sw_offload(sk, ctx, 1);
> +			rc = tls_set_sw_offload(sk, 1);
>   			if (rc)
>   				goto err_crypto_info;
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXSW);
> @@ -786,7 +786,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICE);
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXDEVICE);
>   		} else {
> -			rc = tls_set_sw_offload(sk, ctx, 0);
> +			rc = tls_set_sw_offload(sk, 0);
>   			if (rc)
>   				goto err_crypto_info;
>   			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXSW);
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 9ed978634125..238562f9081b 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2462,10 +2462,10 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
>   		tls_ctx->prot_info.version != TLS_1_3_VERSION;
>   }
>   
> -int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
> +int tls_set_sw_offload(struct sock *sk, int tx)
>   {
> -	struct tls_context *tls_ctx = tls_get_ctx(sk);
> -	struct tls_prot_info *prot = &tls_ctx->prot_info;
> +	struct tls_context *ctx = tls_get_ctx(sk);
> +	struct tls_prot_info *prot = &ctx->prot_info;

nit: while you are here it's good idea to rearrange variables to follow reverse 
xmas tree rule

>   	struct tls_crypto_info *crypto_info;
>   	struct tls_sw_context_tx *sw_ctx_tx = NULL;
>   	struct tls_sw_context_rx *sw_ctx_rx = NULL;
> @@ -2477,11 +2477,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>   	size_t keysize;
>   	int rc = 0;
>   
> -	if (!ctx) {
> -		rc = -EINVAL;
> -		goto out;
> -	}
> -
>   	if (tx) {
>   		if (!ctx->priv_ctx_tx) {
>   			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);

we may consider changing tls_set_device_offload{,_rx} the same for consistency.

Reviewed-by: Vadim Fedorenko <vfedorenko@novek.ru>


