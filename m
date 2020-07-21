Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E42289B2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgGUUSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:18:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:35228 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUUSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:18:11 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jxyi7-0001a2-3k; Tue, 21 Jul 2020 22:17:59 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jxyi6-000HIz-T8; Tue, 21 Jul 2020 22:17:58 +0200
Subject: Re: [PATCH bpf-next] bpf: Generate cookie for new non-initial net NS
To:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org, yhs@fb.com,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200720140919.22342-1-Jianlin.Lv@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <840a9007-3dcb-457f-8746-7f8e6fa209c5@iogearbox.net>
Date:   Tue, 21 Jul 2020 22:17:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200720140919.22342-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25880/Tue Jul 21 16:34:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 4:09 PM, Jianlin Lv wrote:
> For non-initial network NS, the net cookie is generated when
> bpf_get_netns_cookie_sock is called for the first time, but it is more
> reasonable to complete the cookie generation work when creating a new
> network NS, just like init_net.
> net_gen_cookie() be moved into setup_net() that it can serve the initial
> and non-initial network namespace.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>

What use-case are you trying to solve? Why should it be different than, say,
socket cookie generation? I'm currently not seeing much of a point in moving
this. When it's not used in the system, it would actually create more work.

> ---
>   net/core/net_namespace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index dcd61aca343e..5937bd0df56d 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -336,6 +336,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
>   	idr_init(&net->netns_ids);
>   	spin_lock_init(&net->nsid_lock);
>   	mutex_init(&net->ipv4.ra_mutex);
> +	net_gen_cookie(net);
>   
>   	list_for_each_entry(ops, &pernet_list, list) {
>   		error = ops_init(ops, net);
> @@ -1101,7 +1102,6 @@ static int __init net_ns_init(void)
>   		panic("Could not allocate generic netns");
>   
>   	rcu_assign_pointer(init_net.gen, ng);
> -	net_gen_cookie(&init_net);
>   
>   	down_write(&pernet_ops_rwsem);
>   	if (setup_net(&init_net, &init_user_ns))
> 

