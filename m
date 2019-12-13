Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E24E11E295
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 12:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLMLNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 06:13:24 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51318 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfLMLNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 06:13:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3184C20533;
        Fri, 13 Dec 2019 12:13:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2ziTKf02qEG4; Fri, 13 Dec 2019 12:13:22 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C579C20491;
        Fri, 13 Dec 2019 12:13:22 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 13 Dec 2019
 12:13:22 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7FFC53180A50;
 Fri, 13 Dec 2019 12:13:22 +0100 (CET)
Date:   Fri, 13 Dec 2019 12:13:22 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Josh Hunt <johunt@akamai.com>, <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: crash in __xfrm_state_lookup on 4.19 LTS
Message-ID: <20191213111322.GE26283@gauss3.secunet.de>
References: <0b3ab776-2b8b-1725-d36e-70af66c138da@akamai.com>
 <20191212132132.GL8621@gauss3.secunet.de>
 <c328f835-6eb7-3ab9-1f7c-dc565634f8bd@akamai.com>
 <20191213072144.GC26283@gauss3.secunet.de>
 <20191213102512.GP795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191213102512.GP795@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 11:25:12AM +0100, Florian Westphal wrote:
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > 
> > We destroy the states with a workqueue by doing schedule_work().
> > I think we should better use call_rcu to make sure that a
> > rcu grace period has elapsed before the states are destroyed.
> 
> xfrm_state_gc_task calls synchronize_rcu after stealing the gc list and
> before destroying those states, so I don't think this is a problem.

That's true, I've missed this. In that case, I don't
have an idea what is the root cause of these crashes.
We need to find a way to reproduce it.
