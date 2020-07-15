Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5052220E44
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgGONgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:36:11 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25744 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731174AbgGONgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594820169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UTACMbg6xiT/eo4PUaXGXyO7+chCMqLXhN9wZB3njxA=;
        b=CxWXnGjNMKvxMjlQCVWWkXlttHc2+vYXWyerzUnMjcrh3JiEsPpgWDwvehvpNbHWIbfJAg
        yygjGiY3pm6t3Y9oI1g+iGbYtUStWfy7kpO1HbWt4s29H1mKsBMXss3G6lzgzjMiEGypTp
        sIGNQsd24nh7HVqgVQJZCb5P1YhkqjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-cPCbOoFrNfKFGSx2rHvThw-1; Wed, 15 Jul 2020 09:36:06 -0400
X-MC-Unique: cPCbOoFrNfKFGSx2rHvThw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBF20107ACCA;
        Wed, 15 Jul 2020 13:36:04 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2462C72E53;
        Wed, 15 Jul 2020 13:36:02 +0000 (UTC)
Date:   Wed, 15 Jul 2020 15:35:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200715153547.77dbaf82@elisabeth>
In-Reply-To: <20200715124258.GP32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
        <20200714143327.2d5b8581@redhat.com>
        <20200715124258.GP32005@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 14:42:58 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > I would still like the idea I proposed better (updating MTUs down the
> > chain), it's simpler and we don't have to duplicate existing
> > functionality (generating additional ICMP messages).  
> 
> It doesn't make this work though.

Yeah, not knowing exactly what needs to work, that just fixes the two
cases you describe.

I thought that would be enough for Open vSwitch, but apparently it's
not (you mentioned the problem appeared with MTUs already set to
correct values). And also your (bulletproof, I thought) ICMP errors
don't work with it. :/

Anyway, about the Linux bridge:

> With your skeleton patch, br0 updates MTU, but the sender still
> won't know that unless input traffic to br0 is routed (or locally
> generated).

To let the sender know, I still think it's a bit simpler with this
approach, we don't have to do all the peeling. In br_handle_frame(), we
would need to add *something like*:

	if (skb->len > p->br->dev->mtu) {
		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
			  htonl(p->br->dev->mtu));
		goto drop;
	}

just like IP tunnels do, see tnl_update_pmtu().

Note that this doesn't work as it is because of a number of reasons
(skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
shouldn't be using icmp_send(), but at a glance that looks simpler.

Another slight preference I have towards this idea is that the only
known way we can break PMTU discovery right now is by using a bridge,
so fixing the problem there looks more future-proof than addressing any
kind of tunnel with this problem. I think FoU and GUE would hit the
same problem, I don't know about IP tunnels, sticking that selftest
snippet to whatever other test in pmtu.sh should tell.

I might be wrong of course as I haven't tried to implement this bit,
and if this turns out to be just moving the problem without making it
simpler, then sure, I'd rather stick to your approach.

> Furthermore, such MTU reduction would require a mechanism to
> auto-reconfig every device in the same linklevel broadcast domain,
> and I am not aware of any such mechanism.

You mean for other ports connected to the same bridge? They would then
get ICMP errors as well, no?

If you refer to other drivers that need to adjust the MTU, instead,
that's why I would use skb_tunnel_check_pmtu() for that, to avoid
implementing the same logic in every driver.

-- 
Stefano

