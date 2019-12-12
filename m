Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4170911C606
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 07:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfLLGjL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Dec 2019 01:39:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40389 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfLLGjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 01:39:11 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ifI6y-0003S6-Js; Thu, 12 Dec 2019 06:38:09 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id E05596C567; Wed, 11 Dec 2019 22:38:06 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D8973AC1CC;
        Wed, 11 Dec 2019 22:38:06 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     =?us-ascii?Q?=3D=3FUTF-8=3FB=3FTWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLY?=
         =?us-ascii?Q?g4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ=3D=3D=3F=3D?= 
        <maheshb@google.com>
cc:     Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
In-reply-to: <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
References: <20191206234455.213159-1-maheshb@google.com> <10902.1575756592@famine> <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
Comments: In-reply-to =?us-ascii?Q?=3D=3FUTF-8=3FB=3FTWFoZXNoIEJhbmRld2FyI?=
 =?us-ascii?Q?CjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ=3D=3D=3F?=
 =?us-ascii?Q?=3D?= <maheshb@google.com>
   message dated "Mon, 09 Dec 2019 10:41:28 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Wed, 11 Dec 2019 22:38:06 -0800
Message-ID: <26918.1576132686@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mahesh Bandewar (महेश बंडेवार) wrote:

>On Sat, Dec 7, 2019 at 2:09 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>>
>> Mahesh Bandewar <maheshb@google.com> wrote:
>>
>> >After the recent fix 1899bb325149 ("bonding: fix state transition
>> >issue in link monitoring"), the active-backup mode with miimon
>> >initially come-up fine but after a link-failure, both members
>> >transition into backup state.
>> >
>> >Following steps to reproduce the scenario (eth1 and eth2 are the
>> >slaves of the bond):
>> >
>> >    ip link set eth1 up
>> >    ip link set eth2 down
>> >    sleep 1
>> >    ip link set eth2 up
>> >    ip link set eth1 down
>> >    cat /sys/class/net/eth1/bonding_slave/state
>> >    cat /sys/class/net/eth2/bonding_slave/state
>> >
>> >Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
>> >CC: Jay Vosburgh <jay.vosburgh@canonical.com>
>> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>> >---
>> > drivers/net/bonding/bond_main.c | 3 ---
>> > 1 file changed, 3 deletions(-)
>> >
>> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> >index fcb7c2f7f001..ad9906c102b4 100644
>> >--- a/drivers/net/bonding/bond_main.c
>> >+++ b/drivers/net/bonding/bond_main.c
>> >@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *bond)
>> >                       } else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
>> >                               /* make it immediately active */
>> >                               bond_set_active_slave(slave);
>> >-                      } else if (slave != primary) {
>> >-                              /* prevent it from being the active one */
>> >-                              bond_set_backup_slave(slave);
>>
>>         How does this fix things?  Doesn't bond_select_active_slave() ->
>> bond_change_active_slave() set the backup flag correctly via a call to
>> bond_set_slave_active_flags() when it sets a slave to be the active
>> slave?  If this change resolves the problem, I'm not sure how this ever
>> worked correctly, even prior to 1899bb325149.
>>
>Hi Jay, I used kprobes to figure out the brokenness this patch fixes.
>Prior to your patch this call would not happen but with the patch,
>this extra call will put the master into the backup mode erroneously
>(in fact both members would be in backup state). The mechanics you
>have mentioned works correctly except that in the prior case, the
>switch statement was using new_link which was not same as
>link_new_state. The miimon_inspect will update new_link which is what
>was used in miimon_commit code. The link_new_state was used only to
>mitigate the rtnl-lock issue which would update the "link". Hence in
>the prior code, this path would never get executed.

	I'm looking at the old code (prior to 1899bb325149), and I don't
see a path to what you're describing for the down to up transition in
active-backup mode.

bond_miimon_inspect enters switch, slave->link == BOND_LINK_DOWN.

link_state is nonzero, call bond_propose_link_state(BOND_LINK_BACK),
which sets slave->link_new_state to _BACK.

Fall through to BOND_LINK_BACK case, set slave->new_link = BOND_LINK_UP

bond_mii_monitor then calls bond_commit_link_state, which sets
slave->link to BOND_LINK_BACK

Enter bond_miimon_commit switch (new_link), which is BOND_LINK_UP

In "case BOND_LINK_UP:" there is no way out of this block, and it should
proceed to call bond_set_backup_slave for active-backup mode every time.

>The steps to reproduce this issue is straightforward and happens 100%
>of the time (I used two mlx interfaces but that shouldn't matter).

	Yes, I've been able to reproduce it locally (with igb, FWIW).  I
think the patch is likely ok, I'm just mystified as to how the backup
setting could have worked prior to 1899bb325149, so perhaps the Fixes
tag doesn't go back far enough.

	-J

>thanks,
>--mahesh..
>>         -J
>>
>> >                       }
>> >
>> >                       slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
>> >--
>> >2.24.0.393.g34dc348eaf-goog

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
