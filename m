Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24534238B8
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbhJFHVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233968AbhJFHVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 03:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2875C61100;
        Wed,  6 Oct 2021 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633504798;
        bh=l+AatlQLTB90gzM+ksNISTiUQbVsGoVQUFzWrlXlbUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lNUHBwRt3rV1slnHxZn4Dh/eGDVOc5Z0WdRybm335Rp7zHZB/m6TbNXOyX9rrDCzx
         T6Br3ur/vPFVV5wcRTRU5YF25NjExfTL2ZwJR+o8ges8J7SjZoJgFvgAKDrFJou1D0
         no/31QfWB2ZHnTkXly7hZ0cWO6PmjZVfrBsGRjJY=
Date:   Wed, 6 Oct 2021 09:19:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Thomas Backlund <tmb@iki.fi>, Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
Message-ID: <YV1OF1lZHk1USYRR@kroah.com>
References: <20211005083311.830861640@linuxfoundation.org>
 <20211005155909.GA1386975@roeck-us.net>
 <4ecdfb07-4957-913a-6bd3-4410bd2cb5c0@iki.fi>
 <CA+G9fYs=K4V4MgApsoEfGm6YUFnRSP6X6r7_H0uJ-ZzHp4EFJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs=K4V4MgApsoEfGm6YUFnRSP6X6r7_H0uJ-ZzHp4EFJQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 01:12:17AM +0530, Naresh Kamboju wrote:
> On Wed, 6 Oct 2021 at 00:37, Thomas Backlund <tmb@iki.fi> wrote:
> >
> > Den 2021-10-05 kl. 18:59, skrev Guenter Roeck:
> > > On Tue, Oct 05, 2021 at 10:38:40AM +0200, Greg Kroah-Hartman wrote:
> > >> This is the start of the stable review cycle for the 5.14.10 release.
> > >> There are 173 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >>
> > >> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >
> > > AFAICS the warning problems are still seen. Unfortunately I won't be able
> > > to bisect since I have limited internet access.
> > >
> > > Guenter
> > >
> > > =========================
> > > WARNING: held lock freed!
> > > 5.14.10-rc2-00174-g355f3195d051 #1 Not tainted
> > > -------------------------
> > > ip/202 is freeing memory c000000009918900-c000000009918f7f, with a lock still held there!
> > > c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> > > 2 locks held by ip/202:
> > >   #0: c00000000ae149d0 (&sb->s_type->i_mutex_key#5){+.+.}-{3:3}, at: .__sock_release+0x4c/0x150
> > >   #1: c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> > >
> > >
> >
> 
> When I reverted the following two patches the warning got fixed.
> 
> 73a03563f123 af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Odd, this one is in all trees right now, yet no one else is having a
problem.

> b226d61807f1 net: introduce and use lock_sock_fast_nested()

This is only in the 5.14.y tree.  Let me go drop this one, and do a new
-rc release here.

thanks,

greg k-h
