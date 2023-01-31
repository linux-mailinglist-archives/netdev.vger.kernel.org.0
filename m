Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869AB683254
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjAaQOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjAaQOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:14:04 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1B7734C22;
        Tue, 31 Jan 2023 08:14:02 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id C21F346273;
        Tue, 31 Jan 2023 18:14:00 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 60E0646272;
        Tue, 31 Jan 2023 18:13:59 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id B508C3C0444;
        Tue, 31 Jan 2023 18:13:53 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 30VGDoXD056863;
        Tue, 31 Jan 2023 18:13:52 +0200
Date:   Tue, 31 Jan 2023 18:13:50 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
cc:     Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [Question] neighbor entry doesn't switch to the STALE state
 after the reachable timer expires
In-Reply-To: <1252089d-75db-a45c-d735-6883c772d95a@huawei.com>
Message-ID: <d95e4afc-3a95-a3a7-edd9-1bd13cdec90@ssi.bg>
References: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com> <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg> <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com> <9ac5f4f6-36cc-cc6b-1220-f45db141656c@ssi.bg> <1252089d-75db-a45c-d735-6883c772d95a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 31 Jan 2023, Zhang Changzhong wrote:

> Thanks for your fix!
> 
> I reproduced this problem by directly modifying the confirmed time of
> the neigh entry in STALE state. Your change can fix the problem in this
> scenario.

	I'm glad that you have a way to test it :) Thanks!

> Just curious, why did you choose 'jiffies - MAX_JIFFY_OFFSET + 86400 * HZ'
> as the value of 'mint'?

	It is too arbitrary :) Probably, just 'jiffies - MAX_JIFFY_OFFSET'
is enough or something depending on HZ/USER_HZ. I added 1 day for
timer to advance without leaving confirmed time behind the
jiffies - MAX_JIFFY_OFFSET zone but it is not needed.

	What limits play here:

- the HZ/USER_HZ difference: jiffies_to_clock_t reports the 3 times
to user space, so we want to display values as large as possible.
Any HZ > 100 for USER_HZ=100 works for the jiffies - MAX_JIFFY_OFFSET.
HZ=100 does not work.

- users can use large values for sysctl vars which can keep the timer
running for long time and reach some outdated confirmed time
before neigh_add_timer() is called to correct it

	If we choose mint = jiffies - MAX_JIFFY_OFFSET,
for 32-bit we will have:

Past                     Future
++++++++++++++++++++++++++++++++++++++++++++++++++++
|  49  days   |  49 days  |         99 days        |
++++++++++++++^+++++++++++^+++++++++++++++++++++++++
              ^           ^
DELAY+PROBE   |           |
            mint         now

- used/confirmed times should be up to 49 days behind jiffies but
we have 49 days to stay in timer without correcting them,
so they can go up to 99 days in the past before going in
the future and trigger the problem

- as we avoid the checks in neigh_timer_handler to save CPU cycles,
one needs crazy sysctl settings to keep the timer in DELAY+PROBE
states for 49 days. With default settings, it is no more than
half minute. In this case even
mint = jiffies - LONG_MAX + 86400 * HZ should work.

- REACHABLE state extends while confirmed time advances,
otherwise PROBE will need ARP reply to recheck the
times in neigh_add_timer while entering REACHABLE again

Regards

--
Julian Anastasov <ja@ssi.bg>

