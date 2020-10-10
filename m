Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5391528A017
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgJJK5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 06:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729457AbgJJK0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602325561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kw+DnHBWKnE2kWYlwA6mpWIRZTgnYnvtPVC5fmZhrlg=;
        b=GTKPozo86gjW39etYZSWYfHfqZL97ZO1EzGrK4IM9SxdEqB1la/Jhn8eLm34xFylqp7CPY
        k8LVo82mEPiXd5N2DBig30uPmR5xvoSwIWu7BThZv/Q8GBvon91AGMlYfEj7k1Eh6YeNBH
        8FbW8DURfPOSay8K9D8GfPD2AAt7POw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-kH6tjGWMPyGf5iZIfdHzLg-1; Sat, 10 Oct 2020 06:25:56 -0400
X-MC-Unique: kH6tjGWMPyGf5iZIfdHzLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 746141005E5A;
        Sat, 10 Oct 2020 10:25:54 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED1D5D9FC;
        Sat, 10 Oct 2020 10:25:46 +0000 (UTC)
Date:   Sat, 10 Oct 2020 12:25:45 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        willemdebruijn.kernel@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V3 1/6] bpf: Remove MTU check in
 __bpf_skb_max_len
Message-ID: <20201010122545.5ae12f9c@carbon>
In-Reply-To: <20b1e1dc-7ce7-dc42-54cd-5c4040ccdb30@iogearbox.net>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <160216614239.882446.4447190431655011838.stgit@firesoul>
        <20b1e1dc-7ce7-dc42-54cd-5c4040ccdb30@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 18:12:20 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 10/8/20 4:09 PM, Jesper Dangaard Brouer wrote:
> > Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
> > __bpf_skb_max_len() as the max-length. This function limit size against
> > the current net_device MTU (skb->dev->mtu).
> > 
> > When a BPF-prog grow the packet size, then it should not be limited to the
> > MTU. The MTU is a transmit limitation, and software receiving this packet
> > should be allowed to increase the size. Further more, current MTU check in
> > __bpf_skb_max_len uses the MTU from ingress/current net_device, which in
> > case of redirects uses the wrong net_device.
> > 
> > Keep a sanity max limit of IP6_MAX_MTU (under CONFIG_IPV6) which is 64KiB
> > plus 40 bytes IPv6 header size. If compiled without IPv6 use IP_MAX_MTU.
> > 
> > V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   net/core/filter.c |   16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 05df73780dd3..ddc1f9ba89d1 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3474,11 +3474,11 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
> >   	return 0;
> >   }
> >   
> > -static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> > -{
> > -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > -			  SKB_MAX_ALLOC;
> > -}
> > +#ifdef IP6_MAX_MTU /* Depend on CONFIG_IPV6 */
> > +#define BPF_SKB_MAX_LEN IP6_MAX_MTU
> > +#else
> > +#define BPF_SKB_MAX_LEN IP_MAX_MTU
> > +#endif  
> 
> Shouldn't that check on skb->protocol? The way I understand it is
> that a number of devices including virtual ones use ETH_MAX_MTU as
> their dev->max_mtu, so the mtu must be in the range of
> dev->min_mtu(=ETH_MIN_MTU), dev->max_mtu(=ETH_MAX_MTU).
> __dev_set_mtu() then sets the user value to dev->mtu in the core if
> within this range. That means in your case skb->dev->hard_header_len
> for example is left out, meaning if we go for some constant, that
> would need to be higher.

Sorry, but I think you have missed the point.  This BPF_SKB_MAX_LEN is
just a sanity max limit.  We are removing the limit for BPF-progs to
change the size of the packet (regardless of MTU).

This will allow BPF-ingress to increase packet size (up-to this sanity
limit) and then BPF-egress can decrease packet size again, before
sending it to the actual dev.  It is up to the BPF-programmer that to
use this for, but I think this adds good flexibility, instead of being
limited to the *transmit* size (MTU) of the dev.  This is software why
have this MTU limit.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

