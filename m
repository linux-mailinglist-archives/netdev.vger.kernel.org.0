Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12C48440B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiADPBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:01:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiADPBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:01:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB41861366;
        Tue,  4 Jan 2022 15:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA254C36AED;
        Tue,  4 Jan 2022 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641308489;
        bh=mhzeFDYFAPMAD0Yiag37iyFKvCrL7lUYgeMefRiEKq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aEkdgksKYlLG+KOY1hoAafFeaSyntRIIx86DKrcaWH3YuZ9MtQO9/ALtfCtnSr/ym
         XSKFSgWBZKeF86GHOtVmgBejRJ3cC2EK9JhHKMRn8rpYBCO4ZKwt8yc6vwWx2LZs0u
         Xrh5EPjMMXLFe8BgeibifWTKLBLjQVsX6j/ZqQSDHDGv7F8KaV6z2RAxeWj7lfxmSd
         wa76HHYl3yymkrV1UIIv903Cu9PgN9IYXiMeMatHhd8fuWE9s/G88uYY8hn9zMYUT3
         uUM06L5cJIDmxAX3FrLD+QAYzpQOM5ni68vop7RX0ea3y+FfHsHAyAnV5Xyk7TlyK2
         s/xDSihUnu+lg==
Date:   Tue, 4 Jan 2022 07:01:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN
 management
Message-ID: <20220104070127.34af925f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104154151.0d592bff@xps13>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-9-miquel.raynal@bootlin.com>
        <20211222125555.576e60b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220104154151.0d592bff@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 15:41:51 +0100 Miquel Raynal wrote:
> > On Wed, 22 Dec 2021 16:57:33 +0100 Miquel Raynal wrote:  
> > > +/* Maximum number of PAN entries to store */
> > > +static int max_pan_entries = 100;
> > > +module_param(max_pan_entries, uint, 0644);
> > > +MODULE_PARM_DESC(max_pan_entries,
> > > +		 "Maximum number of PANs to discover per scan (default is 100)");
> > > +
> > > +static int pan_expiration = 60;
> > > +module_param(pan_expiration, uint, 0644);
> > > +MODULE_PARM_DESC(pan_expiration,
> > > +		 "Expiration of the scan validity in seconds (default is 60s)");    
> > 
> > Can these be per-device control knobs? Module params are rarely the
> > best answer.  
> 
> I believe we can do that on a per FFD device basis (for now it will be
> on a per-device basis, but later when we will have the necessary
> information we might do something more fine grained). Would a couple of
> sysfs entries work?

Is there no netlink object where this would fit? Sorry, I'm not at all
familiar with WPAN. If it's orthogonal to current cfg802154 objects
sysfs is fine, I guess.
