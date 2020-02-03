Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F374A150999
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgBCPQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:16:55 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38920 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgBCPQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:16:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so17607172wme.4
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 07:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arangodb.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oDRH5we1LRYr69H/g74BFyb9GhUUuAeUSoG8mXyHu3Y=;
        b=fl1ZYh0CUf3sMGtHtJIdJafqlYKLZsSI1uu6QurSiwRuCTiVJqh9V0cgqfAZkuYn2S
         fXV9TTePcAwikD+BC5HR6ZHhzT00wtG+qlrpBQ2Wdn5vUqVy6Bx+g7R5fa+HziqZ6Odm
         llpf1Jt1DT8yD9+pX8BwrZtNhPoh7hpgfOtBrMgiKpA8nf5H9XBIXmfw1qg0KprYgfSw
         IBVnql47upOCp2D8yO/F4lG3svM0wg5RwmuIrl8ppeivODqmrlpuUvzvK5KqqjYbd3kW
         26nq1Ky+W7oW6Mw2INas3fWVOddwxEeg3PyU7BuMHtzNm7TMmEejgAjkYnbaKw7H/oFC
         q8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oDRH5we1LRYr69H/g74BFyb9GhUUuAeUSoG8mXyHu3Y=;
        b=WxLuyaqSoWkBUtrvvSo5mCracbEEarQ6c4MfjtHT+39kh6jZnC1v/NmMo1kEEhOYh8
         ufH7MpRBzuJNoon4ahMPtcrgw9gK8IJ/9Uaz3H/e+YieXVZuPHFuZ/g15Xo31ldbPMqx
         zN5bLuWD4OuqrmRmhpw2pZmI5hRucqbt7hUGF4jaLjRgn9GsoAQELMnFqcvrqHgUjZ5S
         mcoFUud6ZrytsQSm5F/XqNmRMjzFU++ppaK68lGkLiEZnPfItPjTvlp8HT7dcOMFE9wm
         ebsbaM0hY7RkmsEVjHoZg/8M1JGo6F5mgZyVax6Bi9tJtlLLsMIxyPcUL5FSVRnxIRfL
         U0JQ==
X-Gm-Message-State: APjAAAXweARR+5nZ56SNw5uE9XylPS8D5yMwF1YEggAQA36HphJi+V0R
        vZBE6+pjr1vCBDrCDULejwC57Exsdw==
X-Google-Smtp-Source: APXvYqy9zJqEX1AE9F9FSyxmUYx5bGNX2475G5HyDwL44k6DUQVwT9KWcQDJJvYA7H0B4qM5xdkivw==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr31280131wmk.5.1580743013835;
        Mon, 03 Feb 2020 07:16:53 -0800 (PST)
Received: from localhost (static-85-197-33-87.netcologne.de. [85.197.33.87])
        by smtp.gmail.com with ESMTPSA id z19sm22877844wmi.43.2020.02.03.07.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 07:16:53 -0800 (PST)
Date:   Mon, 3 Feb 2020 16:15:36 +0100
From:   Max Neunhoeffer <max@arangodb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Roman Penyaev <rpenyaev@suse.de>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Subject: Re: epoll_wait misses edge-triggered eventfd events: bug in Linux
 5.3 and 5.4
Message-ID: <20200203151536.caf6n4b2ymvtssmh@tux>
References: <20200131135730.ezwtgxddjpuczpwy@tux>
 <20200201121647.62914697@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201121647.62914697@cakuba.hsd1.ca.comcast.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub and all,

I have done a git bisect and found that this commit introduced the epoll
bug:

https://github.com/torvalds/linux/commit/a218cc4914209ac14476cb32769b31a556355b22

I Cc the author of the commit.

This makes sense, since the commit introduces a new rwlock to reduce
contention in ep_poll_callback. I do not fully understand the details
but this sounds all very close to this bug.

I have also verified that the bug is still present in the latest master
branch in Linus' repository.

Furthermore, Chris Kohlhoff has provided yet another reproducing program
which is no longer using edge-triggered but standard level-triggered
events and epoll_wait. This makes the bug all the more urgent, since
potentially more programs could run into this problem and could end up
with sleeping barbers.

I have added all the details to the bugzilla bugreport:

  https://bugzilla.kernel.org/show_bug.cgi?id=205933

Hopefully, we can resolve this now equipped with this amount of information.

Best regards,
  Max.

On 20/02/01 12:16, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 14:57:30 +0100, Max Neunhoeffer wrote:
> > Dear All,
> > 
> > I believe I have found a bug in Linux 5.3 and 5.4 in epoll_wait/epoll_ctl
> > when an eventfd together with edge-triggered or the EPOLLONESHOT policy
> > is used. If an epoll_ctl call to rearm the eventfd happens approximately
> > at the same time as the epoll_wait goes to sleep, the event can be lost, 
> > even though proper protection through a mutex is employed.
> > 
> > The details together with two programs showing the problem can be found
> > here:
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=205933
> > 
> > Older kernels seem not to have this problem, although I did not test all
> > versions. I know that 4.15 and 5.0 do not show the problem.
> > 
> > Note that this method of using epoll_wait/eventfd is used by
> > boost::asio to wake up event loops in case a new completion handler
> > is posted to an io_service, so this is probably relevant for many
> > applications.
> > 
> > Any help with this would be appreciated.
> 
> Could be networking related but let's CC FS folks just in case.
> 
> Would you be able to perform bisection to narrow down the search 
> for a buggy change?
