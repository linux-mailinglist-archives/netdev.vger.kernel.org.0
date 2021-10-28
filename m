Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84A43DB7F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhJ1Gu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:50:58 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47315 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhJ1Gu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:50:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Utyxk-0_1635403708;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Utyxk-0_1635403708)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 14:48:29 +0800
Date:   Thu, 28 Oct 2021 14:48:28 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <YXpHvKGhPzcNoEtD@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 08:47:10AM -0700, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 17:38:27 +0200 Karsten Graul wrote:
> > What we found out was that applications called sendmsg() with large data
> > buffers using blocking sockets. This led to the described situation, were the
> > solution was to early return to user space even if not all data were sent yet.
> > Userspace applications should not have a problem with the fact that sendmsg()
> > returns a smaller byte count than requested.
> > 
> > Reverting this patch would bring back the stalled connection problem.
> 
> I'm not sure. The man page for send says:
> 
>        When the message does not fit into  the  send  buffer  of  the  socket,
>        send()  normally blocks, unless the socket has been placed in nonblock‐
>        ing I/O mode.  In nonblocking mode it would fail with the error  EAGAIN
>        or  EWOULDBLOCK in this case.
> 
> dunno if that's required by POSIX or just a best practice.

The man page describes the common cases about the socket API behavior,
but depends on the implement.

For example, the connect(2) implement of TCP, it would never block, but
also provides EAGAIN errors for UNIX domain sockets.

       EAGAIN For nonblocking UNIX domain sockets, the socket is
              nonblocking, and the connection cannot be completed
              immediately.  For other socket families, there are
              insufficient entries in the routing cache.

In my opinion, if we are going to replace TCP with SMC, these userspace
socket API should behavior as same, and don't break the userspace
applications like netperf. It could be better to block here when sending
message without enough buffer.

In our benchmarks and E2E tests (Redis, MySQL, etc.), it is acceptable to
block here. Because the userspace applications usually block in the loop
until the data send out. If it blocks, the scheduler can handle it.
