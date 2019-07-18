Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6A06D3DC
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391071AbfGRS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:26:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390987AbfGRS0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:26:43 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6IIOnaY098094
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:26:42 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ttvv3b47y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:26:42 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 18 Jul 2019 19:26:41 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Jul 2019 19:26:38 +0100
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6IIQce865470792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 18:26:38 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA927BE051;
        Thu, 18 Jul 2019 18:26:37 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B4A2BE056;
        Thu, 18 Jul 2019 18:26:37 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.10.86.34])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jul 2019 18:26:37 +0000 (GMT)
Subject: Re: [EXT] [PATCH] bnx2x: Prevent load reordering in tx completion
 processing
To:     Manish Chopra <manishc@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Cc:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1563226910-21660-1-git-send-email-brking@linux.vnet.ibm.com>
 <DM6PR18MB2697C972B49EAD3AE7C3F37AABC80@DM6PR18MB2697.namprd18.prod.outlook.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Date:   Thu, 18 Jul 2019 13:26:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <DM6PR18MB2697C972B49EAD3AE7C3F37AABC80@DM6PR18MB2697.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19071818-8235-0000-0000-00000EBB2D9C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011453; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01234036; UDB=6.00650285; IPR=6.01015363;
 MB=3.00027783; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-18 18:26:40
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071818-8236-0000-0000-000046744E05
Message-Id: <247dddf2-9a46-cb02-f7a6-228274ac81d6@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180188
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/19 5:12 AM, Manish Chopra wrote:
>> -----Original Message-----
>> From: Brian King <brking@linux.vnet.ibm.com>
>> Sent: Tuesday, July 16, 2019 3:12 AM
>> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
>> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>; Ariel Elior
>> <aelior@marvell.com>; netdev@vger.kernel.org; Brian King
>> <brking@linux.vnet.ibm.com>
>> Subject: [EXT] [PATCH] bnx2x: Prevent load reordering in tx completion
>> processing
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> This patch fixes an issue seen on Power systems with bnx2x which results in
>> the skb is NULL WARN_ON in bnx2x_free_tx_pkt firing due to the skb pointer
>> getting loaded in bnx2x_free_tx_pkt prior to the hw_cons load in
>> bnx2x_tx_int. Adding a read memory barrier resolves the issue.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> index 656ed80..e2be5a6 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> @@ -285,6 +285,9 @@ int bnx2x_tx_int(struct bnx2x *bp, struct
>> bnx2x_fp_txdata *txdata)
>>  	hw_cons = le16_to_cpu(*txdata->tx_cons_sb);
>>  	sw_cons = txdata->tx_pkt_cons;
>>
>> +	/* Ensure subsequent loads occur after hw_cons */
>> +	smp_rmb();
>> +
>>  	while (sw_cons != hw_cons) {
>>  		u16 pkt_cons;
>>
>> --
>> 1.8.3.1
> 
> Could you please explain a bit in detail what could have caused skb to NULL exactly ?
> Curious that if skb would have been NULL for some reason it did not cause NULL pointer dereference in bnx2x_free_tx_pkt() on below call -
> 
> prefetch(&skb->end);
> 
> Which is prior to the said WARN_ON(!skb) in bnx2x_free_tx_pkt().

Right. In this case, that would end up passing an invalid address to prefetch. On a
Power processor, that turns into a dcbt instruction (data cache block touch), which
is a hint to the process that the subsequent code may access that data cache block.
Passing an invalid address to dcbt causes no harm. I just built a userspace program
to validate that doing something very similar to what is happening here, and the dcbt
executed with no errors, no segfault to the userspace process.

This is the scenario I think is occurring. 

CPU[0]
bnx2x_start_xmit
[1] tx_buf->skb = skb; /* store skb pointer */
[2] ...
[3] wmb(); 
[4] DOORBELL_RELAXED

CPU[1]
bnx2x_tx_int
[5]  hw_cons = le16_to_cpu(*txdata->tx_cons_sb);
[6]  sw_cons = txdata->tx_pkt_cons;
[7]  while (sw_cons != hw_cons) {
[8]  pkt_cons = TX_BD(sw_cons);
[9]  bnx2x_free_tx_pkt
[10]  tx_buf = &txdata->tx_buf_ring[pkt_cons];
[11]  skb = tx_buf->skb;
[12]  prefetch(&skb->end);
[13]  ...
[14]  WARN_ON(!skb);


On CPU0 we are in the process of sending a TX buffer to the adapter. We have a wmb at [3]
to ensure that all stores to cacheable storage are coherent with respect to the
non-cacheable store at [4] to tell the adapter about the new TX buffer.

On CPU1, we have a potential race condition if the processor is aggressively reordering
loads. If we find ourselves in bnx2x_tx_int, while still in bn2x_start_xmit on CPU0,
its possible the processor could begin speculatively executing well into [11]. Since there
is no read barrier of any sort to tell the processor that the load of the skb pointer
cannot happen until the load of hw_cons has occurred, we could end up speculatively
loading the skb pointer before the write in [1] has completed with respect to CPU1. 

Adding the smp_rmb between 6 and 7 ensures that the load at 5 occurs prior to the
load at 11.

This was reproducing consistently on a 16 socket Power 9 system built of four, four socket
nodes, with 10 bnx2x adapters and 26TB of memory. The NUMA effects can get to be exaggerated
a bit on these systems. With this patch, the system runs without issues. We've now been able to
run the workload multiple times with no issues.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

