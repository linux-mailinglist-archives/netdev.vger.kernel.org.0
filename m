Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C872653D1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIJVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:40:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728412AbgIJVku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599774048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGRVnEaekhAhEIL8CGWeb7ErYvV0SGt63fSdiNWSRlQ=;
        b=St7IS+apzVErPzusqkmrYsb9P4TIrcDhHR4dG6I+lgOsjEzOZGYzh/tvWES1Xe34cO6PQ3
        DKYSMyFd0TllVMCY/TdHaaDnyI/b+7O0+u5rLMPFcBtJ0T7KDjDO/VCCs/AmIwrTY2Spce
        1adw+bMVdy/hyrIFsDSMVpHYYdat58Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-1xTI1pPWM7Oqcr1Ld6N7rg-1; Thu, 10 Sep 2020 17:40:42 -0400
X-MC-Unique: 1xTI1pPWM7Oqcr1Ld6N7rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D1001074640;
        Thu, 10 Sep 2020 21:40:40 +0000 (UTC)
Received: from ovpn-112-6.ams2.redhat.com (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC7E37E8EB;
        Thu, 10 Sep 2020 21:40:36 +0000 (UTC)
Message-ID: <0f3b24664813091d535da32d0a645f406f3e30a2.camel@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Thu, 10 Sep 2020 23:40:35 +0200
In-Reply-To: <5f5a959fbe236_c295820892@john-XPS-13-9370.notmuch>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
         <20200623134259.8197-1-mzhivich@akamai.com>
         <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
         <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
         <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
         <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
         <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
         <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
         <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
         <20200822032800.16296-1-hdanton@sina.com>
         <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
         <20200825032312.11776-1-hdanton@sina.com>
         <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
         <20200825162329.11292-1-hdanton@sina.com>
         <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
         <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
         <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
         <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
         <20200827125747.5816-1-hdanton@sina.com>
         <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
         <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
         <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
         <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
         <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
         <CAM_iQpVqdVc5_LkhO4Qie7Ff+XXRTcpiptZsEVNh=o9E0GkcRQ@mail.gmail.com>
         <5f5a959fbe236_c295820892@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-10 at 14:07 -0700, John Fastabend wrote:
> Cong Wang wrote:
> > On Thu, Sep 3, 2020 at 10:08 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > Maybe this would unlock us,
> > > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 7df6c9617321..9b09429103f1 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3749,7 +3749,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> > > 
> > >         if (q->flags & TCQ_F_NOLOCK) {
> > >                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> > > -               qdisc_run(q);
> > > +               __qdisc_run(q);
> > > 
> > >                 if (unlikely(to_free))
> > >                         kfree_skb_list(to_free);
> > > 
> > > 
> > > Per other thread we also need the state deactivated check added
> > > back.
> > 
> > I guess no, because pfifo_dequeue() seems to require q->seqlock,
> > according to comments in qdisc_run(), so we can not just get rid of
> > qdisc_run_begin()/qdisc_run_end() here.
> > 
> > Thanks.
> 
> Seems we would have to revert this as well then,
> 
>  commit 021a17ed796b62383f7623f4fea73787abddad77
>  Author: Paolo Abeni <pabeni@redhat.com>
>  Date:   Tue May 15 16:24:37 2018 +0200
> 
>     pfifo_fast: drop unneeded additional lock on dequeue
>     
>     After the previous patch, for NOLOCK qdiscs, q->seqlock is
>     always held when the dequeue() is invoked, we can drop
>     any additional locking to protect such operation.
> 
> Then I think it should be safe. Back when I was working on the ptr
> ring implementation I opted not to do a case without the spinlock
> because the performance benefit was minimal in the benchmarks I
> was looking at.

The main point behind all that changes was try to close the gap vs the
locked implementation in the uncontended scenario. In our benchmark,
after commit eb82a994479245a79647d302f9b4eb8e7c9d7ca6, was more near to
10%.

Anyway I agree reverting back to the bitlock should be safe.

Cheers,

Paolo 


