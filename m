Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3026E4C3C1B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiBYDBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiBYDBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109D027DF09;
        Thu, 24 Feb 2022 19:00:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D9CD61683;
        Fri, 25 Feb 2022 03:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFCBC340E9;
        Fri, 25 Feb 2022 03:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645758044;
        bh=AM7WkNQ/J9ykSGikSjl3kMHphOyMvG64ZQ99q8mtEvs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uo+h5JiA6aUw89qkWCkkOe6hWWpu63MemUZwuMwHPM7YSGAk65aH736HTVMQz5hB4
         21xXozHk/k+D3GDH/NjTivTJmKC3jKHMPE3gkaHBiQ+X1yOzBYJH0Lq4TZcfklo8N9
         UncPm9zbvKGV35/yeduK+Hi9YoFskXwOJDDH4YZFXvi6snQQqOOui9RHQ/y24JDGo9
         vNrT285Hpc2VWxHkT8ZlfQpaRf9ow40NCyZqkrxv4/9cn0be7m4vfjbo9KHxH1uQlo
         H1ccetnpkSByT7PgsHiHdQVx3918OMCttrJvMQuogAqZBpT249Heq99IXstoKBTiyO
         aQhpUfzNCaT+w==
Message-ID: <ed3e1f08-045c-1a9e-9319-5789faddc473@kernel.org>
Date:   Thu, 24 Feb 2022 20:00:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net/ip6mr: Fix build with !CONFIG_IPV6_PIMSM_V2
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20220223121721.421247-1-dima@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220223121721.421247-1-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/22 5:17 AM, Dmitry Safonov wrote:
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index a9775c830194..4e74bc61a3db 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -1653,7 +1653,6 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
>  	mifi_t mifi;
>  	struct net *net = sock_net(sk);
>  	struct mr_table *mrt;
> -	bool do_wrmifwhole;
>  
>  	if (sk->sk_type != SOCK_RAW ||
>  	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
> @@ -1761,6 +1760,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
>  #ifdef CONFIG_IPV6_PIMSM_V2
>  	case MRT6_PIM:
>  	{
> +		bool do_wrmifwhole;
>  		int v;
>  
>  		if (optlen != sizeof(v))
> 
> base-commit: 922ea87ff6f2b63f413c6afa2c25b287dce76639

you could do one better and move it under the
'if (v != mrt->mroute_do_pim) {'

so that the do_wrmifwhole check is only done when needed
