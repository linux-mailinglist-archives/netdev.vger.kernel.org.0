Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA42F417A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbhAMCBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51092 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbhAMCBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:01:41 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kzVSp-0003pl-Sl; Wed, 13 Jan 2021 02:00:48 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2CCFB5FEE8; Tue, 12 Jan 2021 18:00:46 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 26C129FAB0;
        Tue, 12 Jan 2021 18:00:46 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Saeed Mahameed <saeed@kernel.org>
cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH v6 net-next 14/15] net: bonding: ensure .ndo_get_stats64 can sleep
In-reply-to: <4c4c08e37aeff87f0dd2ea52037c32d07d2868d1.camel@kernel.org>
References: <20210109172624.2028156-1-olteanv@gmail.com> <20210109172624.2028156-15-olteanv@gmail.com> <cbead0479ef0b601bada5ae2ad0f8c28e5b242c9.camel@kernel.org> <20210112143710.nxpxnlcojhvqipw7@skbuf> <4c4c08e37aeff87f0dd2ea52037c32d07d2868d1.camel@kernel.org>
Comments: In-reply-to Saeed Mahameed <saeed@kernel.org>
   message dated "Tue, 12 Jan 2021 12:10:38 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8200.1610503246.1@famine>
Date:   Tue, 12 Jan 2021 18:00:46 -0800
Message-ID: <8201.1610503246@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed <saeed@kernel.org> wrote:

>On Tue, 2021-01-12 at 16:37 +0200, Vladimir Oltean wrote:
>> On Mon, Jan 11, 2021 at 03:38:49PM -0800, Saeed Mahameed wrote:
>> > GFP_ATOMIC is a little bit aggressive especially when user daemons
>> > are
>> > periodically reading stats. This can be avoided.
>> > 
>> > You can pre-allocate with GFP_KERNEL an array with an "approximate"
>> > size.
>> > then fill the array up with whatever slaves the the bond has at
>> > that
>> > moment, num_of_slaves  can be less, equal or more than the array
>> > you
>> > just allocated but we shouldn't care ..
>> > 
>> > something like:
>> > rcu_read_lock()
>> > nslaves = bond_get_num_slaves();
>> > rcu_read_unlock()

	Can be nslaves = READ_ONCE(bond->slave_cnt), or, for just active
slaves:

	struct bond_up_slave *slaves;
	slaves = rcu_dereference(bond->slave_arr);
	nslaves = slaves ? READ_ONCE(slaves->count) : 0;

>> > sarray = kcalloc(nslaves, sizeof(struct bonding_slave_dev),
>> > GFP_KERNEL);
>> > rcu_read_lock();
>> > bond_fill_slaves_array(bond, sarray); // also do: dev_hold()
>> > rcu_read_unlock();
>> > 
>> > 
>> > bond_get_slaves_array_stats(sarray);
>> > 
>> > bond_put_slaves_array(sarray);
>> 
>> I don't know what to say about acquiring RCU read lock twice and
>> traversing the list of interfaces three or four times.
>
>You can optimize this by tracking #num_slaves.

	I think that the set of active slaves changing between the two
calls will be a rare exception, and that the number of slaves is
generally small (more than 2 is uncommon in my experience).

>> On the other hand, what's the worst that can happen if the GFP_ATOMIC
>> memory allocation fails. It's not like there is any data loss.
>> User space will retry when there is less memory pressure.
>
>Anyway Up to you, i just don't like it when we use GFP_ATOMIC when it
>can be avoided, especially for periodic jobs, like stats polling.. 

	And, for the common case, I suspect that an array allocation
will have lower overhead than a loop that allocates once per slave.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
