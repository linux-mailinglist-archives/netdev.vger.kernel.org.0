Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406262C2D4C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390417AbgKXQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:50:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKXQuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:50:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B86206D8;
        Tue, 24 Nov 2020 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606236614;
        bh=zxJSWI7fgYlaXNx3wDv7/S3oRlsxvFCT6yNC9aKjyBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nxN4DuGFWPqUFYvRUMGBGMUE7OxfucTe53o5zXYUXiwvmRVuckFDL3twfcaUKG7XB
         yhdzTGrSB0KTkGAMYeDzyrkvSkAgrVOM2si8qtAdPePLXDBiUg9WbCsL3+CICzeKGr
         kSHzKDSObZeg8fYUB7n7De4KIjjOCk6f2aMow7lM=
Date:   Tue, 24 Nov 2020 08:50:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        kernel <kernel@axis.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: stmmac: Use hrtimer for TX coalescing
Message-ID: <20201124085013.26e282c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124041127.c3uagg4cguqqvgji@axis.com>
References: <20201120150208.6838-1-vincent.whitchurch@axis.com>
        <20201123164600.434b6a9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201124041127.c3uagg4cguqqvgji@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 05:11:27 +0100 Vincent Whitchurch wrote:
> On Tue, Nov 24, 2020 at 01:46:00AM +0100, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 16:02:08 +0100 Vincent Whitchurch wrote:  
> > > This driver uses a normal timer for TX coalescing, which means that the
> > > with the default tx-usecs of 1000 microseconds the cleanups actually
> > > happen 10 ms or more later with HZ=100.  This leads to very low
> > > througput with TCP when bridged to a slow link such as a 4G modem.  Fix
> > > this by using an hrtimer instead.
> > > 
> > > On my ARM platform with HZ=100 and the default TX coalescing settings
> > > (tx-frames 25 tx-usecs 1000), with "tc qdisc add dev eth0 root netem
> > > delay 60ms 40ms rate 50Mbit" run on the server, netperf's TCP_STREAM
> > > improves from ~5.5 Mbps to ~100 Mbps.
> > > 
> > > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>  
> > 
> > Looks perfectly reasonable, but you marked it for net. Do you consider
> > this to be a bug fix, and need it backported to stable? Otherwise I'd
> > rather apply it to net-next.  
> 
> No, sorry, I think a backport to stable is unnecessary.  It should be
> fine to apply it to net-next.  Thanks.

Applied to net-next, thank you!
