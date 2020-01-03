Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C702012F963
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 15:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgACO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 09:59:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:39180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgACO7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 09:59:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B5235ACCA;
        Fri,  3 Jan 2020 14:59:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B8231E0473; Fri,  3 Jan 2020 15:59:11 +0100 (CET)
Date:   Fri, 3 Jan 2020 15:59:11 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>, yu kuai <yukuai3@huawei.com>,
        klassert@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200103145911.GA22387@unicorn.suse.cz>
References: <20200103121907.5769-1-yukuai3@huawei.com>
 <20200103144623.GI6788@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200103144623.GI6788@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 06:46:23AM -0800, Matthew Wilcox wrote:
> On Fri, Jan 03, 2020 at 08:19:07PM +0800, yu kuai wrote:
> > Fixes gcc '-Wunused-but-set-variable' warning:
> > 
> > drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
> > drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
> > ‘mii_reg1’ set but not used [-Wunused-but-set-variable]
> > 
> > It is never used, and so can be removed.
> ...
> >  	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
> > -		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
> >  		mii_reg5 = mdio_read(dev, vp->phys[0], MII_LPA);
> 
> I know nothing about the MII interface, but in general this is not
> a safe thing to do.  You're removing a read from a device register.
> Register reads can have side effects.  I'm actually quite surprised
> that GCC emits this warning, since there should be some kind of
> volatile cast in mdio_read() to let GCC know that something unusual
> is going on here.

Removing the call may be wrong (and certainly isn't obviously correct)
but the warning makes sense, IMHO: if the return value is not used
anywhere, there is no point assigning it to a variable.

Michal Kubecek
