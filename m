Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0047323DE5B
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgHFRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729842AbgHFRDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:03:24 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D8C061A19;
        Thu,  6 Aug 2020 05:09:12 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k3ehe-00ATwx-OM; Thu, 06 Aug 2020 12:08:58 +0000
Date:   Thu, 6 Aug 2020 13:08:58 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] net: Set fput_needed iff FDPUT_FPUT is set
Message-ID: <20200806120858.GA2497432@ZenIV.linux.org.uk>
References: <1596714796-25298-1-git-send-email-linmiaohe@huawei.com>
 <20200806115915.GO1236603@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806115915.GO1236603@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 12:59:16PM +0100, Al Viro wrote:
> On Thu, Aug 06, 2020 at 07:53:16PM +0800, linmiaohe wrote:
> > From: Miaohe Lin <linmiaohe@huawei.com>
> > 
> > We should fput() file iff FDPUT_FPUT is set. So we should set fput_needed
> > accordingly.
> > 
> > Fixes: 00e188ef6a7e ("sockfd_lookup_light(): switch to fdget^W^Waway from fget_light")
> 
> Explain, please.  We are getting it from fdget(); what else can we get in flags there?

FWIW, struct fd ->flags may have two bits set: FDPUT_FPUT and FDPUT_POS_UNLOCK.
The latter is set only by __fdget_pos() and its callers, and that only for
regular files and directories.

Nevermind that sockfd_lookup_light() does *not* use ..._pos() family of
primitives, even if it started to use e.g. fdget_pos() it *still* would
not end up with anything other than FDPUT_FPUT to deal with on that
path - it checks that what it got is a socket.  Anything else is dropped
right there, without leaving fput() to caller.

So could you explain what exactly the bug is - if you are seeing some
breakage and this patch fixes it, something odd is definitely going on
and it would be nice to figure out what that something is.

