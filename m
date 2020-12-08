Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947392D2CF1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgLHORd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbgLHORd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:17:33 -0500
X-Greylist: delayed 994 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Dec 2020 06:16:52 PST
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50BCC0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:16:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kmdXJ-0006n8-82; Tue, 08 Dec 2020 15:00:13 +0100
Date:   Tue, 8 Dec 2020 15:00:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
Message-ID: <20201208140013.GX4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201207134309.16762-1-phil@nwl.cc>
 <9d9cb6dc-32a3-ff1a-5111-7688ce7a2897@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d9cb6dc-32a3-ff1a-5111-7688ce7a2897@6wind.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Tue, Dec 08, 2020 at 10:02:16AM +0100, Nicolas Dichtel wrote:
> Le 07/12/2020 à 14:43, Phil Sutter a écrit :
[...]
> > diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> > index aa4cdcf69d471..24af61c95b4d4 100644
> > --- a/net/xfrm/xfrm_interface.c
> > +++ b/net/xfrm/xfrm_interface.c
> > @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
> >  	skb_dst_set(skb, dst);
> >  	skb->dev = tdev;
> >  
> > -	err = dst_output(xi->net, skb->sk, skb);
> > +	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
> skb->protocol must be correctly set, maybe better to use it instead of
> skb_dst(skb)->ops->family?

skb->protocol holds ETH_P_* values in network byte order, NF_HOOK()
expects an NFPROTO_* value, so this would at least not be a simple
replacement. Actually I copied the code from xfrm_output_resume() in
xfrm_output.c, where skb_dst(skb)->ops is dereferenced without checking
as well. Do you think this is risky?

> > +		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
> And here, tdev instead of skb_dst(skb)->dev ?

Well yes, tdev was set to dst->dev earlier. Likewise I could use dst
directly instead of skb_dst(skb) to simplify the call a bit further.
OTOH I like how in the version above it is clear that skb's dst should
be used, irrespective of the code above (and any later changes that may
receive). No strong opinion though, so if your version is regarded the
preferred one, I'm fine with that.

Thanks, Phil
