Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AF2553B5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbfFYPrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfFYPrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 11:47:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B3F6882FD;
        Tue, 25 Jun 2019 15:47:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE2060BE2;
        Tue, 25 Jun 2019 15:47:37 +0000 (UTC)
Message-ID: <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
In-Reply-To: <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
         <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
         <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
         <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 25 Jun 2019 17:47:36 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 25 Jun 2019 15:47:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-20 at 10:33 -0700, Cong Wang wrote:
> On Thu, Jun 20, 2019 at 5:52 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > hello Cong, thanks for reading.
> > 
> > On Wed, 2019-06-19 at 15:04 -0700, Cong Wang wrote:
> > > On Wed, Jun 19, 2019 at 2:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > > > on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
> > > > In this situation, the following script:
> > > > 
> > > >  # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
> > > >  # tc filter show dev eth0 ingress
> > > > 
> > > > results in an infinite loop.

[...]

> I am not sure it is better to handle this overflow inside idr_get_next_ul()
> or just let its callers to handle it. According to the comments above
> idr_get_next_ul() it sounds like it is not expected to overflow, so...
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index c34e256d2f01..a38f5e391cec 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -267,6 +267,9 @@ void *idr_get_next_ul(struct idr *idr, unsigned
> long *nextid)
>         if (!slot)
>                 return NULL;
> 
> +       /* overflow */
> +       if (iter.index < id)
> +               return NULL;
>         *nextid = iter.index + base;
>         return rcu_dereference_raw(*slot);
>  }

hello Cong,

I tested the above patch, but I still see the infinite loop on kernel
5.2.0-0.rc5.git0.1.fc31.i686 . 

idr_get_next_ul() returns the entry in the radix tree which is greater or 
equal to '*nextid' (which has the same value as 'id' in the above hunk). 
So, when the radix tree contains one slot with index equal to ULONG_MAX,
whatever can be the value of 'id', the condition in that if() will always 
be false (and the function will keep  returning non-NULL, hence the 
infinite loop).

I also tried this:

if (iter.index == id && id == ULONG_MAX) {
	return NULL;
}

it fixes the infinite loop, but it clearly breaks the function semantic
(and anyway, it's not sufficient to fix my test, at least with cls_flower
it still dumps the entry with id 0xffffffff several times).  I'm for
fixing the callers of idr_get_next_ul(), and in details:

- apply this patch for cls_flower
- change tcf_dump_walker() in act_api.c as follows, and add a TDC testcase
for 'gact'.

index 4e5d2e9ace5d..f34888c8a952 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -228,8 +228,11 @@ static int tcf_dump_walker(struct tcf_idrinfo
*idrinfo, struct sk_buff *skb,
 
        idr_for_each_entry_ul(idr, p, id) {
                index++;
-               if (index < s_i)
+               if (index < s_i) {
+                       if (id == ULONG_MAX)
+                               break;
                        continue;
+               }
 
                if (jiffy_since &&
                    time_after(jiffy_since,


WDYT?

thanks a lot,
-- 
davide

