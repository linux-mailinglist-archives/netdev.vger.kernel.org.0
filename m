Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91D21350DB
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgAIBHj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 20:07:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:25129 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgAIBHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:07:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 17:07:38 -0800
X-IronPort-AV: E=Sophos;i="5.69,412,1571727600"; 
   d="scan'208";a="218223786"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 17:07:37 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan> <87lfr9axm8.fsf@linux.intel.com> <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     Po Liu <po.liu@nxp.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Message-ID: <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Wed, 08 Jan 2020 17:07:37 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> >>> 1. add support in taprio to be configured without any schedule in the
> >>> "full offload" mode. In practice, allowing taprio to work somewhat
> >>> similar to (mqprio + frame-preemption), changes in the code should de
> >>> fairly small;
> >>
> >> +
> >>
> >> And if follow mqprio settings logic then preemption also can be enabled
> >> immediately while configuring taprio first time, and similarly new ADMIN
> >> can't change it and can be set w/o preemption option afterwards.
> >>
> >> So that following is correct:
> >>
> >> OPER
> >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> >>        base-time 10000000 \
> >>        num_tc 3 \
> >>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> >>        queues 1@0 1@1 2@2 \
> >>        preemption 0 1 1 1
> >>        flags 1
> >>
> >> then
> >> ADMIN
> >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> >>        base-time 12000000 \
> >>        num_tc 3 \
> >>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> >>        queues 1@0 1@1 2@2 \
> >>        preemption 0 1 1 1
> >>        sched-entry S 01 300000 \
> >>        sched-entry S 02 300000 \
> >>        flags 1
> >>
> >> then
> >> ADMIN
> >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> >>        base-time 13000000 \
> >>        sched-entry S 01 300000 \
> >>        sched-entry S 02 300000 \
> >>        flags 1
> >>
> >> BUT:
> >>
> >> 1) The question is only should it be in this way? I mean preemption to be
> >> enabled immediately? Also should include other parameters like
> >> fragment size.
> > 
> > We can decide what things are allowed/useful here. For example, it might
> > make sense to allow "preemption" to be changed. We can extend taprio to
> > support changing the fragment size, if that makes sense.
> > 
> >>
> >> 2) What if I want to use frame preemption with another "transmission selection
> >> algorithm"? Say another one "time sensitive" - CBS? How is it going to be
> >> stacked?
> > 
> > I am not seeing any (conceptual*) problems when plugging a cbs (for
> > example) qdisc into one of taprio children. Or, are you talking about a
> > more general problem?
> > 
> > * here I am considering that support for taprio without an schedule is
> >   added.
> > 
> >>
> >> In this case ethtool looks better, allowing this "MAC level" feature, to be
> >> configured separately.
> > 
> > My only issue with using ethtool is that then we would have two
> > different interfaces for "complementary" features. And it would make
> > things even harder to configure and debug. The fact that one talks about
> > traffic classes and the other transmission queues doesn't make me more
> > comfortable as well.
> > 
> > On the other hand, as there isn't a way to implement frame preemption in
> > software, I agree that it makes it kind of awkward to have it in the tc
> > subsystem.
> Absolutely. I think frame pre-emption feature flag, per queue express/
> pre-empt state, frag size, timers (hold/release) to be configured
> independently (perhaps through ethtool) and then taprio should check
> this with the lower device and then allow supporting additional Gate
> operations such as Hold/release if supported by underlying device.
> 
> What do you think? Why to abuse tc for this?
> 

After reading all this great discussion and revisiting the 802.1Q and 802.3br
specs, I'm now leaning towards to not coupling Frame Preemption support under
taprio qdisc. Besides what have been discussed, Annex S.2 from 802.1Q-2018
foresees FP without EST so it makes me feel like we should keep them separate.

Regarding the FP configuration knobs, the following seems reasonable to me:
    * Enable/disable FP feature
    * Preemptable queue mapping
    * Fragment size multiplier

I'm not sure about the knob 'timers (hold/release)' described in the quotes
above. I couldn't find a match in the specs. If it refers to 'holdAdvance' and
'releaseAdvance' parameters described in 802.1Q-2018, I believe they are not
configurable. Do we know any hardware where they are configurable?

Regards,

Andre
