Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A58A1FF672
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgFRPUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:20:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44670 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727045AbgFRPUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592493643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MbTYWN0SzS/44xlIfRPBS7iXPj+sngLskZKbh8O1LbQ=;
        b=I/TlLyiIkVxQrTa224gZLtTOK6/qKCTAVQ85nCGYIwBY8WmDzgca2Nv4o6SEjsx6qX+YD5
        rRZDRW2VZVsZnYO2mlDllGS8APyODgr2xYCjqqgNAp9aumSNFbiCoSaE3T1+gAEfV8J37r
        +U2lQwxQbABO+aEYfMCczDvu/rGDOWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-r8ljWaW7PkilwOzOgeIg5Q-1; Thu, 18 Jun 2020 11:20:41 -0400
X-MC-Unique: r8ljWaW7PkilwOzOgeIg5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCCB0107ACF4;
        Thu, 18 Jun 2020 15:20:40 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D19CF1E2265;
        Thu, 18 Jun 2020 15:20:39 +0000 (UTC)
Date:   Thu, 18 Jun 2020 17:20:35 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] geneve: allow changing DF behavior after creation
Message-ID: <20200618172035.37f99a30@redhat.com>
In-Reply-To: <20200618130347.GA2557669@bistromath.localdomain>
References: <3b72fc01841507f8439a90f618ef6f6240b9463f.1592473442.git.sd@queasysnail.net>
        <20200618122629.54a66950@redhat.com>
        <20200618130347.GA2557669@bistromath.localdomain>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 15:03:47 +0200
Sabrina Dubroca <sd@queasysnail.net> wrote:

> 2020-06-18, 12:26:29 +0200, Stefano Brivio wrote:
> > On Thu, 18 Jun 2020 12:13:22 +0200
> > Sabrina Dubroca <sd@queasysnail.net> wrote:
> >   
> > > Currently, trying to change the DF parameter of a geneve device does
> > > nothing:
> > > 
> > >     # ip -d link show geneve1
> > >     14: geneve1: <snip>
> > >         link/ether <snip>
> > >         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
> > >     # ip link set geneve1 type geneve id 1 df unset
> > >     # ip -d link show geneve1
> > >     14: geneve1: <snip>
> > >         link/ether <snip>
> > >         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
> > > 
> > > We just need to update the value in geneve_changelink.
> > > 
> > > Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
> > > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > > ---
> > >  drivers/net/geneve.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > > index 75266580b586..4661ef865807 100644
> > > --- a/drivers/net/geneve.c
> > > +++ b/drivers/net/geneve.c
> > > @@ -1649,6 +1649,7 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
> > >  	geneve->collect_md = metadata;
> > >  	geneve->use_udp6_rx_checksums = use_udp6_rx_checksums;
> > >  	geneve->ttl_inherit = ttl_inherit;
> > > +	geneve->df = df;  
> > 
> > I introduced this bug as I didn't notice the asymmetry with VXLAN,
> > where vxlan_nl2conf() takes care of this for both new links and link
> > changes.  
> 
> Yeah, I didn't notice either :/
> 
> > Here, this block is duplicated in geneve_configure(), which,
> > somewhat surprisingly given the name, is not called from
> > geneve_changelink(). Did you consider factoring out (at least) this
> > block to have it shared?  
> 
> Then I'd have to introduce another lovely function with an absurdly
> long argument list. I'd rather clean that up in all of geneve and
> introduce something like struct vxlan_config, but it's a bit much for
> net. I'll do that once this fix finds its way into net-next.

Yeah, sure, I didn't mean you should simply copy and paste that
somewhere. Either something like struct vxlan_config used around the
current logic, or perhaps even better, something like vxlan_nl2conf()
does.

I didn't check whether something in GENEVE is so special compared to
VXLAN as to prevent this, though.

-- 
Stefano

