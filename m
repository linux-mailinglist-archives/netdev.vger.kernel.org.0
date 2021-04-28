Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2212336D662
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 13:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhD1LXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 07:23:03 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:53589 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhD1LXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 07:23:02 -0400
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id C1BD824000C;
        Wed, 28 Apr 2021 11:22:12 +0000 (UTC)
To:     jean.tourrilhes@hpe.com, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, William Tu <u9012063@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <20210421135747.312095-1-i.maximets@ovn.org>
 <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
 <20210428064553.GA19023@labs.hpe.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size
 calculation
Message-ID: <04bd0073-6eb7-6747-a0b1-3c25cca7873a@ovn.org>
Date:   Wed, 28 Apr 2021 13:22:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210428064553.GA19023@labs.hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 8:45 AM, Jean Tourrilhes wrote:
> On Wed, Apr 28, 2021 at 02:24:10PM +0800, Tonghao Zhang wrote:
>> Hi Ilya
>> If we set the burst size too small, the meters of ovs don't work.
> 
> 	Most likely, you need to set the burst size larger.
> 	A quick Google on finding a good burst size :
> https://www.juniper.net/documentation/us/en/software/junos/routing-policy/topics/concept/policer-mx-m120-m320-burstsize-determining.html

+1.
Tonghao, If you're configuring burst size too low, meter will not pass
packets.  That's expected behavior.  In your example with 1400B packets
and 1500B (12 kbit) burst size there is a very high probability that a
lot of packets will be dropped and not pass the meter unless you're
sending them in a very precise points in time.  I don't think that anyone
will recommend setting burst size so close to the MTU.  The article above
suggests using 10x MTU value, but I don't know if that will be enough
with high speed devices.

> 
> 	Now, the interesting question, is the behaviour of OVS
> different from a standard token bucket, such as a kernel policer ?

I didn't test it, but I looked at the implementation in
net/sched/act_police.c and net/sched/sch_tbf.c, and they should work
in a same way as this patch, i.e. it's a classic token bucket where
burst is a burst and nothing else.  These implementations uses burst
in nanoseconds instead of bytes, but that doesn't matter (nanoseconds
calculated from the rate and burst in bytes specified by user).
For example, net/sched/act_police.c works like this:

  toks = min_t(s64, now - police->tcfp_t_c, p->tcfp_burst);
          ^---- calculating how many tokens needs to be added 
  toks += police->tcfp_toks; <-- also adding all existing tokens
  if (toks > p->tcfp_burst)
      toks = p->tcfp_burst;  <-- hard limit of tokens by the burst size
  toks -= (s64)psched_l2t_ns(&p->rate, qdisc_pkt_len(skb));
        ^-- spending tokens to pass the packet
  if (toks >= 0) {           <-- Did we have enough tokens?
      /* Packet passed. */
      police->tcfp_t_c = now;
      police->tcfp_toks = toks;
  }

net/sched/sch_tbf.c works in almost exactly same way.  So, there is
*no algorithmic difference* here.

---

There is one difference though.  I said that it doesn't matter that
tc uses time instead of bytes as a measure for tokens, but it actually
does matter because time is calculated based on the configured rate,
but applied to the actual rate.  Let me explain:

Assuming configuration "rate 200mbit burst 20K" as in example below.
iproute2 will calculate burst using tc_calc_xmittime function:
  https://github.com/shemminger/iproute2/blob/9f366536edb5158343152604e82b968be46dbf26/tc/tc_core.c#L60

So the burst configuration passed to kernel will be:

 TIME_UNITS_PER_SEC(1000000) * (20 * 1024) / (200 * 1024*1024/8) = 781 usec
         10^-6                     bytes           bytes/sec

That means that burst is not 20K bytes as configured, but any number of
bytes in 781 usec window regardless of a line rate.
For example, if traffic goes from 10 Gbps interface, effective burst size
will be 10^9 / 8 * 781 * 10^-6 = 97K which is almost 5 times higher than
the configured value.  And the difference scales linearly with the increase
of the line rate speed.  For 100G interface it will be 970K.

It might be much more noticeable with lower configured rate.
For "rate 10mbit burst 20K", real burst interval will be 15.6 msec, which
will translate into 1.9M burst size for a 10G line rate, which is almost
100 times larger than configured 20K.  And it will be 19M for a 100Gbps
interface, making the average rate triple as high as configured for a
policer.

All in all this looks more like an issue of TC and iproute implementation.
IMHO, tc command should not allow configuration of burst in bytes just
because it can not configure that in kernel and therefore can not guarantee
that behavior.  Configuration should be in micro/nanoseconds instead.

CC: Cong, Davide
Maybe someone from the TC side can comment on that?

We can try to mimic this behavior in OVS, but I'm not sure if it's correct.
Current OVS implementation, unlike TC, guarantees the burst size in bytes.
And it's also a completely different kind of difference with OVS meters, so
unrelated to the current patch.

Best regards, Ilya Maximets.

> 	Here is how to set up a kernel policer :
> ----------------------------------------------------------
> # Create a dummy classful discipline to attach filter
> tc qdisc del dev eth6 root
> tc qdisc add dev eth6 root handle 1: prio bands 2 priomap  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> tc qdisc add dev eth6 parent 1:1 handle 10: pfifo limit 1000
> tc qdisc add dev eth6 parent 1:2 handle 20: pfifo limit 1000
> tc -s qdisc show dev eth6
> tc -s class show dev eth6
> 
> # Filter to do hard rate limiting
> tc filter del dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 
> tc filter add dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 match u32 0 0 police rate 200mbit burst 20K mtu 10000 drop
> tc -s filter show dev eth6
> tc filter change dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 match u32 0 0 police rate 200mbit burst 50K mtu 10000 drop
> ----------------------------------------------------------
> 
> 	Regards,
> 
> 	Jean
> 

