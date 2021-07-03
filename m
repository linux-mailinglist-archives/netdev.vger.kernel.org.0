Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE23BAA5E
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhGCVwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 17:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhGCVwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 17:52:32 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84656C061762;
        Sat,  3 Jul 2021 14:49:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C45144D3131C8;
        Sat,  3 Jul 2021 14:49:49 -0700 (PDT)
Date:   Sat, 03 Jul 2021 14:49:45 -0700 (PDT)
Message-Id: <20210703.144945.1327654903412498334.davem@davemloft.net>
To:     phind.uet@gmail.com
Cc:     yhs@fb.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, ncardwell@google.com,
        yyd@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] tcp: fix tcp_init_transfer() to not reset
 icsk_ca_initialized
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210703093417.1569943-1-phind.uet@gmail.com>
References: <20210703093417.1569943-1-phind.uet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 03 Jul 2021 14:49:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>
Date: Sat,  3 Jul 2021 17:34:17 +0800

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 7d5e59f688de..855ada2be25e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
>  		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
>  	tp->snd_cwnd_stamp = tcp_jiffies32;
> 
> -	icsk->icsk_ca_initialized = 0;
>  	bpf_skops_established(sk, bpf_op, skb);
>  	if (!icsk->icsk_ca_initialized)
>  		tcp_init_congestion_control(sk);

Don't you have to make the tcp_init_congestion_control() call unconditional now?
