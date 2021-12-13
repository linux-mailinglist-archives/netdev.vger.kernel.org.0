Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D05472A00
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhLMK3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:29:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344441AbhLMK1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:27:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639391237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NxaVc541VXNT+4q7xpNYTkUpKWpJuMIMXoG66q+nrAk=;
        b=eTi7lmGpJg8pI0S8idBRbufuHE0Tw1cEgbQkxvI3++Rd3DkDgeWC6TIEIYoS0IGCScQuMf
        LRxHr4ufZ6qvaCsQrFS2fF1zmy+5QKlcVoFdeOwNyEfGDz7EC0tyPMNm+ObbE7Bgj3/DUK
        OW/l1pVmWZ0wuRD3FGQZ2HZuRbT3/5k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-291-oZFCtQGmPumajKbQx89xsw-1; Mon, 13 Dec 2021 05:27:16 -0500
X-MC-Unique: oZFCtQGmPumajKbQx89xsw-1
Received: by mail-wm1-f69.google.com with SMTP id 201-20020a1c04d2000000b003335bf8075fso9440022wme.0
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 02:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NxaVc541VXNT+4q7xpNYTkUpKWpJuMIMXoG66q+nrAk=;
        b=RBNNYx9vHS5b3Dj1ryJTH3wziu4ezVZPjA9qjO65LV4Kk6pS5bZ45pZYEupWC/lJhF
         P8WFN2SqdPUUoKaeFLWckNqKzcLMJTQ8e649FcL16+lCMyTm4qulbmA7fw9AP/9SVzQV
         SBlzGaqViS4JoiM6MP7vy2vRH7dGQY/zna9W3BMMYKnK4r8VAic+ObvkFrqeLfZl59Mr
         LaZLtWHHH+2qvr/s7c1qswem03vRpP4HrFv5Kbk9HYJGeeh6QXv9PTMh50rmPWnQ1zMS
         KSs+6gl6Yh7yrkpsiVFWvnL3jVREDZ8X3CjCsdQ5A0RwYKVUhfDxMA+VLvxG2cyhQMIF
         yfvA==
X-Gm-Message-State: AOAM531MtbuAcfwE0u1Cn8H5Zm3XR1RvctHWT2D9v+arxlbXctjIWIjP
        J18Rivn4Vmr32c0ldjZ/wDlVWlNZKGOq4vBUG6s2VFgeMQsjfD9Rkx5S0rUAe0APBYSKKZZKJqK
        SSBqTWI9V1D7iH1zs
X-Received: by 2002:a05:600c:4f02:: with SMTP id l2mr36293164wmq.26.1639391234947;
        Mon, 13 Dec 2021 02:27:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSBnbJfTjm8c+Pjgm9ySDC6AViMIIu879Npyh/eLysK8cD4gqws0OxiM4EXIcKdYN/vE1XNg==
X-Received: by 2002:a05:600c:4f02:: with SMTP id l2mr36293143wmq.26.1639391234748;
        Mon, 13 Dec 2021 02:27:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-237-50.dyn.eolo.it. [146.241.237.50])
        by smtp.gmail.com with ESMTPSA id bg12sm8010244wmb.5.2021.12.13.02.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 02:27:14 -0800 (PST)
Message-ID: <9b76f8593aa69596c2fe6f6bd2910b4078a1f6b8.camel@redhat.com>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Mon, 13 Dec 2021 11:27:13 +0100
In-Reply-To: <YbOEaSQW+LtWjuzI@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
         <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
         <YbOEaSQW+LtWjuzI@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-10 at 17:46 +0100, Sebastian Andrzej Siewior wrote:
> On 2021-12-10 17:35:21 [+0100], Paolo Abeni wrote:
> > On Fri, 2021-12-10 at 16:41 +0100, Sebastian Andrzej Siewior wrote:
> > > The root-lock is dropped before dev_hard_start_xmit() is invoked and after
> > > setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
> > > by another sender/task with a higher priority then this new sender won't
> > > be able to submit packets to the NIC directly instead they will be
> > > enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
> > > is scheduled again and finishes the job.
> > > 
> > > By serializing every task on the ->busylock then the task will be
> > > preempted by a sender only after the Qdisc has no owner.
> > > 
> > > Always serialize on the busylock on PREEMPT_RT.
> > 
> > Not sure how much is relevant in the RT context, but this should impact
> > the xmit tput in a relevant, negative way.
> 
> Negative because everyone blocks on lock and transmits packets directly
> instead of adding it to the queue and leaving for more?

In the uncontended scenario this adds an atomic operation and increases
the data set size. Thinking again about it, in RT build this is much
less noticeable (I forgot spinlock are actually mutex in RT...)

> > If I read correctly, you use the busylock to trigger priority
> > ceiling
> > on each sender. I'm wondering if there are other alternative ways
> > (no
> > contended lock, just some RT specific annotation) to mark a whole
> > section of code for priority ceiling ?!?
> 
> priority ceiling as you call it, happens always with the help of a
> lock.
> The root_lock is dropped in sch_direct_xmit().
> qdisc_run_begin() sets only a bit with no owner association.
> If I know why the busy-lock bad than I could add another one. The
> important part is force the sende out of the section so the task with
> the higher priority can send packets instead of queueing them only.

I thought about adding a local_lock() instead, but that will not solve.

I don't see a better solution than this patch, so I'm ok with that.
Please follow Jakub's suggestion to clean the code a bit.

Thanks!

Paolo

