Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE05B74C7
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfISIL7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Sep 2019 04:11:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51304 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfISIL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:11:58 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iArXb-00025e-IU; Thu, 19 Sep 2019 08:11:51 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 7E1A12402EB; Thu, 19 Sep 2019 10:11:51 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 756FE289C50;
        Thu, 19 Sep 2019 10:11:51 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "zhangsha \(A\)" <zhangsha.zhang@huawei.com>
cc:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        hunongda <hunongda@huawei.com>,
        "Chenzhendong (alex)" <alex.chen@huawei.com>
Subject: Re: [PATCH v3] bonding: force enable lacp port after link state recovery for 802.3ad
In-reply-to: <e333c8d2f3624a898a378eb1073f5f29@huawei.com>
References: <20190918130620.8556-1-zhangsha.zhang@huawei.com> <e333c8d2f3624a898a378eb1073f5f29@huawei.com>
Comments: In-reply-to "zhangsha (A)" <zhangsha.zhang@huawei.com>
   message dated "Wed, 18 Sep 2019 13:35:40 -0000."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Thu, 19 Sep 2019 10:11:51 +0200
Message-ID: <10098.1568880711@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhangsha (A) <zhangsha.zhang@huawei.com> wrote:

>> -----Original Message-----
>> From: zhangsha (A)
>> Sent: 2019年9月18日 21:06
>> To: jay.vosburgh@canonical.com; vfalico@gmail.com; andy@greyhouse.net;
>> davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> yuehaibing <yuehaibing@huawei.com>; hunongda <hunongda@huawei.com>;
>> Chenzhendong (alex) <alex.chen@huawei.com>; zhangsha (A)
>> <zhangsha.zhang@huawei.com>
>> Subject: [PATCH v3] bonding: force enable lacp port after link state recovery for
>> 802.3ad
>> 
>> From: Sha Zhang <zhangsha.zhang@huawei.com>
>> 
>> After the commit 334031219a84 ("bonding/802.3ad: fix slave link initialization
>> transition states") merged, the slave's link status will be changed to
>> BOND_LINK_FAIL from BOND_LINK_DOWN in the following scenario:
>> - Driver reports loss of carrier and
>>   bonding driver receives NETDEV_DOWN notifier
>> - slave's duplex and speed is zerod and
>>   its port->is_enabled is cleard to 'false';
>> - Driver reports link recovery and
>>   bonding driver receives NETDEV_UP notifier;
>> - If speed/duplex getting failed here, the link status
>>   will be changed to BOND_LINK_FAIL;
>> - The MII monotor later recover the slave's speed/duplex
>>   and set link status to BOND_LINK_UP, but remains
>>   the 'port->is_enabled' to 'false'.
>> 
>> In this scenario, the lacp port will not be enabled even its speed and duplex are
>> valid. The bond will not send LACPDU's, and its state is 'AD_STATE_DEFAULTED'
>> forever. The simplest fix I think is to call bond_3ad_handle_link_change() in
>> bond_miimon_commit, this function can enable lacp after port slave speed
>> check.
>> As enabled, the lacp port can run its state machine normally after link recovery.
>> 
>> Signed-off-by: Sha Zhang <zhangsha.zhang@huawei.com>
>> ---
>>  drivers/net/bonding/bond_main.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/bonding/bond_main.c
>> b/drivers/net/bonding/bond_main.c index 931d9d9..76324a5 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -2206,7 +2206,8 @@ static void bond_miimon_commit(struct bonding
>> *bond)
>>  			 */
>>  			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
>>  			    slave->link == BOND_LINK_UP)
>> -
>> 	bond_3ad_adapter_speed_duplex_changed(slave);
>> +				bond_3ad_handle_link_change(slave,
>> +							    BOND_LINK_UP);
>>  			continue;
>> 
>>  		case BOND_LINK_UP:
>
>Hi, David,
>I have replied your email for a while,  I guess you may miss my email, so I resend it.
>The following link address is the last email, please review the new one again, thank you.
>https://patchwork.ozlabs.org/patch/1151915/
>
>Last time, you doubted this is a driver specific problem,
>I prefer to believe it's not because I find the commit 4d2c0cda,
>its log says " Some NIC drivers don't have correct speed/duplex 
>settings at the time they send NETDEV_UP notification ...".
>
>Anyway, I think the lacp status should be fixed correctly,
>since link-monitoring (miimon) set SPEED/DUPLEX right here.

	I suspect this is going to be related to the concurrent
discussion with Aleksei, and would like to see the instrumentation
results from his tests before adding another change to attempt to
resolve this.

	Also, what device are you using for your testing, and are you
able to run the instrumentation patch that I provided to Aleksei and
provide its results?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
