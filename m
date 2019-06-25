Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5655250A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfFYHnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:43:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54378 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfFYHnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 03:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3Woq6Ijx79j2u1qvlhauxGczuuE2pOnfE5TxDoYwUlo=; b=ZOsUs5qSf57Dj/Pk5RYzsxw59
        UEljXgjEtZQvU9qf0h/H8kknIf7OPGmcSz8smyBFHiroy9ujI8Qo/4ckFOQzdG/uelI5b6DAirzy6
        Deq5BLpWD9gsZsC0HfxvFd9u8xeHoKc6t3lE8UHCjzBetzSIdrTiNTZOKyfN2taQgp8CnXLEEPpno
        0etHTcBjiIS3jz8xF40mDJIRn+dWXflSvl2dS9xAZScTCCvOTPrjD3oiNkgdt4nCj1//4PCBe4A8i
        DbOAA+hulLsM7sGPx247bRBzMA47vpqf9vhJRSSqMrJxqdq+acP818QPbjp1s4nSdOzxTUwQMULTc
        KwuD+LPhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfg5n-0002my-Rq; Tue, 25 Jun 2019 07:42:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7C1BA20A0642F; Tue, 25 Jun 2019 09:42:14 +0200 (CEST)
Date:   Tue, 25 Jun 2019 09:42:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Frank Ch. Eigler" <fche@redhat.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jessica Yu <jeyu@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, jikos@kernel.org,
        mbenes@suse.cz, Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Richter <rric@kernel.org>,
        rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        paulmck <paulmck@linux.ibm.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
Message-ID: <20190625074214.GR3436@hirez.programming.kicks-ass.net>
References: <20190624091843.859714294@infradead.org>
 <20190624092109.805742823@infradead.org>
 <320564860.243.1561384864186.JavaMail.zimbra@efficios.com>
 <20190624205810.GD26422@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624205810.GD26422@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 04:58:10PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> > > While auditing all module notifiers I noticed a whole bunch of fail
> > > wrt the return value. Notifiers have a 'special' return semantics.
> 
> From peterz's comments, the patches, it's not obvious to me how one is
> to choose between 0 (NOTIFY_DONE) and 1 (NOTIFY_OK) in the case of a
> routine success.

I'm not sure either; what I think I choice was:

 - if I want to completely ignore the callback, use DONE (per the
   "Don't care" comment).

 - if we finished the notifier without error, use OK or
   notifier_from_errno(0).

But yes, its a bit of a shit interface.
