Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664D03D95D7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhG1TGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:06:02 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60122
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhG1TGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:06:01 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 510B23F24B;
        Wed, 28 Jul 2021 19:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627499158;
        bh=PQUntamawrAqnWhjiU0rlzGGWxPZWwUY2WOIj693FUg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=fYvDWd93la4Wrpk7uyEdEMZR9Brolozl+6hAmG7NbI8k6jciEsQEZhzXK8KZBp4AW
         d6tmU2C2vFlCD3btwJgTeZBL/9EBbk2aEKWJU+U3UFfG1iGYGVjbpT/hTa9RO8jGwl
         2S+QNICH0rSC9tEdZTVw6nn6T7MQzGZhACHgofGXbuwMFvcr/iY+WjUnAOkYXKceRg
         QksUBRg5bI04TrA6gQHXwULDNGpnHsQgj6lvSwUnwZrXWthzz1IO1Z4f/ZWKns6nty
         F33cGkg+T9aE4FO4SY5BSLg1PI5R7gY9VlKYtLspiQtcah8An6WwuCE/3fe4DTCx1Y
         E6Y8ZgT7d9pHQ==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 815E35FBC4; Wed, 28 Jul 2021 12:05:44 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7A2ED9FAC3;
        Wed, 28 Jul 2021 12:05:44 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
cc:     Yufeng Mo <moyufeng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, jiri@resnulli.us, netdev@vger.kernel.org,
        shenjian15@huawei.com, lipeng321@huawei.com,
        yisen.zhuang@huawei.com, linyunsheng@huawei.com,
        zhangjiaran@huawei.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, salil.mehta@huawei.com,
        linuxarm@huawei.com, linuxarm@openeuler.org
Subject: Re: [PATCH net-next] bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
In-reply-to: <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com>
References: <1627453192-54463-1-git-send-email-moyufeng@huawei.com> <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com>
Comments: In-reply-to Nikolay Aleksandrov <nikolay@nvidia.com>
   message dated "Wed, 28 Jul 2021 10:34:35 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3525.1627499144.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 28 Jul 2021 12:05:44 -0700
Message-ID: <3528.1627499144@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <nikolay@nvidia.com> wrote:

>On 28/07/2021 09:19, Yufeng Mo wrote:
>> Some time ago, I reported a calltrace issue
>> "did not find a suitable aggregator", please see[1].
>> After a period of analysis and reproduction, I find
>> that this problem is caused by concurrency.
>> =

>> Before the problem occurs, the bond structure is like follows:
>> =

>> bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>>                       \
>>                         port0
>>       \
>>         slaver1(eth1) - agg1.lag_ports -> NULL
>>                       \
>>                         port1
>> =

>> If we run 'ifenslave bond0 -d eth1', the process is like below:
>> =

>> excuting __bond_release_one()
>> |
>> bond_upper_dev_unlink()[step1]
>> |                       |                       |
>> |                       |                       bond_3ad_lacpdu_recv()
>> |                       |                       ->bond_3ad_rx_indicatio=
n()
>> |                       |                       spin_lock_bh()
>> |                       |                       ->ad_rx_machine()
>> |                       |                       ->__record_pdu()[step2]
>> |                       |                       spin_unlock_bh()
>> |                       |                       |
>> |                       bond_3ad_state_machine_handler()
>> |                       spin_lock_bh()
>> |                       ->ad_port_selection_logic()
>> |                       ->try to find free aggregator[step3]
>> |                       ->try to find suitable aggregator[step4]
>> |                       ->did not find a suitable aggregator[step5]
>> |                       spin_unlock_bh()
>> |                       |
>> |                       |
>> bond_3ad_unbind_slave() |
>> spin_lock_bh()
>> spin_unlock_bh()
>> =

>> step1: already removed slaver1(eth1) from list, but port1 remains
>> step2: receive a lacpdu and update port0
>> step3: port0 will be removed from agg0.lag_ports. The struct is
>>        "agg0.lag_ports -> port1" now, and agg0 is not free. At the
>> 	   same time, slaver1/agg1 has been removed from the list by step1.
>> 	   So we can't find a free aggregator now.
>> step4: can't find suitable aggregator because of step2
>> step5: cause a calltrace since port->aggregator is NULL
>> =

