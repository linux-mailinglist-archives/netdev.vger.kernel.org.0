Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBBDDBA4C
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441832AbfJQXsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 19:48:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37998 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441818AbfJQXsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 19:48:37 -0400
Received: by mail-lj1-f196.google.com with SMTP id b20so4314857ljj.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 16:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=OmrnHiTNGAamKJCffw+FDXZ8b8SDpOBqT4pbxbstGfE=;
        b=yZhsECe2HEVL7zpouxy95Ngl9PxCU5j4Tg2aZl9Zlkc/rAgNI2nuUHqvE1twtO9hcc
         QIYGCvnM8EMiSHeuQnCv9sys9lL1kW5n2aKcqMQdm9ERh4myWVtdUdmJOyHu0d75f7zB
         cUpCf+U9EL9VQVQnaxCd0iALkONZcbnBdC0N+LYt/f0B51kIEvDmQ1SZBl4dvJXd3J4u
         Quau84XRRe/Hfvd8ZB2KgpeNTDtYQt4agyCRW9l2fWMqomqOhFIt2Nzw/GJMxmAvB/wi
         t+Yz/2NbSB0i775MUVS06Od1pwBbyS8PecstOVYoyT1o98qORsZ9GNJapbbopJUHkwlI
         4MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OmrnHiTNGAamKJCffw+FDXZ8b8SDpOBqT4pbxbstGfE=;
        b=I7ZCZjU4uXkmLAAUcOyO/LxPYRUBm2snjVdTfTEXo3ANjaee6FC1BJL4NzEF5n2McZ
         4a0CPqP0qr/fPmsvxq1gEUTDeGrStrGu6sGDBIUeekoFSXfL1C3YFIrM7w8sAIIyYeIC
         lre6qZ5rlREUgxCjbuCdSvAuAiYXfrmtBOboRR62xO9y7rMYa8P84wlUTNERu+pFntkL
         X0HzZyDExw30UH5nNI9YJ9epMdVPTWo0X52K8t5i44uxco4ty8xepCnRMJ/l932Jxsrw
         xegdIARjUE4NiQjcfc1JUjwf+S1r0Xcm9cPsQ116LD7FJyly5IitAIYd0yWUGdi0vLqy
         /zTg==
X-Gm-Message-State: APjAAAUKxosytmjKiM5ud8NcBw998r9Z8966c3hj8oxfhM9O6C1tCH/d
        h0IpZNwRWyVA/QCXrZ6qWLlAHw==
X-Google-Smtp-Source: APXvYqxQjJaJfJ4Y8XO7qVMIZqzjSTP4YyW9UVeMDU0kqfiNJVHuYDI8zmSTJfAagGLDNpIrqrLvMQ==
X-Received: by 2002:a2e:9f4d:: with SMTP id v13mr3656818ljk.180.1571356114560;
        Thu, 17 Oct 2019 16:48:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z26sm1460297lji.79.2019.10.17.16.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 16:48:34 -0700 (PDT)
Date:   Thu, 17 Oct 2019 16:48:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20191017164825.22d223d1@cakuba.netronome.com>
In-Reply-To: <20191009165739.GA1848@kvmhost.ch.hwng.net>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
        <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
        <20190918142549.69bfa285@cakuba.netronome.com>
        <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
        <20190918144528.57a5cb50@cakuba.netronome.com>
        <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
        <20190923172811.1f620803@cakuba.netronome.com>
        <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
        <20190927173753.418634ef@cakuba.netronome.com>
        <20191009165739.GA1848@kvmhost.ch.hwng.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 16:57:39 +0000, Pooja Trivedi wrote:
