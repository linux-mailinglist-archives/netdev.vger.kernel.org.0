Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF3D62916D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiKOFQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKOFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:16:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4E61CB08
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373D061538
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2479BC433C1;
        Tue, 15 Nov 2022 05:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668489406;
        bh=eFIdt6wWHsqpSeL7qova1NSCZOGYjR0fW8koEkHwbmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hCzFLw0gwmvwpdQYms6gcAsBnDY6KkOagIGQZDY2rHB1bJd+a+bv5JW+85URkYQ79
         y36F7F5h2y/gEZnocBqQItabwLBqWwIzVcIVtg+LTBcLi2V1m09JiV8TAjk5WQgtZ7
         3av6Hn4HY2LtNP/JWnEkU6c6+vJ2Ra4xR2/jCYgOnzoo28k0DRJK4knojOdjejoVhk
         8qPv1m123fK9C/3YmLOBSX754YxllwmK0D2Ao8Ab71DVjEDinCv3/UkbkmP6UQlkya
         Z5G3ThBlJ55OwuSI8tVDvWhOeumJPUhRDotehrTfzb0iergkpuWDrFDwu4zGYUtFrd
         2myK0rU3svqQw==
Date:   Mon, 14 Nov 2022 21:16:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCHv2 net] net: use struct_group to copy addresses
Message-ID: <20221114211645.539397df@kernel.org>
In-Reply-To: <20221114081210.1033795-1-liuhangbin@gmail.com>
References: <20221114081210.1033795-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 16:12:10 +0800 Hangbin Liu wrote:
> diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
> index 961ec16a26b8..6f7e833a00f7 100644
> --- a/include/uapi/linux/ip.h
> +++ b/include/uapi/linux/ip.h
> @@ -100,8 +100,10 @@ struct iphdr {
>  	__u8	ttl;
>  	__u8	protocol;
>  	__sum16	check;
> -	__be32	saddr;
> -	__be32	daddr;
> +	struct_group(addrs,
> +		__be32	saddr;
> +		__be32	daddr;
> +	);
>  	/*The options start here. */
>  };
>  
> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> index 03cdbe798fe3..3a3a80496c7c 100644
> --- a/include/uapi/linux/ipv6.h
> +++ b/include/uapi/linux/ipv6.h
> @@ -130,8 +130,10 @@ struct ipv6hdr {
>  	__u8			nexthdr;
>  	__u8			hop_limit;
>  
> -	struct	in6_addr	saddr;
> -	struct	in6_addr	daddr;
> +	struct_group(addrs,
> +		struct	in6_addr	saddr;
> +		struct	in6_addr	daddr;
> +	);
>  };
>  

Can you double check the build with clang? It seems to fail with an odd
message, maybe some includes missing?

In file included from ./usr/include/linux/if_tunnel.h:7:
usr/include/linux/ip.h:103:2: error: type name requires a specifier or qualifier
        struct_group(addrs,
        ^
usr/include/linux/ip.h:104:3: error: unexpected type name '__be32': expected identifier
                __be32  saddr;
                ^
usr/include/linux/ip.h:104:10: error: expected ')'
                __be32  saddr;
                        ^
usr/include/linux/ip.h:103:14: note: to match this '('
        struct_group(addrs,
                    ^
usr/include/linux/ip.h:103:15: error: a parameter list without types is only allowed in a function definition
        struct_group(addrs,
                     ^
usr/include/linux/ip.h:106:2: error: type name requires a specifier or qualifier
        );
        ^
usr/include/linux/ip.h:106:2: error: expected member name or ';' after declaration specifiers
usr/include/linux/ip.h:105:16: error: expected ';' at end of declaration list
                __be32  daddr;
                              ^
                              ;
