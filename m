Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD442A4D3C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKCRje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgKCRje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:39:34 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781D220773;
        Tue,  3 Nov 2020 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604425173;
        bh=MWY+jFGNWH9ytQVJx/OtntUa4tGobRNSFLgGhuG13LE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTORgH3KNerItxqOH7+8K5+24oxQ3Jlzp3As475XHBVylU1Df3cKMIXask02d/0du
         ofkb3+LOcaGFK8rvQjCHyB6YWqvVakUt3jpH7Eo0F8XGgLrQWG9jyCLCwosRX8xJ1G
         /HGIudtObAHxRgSzOGYM+QqF9qIt/jsdIaIXsf8M=
Date:   Tue, 3 Nov 2020 09:39:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103093932.26cf1f0c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103093655.65851a21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201029081057.8506-1-claudiu.manoil@nxp.com>
        <20201103161319.wisvmjbdqhju6vyh@skbuf>
        <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
        <20201103173007.23ttgm3rpmbletee@skbuf>
        <20201103093655.65851a21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 09:36:55 -0800 Jakub Kicinski wrote:
> On Tue, 3 Nov 2020 19:30:07 +0200 Vladimir Oltean wrote:
> > On Tue, Nov 03, 2020 at 05:18:25PM +0000, Claudiu Manoil wrote:  
> > > It's either the dev_kfree_skb_any from the dma mapping error path or the one
> > > from skb_cow_head()'s error path.  A confirmation would help indeed.    
> > 
> > It says "consume", not "kfree", which in my mind would make it point
> > towards the only caller of consume_skb from the gianfar driver, i.e. the
> > dev_consume_skb_any that you just added.  
> 
> #define dev_kfree_skb(a)	consume_skb(a)
> 
> IIRC we did this because too many drivers used dev_kfree_skb
> incorrectly and made the dropwatch output very noisy.

FWIW ./scripts/decode_stacktrace.sh should point you right to the lines
of code if the build has enough debug info. 
