Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9EFBCF84
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411047AbfIXQ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:57:46 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:43128 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730532AbfIXQsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 12:48:39 -0400
Received: by mail-ua1-f65.google.com with SMTP id k24so788133uag.10
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1SPmjuHbe3bqxJi1ss7QmTYjm+8aawCYM2ft2q//xI=;
        b=VQr5Zsem/YX7LLuuHUnf8Vk7+9R/WLpGgSWhsaygnJl8pkY4xacZ1mdn4RLb0qFB2K
         mjUxWuZzOjuT5oWIAILXUZG6Aqtt8EVPaUYHCUk04qUmPgU/FLZuzUmOoqWEHU3GqQ9t
         mickaxqpwzb9Ghnq6RnM77ngdXvg8MvCvuYa6HBAIg22GRp6mT1CnFmWFyzLPpxt/28v
         NbjTeHLBQ2ZoHJarziW6VJfHjF5mTLYFak2pH9sFBVWuHiyA0NpgRMn1fOP0S3Sw52is
         SePT3xuyhHCx+znZl8/ONIa03dhQA0fecCRhsSgKz5eEuhXwUeWTLWuSWIqgSm35xOEC
         /c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1SPmjuHbe3bqxJi1ss7QmTYjm+8aawCYM2ft2q//xI=;
        b=H1iuhuB/Gcr2ibG747Yq+EySCj5+x8NOLN69h4+EtDXjFD3OVoI109WSmIx9cqthdz
         /CbO0hQiPjUUd06ZQL3PEYO8dyAqxBggAT2o+5W+HkdHNDKxqxgs+5gDe+CctbHrtDS8
         AmaohMChw4Cf/484LFgfeYtCBVyQ8L03W7rAkySgQI2+IwMEIqM9w6QzWlnJg46jPJoH
         TMp2MXDHbFSZUVWV2n4XuNhOCT+2ne4fOaMTIkCU3UjX2jApxpVLeiUqy5qDWuH0Lv+h
         +X/GSNEU+jZy7WDQIG2l/B/NWHU314RNJlfT7LiUA/wRVcyVEz2bADN2jYufgGhPc1VE
         meKw==
X-Gm-Message-State: APjAAAVEegpdQ49jvxkBPTgFqx+dJV3YZNf+TpV8My0bropGQZ75K7zN
        5sqgmXCago6c66fr/IQAQ6rtAiXeePeN7XZ2N00=
X-Google-Smtp-Source: APXvYqyyhhXbZaE6hJ4Rj+csCLB+vDx/M/GJu1EkOngBPpFgNU0d1fyIOpCG4LoBbu6ywBGar4CzIvuwkq5vbzk7k4A=
X-Received: by 2002:a9f:366a:: with SMTP id s39mr346165uad.91.1569343717862;
 Tue, 24 Sep 2019 09:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
 <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
 <20190918142549.69bfa285@cakuba.netronome.com> <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
 <20190918144528.57a5cb50@cakuba.netronome.com> <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
 <20190923172811.1f620803@cakuba.netronome.com>
In-Reply-To: <20190923172811.1f620803@cakuba.netronome.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Tue, 24 Sep 2019 12:48:26 -0400
Message-ID: <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 8:28 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sat, 21 Sep 2019 23:19:20 -0400, Pooja Trivedi wrote:
> > On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski wrote:
> > > On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:
> > > > Hi Jakub,
> > > >
> > > > I have explained one potential way for the race to happen in my
> > > > original message to the netdev mailing list here:
> > > > https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> > > >
> > > > Here is the part out of there that's relevant to your question:
> > > >
> > > > -----------------------------------------
> > > >
> > > > One potential way for race condition to appear:
> > > >
> > > > When under tcp memory pressure, Thread 1 takes the following code path:
> > > > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > > > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > > > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event
> > >
> > > Ugh, so do_tcp_sendpages() can also release the lock :/
> > >
> > > Since the problem occurs in tls_sw_do_sendpage() and
> > > tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?
> >
> > That won't do because tls_tx_records also gets called when completion
> > callbacks schedule delayed work. That was the code path that caused
> > the crash for my test. Cavium's nitrox crypto offload driver calling
> > tls_encrypt_done, which calls schedule_delayed_work. Delayed work that
> > was scheduled would then be processed by tx_work_handler.
> > Notice in my previous reply,
> > "Thread 2 code path:
> > tx_work_handler ---> tls_tx_records"
> >
> > "Thread 2 code path:
> > tx_work_handler ---> tls_tx_records"
>
> Right, the work handler would obviously also have to obey the exclusion
> mechanism of choice.
>
> Having said that this really does feel like we are trying to lock code,
> not data here :(


Agree with you and exactly the thought process I went through. So what
are some other options?

1) A lock member inside of ctx to protect tx_list
We are load testing ktls offload with nitrox and the performance was
quite adversely affected by this. This approach can be explored more,
but the original design of using socket lock didn't follow this model
either.
2) Allow tagging of individual record inside of tx_list to indicate if
it has been 'processed'
This approach would likely protect the data without compromising
performance. It will allow Thread 2 to proceed with the TX portion of
tls_tx_records while Thread 1 sleeps waiting for memory. There will
need to be careful cleanup and backtracking after the thread wakes up
to ensure a consistent state of tx_list and record transmission.
The approach has several problems, however -- (a) It could cause
out-of-order record tx (b) If Thread 1 is waiting for memory, Thread 2
most likely will (c) Again, socket lock wasn't designed to follow this
model to begin with


Given that socket lock essentially was working as a code protector --
as an exclusion mechanism to allow only a single writer through
tls_tx_records at a time -- what other clean ways do we have to fix
the race without a significant refactor of the design and code?
