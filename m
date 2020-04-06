Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9219F1FF
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDFJDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 05:03:31 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43986 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgDFJDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 05:03:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A047820523;
        Mon,  6 Apr 2020 11:03:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3hYAfdPan_2n; Mon,  6 Apr 2020 11:03:28 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3730D2051F;
        Mon,  6 Apr 2020 11:03:28 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 6 Apr 2020
 11:03:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9DCB53180093; Mon,  6 Apr 2020 11:03:27 +0200 (CEST)
Date:   Mon, 6 Apr 2020 11:03:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yuehaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
Message-ID: <20200406090327.GF13121@gauss3.secunet.de>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
 <20200328112302.GA13121@gauss3.secunet.de>
 <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 10:05:32PM +0800, Yuehaibing wrote:
> On 2020/3/28 19:23, Steffen Klassert wrote:
> > On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
> >> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
> >> mark and different priorities"), we allow duplicate policies with
> >> different priority, this WARN is not needed any more.
> > 
> > Can you please describe a bit more detailed why this warning
> > can't trigger anymore?
> 
> No, this warning is triggered while detect a duplicate entry in the policy list
> 
> regardless of the priority. If we insert policy like this:
> 
> policy A (mark.v = 3475289, mark.m = 0, priority = 1)	//A is inserted
> policy B (mark.v = 0, mark.m = 0, priority = 0) 	//B is inserted
> policy C (mark.v = 3475289, mark.m = 0, priority = 0)	//C is inserted and B is deleted

The codepath that replaces a policy by another should just trigger
on policy updates (XFRM_MSG_UPDPOLICY). Is that the case in your
test?

It should not be possible to add policy C with XFRM_MSG_NEWPOLICY
as long as you have policy B inserted.

The update replaces an old policy by a new one, the lookup keys of
the old policy must match the lookup keys of the new one. But policy
B has not the same lookup keys as C, the mark is different. So B should
not be replaced with C.

> policy D (mark.v = 3475289, mark.m = 0, priority = 1)	
> 
> while finding delpol in xfrm_policy_insert_list,
> first round delpol is matched C, whose priority is less than D, so contiue the loop,
> then A is matched， WARN_ON is triggered.  It seems the WARN is useless.

Looks like the warning is usefull, it found a bug.

