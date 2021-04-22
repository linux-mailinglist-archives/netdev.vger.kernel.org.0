Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C733685B3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhDVRTm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Apr 2021 13:19:42 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:33852 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238568AbhDVRTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:19:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-GF4bTg4fOemEsP4NsiUe0Q-1; Thu, 22 Apr 2021 13:18:54 -0400
X-MC-Unique: GF4bTg4fOemEsP4NsiUe0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBA2E1006C8E;
        Thu, 22 Apr 2021 17:18:52 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0066E60BE5;
        Thu, 22 Apr 2021 17:18:50 +0000 (UTC)
Date:   Thu, 22 Apr 2021 19:18:49 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Phillip Potter <phil@philpotter.co.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Message-ID: <YIGv+UOHIl8c/JVk@hog>
References: <20210421231100.7467-1-phil@philpotter.co.uk>
 <20210422003942.GF4841@breakpoint.cc>
 <YIGeVLyfa2MrAZym@hog>
 <CANn89iJSy82k+5b-vgSE-tD7hc8MhM6Niu=eY8sg-b7LbULouQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANn89iJSy82k+5b-vgSE-tD7hc8MhM6Niu=eY8sg-b7LbULouQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-04-22, 18:52:10 +0200, Eric Dumazet wrote:
> On Thu, Apr 22, 2021 at 6:04 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
> >
> > 2021-04-22, 02:39:42 +0200, Florian Westphal wrote:
> > > Phillip Potter <phil@philpotter.co.uk> wrote:
> > > > Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> > > > rather than struct ipv6hdr. This fixes two kernel selftest failures
> > > > introduced by commit 6628ddfec758
> > > > ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> > > > diminishing the fix provided by that commit.
> > >
> > > What errors?
> > >
> > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > > > ---
> > > >  drivers/net/geneve.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > > > index 42f31c681846..a57a5e6f614f 100644
> > > > --- a/drivers/net/geneve.c
> > > > +++ b/drivers/net/geneve.c
> > > > @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> > > >     __be16 sport;
> > > >     int err;
> > > >
> > > > -   if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> > > > +   if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
> > > >             return -EINVAL;
> > >
> > > Seems this is papering over some bug, this change makes no sense to
> > > me.  Can you please explain this?
> >
> > I'm not sure the original commit (6628ddfec758 ("net: geneve: check
> > skb is large enough for IPv4/IPv6 header")) is correct either. GENEVE
> > isn't limited to carrying IP, I think an ethernet header with not much
> > else on top should be valid.
> 
> Maybe, but we still attempt to use ip_hdr() in this case, from
> geneve_get_v6_dst()
> 
> So there is something fishy.

In ip_tunnel_get_dsfield()? Only if there's IP in the packet. Other
tunnel types (except vxlan, which probably has the same problem as
geneve) ues pskb_inet_may_pull, that looks like what we need here as
well.

-- 
Sabrina

