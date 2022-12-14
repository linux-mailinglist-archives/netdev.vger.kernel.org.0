Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647E64C3CF
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbiLNGcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiLNGcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:32:39 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86279EBC;
        Tue, 13 Dec 2022 22:32:38 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3eUrY031676;
        Wed, 14 Dec 2022 06:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=xFzbEW9xvkMWsfH8wcAT93l1VQQCAJXFPP6KB/pYVog=;
 b=FZCh52CpdENzfCeR4DFS5FpymrycLpNEmbFAgiEnkx/2QEa4vQGwkTAjxOYfbzfi1vl5
 +oyHTA5puOTnQ8vKp1894caf9Sn1GMEfp2sPy/kWQG4HIlxCRo5JYvRwNFJN4SoMmxE+
 3yWvqCYL82f44PbxHIZUs0e4kEOwBnX7sZALgrhpIJdFsQeg74XbVeHulLbiNB9JbsaH
 sFCLEEKLFbjjLsKfHqgvdb168UPC1Y12nmMJ9uyAVc2b5zzpASeBkPFECgiba6nNCgky
 RxbZNTI7sfFVbybzMjReZNwZPcEMazpIo9GgJZkFmYqf7I+g+c9YfpZHV4/jGmrbtS46 vw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mf6rkg9d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 06:32:13 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BE6WC2a017709
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 06:32:12 GMT
Received: from [10.110.87.216] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 13 Dec
 2022 22:32:10 -0800
Message-ID: <38c438ca-2a3f-18d0-03eb-1fa846e2075e@quicinc.com>
Date:   Tue, 13 Dec 2022 23:32:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net] filter: Account for tail adjustment during pull
 operations
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>,
        <andrii@kernel.org>, <martin.lau@linux.dev>,
        <john.fastabend@gmail.com>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Sean Tranchetti <quic_stranche@quicinc.com>
References: <1670906381-25161-1-git-send-email-quic_subashab@quicinc.com>
 <4d598e55-0366-5a27-2dd5-d7b59758b5fc@iogearbox.net>
Content-Language: en-US
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <4d598e55-0366-5a27-2dd5-d7b59758b5fc@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 9M2BKu4AN3y8IgCamPHLcQd9tW1tKleR
X-Proofpoint-ORIG-GUID: 9M2BKu4AN3y8IgCamPHLcQd9tW1tKleR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140049
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/2022 3:42 PM, Daniel Borkmann wrote:
> On 12/13/22 5:39 AM, Subash Abhinov Kasiviswanathan wrote:
>> Extending the tail can have some unexpected side effects if a program is
>> reading the content beyond the head skb headlen and all the skbs in the
>> gso frag_list are linear with no head_frag -
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index bb0136e..d5f7f79 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -1654,6 +1654,20 @@ static DEFINE_PER_CPU(struct bpf_scratchpad, 
>> bpf_sp);
>>   static inline int __bpf_try_make_writable(struct sk_buff *skb,
>>                         unsigned int write_len)
>>   {
>> +    struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
>> +
>> +    if (skb_is_gso(skb) && list_skb && !list_skb->head_frag &&
>> +        skb_headlen(list_skb)) {
>> +        int headlen = skb_headlen(skb);
>> +        int err = skb_ensure_writable(skb, write_len);
>> +
>> +        /* pskb_pull_tail() has occurred */
>> +        if (!err && headlen != skb_headlen(skb))
>> +            skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
>> +
>> +        return err;
>> +    }
> 
> __bpf_try_make_writable() does not look like the right location to me
> given this is called also from various other places. bpf_skb_change_tail
> has skb_gso_reset in there, potentially that or pskb_pull_tail itself
> should mark it?

Actually the program we used had BPF_FUNC_skb_pull_data and we put this 
check in __bpf_try_make_writable so that it would help out 
BPF_FUNC_skb_pull_data & other users of __bpf_try_make_writable. Having 
the check in __pskb_pull_tail seems preferable though. Could you tell if 
the following is acceptable as this works for us -

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index dfc14a7..0f60abb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2263,6 +2263,9 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
                                 insp = list;
                         } else {
                                 /* Eaten partially. */
+                               if (skb_is_gso(skb) && !list->head_frag &&
+                                   skb_headlen(list))
+                                       skb_shinfo(skb)->gso_type |= 
SKB_GSO_DODGY;

                                 if (skb_shared(list)) {
                                         /* Sucks! We need to fork list. 
:-( */

> 
>>       return skb_ensure_writable(skb, write_len);
>>   }
>>
> 