>> To solve this concurrency problem, the range of bond->mode_lock
>> is extended from only bond_3ad_unbind_slave() to both
>> bond_upper_dev_unlink() and bond_3ad_unbind_slave().
>> =

>> [1]https://lore.kernel.org/netdev/10374.1611947473@famine/
>> =

>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> ---
>>  drivers/net/bonding/bond_3ad.c  | 7 +------
>>  drivers/net/bonding/bond_main.c | 6 +++++-
>>  2 files changed, 6 insertions(+), 7 deletions(-)
>> =

>[snip]
>>  /**
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond=
_main.c
>> index 0ff7567..deb019e 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -2129,14 +2129,18 @@ static int __bond_release_one(struct net_device=
 *bond_dev,
>>  	/* recompute stats just before removing the slave */
>>  	bond_get_stats(bond->dev, &bond->bond_stats);
>>  =

>> -	bond_upper_dev_unlink(bond, slave);
>>  	/* unregister rx_handler early so bond_handle_frame wouldn't be calle=
d
>>  	 * for this slave anymore.
>>  	 */
>>  	netdev_rx_handler_unregister(slave_dev);
>>  =

>> +	/* Sync against bond_3ad_state_machine_handler() */
>> +	spin_lock_bh(&bond->mode_lock);
>> +	bond_upper_dev_unlink(bond, slave);
>
>this calls netdev_upper_dev_unlink() which calls call_netdevice_notifiers=
_info() for
>NETDEV_PRECHANGEUPPER and NETDEV_CHANGEUPPER, both of which are allowed t=
o sleep so you
>cannot hold the mode lock

	Indeed it does, I missed that the callbacks can sleep.

>after netdev_rx_handler_unregister() the bond's recv_probe cannot be exec=
uted
>so you don't really need to unlink it under mode_lock or move mode_lock a=
t all

	I don't think moving the call to netdev_rx_handler_unregister is
sufficient to close the race.  If it's moved above the call to
bond_upper_dev_unlink, the probe won't be called afterwards, but the
LACPDU could have arrived just prior to the unregister and changed the
port state in the bond_3ad_lacpdu_recv call sequence ("step 2",
something in the LACPDU causes AD_PORT_SELECTED to be cleared).  Later,
bond_3ad_state_machine_handler runs in a separate work queue context,
and could process the effect of the LACPDU after the rx_handler
unregister, and still race with the upper_dev_unlink.

	I suspect the solution is to rework ad_port_selection_logic to
correctly handle the situation where no aggregator is available.  Off
the top of my head, I think something along the lines of:

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad=
.c
index 6908822d9773..eb6223e4510e 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1537,6 +1537,10 @@ static void ad_port_selection_logic(struct port *po=
rt, bool *update_slave_arr)
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
+			aggregator =3D __get_first_agg(port);
+			ad_agg_selection_logic(aggregator, update_slave_arr);
+
+			return;
 		}
 	}
 	/* if all aggregator's ports are READY_N =3D=3D TRUE, set ready=3DTRUE

	I've not compiled or tested this, but the theory is that it will
reselect a new aggregator for the bond (which happens anyway later in
the function), then returns, leaving "port" as not AD_PORT_SELECTED.
The next run of the state machine should attempt to select it again, and
presumably succeed at that time.

	This may leave the bond with no active ports for one interval
between runs of the state machine, unfortunately, but it should
eliminate the panic.

	Another possibility might be netdev_rx_handler_unregister, then
bond_3ad_unbind_slave, and finally bond_upper_dev_unlink, but I'm not
sure right off if that would have other side effects.

	Yufeng, would you be able to test the above and see if it
resolves the issue in your test?

	-J


>>  	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD)
>>  		bond_3ad_unbind_slave(slave);
>> +	spin_unlock_bh(&bond->mode_lock);
>>  =

>>  	if (bond_mode_can_use_xmit_hash(bond))
>>  		bond_update_slave_arr(bond, slave);
>> =

>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
