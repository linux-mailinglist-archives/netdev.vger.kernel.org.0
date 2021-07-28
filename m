Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D6A3D9641
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhG1T54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:57:56 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35772
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhG1T5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:57:55 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 147423F230;
        Wed, 28 Jul 2021 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627502272;
        bh=9XhWFj3iXsaa9GL8FuzchKBNR6WD5Sa8tvIQxzDCL5s=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=SHN54Y2S9cVBr2IPNhwGKiToxykxNuLIdzSDUAFUs8GZwrwCXxf/euQC9/UBM2EqM
         hRjpEzMV/QSukHXKQQgrVGf8cGQJhgA2AK6Ge7e4GLa0y2cW3mBcIFxY7OoiBUy6f5
         Da6fgH+5hb5/FYRFFTJQ0GxTRKlUikGqQJGZG3okDWWAYxtIOEw6M72D+JKeshnUgM
         2Zg5QmUCcHz1O1aYsABQROzPxeDkH10HPagkewHUo08FGs/ob11LEYVu6Uh2v0NuTE
         aNgPEx98bQM1TXDoHBf16uRx+KeJ5cmweNn2ADAOYhYlDc1gtnC/faxzUg2TTQXxd4
         OA7uF49OFHwqA==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 32A435FBC4; Wed, 28 Jul 2021 12:57:50 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2A92E9FAC3;
        Wed, 28 Jul 2021 12:57:50 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "zhudi (J)" <zhudi21@huawei.com>
cc:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] bonding: Avoid adding slave devices to inactive bonding
In-reply-to: <a457335cb9a04023808f5b34cd8c1d30@huawei.com>
References: <a457335cb9a04023808f5b34cd8c1d30@huawei.com>
Comments: In-reply-to "zhudi (J)" <zhudi21@huawei.com>
   message dated "Wed, 28 Jul 2021 06:51:55 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5225.1627502270.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 28 Jul 2021 12:57:50 -0700
Message-ID: <5226.1627502270@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhudi (J) <zhudi21@huawei.com> wrote:

>> zhudi <zhudi21@huawei.com> wrote:
>> =

>> >We need to refuse to add slave devices to the bonding which does
>> >not set IFF_UP flag, otherwise some problems will be caused(such as
>> >bond_set_carrier() will not sync carrier state to upper net device).
>> >The ifenslave command can prevent such use case, but through the sysfs
>> >interface, slave devices can still be added regardless of whether
>> >the bonding is set with IFF_UP flag or not.
>> =

>> 	What specifically happens in the carrier state issue you
>> mention?  Are there other specific issues?
>
>yes, The following steps can cause problems:
>	1)bond0 is down
>	2) ip link add link bond0 name ipvlan type ipvlan mode l2
>	3) echo +enp2s7 >/sys/class/net/bond0/bonding/slaves
>	4) ip link set bond0 up
>
>	After these steps, use ip link command, we found ipvlan has NO-CARRIER:
>		ipvlan@bond0: <NO-CARRIER, BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdis=
c noqueue state>
>
>	This is because,  bond_enslave()->bond_set_carrier()->netif_carrier_on()=
...->netdev_state_change() =

>will not sync carrier state to ipvlan because the IFF_UP  flag is not set=
.

	Correct, it's not supposed to at the time bond_enslave is called
(because the bond is down at that time).  Later, when the bond is set
link up, NETDEV_UP and NETDEV_CHANGE netdevice events are issued, and
devices logically stacked above the bond can receive a notification at
that time.  This is what, e.g., VLAN does, in vlan_device_event,
ultimately by calling netif_stacked_transfer_operstate if I'm following
the code correctly.

	Looking at ipvlan, it does register for netdevice events
(ipvlan_device_event) but doesn't appear to handle events for the device
it is linked to.

>> 	As far as I can recall, adding interfaces to the bond while the
>> bond is down has worked for a very long time, so I'm concerned that
>> disabling that functionality will have impact on existing
>> configurations.
>> =

