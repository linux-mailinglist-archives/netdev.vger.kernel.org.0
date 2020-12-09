Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784FB2D37CB
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgLIA3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731032AbgLIA3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:29:34 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3781CC0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:28:54 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 52F0A4D249B50;
        Tue,  8 Dec 2020 16:28:53 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:28:52 -0800 (PST)
Message-Id: <20201208.162852.2205708169665484487.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        soheil@google.com, ncardwell@google.com, ycheng@google.com,
        abuehaze@amazon.com
Subject: Re: [PATCH net] tcp: select sane initial rcvq_space.space for big
 MSS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208162131.313635-1-eric.dumazet@gmail.com>
References: <20201208162131.313635-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:28:53 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue,  8 Dec 2020 08:21:31 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> Before commit a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> small tcp_rmem[1] values were overridden by tcp_fixup_rcvbuf() to accommodate various MSS.
> 
> This is no longer the case, and Hazem Mohamed Abuelfotoh reported
> that DRS would not work for MTU 9000 endpoints receiving regular (1500 bytes) frames.
> 
> Root cause is that tcp_init_buffer_space() uses tp->rcv_wnd for upper limit
> of rcvq_space.space computation, while it can select later a smaller
> value for tp->rcv_ssthresh and tp->window_clamp.
> 
> ss -temoi on receiver would show :
> 
> skmem:(r0,rb131072,t0,tb46080,f0,w0,o0,bl0,d0) rcv_space:62496 rcv_ssthresh:56596
> 
> This means that TCP can not increase its window in tcp_grow_window(),
> and that DRS can never kick.
> 
> Fix this by making sure that rcvq_space.space is not bigger than number of bytes
> that can be held in TCP receive queue.
> 
> People unable/unwilling to change their kernel can work around this issue by
> selecting a bigger tcp_rmem[1] value as in :
> 
> echo "4096 196608 6291456" >/proc/sys/net/ipv4/tcp_rmem
> 
> Based on an initial report and patch from Hazem Mohamed Abuelfotoh
>  https://lore.kernel.org/netdev/20201204180622.14285-1-abuehaze@amazon.com/
> 
> Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
> Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
