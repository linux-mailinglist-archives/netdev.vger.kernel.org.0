Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1443FC0F01
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfI1AiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 20:38:00 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45925 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfI1Ah7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 20:37:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so9475174qtj.12
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 17:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1d+qpT8CY6Zow0yxcpHZi1JJ2PdyznrOAbyszRQnxus=;
        b=OsNASevDwKV016I3Uksqnoc7Rz7xRag+6BTNCQSdHmT9ExAJiBXoGGriZruZi+OT5i
         t+zipIXA7yJZg49W/YoBKrta9UKG1F07A2JAED6oHE0btDka18jZ/9qJi1qdpVHyoe5I
         0lIY0PMxy+TgO7BxCOtHw5wL5POJ07uPbWNGk0FCzfQW0I2F+w/P6drpnXNTQpJfIaLD
         OCqWE0ldrApjrPuIcxm2dO5ItktJtKfn+9WOL/oorNCa47tRlYChA5FB5y46CB0zQfsA
         yiSpW6hiY+A+og+a67hghb3n9Cb6r/Yps9jH25gxKpYbmg1FQdYytrrAchGjuN15pJLc
         4q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1d+qpT8CY6Zow0yxcpHZi1JJ2PdyznrOAbyszRQnxus=;
        b=iTFCPdOaavravpeYFroQN271uv9JeR+uWA86U/Vs7HE9tooIJ7vZSQww+4UdtKiqTH
         diIlcHd98Od4ujhJyMDv8H/b/7znoxAkd4476QFQjHjNL4qM9YWLWzec5X1bs96QCirv
         JcHaL18JTnrBJ1zpFIAQ9Tnt2z1/7ObR6FMtfy8QRmBp4B8UZH7mZ6Sb4PkzKUS5tTfj
         trwvREhW44ZI3nzqtOSphbbbbnJJYnAv2I+B4D8JqWhd7KYBTvEmyM8jpRB4C3sysahb
         tRumPtOchTTo6BjuvF8wci9JYaH72hZ7wiAUde1JuqzedG+dH3VcoS8jEc4JXrJIuQ1l
         SBsQ==
X-Gm-Message-State: APjAAAVLjG3XcH4hMUcKI0HsR3+oTUk1yShdHkBF5JlboQ6T2egM87wk
        u1HQYpX/3kWWBB0UUr8kyOOi+A==
X-Google-Smtp-Source: APXvYqyX877NfvM+nZGB54fsoytixA4UgRCN8TiISrPnpfrFC2nSWy8KuygGFi8j2wfOakaNqDANHA==
X-Received: by 2002:a05:6214:1369:: with SMTP id c9mr10791737qvw.3.1569631078437;
        Fri, 27 Sep 2019 17:37:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q49sm4488244qta.60.2019.09.27.17.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 17:37:58 -0700 (PDT)
Date:   Fri, 27 Sep 2019 17:37:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20190927173753.418634ef@cakuba.netronome.com>
In-Reply-To: <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
        <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
        <20190918142549.69bfa285@cakuba.netronome.com>
        <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
        <20190918144528.57a5cb50@cakuba.netronome.com>
        <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
        <20190923172811.1f620803@cakuba.netronome.com>
        <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Sep 2019 12:48:26 -0400, Pooja Trivedi wrote:
> On Mon, Sep 23, 2019 at 8:28 PM Jakub Kicinski wrote:
> > On Sat, 21 Sep 2019 23:19:20 -0400, Pooja Trivedi wrote:  
> > > On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski wrote:  
> > > > On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:  
> > > > > Hi Jakub,
> > > > >
> > > > > I have explained one potential way for the race to happen in my
> > > > > original message to the netdev mailing list here:
> > > > > https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> > > > >
> > > > > Here is the part out of there that's relevant to your question:
> > > > >
> > > > > -----------------------------------------
> > > > >
> > > > > One potential way for race condition to appear:
> > > > >
> > > > > When under tcp memory pressure, Thread 1 takes the following code path:
> > > > > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > > > > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > > > > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event  
> > > >
> > > > Ugh, so do_tcp_sendpages() can also release the lock :/
> > > >
> > > > Since the problem occurs in tls_sw_do_sendpage() and
> > > > tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?  
> > >
> > > That won't do because tls_tx_records also gets called when completion
> > > callbacks schedule delayed work. That was the code path that caused
> > > the crash for my test. Cavium's nitrox crypto offload driver calling
> > > tls_encrypt_done, which calls schedule_delayed_work. Delayed work that
> > > was scheduled would then be processed by tx_work_handler.
> > > Notice in my previous reply,
> > > "Thread 2 code path:
> > > tx_work_handler ---> tls_tx_records"
> > >
> > > "Thread 2 code path:
> > > tx_work_handler ---> tls_tx_records"  
> >
> > Right, the work handler would obviously also have to obey the exclusion
> > mechanism of choice.
> >
> > Having said that this really does feel like we are trying to lock code,
> > not data here :(  
> 
> Agree with you and exactly the thought process I went through. So what
> are some other options?
> 
> 1) A lock member inside of ctx to protect tx_list
> We are load testing ktls offload with nitrox and the performance was
> quite adversely affected by this. This approach can be explored more,
> but the original design of using socket lock didn't follow this model
> either.
> 2) Allow tagging of individual record inside of tx_list to indicate if
> it has been 'processed'
> This approach would likely protect the data without compromising
> performance. It will allow Thread 2 to proceed with the TX portion of
> tls_tx_records while Thread 1 sleeps waiting for memory. There will
> need to be careful cleanup and backtracking after the thread wakes up
> to ensure a consistent state of tx_list and record transmission.
> The approach has several problems, however -- (a) It could cause
> out-of-order record tx (b) If Thread 1 is waiting for memory, Thread 2
> most likely will (c) Again, socket lock wasn't designed to follow this
> model to begin with
> 
> 
> Given that socket lock essentially was working as a code protector --
> as an exclusion mechanism to allow only a single writer through
> tls_tx_records at a time -- what other clean ways do we have to fix
> the race without a significant refactor of the design and code?

Very sorry about the delay. I don't think we can maintain the correct
semantics without sleeping :( If we just bail in tls_tx_records() when
there's already another writer the later writer will return from the
system call, even though the data is not pushed into the TCP layer.

What was reason for the performance impact on (1)? My feeling is that
we need to make writers wait to maintain socket write semantics, and
that implies putting writers to sleep, which is indeed very costly..

Perhaps something along the lines of:

	if (ctx->in_tcp_sendpages) {
		rc = sk_stream_wait_memory(sk, &timeo);
		...
	}

in tls_tx_records() would be the "most correct" solution? If we get
there and there is already a writer, that means the first writer has
to be waiting for memory, and so should the second..

WDYT?
