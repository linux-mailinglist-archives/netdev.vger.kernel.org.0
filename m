Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C6F63F5F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 04:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGJCiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 22:38:52 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36015 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGJCiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 22:38:51 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so762840qkl.3
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 19:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jDEI0z0+T3TWeJ/hFB5v8bUNjyZ8Sx2AYpwzjwi8FHM=;
        b=vnHlT4o56fYEQImxIjVaUxD/qlpsaewZfsNdFGHgfKTqSHCwc3TS9T9vrhORcHIFfR
         CgPBBMNtIfXtkxZv1obvfBnXDsunwGuVXjG9MFCNRzJOqxNjFAlbeWtOaKXEkqIpl9ND
         a7gwF7KIteJ5fmlG2+vJIBD8WmVvWX+U9Lu0j1rv0ooKUdoux7/i+4dGDzCJ0QwCd+Eb
         Mga9V4A28AEUq08qrKHHnmfeXWPBM3RJUt3bLkfFMV0ndzo7QaJf2YXAuBE9zBP8sIgD
         8M9sIL4vYS7UO+K1J2WszvM4DnNytwtt/EW+onALqhrbv2Qua08e0eRAwM9ap6jToFB3
         6mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jDEI0z0+T3TWeJ/hFB5v8bUNjyZ8Sx2AYpwzjwi8FHM=;
        b=jDR/gc39yYkwwpjDZDvwOcak+LQ2Cq0EcCAvo20YGy8XAAkwcgSGZP8ahvLy+NuxN0
         yk1O3t3g9StRU4izzAFeCQKJGJ6aAqBM0jjNoZGxFOIVZDV8n+LKHjLnyhN8yG4ZE10r
         c+hA5nIZAz7wvgYEDOkFohmiO9Yebm5ip6NwPWTbNfmZGLwL5gJ1AxXkRScgxh631oCz
         Qmbq9VggcMi92sRDH80wnoAfKtK5mxws0QddxzUPyuZlv30vFRydrXpKlVHDE+3jMLGA
         aPpZQjpYWsUYc4EkQcnGkXJvD8Vk6ohCjGaIm0Y/vQ7Vi+2qqk21ss5IXH4UPtJI+lxI
         wZ3A==
X-Gm-Message-State: APjAAAWbKM25HMHyukz/yGJR5WcJqdFee4bKQ1ZPfBlMw3FxuRXXG1d6
        Jk2Frz6QNhgCZNyJcK6Wut6xryQnmnk=
X-Google-Smtp-Source: APXvYqwiKUwhmFalo9u+BSCRE/6iBIklPenJ67uja00/ES4dDk2X3UQE3tMcf+dqW4h+mi6JWnoF4w==
X-Received: by 2002:a37:7dc1:: with SMTP id y184mr19994389qkc.58.1562726330915;
        Tue, 09 Jul 2019 19:38:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x8sm406301qkl.27.2019.07.09.19.38.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 19:38:50 -0700 (PDT)
Date:   Tue, 9 Jul 2019 19:38:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 6/6] bpf: sockmap/tls, close can race with map
 free
Message-ID: <20190709193846.62f0a2c7@cakuba.netronome.com>
In-Reply-To: <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
        <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Jul 2019 19:15:18 +0000, John Fastabend wrote:
> @@ -352,15 +354,18 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
>  	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
>  		goto skip_tx_cleanup;
>  
> -	sk->sk_prot = ctx->sk_proto;
>  	tls_sk_proto_cleanup(sk, ctx, timeo);
>  
>  skip_tx_cleanup:
> +	write_lock_bh(&sk->sk_callback_lock);
> +	icsk->icsk_ulp_data = NULL;

Is ulp_data pointer now supposed to be updated under the
sk_callback_lock?

> +	if (sk->sk_prot->close == tls_sk_proto_close)
> +		sk->sk_prot = ctx->sk_proto;
> +	write_unlock_bh(&sk->sk_callback_lock);
>  	release_sock(sk);
>  	if (ctx->rx_conf == TLS_SW)
>  		tls_sw_release_strp_rx(ctx);
> -	sk_proto_close(sk, timeout);
> -
> +	ctx->sk_proto_close(sk, timeout);
>  	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
>  	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
>  		tls_ctx_free(ctx);