> On Fri, Sep 27, 2019 at 05:37:53PM -0700, Jakub Kicinski wrote:
> > On Tue, 24 Sep 2019 12:48:26 -0400, Pooja Trivedi wrote:  
> > > On Mon, Sep 23, 2019 at 8:28 PM Jakub Kicinski wrote:  
> > > > On Sat, 21 Sep 2019 23:19:20 -0400, Pooja Trivedi wrote:    
> > > > > On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski wrote:    
> > > > > > On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:    
> > > > > > > Hi Jakub,
> > > > > > >
> > > > > > > I have explained one potential way for the race to happen in my
> > > > > > > original message to the netdev mailing list here:
> > > > > > > https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> > > > > > >
> > > > > > > Here is the part out of there that's relevant to your question:
> > > > > > >
> > > > > > > -----------------------------------------
> > > > > > >
> > > > > > > One potential way for race condition to appear:
> > > > > > >
> > > > > > > When under tcp memory pressure, Thread 1 takes the following code path:
> > > > > > > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > > > > > > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > > > > > > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event    
> > > > > >
> > > > > > Ugh, so do_tcp_sendpages() can also release the lock :/
> > > > > >
> > > > > > Since the problem occurs in tls_sw_do_sendpage() and
> > > > > > tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?    
> > > > >
> > > > > That won't do because tls_tx_records also gets called when completion
> > > > > callbacks schedule delayed work. That was the code path that caused
> > > > > the crash for my test. Cavium's nitrox crypto offload driver calling
> > > > > tls_encrypt_done, which calls schedule_delayed_work. Delayed work that
> > > > > was scheduled would then be processed by tx_work_handler.
> > > > > Notice in my previous reply,
> > > > > "Thread 2 code path:
> > > > > tx_work_handler ---> tls_tx_records"
> > > > >
> > > > > "Thread 2 code path:
> > > > > tx_work_handler ---> tls_tx_records"    
> > > >
> > > > Right, the work handler would obviously also have to obey the exclusion
> > > > mechanism of choice.
> > > >
> > > > Having said that this really does feel like we are trying to lock code,
> > > > not data here :(    
> > > 
> > > Agree with you and exactly the thought process I went through. So what
> > > are some other options?
> > > 
> > > 1) A lock member inside of ctx to protect tx_list
> > > We are load testing ktls offload with nitrox and the performance was
> > > quite adversely affected by this. This approach can be explored more,
> > > but the original design of using socket lock didn't follow this model
> > > either.
> > > 2) Allow tagging of individual record inside of tx_list to indicate if
> > > it has been 'processed'
> > > This approach would likely protect the data without compromising
> > > performance. It will allow Thread 2 to proceed with the TX portion of
> > > tls_tx_records while Thread 1 sleeps waiting for memory. There will
> > > need to be careful cleanup and backtracking after the thread wakes up
> > > to ensure a consistent state of tx_list and record transmission.
> > > The approach has several problems, however -- (a) It could cause
> > > out-of-order record tx (b) If Thread 1 is waiting for memory, Thread 2
> > > most likely will (c) Again, socket lock wasn't designed to follow this
> > > model to begin with
> > > 
> > > 
> > > Given that socket lock essentially was working as a code protector --
> > > as an exclusion mechanism to allow only a single writer through
> > > tls_tx_records at a time -- what other clean ways do we have to fix
> > > the race without a significant refactor of the design and code?  
> > 
> > Very sorry about the delay. I don't think we can maintain the correct
> > semantics without sleeping :( If we just bail in tls_tx_records() when
> > there's already another writer the later writer will return from the
> > system call, even though the data is not pushed into the TCP layer.
> 
> Thanks for your response and sorry about the delay!
> 
> I am trying the following scenarios in my head to see how valid your
> concern is. Play along with me please.
> 
> The two main writers in picture here are
> Thread 1 -- Enqueue thread (sendfile system call) -- pushes records to
> card, also performs completions (push to tcp) if records are ready
> Thread 2 -- Work handler (tx_work_handler) -- bottom-half completions routine
> 
> With the submitted patch,
> Case 1 (your concern) : Thread 2 grabs socket lock, calls
> tls_tx_records, runs into memory pressure, releases socket lock, waits
> for memory. Now Thread 1 grabs socket lock, calls tls_tx_records, bails.
> In this case, sendfile system call will bail out without performing
> completions. Is that really a problem? When Thread 1 ultimately
> proceeds, it will perform the completions anyway.

I think there is value in preserving normal socket semantics as much
as possible. If a writer pushes more data to a TCP connection than send
buffer the call should block.

> Case 2: Threads grab socket lock in a reverse sequence of Case 1. So
> Thread 1 grabs socket lock first and ends up waiting for memory.
> Thread 2 comes in later and bails from tls_tx_records.
> In this case, in the submitted patch, I realized that we are not rescheduling 
> the work before bailing. So I think an amendment to that patch, 
> something along the lines of what's shown below, would fare better.
> 

> ********************************************************************************
> 
> > What was reason for the performance impact on (1)?   
> 
> 
> While the performance impact still needs to be investigated, that effort has stopped short due 
> to other issues with that approach like hard lockups. The basic problem is that the socket lock 
> is touched at multiple layers (tls, tcp etc.).
> 
> Here are the two approaches we tried along the lines of using an additional lock...
> 
> Approach 1 -- Protect tx_list with a spinlock_t tx_list_lock :

> Approach 2 -- Protect tx_list with a spinlock_t tx_list_lock and move lock/release of socket lock to tls_push_sg :

You can't sleep with spin locks, we'd need a mutex...

> > My feeling is that
> > we need to make writers wait to maintain socket write semantics, and
> > that implies putting writers to sleep, which is indeed very costly..
> > 
> > Perhaps something along the lines of:
> > 
> > 	if (ctx->in_tcp_sendpages) {
> > 		rc = sk_stream_wait_memory(sk, &timeo);
> > 		...
> > 	}
> > 
> > in tls_tx_records() would be the "most correct" solution? If we get
> > there and there is already a writer, that means the first writer has
> > to be waiting for memory, and so should the second..
> > 
> > WDYT?  
> 
> Hmmm, I am not sure what the benefit would be of having two threads
> do the completions, as explained above with Case 1 and Case 2
> scenarios. If we made the later thread wait also while earlier one
> waits for memory, just so the later one can also perform the
> completions, it will either have no completions left to take care of
> or have minimal (a few records that may have sneaked in while the
> earlier thread returned and second made it in).

Semantics matter.

> The only patch that we have been able to make consistently work
> without crashing and also without compromising performance, is the
> previously submitted one where later thread bails out of
> tls_tx_records. And as mentioned, it can perhaps be made more
> efficient by rescheduling delayed work in the case where work handler
> thread turns out to be the later thread that has to bail.

Let me try to find a way to repro this reliably without any funky
accelerators. The sleep in do_tcp_sendpages() should affect all cases.
I should have some time today and tomorrow to look into this, bear with
me..
