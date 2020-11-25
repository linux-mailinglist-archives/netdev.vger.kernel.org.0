Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7A2C42D6
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgKYP0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:26:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727980AbgKYP0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 10:26:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0APF3kXj115421;
        Wed, 25 Nov 2020 10:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6vM1k1v1DUbJuvSpWCALChY7j62OYSGjuS0WOjFgDQg=;
 b=Dx4r87ddEQCDC4J2N/SErTtXTCIWFgYOU7Vk38jjtb8y06PfwdGhcMekMiQHx5vOLSTt
 a05m/NhF5qURSUeXe/m3lzp5i/jFIkZJ0jUT1+xMti+yuG2+HTALM7CQ//AsCdjoPCdS
 tZMg5OYE/VlofsREWhYWA6/M6ibfBXsSMIaSDh86dtWXHZ/i/6bF9KhDRbq6xjuWlyzJ
 vArt8325GdUTKru6R6/apIxr3Sl0XEsli9ukuxoSRJm+kTI3XiVCOIUMQ8bo30KyWtmp
 mEMT1fzIU4TgSIPuFSsmTenkMp3NwHae1JA89JVmBJinwvYyjqelm0CkfAuVjKEjg9B1 hA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351qy54d77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 10:26:06 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0APFC7ED023377;
        Wed, 25 Nov 2020 15:26:03 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 34xth9rfxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 15:26:03 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0APFQ2de18547274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 15:26:02 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A965630E8F;
        Wed, 25 Nov 2020 15:26:02 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B278430E8A;
        Wed, 25 Nov 2020 15:26:01 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.115.31])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 Nov 2020 15:26:01 +0000 (GMT)
Subject: Re: [PATCH net 1/2] ibmvnic: Ensure that SCRQ entry reads are
 correctly ordered
To:     Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org
Cc:     cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
References: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
 <1606238776-30259-2-git-send-email-tlfalcon@linux.ibm.com>
 <87o8jmyosh.fsf@mpe.ellerman.id.au>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <2da3e517-f1dd-95c9-11db-a6c62bf61978@linux.ibm.com>
Date:   Wed, 25 Nov 2020 09:26:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <87o8jmyosh.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_08:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 11:43 PM, Michael Ellerman wrote:
> Thomas Falcon <tlfalcon@linux.ibm.com> writes:
>> Ensure that received Subordinate Command-Response Queue (SCRQ)
>> entries are properly read in order by the driver. These queues
>> are used in the ibmvnic device to process RX buffer and TX completion
>> descriptors. dma_rmb barriers have been added after checking for a
>> pending descriptor to ensure the correct descriptor entry is checked
>> and after reading the SCRQ descriptor to ensure the entire
>> descriptor is read before processing.
>>
>> Fixes: 032c5e828 ("Driver for IBM System i/p VNIC protocol")
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>>   drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
>> index 2aa40b2..489ed5e 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -2403,6 +2403,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
>>   
>>   		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
>>   			break;
>> +		/* ensure that we do not prematurely exit the polling loop */
>> +		dma_rmb();
> I'd be happier if these comments were more specific about which read(s)
> they are ordering vs which other read(s).
>
> I'm sure it's obvious to you, but it may not be to a future author,
> and/or after the code has been refactored over time.

Thank you for reviewing! I will submit a v2 soon with clearer comments 
on the reads being ordered here.

Thanks,

Tom


>
>>   		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
>>   		rx_buff =
>>   		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
>> @@ -3098,6 +3100,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
>>   		unsigned int pool = scrq->pool_index;
>>   		int num_entries = 0;
>>   
>> +		/* ensure that the correct descriptor entry is read */
>> +		dma_rmb();
>> +
>>   		next = ibmvnic_next_scrq(adapter, scrq);
>>   		for (i = 0; i < next->tx_comp.num_comps; i++) {
>>   			if (next->tx_comp.rcs[i]) {
>> @@ -3498,6 +3503,9 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
>>   	}
>>   	spin_unlock_irqrestore(&scrq->lock, flags);
>>   
>> +	/* ensure that the entire SCRQ descriptor is read */
>> +	dma_rmb();
>> +
>>   	return entry;
>>   }
> cheers
