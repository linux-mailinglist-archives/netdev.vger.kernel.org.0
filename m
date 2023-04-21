Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489F76EA25F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjDUDdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjDUDda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F1F213D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 20:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A10664D8E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B84C433EF;
        Fri, 21 Apr 2023 03:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682048005;
        bh=QNCwA1j6xFn1l3sCa3C+089KKEf2uImL+6/5gQiyowU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QGZAgL1urdvcHYAlsnpIf82vGpjIuf9++/xW0HtTIc2mRf+e7eu3EP/vTK4tgze2x
         7z18LfdvHCQhap96EFBNOZWdZqP9hE7aCP1DbUB6pN7IgylZ1mGKdtjSyRkxeWmQig
         2R0UkOu7rvH3vQ8/akpYT7LOwtxiAFu/LYNGS8M57rf9uy274ta1ZXUrmADmUwRtEL
         GkFe6YwE7sqXOvjoI8fZI4XXFFl0CNvefD95UNtptYhEAMNIJXCH8YPL7uceNN3Knl
         kF0z9N1oM3pDhX9hWL8togJ3XH66CNcGuNvtHwimKBack7wwGih1GKokp4LMP+Iqky
         jOMlwMmWKB8bw==
Date:   Thu, 20 Apr 2023 20:33:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        Johannes Berg <johannes.berg@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Brad Spencer <bspencer@blackberry.com>
Subject: Re: [PATCH v2 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
Message-ID: <20230420203324.04c50e8d@kernel.org>
In-Reply-To: <20230420233351.77166-1-kuniyu@amazon.com>
References: <20230420233351.77166-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 16:33:51 -0700 Kuniyuki Iwashima wrote:
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index f365dfdd672d..5c0d17b3984c 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1742,7 +1742,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
>  {
>  	struct sock *sk = sock->sk;
>  	struct netlink_sock *nlk = nlk_sk(sk);
> -	int len, val, err;
> +	int len, val;
>  
>  	if (level != SOL_NETLINK)
>  		return -ENOPROTOOPT;
> @@ -1753,40 +1753,27 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
>  		return -EINVAL;
>  
>  	switch (optname) {
> -	case NETLINK_PKTINFO:
> +	case NETLINK_LIST_MEMBERSHIPS:
> +		break;
> +	default:
>  		if (len < sizeof(int))
>  			return -EINVAL;
>  		len = sizeof(int);
> +	}


> -		err = 0;
>  		break;
>  	default:
> -		err = -ENOPROTOOPT;
> +		return -ENOPROTOOPT;
>  	}
> -	return err;
> +
> +	if (put_user(len, optlen) ||
> +	    copy_to_user(optval, &val, len))
> +		return -EFAULT;

Maybe this is a nit pick but we'd unnecessarily change the return value
to unknown opts when len < 4, from -ENOPROTOOPT to -EINVAL, right?

How about we do:

	unsigned int flag;

	flag = 0;
	switch (optname) {
	case NETLINK_PKTINFO:
		flag = NETLINK_F_RECV_PKTINFO;
 		break;
 	case NETLINK_BROADCAST_ERROR:
		flag = NETLINK_F_BROADCAST_SEND_ERROR;
		break;
	...
	case NETLINK_LIST_MEMBERSHIPS: {
	...
	default:
		return -ENOPROTOOPT;
	}

	if (flag) {
		if (len < sizeof(int))
			return -EINVAL;
		len = sizeof(int);
 		val = nlk->flags & flag ? 1 : 0;
		if (put_user(len, optlen) || 
		    copy_to_user(optval, &val, len))
			return -EFAULT;
		...
	}
