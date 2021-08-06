Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743C23E31DB
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbhHFWmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242484AbhHFWmo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DCC860EE7;
        Fri,  6 Aug 2021 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628289748;
        bh=AXfG4bL+S5KpiWpdKgIENx9EqmoykkbhVX5F/NL+Vss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j8t+HZ56qH16mzBQSBeshmeB3gqT8o+jz8WjbYOPROwvGev0cbxvgGFiDTjNkZHJZ
         xwy7HN5vB9S20So7fNpTcE8M0pB9DE0osori9dkYh4vQeL5UGJmsetkhtzILB3HrR8
         46Y3+KJrghpiDLvtaTD62AUgFbnBi9wtcbEmyncCAluPPQJD5B3BUOoo5k+ajzL7dc
         5o5pL+EsozOPLGvCs3fcb0uKtzh7XMw4/D1jSXkCmMNY38qtATC/slMwIImUaLhZ0s
         UMRGUGTGi5mGaHUdHphG7bX19pkN9d4OiuSvnZlqdu601PhNZbhZVMPexrYcbn+eOv
         gS4vdSRUe+f5g==
Date:   Fri, 6 Aug 2021 15:42:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH NET] vrf: fix null pointer dereference in
 vrf_finish_output()
Message-ID: <20210806154227.49ac089d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5ba67c28-1056-e24d-cad3-4b7aaac01111@virtuozzo.com>
References: <20210806.111412.1329682129695306949.davem@davemloft.net>
        <5ba67c28-1056-e24d-cad3-4b7aaac01111@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 15:53:00 +0300 Vasily Averin wrote:
> After 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
> skb->dev  is accessed after skb free.
> Let's replace skb->dev by dev = skb_dst(skb)->dev:
> vrf_finish_output() is only called from vrf_output(),
> it set skb->dev to skb_dst(skb)->dev and calls POSTROUTING netfilter
> hooks, where output device should not be changed.
> 
> Fixes: 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks for following up! I decided to pick a similar patch from Dan
Carpenter [1] because the chunk quoted below is not really necessary.

[1] https://lore.kernel.org/kernel-janitors/20210806150435.GB15586@kili/

> @@ -883,7 +883,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
>  	}
>  
>  	rcu_read_unlock_bh();
> -	vrf_tx_error(skb->dev, skb);
> +	vrf_tx_error(dev, skb);
>  	return -EINVAL;
>  }
>  

