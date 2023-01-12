Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55722667F96
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjALTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjALTrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:47:13 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDB726FA
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:42:13 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C8mgXx003649;
        Thu, 12 Jan 2023 19:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=iEGMRVvIQI0obzGwfLBAiL+AxKgDH0y3smlFToYQtok=;
 b=WWB83xlxizIx5uD98hb13zfzU9ALxCoIlxrbSkWL7GYOkb//+u96TU423PTh+nkBTdDk
 08+DDdAYTbUCd5DYxzsd6XcuIu01f/FJuKT2N0GUDNHqfLB4EJrJb/2TlKPw5Z6fp2yo
 rI7AV5Th7gW537gLtFt6hTcbiCRrW9VQl6tKMDy8BS8MCS6Q2LYTpX3POpkL3d8FDgAX
 a5WK0VnsTyiHoui4Nb5lzt88ONRG0RQ6KFg9RT2e+w3sG9bJsrE9USr8K3qnO/R1e5Rq
 ugQRMGz2eyX2q82+Aqjkp8H1oRl1zlJngvXSSHxEYcTRcBmokOEw3EEQ6wlApp+U47d4 dA== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3n1kxhmwhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 19:41:59 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 30CJfwcA022022
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 19:41:58 GMT
Received: from [10.110.94.155] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 11:41:56 -0800
Message-ID: <d5bbfae7-e7bc-0f07-a014-653cfd9ad23d@quicinc.com>
Date:   Thu, 12 Jan 2023 12:41:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v4 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
To:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>
CC:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>
References: <20230111130520.483222-1-dnlplm@gmail.com>
 <20230111130520.483222-3-dnlplm@gmail.com>
Content-Language: en-US
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <20230111130520.483222-3-dnlplm@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: TNMyPfKbqjPb1jMPZ2z3FWa_IxIxwFkh
X-Proofpoint-ORIG-GUID: TNMyPfKbqjPb1jMPZ2z3FWa_IxIxwFkh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_12,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=933
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120140
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2023 6:05 AM, Daniele Palmas wrote:
> Add tx packets aggregation.
> 
> Bidirectional TCP throughput tests through iperf with low-cat
> Thread-x based modems revelead performance issues both in tx
> and rx.
> 
> The Windows driver does not show this issue: inspecting USB
> packets revealed that the only notable change is the driver
> enabling tx packets aggregation.
> 
> Tx packets aggregation is by default disabled and can be enabled
> by increasing the value of ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES.
> 
> The maximum aggregated size is by default set to a reasonably low
> value in order to support the majority of modems.
> 
> This implementation is based on patches available in Code Aurora
> repositories (msm kernel) whose main authors are
> 
> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Sean Tranchetti <stranche@codeaurora.org>
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> Hi all,
> 
> in v4 I should have met all Paolo's remarks, besides the one related
> to removing the scheduled work, since according to my understanding
> of the code in dev_queue_xmit it's not possible to avoid the
> WARN_ONCE when called directly from the timer function.
> 
> Context at https://lore.kernel.org/netdev/CAGRyCJGHSPO+i_xKHGbNg+Hki5tQC3_6Kc8RNcHWN6pxQdjODw@mail.gmail.com/
> 
> v4
> - Solved race when accessing egress_agg_params
> - Removed duplicated code for error in rmnet_map_tx_aggregate

Hi Daniele

I see that you are calling dev_queue_xmit from the worker thread context 
only so I assume you aren't running into any warnings anymore.


Reviewed-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
