Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB61386C61
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbhEQVkA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 May 2021 17:40:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:57475 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237741AbhEQVj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:39:59 -0400
IronPort-SDR: J3QOnpPOonV1TUwwgebvfAxTy1ogvtuzy/GMRDh00cXTf4gmENpt/wrv8nGQikMG9SmQg2Elqj
 Zc0m14q8YASQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="187977026"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="187977026"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 14:38:42 -0700
IronPort-SDR: DTgt40BRnsXHRoqKxB26ZD/dw5GFoXryP099LyL2tsd1+dskddwuSN8JNKppE/WQy16NHbVYUY
 fABfcHDchpOQ==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="543853987"
Received: from mchicks-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.132.186])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 14:38:41 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Michael Walle <michael@walle.cc>,
        Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
        Vedang Patel <vedang.patel@intel.com>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev
 queue mapping
In-Reply-To: <94d68f6301c085fbdd1940cd0f6f7def@walle.cc>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
 <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
 <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
 <94d68f6301c085fbdd1940cd0f6f7def@walle.cc>
Date:   Mon, 17 May 2021 14:38:40 -0700
Message-ID: <874kf111nj.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Walle <michael@walle.cc> writes:

>>> 
>>> At least the hardware that I am familiar with doesn't reorder packets.
>>> 
>>> For TXTIME, we have ETF (the qdisc) that re-order packets. The way
>>> things work when taprio and ETF are used together is something like
>>> this: taprio only has enough knowledge about TXTIME to drop packets 
>>> that
>>> would be transmitted outside their "transmission window" (e.g. for
>>> traffic class 0 the transmission window is only for 10 to 50, the 
>>> TXTIME
>>> for a packet is 60, this packet is "invalid" and is dropped). And then
>>> when the packet is enqueued to the "child" ETF, it's re-ordered and 
>>> then
>>> sent to the driver.
>>> 
>>> And this is something that this patch breaks, the ability of dropping
>>> those invalid packets (I really wouldn't like to do this verification
>>> inside our drivers). Thanks for noticing this.
>
> Is this really how the taprio should behave? I mean, should the frame
> really be dropped by taprio if TXTIME is outside of the window? Why
> would taprio bother with TXTIME at all?

Yeah, I understand what you are saying, I also didn't like the idea of
having TXTIME knowledge inside taprio. This trade off was made because
the HW we have is very... particular about the launchtime, if the
launchtime for a packet ends after the "close" time for that queue, that
queue can end up stuck (for multiple seconds in some extreme cases).

The idea is that other vendors could be as particular.

Also, what helped convince me was that txtime is a feature of the
socket/skb, and if taprio/whatever can use it to make the driver life's
easier, then let's use it, that is

>
>> Hmm, indeed, I missed that check (we don't use ETF currently). I'm not
>> sure of the best way forward, but here are a few thoughts:
>> . The problem only arises for full-offload taprio, not for the
>> software or TxTime-assisted cases.
>> . I'm not sure mixing taprio(full-offload) with etf(no-offload) is
>> very useful, at least with small gate intervals: it's likely you will
>> miss your window when trying to send a packet at exactly the right
>> time in software (I am usually testing taprio with a 2ms period and a
>> 4µs interval for the RT stream).
>> . That leaves the case of taprio(full-offload) with etf(offload).
>> Right now with the current stmmac driver config, a packet whose tstamp
>> is outside its gate interval will be sent on the next interval (and
>> block the queue).
>
> If both are offloaded, are the h/w queues reordered if there is a
> new frame with an earlier TXTIME? Or will the queue be blocked by a
> frame with a later transmission time?

Even if offloaded ETF will re-order packets. In bit more detail, ETF
will re-order packets if their launchtime is more than "delta"
nanoseconds in the future.

>
> TBH I've never understood why the ETF qdisc will drop frames with
> TXTIME in the past. I mean it makes sense with hardware offloading. But
> without it, how can you make sure the kernel will wake up the queue
> at just the right time to be able to send it. You can juggle the delta
> parameter but on you don't want to send to too early, but on the other
> hand the frame will likely be dropped if delta is too small. What am
> I misssing here?

I don't think you are missing anything.

Just some background, ETF was written thinking mostly about it being
offloaded, the non-offloaded/"software" mode was a best-effort
implementation of that idea.

That is, If you have use cases for non-offloaded ETF and it work better
if it didn't drop "late" packets, I would be happy hear more.


Cheers,
-- 
Vinicius
