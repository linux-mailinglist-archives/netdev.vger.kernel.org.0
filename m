Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F73253371
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHZPUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHZPUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 11:20:11 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854FEC061574;
        Wed, 26 Aug 2020 08:20:10 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Bc8gB5kB8zKmr4;
        Wed, 26 Aug 2020 17:20:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aixah.de; s=MBO0001;
        t=1598455205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2qM1jxwRVIaxNoafXFNNPnXJ2t5niKuo4svPG6xAYZs=;
        b=m3OnWH9t6OfefTnGMiRiHV9/l3Tpe8rHW+XDxtdta1v7PPy499mv3fbgknGlmmFWWLjiji
        X7io67hyI4FWpIHvFJSTZnDWD7AtrStfsKO0Idi+ULqMruRdiLchiv35F/K7zz5Un4kGZY
        OS/s+iBrQo1kczWjgCxvbWNGlgg6Q99beZCHwgsPWmn75tF4dL26jyoLo89GiFBLMSEL4m
        WSRmQlrugMVWw7cvCstNNo2+S/jmnVlSAaqw+nJeaYWJ92c66erX5L6a0qdecHahJkEucX
        +rR5fYpci0o2U6Mz3XLuM9KP7ZKvCsnj9V1bguZHtmeOrHVtSAo6LIvEk68TRQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id FJwc5ExwoScb; Wed, 26 Aug 2020 17:20:03 +0200 (CEST)
Date:   Wed, 26 Aug 2020 15:20:00 +0000
From:   Mira Ressel <aranea@aixah.de>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] veth: Initialize dev->perm_addr
Message-ID: <20200826152000.ckxrcfyetdvuvqum@vega>
References: <20200824143828.5964-1-aranea@aixah.de>
 <20200824.102545.1450838041398463071.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824.102545.1450838041398463071.davem@davemloft.net>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.75 / 15.00 / 15.00
X-Rspamd-Queue-Id: BA09FCC9
X-Rspamd-UID: 406851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:25:45AM -0700, David Miller wrote:
> From: Mira Ressel <aranea@aixah.de>
> Date: Mon, 24 Aug 2020 14:38:26 +0000
> 
> > Set the perm_addr of veth devices to whatever MAC has been assigned to
> > the device. Otherwise, it remains all zero, with the consequence that
> > ipv6_generate_stable_address() (which is used if the sysctl
> > net.ipv6.conf.DEV.addr_gen_mode is set to 2 or 3) assigns every veth
> > interface on a host the same link-local address.
> > 
> > The new behaviour matches that of several other virtual interface types
> > (such as gre), and as far as I can tell, perm_addr isn't used by any
> > other code sites that are relevant to veth.
> > 
> > Signed-off-by: Mira Ressel <aranea@aixah.de>
>  ...
> > @@ -1342,6 +1342,8 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
> >  	if (!ifmp || !tbp[IFLA_ADDRESS])
> >  		eth_hw_addr_random(peer);
> >  
> > +	memcpy(peer->perm_addr, peer->dev_addr, peer->addr_len);
> 
> Semantically don't you want to copy over the peer->perm_addr?
> 
> Otherwise this loses the entire point of the permanent address, and
> what the ipv6 address generation facility expects.

I'm confused. Am I misinterpreting what you're saying here, or did you
make a typo?

I'm setting the peer->perm_addr, which would otherwise be zero, to its
dev_addr, which has been either generated randomly by the kernel or
provided by userland in a netlink attribute.

-- 
Regards,
Mira
