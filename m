Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD133B0AF3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFVQ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhFVQ7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E931061369;
        Tue, 22 Jun 2021 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624381046;
        bh=yUq4JYJYlD7jBtewVG1I0RUDC2YyvvmYkXwvuBoEn60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CIonhWyBtNNSTOMQw0UttsdSbkMwLUuxOQOAS2RvtLxwGeyKRt+bjMTMYOCGZXo4K
         kaZXw0lONuSzBZOxlAtAgApp/AU+j2Y4Z1I5Ty3BN1V3KANugj4qGSBg3dKg+rAxUe
         IqMQZozFKGLqaQkyyeMvyjN8Nh5zkL4QpPcpWpLcnoA6t26e9rdAiwUM8MmtNkrUjZ
         weRrsIkImds+e7UFIufxLpU8eje17XM7HIpFG1oJDkhghnn9IwtuBFK9PsVzEeGx3m
         ce9IThwMYoRHpqOO3db2R52yCYoD32ONeEp0PHu9UyufKFfuRg7cBQh6UlswILdEfm
         frmq47ZwgqisQ==
Date:   Tue, 22 Jun 2021 09:57:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622095725.53fbf399@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <fe0640023aa1142300651a32833ec44340b62943.camel@redhat.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <fe0640023aa1142300651a32833ec44340b62943.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 12:07:27 +0200 Paolo Abeni wrote:
> On Mon, 2021-06-21 at 16:13 -0700, Jakub Kicinski wrote:
> > Dave observed number of machines hitting OOM on the UDP send
> > path. The workload seems to be sending large UDP packets over
> > loopback. Since loopback has MTU of 64k kernel will try to
> > allocate an skb with up to 64k of head space. This has a good
> > chance of failing under memory pressure. What's worse if
> > the message length is <32k the allocation may trigger an
> > OOM killer.  
> 
> Out of sheer curiosity, are there a large number of UDP sockets in such
> workload? did you increase rmem_default/rmem_max? If so, could tuning
> udp_mem help?

It's a handful of sockets, < 10.

> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index c3efc7d658f6..a300c2c65d57 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
> >  				alloclen += rt->dst.trailer_len;
> >  
> >  			if (transhdrlen) {
> > -				skb = sock_alloc_send_skb(sk,
> > -						alloclen + hh_len + 15,
> > +				size_t header_len = alloclen + hh_len + 15;
> > +				gfp_t sk_allocation;
> > +
> > +				if (header_len > PAGE_SIZE)
> > +					sk_allocation_push(sk, __GFP_NORETRY,
> > +							   &sk_allocation);  
> 
> Could an additional __GFP_NOWARN be relevant here?

We always set GFP_NOWARN for heads thru kmalloc_reserve().
