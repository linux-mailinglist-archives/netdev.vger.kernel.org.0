Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0213DD27E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhHBJBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhHBJBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 05:01:12 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB78C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 02:01:03 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h11so22923372ljo.12
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 02:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=FKkTDOoJkTf8q49ytftID668qe8fzuG5BawdaIV8kuA=;
        b=pIS2pGlmP8ZlgfkVoEdnjZDGG4WXVsdEADYJypNWJGKoEsxopWQB09EloEpv6qM5X8
         grmiivXghPgBVTrK7MXrIzJgb5qTx26Kk7x2FO/SrMMlXVv12UMLwYG8FcBIGeYzr9oz
         ThoXBUaqvnrT08bSpkwT8gIUhGBFdzx3ByNBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=FKkTDOoJkTf8q49ytftID668qe8fzuG5BawdaIV8kuA=;
        b=Jn0VpL6T11JYdFIGg/1BSgMKv0PpbLIFzXJgrfo0u2UyzC9PHvDWQ2TwqUP1GAM8k3
         ZO0SyDC9g6WLhQ6NnOC2mncgex/S9muCG5QrSWUDS6EvHhT9TLAdcL+sK3a/LjjVlaj0
         VTrwSaM/rEZq2Lmiu2dNJ00uKtlWHpnRbfcC5QwcwsZ/Lh1bKh9yT1txwMmp/dWn/wFr
         zTWK0QBq0ftMEq1TskG8634vJxRQMvaP/jvN8a150nWuPu+NjJea6BsJuJwX2Vv8bgom
         3Z5hv4wXErEI+bF+TO8ZPDm20feW2DkZhVPZiD54UZvA2LeRMyyeSw/zZNXt++UL7T69
         Npqg==
X-Gm-Message-State: AOAM532MYyktubGteltpK98S53IE5rXmxm8NXCDJnktUtOU3TqWpDNLH
        a1Owo9Eg7py7FHqTsQ3EcdF2vg==
X-Google-Smtp-Source: ABdhPJzEdmFIA6o3qeJFou32X+VoHvsVJSbMF9hUy7rsrIHD1qctKAYoiZEMsNB6Aus5gsoeOfcNXA==
X-Received: by 2002:a2e:a80f:: with SMTP id l15mr10869165ljq.354.1627894861160;
        Mon, 02 Aug 2021 02:01:01 -0700 (PDT)
Received: from cloudflare.com (79.191.182.217.ipv4.supernova.orange.pl. [79.191.182.217])
        by smtp.gmail.com with ESMTPSA id k8sm867574ljn.18.2021.08.02.02.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 02:01:00 -0700 (PDT)
References: <20210731195038.8084-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next] unix_bpf: check socket type in
 unix_bpf_update_proto()
In-reply-to: <20210731195038.8084-1-xiyou.wangcong@gmail.com>
Date:   Mon, 02 Aug 2021 11:00:59 +0200
Message-ID: <87sfzsnruc.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 09:50 PM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> As of now, only AF_UNIX datagram socket supports sockmap.
> But unix_proto is shared for all kinds of AF_UNIX sockets,
> so we have to check the socket type in
> unix_bpf_update_proto() to explicitly reject other types,
> otherwise they could be added into sockmap too.
>
> Fixes: c63829182c37 ("af_unix: Implement ->psock_update_sk_prot()")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/unix/unix_bpf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index 177e883f451e..20f53575b5c9 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -105,6 +105,9 @@ static void unix_bpf_check_needs_rebuild(struct proto *ops)
>  
>  int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
>  {
> +	if (sk->sk_type != SOCK_DGRAM)
> +		return -EOPNOTSUPP;
> +
>  	if (restore) {
>  		sk->sk_write_space = psock->saved_write_space;
>  		WRITE_ONCE(sk->sk_prot, psock->sk_proto);

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
