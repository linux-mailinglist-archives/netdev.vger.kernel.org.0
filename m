Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6269304D40
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbhAZXHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:07:11 -0500
Received: from foss.arm.com ([217.140.110.172]:52234 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbhAZSgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 13:36:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98ABB113E;
        Tue, 26 Jan 2021 10:36:09 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.45.247])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EABA83F66B;
        Tue, 26 Jan 2021 10:36:07 -0800 (PST)
Date:   Tue, 26 Jan 2021 18:36:02 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: Preemptible idr_alloc() in QRTR code
Message-ID: <20210126183534.GA90035@C02TD0UTHF1T.local>
References: <20210126104734.GB80448@C02TD0UTHF1T.local>
 <20210126145833.GM308988@casper.infradead.org>
 <20210126162154.GD80448@C02TD0UTHF1T.local>
 <YBBKla3I2TxMFIvZ@builder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBBKla3I2TxMFIvZ@builder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:00:05AM -0600, Bjorn Andersson wrote:
> On Tue 26 Jan 10:21 CST 2021, Mark Rutland wrote:
> 
> > On Tue, Jan 26, 2021 at 02:58:33PM +0000, Matthew Wilcox wrote:
> > > On Tue, Jan 26, 2021 at 10:47:34AM +0000, Mark Rutland wrote:
> > > > Hi,
> > > > 
> > > > When fuzzing arm64 with Syzkaller, I'm seeing some splats where
> > > > this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
> > > > radix_tree_node_alloc(), in a preemptible context:
> > > 
> > > I sent a patch to fix this last June.  The maintainer seems to be
> > > under the impression that I care an awful lot more about their
> > > code than I do.
> > > 
> > > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > 
> > Ah; I hadn't spotted the (glaringly obvious) GFP_ATOMIC abuse, thanks
> > for the pointer, and sorry for the noise.
> > 
> 
> I'm afraid this isn't as obvious to me as it is to you. Are you saying
> that one must not use GFP_ATOMIC in non-atomic contexts?
> 
> That said, glancing at the code I'm puzzled to why it would use
> GFP_ATOMIC.

I'm also not entirely sure about the legitimacy of GFP_ATOMIC outside of
atomic contexts -- I couldn't spot any documentation saying that wasn't
legitimate, but Matthew's commit message implies so, and it sticks out
as odd.

> > It looks like Eric was after a fix that trivially backported to v4.7
> > (and hence couldn't rely on xarray) but instead it just got left broken
> > for months. :/
> > 
> > Bjorn, is this something you care about? You seem to have the most
> > commits to the file, and otherwise the official maintainer is Dave
> > Miller per get_maintainer.pl.
> 
> I certainly care about qrtr working and remember glancing at Matthew's
> patch, but seems like I never found time to properly review it.
> 
> > It is very tempting to make the config option depend on BROKEN...
> 
> I hear you and that would be bad, so I'll make sure to take a proper
> look at this and Matthew's patch.

Thanks! I'm happy to try/test patches if that's any help. My main
concern here is that this can be triggered on arbitrary platforms so
long as the driver is built in (e.g. my Syzkaller instance is hitting
this within a VM).

Thanks,
Mark.
