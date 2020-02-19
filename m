Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492B8163943
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgBSBXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:23:30 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34284 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgBSBX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 20:23:29 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so11631556pfc.1;
        Tue, 18 Feb 2020 17:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nKwk106No1DVrc6dMzx8YU78C3BBL9k3Rd6ZldKG2b0=;
        b=ZpIXO+JG9mZT+U+C8NMHHfBk2C8V/5jqtjRh3crA8DOwbBO+vwHribUYll9f/0C0kL
         F0JmNTGgtCbaBRnjWTOsOFh3XS57bS4iUXvlk4BvKh2UhjyVmtqc0oCITsoctlI3nkW2
         tu8r357tm5Whi4CS9Dgf65KOZOKpPieRjmh1TJMDryqTI2uIeziTwOtxRWZ41eg5u53l
         WhI8pLz4CHpYh27uw0Iny22E15J41HoHeW4U9/rc1xJBFHYB1ZugKCJ8C4NOMeubFuGV
         bEb45xfYxAXW9l507OS66dnpLB6PqVwWGaHfw/Ww7X4ZnTieOwBVUlu67amwOlPDCZ+y
         jssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nKwk106No1DVrc6dMzx8YU78C3BBL9k3Rd6ZldKG2b0=;
        b=HVhST9ogO0K+7Xrdx9SiEQMO72V4OggUr3RbWQ4MWs95GRIDv79Oxt8X3H/HDdPd2e
         CvLoqr+YxNScaYu+IIWEsJ5LHNRQkW3Bs91Yed+MHxK1cDpC0Tfwp+l55GruO4E2p5Pp
         JZtUwnGlUV0MWm+PVuVnf7P76Fxmoi5Aj3d+ZrVJz5Xo241yGkOf08e+X775Lm9OvQnQ
         JSZBkP2CGvs5FKVRpkcnPVTcjNzojx0xYtNBInLSB4P1zWRRKsot+QsC807aNPQrKSC4
         UwIhF0/4337Ebb2QLdNa58LT85FVMHDhdur8eq7ZpnaUI53SANhId2gE/wrrdNAU/hPm
         XmwQ==
X-Gm-Message-State: APjAAAXg7ZN5Ol4bY1lIFJCbZAcnyL2RoH+99ZgssmQauISjsYLoNVLp
        7eHAI1O3ANGEbevGbFF2UDE=
X-Google-Smtp-Source: APXvYqwfDAVi8Im12SfiiewjZMyylKKGx9xgm1md/60CqBBjyHVY3ZzsFDFnsYviFwdBnUEqmFUIgg==
X-Received: by 2002:a63:3349:: with SMTP id z70mr25485167pgz.408.1582075409026;
        Tue, 18 Feb 2020 17:23:29 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:dd54])
        by smtp.gmail.com with ESMTPSA id 84sm182260pgg.90.2020.02.18.17.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 17:23:28 -0800 (PST)
Date:   Tue, 18 Feb 2020 17:23:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
Message-ID: <20200219012324.fibreerdmd2zdzr3@ast-mbp>
References: <20200214133917.304937432@linutronix.de>
 <20200214161504.325142160@linutronix.de>
 <20200214191126.lbiusetaxecdl3of@localhost>
 <87imk9t02r.fsf@nanos.tec.linutronix.de>
 <20200218233641.i7fyf36zxocgucap@ast-mbp>
 <87blpvqu2y.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blpvqu2y.fsf@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 01:49:57AM +0100, Thomas Gleixner wrote:
> Alexei,
> 
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > Overall looks great.
> > Thank you for taking time to write commit logs and detailed cover letter.
> > I think s/__this_cpu_inc/this_cpu_inc/ is the only bit that needs to be
> > addressed for it to be merged.
> > There were few other suggestions from Mathieu and Jakub.
> > Could you address them and resend?
> 
> I have them fixed up already, but I was waiting for further
> comments. I'll send it out tomorrow morning as I'm dead tired by now.
> 
> > I saw patch 1 landing in tip tree, but it needs to be in bpf-next as well
> > along with the rest of the series. Does it really need to be in the tip?
> > I would prefer to take the whole thing and avoid conflicts around
> > migrate_disable() especially if nothing in tip is going to use it in this
> > development cycle. So just drop patch 1 from the tip?
> 
> I'll add patch 2 to a tip branch as well and I'll give you a tag to pull
> into BPF (which has only those two commits). 

That works too.

> > Regarding
> > union {
> >    raw_spinlock_t  raw_lock;
> >    spinlock_t      lock;
> > };
> > yeah. it's not pretty, but I also don't have better ideas.
> 
> Yeah. I really tried hard to avoid it, but the alternative solution was
> code duplication which was even more horrible.
> 
> > Regarding migrate_disable()... can you enable it without the rest of RT?
> > I haven't seen its implementation. I suspect it's scheduler only change?
> > If I can use migrate_disable() without RT it will help my work on sleepable
> > BPF programs. I would only have to worry about rcu_read_lock() since
> > preempt_disable() is nicely addressed.
> 
> You have to talk to Peter Zijlstra about this as this is really
> scheduler relevant stuff. FYI, he undamentaly hates migrate_disable()
> from a schedulabilty POV, but as with the above lock construct the
> amount of better solutions is also close to zero.

I would imagine that migrate_disable is like temporary cpu pinning. The
scheduler has to have all the logic to make scheduling decisions quickly in
presence of pinned tasks and additional migrate_disable shouldn't introduce
slowdowns or complexity to critical path. Anyway, we'll discuss further
when migrate_disable patches hit mailing lists.
