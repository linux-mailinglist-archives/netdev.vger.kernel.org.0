Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E953118C302
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgCSWcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:32:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37780 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCSWcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:32:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id f16so1675676plj.4;
        Thu, 19 Mar 2020 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yn0bvtfI8PGAgDPeIqZITACHOyKmYANGVfVMnX+ajjU=;
        b=uUxrCcsIYetoQfJZB1E6FdPnZjhbcGtFhytVv34E5uYmR+052Pi6qkvIVIv1Y3CsxJ
         QvQagoStq7ECjCxDrfzLB0cZTRkn3YYKfL7dtZeNU8Ii1QGv9UMRxkcf1TcVGaT+3P9F
         IvGQXXw0N4GQMESv2xplDdNb1bdjUqYEoUet/IWMhX6B+MDmBpTZS4zrUaxJRvABNQRR
         n+qRXN2YXPvXc2+vc6yD1vuDfmBbkuupEW35OSSLfj7tJUp2Y6UJxQe9zZDbI9RLUpbO
         uwjBWL5CwdbroosBt1hnrdCBWQ70AkQQ/ccFuWlHXwn9FqnpHFJOziqJJEtyC23RYHQX
         NYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yn0bvtfI8PGAgDPeIqZITACHOyKmYANGVfVMnX+ajjU=;
        b=PHjlOi7IjtXplWNfZ/wT7mYLz5UmD/2e3I9OUu2kK2hzyZUjsaND4euBXVRLw9kSaP
         k7WAP0j8BYq6oC4434XorVC7wS54A0R+zy7DrzGiCdQ/BUG5+1ROW/5Uxb6IDQyx8Jr3
         cQqKmEDa9wz4i89wxv8PESLG03KW2I79iOXki8k9gjWBJvdynUdoIk/mfW8CHo4YfEyu
         GyThvx7zyiV6rLZ2VopcASqlAxO34iRZ4k9llVt2bw4rm2Sm+HcDJA4i4ZGsnKTrQ8Jx
         9Rv+pggXF0uGL1clbNgAw10Jbpzx2ffjGtbSvcVwygwWIZz9JcbpSCFhek2CvSMjNezM
         gbQw==
X-Gm-Message-State: ANhLgQ1t1ICW3jzxot/nZ6+u4SCDwZl7hSSYcearBMK8q6fWh4bCeqLn
        ihN3FGkNCHbwpUZIDCKKuJkELcJn
X-Google-Smtp-Source: ADFU+vutLiD6fSLkHPNxhyuU7XKmRhjj+YP3VQriWyRk7yWl94rVBiIaemgaT8zPWHgF9CLlaTcLzQ==
X-Received: by 2002:a17:90a:8806:: with SMTP id s6mr6191359pjn.141.1584657138404;
        Thu, 19 Mar 2020 15:32:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e986:7672:8e0d:7fbd? ([2601:282:803:7700:e986:7672:8e0d:7fbd])
        by smtp.googlemail.com with ESMTPSA id fz3sm3025898pjb.41.2020.03.19.15.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 15:32:17 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix a RCU-list bug in inet_dump_fib()
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     alexander.h.duyck@linux.intel.com, kuznet@ms2.inr.ac.ru,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200319221141.8814-1-cai@lca.pw>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3804be39-c185-592d-852d-3e91d4231b55@gmail.com>
Date:   Thu, 19 Mar 2020 16:32:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319221141.8814-1-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 4:11 PM, Qian Cai wrote:
> There is a place,
> 
> inet_dump_fib()
>   fib_table_dump
>     fn_trie_dump_leaf()
>       hlist_for_each_entry_rcu()
> 
> without rcu_read_lock() triggers a warning,
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

Fixes: 18a8021a7be3 ("net/ipv4: Plumb support for filtering route dumps")

but you have a problem below ...

> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  net/ipv4/fib_frontend.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 577db1d50a24..5e441282d647 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -987,6 +987,8 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
>  	if (filter.flags & RTM_F_PREFIX)
>  		return skb->len;
>  
> +	rcu_read_lock();
> +
>  	if (filter.table_id) {
>  		tb = fib_get_table(net, filter.table_id);
>  		if (!tb) {

this branch has 2 return points which now have rcu_read_lock; you should
have seen this when you tested the change..


