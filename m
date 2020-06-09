Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6701F3B64
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgFING7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:06:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgFING7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 09:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8hnV2fj1rDCJq0L+JTTYrY1gbpiBl4ZFcnXTyn5DB6w=; b=KwLcx87F1vcXf66ceahGaHbKRr
        9aYNOOHXsolv3EtpapUCqmeTas+OQ5Ya6F7DmYH/tK0tiQMs7zz69Qb8oGcvTomAfS09Y5ABVRiq9
        tUBG1UQDxSoY7Syd/pszOOqqH1DPmfRvv2rZyoWEKQfZNxLmgBdBUjvgfiU+jkqLOKmw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jidxu-004VuZ-UP; Tue, 09 Jun 2020 15:06:54 +0200
Date:   Tue, 9 Jun 2020 15:06:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, lorenzo.bianconi@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
Message-ID: <20200609130654.GI1022955@lunn.ch>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
 <20200608231015.GH1022955@lunn.ch>
 <20200609074110.GA2067@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609074110.GA2067@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 09:41:10AM +0200, Lorenzo Bianconi wrote:
> > On Tue, Jun 09, 2020 at 12:02:39AM +0200, Lorenzo Bianconi wrote:
> > > Disable frames injection in mvneta_xdp_xmit routine during hw
> > > re-configuration in order to avoid hardware hangs
> > 
> > Hi Lorenzo
> > 
> > Why does mvneta_tx() also not need the same protection?
> > 
> >     Andrew
> 
> Hi Andrew,
> 
> So far I have not been able to trigger the issue in the legacy tx path.

Even if you have not hit the issue, do you still think it is possible?
If it is hard to trigger, maybe it is worth protecting against it,
just in case.

> I hit the problem adding the capability to attach an eBPF program to CPUMAP
> entries [1]. In particular I am redirecting traffic to mvneta and concurrently
> attaching/removing a XDP program to/from it.
> I am not sure this can occur running mvneta_tx().
> Moreover it seems a common pattern for .ndo_xdp_xmit() in other drivers
> (e.g ixgbe, bnxt, mlx5)

I was wondering if this should be solved at a higher level. And if you
say there are more MAC drivers with this issue, maybe it should. Not
sure how though. It seems like MTU change and rx mode change wound
need to be protected, which at a higher level is harder to do. What
exactly do you need to protect, in a generic way?

     Andrew
