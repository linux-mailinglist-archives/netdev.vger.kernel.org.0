Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFE58E096
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 00:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfHNWSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 18:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbfHNWSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 18:18:08 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4107D20665;
        Wed, 14 Aug 2019 22:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565821086;
        bh=k8sF9ByxTFJt+xPpPS1ClUhI3arOUct3oMxaqPHO3MI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S/1z63Ov8CQ7Ns/DVtHuelIHzOPS4/tww77AgTZI+v2U7sLvnbEEPlv9WPhG4y32H
         Ky5oGomVEEFvzPSSqxC0WdbhxRINJl5SXaHNr/fe/MyCpOGumxN+7Nu+yIVU/PM4I1
         D0rTreqznnzPWBSf5XSM5YiCaXthUF0BkjISpeJc=
Date:   Wed, 14 Aug 2019 15:18:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     bjorn.topel@intel.com, linux-mm@kvack.org,
        xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
Message-Id: <20190814151805.bbff7b08f3a4119750b3e9fd@linux-foundation.org>
In-Reply-To: <20190814150934.GD4142@khorivan>
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
        <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
        <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
        <20190814150934.GD4142@khorivan>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 18:09:36 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Mon, Aug 12, 2019 at 02:19:24PM -0700, Andrew Morton wrote:
> 
> Hi, Andrew
> 
> >On Mon, 12 Aug 2019 15:43:26 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >
> >> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> >> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
> >> established already and are part of configuration interface.
> >>
> >> But for 32-bit systems, while AF_XDP socket configuration, the values
> >> are to large to pass maximum allowed file size verification.
> >> The offsets can be tuned ofc, but instead of changing existent
> >> interface - extend max allowed file size for sockets.
> >
> >
> >What are the implications of this?  That all code in the kernel which
> >handles mapped sockets needs to be audited (and tested) for correctly
> >handling mappings larger than 4G on 32-bit machines?  Has that been
> 
> That's to allow only offset to be passed, mapping length is less than 4Gb.
> I have verified all list of mmap for sockets and all of them contain dummy
> cb sock_no_mmap() except the following:
> 
> xsk_mmap()
> tcp_mmap()
> packet_mmap()
> 
> xsk_mmap() - it's what this fix is needed for.
> tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
> packet_mmap() - return -EINVAL if it's even set.

Great, thanks.

> 
> >done?  Are we confident that we aren't introducing user-visible buggy
> >behaviour into unsuspecting legacy code?
> >
> >Also...  what are the user-visible runtime effects of this change?
> >Please send along a paragraph which explains this, for the changelog.
> >Does this patch fix some user-visible problem?  If so, should be code
> >be backported into -stable kernels?
> It should go to linux-next, no one has been using it till this patch
> with 32 bits as w/o this fix af_xdp sockets can't be used at all.
> It unblocks af_xdp socket usage for 32bit systems.
> 
> 
> That's example of potential next commit message:
> Subject: mm: mmap: increase sockets maximum memory size pgoff for 32bits
> 
> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> and XDP_UMEM_PGOFF_COMPLETION_RING offsets.  These offsets are established
> already and are part of the configuration interface.
> 
> But for 32-bit systems, using AF_XDP socket configuration, these values
> are too large to pass the maximum allowed file size verification.  The
> offsets can be tuned off, but instead of changing the existing interface,
> let's extend the max allowed file size for sockets.
> 
> No one has been using it till this patch with 32 bits as w/o this fix
> af_xdp sockets can't be used at all, so it unblocks af_xdp socket usage
> for 32bit systems.
> 
> All list of mmap cbs for sockets were verified on side effects and
> all of them contain dummy cb - sock_no_mmap() at this moment, except the
> following:
> 
> xsk_mmap() - it's what this fix is needed for.
> tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
> packet_mmap() - return -EINVAL if it's even set.
>
> ...
>
> Is it ok to be replicated in PATCH v2 or this explanation is enough here
> to use v1?

I have replaced the changlog in my tree with the above, thanks.

