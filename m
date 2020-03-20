Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B880518D2C6
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgCTPYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:24:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38125 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgCTPYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:24:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id z5so3393995pfn.5;
        Fri, 20 Mar 2020 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s6Mo0FFP1u/jmvNK2mj/w2RqZ5Bkfge0hzzPwVp0Las=;
        b=YAGb51BwWc/Yc+CpI+3qhZqgm0rEkKL36nWAK3gwD+r13+B+a7Y63a905YnGMzEzSR
         2epk7QRz2RSGVfHlM2wsmF2zP+0D9Ri2XEjnZ+3zy2gmco8GeNqfHJE3UqxZpRL48HKW
         VRp6ymQhtiQ2/GUmYwmRB/fScxhFXfQmb6v9GQj133DFZ1OqpBl8vS9gnIB9T7KhKmBT
         kb59mBvHtiEb3OMZSJpXs5/oETdl8JOYHPIbjwkWukUOO3I8N/z8o1/lEslXBBc8H41Z
         F02WtJHog0ruNiqQI3WW22GVBOGuF+pccENXIdq1ywUJjtPiXRavHMzfhKhbVwFWwokS
         Znmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6Mo0FFP1u/jmvNK2mj/w2RqZ5Bkfge0hzzPwVp0Las=;
        b=Fg8E0c8mA85g5KZ0h5iqj6RWnI9Px5hr7voes4QjHK51x25maIbWBLVFbaHXIohbAR
         0oUGjNsN4alWD62bMzcV5jKLjl1VaiicoXY59YXXPT8pJNOIh/uC/1oXNbj0OaV1L48D
         zRo57wPjQHI+PLjp/nHbPzd8hXCUGMQNYjKYGu0Clj+/NRjjfN6M1tsSAU4TMuwNbqJk
         fUV9RyK4jNVWVhSB1fTEszHECFT0Om13qqMW1u25w76b2uKLvGExQtVMMui9L4HFaVSZ
         Ojl1kLafaWI9FE3Du5Z5r9SQ7f3dLB9MLfpGopHBtaU6Bvu4/Mc1dQ/P9hobAqPokYJB
         JxDQ==
X-Gm-Message-State: ANhLgQ0mQg6Rzl36VLXhO5F0q5xubFCAqun4BWt4KCvskphRMnBcTItJ
        jAEgP9QG3C27Rpp6ohzCHHIEGqCM
X-Google-Smtp-Source: ADFU+vtDBZzR+E1LIguylmsDl/3itA3g0GxqLTjbgZfBSgyOglXJHbuypbTHv5uECriPBjFwQtj8cA==
X-Received: by 2002:a62:8684:: with SMTP id x126mr10168390pfd.160.1584717840483;
        Fri, 20 Mar 2020 08:24:00 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e9f2:4948:e013:782b? ([2601:282:803:7700:e9f2:4948:e013:782b])
        by smtp.googlemail.com with ESMTPSA id gv7sm5220217pjb.16.2020.03.20.08.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 08:23:59 -0700 (PDT)
Subject: Re: [PATCH v2] ipv4: fix a RCU-list lock in inet_dump_fib()
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     alexander.h.duyck@linux.intel.com, kuznet@ms2.inr.ac.ru,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200320025421.9216-1-cai@lca.pw>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a90ddf03-f321-19ef-290a-673663992b33@gmail.com>
Date:   Fri, 20 Mar 2020 09:23:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320025421.9216-1-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 8:54 PM, Qian Cai wrote:
> There is a place,
> 
> inet_dump_fib()
>   fib_table_dump
>     fn_trie_dump_leaf()
>       hlist_for_each_entry_rcu()
> 
> without rcu_read_lock() will trigger a warning,
> 
>  WARNING: suspicious RCU usage
>  -----------------------------
>  net/ipv4/fib_trie.c:2216 RCU-list traversed in non-reader section!!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 2, debug_locks = 1
>  1 lock held by ip/1923:
>   #0: ffffffff8ce76e40 (rtnl_mutex){+.+.}, at: netlink_dump+0xd6/0x840
> 
>  Call Trace:
>   dump_stack+0xa1/0xea
>   lockdep_rcu_suspicious+0x103/0x10d
>   fn_trie_dump_leaf+0x581/0x590
>   fib_table_dump+0x15f/0x220
>   inet_dump_fib+0x4ad/0x5d0
>   netlink_dump+0x350/0x840
>   __netlink_dump_start+0x315/0x3e0
>   rtnetlink_rcv_msg+0x4d1/0x720
>   netlink_rcv_skb+0xf0/0x220
>   rtnetlink_rcv+0x15/0x20
>   netlink_unicast+0x306/0x460
>   netlink_sendmsg+0x44b/0x770
>   __sys_sendto+0x259/0x270
>   __x64_sys_sendto+0x80/0xa0
>   do_syscall_64+0x69/0xf4
>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Fixes: 18a8021a7be3 ("net/ipv4: Plumb support for filtering route dumps")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
> 
> v2: Call rcu_read_unlock() before returning.
>     Add a "Fixes" tag per David.
> 
>  net/ipv4/fib_frontend.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 577db1d50a24..213be9c050ad 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -997,7 +997,9 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
>  			return -ENOENT;
>  		}
>  
> +		rcu_read_lock();
>  		err = fib_table_dump(tb, skb, cb, &filter);
> +		rcu_read_unlock();
>  		return skb->len ? : err;
>  	}
>  
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

