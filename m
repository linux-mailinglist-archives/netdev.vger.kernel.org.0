Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32562CCB0E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLCAkE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 19:40:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60192 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgLCAkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:40:04 -0500
Received: from 1.general.jvosburgh.uk.vpn ([10.172.196.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kkceR-0006TK-L3; Thu, 03 Dec 2020 00:39:16 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2F9365FEE8; Wed,  2 Dec 2020 16:39:14 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 27C7B9FAB0;
        Wed,  2 Dec 2020 16:39:14 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/4] net: bonding: Notify ports about their initial state
In-reply-to: <87h7p37u4t.fsf@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-2-tobias@waldekranz.com> <17902.1606936179@famine> <87h7p37u4t.fsf@waldekranz.com>
Comments: In-reply-to Tobias Waldekranz <tobias@waldekranz.com>
   message dated "Wed, 02 Dec 2020 22:52:50 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <458.1606955954.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 02 Dec 2020 16:39:14 -0800
Message-ID: <459.1606955954@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tobias Waldekranz <tobias@waldekranz.com> wrote:

>On Wed, Dec 02, 2020 at 11:09, Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>
>>>When creating a static bond (e.g. balance-xor), all ports will always
>>>be enabled. This is set, and the corresponding notification is sent
>>>out, before the port is linked to the bond upper.
>>>
>>>In the offloaded case, this ordering is hard to deal with.
>>>
>>>The lower will first see a notification that it can not associate with
>>>any bond. Then the bond is joined. After that point no more
>>>notifications are sent, so all ports remain disabled.
>>>
>>>This change simply sends an extra notification once the port has been
>>>linked to the upper to synchronize the initial state.
>>
>> 	I'm not objecting to this per se, but looking at team and
>> net_failover (failover_slave_register), those drivers do not send the
>> same first notification that bonding does (the "can not associate" one),
>> but only send a notification after netdev_master_upper_dev_link is
>> complete.
>>
>> 	Does it therefore make more sense to move the existing
>> notification within bonding to take place after the upper_dev_link
>> (where you're adding this new call to bond_lower_state_changed)?  If the
>> existing notification is effectively useless, this would make the
>> sequence of notifications consistent across drivers.
>
>From my point of view that makes more sense. I just assumed that the
>current implementation was done this way for a reason. Therefore I opted
>for a simple extension instead.

	I suspect the current implementation's ordering is more a side
effect of how the function was structured initially, and the
notifications were added later without giving thought to the ordering of
those events.

>I could look at hoisting up the linking op before the first
>notification. My main concern is that this is a new subsystem to me, so
>I am not sure how to determine the adequate test coverage for a change
>like this.
>
>Another option would be to drop this change from this series and do it
>separately. It would be nice to have both team and bond working though.
>
>Not sure why I am the first to run into this. Presumably the mlxsw LAG
>offloading would be affected in the same way. Maybe their main use-case
>is LACP.

	I'm not sure about mlxsw specifically, but in the configurations
I see, LACP is by far the most commonly used mode, with active-backup a
distant second.  I can't recall the last time I saw a production
environment using balance-xor.

	I think that in the perfect world there should be exactly one
such notification, and occurring in the proper sequence.  A quick look
at the kernel consumers of the NETDEV_CHANGELOWERSTATE event (mlx5,
mlxsw, and nfp, looks like) suggests that those shouldn't have an issue.

	In user space, however, there are daemons that watch the events,
and may rely on the current ordering.  Some poking around reveals odd
bugs in user space when events are rearranged, so I think the prudent
thing is to not mess with what's there now, and just add the one event
here (i.e., apply your patch as-is).

	So, for this bonding change:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
