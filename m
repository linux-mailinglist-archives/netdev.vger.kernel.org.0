Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA59DB7E1F
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391196AbfISP1L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Sep 2019 11:27:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41522 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391130AbfISP1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 11:27:11 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iAyKq-0005A4-1v; Thu, 19 Sep 2019 15:27:08 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id A1C9D2402EB; Thu, 19 Sep 2019 17:27:07 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 975E5289C50;
        Thu, 19 Sep 2019 17:27:07 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI?=
         =?us-ascii?Q?=3D=3F=3D?= <zaharov@selectel.ru>
cc:     netdev@vger.kernel.org
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com> <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
Comments: In-reply-to =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0?=
 =?us-ascii?Q?JfQsNGF0LDRgNC+0LI=3D=3F=3D?= <zaharov@selectel.ru>
   message dated "Thu, 19 Sep 2019 12:53:14 +0300."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Thu, 19 Sep 2019 17:27:07 +0200
Message-ID: <7236.1568906827@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Алексей Захаров wrote:

>чт, 19 сент. 2019 г. в 11:00, Jay Vosburgh <jay.vosburgh@canonical.com>:
>>
>> Алексей Захаров wrote:
>>
>> >> >Once a while, one of 802.3ad slaves fails to initialize and hangs in
>> >> >BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slave
>> >> >link initialization transition states") checks slave->last_link_up. But
>> >> >link can still hang in weird state.
>> >> >After physical link comes up it sends first two LACPDU messages and
>> >> >doesn't work properly after that. It doesn't send or receive LACPDU.
>> >> >Once it happens, the only message in dmesg is:
>> >> >bond1: link status up again after 0 ms for interface eth2
>> >>
>> >>         I believe this message indicates that the slave entered
>> >> BOND_LINK_FAIL state, but downdelay was not set.  The _FAIL state is
>> >> really for managing the downdelay expiration, and a slave should not be
>> >> in that state (outside of a brief transition entirely within
>> >> bond_miimon_inspect) if downdelay is 0.
>> >That's true, downdelay was set to 0, we only use updelay 500.
>> >Does it mean, that the bonding driver shouldn't set slave to FAIL
>> >state in this case?
>>
>>         It really shouldn't change the slave->link outside of the
>> monitoring functions at all, because there are side effects that are not
>> happening (user space notifications, updelay / downdelay, etc).
>>
>> >> >This behavior can be reproduced (not every time):
>> >> >1. Set slave link down
>> >> >2. Wait for 1-3 seconds
>> >> >3. Set slave link up
>> >> >
>> >> >The fix is to check slave->link before setting it to BOND_LINK_FAIL or
>> >> >BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is in
>> >> >BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
>> >> >BOND_LINK_DOWN.
>> >> >
>> >> >Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
>> >> >transition states")
>> >> >Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
>> >> >---
>> >> > drivers/net/bonding/bond_main.c | 2 +-
>> >> > 1 file changed, 1 insertion(+), 1 deletion(-)
>> >> >
>> >> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> >> >index 931d9d935686..a28776d8f33f 100644
>> >> >--- a/drivers/net/bonding/bond_main.c
>> >> >+++ b/drivers/net/bonding/bond_main.c
>> >> >@@ -3135,7 +3135,7 @@ static int bond_slave_netdev_event(unsigned long event,
>> >> >                */
>> >> >               if (bond_update_speed_duplex(slave) &&
>> >> >                   BOND_MODE(bond) == BOND_MODE_8023AD) {
>> >> >-                      if (slave->last_link_up)
>> >> >+                      if (slave->link == BOND_LINK_UP)
>> >> >                               slave->link = BOND_LINK_FAIL;
>> >> >                       else
>> >> >                               slave->link = BOND_LINK_DOWN;
>> >>
>> >>         Is the core problem here that slaves are reporting link up, but
>> >> returning invalid values for speed and/or duplex?  If so, what network
>> >> device are you testing with that is exhibiting this behavior?
>> >That's true, because link becomes FAIL right in this block of code.
>> >We use Mellanox ConnectX-3 Pro nic.
>> >
>> >>
>> >>         If I'm not mistaken, there have been several iterations of
>> >> hackery on this block of code to work around this same problem, and each
>> >> time there's some corner case that still doesn't work.
>> >As i can see, commit 4d2c0cda0744 ("bonding: speed/duplex update at
>> >NETDEV_UP event")
>> >introduced BOND_LINK_DOWN state if update speed/duplex failed.
>> >
>> >Commit ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
>> >changed DOWN state to FAIL.
>> >
>> >Commit 334031219a84 ("bonding/802.3ad: fix slave link initialization
>> >transition states")
>> >implemented different new state for different current states, but it
>> >was based on slave->last_link_up.
>> >In our case slave->last_link_up !=0 when this code runs. But, slave is
>> >not in UP state at the moment. It becomes
>> >FAIL and hangs in this state.
>> >So, it looks like checking if slave is in UP mode is more appropriate
>> >here. At least it works in our case.
>> >
>> >There was one more commit 12185dfe4436 ("bonding: Force slave speed
>> >check after link state recovery for 802.3ad")
>> >but it doesn't help in our case.
>> >
>> >>
>> >>         As Davem asked last time around, is the real problem that device
>> >> drivers report carrier up but supply invalid speed and duplex state?
>> >Probably, but I'm not quite sure right now. We didn't face this issue
>> >before 4d2c0cda0744 and ea53abfab960
>> >commits.
>>
>>         My concern here is that we keep adding special cases to this
>> code apparently without really understanding the root cause of the
>> failures.  4d2c0cda0744 asserts that there is a problem that drivers are
>> not supplying speed and duplex information at NETDEV_UP time, but is not
>> specific as to the details (hardware information).  Before we add
>> another change, I would like to understand what the actual underlying
>> cause of the failure is, and if yours is somehow different from what
>> 4d2c0cda0744 or ea53abfab960 were fixing (or trying to fix).
>>
>>         Would it be possible for you to instrument the code here to dump
>> out the duplex/speed failure information and carrier state of the slave
>> device at this point when it fails in your testing?  Something like the
>> following (which I have not compile tested):
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 931d9d935686..758af8c2b9e1 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -378,15 +378,22 @@ static int bond_update_speed_duplex(struct slave *slave)
>>         slave->duplex = DUPLEX_UNKNOWN;
>>
>>         res = __ethtool_get_link_ksettings(slave_dev, &ecmd);
>> -       if (res < 0)
>> +       if (res < 0) {
>> +               pr_err("DBG ksettings res %d slave %s\n", res, slave_dev->name);
>>                 return 1;
>> -       if (ecmd.base.speed == 0 || ecmd.base.speed == ((__u32)-1))
>> +       }
>> +       if (ecmd.base.speed == 0 || ecmd.base.speed == ((__u32)-1)) {
>> +               pr_err("DBG speed %u slave %s\n", ecmd.base.speed,
>> +                      slave_dev->name);
>>                 return 1;
>> +       }
>>         switch (ecmd.base.duplex) {
>>         case DUPLEX_FULL:
>>         case DUPLEX_HALF:
>>                 break;
>>         default:
>> +               pr_err("DBG duplex %u slave %s\n", ecmd.base.duplex,
>> +                      slave_dev->name);
>>                 return 1;
>>         }
>>
>> @@ -3135,6 +3142,9 @@ static int bond_slave_netdev_event(unsigned long event,
>>                  */
>>                 if (bond_update_speed_duplex(slave) &&
>>                     BOND_MODE(bond) == BOND_MODE_8023AD) {
>> +                       pr_err("DBG slave %s event %d carrier %d\n",
>> +                              slave->dev->name, event,
>> +                              netif_carrier_ok(slave->dev));
>>                         if (slave->last_link_up)
>>                                 slave->link = BOND_LINK_FAIL;
>>                         else
>
>Thanks, did that, without my patch. Here is the output when link doesn't work.
>Host has actor port state 71 and partner port state 1:
>[Thu Sep 19 12:14:04 2019] mlx4_en: eth2: Steering Mode 1
>[Thu Sep 19 12:14:04 2019] DBG speed 4294967295 slave eth2
>[Thu Sep 19 12:14:04 2019] DBG slave eth2 event 1 carrier 0
>[Thu Sep 19 12:14:04 2019] 8021q: adding VLAN 0 to HW filter on device eth2
>[Thu Sep 19 12:14:04 2019] mlx4_en: eth2: Link Up
>[Thu Sep 19 12:14:04 2019] bond-san: link status up again after 0 ms
>for interface eth2
>
>Here is the output when everything works fine:
>[Thu Sep 19 12:15:40 2019] mlx4_en: eth2: Steering Mode 1
>[Thu Sep 19 12:15:40 2019] DBG speed 4294967295 slave eth2
>[Thu Sep 19 12:15:40 2019] DBG slave eth2 event 1 carrier 0
>[Thu Sep 19 12:15:40 2019] 8021q: adding VLAN 0 to HW filter on device eth2
>[Thu Sep 19 12:15:40 2019] bond-san: link status definitely down for
>interface eth2, disabling it
>[Thu Sep 19 12:15:40 2019] mlx4_en: eth2: Link Up
>[Thu Sep 19 12:15:40 2019] bond-san: link status up for interface
>eth2, enabling it in 500 ms
>[Thu Sep 19 12:15:41 2019] bond-san: link status definitely up for
>interface eth2, 10000 Mbps full duplex
>
>If I'm not mistaken, there's up event before carrier is up.

	Yes; the NETDEV_UP is presumably coming from dev_open(), which
makes the device administratively up.  This is discrete from the carrier
"up" state, so NETDEV_UP before carrier up is not unexpected.

	What I was concerned with is that the carrier would be up but
speed or duplex would be invalid, which does not appear to be the case.

	In any event, I think I see what the failure is, I'm working up
a patch to test and will post it when I have it ready.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
