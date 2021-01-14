Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9062F658E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbhANQQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:16:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbhANQQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:16:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610640883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qee0DcZxR0fVVmjSULZKOay9OvqVZKocCovyVyOW/28=;
        b=Ng4qymqHMaI7+5armBBRpRFqR+P3Fg+0FTZIcJYuyZpEibzkLeQOLzK68cWwPFHy3SgFCu
        m/RtZF0mT0tii/i0984sYNfNOvOJC5wdCct7r8dHoUGsva3qIky6DfJ2US2Tv1jLSVrwWP
        jG/6BxzWwbDv9qw0Obo42eJqQnPS/Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-8_NQ3No7MeuV4G2PYUeSRw-1; Thu, 14 Jan 2021 11:14:39 -0500
X-MC-Unique: 8_NQ3No7MeuV4G2PYUeSRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87AA1100C664;
        Thu, 14 Jan 2021 16:14:37 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61BB65C1A3;
        Thu, 14 Jan 2021 16:14:31 +0000 (UTC)
Date:   Thu, 14 Jan 2021 17:14:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V11 5/7] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Message-ID: <20210114171429.1402ca3d@carbon>
In-Reply-To: <600008e5e2e80_1eeef20852@john-XPS-13-9370.notmuch>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
        <161047352593.4003084.6778762780747210369.stgit@firesoul>
        <600008e5e2e80_1eeef20852@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 01:03:33 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > The use-case for dropping the MTU check when TC-BPF does redirect to
> > ingress, is described by Eyal Birger in email[0]. The summary is the
> > ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> > ingress redirect packet and let normal netstack fragment packet as needed.
> > 
> > [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> > 
> > V9:
> >  - Make net_device "up" (IFF_UP) check explicit in skb_do_redirect
> > 
> > V4:
> >  - Keep net_device "up" (IFF_UP) check.
> >  - Adjustment to handle bpf_redirect_peer() helper
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
> >  net/core/dev.c            |   19 ++-----------------
> >  net/core/filter.c         |   14 +++++++++++---
> >  3 files changed, 42 insertions(+), 22 deletions(-)
> >   
> 
> [...]
> 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 3f2e593244ca..1908800b671c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
> >  
> >  static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
> >  {
> > -	return dev_forward_skb(dev, skb);  
> 
> > +	int ret = ____dev_forward_skb(dev, skb, false);
> > +
> > +	if (likely(!ret)) {
> > +		skb->protocol = eth_type_trans(skb, dev);
> > +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > +		ret = netif_rx(skb);
> > +	}
> > +
> > +	return ret;  
> 
> How about putting above block into a dev.c routine call it
> 
>  dev_forward_skb_nomtu(...)
> 
> or something like that. Then we keep this code next to its pair
> with mtu check, dev_forward_skb().
> 
> dev_forward_skb() also uses netif_rx_internal() looks like maybe we should
> just do the same here?

I love the idea.  I'm coding it up and it looks much nicer.  And yes we
obviously can use netif_rx_internal() once the code in core/dev.c

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

