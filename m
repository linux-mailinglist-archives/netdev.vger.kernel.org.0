Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D71C7427
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgEFPU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:20:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:38474 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgEFPU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588778458; x=1620314458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=Qxz8YBQJMe0tFK5dHJ7HQYaq14w58zhXEZxLWPuYNeE=;
  b=BC/sLKzDzARc1pQD/WzENadvk+JG4VV1rJZFWINw4+iGfN/1vkBz/vXW
   RPsmLPCiyKzkOtQYD7r+1hTMugPzpgq6r+HHWSA5tpD7a7scq7OCXGetp
   jrZxMWGf2f4vl/Mvy8pOTbTxTgEM8rrW/oJ4xb+uFBWzSWwhea76UzLDx
   o=;
IronPort-SDR: Ld8GMMi8Y88G+q0R5NC/a+LOiUcKRXJWMBHS1Vb9+4Qrjo2+QlB9FolQxA3SnFKWn7ta1QRKpi
 +ozPwuTuHyJA==
X-IronPort-AV: E=Sophos;i="5.73,359,1583193600"; 
   d="scan'208";a="43082169"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 May 2020 15:20:56 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id A05A4A2171;
        Wed,  6 May 2020 15:20:52 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 15:20:51 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.37) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 15:20:43 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: Re: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Wed, 6 May 2020 17:20:25 +0200
Message-ID: <20200506152025.22085-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506144151.GZ2869@paulmck-ThinkPad-P72> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.37]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 07:41:51 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Wed, May 06, 2020 at 02:59:26PM +0200, SeongJae Park wrote:
> > TL; DR: It was not kernel's fault, but the benchmark program.
> > 
> > So, the problem is reproducible using the lebench[1] only.  I carefully read
> > it's code again.
> > 
> > Before running the problem occurred "poll big" sub test, lebench executes
> > "context switch" sub test.  For the test, it sets the cpu affinity[2] and
> > process priority[3] of itself to '0' and '-20', respectively.  However, it
> > doesn't restore the values to original value even after the "context switch" is
> > finished.  For the reason, "select big" sub test also run binded on CPU 0 and
> > has lowest nice value.  Therefore, it can disturb the RCU callback thread for
> > the CPU 0, which processes the deferred deallocations of the sockets, and as a
> > result it triggers the OOM.
> > 
> > We confirmed the problem disappears by offloading the RCU callbacks from the
> > CPU 0 using rcu_nocbs=0 boot parameter or simply restoring the affinity and/or
> > priority.
> > 
> > Someone _might_ still argue that this is kernel problem because the problem
> > didn't occur on the old kernels prior to the Al's patches.  However, setting
> > the affinity and priority was available because the program received the
> > permission.  Therefore, it would be reasonable to blame the system
> > administrators rather than the kernel.
> > 
> > So, please ignore this patchset, apology for making confuse.  If you still has
> > some doubts or need more tests, please let me know.
> > 
> > [1] https://github.com/LinuxPerfStudy/LEBench
> > [2] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L820
> > [3] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L822
> 
> Thank you for chasing this down!
> 
> I have had this sort of thing on my list as a potential issue, but given
> that it is now really showing up, it sounds like it is time to bump
> up its priority a bit.  Of course there are limits, so if userspace is
> running at any of the real-time priorities, making sufficient CPU time
> available to RCU's kthreads becomes userspace's responsibility.  But if
> everything is running at SCHED_OTHER (which is this case here, correct?),

Correct.

> then it is reasonable for RCU to do some work to avoid this situation.

That would be also great!

> 
> But still, yes, the immediate job is fixing the benchmark.  ;-)

Totally agreed.

> 
> 							Thanx, Paul
> 
> PS.  Why not just attack all potential issues on my list?  Because I
>      usually learn quite a bit from seeing the problem actually happen.
>      And sometimes other changes in RCU eliminate the potential issue
>      before it has a chance to happen.

Sounds interesting, I will try some of those in my spare time ;)


Thanks,
SeongJae Park
