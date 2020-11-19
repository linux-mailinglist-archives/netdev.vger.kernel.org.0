Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389D52B9C63
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgKSU65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:58:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36372 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgKSU64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:58:56 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKZLwi038704;
        Thu, 19 Nov 2020 15:58:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qJDY2PTYw/PLiBcP6m0c8IB+46oc0gqj3Qvg/Ep0U9U=;
 b=oBLrg6zLsdsTWW3386/ZXjP3urYCMSN/F/Zt+CN/L+sVtbrkuTiUtY77oKAE1iJQQqWk
 gPJDr1JicbA14oh6xdVpYx10esGd/iEvB8cajLjz3pbP2pLVvQfvX9XngXcICqHPYXOk
 xKWMtkk9jQb/u/z/+JTzvcEwrq/UxjFXutA377mBmcCSGxB6zfj/XIyFEuVsEyWDrW35
 RXe8GJbQ8cX6aRheLqb8Cd1SraWs7pY5jAI7By5A/AF/q40NfJ7jDU/sJ8tkNMRzff4R
 56hwQQ35pouqNZDMF1oBw88kH94X/cprF2ypmO/NoFOj7nAwbEtrRaApxsG2xUfEu9mN xA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wy6fskxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 15:58:49 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKpFiH013630;
        Thu, 19 Nov 2020 20:58:48 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 34uyn1qusn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 20:58:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJKwm8G54591882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 20:58:48 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17573124055;
        Thu, 19 Nov 2020 20:58:48 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 486B3124052;
        Thu, 19 Nov 2020 20:58:47 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.227.245])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 20:58:47 +0000 (GMT)
Subject: Re: [PATCH net-next v2 9/9] ibmvnic: Do not replenish RX buffers
 after every polling loop
To:     ljp <ljp@linux.vnet.ibm.com>
Cc:     kuba@kernel.org, cforno12@linux.ibm.com, netdev@vger.kernel.org,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605748345-32062-10-git-send-email-tlfalcon@linux.ibm.com>
 <1a4e7b1ef1fb101cbb26fb9d5867ee46@linux.vnet.ibm.com>
 <83ca37f3-07be-4179-8414-88c8c83bfe56@linux.ibm.com>
 <7853649c6c1f2f4ce6d8bf9643cd1a43@linux.vnet.ibm.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <d0792730-f72c-8213-15c3-e0c518d1c23f@linux.ibm.com>
Date:   Thu, 19 Nov 2020 14:58:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <7853649c6c1f2f4ce6d8bf9643cd1a43@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_10:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=550 adultscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20 2:38 PM, ljp wrote:
> On 2020-11-19 14:26, Thomas Falcon wrote:
>> On 11/19/20 3:43 AM, ljp wrote:
>>
>>> On 2020-11-18 19:12, Thomas Falcon wrote:
>>>
>>>> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
>>>>
>>>> Reduce the amount of time spent replenishing RX buffers by
>>>> only doing so once available buffers has fallen under a certain
>>>> threshold, in this case half of the total number of buffers, or
>>>> if the polling loop exits before the packets processed is less
>>>> than its budget.
>>>>
>>>> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
>>>> ---
>>>> drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
>>>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
>>>> b/drivers/net/ethernet/ibm/ibmvnic.c
>>>> index 96df6d8fa277..9fe43ab0496d 100644
>>>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>>>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>>>> @@ -2537,7 +2537,10 @@ static int ibmvnic_poll(struct napi_struct
>>>>
>>>> *napi, int budget)
>>>> frames_processed++;
>>>> }
>>>>
>>>> - if (adapter->state != VNIC_CLOSING)
>>>> + if (adapter->state != VNIC_CLOSING &&
>>>> + ((atomic_read(&adapter->rx_pool[scrq_num].available) <
>>>> + adapter->req_rx_add_entries_per_subcrq / 2) ||
>>>> + frames_processed < budget))
>>>
>>> 1/2 seems a simple and good algorithm.
>>> Explaining why "frames_process < budget" is necessary in the commit
>>> message
>>> or source code also helps.
>>
>> Hello, Lijun. The patch author, Dwip Banerjee, suggested the modified
>> commit message below:
>>
>> Reduce the amount of time spent replenishing RX buffers by
>>  only doing so once available buffers has fallen under a certain
>>  threshold, in this case half of the total number of buffers, or
>>  if the polling loop exits before the packets processed is less
>>  than its budget. Non-exhaustion of NAPI budget implies lower
>>  incoming packet pressure, allowing the leeway to refill the buffers
>>  in preparation for any impending burst.
>
> It looks good to me.
>
>>
>> Would such an update require a v3?
>
> I assume you ask Jakub, right?
>
>
Yes. There was an issue with my mail client in my earlier response, so I 
am posting Dwip's modified commit message again below.

Reduce the amount of time spent replenishing RX buffers by only doing so 
once available buffers has fallen under a certain threshold, in this 
case half of the total number of buffers, or if the polling loop exits 
before the packets processed is less than its budget. Non-exhaustion of 
NAPI budget implies lower incoming packet pressure, allowing the leeway 
to refill the buffers in preparation for any impending burst.

>>>> replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
>>>> if (frames_processed < budget) {
>>>> if (napi_complete_done(napi, frames_processed)) {
