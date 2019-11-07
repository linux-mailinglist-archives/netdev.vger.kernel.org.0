Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683B8F3A94
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfKGVc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:32:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725893AbfKGVcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:32:25 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7LPeCu021231;
        Thu, 7 Nov 2019 16:31:02 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w4sn7kks2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 16:31:01 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA7LUo1L028094;
        Thu, 7 Nov 2019 21:31:05 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 2w41ukc2n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 21:31:05 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7LUxCK62980352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 21:30:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB46136059;
        Thu,  7 Nov 2019 21:30:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 043F8136053;
        Thu,  7 Nov 2019 21:30:58 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 21:30:58 +0000 (GMT)
Subject: Re: [RFC PATCH] powerpc/pseries/mobility: notify network peers after
 migration
To:     Nathan Lynch <nathanl@linux.ibm.com>
Cc:     netdev@vger.kernel.org, tyreld@linux.ibm.com, msuchanek@suse.com,
        linuxppc-dev@ozlabs.org
References: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
 <87lfss7ivo.fsf@linux.ibm.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <83835ea7-e76b-35c1-88a8-e37dae5bb26e@linux.ibm.com>
Date:   Thu, 7 Nov 2019 15:30:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87lfss7ivo.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/6/19 4:14 PM, Nathan Lynch wrote:
> Hi Tom,
>
> Thomas Falcon <tlfalcon@linux.ibm.com> writes:
>> After a migration, it is necessary to send a gratuitous ARP
>> from all running interfaces so that the rest of the network
>> is aware of its new location. However, some supported network
>> devices are unaware that they have been migrated. To avoid network
>> interruptions and other unwanted behavior, force a GARP on all
>> valid, running interfaces as part of the post_mobility_fixup
>> routine.
> [...]
>
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
> This isn't an outright nak, but this is not nice. It illustrates the
> need to rethink the pseries partition migration code. There is no
> mechanism for drivers and other interested code to prepare for a
> migration or to adjust to the destination. So post_mobility_fixup() will
> continue to grow into a fragile collection of calls into unrelated
> subsystems until there is a better design -- either a pseries-specific
> notification/callback mechanism, or something based on the pm framework.
>
> My understanding is that this is needed specifically for ibmveth and,
> unlike ibmvnic, the platform does not provide any notification to that
> driver that a migration has occurred, right?

Correct, the ibmveth device, unlike ibmvnic, receives no signal or 
notification at all in the event of a partition migration, so it can not 
handle it or send a gratuitous ARP because from the driver's perspective 
nothing has changed.  As you've described, there is no existing notifier 
in the kernel to inform interested parties that the system has migrated 
or is about to migrate. Without adding the needed infrastructure to do 
that, I'm not sure how else to fix this.

Tom

