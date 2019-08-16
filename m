Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB148F96C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 05:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHPDYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 23:24:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41029 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfHPDY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 23:24:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so1854123pls.8
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 20:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cN+7rGP0xjUhYzQcCZSy/Mfo1mEBhFYPPci5RZZdT5I=;
        b=ASUjGWynpDIvUt4hrSrdD8SxCP2cQbR7KGEbUgdIiBdgR36JmBmdGJuflluHQEKh/3
         NNQ3mm5ZJO0OZjzeNn78QgzgY+sc6p1JfK1/58uEp5yj+IL41exXeZdetXFDmHAEw9Hw
         2RXi0qoqvKQSGiNnancVMx42lC0LXNhKlurbBVIYb6+aVDsiQgr9L8ky5AzeLe0gYI6K
         pUADaSoy7+cC+kck/HRlT3J00SMxpci8oZpXX4Vr9J3xOSAZNdgQVqoEQmyOW3dvIjax
         Rm0GTUnScOmGiIes5u+lC2T8jGT6nhajnaB/wpa+pQVJy2UaNhyEB7hD6D00ERszwwLu
         JnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cN+7rGP0xjUhYzQcCZSy/Mfo1mEBhFYPPci5RZZdT5I=;
        b=o4qIwCMIGhdAnrN4/8BuwFloUHSwsIXXKiRBWO8QbEc8j1zlWC0SRSFSVT2v7Y8XcH
         OAyUKVRG9EgKSDuUA1GTVO5Iy/HVVzeXdHQuxa3sCZ1ygHnZqfhpt2lnjkiPOyzGsoUc
         9WKrv0wFdpVcWXpcn5iVjEYGAwXFby8f7bwNrMWyhEBHjhPLWvCoftDy4MVIQ7iExcXE
         2K7mU4D4Q8BX32T5Jx8jIm5cyHyYik44+q8PuVJzyJj7+PQqH3WtEky6MhXdsi8xPTXS
         iuMskrt/YqUnD41I1ffz2MsZxnPLtj5uwAyaaNd9pxoatKdEvUAiW9qTtkw/XgmetqbC
         PNgA==
X-Gm-Message-State: APjAAAVjBY8e+EGGHUDSQftu7TXDCdh2/gwARo5zgGzpONcQEVE0FsIk
        XFQX0wicGVclNKM3uYgNRo0=
X-Google-Smtp-Source: APXvYqx6KqQrpywOD61GVBN8ca8dFdIH5FSkXKtzDV2Or1o+3OoREPcz4Vwp27yWu9ZMzw3xWdvnvQ==
X-Received: by 2002:a17:902:d890:: with SMTP id b16mr7073537plz.315.1565925869335;
        Thu, 15 Aug 2019 20:24:29 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u24sm3495750pgk.31.2019.08.15.20.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 20:24:28 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:24:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tunnel: fix dev null pointer dereference when send
 pkg larger than mtu in collect_md mode
Message-ID: <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for the review.
On Thu, Aug 15, 2019 at 11:16:58AM +0200, Eric Dumazet wrote:
> > diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> > index 38c02bb62e2c..c6713c7287df 100644
> > --- a/net/ipv4/ip_tunnel.c
> > +++ b/net/ipv4/ip_tunnel.c
> > @@ -597,6 +597,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
> >  		goto tx_error;
> >  	}
> >  
> > +	if (skb_dst(skb) && !skb_dst(skb)->dev)
> > +		skb_dst(skb)->dev = rt->dst.dev;
> > +
> 
> 
> IMO this looks wrong.
> This dst seems shared. 

If the dst is shared, it may cause some problem. Could you point me where the
dst may be shared possibly?

> Once set, we will reuse the same dev ?

If yes, how about just set the skb dst to rt->dst, as the
iptunnel_xmit would do later.

skb_dst_drop(skb);
skb_dst_set(skb, &rt->dst);

or do you have any other idea?
> 
> If intended, why not doing this in __metadata_dst_init() instead of in the fast path ?

I'm afraid we couldn't do this, I didn't find a way to init dev in
__metadata_dst_init(). Do you?

Thanks
Hangbin
