Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E09D2F04E0
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAJD1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAJD1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:27:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C97C8229C4;
        Sun, 10 Jan 2021 03:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610249224;
        bh=Uic+0LRNxWzv++QYnBmc9MDz8Rfd+71nxprZcQI82Js=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+ypcv/a3t5zekJqpLmJlxSBIW39God7frh+I+qCWoGFwg6PjpBBAd/mYqM7m92Xy
         wBNCGjMFca0AE5WLFjr49nP634gVRn68xMDmIlzXEFMLG7EMtV//l5k+tzpd7aHGrh
         KOCdLXkL7Gt2zYGF4+08WRg03e/P9vTg++H27UNituVlrJZObX4N0WqMfzf+HviY+o
         RUdGZ7UuL0N7lPYFPNsrOV4ayIpkoBd8WDLQ1Evb0/fcUuVvxs0Fb860xO+SzjxuBB
         EGFBuZldJxRCkf0+R8DDm1ILWPv7rLPLFTCPXJfPi94cAbNzQRO54Oxd8e1KsDv0m9
         2tNY0zd/VyX/g==
Date:   Sat, 9 Jan 2021 19:27:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin B Shelar <pbshelar@fb.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <laforge@gnumonks.org>, <jonas@norrbonn.se>, <pravin.ovn@gmail.com>
Subject: Re: [PATCH net-next v4] GTP: add support for flow based tunneling
 API
Message-ID: <20210109192702.1b88a25a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106044505.47535-1-pbshelar@fb.com>
References: <20210106044505.47535-1-pbshelar@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 20:45:05 -0800 Pravin B Shelar wrote:
> @@ -477,40 +572,99 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
>  			     struct gtp_pktinfo *pktinfo)
>  {
>  	struct gtp_dev *gtp = netdev_priv(dev);
> +	struct gtpu_metadata *opts = NULL;
>  	struct pdp_ctx *pctx;
>  	struct rtable *rt;
>  	struct flowi4 fl4;
> -	struct iphdr *iph;
> -	__be16 df;
> +	struct sock *sk = NULL;
> +	__be32 tun_id;
> +	__be32 daddr;
> +	__be32 saddr;
> +	u8 gtp_version;
>  	int mtu;
> +	__u8 tos;
> +	__be16 df = 0;

Please hold rev xmas tree.

> @@ -706,6 +895,7 @@ static void gtp_dellink(struct net_device *dev, struct list_head *head)
>  			pdp_context_delete(pctx);
>  
>  	list_del_rcu(&gtp->list);
> +
>  	unregister_netdevice_queue(dev, head);
>  }
>  

Unrelated whitespace change.
