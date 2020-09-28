Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945F527ABA3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgI1KOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:14:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbgI1KOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 06:14:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601288077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+pzYD+r/mOVsj/1Rewpd8Q55idVOJS1LWXIw8yTv7k=;
        b=Ut0RcuEkawUp7m4nEJojC5RlVj3fBzyhTebuIF4kJJC/WOqOurL+WBWqaVTj57xjwQfsJT
        JXmbfZxxqzStU+8OqcLcr4gS8iHzmb2KR6KsmeNP9gJ75eAAAe7oIQDusmm2AhM5BgRlZW
        GWeLWfaL094ujCcEWldgV9wDTANW9tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-0FYIgwLzOgq6WXX6PVjcdQ-1; Mon, 28 Sep 2020 06:14:35 -0400
X-MC-Unique: 0FYIgwLzOgq6WXX6PVjcdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F485104D3E0;
        Mon, 28 Sep 2020 10:14:33 +0000 (UTC)
Received: from new-host-6 (unknown [10.40.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BC25D9CA;
        Mon, 28 Sep 2020 10:14:30 +0000 (UTC)
Message-ID: <3a0677de763a6a993123fd4f01000f7e78ace353.camel@redhat.com>
Subject: Re: [Patch net 1/2] net_sched: defer tcf_idr_insert() in
 tcf_action_init_1()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vlad Buslov <vlad@buslov.dev>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
In-Reply-To: <8736358wu0.fsf@buslov.dev>
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
         <20200923035624.7307-2-xiyou.wangcong@gmail.com>
         <877dsh98wq.fsf@buslov.dev>
         <CAM_iQpXy4GuHidnLAL+euBaNaJGju6KFXBZ67WS_Pws58sD6+g@mail.gmail.com>
         <8736358wu0.fsf@buslov.dev>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 28 Sep 2020 12:14:30 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Fri, 2020-09-25 at 22:45 +0300, Vlad Buslov wrote:
> On Fri 25 Sep 2020 at 22:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Fri, Sep 25, 2020 at 8:24 AM Vlad Buslov <vlad@buslov.dev> wrote:
> > > > +     if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> > > > +         !rcu_access_pointer(a->goto_chain)) {
> > > > +             tcf_action_destroy_1(a, bind);
> > > > +             NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> > > > +             return ERR_PTR(-EINVAL);
> > > > +     }
> > > 
> > > I don't think calling tcf_action_destoy_1() is enough here. Since you
> > > moved this block before assigning cookie and releasing the module, you
> > > also need to release them manually in addition to destroying the action
> > > instance.
> > > 
> > 
> > tcf_action_destoy_1() eventually calls free_tcf() which frees cookie and
> > tcf_action_destroy() which releases module refcnt.
> > 
> > What am I missing here?
> > 
> > Thanks.
> 
> The memory referenced by the function local pointer "cookie" hasn't been
> assigned yet to the a->act_cookie because in your patch you moved
> goto_chain validation code before the cookie change. That means that if
> user overwrites existing action, then action old a->act_cookie will be
> freed by tcf_action_destroy_1() but new cookie that was allocated by
> nla_memdup_cookie() will leak.

maybe we can just delete this if (TC_ACT_EXT_CMP(...)) { ... }
statement, instead of moving it? Each TC action already does the check
for NULL "goto chains" with a_o->init() -> tcf_action_check_ctrlact(),
so this if () statement looks dead code to me _ I probably forgot to
remove it after all actions were converted to validate the control
action inside their .init() function.

-- 
davide


