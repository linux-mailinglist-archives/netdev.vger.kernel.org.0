Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9F58DAE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfF0WKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfF0WKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 18:10:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E42E8308FC4A;
        Thu, 27 Jun 2019 22:10:17 +0000 (UTC)
Received: from ovpn-204-56.brq.redhat.com (ovpn-204-56.brq.redhat.com [10.40.204.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F38185D719;
        Thu, 27 Jun 2019 22:10:13 +0000 (UTC)
Message-ID: <94260c8898834cfa8e5421933a2b5ea59680b970.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
In-Reply-To: <CAM_iQpV8Euk=NT4M7R5mAoS6_zU7aWBLRtkKEMatCxLAyaxSjQ@mail.gmail.com>
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
         <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
         <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
         <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
         <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
         <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com>
         <CAM_iQpXj1A05FdbD93iWQp9Tcd6aW0BQ3_xFx8bNEbqA00RGAg@mail.gmail.com>
         <CAM_iQpV8Euk=NT4M7R5mAoS6_zU7aWBLRtkKEMatCxLAyaxSjQ@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 28 Jun 2019 00:10:12 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 27 Jun 2019 22:10:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-26 at 14:15 -0700, Cong Wang wrote:
> Hi, Davide
> 
> On Tue, Jun 25, 2019 at 12:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > It should handle this overflow case more gracefully, I hope.
> > 
> 
> Please try this attached one and let me know if it works.
> Hope I get it right this time.
> 
> Thanks!

hello Cong, and thanks a lot for the patch!
I see it uses 

    (tmp <= id)

as the condition to detect the overflow, and at each iteration it does

    tmp = id, ++id

so that 'tmp' contains the last IDR found in the tree and 'id' is the next
tentative value to be searched for. When 'id' overflows, (tmp <= id)
becomes false, and the 'for' loop exits.
I tested it successfully with TC actions having the highest possible
index: 'tc actions show' doesn't loop anymore. But with cls_flower (that
uses idr_for_each_entry_continue_ul() ) I still see the infinite loop:
even when idr_for_each_entry_continue_ul() is used, fl_get_next_filter() 
never returns NULL, because 

    (tmp <= id) && (((entry) = idr_get_next_ul(idr, &(id))) != NULL)

calls idr_get_next_ul(idr, &(id)) at least once. So, even if
idr_for_each_entry_continue_ul() detected the overflow of 'id' after the
first iteration, and bailouts the for loop, fl_get_next_filter()
repeatedly returns a pointer to the idr slot with index equal to
0xffffffff. Because of that, the while() loop in fl_walk() keeps dumping
the same rule.
In my original patch I found easier to check for the overflow of
arg->cookie in fl_walk(), before the self-increment, so I was sure that 

    arg->fn(tp, f, arg)

was already called once when 'f' was the slot having the highest possible
IDR. Now, I didn't check it, but I guess 

    refcount_inc_not_zero(&f->refcnt))

in fl_get_next_filter() is always true during my test, so the inner
while() loop is not endless, even when the idr has a slot with id equal to
ULONG_MAX. Probably, to stay on the safe side, cls_flower needs both tests
to be in place, what do you think?  

-- 
davide



