Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE004CE02
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfFTMwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbfFTMwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:52:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF047307D866;
        Thu, 20 Jun 2019 12:52:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44FAF60605;
        Thu, 20 Jun 2019 12:52:33 +0000 (UTC)
Message-ID: <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
In-Reply-To: <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
         <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 20 Jun 2019 14:52:32 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 20 Jun 2019 12:52:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks for reading.

On Wed, 2019-06-19 at 15:04 -0700, Cong Wang wrote:
> On Wed, Jun 19, 2019 at 2:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
> > In this situation, the following script:
> > 
> >  # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
> >  # tc filter show dev eth0 ingress
> > 
> > results in an infinite loop. It happened also on other CPUs (e.g x86_64),
> > before commit 061775583e35 ("net: sched: flower: introduce reference
> > counting for filters"), because 'handle' + 1 made the u32 overflow before
> > it was assigned to 'cookie'; but that commit replaced the assignment with
> > a self-increment of 'cookie', so the problem was indirectly fixed.
> 
> Interesting... Is this really specific to cls_flower? To me it looks like
> a bug of idr_*_ul() API's, especially for idr_for_each_entry_ul().

good question, I have to investigate this better (idr_for_each_entry_ul()
expands in a iteration of idr_get_next_ul()). It surely got in cls_flower
when it was converted to use IDRs, but it's true that there might be other
points in TC where IDR are used and the same pattern is present (see
below).

> Can you test if the following command has the same problem on i386?
> 
> tc actions add action ok index 4294967295

the action is added, but then reading it back results in an infinite loop.
And again, the infinite loop happens on i686 and not on x86_64. I will try
to see where's the problem also here.

-- 
davide

