Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D5B48BEA5
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 07:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351024AbiALGnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 01:43:13 -0500
Received: from 7.mo552.mail-out.ovh.net ([188.165.59.253]:38657 "EHLO
        7.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbiALGnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 01:43:13 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 01:43:12 EST
Received: from mxplan1.mail.ovh.net (unknown [10.109.156.148])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 4555A22585;
        Wed, 12 Jan 2022 06:36:46 +0000 (UTC)
Received: from bracey.fi (37.59.142.99) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 12 Jan
 2022 07:36:45 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G003d5a8f43c-66d3-4c4a-9991-a8ac86815c59,
                    9C4ECD095E6EB6DE56D124D498B9B7C748136B87) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
Message-ID: <03cc89aa-1837-dacc-29d7-fcf6a5e45284@bracey.fi>
Date:   Wed, 12 Jan 2022 08:36:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net_sched: restore "mpu xxx" handling
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
References: <20220107202249.3812322-1-kevin@bracey.fi>
 <20220111210613.55467734@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Kevin Bracey <kevin@bracey.fi>
In-Reply-To: <20220111210613.55467734@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG5EX1.mxp1.local (172.16.2.9) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: d47f6d19-eda5-40b6-bd05-831b476f8246
X-Ovh-Tracer-Id: 8574290742286389411
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudehgedgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpefmvghvihhnuceurhgrtggvhicuoehkvghvihhnsegsrhgrtggvhidrfhhiqeenucggtffrrghtthgvrhhnpefgffeugfeuteevueeutdehiefhgfeivdeggeeuhefgffetieefgedtjefhlefhieenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdprhgtphhtthhopehjrdhvihhmrghlsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2022 07:06, Jakub Kicinski wrote:
> On Fri, 7 Jan 2022 22:22:50 +0200 Kevin Bracey wrote:
>> commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
>> "overhead X", "linklayer atm" and "mpu X" attributes.
>>
>> "overhead X" and "linklayer atm" have already been fixed. This restores
>> the "mpu X" handling, as might be used by DOCSIS or Ethernet shaping:
>>
>>      tc class add ... htb rate X overhead 4 mpu 64
>>
>> The code being fixed is used by htb, tbf and act_police. Cake has its
>> own mpu handling. qdisc_calculate_pkt_len still uses the size table
>> containing values adjusted for mpu by user space.
>>
>> Fixes: 56b765b79e9a ("htb: improved accuracy at high rates")
> Are you sure this worked and got broken? I can't seem to grep out any
> uses of mpu in this code. commit 175f9c1bba9b ("net_sched: Add size
> table for qdiscs") adds it as part of the struct but I can't find a
> single use of it.

Indeed, There has never been any kernel handling of tc_ratespec::mpu - 
the kernel merely stored the value.

But the system functionality worked because the length-to-time that tc 
passed to TCA_HTB_RTAB was based on the mpu value.

Since 56b765b79e9a ("htb: improved accuracy at high rates"), the table 
has been ignored, and the kernel has done its own immediate calculations.

So this would be the first time the kernel itself has acted on the 
tc_ratespec::mpu value. But it echoes the changes made in 01cb71d2d47b 
("net_sched: restore "overhead xxx" handling") and 8a8e3d84b171 
("net_sched: restore "linklayer atm" handling")

The overhead had been similarly passed to the kernel but not originally 
acted on. Linklayer had to be added to tc_ratespec.

I noticed this because I'd been messing with the htbs on a 2.6.26-based 
router, and when I migrated to a 4.1-based one it was obvious the mpu 
values set in tc weren't sticking. Inspection showed that not only was 
the kernel not storing them, it wasn't any longer using the table based 
on them, so they were ineffective.

Kevin


