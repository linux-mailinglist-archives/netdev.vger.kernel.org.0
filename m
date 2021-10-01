Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D64D41F311
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355341AbhJAR27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:28:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:50616 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355262AbhJAR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 13:28:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="311051743"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="311051743"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:27:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="521239016"
Received: from unknown (HELO vcostago-mobl3) ([10.134.46.83])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:27:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: RE: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
In-Reply-To: <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
Date:   Fri, 01 Oct 2021 10:27:12 -0700
Message-ID: <87lf3cfyfj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaoliang Yang <xiaoliang.yang_1@nxp.com> writes:

> Hi Vinicius,
>
> On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
>> > This patch introduce a frer action to implement frame replication and
>> > elimination for reliability, which is defined in IEEE P802.1CB.
>> >
>> 
>> An action seems, to me, a bit too limiting/fine grained for a frame replication
>> and elimination feature.
>> 
>> At least I want to hear the reasons that the current hsr/prp support cannot be
>> extended to support one more tag format/protocol.
>> 
>> And the current name for the spec is IEEE 802.1CB-2017.
>> 
> 802.1CB can be set on bridge ports, and need to use bridge forward
> Function as a relay system. It only works on identified streams,
> unrecognized flows still need to pass through the bridged network
> normally.

This ("only on identified streams") is the strongest argument so far to
have FRER also as an action, in adition to the current hsr netdevice
approach.

>
> But current hsr/prp seems only support two ports, and cannot use the
> ports in bridge. It's hard to implement FRER functions on current HSR
> driver.

That the hsr netdevice only support two ports, I think is more a bug
than a design issue. Which will need to get fixed at some point. 

Speaking of functions, one thing that might be interesting is trying to
see if it makes sense to make part of the current hsr functionality a
"library" so it can be used by tc-frer as well. (less duplication of
bugs).

>
> You can see chapter "D.2 Example 2: Various stack positions" in IEEE 802.1CB-2017,
> Protocol stack for relay system is like follows:
>
>              Stream Transfer Function
>                 |             |
>   				|    	Sequence generation
>                 |       	Sequence encode/decode
>   Stream identification		Active Stream identification
> 				|			  |
>   			    |		Internal LAN---- Relay system forwarding
> 				|						|		|
> 				MAC						MAC		MAC
>
> Use port actions to easily implement FRER tag add/delete, split, and
> recover functions.
>
> Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
> Action to be used for stream RTAG/HSR/PRP set and recover.

I am still reading the spec and trying to imagine how things would fit
together:
  - for which use cases tc-frer would be useful;
  - for which use cases the hsr netdevice would be useful;
  - would it make sense to have them in the same system?
  
>
> Thanks,
> Xiaoliang

Cheers,
-- 
Vinicius
