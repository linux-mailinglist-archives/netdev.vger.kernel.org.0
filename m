Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E161F3043C1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392895AbhAZQYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:24:45 -0500
Received: from foss.arm.com ([217.140.110.172]:46890 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392859AbhAZQWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 11:22:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E00C31B;
        Tue, 26 Jan 2021 08:21:58 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.45.247])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 263843F66E;
        Tue, 26 Jan 2021 08:21:57 -0800 (PST)
Date:   Tue, 26 Jan 2021 16:21:54 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: Preemptible idr_alloc() in QRTR code
Message-ID: <20210126162154.GD80448@C02TD0UTHF1T.local>
References: <20210126104734.GB80448@C02TD0UTHF1T.local>
 <20210126145833.GM308988@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126145833.GM308988@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 02:58:33PM +0000, Matthew Wilcox wrote:
> On Tue, Jan 26, 2021 at 10:47:34AM +0000, Mark Rutland wrote:
> > Hi,
> > 
> > When fuzzing arm64 with Syzkaller, I'm seeing some splats where
> > this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
> > radix_tree_node_alloc(), in a preemptible context:
> 
> I sent a patch to fix this last June.  The maintainer seems to be
> under the impression that I care an awful lot more about their
> code than I do.
> 
> https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/

Ah; I hadn't spotted the (glaringly obvious) GFP_ATOMIC abuse, thanks
for the pointer, and sorry for the noise.

It looks like Eric was after a fix that trivially backported to v4.7
(and hence couldn't rely on xarray) but instead it just got left broken
for months. :/

Bjorn, is this something you care about? You seem to have the most
commits to the file, and otherwise the official maintainer is Dave
Miller per get_maintainer.pl.

It is very tempting to make the config option depend on BROKEN...

Thanks,
Mark.
