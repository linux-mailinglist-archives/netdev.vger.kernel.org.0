Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D676367A9D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhDVHIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:08:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235034AbhDVHIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:08:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M74P3T032893;
        Thu, 22 Apr 2021 03:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hBKjfcrKHvPZuyw4887AQ9KUsBTVTdRWR+dU2vlNDhw=;
 b=cf2PjBmi3OuAPFBFYWpfCGPAnMvBOfOfmBiYJYUrXkeSsK899FErog0d1GlnzKdcAOSa
 wji69yAs/pYsECgj8zDkc000MyGw/bwpzYUbTZEM1jNdDX8mppIOb4Z9j71O1b+ByNXM
 skxZ1k/Yi/KGqBuH1qkYcpe2GOlXjxZ9unq/TUFTcnJdrPTsMmtZm6Qj5GnCvSaIM7sU
 /CMmTqZ1mY2Hvr1dcRmiioCm8O7UMXs163spBOvpyjZ1QLvHdQE7LFpy1W3kna4Hm0TO
 qj+XoeD6rIjGKgBur/iH6WX/vq/Aa8OWfkR5e4hrrywHoPzLgd6Hn5cjbdYQn9TtBZcr zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382xveqmf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 03:07:50 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13M74i9w034716;
        Thu, 22 Apr 2021 03:07:49 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382xveqme5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 03:07:49 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13M6utS2001040;
        Thu, 22 Apr 2021 07:07:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 37yqa9g1nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 07:07:48 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13M77moF27132394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 07:07:48 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7612AE05C;
        Thu, 22 Apr 2021 07:07:47 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76777AE063;
        Thu, 22 Apr 2021 07:07:46 +0000 (GMT)
Received: from [9.160.109.21] (unknown [9.160.109.21])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 22 Apr 2021 07:07:46 +0000 (GMT)
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
To:     Lijun Pan <lijunp213@gmail.com>, Dany Madden <drt@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <CAOhMmr5XayoXS=sJ+9zm68VF+Jn+9qiVvWUrDfq0WGQ6ftKdbw@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <49b3b535-3b81-6ffd-44b7-6226507859fa@linux.vnet.ibm.com>
Date:   Thu, 22 Apr 2021 00:07:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAOhMmr5XayoXS=sJ+9zm68VF+Jn+9qiVvWUrDfq0WGQ6ftKdbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1BuwRCZ903Px1DaknrGiO9nGDpV-h_Iu
X-Proofpoint-GUID: ZErJA5Kva0BMOsfpeSNsQ9JI91_nkjHu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 clxscore=1011 adultscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 10:30 PM, Lijun Pan wrote:
>> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>> Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
>> Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> One thing I would like to point out as already pointed out by Nathan Lynch is
> that those review-by tags given by the same groups of people from the same
> company loses credibility over time if you never critique or ask
> questions on the list.
> 

Well, so far you aren't addressing either my critiques or questions.

I have been asking questions but all I have from you are the above
attempts to discredit the reputation of myself and other people, and
non-technical statements like

     will make the code very difficult to manage
     I think there should be a trade off between optimization and stability.
     So I don't think you could even compare the two results

On the other hand, from the original submission I see some very specific
details:

     If ibmvnic abandons the reset because of this failed set link
     down and this is the last reset in the workqueue, then this
     adapter will be left in an inoperable state.

and from a followup discussion:

     We had a FATAL error and when handling it, we failed to
     send a link-down message to the VIOS. So what we need
     to try next is to reset the connection with the VIOS. For
     this we must ...

These are great technical points that could be argued or discussed.
Problem is, I agree with them.

I will ask again:  can you please supply some technical reasons for
your objections.  Otherwise, your objections are meritless and at worst
simply an ad hominem attack.

Rick
