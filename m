Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E659149F3E3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbiA1Gzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:55:43 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:45765 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346504AbiA1Gzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:55:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V31QM7r_1643352940;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V31QM7r_1643352940)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 Jan 2022 14:55:40 +0800
Date:   Fri, 28 Jan 2022 14:55:39 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfOTa5uIPUw+gOfM@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal>
 <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
 <YfJlFe3p2ABbzoYI@unreal>
 <YfJq5pygXS13XRhp@TonyMac-Alibaba>
 <3fcfdf75-eb8c-426d-5874-3afdc49de743@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fcfdf75-eb8c-426d-5874-3afdc49de743@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 03:52:36PM +0100, Karsten Graul wrote:
> On 27/01/2022 10:50, Tony Lu wrote:
> > On Thu, Jan 27, 2022 at 11:25:41AM +0200, Leon Romanovsky wrote:
> >> On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
> >>> On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
> >>>> On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> >>>
> >>> Sorry for that if I missed something about properly using existing
> >>> in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
> >>> and ib_cq_pool_put()?
> >>>
> >>> If so, these APIs doesn't suit for current smc's usage, I have to
> >>> refactor logic (tasklet and wr_id) in smc. I think it is a huge work
> >>> and should do it with full discussion.
> >>
> >> This discussion is not going anywhere. Just to summarize, we (Jason and I)
> >> are asking to use existing API, from the beginning.
> > 
> > Yes, I can't agree more with you about using existing API and I have
> > tried them earlier. The existing APIs are easy to use if I wrote a new
> > logic. I also don't want to repeat the codes.
> > 
> > The main obstacle is that the packet and wr processing of smc is
> > tightly bound to the old API and not easy to replace with existing API.
> > 
> > To solve a real issue, I have to fix it based on the old API. If using
> > existing API in this patch, I have to refactor smc logics which needs
> > more time. Our production tree is synced with smc next. So I choose to
> > fix this issue first, then refactor these logic to fit existing API once
> > and for all.
> 
> While I understand your approach to fix the issue first I need to say
> that such interim fixes create an significant amount of effort that has to
> be spent for review and test for others. And there is the increased risk 
> to introduce new bugs by just this only-for-now fix.

Let's back to this patch itself. This approach spreads CQs to different
vectors, it tries to solve this issue under current design and not to
introduce more changes to make it easier to review and test. It severely
limits the performance of SMC when replacing TCP. This patch tries to
reduce the gap between SMC and TCP.

To use newer API, it should have a lots of work to do with wr process
logic, for example remove tasklet handler, refactor wr_id logic. I have
no idea if we should do this? If it's okay and got your permission, I
will do this in the next patch.

> Given the fact that right now you are the only one who is affected by this problem
> I recommend to keep your fix in your environment for now, and come back with the
> final version. In the meantime I can use the saved time to review the bunch 
> of other patches that we received.

I really appreciate the time you spent reviewing our patch. Recently,
our team has submitted a lot of patches and got your detailed
suggestions, including panic (linkgroup, CDC), performance and so on.
We are using SMC in our public cloud environment. Therefore, we maintain
a internal tree and try to contribute these changes to upstream, and we
will continue to invest to improve the stability, performance and
compatibility, and focus on SMC for a long time.

We are willing to commit time and resource to help out in reviewing and
testing the patch in mail list and -next, as reviewer or tester.

We have built up CI/CD and nightly test for SMC. And we intend to send
test reports for each patch in the mail list, help to review, find out
panic and performance regression.

Not sure if this proposal will help save your time to review other
patches? Glad to hear your advice.

Thank you,
Tony Lu
