Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F23624F75
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKKBSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiKKBSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:18:32 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C363CE7
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:17:29 -0800 (PST)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AANdBrM008694;
        Fri, 11 Nov 2022 01:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=f2IsR4OpgZVQNXKpw9UIKxyZv7COQFaaENYI0vqgtRg=;
 b=l5urzZYxKjoUeHECX66rGNiLh3p4istsjGGb7RQ4NCuJUo7OKGwrgd3TRPkcTXdyfRzZ
 osfpBCiKrhpMFnsSnx23bVhmgsH4F7sfMibHu25escFyjSmWIP6S55Dz4dcoOlO2eG9+
 PeDxB5R1aqq5+bYDg0wT2ChlXCVeKTytYa3mP4rN9LLgn7rSxfHkW9Cp+APsRfsJ5KoG
 b0W5LQUJ7n3v2aRu0ybM10tcYikJzjLgEXVsl3g9IpJGvBCCQmx4rHK9kQxXvhxV9PQu
 brxMINdWtdP72uMepH/kV4aBdNZa6kn00/hfqM9smBViiyKuE28k+GzJDUFRGvH1w3LT mA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ksada08fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 01:17:12 +0000
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB1FgcC018063;
        Fri, 11 Nov 2022 01:17:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 3kngwkxvx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 01:17:11 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AB1HBRb019370;
        Fri, 11 Nov 2022 01:17:11 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 2AB1HBNr019369
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 01:17:11 +0000
Received: from [10.110.16.245] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 10 Nov
 2022 17:17:10 -0800
Message-ID: <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
Date:   Thu, 10 Nov 2022 18:17:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniele Palmas <dnlplm@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>
References: <20221109180249.4721-1-dnlplm@gmail.com>
 <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com>
Content-Language: en-US
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <20221110173222.3536589-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: hmY9-NZvrH6uo-k2wbbzcR_6Hi7jWln5
X-Proofpoint-GUID: hmY9-NZvrH6uo-k2wbbzcR_6Hi7jWln5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 mlxscore=0 mlxlogscore=917 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211110007
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/2022 10:32 AM, Alexander Lobakin wrote:
> From: Daniele Palmas <dnlplm@gmail.com>
> Date: Wed,  9 Nov 2022 19:02:48 +0100
> 
>> Bidirectional TCP throughput tests through iperf with low-cat
>> Thread-x based modems showed performance issues both in tx
>> and rx.
>>
>> The Windows driver does not show this issue: inspecting USB
>> packets revealed that the only notable change is the driver
>> enabling tx packets aggregation.
>>
>> Tx packets aggregation, by default disabled, requires flag
>> RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).
>>
>> The maximum number of aggregated packets and the maximum aggregated
>> size are by default set to reasonably low values in order to support
>> the majority of modems.
>>
>> This implementation is based on patches available in Code Aurora
>> repositories (msm kernel) whose main authors are
>>
>> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
>> Sean Tranchetti <stranche@codeaurora.org>
>>
>> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>> ---
>>   
>> +struct rmnet_egress_agg_params {
>> +	u16 agg_size;
> 
> skbs can now be way longer than 64 Kb.
> 

rmnet devices generally use a standard MTU (around 1500) size.
Would it still be possible for >64kb to be generated as no relevant 
hw_features is set for large transmit offloads.
Alternatively, are you referring to injection of packets explicitly, say 
via packet sockets.

>> +	u16 agg_count;
>> +	u64 agg_time_nsec;
>> +};
>> +
> Do I get the whole logics correctly, you allocate a new big skb and
> just copy several frames into it, then send as one chunk once its
> size reaches the threshold? Plus linearize every skb to be able to
> do that... That's too much of overhead I'd say, just handle S/G and
> fraglists and make long trains of frags from them without copying
> anything? Also BQL/DQL already does some sort of aggregation via
> ::xmit_more, doesn't it? Do you have any performance numbers?

The difference here is that hardware would use a single descriptor for 
aggregation vs multiple descriptors for scatter gather.

I wonder if this issue is related to pacing though.
Daniele, perhaps you can try this hack without enabling EGRESS 
AGGREGATION and check if you are able to reach the same level of 
performance for your scenario.

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -236,7 +236,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
         struct rmnet_priv *priv;
         u8 mux_id;

-       sk_pacing_shift_update(skb->sk, 8);
+       skb_orphan(skb);

         orig_dev = skb->dev;
         priv = netdev_priv(orig_dev);

> 
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 5e7a1041df3a..09a30e2b29b1 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -1351,6 +1351,7 @@ enum {
>>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
>>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
>>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
>> +#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)
> 
> But you could rely on the aggregation parameters passed via Ethtool
> to decide whether to enable aggregation or not. If any of them is 0,
> it means the aggregation needs to be disabled.
> Otherwise, to enable it you need to use 2 utilities: the one that
> creates RMNet devices at first and Ethtool after, isn't it too
> complicated for no reason?

Yes, the EGRESS AGGREGATION parameters can be added as part of the rmnet 
netlink policies.

> 
>>   
>>   enum {
>>   	IFLA_RMNET_UNSPEC,
>> -- 
>> 2.37.1
> 
> Thanks,
> Olek
