Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4CE1B1EC3
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 08:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgDUG2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 02:28:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39098 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgDUG2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 02:28:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B40BD20512;
        Tue, 21 Apr 2020 08:28:11 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j5fW46zN1PrC; Tue, 21 Apr 2020 08:28:11 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3E53620082;
        Tue, 21 Apr 2020 08:28:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 21 Apr 2020 08:28:11 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Apr
 2020 08:28:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 798873180126;
 Tue, 21 Apr 2020 08:28:10 +0200 (CEST)
Date:   Tue, 21 Apr 2020 08:28:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yuehaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
Message-ID: <20200421062810.GR13121@gauss3.secunet.de>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
 <20200328112302.GA13121@gauss3.secunet.de>
 <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
 <20200406090327.GF13121@gauss3.secunet.de>
 <ff4b3d2c-e6b3-33d6-141b-b093db084a18@huawei.com>
 <20200415071443.GV13121@gauss3.secunet.de>
 <f8c7d907-b6f4-c95f-b1f1-57131d19715c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8c7d907-b6f4-c95f-b1f1-57131d19715c@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 07:01:52PM +0800, Yuehaibing wrote:
> On 2020/4/15 15:14, Steffen Klassert wrote:
> > On Thu, Apr 09, 2020 at 04:19:37PM +0800, Yuehaibing wrote:
> >>
> >>
> >> On 2020/4/6 17:03, Steffen Klassert wrote:
> >>> On Mon, Mar 30, 2020 at 10:05:32PM +0800, Yuehaibing wrote:
> >>>> On 2020/3/28 19:23, Steffen Klassert wrote:
> >>>>> On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
> >>>>>> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
> >>>>>> mark and different priorities"), we allow duplicate policies with
> >>>>>> different priority, this WARN is not needed any more.
> >>>>>
> >>>>> Can you please describe a bit more detailed why this warning
> >>>>> can't trigger anymore?
> >>>>
> >>>> No, this warning is triggered while detect a duplicate entry in the policy list
> >>>>
> >>>> regardless of the priority. If we insert policy like this:
> >>>>
> >>>> policy A (mark.v = 3475289, mark.m = 0, priority = 1)	//A is inserted
> >>>> policy B (mark.v = 0, mark.m = 0, priority = 0) 	//B is inserted
> >>>> policy C (mark.v = 3475289, mark.m = 0, priority = 0)	//C is inserted and B is deleted
> >>>
> >>> The codepath that replaces a policy by another should just trigger
> >>> on policy updates (XFRM_MSG_UPDPOLICY). Is that the case in your
> >>> test?
> >>
> >> Yes, this is triggered by XFRM_MSG_UPDPOLICY
> >>
> >>>
> >>> It should not be possible to add policy C with XFRM_MSG_NEWPOLICY
> >>> as long as you have policy B inserted.
> >>>
> >>> The update replaces an old policy by a new one, the lookup keys of
> >>> the old policy must match the lookup keys of the new one. But policy
> >>> B has not the same lookup keys as C, the mark is different. So B should
> >>> not be replaced with C.
> >>
> >> 1436 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >> 1437                                    struct xfrm_policy *pol)
> >> 1438 {
> >> 1439         u32 mark = policy->mark.v & policy->mark.m;
> >> 1440
> >> 1441         if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >> 1442                 return true;
> >> 1443
> >> 1444         if ((mark & pol->mark.m) == pol->mark.v &&    //policy is C, pol is B, so mark is 0, pol->mark.m is 0, pol->mark.v is 0
> >> 1445             policy->priority == pol->priority)	   //priority is same zero, so return true, B is replaced with C
> >> 1446                 return true;
> >> 1447
> >> 1448         return false;
> >> 1449 }
> >>
> >> Should xfrm_policy_mark_match be fixed？
> > 
> > Yes, xfrm_policy_mark_match should only replace if the found
> > policy has the same lookup keys.
> 
> I'm wonder that lookup keys means association of mark.v and mark.m, or the mark (mark.v & mark.m).

Good point. I'd say the lookup lookup keys are identical if the policy
lookup can't distinguish between the policies. So (mark.v & mark.m)
should be it.
