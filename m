Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0875FF3A48
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfKGVRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:17:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfKGVRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:17:54 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7LCPoY063441;
        Thu, 7 Nov 2019 16:16:26 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w41w5pe9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 16:16:25 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA7LBEp6001407;
        Thu, 7 Nov 2019 21:16:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 2w41ujuya0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 21:16:20 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7LGJI837552446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 21:16:19 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B2C136061;
        Thu,  7 Nov 2019 21:16:19 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4FE5136059;
        Thu,  7 Nov 2019 21:16:18 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 21:16:18 +0000 (GMT)
Subject: Re: [RFC PATCH] powerpc/pseries/mobility: notify network peers after
 migration
To:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc:     nathanl@linux.ibm.com, netdev@vger.kernel.org, msuchanek@suse.com,
        tyreld@linux.ibm.com
References: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
 <87tv7g5v3e.fsf@mpe.ellerman.id.au>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <601046ba-7bf4-f323-c708-8a5d99c961cd@linux.ibm.com>
Date:   Thu, 7 Nov 2019 15:16:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87tv7g5v3e.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/6/19 7:33 PM, Michael Ellerman wrote:
> Hi Thomas,
>
> Thomas Falcon <tlfalcon@linux.ibm.com> writes:
>> After a migration, it is necessary to send a gratuitous ARP
>> from all running interfaces so that the rest of the network
>> is aware of its new location. However, some supported network
>> devices are unaware that they have been migrated. To avoid network
>> interruptions and other unwanted behavior, force a GARP on all
>> valid, running interfaces as part of the post_mobility_fixup
>> routine.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>>   arch/powerpc/platforms/pseries/mobility.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
> This patch is in powerpc code, but it's doing networking stuff that I
> don't really understand.
>
> So I'd like an Ack from Dave or someone else in netdev land before I
> merge it.

Thanks, I've already included netdev in the CC list. I'll wait and keep 
an eye out for any comments from that side.

Tom



>
> cheers
>
>
>> diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
>> index b571285f6c14..c1abc14cf2bb 100644
>> --- a/arch/powerpc/platforms/pseries/mobility.c
>> +++ b/arch/powerpc/platforms/pseries/mobility.c
>> @@ -17,6 +17,9 @@
>>   #include <linux/delay.h>
>>   #include <linux/slab.h>
>>   #include <linux/stringify.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/rtnetlink.h>
>> +#include <net/net_namespace.h>
>>   
>>   #include <asm/machdep.h>
>>   #include <asm/rtas.h>
>> @@ -331,6 +334,8 @@ void post_mobility_fixup(void)
>>   {
>>   	int rc;
>>   	int activate_fw_token;
>> +	struct net_device *netdev;
>> +	struct net *net;
>>   
>>   	activate_fw_token = rtas_token("ibm,activate-firmware");
>>   	if (activate_fw_token == RTAS_UNKNOWN_SERVICE) {
>> @@ -371,6 +376,21 @@ void post_mobility_fixup(void)
>>   	/* Possibly switch to a new RFI flush type */
>>   	pseries_setup_rfi_flush();
>>   
>> +	/* need to force a gratuitous ARP on running interfaces */
>> +	rtnl_lock();
>> +	for_each_net(net) {
>> +		for_each_netdev(net, netdev) {
>> +			if (netif_device_present(netdev) &&
>> +			    netif_running(netdev) &&
>> +			    !(netdev->flags & (IFF_NOARP | IFF_LOOPBACK)))
>> +				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
>> +							 netdev);
>> +				call_netdevice_notifiers(NETDEV_RESEND_IGMP,
>> +							 netdev);
>> +		}
>> +	}
>> +	rtnl_unlock();
>> +
>>   	return;
>>   }
>>   
>> -- 
>> 2.12.3
