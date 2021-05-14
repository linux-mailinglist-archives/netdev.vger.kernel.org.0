Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EEE38145B
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhENXsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:48:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:27461 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhENXsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 19:48:17 -0400
IronPort-SDR: W1rKUBnv3bubPIFLteIkhZvdGnH+qwBE0uH2u8J9mLU2KJi1xf+yvTXZV7u8blcstxICktlrHE
 ok5ziup5EydQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="285775852"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="285775852"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 16:47:05 -0700
IronPort-SDR: mdLnzuXlfcA6xXcrWP0Z9ES3zXM2J8//LYK9pWlA1dlJ5h+V7HGK2OKgZOEjx0krqlsCweJl36
 8aN8w65QdChA==
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="624965528"
Received: from daherman-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.126.53])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 16:47:04 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev
 queue mapping
In-Reply-To: <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
Date:   Fri, 14 May 2021 16:47:02 -0700
Message-ID: <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
>> > CCing them now. Comments, anyone?  
>> 
>> I guess I should suggest myself as maintainer, to reduce chances of this
>> happening again.
>
> Yes, please.
>
>> > This looks like a very drastic change. Are you expecting the qdisc will
>> > always be bypassed?  
>> 
>> Only when running in full offload mode it will be bypassed.
>> 
>> And it's kind of by design, in offload mode, the idea was: configure the
>> netdev traffic class to queue mapping, send the schedule to the hardware
>> and stay out of the way.
>> 
>> But as per Yannick's report, it seems that taprio doesn't stay enough
>> out of the yay.
>> 
>> > After a 1 minute looks it seems like taprio is using device queues in
>> > strict priority fashion. Maybe a different model is needed, but a qdisc
>> > with:
>> >
>> > enqueue()
>> > {
>> > 	WARN_ONCE(1)
>> > }
>> >
>> > really doesn't look right to me.  
>> 
>> This patch takes the "stay out of the way" to the extreme, I kind of
>> like it/I am not opposed to it, if I had this idea a couple of years
>> ago, perhaps I would have used this same approach.
>
> Sorry for my ignorance, but for TXTIME is the hardware capable of
> reordering or the user is supposed to know how to send packets?

At least the hardware that I am familiar with doesn't reorder packets.

For TXTIME, we have ETF (the qdisc) that re-order packets. The way
things work when taprio and ETF are used together is something like
this: taprio only has enough knowledge about TXTIME to drop packets that
would be transmitted outside their "transmission window" (e.g. for
traffic class 0 the transmission window is only for 10 to 50, the TXTIME
for a packet is 60, this packet is "invalid" and is dropped). And then
when the packet is enqueued to the "child" ETF, it's re-ordered and then
sent to the driver.

And this is something that this patch breaks, the ability of dropping
those invalid packets (I really wouldn't like to do this verification
inside our drivers). Thanks for noticing this.

>
> My biggest problem with this patch is that unless the application is
> very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
> servicing the queue when the application sends - the qdisc will not 
> be bypassed, right?
>
>> I am now thinking if this idea locks us out of anything.
>> 
>> Anyway, a nicer alternative would exist if we had a way to tell the core
>> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
>> after init() runs.
>
> I don't think calling enqueue() and dequeue() is a problem. The problem
> is that RT process does unrelated work.

That is true. But this seems like a much bigger (or at least more
"core") issue.


Cheers,
-- 
Vinicius
