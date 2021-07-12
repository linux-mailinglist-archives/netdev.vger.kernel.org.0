Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE63C50A6
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344840AbhGLHeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 03:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346194AbhGLHah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 03:30:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B36C0613B7
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 00:22:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i94so24129192wri.4
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 00:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=niwmpdXM7KNF8H22pgiZfYJ+IlDDLwhRRK2oXaaMW4E=;
        b=qyu6923oWTx22Y3o7XlmFZRrj7RSxhvfvsgDUXYwFNiUTfFSJOXsQbOB3h3kNuNvbZ
         CAOrdsKLvBHe+sJ9mvBFmAZPssedGWGohAgzx4PxyGY0wOaCkHOFwswCACDEn+RxD5KV
         CtINmoZpNf7KWyResRodm8b3hlXUzstTUgLtI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=niwmpdXM7KNF8H22pgiZfYJ+IlDDLwhRRK2oXaaMW4E=;
        b=G/GaYJ5N6JfK9frXfV6eQjcBgvCInWWFciOjIMxlaiZVkuSoKD5YP4TuqIRUu9dR5A
         n1SowWipfAxebduPcdnA+gHCM7vQuQRGu7FKgK12Veux9EdX0tyX3Oz3te5Ow0PYriZ6
         rvCnsEVEjf+0IjHFXgmfc58QmxkVmgvJNBxt7uEjpYWmAgMtb99B4ypNaOuZG8Myn0id
         YoMf++uwpcw2Rl4P/aGHDallmRV7pRx6s1kDtDaP2pu8H5rwSW56OZpJLhvUYlAjHj48
         O2cNMEDZpOHLpfpHh2r9Kqc3CjEyzU5429UEIKRKkCmuFe7uSbF3RAtsaRNHC0jg9Pul
         sMIg==
X-Gm-Message-State: AOAM532+1Hml6rb1vFZZcd01X726CV1lcbPGkz9fQsaEIWMFF5ooxSjt
        5RZpN6daSSpMZHTs+WhCP/LOZQ==
X-Google-Smtp-Source: ABdhPJybNjNqpSgQrmm+7FaSDAoMjZx3kDV/tnkTyVmyqxK/iRjJ5kI+axLn43wnLXVgZG4vjYpkPQ==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr56782701wrs.384.1626074562688;
        Mon, 12 Jul 2021 00:22:42 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id n23sm4457918wmc.38.2021.07.12.00.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 00:22:41 -0700 (PDT)
References: <20210706163150.112591-1-john.fastabend@gmail.com>
 <20210706163150.112591-3-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v3 2/2] bpf, sockmap: sk_prot needs inuse_idx set
 for proc stats
In-reply-to: <20210706163150.112591-3-john.fastabend@gmail.com>
Date:   Mon, 12 Jul 2021 09:22:40 +0200
Message-ID: <871r84ro73.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 06:31 PM CEST, John Fastabend wrote:
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/sock_map.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 60decd6420ca..27bdf768aa8c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -185,10 +185,19 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
>
>  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
>  {
> +	int err;
> +#ifdef CONFIG_PROC_FS
> +	int idx = sk->sk_prot->inuse_idx;
> +#endif
>  	if (!sk->sk_prot->psock_update_sk_prot)
>  		return -EINVAL;
>  	psock->psock_update_sk_prot = sk->sk_prot->psock_update_sk_prot;
> -	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
> +	err = sk->sk_prot->psock_update_sk_prot(sk, psock, false);
> +#ifdef CONFIG_PROC_FS
> +	if (!err)
> +		sk->sk_prot->inuse_idx = idx;
> +#endif
> +	return err;
>  }
>
>  static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)

We could initialize inuse_idx just once in {tcp,udp}_bpf_rebuild_protos,
if we changed {tcp,udp}_bpf_v4_build_proto to be a late_initcall, so
that it runs after inet_init when {tcp,udp}_prot and udp_prot are
already registered and have inuse_idx assigned.
