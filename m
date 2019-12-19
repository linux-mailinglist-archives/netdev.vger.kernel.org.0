Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE0125962
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfLSBx6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 20:53:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:57586 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfLSBx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 20:53:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 17:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="417444867"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 18 Dec 2019 17:53:57 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Po Liu <po.liu@nxp.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <20191219004322.GA20146@khorivan>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan>
Date:   Wed, 18 Dec 2019 17:54:23 -0800
Message-ID: <87lfr9axm8.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:

>>>> Quoting Po Liu (2019-11-27 01:59:18)
>>>> > IEEE Std 802.1Qbu standard defined the frame preemption of port
>>>> > traffic classes. This patch introduce a method to set traffic classes
>>>> > preemption. Add a parameter 'preemption' in struct
>>>> > ethtool_link_settings. The value will be translated to a binary, each
>>>> > bit represent a traffic class. Bit "1" means preemptable traffic
>>>> > class. Bit "0" means express traffic class.  MSB represent high number
>>>> > traffic class.
>>>> >
>>>> > If hardware support the frame preemption, driver could set the
>>>> > ethernet device with hw_features and features with NETIF_F_PREEMPTION
>>>> > when initializing the port driver.
>>>> >
>>>> > User can check the feature 'tx-preemption' by command 'ethtool -k
>>>> > devname'. If hareware set preemption feature. The property would be a
>>>> > fixed value 'on' if hardware support the frame preemption.
>>>> > Feature would show a fixed value 'off' if hardware don't support the
>>>> > frame preemption.
>>
>>Having some knobs in ethtool to enable when/how Frame Preemption is
>>advertised on the wire makes sense. I also agree that it should be "on"
>>by default.
>>
>>>> >
>>>> > Command 'ethtool devname' and 'ethtool -s devname preemption N'
>>>> > would show/set which traffic classes are frame preemptable.
>>>> >
>>>> > Port driver would implement the frame preemption in the function
>>>> > get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>>>>
>>>> In an early RFC series [1], we proposed a way to support frame preemption. I'm
>>>> not sure if you have considered it before implementing this other proposal
>>>> based on ethtool interface so I thought it would be a good idea to bring that up
>>>> to your attention, just in case.
>>>
>>> Sorry, I didn't notice the RFC proposal. Using ethtool set the
>>> preemption just thinking about 8021Qbu as standalone. And not limit to
>>> the taprio if user won't set 802.1Qbv.
>>
>>I see your point of using frame-preemption "standalone", I have two
>>ideas:
>>
>> 1. add support in taprio to be configured without any schedule in the
>> "full offload" mode. In practice, allowing taprio to work somewhat
>> similar to (mqprio + frame-preemption), changes in the code should de
>> fairly small;
>
> +
>
> And if follow mqprio settings logic then preemption also can be enabled
> immediately while configuring taprio first time, and similarly new ADMIN
> can't change it and can be set w/o preemption option afterwards.
>
> So that following is correct:
>
> OPER
> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>       base-time 10000000 \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       preemption 0 1 1 1
>       flags 1
>
> then
> ADMIN
> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>       base-time 12000000 \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       preemption 0 1 1 1
>       sched-entry S 01 300000 \
>       sched-entry S 02 300000 \
>       flags 1
>
> then
> ADMIN
> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>       base-time 13000000 \
>       sched-entry S 01 300000 \
>       sched-entry S 02 300000 \
>       flags 1
>
> BUT:
>
> 1) The question is only should it be in this way? I mean preemption to be
> enabled immediately? Also should include other parameters like
> fragment size.

We can decide what things are allowed/useful here. For example, it might
make sense to allow "preemption" to be changed. We can extend taprio to
support changing the fragment size, if that makes sense.

>
> 2) What if I want to use frame preemption with another "transmission selection
> algorithm"? Say another one "time sensitive" - CBS? How is it going to be
> stacked?

I am not seeing any (conceptual*) problems when plugging a cbs (for
example) qdisc into one of taprio children. Or, are you talking about a
more general problem?

* here I am considering that support for taprio without an schedule is
 added.

>
> In this case ethtool looks better, allowing this "MAC level" feature, to be
> configured separately.

