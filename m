Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9422B233A3B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgG3VBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:01:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:13681 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgG3VBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 17:01:11 -0400
IronPort-SDR: 7yMrklX/VzB/EgrqbsGlLBsM6V+ap1/WBByFM35lRaR5nZBrXDBhzCKOGe5AoxPR03E0zFDAlI
 JKHmsSfTZ/Kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131260075"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="131260075"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 14:01:08 -0700
IronPort-SDR: PbBop5KoWfxIf5o0EeWb6lVbV0rWzkfRTunIt9hrwuf/zZQRSrrXZp+ryETaUUA/WKnwaLh1qp
 2jvTHGZqeMIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="490804902"
Received: from kyoungil-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.108.110])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jul 2020 14:01:06 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     "Zhang\, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "fweisbec\@gmail.com" <fweisbec@gmail.com>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs\@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: =?utf-8?B?5Zue5aSNOg==?= INFO: rcu detected stall in
 tc_modify_qdisc
In-Reply-To: <3fc2ce1b-553a-e6de-776c-7e4d668c6ecb@gmail.com>
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com> <87tuxqxhgq.fsf@intel.com> <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com> <87pn8cyk2b.fsf@intel.com> <3fc2ce1b-553a-e6de-776c-7e4d668c6ecb@gmail.com>
Date:   Thu, 30 Jul 2020 14:01:05 -0700
Message-ID: <87k0ykyay6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Eric Dumazet <eric.dumazet@gmail.com> writes:

>> I admit that I am on the fence on that argument: do not let even root
>> crash the system (the point that my code is crashing the system gives
>> weight to this side) vs. root has great powers, they need to know what
>> they are doing.
>> 
>> The argument that I used to convince myself was: root can easily create
>> a bunch of processes and give them the highest priority and do
>> effectively the same thing as this issue, so I went with a the "they
>> need to know what they are doing side".
>> 
>> A bit more on the specifics here:
>> 
>>   - Using a small interval size, is only a limitation of the taprio
>>   software mode, when using hardware offloads (which I think most users
>>   do), any interval size (supported by the hardware) can be used;
>> 
>>   - Choosing a good lower limit for this seems kind of hard: something
>>   below 1us would never work well, I think, but things 1us < x < 100us
>>   will depend on the hardware/kernel config/system load, and this is the
>>   range includes "useful" values for many systems.
>> 
>> Perhaps a middle ground would be to impose a limit based on the link
>> speed, the interval can never be smaller than the time it takes to send
>> the minimum ethernet frame (for 1G links this would be ~480ns, should be
>> enough to catch most programming mistakes). I am going to add this and
>> see how it looks like.
>> 
>> Sorry for the brain dump :-)
>
>
> I do not know taprio details, but do you really need a periodic timer
> ?

As we can control the transmission time of packets, you are right, I
don't.

Just a bit more detail about the current implementation taprio,
basically it has a sequence of { Traffic Classes that are open; Interval
} that repeats cyclicly, it uses an hrtimer to advance the pointer for
the current element, so during dequeue I can check if a traffic class is
"open" or "closed".

But again, if I calculate the 'skb->tstamp' of each packet during
enqueue, I don't need the hrtimer. What we have in the txtime-assisted
mode is half way there.

I think this is what you had in mind.


Cheers,
-- 
Vinicius
