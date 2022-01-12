Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89B948C96C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348571AbiALRcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:32:12 -0500
Received: from 5.mo548.mail-out.ovh.net ([188.165.49.213]:36415 "EHLO
        5.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiALRcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:32:09 -0500
Received: from mxplan1.mail.ovh.net (unknown [10.108.20.243])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id DAC4A216D4;
        Wed, 12 Jan 2022 17:32:06 +0000 (UTC)
Received: from bracey.fi (37.59.142.100) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 12 Jan
 2022 18:32:03 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-100R003e5bb13a0-636c-4e17-a0a4-b729bd790f18,
                    9C4ECD095E6EB6DE56D124D498B9B7C748136B87) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
Message-ID: <00960549-3a4a-abe3-0a28-ab866a7dbe97@bracey.fi>
Date:   Wed, 12 Jan 2022 19:31:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net_sched: restore "mpu xxx" handling
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
References: <20220112170210.1014351-1-kevin@bracey.fi>
 <CANn89iJiAGD11qe9edmzsf0Sf9Wb7nc6o6zscO=4KOwkRv1gRQ@mail.gmail.com>
From:   Kevin Bracey <kevin@bracey.fi>
In-Reply-To: <CANn89iJiAGD11qe9edmzsf0Sf9Wb7nc6o6zscO=4KOwkRv1gRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG5EX2.mxp1.local (172.16.2.10) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: a0b30db0-96fb-4589-9875-91e70ad7d84f
X-Ovh-Tracer-Id: 1195142753781256355
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrtddugdejjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgihesthejredttdefjeenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepgfffuefgueetveeuuedtheeihffgiedvgeegueehgfffteeifeegtdejhfelhfeinecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdpnhgspghrtghpthhtohepuddprhgtphhtthhopehjrdhvihhmrghlsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2022 19:08, Eric Dumazet wrote:
> On Wed, Jan 12, 2022 at 9:02 AM Kevin Bracey <kevin@bracey.fi> wrote:
>> commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
>> "overhead X", "linklayer atm" and "mpu X" attributes.
> Thanks for the nice changelog.
>
> I do have a question related to HTB offload.
>
> Is this mpu attribute considered there ?

I had not considered that. None of these 3 adjustment parameters are 
passed to its setup - tc_htb_qopt_offload merely contains u64 rate and ceil.

Dealing with that looks like it might be a bit fiddly. htb_change_class 
would need reordering. It appears the software case permits parameter 
changing and it is ordered on that basis, but the offload locks in 
parameters on creation.

But in principle, tc_htb_qopt_offload could contain a pair of 
psched_ratecfg rather than a pair of u64s, and then offload would have 
all the adjustment information.