My only issue with using ethtool is that then we would have two
different interfaces for "complementary" features. And it would make
things even harder to configure and debug. The fact that one talks about
traffic classes and the other transmission queues doesn't make me more
comfortable as well.

On the other hand, as there isn't a way to implement frame preemption in
software, I agree that it makes it kind of awkward to have it in the tc
subsystem.

At this point, I am slightly in favor of the taprio approach (yes, I am
biased :-), but I can be convinced otherwise. I will be only a little
sad if we choose to go with ethtool for now, and then add support up in
the stack, something similar to "ethtool -N" and "tc-flower".

>
>>
>> 2. extend mqprio to support frame-preemption;
>>
>>>
>>> As some feedback  also want to set the MAC merge minimal fragment size
>>> and get some more information of 802.3br.
>>
>>The minimal fragment size, I guess, also makes sense to be kept in
>>ethtool. That is we have a sane default, and allow the user to change
>>this setting for special cases.
>>
>>>
>>>>
>>>> In that initial proposal, Frame Preemption feature is configured via taprio qdisc.
>>>> For example:
>>>>
>>>> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>>>>       num_tc 3 \
>>>>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>>>       queues 1@0 1@1 2@2 \
>>>>       preemption 0 1 1 1 \
>>>>       base-time 10000000 \
>>>>       sched-entry S 01 300000 \
>>>>       sched-entry S 02 300000 \
>>>>       sched-entry S 04 400000 \
>>>>       clockid CLOCK_TAI
>>>>
>>>> It also aligns with the gate control operations Set-And-Hold-MAC and Set-And-
>>>> Release-MAC that can be set via 'sched-entry' (see Table 8.7 from
>>>> 802.1Q-2018 for further details.
>>>
>>> I am curious about Set-And-Hold-Mac via 'sched-entry'. Actually, it
>>> could be understand as guardband by hardware preemption. MAC should
>>> auto calculate the nano seconds before  express entry slot start to
>>> break to two fragments. Set-And-Hold-MAC should minimal larger than
>>> the fragment-size oct times.
>>
>>Another interesting point. My first idea is that when the schedule is
>>offloaded to the driver and the driver detects that the "entry" width is
>>smaller than the fragment side, the driver could reject that schedule
>>with a nice error message.
>
> Looks ok, if entry command is RELEASE or SET only, but not HOLD, and
> only if it contains express queues. And if for entry is expectable to have
> interval shorter, the entry has to be marked as HOLD then.
>
> But not every offload is able to support mac/hold per sched (there is
> no HOLD/RELEASE commands in this case). For this case seems like here can
> be 2 cases:

Yeah, the hw I have in hand also doesn't support the HOLD/RELEASE
commands.

>
> 1) there is no “gate close” event for the preemptible traffic
> 2) there is "gate close" event for the preemptable traffic
>
> And both can have the following impact, if assume the main reason to
> this guard check is to guarantee the express queue cannot be blocked while
> this "close to short" interval opening ofc:
>
> If a preemption fragment is started before "express" frame, then interval
> should allow to complete preemption fragment and has to have enough time
> to insert express frame. So here situation when maximum packet size per
> each queue can have place.
>
> In case of TI am65 this queue MTU is configurable per queue (for similar
> reasons and couple more (packet fill feature for instance)) and can be
> used for guard check also, but not clear where it should be. Seems like
> it should be done using ethtool also, but can be needed for taprio
> interface....

For now, at least for the hardware I am working on, something like this
is configurable, but I wasn't planning on exposing it, using the maximum
ethernet frame size seemed a good default.

>
>>>
>>>>
>>>> Please share your thoughts on this.
>>>
>>> I am good to see there is frame preemption proposal. Each way is ok
>>> for me but ethtool is more flexible. I've seen the RFC the code. The
>>> hardware offload is in the mainline, but preemption is not yet, I
>>> don't know why. Could you post it again?
>>
>>It's not mainline because this kind of stuff will not be accepted
>>upstream without in-tree users. And you are the first one to propose
>>such a thing :-)
>>
>>It's just now that I have something that supports frame-preemption, the
>>code I have is approaching RFC-like quality. I will send another RFC
>>this week hopefully, and we can see how things look in practice.
>>
>>
>>Cheers,
>>--
>>Vinicius
>
> -- 
> Regards,
> Ivan Khoronzhuk

Cheers,
--
Vinicius
