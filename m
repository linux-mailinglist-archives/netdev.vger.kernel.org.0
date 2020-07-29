Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E14232525
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgG2TN3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 15:13:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2252 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgG2TN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 15:13:29 -0400
IronPort-SDR: APilKWlAra2BRvFzKRAk5pYx9pOqQ1yAwQ89Ao3M3WQd21Fa+8RxR8qb2RMwT0BfP79ZIeiq+O
 AWe4moDyXe9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169609180"
X-IronPort-AV: E=Sophos;i="5.75,411,1589266800"; 
   d="scan'208";a="169609180"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 12:13:29 -0700
IronPort-SDR: myaKcCtokUJMkzeggkpvAj5yxerRteQIEo9VLaiKhg7BXQhs0cG1Dr2nExr3NPQZHn5rKMBVyK
 g63hxz7RTLnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,411,1589266800"; 
   d="scan'208";a="490391579"
Received: from askotian-mobl2.amr.corp.intel.com (HELO ellie) ([10.212.6.60])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jul 2020 12:13:28 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     "Zhang\, Qiang" <Qiang.Zhang@windriver.com>,
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
In-Reply-To: <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com>
Date:   Wed, 29 Jul 2020 12:13:25 -0700
Message-ID: <87tuxqxhgq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

"Zhang, Qiang" <Qiang.Zhang@windriver.com> writes:

> ________________________________________
> 发件人: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> 代表 syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>
> 发送时间: 2020年7月29日 13:53
> 收件人: davem@davemloft.net; fweisbec@gmail.com; jhs@mojatatu.com; jiri@resnulli.us; linux-kernel@vger.kernel.org; mingo@kernel.org; netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tglx@linutronix.de; vinicius.gomes@intel.com; xiyou.wangcong@gmail.com
> 主题: INFO: rcu detected stall in tc_modify_qdisc
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to_kern()
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=12925e38900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
> dashboard link: https://syzkaller.appspot.com/bug?extid=9f78d5c664a8c33f4cce
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:
> https://syzkaller.appspot.com/x/repro.syz?x=16587f8c900000

It seems that syzkaller is generating an schedule with too small
intervals (3ns in this case) which causes a hrtimer busy-loop which
starves other kernel threads.

We could put some limits on the interval when running in software mode,
but I don't like this too much, because we are talking about users with
CAP_NET_ADMIN and they have easier ways to do bad things to the system.


Cheers,
-- 
Vinicius
