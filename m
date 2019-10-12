Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542E9D4F3B
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfJLLGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:06:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44452 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfJLLGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 07:06:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so5675945pll.11;
        Sat, 12 Oct 2019 04:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b35Ed/9iBBnm16JltqLPFC1hR6kvSZ6NR0s4StD621s=;
        b=Mnot09YNCMIrjLeZoj3eHMWwG/oNPnDYe36oOvVR4bLt1an75r1pejQVnwosgYcdDC
         D81RHP8k1w/WoBA6/MjQ14Rt9zGrdZCrh157sbbxCDxvWNyISBkz42sxiCtmsFhLgtGF
         /9IBPERa08PnBBfUPpf+x8STt3/nZwYQL6wF0QII/DQQFqiwAfxtwVtvtujH9WIkEehG
         rkHOZq4jE9UpYmQKOjoL8QTKCB9VVBEBkkEt7jmlNeF0r2pvLsc+XTZ9yEliX6Nnb2jz
         pWEt0Xekr+k24nRtBcSvnWHuPgmwOsxohZ/qFzdC402sRNCU8wDpGvEJiWuia/Ysn0hi
         SwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b35Ed/9iBBnm16JltqLPFC1hR6kvSZ6NR0s4StD621s=;
        b=KgsG3d3Ps6059E4rq3TJ6qLR86QeuEsJSVo945Y7tOmU84xFvVMov/07z2QupSlawP
         rpy9iSYo2l3kKuZgzC7qnQ0PpqIKN5FdCHPljZJIJ1akZY/fFOGYOWM1hhu6YvsZoru/
         IHq+sIXrACtVHlGL2s0gw1abqQuEyCDSZC1luLNweYLb9QCTmidJp12qaOaJ49UYLNoB
         Hh/JahPQptAKYu1O92TG5zAtTst5ml65CMIZVjVusfWlTQWpL9anDijvSoDgVOZ0WoU7
         UoHp311WrVNPjnH/RwbPzsWkaqwgcw9CNqnvUDcF6WS/0qwpNjvjqOumK+jg16ZYNrra
         0Dpw==
X-Gm-Message-State: APjAAAV61KJNoCtqi7wF97WTaw1jJdO4tTc8zKuo61QaNvmaQFl3IgYi
        z0IN9n6QkSkSRK79f7fcOkkwb/bC
X-Google-Smtp-Source: APXvYqzI/Dkq4rDjnCb+lKTdis8BUFpR5tyFOSG4JhvYrFH8f/bBFAllmFQax2jVlE1IWOdwNIPm5Q==
X-Received: by 2002:a17:902:a584:: with SMTP id az4mr19186745plb.74.1570878370004;
        Sat, 12 Oct 2019 04:06:10 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id l21sm11721302pgm.55.2019.10.12.04.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2019 04:06:09 -0700 (PDT)
Subject: Re: [PATCH net] rxrpc: Fix possible NULL pointer access in ICMP
 handling
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
References: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
 <bf358fc5-c0e1-070f-b073-1675e3d13fd8@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bbf115d1-8197-426c-cbe8-bd1f5cff2041@gmail.com>
Date:   Sat, 12 Oct 2019 04:06:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bf358fc5-c0e1-070f-b073-1675e3d13fd8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/19 3:49 AM, Eric Dumazet wrote:

> 
> Okay, but we also need this.
> 
> diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
> index c97ebdc043e44525eaecdd54bc447c1895bdca74..38db10e61f7a5cb50f9ee036b5e16ec284e723ac 100644
> --- a/net/rxrpc/peer_event.c
> +++ b/net/rxrpc/peer_event.c
> @@ -145,9 +145,9 @@ static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, struct sock_exterr_skb *se
>   */
>  void rxrpc_error_report(struct sock *sk)
>  {
> +       struct rxrpc_local *local = rcu_dereference_sk_user_data(sk);
>         struct sock_exterr_skb *serr;
>         struct sockaddr_rxrpc srx;
> -       struct rxrpc_local *local = sk->sk_user_data;
>         struct rxrpc_peer *peer;
>         struct sk_buff *skb;
> 

I will psubmit the patch later once David pushes his net tree, since I do not know yet
the sha1 of your patch (to provide a proper Fixes: tag)
