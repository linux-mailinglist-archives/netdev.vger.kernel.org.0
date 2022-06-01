Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9E539C4A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349559AbiFAEfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349553AbiFAEfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:35:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAB94D243;
        Tue, 31 May 2022 21:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7539CCE091C;
        Wed,  1 Jun 2022 04:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B1DC385A5;
        Wed,  1 Jun 2022 04:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654058102;
        bh=k4EuQkDYSzAkYwPH22pmDdWOjmPDDH1V9Dj2XG8IKs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b1S6GaoacgcOHBe1QCYWifE+JcY+iOIz3g9JWX6prMj4sVVYkZr3z72GPdmLCPGtd
         O/ccAgc1oohxRtkU4ZUWBPlRb6wOHWGnMdAqnGpPps5GmmuiwsHWAH84EeZ//frNkk
         t56B92nMBJyD6R0orTYRs+hl+Ipcd8jP7N1qLbe/DQJY8PSHrigOCmNSZdSMQA/zRD
         kxVTG+gmZzpvpmesM0dgLRb5A/9uZN3aHSxebQ/TZ+CfG96riY48njrYQYR/YVrM8c
         Y34bYTolhzOEeWHkL3CZIyd9OlEqeEa4zGFI1j0qoaOoJC5WUsX9FzbQVCPnpoimyz
         3GoyMmGtCuR4Q==
Date:   Tue, 31 May 2022 21:35:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v3] ipv6: Fix signed integer overflow in
 __ip6_append_data
Message-ID: <20220531213500.521ef5cc@kernel.org>
In-Reply-To: <20220528022312.2827597-1-wangyufen@huawei.com>
References: <20220528022312.2827597-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 May 2022 10:23:12 +0800 Wang Yufen wrote:
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 55afd7f39c04..91704bbc7715 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1308,7 +1308,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  	struct ipcm6_cookie ipc6;
>  	int addr_len = msg->msg_namelen;
>  	bool connected = false;
> -	int ulen = len;
> +	size_t ulen = len;
>  	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
>  	int err;
>  	int is_udplite = IS_UDPLITE(sk);

No need to change ulen neither, it will not overflow and will be
promoted to size_t when passed to ip6_append_data() / ip6_make_skb().
