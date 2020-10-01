Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7FE280A61
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbgJAWoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:44:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38796 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgJAWoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:44:23 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601592260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f5pavRIPBXFgoArTS09EMAvE+9XTGOcnORwLcRx4kkA=;
        b=U84f6VB+uoY56yY0AbL7m5zFgUQvOqpAnDuLzL3VgEIUJxo3VWnvTmp2r3XUK47/T9+W3/
        GuaMG375NPiap38Xpq+NieKRecG+teH4PClBFb01m+pyIuxlw3K18VA8kZlmYDCUzLZxrO
        BxAstiqQYGKe8B7quD/kZ4Ki/Z+w5tMLV4r7VzGOq/UgRGRzZ7qhgfdXay4ECCvbqNv8Dg
        70F6RFVZFQr0+QI0ovAYfxGYELQYMWbnPi9353lf4a2yTGRFO9YIs87/wg7svnN3lGVQ30
        3Fw7obB0uR90Z/Oo6ny8VWlc0UPhETzmecph2ts+Mx0h4F5sPk6dcnRupfYkNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601592260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f5pavRIPBXFgoArTS09EMAvE+9XTGOcnORwLcRx4kkA=;
        b=Xsq66SYfx5Fu5ZSQwlHHuBW51rXywOjw4mGFPmrJrIvzjPkx1LtZ+fV4PzJgwhwk89w2qi
        jrpBapKbZaJSMlAQ==
To:     Erez Geva <erez.geva.ext@siemens.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 4/7] Fix qdisc_watchdog_schedule_range_ns range check
In-Reply-To: <20201001205141.8885-5-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-5-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 00:44:19 +0200
Message-ID: <87pn61efcs.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:

Fixes should be at the beginning of a patch series and not be hidden
somewhere in the middle.

>    - As all parameters are unsigned.

This is not a sentence and this list style does not make that changelog
more readable.

>    - If 'expires' is bigger than 'last_expires' then the left expression
>      overflows.

This would be the most important information and should be clearly
spelled out as problem description at the very beginning of the change
log.

>    - It is better to use addition and check both ends of the range.

Is better? Either your change is correcting the problem or not. Just
better but incorrect does not cut it.

But let's look at the problem itself. The check is about:

    B <= A <= B + C

A, B, C are all unsigned. So if B > A then the result is false.

Now lets look at the implementation:

    if (A - B <= C)
    	return;

which works correctly due the wonders of unsigned math.

For B <= A the check is obviously correct.

If B > A then the result of the unsigned subtraction A - B is a very
large positive number which is pretty much guaranteed to be larger than
C, i.e. the result is false.

So while not immediately obvious, it's still correct.

Thanks,

        tglx



