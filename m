Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739DB2638BD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIIVyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:54:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:11808 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIIVyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 17:54:40 -0400
IronPort-SDR: PlTa6i5k8wWbfvqthBpLumDhZ1w+xvpXM2hlvzFgQyNOJotzf/z55V0Mn+ILxs2WMrUfDH5jIW
 pqPPJFEm7EpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="159379825"
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="159379825"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 14:54:39 -0700
IronPort-SDR: xEQVTvgSU7FZDwgkn9J49hOcTAsQJFTQq757N5+2SSN3hyhLWp5jR4mvDVc3QHwhJOfpRYDt5Z
 +fn0mRtQY4iw==
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="449356036"
Received: from rbentz-mobl.amr.corp.intel.com (HELO ellie) ([10.212.86.17])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 14:54:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com
Subject: Re: INFO: rcu detected stall in cleanup_net (4)
In-Reply-To: <20200909085203.5e335c61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <000000000000db78de05aedabb5a@google.com> <20200909085203.5e335c61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 09 Sep 2020 14:54:36 -0700
Message-ID: <877dt2pqeb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 08 Sep 2020 22:29:21 -0700 syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    59126901 Merge tag 'perf-tools-fixes-for-v5.9-2020-09-03' ..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12edb935900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f6ce8d5b68299
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8267241609ae8c23b248
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157c7aa5900000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c92ef9900000
>> 
>> The issue was bisected to:
>> 
>> commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
>> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Date:   Sat Sep 29 00:59:43 2018 +0000
>> 
>>     tc: Add support for configuring the taprio scheduler
>
>
> Vinicius, could you please take a look at all the syzbot reports which
> point to your commit? I know syzbot bisection is not super reliable,
> but at least 3 reports point to your commit now, so something's
> probably going on.

I did take a look, and it seems that it all boils down to having too
small (unreasonable?) intervals in the schedule, which causes the
hrtimer handler to starve the other kernel threads.

I have a quick fix to restrict the interval values to more sensible
values (at least equal to the time it takes to transmit the mininum
ethernet frame size), I am testing it and I will propose it soon. But a
proper solution will require more time.


Cheers,
-- 
Vinicius
