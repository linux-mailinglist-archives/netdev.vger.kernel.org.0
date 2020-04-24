Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6C1B7D27
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 19:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgDXRlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 13:41:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:34773 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgDXRla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 13:41:30 -0400
IronPort-SDR: rzc0LJ4Sq9pbdVUkLzZolbVl0GQ/g+d7MuPuA23Tly9+xnxkJaIPWA4aSOBCFYvulF5PBqMYom
 dM7xy9lc2nCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 10:41:29 -0700
IronPort-SDR: f4RRp7WWJttbUvgxw/9UbApYxaL50ZANvd/0c2wTkhy44+grzEtlQjgdh6D3EnkBa2JITfHCMy
 lZukeMoNSHNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457998026"
Received: from unknown (HELO ellie) ([10.212.255.230])
  by fmsmga006.fm.intel.com with ESMTP; 24 Apr 2020 10:41:28 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan\@broadcom.com" <michael.chan@broadcom.com>,
        "vishal\@chelsio.com" <vishal@chelsio.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "idosch\@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni\@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver\@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "moshe\@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2\@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes\@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
In-Reply-To: <VE1PR04MB6496B9EA946877FB473E5D7892D00@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com> <20200422024852.23224-2-Po.Liu@nxp.com> <878sim2jcs.fsf@intel.com> <VE1PR04MB6496B9EA946877FB473E5D7892D00@VE1PR04MB6496.eurprd04.prod.outlook.com>
Date:   Fri, 24 Apr 2020 10:41:28 -0700
Message-ID: <874kt83ho7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Po Liu <po.liu@nxp.com> writes:

>> 
>> One idea that just happened, if you find a way to enable RX timestamping
>> and can rely that all packets have a timestamp, the code can simplified a
>> lot. You wouldn't need any hrtimers, and deciding to drop or not a packet
>> becomes a couple of mathematical operations. Seems worth a thought.
>
> Thanks for the different ideas. The basic problem is we need to know
> now is a close time or open time in action. But I still don't know a
> better way than hrtimer to set the flag.

That's the point, if you have the timestamp of when the packet arrived,
you can calculate if the gate is open and closed at that point. You
don't need to know "now", you work only in terms of "skb->tstamp"
(supposing that's where the timestamp is stored). In other words, it
doesn't matter when the packet arrives at the qdisc action, but when it
arrived at the controller, and the actions should be taken based on that
time.

>
>> 
>> The real question is: if requiring for the driver to support at least software
>> RX timestamping is excessive (doesn't seem so to me).
>
> I understand.
>
>> 
>> 
>> Cheers,
>> --
>> Vinicius
>
> Thanks a lot!
>
> Br,
> Po Liu

-- 
Vinicius
