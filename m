Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4853E443BAA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhKCDIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:08:45 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60561 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhKCDIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:08:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UupXNxJ_1635908766;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UupXNxJ_1635908766)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 11:06:07 +0800
Date:   Wed, 3 Nov 2021 11:06:06 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <YYH8npT0+ww57Gg1@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
 <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YX+RaKfBVzFokQON@TonyMac-Alibaba>
 <ca2a567b-915e-c4e1-96cf-2c03ff74aad5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca2a567b-915e-c4e1-96cf-2c03ff74aad5@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 10:17:15AM +0100, Karsten Graul wrote:
> On 01/11/2021 08:04, Tony Lu wrote:
> > On Thu, Oct 28, 2021 at 07:38:27AM -0700, Jakub Kicinski wrote:
> >> On Thu, 28 Oct 2021 13:57:55 +0200 Karsten Graul wrote:
> >>> So how to deal with all of this? Is it an accepted programming error
> >>> when a user space program gets itself into this kind of situation?
> >>> Since this problem depends on internal send/recv buffer sizes such a
> >>> program might work on one system but not on other systems.
> >>
> >> It's a gray area so unless someone else has a strong opinion we can
> >> leave it as is.
> > 
> > Things might be different. IMHO, the key point of this problem is to
> > implement the "standard" POSIX socket API, or TCP-socket compatible API.
> > 
> >>> At the end the question might be if either such kind of a 'deadlock'
> >>> is acceptable, or if it is okay to have send() return lesser bytes
> >>> than requested.
> >>
> >> Yeah.. the thing is we have better APIs for applications to ask not to
> >> block than we do for applications to block. If someone really wants to
> >> wait for all data to come out for performance reasons they will
> >> struggle to get that behavior. 
> > 
> > IMO, it is better to do something to unify this behavior. Some
> > applications like netperf would be broken, and the people who want to use
> > SMC to run basic benchmark, would be confused about this, and its
> > compatibility with TCP. Maybe we could:
> > 1) correct the behavior of netperf to check the rc as we discussed.
> > 2) "copy" the behavior of TCP, and try to compatiable with TCP, though
> > it is a gray area.
> 
> I have a strong opinion here, so when the question is if the user either
> encounters a deadlock or if send() returns lesser bytes than requested,
> I prefer the latter behavior.
> The second case is much easier to debug for users, they can do something
> to handle the problem (loop around send()), and this case can even be detected
> using strace. But the deadlock case is nearly not debuggable by users and there
> is nothing to prevent it when the workload pattern runs into this situation
> (except to not use blocking sends).

I agree with you. I am curious about this deadlock scene. If it was
convenient, could you provide a reproducible test case? We are also
setting up a SMC CI/CD system to find the compatible and performance
fallback problems. Maybe we could do something to make it better.

Cheers,
Tony Lu
