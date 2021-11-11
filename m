Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284CF44D391
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 09:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhKKI71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 03:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhKKI71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 03:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850BF61884;
        Thu, 11 Nov 2021 08:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636620998;
        bh=sE/wsCuVFrDFdU7KxWKCbILvWcYkGJYS1wyCg2ri3+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z0XLGu2d217WzQ2kPfDprdMHYIjNm6j+Jh11Xg8i4lGTqgaZDtUGKMb4UQCMB12Bg
         6YD+NzUB8ljFZmkqL/5nCWD8Ph5kbgZeKxxiDng7r9ZE5uYWaufngJabk6SPknuift
         m79JF6hSUg6efd/fX2rQDqqa7N+APMxB7xhhRSCg=
Date:   Thu, 11 Nov 2021 09:56:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     syzbot <syzbot+5434727aa485c3203fed@syzkaller.appspotmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "yhs@fb.com" <yhs@fb.com>
Subject: Re: [syzbot] WARNING in __dev_change_net_namespace
Message-ID: <YYzaw+7TSwcGTGQI@kroah.com>
References: <0000000000008a7c9605d07da846@google.com>
 <e6bfbffa089c711fa3ea21f5f8ab852aaa4d9c00.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6bfbffa089c711fa3ea21f5f8ab852aaa4d9c00.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 08:50:33AM +0100, Johannes Berg wrote:
> On Thu, 2021-11-11 at 06:43 +0000, syzbot wrote:
> > 
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15b45fb6b00000
> 
> So we see that fault injection is triggering a memory allocation failure
> deep within the device_rename():
> 
> int __dev_change_net_namespace(struct net_device *dev, struct net *net,
>                                const char *pat, int new_ifindex)
> {
> ...
>         /* Fixup kobjects */
>         err = device_rename(&dev->dev, dev->name);
>         WARN_ON(err);
> 
> 
> So we hit that WARN_ON().
> 
> I'm not really sure what to do about that though. Feels like we should
> be able to cope with failures here, but clearly we don't, and it seems
> like it would also be tricky to do after all the work already done at
> this point.
> 
> Perhaps device_rename() could grow an API to preallocate all the
> memories, but that would also be fairly involved, I imagine?

That would be a mess to unwind at times.  For fault-injection stuff like
this, that can not be hit in "real world operation", if the issue can
not be easily handled, I don't think it is worth worrying about.

We have some things like this in the tty layer at boot time, if a memory
failure happens then, we have bigger overall problems in the system than
trying to recover from minor stuff like this.

thanks,

greg k-h
