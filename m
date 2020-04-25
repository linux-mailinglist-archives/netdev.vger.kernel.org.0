Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8B41B82BA
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgDYA3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgDYA3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 20:29:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56352074F;
        Sat, 25 Apr 2020 00:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587774541;
        bh=GKvFbIV8FTN/r15/xK71DMYtULaiiCHssjAJY5Qm95k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WjZmToBoD1i9GdkhmbvYWlf/aI5dc+9JphRqoA7gJEzU3Sz2JiuZGXtgszRwc2DuZ
         XHAPw4VT6ge62FXz++RQJe//Ni4O7RGHjwELx1PZ0EEgwBx1yYLpYTZtlPVtXUdm3M
         6yfuRiu/pwL8odZn6Vvy6BMnhOnlqMOSmWo6+Aes=
Date:   Fri, 24 Apr 2020 17:28:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, ruxandra.radulescu@nxp.com,
        ioana.ciornei@nxp.com, nipun.gupta@nxp.com, shawnguo@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200424172859.78245218@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200424090426.1f9505e9@carbon>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
        <20200423082804.6235b084@hermes.lan>
        <20200423173804.004fd0f6@carbon>
        <20200423123356.523264b4@hermes.lan>
        <20200423125600.16956cc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200424090426.1f9505e9@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 09:04:26 +0200 Jesper Dangaard Brouer wrote:
> (Side-note: First I placed an extack in qdisc_create_dflt() but I
> realized it was wrong, because it could potentially override messages
> from the lower layers.)
>
> > > but doing that would require a change
> > > to the ndo_setup_tc hook to allow driver to return its own error message
> > > as to why the setup failed.    
> > 
> > Yeah :S The block offload command contains extack, but this driver
> > doesn't understand block offload, so it won't interpret it...
> > 
> > That brings me to an important point - doesn't the extack in patch 1
> > override any extack driver may have set?  
> 
> Nope, see above side-note.  I set the extack at the "lowest level",
> e.g. closest to the error that cause the err back-propagation, when I
> detect that this will cause a failure at higher level.

Still, the driver is lower:

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2908e0a0d6e1..ffed75453c14 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -209,9 +209,12 @@ static int
 nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 {
        struct netdevsim *ns = netdev_priv(dev);
+       struct flow_block_offload *f;

        switch (type) {
        case TC_SETUP_BLOCK:
+               f = type_data;
+               NL_SET_ERR_MSG_MOD(f->extack, "bla bla bla bla bla");
+               return -EINVAL;
-               return flow_block_cb_setup_simple(type_data,
-                                                 &nsim_block_cb_list,
-                                                 nsim_setup_tc_block_cb,
 	default:
 		return -EOPNOTSUPP;
 	}

# tc qdisc add dev netdevsim0 ingress
Error: Driver ndo_setup_tc failed.


> > I remember we discussed this when adding extacks to the TC core, but 
> > I don't remember the conclusion now, ugh.  
> 
> When adding the extack code, I as puzzled that during debugging I
> managed to override other extack messages.  Have anyone though about a
> better way to handle if extack messages gets overridden?

I think there was more discussion, but this is all I can find now:

https://lore.kernel.org/netdev/20180918131212.20266-4-johannes@sipsolutions.net/#t

Maybe Marcelo will remeber.
