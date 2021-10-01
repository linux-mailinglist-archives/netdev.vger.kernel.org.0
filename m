Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BA41F2E1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbhJARTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:19:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:16776 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhJARS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 13:18:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="223599967"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="223599967"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:13:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="619277115"
Received: from unknown (HELO vcostago-mobl3) ([10.134.46.83])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:13:45 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
In-Reply-To: <20211001161710.2sdz6o6lh3yg7k6p@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20211001161710.2sdz6o6lh3yg7k6p@skbuf>
Date:   Fri, 01 Oct 2021 10:13:44 -0700
Message-ID: <87pmsofz1z.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Hi Vinicius,
>
> On Wed, Sep 29, 2021 at 10:25:58AM +0000, Xiaoliang Yang wrote:
>> Hi Vinicius,
>>
>> On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
>> > > This patch introduce a frer action to implement frame replication and
>> > > elimination for reliability, which is defined in IEEE P802.1CB.
>> > >
>> >
>> > An action seems, to me, a bit too limiting/fine grained for a frame replication
>> > and elimination feature.
>> >
>> > At least I want to hear the reasons that the current hsr/prp support cannot be
>> > extended to support one more tag format/protocol.
>> >
>> > And the current name for the spec is IEEE 802.1CB-2017.
>> >
>> 802.1CB can be set on bridge ports, and need to use bridge forward
>> Function as a relay system. It only works on identified streams,
>> unrecognized flows still need to pass through the bridged network
>> normally.
>>
>> But current hsr/prp seems only support two ports, and cannot use the
>> ports in bridge. It's hard to implement FRER functions on current HSR
>> driver.
>>
>> You can see chapter "D.2 Example 2: Various stack positions" in IEEE 802.1CB-2017,
>> Protocol stack for relay system is like follows:
>>
>>              Stream Transfer Function
>>                 |             |
>>                 |        Sequence generation
>>                 |            Sequence encode/decode
>>   Stream identification        Active Stream identification
>>                 |              |
>>                 |        Internal LAN---- Relay system forwarding
>>                 |                        |        |
>>                 MAC                    MAC        MAC
>>
>> Use port actions to easily implement FRER tag add/delete, split, and
>> recover functions.
>>
>> Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
>> Action to be used for stream RTAG/HSR/PRP set and recover.
>
> Did Xiaoliang answer your question satisfactorily? :)

Oh, yes, the answer was very good. I was taking some time to read the
802.1CB spec, and try to think how things would fit together so I can
ask better questions next time :-)


Cheers,
-- 
Vinicius
