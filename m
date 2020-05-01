Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355CC1C2061
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgEAWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgEAWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:10:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E5EC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:10:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1CDE14EFC22B;
        Fri,  1 May 2020 15:10:13 -0700 (PDT)
Date:   Fri, 01 May 2020 15:10:11 -0700 (PDT)
Message-Id: <20200501.151011.1971671220831427146.davem@davemloft.net>
To:     lesedorucalin01@gmail.com
Cc:     pabeni@redhat.com, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v5] net: Option to retrieve the pending data from send
 queue of UDP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423221515.GA4335@white>
References: <20200423221515.GA4335@white>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:10:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lese Doru Calin <lesedorucalin01@gmail.com>
Date: Fri, 24 Apr 2020 01:15:15 +0300

> @@ -1794,18 +1924,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  
>  	sock_recv_ts_and_drops(msg, sk, skb);
>  
> -	/* Copy the address. */
> -	if (sin) {
> -		sin->sin_family = AF_INET;
> -		sin->sin_port = udp_hdr(skb)->source;
> -		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
> -		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> -		*addr_len = sizeof(*sin);
> -
> -		if (cgroup_bpf_enabled)
> -			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
> -							(struct sockaddr *)sin);
> -	}
> +	udp_set_source_addr(sk, msg, addr_len, ip_hdr(skb)->saddr,
> +			    udp_hdr(skb)->source);

The 'sin' variable is no longer used, please remove it.
