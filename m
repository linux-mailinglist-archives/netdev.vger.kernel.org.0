Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29FB631597
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 18:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiKTRsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 12:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiKTRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 12:48:50 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67C1FCD9
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 09:48:49 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKHdBEW026195;
        Sun, 20 Nov 2022 17:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=KTw8KufSe9ZhSbF0TKh+YET65hCSlBtpIEg/bZEEvCQ=;
 b=cJPTRW/XzBbjX9LDEl/ra2PquwBAwaxVxNWsL6B1yToompAwDODkAcoLdZKrj88ak3CK
 mkasD0rbVS2LOBF3+zzMuTqmkUd2x3ozq0CWIB0xBDOemnFm5DwmmcD73s7WflU0p/W+
 FA2qBqGaZ+KtrF6nYswQClEVIKPQMeidm5oYH7juymtd1hL42fqQg4GWOL33G7p9Dow5
 WNhBkPSJ48nqUI+W0Gy/7aGya9PFYS/d46EaNKm/TPH8o7Hj0tCRRu9/xy6zrsLiUN+L
 6olrORnbhQQ/IAUsaJC3Pud8mr2O2ZtL/5q5QNDrp0UUHj7NK57LkNdOcgRFSBgYokUW eA== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kxrtqak8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Nov 2022 17:48:36 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2AKHmZwR023545;
        Sun, 20 Nov 2022 17:48:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3kxr7kc3pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Nov 2022 17:48:35 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AKHmZV5023540;
        Sun, 20 Nov 2022 17:48:35 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 2AKHmZrN023539
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Nov 2022 17:48:35 +0000
Received: from [10.110.3.170] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 20 Nov
 2022 09:48:34 -0800
Message-ID: <80e0a215-4b63-3ff9-3c31-765dbba5e7bb@quicinc.com>
Date:   Sun, 20 Nov 2022 10:48:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
To:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
CC:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>
References: <20221109180249.4721-1-dnlplm@gmail.com>
 <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com>
 <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
 <20221116162016.3392565-1-alexandr.lobakin@intel.com>
 <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
 <87tu2unewg.fsf@miraculix.mork.no>
 <CAGRyCJFnh8iXBCyzNxzxSp9PBCDxXYDVOfeyojNBGnFtNWniLw@mail.gmail.com>
Content-Language: en-US
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <CAGRyCJFnh8iXBCyzNxzxSp9PBCDxXYDVOfeyojNBGnFtNWniLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 3I-GyevftgnvJZLof6Ve0vLcn_B50hwB
X-Proofpoint-GUID: 3I-GyevftgnvJZLof6Ve0vLcn_B50hwB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-20_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxlogscore=706 lowpriorityscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211200151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/2022 2:52 AM, Daniele Palmas wrote:
> Il giorno dom 20 nov 2022 alle ore 10:39 Bjørn Mork <bjorn@mork.no> ha scritto:
>>
>> Daniele Palmas <dnlplm@gmail.com> writes:
>>
>>> Ok, so rmnet would only take care of qmap rx packets deaggregation and
>>> qmi_wwan of the tx aggregation.
>>>
>>> At a conceptual level, implementing tx aggregation in qmi_wwan for
>>> passthrough mode could make sense, since the tx aggregation parameters
>>> belong to the physical device and are shared among the virtual rmnet
>>> netdevices, which can't have different aggr configurations if they
>>> belong to the same physical device.
>>>
>>> Bjørn, would this approach be ok for you?
>>
>> Sounds good to me, if this can be done within the userspace API
>> restrictions we've been through.
>>
>> I assume it's possible to make this Just Work(tm) in qmi_wwan
>> passthrough mode?  I do not think we want any solution where the user
>> will have to configure both qmi_wwan and rmnet to make things work
>> properly.
>>
> 
> Yes, I think so: the ethtool configurations would apply to the
> qmi_wwan netdevice so that nothing should be done on the rmnet side.
> 
> Regards,
> Daniele

My only concern against this option is that we would now need to end up 
implementing the same tx aggregation logic in the other physical device 
drivers - mhi_netdev & ipa. Keeping this tx aggregation logic in rmnet 
allows you to leverage it across all these various physical devices.
