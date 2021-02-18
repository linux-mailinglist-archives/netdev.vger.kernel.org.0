Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CBF31EA9F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhBRNzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:55:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:36448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhBRMyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 07:54:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613652819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v2M2f1didXi8qZbKbJNpKDVS3nQGtSjoYLz7GZ8G2oA=;
        b=ajJ7vi+VZU89eb/Xc0CIb/zbZ8fbz4u0n5nZ1PPyXZB1MjEiPGbcoUjg4gO+pEQzZN5oxY
        iS9PjZxTlHUPjRgYAoph22HnxcE/HR5nPx62wTdId879+BdncP3cqBdQMzcuRtwfE/kF1G
        TG8YVslckFPZaRMtiH6w0yE1tk8Rlbw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DEE34ACE5;
        Thu, 18 Feb 2021 12:53:38 +0000 (UTC)
Date:   Thu, 18 Feb 2021 13:53:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, linux@rasmusvillemoes.dk,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: check for NULL device_node name in
 device_node_string()
Message-ID: <YC5jUqxphRvyuMEv@alley>
References: <20210217121543.13010-1-info@metux.net>
 <YC0fCAp6wxJfizD7@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC0fCAp6wxJfizD7@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2021-02-17 15:50:00, Andy Shevchenko wrote:
> On Wed, Feb 17, 2021 at 01:15:43PM +0100, Enrico Weigelt, metux IT consult wrote:
> > Under rare circumstances it may happen that a device node's name is NULL
> > (most likely kernel bug in some other place).
> 
> What circumstances? How can I reproduce this? More information, please!
> 
> > In such situations anything
> > but helpful, if the debug printout crashes, and nobody knows what actually
> > happened here.
> > 
> > Therefore protect it by an explicit NULL check and print out an extra
> > warning.
> 
> ...
> 
> > +				pr_warn("device_node without name. Kernel bug ?\n");
> 
> If it's not once, then it's possible to have log spammed with this, right?
> 
> ...
> 
> > +				p = "<NULL>";
> 
> We have different standard de facto for NULL pointers to be printed. Actually
> if you wish, you may gather them under one definition (maybe somewhere under
> printk) and export to everybody to use.

Please, use

	if (check_pointer(&buf, end, p, spec))
		return buf;

It will print "(null)" instead of the name. It should be enough
to inform the user this way. The extra pr_warn() does not help
much to localize the problem anyway. And it is better to avoid
recursion in this path.

Best Regards,
Petr
