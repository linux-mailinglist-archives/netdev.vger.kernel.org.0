Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D01388657
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhESFGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232842AbhESFGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 01:06:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D0E6135B;
        Wed, 19 May 2021 05:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621400703;
        bh=wYYX9ZqE8MzuuAZRGsD7NWSnysXuKB8JlIKz2SrZG7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDTLUdYDPOqGsBMcGlgqJPnqMyaL+6ZyGBbXTrwd5gxKE34zpNCuAW3q48aS8oBCE
         jVXiydajtZ29294JvxkwdUKOzRZV+CreV+bh8Sqqf2YYgUivccXwr1eshu/5M54dld
         n7oqYbFPbYfTTEIoA6QBTEOQTIwmguh/aG6WnvO0=
Date:   Wed, 19 May 2021 07:05:00 +0200
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
Message-ID: <YKScfFKhxtVqfRkt@kroah.com>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
 <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 03:00:44PM -0700, Jeff Johnson wrote:
> On 2021-05-18 12:29, Jeff Johnson wrote:
> > On 2021-05-18 09:33, Greg Kroah-Hartman wrote:
> > > There is no need to keep around the dentry pointers for the debugfs
> > > files as they will all be automatically removed when the subdir is
> > > removed.  So save the space and logic involved in keeping them
> > > around by
> > > just getting rid of them entirely.
> > > 
> > > By doing this change, we remove one of the last in-kernel user that
> > > was
> > > storing the result of debugfs_create_bool(), so that api can be
> > > cleaned
> > > up.
> > 
> > Question not about this specific change, but the general concept
> > of keeping (or not keeping) dentry pointers. In the ath drivers,
> > as well as in an out-of-tree driver for Android, we keep a
> > debugfs dentry pointer to use as a param to relay_open().
> > 
> > Will we still be able to have a dentry pointer for this purpose?
> > Or better, is there a recommended way to get a dentry pointer
> > NOT associated with debugfs at all (which would be ideal for
> > Android where debugfs is disabled).
> 
> Answering one of my questions: The dentry passed to relay_open() comes
> from debugfs_create_dir() which is expected to return a dentry.
> 
> Would still like guidance on if there is a recommended way to get a
> dentry not associated with debugfs.

What do you exactly mean by "not associated with debugfs"?

And why are you passing a debugfs dentry to relay_open()?  That feels
really wrong and fragile.

Ideally I want to get rid of the "raw" dentry that debugfs returns to
callers, as it has caused odd problems in the past, but that's a very
long-term project...

thanks,

greg k-h
