Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135B41350B2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgAIA45 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 19:56:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:45603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgAIA45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 19:56:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 16:56:56 -0800
X-IronPort-AV: E=Sophos;i="5.69,412,1571727600"; 
   d="scan'208";a="218221687"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 16:56:55 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87eex43pzm.fsf@linux.intel.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
To:     "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Message-ID: <157853141533.36295.15469390811167798190@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Wed, 08 Jan 2020 16:56:55 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Quoting Vinicius Costa Gomes (2019-12-16 13:44:13)
> >> Quoting Po Liu (2019-11-27 01:59:18)
> >> > User can check the feature 'tx-preemption' by command 'ethtool -k
> >> > devname'. If hareware set preemption feature. The property would be a
> >> > fixed value 'on' if hardware support the frame preemption.
> >> > Feature would show a fixed value 'off' if hardware don't support the
> >> > frame preemption.
> 
> Having some knobs in ethtool to enable when/how Frame Preemption is
> advertised on the wire makes sense. I also agree that it should be "on"
> by default.

Agreed. If Frame Preemption is supported by hardware and it can be
enabled/disabled, I think we should allow the user to configure it, instead of
having it fixed in 'on'.

> >> In an early RFC series [1], we proposed a way to support frame preemption. I'm
> >> not sure if you have considered it before implementing this other proposal
> >> based on ethtool interface so I thought it would be a good idea to bring that up
> >> to your attention, just in case.
> >  
> > Sorry, I didn't notice the RFC proposal. Using ethtool set the
> > preemption just thinking about 8021Qbu as standalone. And not limit to
> > the taprio if user won't set 802.1Qbv.
> 
> I see your point of using frame-preemption "standalone", I have two
> ideas:
> 
>  1. add support in taprio to be configured without any schedule in the
>  "full offload" mode. In practice, allowing taprio to work somewhat
>  similar to (mqprio + frame-preemption), changes in the code should de
>  fairly small;
> 
>  2. extend mqprio to support frame-preemption;

I'm not sure 2) is a good way to support frame preemption "standalone"
functionality since mpqrio already looks overloaded. Besides its original goal
(map traffic flows to hardware queues), it also supports different modes and
traffic shaping. I rather not add another functionality to it.

> > As some feedback  also want to set the MAC merge minimal fragment size
> > and get some more information of 802.3br.
> 
> The minimal fragment size, I guess, also makes sense to be kept in
> ethtool. That is we have a sane default, and allow the user to change
> this setting for special cases.

Yes, the mim fragment size is another configuration knob we should have, and it
should probably live at the same place we land the enable/disable knob.

> >> It also aligns with the gate control operations Set-And-Hold-MAC and Set-And-
> >> Release-MAC that can be set via 'sched-entry' (see Table 8.7 from
> >> 802.1Q-2018 for further details.
> >  
> > I am curious about Set-And-Hold-Mac via 'sched-entry'. Actually, it
> > could be understand as guardband by hardware preemption. MAC should
> > auto calculate the nano seconds before  express entry slot start to
> > break to two fragments. Set-And-Hold-MAC should minimal larger than
> > the fragment-size oct times.
> 
> Another interesting point. My first idea is that when the schedule is
> offloaded to the driver and the driver detects that the "entry" width is
> smaller than the fragment side, the driver could reject that schedule
> with a nice error message.

My understanding is that, if HOLD operation is supported, the hardware issues
an MM_CTL.request(HOLD) at 'holdAdvance' nsecs in advance to the point where
the 'sched-entry' with Set-And-Hold-MAC starts. This comes from the description
in Table 8-7 from 802.1Q-2018.

Best regards,

Andre
