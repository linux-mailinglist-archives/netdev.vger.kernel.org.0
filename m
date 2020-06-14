Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678BF1F8B05
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 23:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgFNV4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 17:56:38 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:46730 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbgFNV4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 17:56:38 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05ELuIDW016346;
        Sun, 14 Jun 2020 23:56:23 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id EE0A8120925;
        Sun, 14 Jun 2020 23:56:13 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592171774; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JFmA7zQmwjamZvBBzBcAWOqtcPJgeXHYUvuSuVxnic=;
        b=T/g7DF0hX49XAr/jZkQc4sR1ST6F6ytA011Dlcs4i+2Nj/z5Kj3w66bLVVfqGKX59SF1ap
        hjTQUWEXGC07lDAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592171774; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JFmA7zQmwjamZvBBzBcAWOqtcPJgeXHYUvuSuVxnic=;
        b=tnha29J3cd5QfC0yMck+H910Xz4i3OVWnzUBgMDCnLmn/q2eo2B1EevHVnmUoK4S+nBijZ
        40fvMolW3egtHBcKZXInfcV+zAduwF6a0IW4IDuk4tS8gHIUS1VNctbjYOSCp6+wFRx6g1
        uvghRvCLGWVymAxDw9OK75NCkxx0+IkNKHABKCxnhV6Thcm206BYr0qDALwtWEYhD75HIJ
        +kSg7xcHFzAqgr5dyQ4ukE6FSww32Pp74BfTGMIraq5nCqPctIDV9ZlhdEK7OWxmCBZU0e
        AOuLT9w2oMn3adAHWhQSrC3r9znEwxHZZEXuCXcv6PwwRYN4L8ydgFFP5lt7Xw==
Date:   Sun, 14 Jun 2020 23:56:13 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC,net-next, 1/5] l3mdev: add infrastructure for table to VRF
 mapping
Message-Id: <20200614235613.b16ef9bad3e93b8727a80abe@uniroma2.it>
In-Reply-To: <983c5d6b-5366-dfd3-eab2-2727e056d5c5@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-2-andrea.mayer@uniroma2.it>
        <983c5d6b-5366-dfd3-eab2-2727e056d5c5@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jun 2020 18:37:09 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/12/20 10:49 AM, Andrea Mayer wrote:
> > @@ -37,6 +45,15 @@ struct l3mdev_ops {
> >  
> >  #ifdef CONFIG_NET_L3_MASTER_DEV
> >  
> > +int l3mdev_table_lookup_register(enum l3mdev_type l3type,
> > +				 int (*fn)(struct net *net, u32 table_id));
> > +
> > +void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
> > +				    int (*fn)(struct net *net, u32 table_id));
> > +
> > +int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
> > +				      u32 table_id);
> > +
> >  int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
> >  			  struct fib_lookup_arg *arg);
> >  
> > @@ -280,6 +297,26 @@ struct sk_buff *l3mdev_ip6_out(struct sock *sk, struct sk_buff *skb)
> >  	return skb;
> >  }
> >  
> > +static inline
> > +int l3mdev_table_lookup_register(enum l3mdev_type l3type,
> > +				 int (*fn)(struct net *net, u32 table_id))
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static inline
> > +void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
> > +				    int (*fn)(struct net *net, u32 table_id))
> > +{
> > +}
> > +
> > +static inline
> > +int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
> > +				      u32 table_id)
> > +{
> > +	return -ENODEV;
> > +}
> > +
> >  static inline
> >  int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
> >  			  struct fib_lookup_arg *arg)
> > diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
> > index f35899d45a9a..6cc1fe7eb039 100644
> > --- a/net/l3mdev/l3mdev.c
> > +++ b/net/l3mdev/l3mdev.c
> > @@ -9,6 +9,101 @@
> >  #include <net/fib_rules.h>
> >  #include <net/l3mdev.h>
> >  
> > +DEFINE_SPINLOCK(l3mdev_lock);
> > +
> > +typedef int (*lookup_by_table_id_t)(struct net *net, u32 table_d);
> > +
> 
> I should have caught this earlier. Move lookup_by_table_id_t to l3mdev.h
> and use above for 'fn' in l3mdev_table_lookup_{un,}register
> 

Hi David,
Ok, I will do it!

Thank you,
Andrea
