Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B116109BD
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 07:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJ1F3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 01:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ1F3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 01:29:37 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69AEDA3;
        Thu, 27 Oct 2022 22:29:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VTF-aiQ_1666934966;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VTF-aiQ_1666934966)
          by smtp.aliyun-inc.com;
          Fri, 28 Oct 2022 13:29:27 +0800
Date:   Fri, 28 Oct 2022 13:29:25 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jan Karcher <jaka@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
Message-ID: <Y1totRGH3t9u3QlQ@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
 <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
 <79e3bccb-55c2-3b92-b14a-7378ef02dd78@linux.ibm.com>
 <4127d84d-e3b4-ca44-2531-8aed12fdee3f@linux.alibaba.com>
 <f8ea7943-4267-8b8d-f8b4-831fea7f3963@linux.ibm.com>
 <Y1d+jDQiyn4LSKlu@TonyMac-Alibaba>
 <35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 03:12:48PM +0200, Jan Karcher wrote:
> 
> 
> On 25/10/2022 08:13, Tony Lu wrote:
> > On Mon, Oct 24, 2022 at 03:10:54PM +0200, Jan Karcher wrote:
> > > Hi D. Wythe,
> > > 
> > > I reply with the feedback on your fix to your v4 fix.
> > > 
> > > Regarding your questions:
> > > We are aware of this situation and we are currently evaluating how we want
> > > to deal with SMC-D in the future because as of right now i can understand
> > > your frustration regarding the SMC-D testing.
> > > Please give me some time to hit up the right people and collect some
> > > information to answer your question. I'll let you know as soon as i have an
> > > answer.
> 
> Hi Tony (and D.),
> > 
> > Hi Jan,
> > 
> > We sent a RFC [1] to mock SMC-D device for inter-VM communication. The
> > original purpose is not to test, but for now it could be useful for the
> > people who are going to test without physical devices in the community.
> 
> I'm aware of the RFC and various people in IBM looked over it.
> 
> As stated in the last mail we are aware that the entanglement between SMC-D
> and ISM is causing problems for the community.
> To give you a little insight:
> 
> In order to improve the code quality and usability for the broader community
> we are working on placing an API between SMC-D and the ISM device. If this
> API is complete it will be easier to use different "devices" for SMC-D. One
> could be your device driver for inter-VM communication (ivshmem).
> Another one could be a "Dummy-Device" which just implements the required
> interface which acts as a loopback device. This would work only in a single
> Linux instance, thus would be the perfect device to test SMC-D logic for the
> broad community.

That sounds great :-) It will provide many possibilities.

> We would hope that these changes remove the hardware restrictions and that
> the community picks up the idea and implements devices and improves SMC
> (including SMC-D and SMC-R) even more in the future!
> 
> As i said - and also teased by Alexandra in a respond to your RFC - this API
> feature is currently being developed and in our internal reviews. This would
> make your idea with the inter-VM communication a lot easier and would
> provide a clean base to build upon in the future.

Great +1.

> 
> > 
> > This driver basically works but I would improve it for testing. Before
> > that, what do you think about it?
> 
> I think it is a great idea and we should definetly give it a shot! I'm also
> putting a lot in code quality and future maintainability. The API is a key
> feature there improving the usability for the community and our work as
> maintainers. So - for the sake of the future of the SMC code base - I'd like
> to wait with putting your changes upstream for the API and use your idea to
> see if fits our (and your) requirements.

Sure. We are very much looking forward to the new API :-) Maybe we can
discuss this API in the mail list, and I'd like to adapt it first.

> 
> > 
> > And where to put this driver? In kernel with SMC code or merge into
> > separate SMC test cases. I haven't made up my mind yet.
> 
> We are not sure either currently, and have to think about that for a bit. I
> think your driver could be a classic driver, since it is usable for a real
> world problem (communication between two VMs on the same host). If we look
> at the "Dummy-Device" above we see that it does not provide any value beside
> testing. Feel free to share your ideas on that topic.

I agree with this. SMC would provides a common ability that drivers can
be introduced as classic driver for every individual device, maybe likes
ethernet cards with their drivers.

And for dummy devices, I have an idea that provides the same
shared-memory ability for same host, just like loopback devices for
TCP/IP. SMC-D with loopback devices also shows better performance compared
with other protocols.

Maybe SMC can cover all the scenes including inter-host (SMC-R),
inter-VM (SMC-D) and inter-local-process (SMC-D) communication with the
fastest path, and make things easier for user-space. I'd like to share
this RFC later when it's ready.

> 
> > 
> > [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
> > 
> > Cheers,
> > Tony Lu
> 
> A friendly disclaimer: Even tho this API feature is pretty far in the
> development process it can always be that we decide to drop it, if it does
> not meet our quality expectations. But of course we'll keep you updated.
> 

No problem. If there has something that we can involve, we'd be pleasure
to do that.

Cheers,
Tony Lu


> - Jan
