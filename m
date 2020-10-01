Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F374D280940
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgJAVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJAVLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:11:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98BB2206A5;
        Thu,  1 Oct 2020 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601586711;
        bh=vo5jqYOgXhiBCeJoP0VU1ki2oSlXF2VU7JE+uU5GLC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qh2KKp6N00ywASU7zx1bMl1c6CaOOLOwJHbDaEQZiiCsbxmTv4G4wi9ZDU61udJ9q
         lRTjRJQr3WFBnIw1Ta40ArY+cnwB+TCesnzxVSnsBJ03Kci5p06EWasr3YkpZRS1ea
         SpuaB/SVhtFszq+BA5M/omQx0u5HMmkXHsmOEiJo=
Date:   Thu, 1 Oct 2020 14:11:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next 9/9] genetlink: allow dumping command-specific
 policy
Message-ID: <20201001141149.3f2ee7a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dcaeaedaa179c558cab0d417277fea9ac29d8b79.camel@sipsolutions.net>
References: <20201001183016.1259870-1-kuba@kernel.org>
        <20201001183016.1259870-10-kuba@kernel.org>
        <dcaeaedaa179c558cab0d417277fea9ac29d8b79.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Oct 2020 23:03:01 +0200 Johannes Berg wrote:
> On Thu, 2020-10-01 at 11:30 -0700, Jakub Kicinski wrote:
> > 
> > +++ b/net/netlink/genetlink.c
> > @@ -1119,6 +1119,7 @@ static const struct nla_policy ctrl_policy_policy[] = {
> >  	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
> >  	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
> >  				    .len = GENL_NAMSIZ - 1 },
> > +	[CTRL_ATTR_OP]		= { .type = NLA_U8 },  
> 
> I slightly wonder if we shouldn't make this wider. There's no real
> *benefit* to using a u8 since, due to padding, the attribute actually
> has the same size anyway (up to U32), and we also still need to validate
> it actually exists.
> 
> However, if we ever run out of command numbers in some family (nl80211
> is almost half way :-) ) then I believe we still have some reserved
> space in the genl header that we could use for extensions, but if then
> we have to also go around and change a bunch of other interfaces like
> this, it'll just be so much harder, and ... we'd probably just be
> tempted to multiplex onto an "extension command" or something? Or maybe
> then we should have a separate genl family at that point?
> 
> (Internal interfaces are much easier to change)
> 
> Dunno. Just a thought. We probably won't ever get there, it just sort of
> rubs me the wrong way that we'd be restricting this in an "unfixable"
> API for no real reason :)

Makes sense, I'll make it a u32. Gotta respin, anyway.

> > -	if (!rt->policy)
> > +	if (tb[CTRL_ATTR_OP]) {
> > +		err = genl_get_cmd(nla_get_u8(tb[CTRL_ATTR_OP]), rt, &op);  
> 
> OK, so maybe if we make that wider we also have to make the argument to
> genl_get_cmd() wider so we don't erroneously return op 1 if you ask for
> 257, but that's in an at least 32-bit register anyway, presumably?

Ack.
