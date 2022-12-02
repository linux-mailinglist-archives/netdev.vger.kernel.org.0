Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39AB6403F7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiLBKCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiLBKCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:02:40 -0500
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881A310B8;
        Fri,  2 Dec 2022 02:02:36 -0800 (PST)
Received: from momiji.horms.nl (86-93-216-223.fixed.kpn.net [86.93.216.223])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 7F991200A3;
        Fri,  2 Dec 2022 10:02:04 +0000 (UTC)
Received: by momiji.horms.nl (Postfix, from userid 7100)
        id 3436E9401C8; Fri,  2 Dec 2022 11:02:04 +0100 (CET)
Date:   Fri, 2 Dec 2022 11:02:04 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] ipvs: initialize 'ret' variable in do_ip_vs_set_ctl()
Message-ID: <Y4nNHHfIY7iEvMgr@vergenet.net>
References: <20221202032511.1435-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202032511.1435-1-liqiong@nfschina.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.7 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:25:11AM +0800, Li Qiong wrote:
> The 'ret' should need to be initialized to 0, in case
> return a uninitialized value because no default process
> for "switch (cmd)".
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>

Thanks,

I agree there seems to be a problem here.  But perhaps it's nicer to solve
it by adding a default case to the switch statement?

Also, if we update the declaration of ret, perhaps we could also move it to
the bottom of the declaration of local variables, to move more towards
reverse xmas tree order.

But to be honest, I don't feel strongly about either of these issues.

So if someone wants to take this patch as-is then feel free to add.

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 988222fff9f0..4b20db86077c 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2456,7 +2456,7 @@ static int
>  do_ip_vs_set_ctl(struct sock *sk, int cmd, sockptr_t ptr, unsigned int len)
>  {
>  	struct net *net = sock_net(sk);
> -	int ret;
> +	int ret = 0;
>  	unsigned char arg[MAX_SET_ARGLEN];
>  	struct ip_vs_service_user *usvc_compat;
>  	struct ip_vs_service_user_kern usvc;
> -- 
> 2.11.0
> 
