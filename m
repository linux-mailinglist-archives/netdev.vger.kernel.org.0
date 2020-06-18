Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7B1FF297
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgFRNEv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 09:04:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727853AbgFRNEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:04:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-WX2-kXa7MXmzhSgri_lcsQ-1; Thu, 18 Jun 2020 09:04:10 -0400
X-MC-Unique: WX2-kXa7MXmzhSgri_lcsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCA86835B8E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:03:49 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-149.ams2.redhat.com [10.36.112.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 323151E2294;
        Thu, 18 Jun 2020 13:03:49 +0000 (UTC)
Date:   Thu, 18 Jun 2020 15:03:47 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] geneve: allow changing DF behavior after creation
Message-ID: <20200618130347.GA2557669@bistromath.localdomain>
References: <3b72fc01841507f8439a90f618ef6f6240b9463f.1592473442.git.sd@queasysnail.net>
 <20200618122629.54a66950@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200618122629.54a66950@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-18, 12:26:29 +0200, Stefano Brivio wrote:
> On Thu, 18 Jun 2020 12:13:22 +0200
> Sabrina Dubroca <sd@queasysnail.net> wrote:
> 
> > Currently, trying to change the DF parameter of a geneve device does
> > nothing:
> > 
> >     # ip -d link show geneve1
> >     14: geneve1: <snip>
> >         link/ether <snip>
> >         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
> >     # ip link set geneve1 type geneve id 1 df unset
> >     # ip -d link show geneve1
> >     14: geneve1: <snip>
> >         link/ether <snip>
> >         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
> > 
> > We just need to update the value in geneve_changelink.
> > 
> > Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > ---
> >  drivers/net/geneve.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > index 75266580b586..4661ef865807 100644
> > --- a/drivers/net/geneve.c
> > +++ b/drivers/net/geneve.c
> > @@ -1649,6 +1649,7 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
> >  	geneve->collect_md = metadata;
> >  	geneve->use_udp6_rx_checksums = use_udp6_rx_checksums;
> >  	geneve->ttl_inherit = ttl_inherit;
> > +	geneve->df = df;
> 
> I introduced this bug as I didn't notice the asymmetry with VXLAN,
> where vxlan_nl2conf() takes care of this for both new links and link
> changes.

Yeah, I didn't notice either :/

> Here, this block is duplicated in geneve_configure(), which,
> somewhat surprisingly given the name, is not called from
> geneve_changelink(). Did you consider factoring out (at least) this
> block to have it shared?

Then I'd have to introduce another lovely function with an absurdly
long argument list. I'd rather clean that up in all of geneve and
introduce something like struct vxlan_config, but it's a bit much for
net. I'll do that once this fix finds its way into net-next.

> 
> Either way,
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Thanks.

-- 
Sabrina

