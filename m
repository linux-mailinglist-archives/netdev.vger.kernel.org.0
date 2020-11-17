Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B9E2B71B9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgKQWis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgKQWis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:38:48 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA01B206E0;
        Tue, 17 Nov 2020 22:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605652727;
        bh=8nds6rZbc08PfryBuLS5pWYwADwquMGg0RinCE8DZh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qL57K1mwpFYi0YB8h3GJ+4SXUBGRnLGjpZWmsKeeG6OqV3SU3cQ3O4QQDtqtO35Xt
         evXJJHWPVt2sRJshzjcvME3WsBcgWnS6vbUeFumZMGZgQarcB93f12ZpOBAdX/zqv9
         9Y6L35qeaISomuTdBi8r+98O1hWgL9nKi7ILI1wY=
Date:   Tue, 17 Nov 2020 14:38:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: missing received data after fast remote close
Message-ID: <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 14:43:48 +0300 Vadim Fedorenko wrote:
> In case when tcp socket received FIN after some data and the
> parser haven't started before reading data caller will receive
> an empty buffer.

This is pretty terse, too terse for me to understand..

> This behavior differs from plain TCP socket and
> leads to special treating in user-space. Patch unpauses parser
> directly if we have unparsed data in tcp receive queue.

Sure, but why is the parser paused? Does it pause itself on FIN?

> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 2fe9e2c..4db6943 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1289,6 +1289,9 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
>  	struct sk_buff *skb;
>  	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  
> +	if (!ctx->recv_pkt && skb_queue_empty(&sk->sk_receive_queue))
> +		__strp_unpause(&ctx->strp);
> +
>  	while (!(skb = ctx->recv_pkt) && sk_psock_queue_empty(psock)) {
>  		if (sk->sk_err) {
>  			*err = sock_error(sk);

