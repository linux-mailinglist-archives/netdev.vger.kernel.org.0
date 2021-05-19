Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9373E389330
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355077AbhESQEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 12:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346574AbhESQEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 12:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC91611BF;
        Wed, 19 May 2021 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621440190;
        bh=JZ5ttupHJEOD9whNallqTU+f5HydGhX1QoErpDhMSqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pK80JGjcsfTNR77RvDU/cvsZsF0N9SpohJW9XQJaXGVTLtFhs9vZO0mfB8Qr/6yP1
         WeDPA9KpMxok/EFnJe+k7/XORUQWRS1slPmZKqwOWUobnEANqAoyr5w/7wWWmc+RMx
         qxmSTLpdSAIBzMBO0t4HXq7D8VfJGTzne7w68Wjk=
Date:   Wed, 19 May 2021 18:03:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeff Johnson <jjohnson@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjohnson=codeaurora.org@codeaurora.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
Message-ID: <YKU2vMoDO0Ch1Lyg@kroah.com>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
 <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
 <YKScfFKhxtVqfRkt@kroah.com>
 <2eb3af43025436c0832c8f61fbf519ad@codeaurora.org>
 <YKUyAoBq/cepglmk@kroah.com>
 <48aea7ae33faaafab388e24c3b8eb199@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48aea7ae33faaafab388e24c3b8eb199@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 08:57:00AM -0700, Jeff Johnson wrote:
> On 2021-05-19 08:42, Greg Kroah-Hartman wrote:
> > On Wed, May 19, 2021 at 08:04:59AM -0700, Jeff Johnson wrote:
> > > On 2021-05-18 22:05, Greg Kroah-Hartman wrote:
> > > > On Tue, May 18, 2021 at 03:00:44PM -0700, Jeff Johnson wrote:
> > > > > On 2021-05-18 12:29, Jeff Johnson wrote:
> > > > > Would still like guidance on if there is a recommended way to get a
> > > > > dentry not associated with debugfs.
> > > >
> > > > What do you exactly mean by "not associated with debugfs"?
> > > >
> > > > And why are you passing a debugfs dentry to relay_open()?  That feels
> > > > really wrong and fragile.
> > > 
> > > I don't know the history but the relay documentation tells us:
> > > "If you want a directory structure to contain your relay files,
> > > you should create it using the host filesystem’s directory
> > > creation function, e.g. debugfs_create_dir()..."
> > > 
> > > So my guess is that the original implementation followed that
> > > advice.  I see 5 clients of this functionality, and all 5 pass a
> > > dentry returned from debugfs_create_dir():
> > > 
> > > drivers/gpu/drm/i915/gt/uc/intel_guc_log.c, line 384
> > > drivers/net/wireless/ath/ath10k/spectral.c, line 534
> > > drivers/net/wireless/ath/ath11k/spectral.c, line 902
> > > drivers/net/wireless/ath/ath9k/common-spectral.c, line 1077
> > > kernel/trace/blktrace.c, line 549
> > 
> > Ah, that's just the "parent" dentry for the relayfs file.  That's fine,
> > not a big deal, debugfs will always provide a way for you to get that if
> > needed.
> 
> Unless debugfs is disabled, like on Android, which is the real problem I'm
> trying to solve.

Then use some other filesystem to place your relay file in.  A relay
file is not a file that userspace should rely on for normal operation,
so why do you need it at all?

What tools/operation requires access to this file that systems without
debugfs support is causing problems on?

thanks,

greg k-h
