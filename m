Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E371929839D
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418808AbgJYVFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732087AbgJYVFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 17:05:51 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F49A208B3;
        Sun, 25 Oct 2020 21:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603659951;
        bh=IWC2mraHXvnqqlJMze8XJ+U0kgMd9LFfpNCR3i6fDIo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uWHea8p+7opOynJtqFWPn/s1B+iCnWK7cfsioBC1gYVa7KRq2d18e6Py2SUzZGM4h
         Ioq5Bz0GwqoNGjUJWhRSP2qyZbfaIi9X5QvdbWrkvYetrJ9tAJn3mFGa3AZhPpzZMy
         BV5YbX24XN9q/skkSEka9J1OwNzS+Jd88DG5GeI8=
Date:   Sun, 25 Oct 2020 14:05:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Schultz <aschultz@tpip.net>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] gtp: fix an use-before-init in gtp_newlink()
Message-ID: <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201024154233.4024-1-fujiwara.masahiro@gmail.com>
References: <20201024154233.4024-1-fujiwara.masahiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Oct 2020 15:42:33 +0000 Masahiro Fujiwara wrote:
> *_pdp_find() from gtp_encap_recv() would trigger a crash when a peer
> sends GTP packets while creating new GTP device.
> 
> RIP: 0010:gtp1_pdp_find.isra.0+0x68/0x90 [gtp]
> <SNIP>
> Call Trace:
>  <IRQ>
>  gtp_encap_recv+0xc2/0x2e0 [gtp]
>  ? gtp1_pdp_find.isra.0+0x90/0x90 [gtp]
>  udp_queue_rcv_one_skb+0x1fe/0x530
>  udp_queue_rcv_skb+0x40/0x1b0
>  udp_unicast_rcv_skb.isra.0+0x78/0x90
>  __udp4_lib_rcv+0x5af/0xc70
>  udp_rcv+0x1a/0x20
>  ip_protocol_deliver_rcu+0xc5/0x1b0
>  ip_local_deliver_finish+0x48/0x50
>  ip_local_deliver+0xe5/0xf0
>  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
> 
> gtp_encap_enable() should be called after gtp_hastable_new() otherwise
> *_pdp_find() will access the uninitialized hash table.

Looks good, minor nits:
 
 - is the time zone broken on your system? Looks like your email has
   arrived with the date far in the past, so the build systems have
   missed it. Could you double check the time on your system?

> Fixes: 1e3a3abd8 ("gtp: make GTP sockets in gtp_newlink optional")

The hash looks short, should be at lest 12 chars:

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")

> Signed-off-by: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>

> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 8e47d0112e5d..6c56337b02a3 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -663,10 +663,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  
>  	gtp = netdev_priv(dev);
>  
> -	err = gtp_encap_enable(gtp, data);
> -	if (err < 0)
> -		return err;
> -
>  	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
>  		hashsize = 1024;
>  	} else {
> @@ -676,13 +672,18 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  	}
>  
>  	err = gtp_hashtable_new(gtp, hashsize);
> +	if (err < 0) {
> +		return err;
> +	}

no need for braces around single statement

> +
> +	err = gtp_encap_enable(gtp, data);
>  	if (err < 0)
>  		goto out_encap;
>  
>  	err = register_netdevice(dev);
>  	if (err < 0) {
>  		netdev_dbg(dev, "failed to register new netdev %d\n", err);
> -		goto out_hashtable;
> +		goto out_encap;
>  	}
>  
>  	gn = net_generic(dev_net(dev), gtp_net_id);
> @@ -693,11 +694,10 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  
>  	return 0;
>  
> -out_hashtable:
> -	kfree(gtp->addr_hash);
> -	kfree(gtp->tid_hash);
>  out_encap:
>  	gtp_encap_disable(gtp);

I'd personally move the out_hashtable: label here and keep it, just for
clarity. Otherwise reader has to double check that gtp_encap_disable()
can be safely called before gtp_encap_enable().

Also gtp_encap_disable() could change in the future breaking this
assumption.

> +	kfree(gtp->addr_hash);
> +	kfree(gtp->tid_hash);
>  	return err;
>  }
>  

