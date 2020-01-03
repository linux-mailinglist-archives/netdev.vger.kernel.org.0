Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8FD12F954
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 15:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgACOqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 09:46:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACOqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 09:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dxGlP6E/0HnbmMgn1yCwGjBQHVH0nxVSC6z7ysmlKDs=; b=OL7BdYVsmhrEZ6PqewWXvrrH/b
        EiWzXJN80gQf8xZL1AGC7lanLRcuhef2luI/P0Bp1QDWo4gTSMcnyQSnYTJ+lUGtaBpRvpAeGPWXs
        Gue5FGGBUKoLkMAR1ShHf0hyKuREbHBeI5zr5WfMZWWVWXpq818HrvNWl3vjW75kcGrwW2Pix6emS
        DGJRxyiDxDx09lAFEEO+9TRFUUMzGlWl14DDUI6eVLPYMttzrNHspsBmplwjzdwdnRl7Tz/nystz5
        EMRDpQn/0LfqNFI6QbcABSG2tkdfI2OuOJG+9QemWA3sm1msZxij2u23XGtYpanGu6NRuj3Zn/aFt
        zD/4hdjA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1inODX-0005ig-Sz; Fri, 03 Jan 2020 14:46:23 +0000
Date:   Fri, 3 Jan 2020 06:46:23 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     yu kuai <yukuai3@huawei.com>
Cc:     klassert@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200103144623.GI6788@bombadil.infradead.org>
References: <20200103121907.5769-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200103121907.5769-1-yukuai3@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 08:19:07PM +0800, yu kuai wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
> drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
> ‘mii_reg1’ set but not used [-Wunused-but-set-variable]
> 
> It is never used, and so can be removed.
...
>  	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
> -		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
>  		mii_reg5 = mdio_read(dev, vp->phys[0], MII_LPA);

I know nothing about the MII interface, but in general this is not
a safe thing to do.  You're removing a read from a device register.
Register reads can have side effects.  I'm actually quite surprised
that GCC emits this warning, since there should be some kind of
volatile cast in mdio_read() to let GCC know that something unusual
is going on here.
