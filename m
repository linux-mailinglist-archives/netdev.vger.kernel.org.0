Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8845FD1DC1
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbfJJAyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:54:31 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:20480 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731751AbfJJAya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 20:54:30 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A0qJ8u013485;
        Thu, 10 Oct 2019 01:54:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=lrf8L8G2NzSWzWgb/tgnH00mlUfAWbKZY2H5RGGA9fI=;
 b=CUxjTXJ2OH5O0JjfcJ5Hsw7g81SaDTA42XUWWq7tK6xXtWdK9AieyLOdrNWP9BjjG0H5
 r8bdgKkgfdOedMFVyvSC0bpYt1EbNwumw5WnO19Q/5j6LuIGQclMmiQR7ThmKyPjw2DE
 obe5cCV7gJWjvnchsaQgc6GkoAdjKw2+x9c2eb8U7kYjX2DFM0gDEVzBw30x1AGW8CnA
 4uWCMLyXmdn03RrdW4DbFDkcNQyl7dmafnMS544pUXx+ujzGtPD0+pFylqjSz55F8Yi0
 /VTxvpUCqEj20wOB0LeU82UUs/4ZbiKtf3ybYoUmt2yzXfoZU6HMLzlLhSwSd/4+4h2I yQ== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2vejtvdsf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 01:54:22 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9A0lD2X027450;
        Wed, 9 Oct 2019 20:54:21 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2vepgwunqr-9;
        Wed, 09 Oct 2019 20:54:20 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id AEC15206EE;
        Thu, 10 Oct 2019 00:54:19 +0000 (GMT)
Subject: Re: [PATCH 3/3] i40e: Add UDP segmentation offload support
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, willemb@google.com,
        intel-wired-lan@lists.osuosl.org
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <1570658777-13459-4-git-send-email-johunt@akamai.com>
 <5f4af1c5-c2d1-d643-3fb2-fe4bd0e7e8cf@intel.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <0ecadb39-ef96-6802-55f5-f1d72f2132f2@akamai.com>
Date:   Wed, 9 Oct 2019 17:54:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5f4af1c5-c2d1-d643-3fb2-fe4bd0e7e8cf@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100004
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_11:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 5:39 PM, Samudrala, Sridhar wrote:
> 
> 
> On 10/9/2019 3:06 PM, Josh Hunt wrote:
>> Based on a series from Alexander Duyck this change adds UDP segmentation
>> offload support to the i40e driver.
>>
>> CC: Alexander Duyck <alexander.h.duyck@intel.com>
>> CC: Willem de Bruijn <willemb@google.com>
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
>>   2 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c 
>> b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index 6031223eafab..56f8c52cbba1 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -12911,6 +12911,7 @@ static int i40e_config_netdev(struct i40e_vsi 
>> *vsi)
>>                 NETIF_F_GSO_IPXIP6        |
>>                 NETIF_F_GSO_UDP_TUNNEL    |
>>                 NETIF_F_GSO_UDP_TUNNEL_CSUM    |
>> +              NETIF_F_GSO_UDP_L4        |
>>                 NETIF_F_SCTP_CRC        |
>>                 NETIF_F_RXHASH        |
>>                 NETIF_F_RXCSUM        |
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c 
>> b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>> index e3f29dc8b290..0b32f04a6255 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>> @@ -2960,10 +2960,16 @@ static int i40e_tso(struct i40e_tx_buffer 
>> *first, u8 *hdr_len,
>>       /* remove payload length from inner checksum */
>>       paylen = skb->len - l4_offset;
>> -    csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
>> -    /* compute length of segmentation header */
>> -    *hdr_len = (l4.tcp->doff * 4) + l4_offset;
>> +    if (skb->csum_offset == offsetof(struct tcphdr, check)) {
> 
> Isn't it more relevant to check for gso_type rather than base this on 
> the csum_offset?
Thanks Sridhar for the review. Yeah I think you're right. I will change 
this on all 3 patches.

Josh
