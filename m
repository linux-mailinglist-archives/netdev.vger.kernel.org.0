Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46159484F56
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbiAEI2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:28:46 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:43913 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbiAEI2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:28:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1020Uj_1641371321;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1020Uj_1641371321)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 16:28:42 +0800
Date:   Wed, 5 Jan 2022 16:28:41 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <YdVWuWx+ygpD5gjX@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105044049.GA107642@e02h04389.eu6sqa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 12:40:49PM +0800, D. Wythe wrote:
> Hi, 
> 
> Since we are trying to use the backlog parameter to limit smc dangling
> connections, it's seems there's no difference from increasing the
> backlog parameter for the TCP listen socket, user space Application can
> simply avoid the 10K connections problem through that.
> 
> If so, this patch looks redundant to me. Look forward to your advise.
> 
> Thanks.

Hi D. Wythe,

IMHO, this patch is still useful for flood-connections scenes.
Karsten concerns the safety in flood case, we should limit the number
of tcp sockets for safety.

Imaging these two scenes:
- general socket setup process, if with this patch, setting up tcp
  socket is faster, but we also need to wait for the rest part of
  handshake (rdma...). Meanwhile, there are lots of dangling sockets,
  which may cause kernel OOM. If it isn't first-connected peer, the
  rest part is faster, and this patch should be useful.
- always fallback to tcp, the rest part of handshake failed, so we need
  to fallback, this patch should make it faster to fallback.

Whatever scenes we met, it could be better to limit the number of
"half-connected", like backlog in tcp. There is a possible approach,
using sysctl to limit the global or net-namespace max backlog.
Currently, smc doesn't support sysctl yet. I sent an incomplete sysctl
patch before, maybe it could help you. If so, I will fix that patch, and
resent it out.

Thanks,
Tony Lu
 
> On Tue, Jan 04, 2022 at 02:45:35PM +0100, Karsten Graul wrote:
> > On 04/01/2022 14:12, D. Wythe wrote:
> > > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > > 
> > > In nginx/wrk multithread and 10K connections benchmark, the
> > > backend TCP connection established very slowly, and lots of TCP
> > > connections stay in SYN_SENT state.
> > 
> > I see what you are trying to solve here.
> > So what happens with your patch now is that we are accepting way more connections
> > in advance and queue them up for the SMC connection handshake worker.
> > The connection handshake worker itself will not run faster with this change, so overall
> > it should be the same time that is needed to establish all connections.
> > What you solve is that when 10k connections are started at the same time, some of them
> > will be dropped due to tcp 3-way handshake timeouts. Your patch avoids that but one can now flood
> > the stack with an ~infinite amount of dangling sockets waiting for the SMC handshake, maybe even 
> > causing oom conditions.
> > 
> > What should be respected with such a change would be the backlog parameter for the listen socket,
> > i.e. how many backlog connections are requested by the user space application?
> > There is no such handling of backlog right now, and due to the 'braking' workers we avoided
> > to flood the kernel with too many dangling connections. With your change there should be a way to limit
> > this ind of connections in some way.
