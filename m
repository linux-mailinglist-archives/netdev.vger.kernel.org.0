Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D748C08C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351831AbiALI6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:58:14 -0500
Received: from 8.mo548.mail-out.ovh.net ([46.105.45.231]:33381 "EHLO
        8.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiALI6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:58:13 -0500
X-Greylist: delayed 6300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 03:58:13 EST
Received: from mxplan1.mail.ovh.net (unknown [10.108.16.235])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id C7F18201E1;
        Wed, 12 Jan 2022 07:03:00 +0000 (UTC)
Received: from bracey.fi (37.59.142.101) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 12 Jan
 2022 08:03:00 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-101G004d60229ce-6e0b-4835-ac3f-5cb9ff21f049,
                    9C4ECD095E6EB6DE56D124D498B9B7C748136B87) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
Message-ID: <a59fc45e-f9c8-91fe-09a2-e47605c4c0c7@bracey.fi>
Date:   Wed, 12 Jan 2022 09:02:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net_sched: restore "mpu xxx" handling
From:   Kevin Bracey <kevin@bracey.fi>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
References: <20220107202249.3812322-1-kevin@bracey.fi>
 <20220111210613.55467734@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <03cc89aa-1837-dacc-29d7-fcf6a5e45284@bracey.fi>
In-Reply-To: <03cc89aa-1837-dacc-29d7-fcf6a5e45284@bracey.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: CAS1.mxp1.local (172.16.1.1) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 4e362924-b4a7-4939-b2fd-ed0d8dd1362b
X-Ovh-Tracer-Id: 9017332356607021219
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudehgedguddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuhffvfhgjtgfgihesthejredttdefjeenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepudehtdduveejgfetjeekfeekudfgteffvddvjeegtdeiieehvedugfelhedvgeeinecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdprhgtphhtthhopehjrdhvihhmrghlsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2022 08:36, Kevin Bracey wrote:
>
> Indeed, There has never been any kernel handling of tc_ratespec::mpu - 
> the kernel merely stored the value.
>
> The overhead had been similarly passed to the kernel but not 
> originally acted on. Linklayer had to be added to tc_ratespec. 

Ah, I need to correct myself there. The overhead was originally acted on 
in qdisc_l2t. htb_l2t forgot to incorporate it.

So:

  * overhead - always passed via tc_ratespec, handled by kernel. HTB
    temporarily ignored it.
  * linklayer - not originally passed via tc_ratespec, but incorporated
    in table. HTB temporarily lost functionality when it stopped using
    table. Later passed via ratespec, or inferred from table analysis
    for old iproute2.
  * mpu - always passed via tc_ratespec, but ignored by kernel.
    Incorporated in table. HTB lost functionality when it stopped using
    table.

("always" meaning "since iproute2 first had the parameter").

So this is a tad different from the other two - those were making the 
kernel act on something it previously acted on. This makes it act on 
something it's always been given, but never acted on. But it restores 
iproute2+kernel system functionality with no userspace change.

Kevin


