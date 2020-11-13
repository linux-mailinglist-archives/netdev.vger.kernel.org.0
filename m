Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A92B1CF6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKMOPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:15:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgKMOPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 09:15:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605276915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgsPZorsBInqug204yKtGdenm5jOUFNYIYAi8fxlgbg=;
        b=Dh57G5JimiQiYNA6/JrT7q9oQl8XYcfELytjNKSqtdPEOHR0ShmuPIkKaK21PJgAKf7vYH
        xmGxSmN1HfsD0JQc82cUpa6YeOqxYmv1fvUvtZ7NhKGK4MBrqfFDC22MTN5gG7DgudyIOd
        GcYTCMErj7LiHNZWMVtdOvGJui9bqMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-ye2mSQhIPVipK1TVRYeU9w-1; Fri, 13 Nov 2020 09:15:12 -0500
X-MC-Unique: ye2mSQhIPVipK1TVRYeU9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C89D0809DC4;
        Fri, 13 Nov 2020 14:15:11 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.194.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 899B21C4;
        Fri, 13 Nov 2020 14:15:10 +0000 (UTC)
Date:   Fri, 13 Nov 2020 15:15:07 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201113141507.z4gehzlddi6eyggm@yoda.fritz.box>
References: <20201112151229.1288504-1-acardace@redhat.com>
 <20201113114522.pn5ap6m4a2aqoz2j@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113114522.pn5ap6m4a2aqoz2j@lion.mk-sys.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:45:22PM +0100, Michal Kubecek wrote:
> On Thu, Nov 12, 2020 at 04:12:29PM +0100, Antonio Cardace wrote:
> > Add ethtool ring and coalesce settings support for testing.
> > 
> > Signed-off-by: Antonio Cardace <acardace@redhat.com>
> > ---
> >  drivers/net/netdevsim/ethtool.c   | 65 +++++++++++++++++++++++++++----
> >  drivers/net/netdevsim/netdevsim.h |  9 ++++-
> >  2 files changed, 65 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
> > index f1884d90a876..25acd3bc1781 100644
> > --- a/drivers/net/netdevsim/ethtool.c
> > +++ b/drivers/net/netdevsim/ethtool.c
> > @@ -7,15 +7,18 @@
> > 
> >  #include "netdevsim.h"
> > 
> > +#define UINT32_MAX 0xFFFFFFFFU
> 
> We already have U32_MAX in <linux/limits.h>
> 
> > +#define ETHTOOL_COALESCE_ALL_PARAMS UINT32_MAX
> 
> I would rather prefer this constant to include only bits corresponding
> to parameters which actually exist, i.e. either GENMASK(21, 0) or
> combination of existing ETHTOOL_COALESCE_* macros. It should probably
> be defined in include/linux/ethtool.h then.
> 
> [...]
> > +static void nsim_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
> > +{
> > +	struct netdevsim *ns = netdev_priv(dev);
> > +
> > +	memcpy(ring, &ns->ethtool.ring, sizeof(ns->ethtool.ring));
> > +}
> > +
> > +static int nsim_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
> > +{
> > +	struct netdevsim *ns = netdev_priv(dev);
> > +
> > +	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
> >  	return 0;
> >  }
> [...]
> > 
> > +static void nsim_ethtool_coalesce_init(struct netdevsim *ns)
> > +{
> > +	ns->ethtool.ring.rx_max_pending = UINT32_MAX;
> > +	ns->ethtool.ring.rx_jumbo_max_pending = UINT32_MAX;
> > +	ns->ethtool.ring.rx_mini_max_pending = UINT32_MAX;
> > +	ns->ethtool.ring.tx_max_pending = UINT32_MAX;
> > +}
> 
> This way an ETHTOOL_MSG_RINGS_SET request would never fail. It would be
> more useful for selftests if the max values were more realistic and
> ideally also configurable via debugfs.
> 
> Michal
> 

Thanks Michal and Jakub, I will send a v2 patch that addresses the
comments you made.

Antonio

