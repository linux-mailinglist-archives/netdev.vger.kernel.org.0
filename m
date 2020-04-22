Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AEF1B4911
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgDVPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:49:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726399AbgDVPtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587570543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OhfB7qBup5AhUml+0c0eRYkVxOLhqg8b5aTcB91g9g4=;
        b=JuKihNAyPgKRX8glxfXM/VyvLmi8EIDLyQE57mKujU31Nmjyzqs5KnVd6w92flVBGvGq5r
        sEIw+kmeGukZQfbZwaFULmFv+k/msuwMba1Bmrzvbw1sXOAmR6zlFY91IKlgOTgOAfIhqt
        wpzE40UHIPFUTK1JX27kIpoIl8jEvAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-G12W5B_mN4mUY_DMUMCnbg-1; Wed, 22 Apr 2020 11:48:58 -0400
X-MC-Unique: G12W5B_mN4mUY_DMUMCnbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D377A1926DA4;
        Wed, 22 Apr 2020 15:48:56 +0000 (UTC)
Received: from ovpn-114-173.ams2.redhat.com (ovpn-114-173.ams2.redhat.com [10.36.114.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDA385D714;
        Wed, 22 Apr 2020 15:48:54 +0000 (UTC)
Message-ID: <30c615a70de5a5cbfee2a2bf221c1ff950dc6054.camel@redhat.com>
Subject: Re: [PATCH V2 -next] mptcp/pm_netlink.c : add check for
 nla_put_in/6_addr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bo YU <tsu.yubo@gmail.com>
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Date:   Wed, 22 Apr 2020 17:48:53 +0200
In-Reply-To: <20200422145618.b5qshinlmi26i6ko@host>
References: <20200422013433.qzlthtmx4c7mmlh3@host>
         <f82e4d00d4d4680994f0885c55831b2e9a2299c1.camel@redhat.com>
         <20200422145618.b5qshinlmi26i6ko@host>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-22 at 22:56 +0800, Bo YU wrote:
> On Wed, Apr 22, 2020 at 12:12:27PM +0200, Paolo Abeni wrote:
> > On Wed, 2020-04-22 at 09:34 +0800, Bo YU wrote:
> > > Normal there should be checked for nla_put_in6_addr like other
> > > usage in net.
> > > 
> > > Detected by CoverityScan, CID# 1461639
> > > 
> > > Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
> > > Signed-off-by: Bo YU <tsu.yubo@gmail.com>
> > > ---
> > > V2: Add check for nla_put_in_addr suggested by Paolo Abeni
> > 
> > Thank you for addressing my feedback!
> > 
> > > ---
> > >  net/mptcp/pm_netlink.c | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> > > index 86d61ab34c7c..0a39f0ebad76 100644
> > > --- a/net/mptcp/pm_netlink.c
> > > +++ b/net/mptcp/pm_netlink.c
> > > @@ -599,12 +599,15 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
> > >  	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
> > >  		goto nla_put_failure;
> > > 
> > > -	if (addr->family == AF_INET)
> > > +	if (addr->family == AF_INET &&
> > >  		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
> > > -				addr->addr.s_addr);
> > > +				addr->addr.s_addr))
> > > +		goto nla_put_failure;
> > > +
> > 
> > I'm very sorry about the nit-picking, but the above is now a single
> > statement, and indentation should be adjusted accordingly:
> > 'nla_put_in_addr()' should be aligned with 'addr->family'.
> Ok, but i just want to make clear for that, do you mean:
> 
> 
> 	if (addr->family == AF_INET && nla_put_in_addr(skb,
> 			MPTCP_PM_ADDR_ATTR_ADDR4, addr->addr.s_addr))
> 
> In fact, i was upset by checkpatch about over 80 chars warning.
> This is my originally version patch to fix it :(. If i was wrong
> to understand your means, please  correct me. Thank you.

I mean:
	if (addr->family == AF_INET &&
	    nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
			    addr->addr.s_addr))

note that [the first char of]  'nla_put_in_addr' is aligned with [the
first char of] 'addr->family', and 'addr->addr.s_addr' with 'skb'.

Please, nota that the same applies to nla_put_in6_addr() below.

Thanks!

Paolo

