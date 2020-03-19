Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71318C31A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgCSWmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCSWmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 18:42:13 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FA52076E;
        Thu, 19 Mar 2020 22:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584657733;
        bh=ycysLJfzqp1MtnKq8rVHdkuxCFZmjQcFEDu8j/QDQ24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XQiq77mdBw5mE0ZpHakXZDJ0s5jwB7xaD3cbTLpF75tR5jWoEA4D+DVVKzVsIy/fU
         itsg8m76BBrtzgaCAEQTHqUWC2R+LMJsNwqvyDjRotVQ9ZQKT7ZsXg3jCCP9RiHViy
         MW4c1VHpTcFfX2ZPO7j1Ul1uquiisJzklZGNdvqg=
Date:   Thu, 19 Mar 2020 15:42:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     sunil.kovvuri@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, leon@kernel.org,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 net-next 4/8] octeontx2-vf: Ethtool support
Message-ID: <20200319154211.4bf7cf01@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200319155631.GC27807@lunn.ch>
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
        <1584623248-27508-5-git-send-email-sunil.kovvuri@gmail.com>
        <20200319155631.GC27807@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 16:56:31 +0100 Andrew Lunn wrote:
> On Thu, Mar 19, 2020 at 06:37:24PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Tomasz Duszynski <tduszynski@marvell.com>
> > 
> > Added ethtool support for VF devices for
> >  - Driver stats, Tx/Rx perqueue stats
> >  - Set/show Rx/Tx queue count
> >  - Set/show Rx/Tx ring sizes
> >  - Set/show IRQ coalescing parameters
> >  - RSS configuration etc
> > 
> > It's the PF which owns the interface, hence VF
> > cannot display underlying CGX interface stats.
> > Except for this rest ethtool support reuses PF's
> > APIs.
> > 
> > Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But they didn't add static inlines, no? Don't the dependencies 
look strange?

VF depends on PF code, but ethtool code (part of PF) also needs 
symbols from the VF..

Are the kconfig options really needed? If the dependencies are
circular, this will either not work well or have all the modules 
loaded together. So let's just have everything under one kconfig 
knob and not bother breaking it up at module boundaries..

Note that it's perfectly fine to have multiple drivers in one module
(it used to be harder long time ago).
