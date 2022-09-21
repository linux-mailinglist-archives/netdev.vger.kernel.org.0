Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657FD5C00A8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiIUPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiIUPDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:03:20 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FDBE03F;
        Wed, 21 Sep 2022 08:03:19 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LEmFgF025139;
        Wed, 21 Sep 2022 15:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Gafwz67+ODpZcuvjE8LnfUXj/jd3U3eu4qIzV4ikTl8=;
 b=Y0flJkg1IEOVvvY9SH9F1zLH/BY4v31j33Y5xF/ESQHjJCd8wyDTveF9H9XfqkTNo1rB
 6YOvAbiVOv84SHbp0f5DaZLWTKmURBKT2wVbGS0cJXTFRkEfspeVdyJ310MdC4z6WBwV
 TfSaJGBlOBHTzmkU87Dl7nu54kNP8xLAmK4W56VA+7PDLpWCSCuyQaUl0tvyVgdtmwON
 UgaLYBcWJRQwPqdFS5ONLOIxSChY2292BiAGosz6RX08gHsO3EJX/tWuT41sRfO6vfr6
 QVfOFq31Abdwob4sw87VLO8lU2avoFaGKQOsgtb94IjllxE7FmKdjbGB9tYdLUwC0Age 7w== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jr4ge027f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:03:07 +0000
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28LF36W9017921;
        Wed, 21 Sep 2022 15:03:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 3jnqpvp5q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:03:06 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28LF2O5n016796;
        Wed, 21 Sep 2022 15:03:06 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 28LF367s017908
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:03:06 +0000
Received: from [10.110.44.78] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 21 Sep
 2022 08:03:05 -0700
Message-ID: <f663ce29-72e7-7592-d4ef-d79fda1de102@quicinc.com>
Date:   Wed, 21 Sep 2022 08:03:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] cfg80211: fix dead lock for nl80211_new_interface()
Content-Language: en-US
To:     Aran Dalton <arda@allwinnertech.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220921091913.110749-1-arda@allwinnertech.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220921091913.110749-1-arda@allwinnertech.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: FVeE12kYZyXRtIPZWBLFT72VM7Dkuun0
X-Proofpoint-ORIG-GUID: FVeE12kYZyXRtIPZWBLFT72VM7Dkuun0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_08,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=874 adultscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210102
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/2022 2:19 AM, Aran Dalton wrote:
> Both nl80211_new_interface and cfg80211_netdev_notifier_call hold the
> same wiphy_lock, then cause deadlock.
> 
> The main call stack as bellow:
> 
> nl80211_new_interface() takes wiphy_lock
>   -> _nl80211_new_interface:
>    -> rdev_add_virtual_intf
>     -> rdev->ops->add_virtual_intf
>      -> register_netdevice
>       -> call_netdevice_notifiers(NETDEV_REGISTER, dev);
>        -> call_netdevice_notifiers_extack
>         -> call_netdevice_notifiers_info
>          -> raw_notifier_call_chain
>           -> cfg80211_netdev_notifier_call
>            -> wiphy_lock(&rdev->wiphy), cfg80211_register_wdev

In both of your patches please describe what you are doing in the patch 
to fix the problem, and in particular describe why your fix is safe.

> 
> Fixes: ea6b2098dd02 ("cfg80211: fix locking in netlink owner interface destruction")
> Signed-off-by: Aran Dalton <arda@allwinnertech.com>
> ---
>   net/wireless/nl80211.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 2705e3ee8fc4..bdacddc3ffa3 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4260,9 +4260,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>   	/* to avoid failing a new interface creation due to pending removal */
>   	cfg80211_destroy_ifaces(rdev);
>   
> -	wiphy_lock(&rdev->wiphy);
>   	ret = _nl80211_new_interface(skb, info);
> -	wiphy_unlock(&rdev->wiphy);
>   
>   	return ret;
>   }

