Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF6E4AEE7C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiBIJxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiBIJxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:53:11 -0500
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED7E076B5D;
        Wed,  9 Feb 2022 01:53:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4-Z1JE_1644400163;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4-Z1JE_1644400163)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:49:23 +0800
Date:   Wed, 9 Feb 2022 17:49:20 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YgOOIGDx9/0cwsCV@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal>
 <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
 <YfJlFe3p2ABbzoYI@unreal>
 <YfJq5pygXS13XRhp@TonyMac-Alibaba>
 <3fcfdf75-eb8c-426d-5874-3afdc49de743@linux.ibm.com>
 <YfOTa5uIPUw+gOfM@TonyMac-Alibaba>
 <6739dd5f-aaa9-dce9-4b06-08060fe267da@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6739dd5f-aaa9-dce9-4b06-08060fe267da@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 05:50:48PM +0100, Karsten Graul wrote:
> On 28/01/2022 07:55, Tony Lu wrote:
> > On Thu, Jan 27, 2022 at 03:52:36PM +0100, Karsten Graul wrote:
> >> On 27/01/2022 10:50, Tony Lu wrote:
> >>> On Thu, Jan 27, 2022 at 11:25:41AM +0200, Leon Romanovsky wrote:
> >>>> On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
> >>>>> On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
> >>>>>> On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> >>>>>
> >>>>> Sorry for that if I missed something about properly using existing
> >>>>> in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
> >>>>> and ib_cq_pool_put()?
> >>>>>
> >>>>> If so, these APIs doesn't suit for current smc's usage, I have to
> >>>>> refactor logic (tasklet and wr_id) in smc. I think it is a huge work
> >>>>> and should do it with full discussion.
> >>>>
> >>>> This discussion is not going anywhere. Just to summarize, we (Jason and I)
> >>>> are asking to use existing API, from the beginning.
> >>>
> >>> Yes, I can't agree more with you about using existing API and I have
> >>> tried them earlier. The existing APIs are easy to use if I wrote a new
> >>> logic. I also don't want to repeat the codes.
> >>>
> >>> The main obstacle is that the packet and wr processing of smc is
> >>> tightly bound to the old API and not easy to replace with existing API.
> >>>
> >>> To solve a real issue, I have to fix it based on the old API. If using
> >>> existing API in this patch, I have to refactor smc logics which needs
> >>> more time. Our production tree is synced with smc next. So I choose to
> >>> fix this issue first, then refactor these logic to fit existing API once
> >>> and for all.
> >>
> >> While I understand your approach to fix the issue first I need to say
> >> that such interim fixes create an significant amount of effort that has to
> >> be spent for review and test for others. And there is the increased risk 
> >> to introduce new bugs by just this only-for-now fix.
> > 
> > Let's back to this patch itself. This approach spreads CQs to different
> > vectors, it tries to solve this issue under current design and not to
> > introduce more changes to make it easier to review and test. It severely
> > limits the performance of SMC when replacing TCP. This patch tries to
> > reduce the gap between SMC and TCP.
> > 
> > To use newer API, it should have a lots of work to do with wr process
> > logic, for example remove tasklet handler, refactor wr_id logic. I have
> > no idea if we should do this? If it's okay and got your permission, I
> > will do this in the next patch.
> 
> Hi Tony,
> 
> I think there was quite a discussion now about this patch series and the conclusion from 
> the RDMA list and from my side was that if this code is changed it should be done using
> the new API. The current version re-implements code that is already available there.
> 
> I agree that using the new API is the way to go, and I am in for any early discussions
> about the changes that are needed.
> 

Thank you for pointing me to the sure way.

I am working on this. I will send the complete refactor version with the
new API later.

Best regards,
Tony Lu
