Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4BA2D3589
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgLHVrC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Dec 2020 16:47:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58979 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgLHVrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 16:47:01 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kmkoF-0006sn-Kc; Tue, 08 Dec 2020 21:46:13 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id C5B695FEE7; Tue,  8 Dec 2020 13:46:09 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id BE5A99FAB0;
        Tue,  8 Dec 2020 13:46:09 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Lars Everbrand <lars.everbrand@protonmail.com>,
        linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: correct rr balancing during link failure
In-reply-to: <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <X8f/WKR6/j9k+vMz@black-debian> <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Sat, 05 Dec 2020 11:45:13 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15307.1607463969.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 08 Dec 2020 13:46:09 -0800
Message-ID: <15308.1607463969@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Wed, 02 Dec 2020 20:55:57 +0000 Lars Everbrand wrote:
>> This patch updates the sending algorithm for roundrobin to avoid
>> over-subscribing interface(s) when one or more interfaces in the bond is
>> not able to send packets. This happened when order was not random and
>> more than 2 interfaces were used.
>> 
>> Previously the algorithm would find the next available interface
>> when an interface failed to send by, this means that most often it is
>> current_interface + 1. The problem is that when the next packet is to be
>> sent and the "normal" algorithm then continues with interface++ which
>> then hits that same interface again.
>> 
>> This patch updates the resending algorithm to update the global counter
>> of the next interface to use.
>> 
>> Example (prior to patch):
>> 
>> Consider 6 x 100 Mbit/s interfaces in a rr bond. The normal order of links
>> being used to send would look like:
>> 1 2 3 4 5 6  1 2 3 4 5 6  1 2 3 4 5 6 ...
>> 
>> If, for instance, interface 2 where unable to send the order would have been:
>> 1 3 3 4 5 6  1 3 3 4 5 6  1 3 3 4 5 6 ...
>> 
>> The resulting speed (for TCP) would then become:
>> 50 + 0 + 100 + 50 + 50 + 50 = 300 Mbit/s
>> instead of the expected 500 Mbit/s.
>> 
>> If interface 3 also would fail the resulting speed would be half of the
>> expected 400 Mbit/s (33 + 0 + 0 + 100 + 33 + 33).

	Are these bandwidth numbers from observation of the actual
behavior?  I'm not sure the real system would behave this way; my
suspicion is that it would increase the likelihood of drops on the
overused slave, not that the overall capacity would be limited.

>> Signed-off-by: Lars Everbrand <lars.everbrand@protonmail.com>
>
>Thanks for the patch!
>
>Looking at the code in question it feels a little like we're breaking
>abstractions if we bump the counter directly in get_slave_by_id.

	Agreed; I think a better way to fix this is to enable the slave
array for balance-rr mode, and then use the array to find the right
slave.  This way, we then avoid the problematic "skip unable to tx"
logic for free.

>For one thing when the function is called for IGMP packets the counter
>should not be incremented at all. But also if packets_per_slave is not
>1 we'd still be hitting the same leg multiple times (packets_per_slave
>/ 2). So it seems like we should round the counter up somehow?
>
>For IGMP maybe we don't have to call bond_get_slave_by_id() at all,
>IMHO, just find first leg that can TX. Then we can restructure
>bond_get_slave_by_id() appropriately for the non-IGMP case.

	For IGMP, the theory is to confine that traffic to a single
device.  Normally, this will be curr_active_slave, which is updated even
in balance-rr mode as interfaces are added to or removed from the bond.
The call to bond_get_slave_by_id should be a fallback in case
curr_active_slave is empty, and should be the exception, and may not be
possible at all.

	But either way, the IGMP path shouldn't mess with rr_tx_counter,
it should be out of band of the normal TX packet counting, so to speak.

	-J

>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index e0880a3840d7..e02d9c6d40ee 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -4107,6 +4107,7 @@ static struct slave *bond_get_slave_by_id(struct bonding *bond,
>>  		if (--i < 0) {
>>  			if (bond_slave_can_tx(slave))
>>  				return slave;
>> +			bond->rr_tx_counter++;
>>  		}
>>  	}
>>  
>> @@ -4117,6 +4118,7 @@ static struct slave *bond_get_slave_by_id(struct bonding *bond,
>>  			break;
>>  		if (bond_slave_can_tx(slave))
>>  			return slave;
>> +		bond->rr_tx_counter++;
>>  	}
>>  	/* no slave that can tx has been found */
>>  	return NULL;
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
