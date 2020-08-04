Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED523B49F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgHDFx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:53:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726398AbgHDFx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YI+1k9eGqpOp0GG0X9yNOQ1AabHPoPPkLGBmxoPjbx0=;
        b=TjY7Blry/AblTeNKVc4/oD3pIp0bQiVXCLriN/kFCqfQq0FBXmF7+1Pd+XkOgZzY5ISm2Z
        efou5Bk3Lu2Ph/a4Xw9CljpBH2vW632XTgPXUH10Vfs3+Py2IXt+/cQK4sfcYMTsLwgp9v
        EIVncMhRFPhcTz2D6QNULQngVuiDlwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-YCsEdWvzNza9aGEeLC6rWg-1; Tue, 04 Aug 2020 01:53:24 -0400
X-MC-Unique: YCsEdWvzNza9aGEeLC6rWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C925B1083E80;
        Tue,  4 Aug 2020 05:53:22 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A268B71769;
        Tue,  4 Aug 2020 05:53:19 +0000 (UTC)
Date:   Tue, 4 Aug 2020 07:53:14 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] tunnels: PMTU discovery support for
 directly bridged IP packets
Message-ID: <20200804075314.3a45558d@elisabeth>
In-Reply-To: <b6978999-4f05-5e87-2964-bec444221cf5@gmail.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
        <c7b3e4800ea02d964bab7dd9f349e0a0720bff2d.1596487323.git.sbrivio@redhat.com>
        <b6978999-4f05-5e87-2964-bec444221cf5@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 17:44:16 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 8/3/20 2:52 PM, Stefano Brivio wrote:
> > @@ -461,6 +464,91 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
> > [...]
> >
> > +static inline int skb_tunnel_check_pmtu(struct sk_buff *skb,
> > +					struct dst_entry *encap_dst,
> > +					int headroom, bool reply)  
> 
> Given its size, this is probably better as a function. I believe it can
> go into net/ipv4/ip_tunnel_core.c like you have iptunnel_pmtud_build_icmp.

Right, moved in v2.

> > [...]
> > +	if (skb->protocol == htons(ETH_P_IP) && mtu > 576) {  
> 
> I am surprised the 576 does not have an existing macro.

I guess that comes from how RFC 791 picks this "512 plus something
reasonable" value. I'll think of a name and propose as a later patch,
it's used in a number of places.

> > [...]
> > +		return iptunnel_pmtud_build_icmp(skb, mtu);
> > +	}
> > +#endif  
> 
> separate v4 and v6 code into helpers based on skb->protocol; the mtu
> check then becomes part of the version specific helpers.

Done.

> > +EXPORT_SYMBOL(iptunnel_pmtud_build_icmp);  
> 
> I think separate v4 and v6 versions would be more readable; the
> duplication is mostly skb manipulation.

Yes, way more readable, changed in v2.

-- 
Stefano