>> 	Also, to the best of my knowledge, the currently packaged
>> ifenslave programs are scripts that utilize the sysfs interface.  I'm
>> unaware of current usage of the old C ifenslave program (removed from
>> the kernel source in 2013), although the kernel code should still
>> support it.
>
>	We still use old ifenslave command and it  does only allow to add slave =
to bonding with up state, code is as follows:
>
>	/* check if master is up; if not then fail any operation */
>	if (!(master_flags.ifr_flags & IFF_UP)) {
>		fprintf(stderr,
>			"Illegal operation; the specified master interface "
>			"'%s' is not up.\n",
>			master_ifname);
>		res =3D 1;
>		goto out;
>	}
>
>	If so, the behavior of the new tool is inconsistent with that of the old=
 tool.

	This restriction in ifenslave.c dates to 15-20 years ago, when
(as I recall) the master->slave infrastructure in the kernel could not
handle such linking while the interface was down.  Another side effect
at the time was that setting a bond down would release all slaves.

	In any event, the old ifenslave.c is not the standard by which
we set the behavior of the driver.  It is obsolete and no longer
developed or distributed upstream.

	-J

>> >So we introduce a new BOND_OPTFLAG_IFUP flag to avoid adding slave
>> >devices to inactive bonding.
>> >
>> >Signed-off-by: zhudi <zhudi21@huawei.com>
>> >---
>> > drivers/net/bonding/bond_options.c | 4 +++-
>> > include/net/bond_options.h         | 4 +++-
>> > 2 files changed, 6 insertions(+), 2 deletions(-)
>> >
>> >diff --git a/drivers/net/bonding/bond_options.c
>> b/drivers/net/bonding/bond_options.c
>> >index 0cf25de6f46d..6d2f44b3528d 100644
>> >--- a/drivers/net/bonding/bond_options.c
>> >+++ b/drivers/net/bonding/bond_options.c
>> >@@ -387,7 +387,7 @@ static const struct bond_option
>> bond_opts[BOND_OPT_LAST] =3D {
>> > 		.id =3D BOND_OPT_SLAVES,
>> > 		.name =3D "slaves",
>> > 		.desc =3D "Slave membership management",
>> >-		.flags =3D BOND_OPTFLAG_RAWVAL,
>> >+		.flags =3D BOND_OPTFLAG_RAWVAL | BOND_OPTFLAG_IFUP,
>> > 		.set =3D bond_option_slaves_set
>> > 	},
>> > 	[BOND_OPT_TLB_DYNAMIC_LB] =3D {
>> >@@ -583,6 +583,8 @@ static int bond_opt_check_deps(struct bonding
>> *bond,
>> > 		return -ENOTEMPTY;
>> > 	if ((opt->flags & BOND_OPTFLAG_IFDOWN) && (bond->dev->flags &
>> IFF_UP))
>> > 		return -EBUSY;
>> >+	if ((opt->flags & BOND_OPTFLAG_IFUP) && !(bond->dev->flags &
>> IFF_UP))
>> >+		return -EPERM;
>> >
>> > 	return 0;
>> > }
>> >diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>> >index 9d382f2f0bc5..742f5cc81adf 100644
>> >--- a/include/net/bond_options.h
>> >+++ b/include/net/bond_options.h
>> >@@ -15,11 +15,13 @@
>> >  * BOND_OPTFLAG_NOSLAVES - check if the bond device is empty before
>> setting
>> >  * BOND_OPTFLAG_IFDOWN - check if the bond device is down before
>> setting
>> >  * BOND_OPTFLAG_RAWVAL - the option parses the value itself
>> >+ * BOND_OPTFLAG_IFUP - check if the bond device is up before setting
>> >  */
>> > enum {
>> > 	BOND_OPTFLAG_NOSLAVES	=3D BIT(0),
>> > 	BOND_OPTFLAG_IFDOWN	=3D BIT(1),
>> >-	BOND_OPTFLAG_RAWVAL	=3D BIT(2)
>> >+	BOND_OPTFLAG_RAWVAL	=3D BIT(2),
>> >+	BOND_OPTFLAG_IFUP	=3D BIT(3)
>> > };
>> >
>> > /* Value type flags:
>> >--
>> >2.27.0
>> >

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
