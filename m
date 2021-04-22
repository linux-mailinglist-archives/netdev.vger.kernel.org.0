Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE7368459
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhDVQEi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Apr 2021 12:04:38 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:45006 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232670AbhDVQEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:04:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-ufYayBnTNhuXUT5o0X5VwA-1; Thu, 22 Apr 2021 12:03:59 -0400
X-MC-Unique: ufYayBnTNhuXUT5o0X5VwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D65E81B2C9B3;
        Thu, 22 Apr 2021 16:03:36 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5CA06091B;
        Thu, 22 Apr 2021 16:03:34 +0000 (UTC)
Date:   Thu, 22 Apr 2021 18:03:32 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phillip Potter <phil@philpotter.co.uk>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Message-ID: <YIGeVLyfa2MrAZym@hog>
References: <20210421231100.7467-1-phil@philpotter.co.uk>
 <20210422003942.GF4841@breakpoint.cc>
MIME-Version: 1.0
In-Reply-To: <20210422003942.GF4841@breakpoint.cc>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

2021-04-22, 02:39:42 +0200, Florian Westphal wrote:
> Phillip Potter <phil@philpotter.co.uk> wrote:
> > Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> > rather than struct ipv6hdr. This fixes two kernel selftest failures
> > introduced by commit 6628ddfec758
> > ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> > diminishing the fix provided by that commit.
> 
> What errors?
> 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  drivers/net/geneve.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > index 42f31c681846..a57a5e6f614f 100644
> > --- a/drivers/net/geneve.c
> > +++ b/drivers/net/geneve.c
> > @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> >  	__be16 sport;
> >  	int err;
> >  
> > -	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> > +	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
> >  		return -EINVAL;
> 
> Seems this is papering over some bug, this change makes no sense to
> me.  Can you please explain this?

I'm not sure the original commit (6628ddfec758 ("net: geneve: check
skb is large enough for IPv4/IPv6 header")) is correct either. GENEVE
isn't limited to carrying IP, I think an ethernet header with not much
else on top should be valid.

-- 
Sabrina

