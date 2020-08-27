Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAFB253B46
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 03:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgH0BET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 21:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgH0BES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 21:04:18 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08F0C061796;
        Wed, 26 Aug 2020 18:04:17 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4BcPd82w4DzQkjS;
        Thu, 27 Aug 2020 03:04:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aixah.de; s=MBO0001;
        t=1598490246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q6j+hA2/dONqWHhiG0eN90dTxudsQeR1jOdQOyycNIg=;
        b=yFyF8kopQGa6vkjuFrLzQCFZfVTA39aKI3oQLg9f55qz3XJqOKPZYILZYhEQL0oJHFOnfL
        F/oOBsL5Dwf0tb/K/RfK/mFFBNqS9CoWuiW4+zg8X2fAkxZ4iqH1Mq/WV2BuYr2aViKDQR
        xIPhazIvb7VdraksOEtzi07nkrrXIpsJP/xF7BJjJjMHO8L7me6SHcM84wbUkItnh1e9/0
        Svy7nyrOlEV/Ot49HkdlRhBX7PGRbA5/9BkUgpVMVulLRbogUKcRRSDKici0Wty/cc83kn
        ywGSoIqxBJ/HetDkO/hvw9HD7lTKaFtVCPcWfzFFgWPL1StrqOHcWEyn9XIvIQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id ppw00nlC4MBF; Thu, 27 Aug 2020 03:04:04 +0200 (CEST)
Date:   Thu, 27 Aug 2020 01:04:03 +0000
From:   Mira Ressel <aranea@aixah.de>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] veth: Initialize dev->perm_addr
Message-ID: <20200827010403.r3zic7s66shcjcrb@vega>
References: <20200826152000.ckxrcfyetdvuvqum@vega>
 <20200826.082857.584544823490249841.davem@davemloft.net>
 <20200826162901.4js4u5u2whusp4l4@vega>
 <20200826.093329.96316850316598868.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826.093329.96316850316598868.davem@davemloft.net>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.34 / 15.00 / 15.00
X-Rspamd-Queue-Id: F267068C
X-Rspamd-UID: 510460
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 09:33:29AM -0700, David Miller wrote:
> From: Mira Ressel <aranea@aixah.de>
> Date: Wed, 26 Aug 2020 16:29:01 +0000
> 
> > On Wed, Aug 26, 2020 at 08:28:57AM -0700, David Miller wrote:
> >> From: Mira Ressel <aranea@aixah.de>
> >> Date: Wed, 26 Aug 2020 15:20:00 +0000
> >> 
> >> > I'm setting the peer->perm_addr, which would otherwise be zero, to its
> >> > dev_addr, which has been either generated randomly by the kernel or
> >> > provided by userland in a netlink attribute.
> >> 
> >> Which by definition makes it not necessarily a "permanent address" and
> >> therefore is subject to being different across boots, which is exactly
> >> what you don't want to happen for automatic address generation.
> > 
> > That's true, but since veth devices aren't backed by any hardware, I
> > unfortunately don't have a good source for a permanent address. The only
> > inherently permanent thing about them is their name.
> > 
> > People who use the default eui64-based address generation don't get
> > persistent link-local addresses for their veth devices out of the box
> > either -- the EUI64 is derived from the device's dev_addr, which is
> > randomized by default.
> > 
> > If that presents a problem for anyone, they can configure their userland
> > to set the dev_addr to a static value, which handily fixes this problem
> > for both address generation algorithms.
> > 
> > I'm admittedly glancing over one problem here -- I'm only setting the
> > perm_addr during device creation, whereas userland can change the
> > dev_addr at any time. I'm not sure if it'd make sense here to update the
> > perm_addr if the dev_addr is changed later on?
> 
> We are talking about which parent device address to inherit from, you
> have choosen to use dev_addr and I am saying you should use perm_addr.
> 
> Can you explain why this isn't clear?

Which parent device? This is the veth patch, not the vlan patch. I'm
setting the perm_addrs of both sides of the veth pair to their
respective dev_addrs that they were assigned by userland or through
random generation. If I were to give both of them the same perm_addr,
we'd again have the problem that they'd get conflicting link-local
addresses and trigger DAD.

My apologies if I'm misunderstanding something here!

Regards,
Mira
