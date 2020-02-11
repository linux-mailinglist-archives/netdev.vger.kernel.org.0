Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1215999D
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgBKTVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:21:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:52862 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgBKTVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:21:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 11:21:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="433791170"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 11 Feb 2020 11:21:21 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <70deb628-d7bc-d2a3-486d-d3e53854c06e@ti.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <87v9p93a2s.fsf@linux.intel.com> <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com> <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com> <87d0bajc3l.fsf@linux.intel.com> <70deb628-d7bc-d2a3-486d-d3e53854c06e@ti.com>
Date:   Tue, 11 Feb 2020 11:22:56 -0800
Message-ID: <877e0tx71r.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

> We are still working to send a patch for taprio offload on our hardware
> and it may take a while to get to this. So if someone can help to add
> the required kernel/driver interface for this, that will be great!

Will add this to my todo list. But if anyone else has the spare cycles
feel free to have a go at it.

>
>>>>       - ConfigChangeError - Error in configuration (AdminBaseTime <
>>>>         CurrentTime)
>>>
>>> This can be exported similarly.
>> 
>> In my view, having this as a "runtime" error is not useful, as we can
>> verify this at configuration time.
>
> Looks like this is not an error per 802.1Q standard if I understood it
> correctly.
>
> This is what I see.
> =======================================================================
>  From 802.1Q 2018, 8.6.9.1.1 SetCycleStartTime()
>
> If AdminBaseTime is set to the same time in the past in all bridges and
> end stations, OperBaseTime is always in the past, and all cycles start
> synchronized. Using AdminBaseTime in the past is appropriate when you
> can start schedules prior to starting the application that uses the
> schedules. Use of AdminBaseTime in the future is intended to change a
> currently running schedule in all bridges and end stations to a new
> schedule at a future time. Using AdminBaseTime in the future is
> appropriate when schedules must be changed without stopping the
> application
> ========================================================================
>

What I meant here is the case that I already have an "oper" schedule
running, so my "oper->base_time" is in the past, and I try to add an
"admin" schedule with a "base_time" also in the past. What's the
expected behavior in this case? The text about stopping/starting
applications doesn't seem to apply to the way the tc subsystem interacts
with the applications.

>> 
>>>
>>>>       - SupportedListMax - Maximum supported Admin/Open shed list.
>>>>
>>>> Is there a plan to export these from driver through tc show or such
>>>> command? The reason being, there would be applications developed to
>>>> manage configuration/schedule of TSN nodes that would requires these
>>>> information from the node. So would need a support either in tc or
>>>> some other means to retrieve them from hardware or driver. That is my
>>>> understanding...
>>>>
>> 
>> Hm, now I understamd what you meant here...
>> 
>>>
>>> Not sure what answer you expect to receive for "is there any plan".
>>> You can go ahead and propose something, as long as it is reasonably
>>> useful to have.
>> 
>> ... if this is indeed useful, perhaps one way to do is to add a subcommand
>> to TC_SETUP_QDISC_TAPRIO, so we can retrieve the stats/information we want
>> from the driver. Similar to what cls_flower does.
>> 
>
> What I understand is that there will be some work done to allow auto
> configuration of TSN nodes from user space and that would need access to
> all or some of the above parameters along with tc command to configure
> the same. May be a open source project for this or some custom
> application? Any such projects existing??

Yeah, this is a big missing piece for TSN. I've heard 'netopeer2' and
'sysrepo' mentioned when similar questions were asked, but I have still
to take a look at them and see what's missing. (Or if they are the right
tool for the job)


-- 
Vinicius
