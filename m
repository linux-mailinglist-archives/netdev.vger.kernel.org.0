Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95CF4413F9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKAHG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:06:56 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58386 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhKAHGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:06:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UuTvRIP_1635750248;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuTvRIP_1635750248)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 15:04:08 +0800
Date:   Mon, 1 Nov 2021 15:04:08 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <YX+RaKfBVzFokQON@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
 <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 07:38:27AM -0700, Jakub Kicinski wrote:
> On Thu, 28 Oct 2021 13:57:55 +0200 Karsten Graul wrote:
> > So how to deal with all of this? Is it an accepted programming error
> > when a user space program gets itself into this kind of situation?
> > Since this problem depends on internal send/recv buffer sizes such a
> > program might work on one system but not on other systems.
> 
> It's a gray area so unless someone else has a strong opinion we can
> leave it as is.

Things might be different. IMHO, the key point of this problem is to
implement the "standard" POSIX socket API, or TCP-socket compatible API.

> > At the end the question might be if either such kind of a 'deadlock'
> > is acceptable, or if it is okay to have send() return lesser bytes
> > than requested.
> 
> Yeah.. the thing is we have better APIs for applications to ask not to
> block than we do for applications to block. If someone really wants to
> wait for all data to come out for performance reasons they will
> struggle to get that behavior. 

IMO, it is better to do something to unify this behavior. Some
applications like netperf would be broken, and the people who want to use
SMC to run basic benchmark, would be confused about this, and its
compatibility with TCP. Maybe we could:
1) correct the behavior of netperf to check the rc as we discussed.
2) "copy" the behavior of TCP, and try to compatiable with TCP, though
it is a gray area.


Cheers,
Tony Lu

> We also have the small yet pernicious case where the buffer is
> completely full at sendmsg() time, IOW we didn't send a single byte.
> We won't be able to return "partial" results and deadlock. IDK if your
> application can hit this, but it should really use non-blocking send if
> it doesn't want blocking behavior..
