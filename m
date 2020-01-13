Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1640139D48
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgAMXaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:30:14 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39897 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgAMXaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:30:14 -0500
Received: by mail-oi1-f193.google.com with SMTP id a67so10073685oib.6;
        Mon, 13 Jan 2020 15:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZaqiw319VJnCml2+zBJxKWVWM0h/GzDX6yg9g2Rquw=;
        b=azLS09kg+Uk/fO35rdud1DlwwVzPiuH5S7OM5V8SHMM5D1fX8rwNxsfx5M1Upshs+x
         0mmpxoqHrsRoGKlrc2LaQ9ALZ5Tv5iN9HBPMjsA+lijecPUDoArwpyRyjiMfX4gWYhWH
         tnHnmmWYyMRk32sf3/9XeSbBwTSik4C8ZZ5ujulGD44lATnZAh4e/T5O0MyTCrPF2PDB
         w75OLfRqIHlkMi8E0Zwu7VC+pviVK6P6BYtSeqMtWNKgENiJJbuarQ/aAwGc/ZHfzBgC
         HDTdjeMqkLJ8EDBoNjjiItfXwNPhsWMKGew3+TvvO1zX4ts5zBy8ovtPl32hBX+SFwpX
         4Gvw==
X-Gm-Message-State: APjAAAU1JDj8op1wzhwlKWHFacauqx2P6d5pm6Ko/Ch3+91PR+kVzJYW
        xlI/Zg5qmtDa+3YYmupKpVPTBJCiKKxNj5CHAI8=
X-Google-Smtp-Source: APXvYqzg8CdbzHzyG2pmz4js9Msb/H7pbgSPntduERaOQNPUZYVj+FwHMkNAuBIckeikwPmAWFV/f2vKNieGQbmMI6k=
X-Received: by 2002:a54:488d:: with SMTP id r13mr14062187oic.115.1578958213346;
 Mon, 13 Jan 2020 15:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net> <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net> <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
 <20200113124247.GG2827@hirez.programming.kicks-ass.net> <CAJZ5v0jv+5aLY3N4wFSitu61o9S8tJWEWGGn1Xyw-P82_TwFdQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0jv+5aLY3N4wFSitu61o9S8tJWEWGGn1Xyw-P82_TwFdQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 14 Jan 2020 00:30:02 +0100
Message-ID: <CAJZ5v0imNbbch=NWAdgVKf_hjwRrEiWAL8SFNwe6rW_SjgYzrw@mail.gmail.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in hibernation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Singh, Balbir" <sblbir@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 10:50 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Mon, Jan 13, 2020 at 1:43 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, Jan 13, 2020 at 11:43:18AM +0000, Singh, Balbir wrote:
> > > For your original comment, just wanted to clarify the following:
> > >
> > > 1. After hibernation, the machine can be resumed on a different but compatible
> > > host (these are VM images hibernated)
> > > 2. This means the clock between host1 and host2 can/will be different
> > >
> > > In your comments are you making the assumption that the host(s) is/are the
> > > same? Just checking the assumptions being made and being on the same page with
> > > them.
> >
> > I would expect this to be the same problem we have as regular suspend,
> > after power off the TSC will have been reset, so resume will have to
> > somehow bridge that gap. I've no idea if/how it does that.
>
> In general, this is done by timekeeping_resume() and the only special
> thing done for the TSC appears to be the tsc_verify_tsc_adjust(true)
> call in tsc_resume().

And I forgot about tsc_restore_sched_clock_state() that gets called
via restore_processor_state() on x86, before calling
timekeeping_resume().
