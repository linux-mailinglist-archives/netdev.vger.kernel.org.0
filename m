Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3D623048
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiKIQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiKIQhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:37:09 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A12B24F12;
        Wed,  9 Nov 2022 08:37:00 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A9CWUXo000910;
        Wed, 9 Nov 2022 08:36:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Mnip8WJefAVXZZAMV/SMgRQL+wmLM/UOAsCyA01i0hc=;
 b=fWbOOVDS9mTo5mUIsX1YaBfmq8yZ8gxhwX0BU9TI3EvFxfL6DfAjI4ynjAixkej/EyIk
 olPrQyrZgwOM5ccIaj36OaTgiTSaMP2yjpIne6d/m44gVW6kidhHkcgeGQdu52vNlbF1
 hIeZQ3jQcyZ0DFF3SZU02GYjRyoaO/pM2dJ1OCayK2FKF9QrJKJSBWBKA5RbftulqBrU
 1oS6pjUtWE651To75p1im62CcCBDTeR19l3rKdRfopMqPa3H5C/wVwAm0LUu9bWoY3E3
 noXuKBQyHKWzKoRrZUX/Jgee68ghAmBgi2T0Pn/YyHq758YorbHWLRdgyGT2ZJY/77T3 dw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by m0001303.ppops.net (PPS) with ESMTPS id 3krca32019-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 08:36:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUcSRiR88MK3onlraYsum1DFmapdu2R6eSoGx+ORpi0WRyQ10t9Fhpiojot/+WdELzQQtjHi6A+rDFnGfEytXYPYzcuQeOEXKNbcSX6ZeHHwpbRbTVVL1ACn0gNOoHU9mhcgBUgJbTFV92aTHB6ayAwtF+PKr3lBFiR7iprs6k4J1I/PDIVC0uKAdA/z20dOLh9j6JlAJXtp8842mzMvSqeIWVr1dE8Nlt/4G5HqraiPxUH5F9oWQzTa1E3Nf1QwTTI/eOGcpVNYOjgleqjd0i6/8cF3ut0t51BDAQKb2JFIal7YK1bvG+g+XRRxhVXjNHB9quSB13M2GovkWWDLhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mnip8WJefAVXZZAMV/SMgRQL+wmLM/UOAsCyA01i0hc=;
 b=VFheD7NifwwNOWIYnMlC0fCA24sA4JH9DozyZXWGoBQ4mx0C21ToU8hcVEkxWTBjfRgy8RBOKrtwASP15usra8l0bUSrNRHc8kgVUoz9FfXHdV0eiwer5JzmkqiJma6G9t9S2PB+7Rvyaozv0odNSCfhyqKfw1gP6mjyc+HQNrQOVCccHUpyjLGJrr1LZu5t4a2lNH6DbIQZVLbLoNxGILwig5CqRDRePdWZswGMSi2zmGMQSqBvhYoqibRTnpJqlj+no4gEUXdtKMNRLESHfTGpmGyoqwr5UfOFfKNsE6MJZvkLUZO+9d8zcCpvCTKS3CJV3vD87gavQcleF3HDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4501.namprd15.prod.outlook.com (2603:10b6:a03:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 9 Nov
 2022 16:36:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 16:36:40 +0000
Message-ID: <f536564b-973a-797c-7b8e-adaaa567de7b@meta.com>
Date:   Wed, 9 Nov 2022 08:36:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/2] net: remove skb->vlan_present
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, eric.dumazet@gmail.com
References: <20221109095759.1874969-1-edumazet@google.com>
 <20221109095759.1874969-2-edumazet@google.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221109095759.1874969-2-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB4501:EE_
X-MS-Office365-Filtering-Correlation-Id: 9916ed07-d6a6-4a24-3fe2-08dac270943b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBx8HMWvjArjfDS97VYSkdn9OdsbuoAwi2C1G7gWcSQm8SatHE6kXDbB04IXge3h+ufg9AatSR98LOrFb1Jn7ZondBRmvuCmScSiew8GFjPQQeM7MsdV47tvMbXSw45LgOqfjY8x7y5/JIsftSX3060r49Hut5rn9NZr5xcNBaQjEltRLSsKX4G4fYr+wzIyNmDwqgRrljLElAriAnSws7ndMH5p45miRXPiLEwGixrnOiUdcGICgdAjwM5pWdtf43HMGPxCcE8BPc3q0nppep0bBNokU8BqxZwylwlXSWfZXXxcU2WizVxjmwGt6MqCB77nKf1LoTmG9VPGLs3xIkYPBE6VKnt4EYmoPBI3K+iPnVsS0e8T/S07LVId/vsDSCerRtG/v4PZL1/iCm7efASh4ZJ0UpqnJA4z7BSM5zPjAaY6dwTdlgnaqIyzeRODmp4JiSlBBEUQ4CveE1Gyn/J0g4PI35eApyMpozbQWTfRUfsoAtPcF8xnjWIDq/ECDvGjihkLO/gkmyO6xHWXUi8iBWIOQ9ys/BRa5LOtwjN+mQQK1CfLjrNVsP+Reia/4mIRAvrfD10wTHxHQVpi0ZfOdw8TymbRCVDNEPfWG4L86CsJanx8FIQH7ityr6ecG7TtLT+6Y1rc31oN9NOQh723FCRohp54wLvXUvtHaT8vXfYDWxN+jox6tO0T/XjBJQ9OLq7SrAjM8fMb41qTYRfoOSPGN9B7z17YDDcRLaZObSJhQKwxQu354zmrU4X546zDtxqXsgvv4XF7EZiW9xYmfOKX4ALBFppJ32phFUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(6512007)(83380400001)(38100700002)(2616005)(6506007)(186003)(4744005)(7416002)(53546011)(2906002)(5660300002)(478600001)(110136005)(8676002)(6666004)(4326008)(41300700001)(6486002)(8936002)(66556008)(66946007)(66476007)(316002)(31686004)(36756003)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N20xd3hsMTNoUFgzTHhWc2UwNkZXQzZjWWs2a2FYeXBBc014citGRGJtVEJn?=
 =?utf-8?B?Q2ZUcE9oeHF5WTZVTEJkQjRCaFJkSG4xWWU0OXN1TVBIOHg2ZnVTbTRDZEFO?=
 =?utf-8?B?WGdSc1ZqS3dtWHBoalJvRzgrQWg3amtVSDNlN3lqZUtPL3FmQnJqLzNlb2xh?=
 =?utf-8?B?YlpQKzBvcUtrVDg1QWlicm04ejFzNTZFWjNOdXdpOTBXM0dRM091UEJVcTRB?=
 =?utf-8?B?eUVGdnpWYjRTNDVTcEVEU2xOZkd4OTlZUVlMZE9kM0hkaWZYdUxBSFVTSURn?=
 =?utf-8?B?ODNjZXVLTjNhUXBRRXhCVFZGV0liMzI3RDB4bnhMa3M1V0l2Q0d6WGtydldH?=
 =?utf-8?B?cm9XWlZyaHZUV1RWSURZTlJDQzFXdXFEM1JPa1BtSjJNZlM0MG50dzhDQ2Zu?=
 =?utf-8?B?Nkd3R2pDVkVQdHhvWjVObW5kRmZqSGs5bjRWSGYzQWNXUmh2U3ZSSkUvaXdo?=
 =?utf-8?B?NDl5Q2ZRNWtZMG9nYmM3Z0hZN2c5cGpnN25xaDdOeG4zMEhNQk9qZEdFYm1t?=
 =?utf-8?B?NEZVUXV4QU5iTHQ3N1JKYmpaV1QyWkFEWVRSZURxNElJM2xjSVV4azVILzBy?=
 =?utf-8?B?bytsMjV4Z3NyUlUxYkhrbFV0Z0FMSkxvZzR2UzN4eEZ0c1FxNFZSeWVwUjUw?=
 =?utf-8?B?cm5QWjBVZnFaUnAyMDFaSHdlK3p2ZHFTbnU5OGJXb1pQTDVKK0FZeGNjUCtl?=
 =?utf-8?B?MGUrYUZnZDVDQWJyb015eXFVUnNPWVEyRnJuZy9HalRKMk8ydXkvZnRwakNh?=
 =?utf-8?B?QmxQUldTZFBJcVNDNE9GaFVGTU1lY2tDNkpwVVVNdDNlQkN1aTRWVDgwN2hj?=
 =?utf-8?B?MmoyTVJ4NTg0Y2Z4dTBTU1RlWkhVZERWNnJtOXVLYXg1TjljVlB5aFlOYjdy?=
 =?utf-8?B?L3l5MDloTXFnR2lXWm1OSEtkRy9pVmVwMENhU0tJbDd2RG40YXRrdjhCeUxr?=
 =?utf-8?B?cnZzY3ZNTXVwMTZqTFl5N0hXbyt5aWM4WmxBWmszekZkN0MwQjhQLzd4VVl1?=
 =?utf-8?B?S3BSYWpiSzg3a0ZqZGIycHVQUUR2YlhJd1BObm5TMGdtaW9oZzMxY3g5NDJY?=
 =?utf-8?B?WGh6cytOb0NTRjd0Ujk5dlRtdG4ra0MzakE3ZzV3cHVsRS9ENEtUdjQ1Wmdk?=
 =?utf-8?B?cHRYZkhOQlBRR2F6anZyNkFuNU4zSlp0aTBUb0pRaW5iNkNqa0hyUWU4c0s0?=
 =?utf-8?B?Yi9RV0RkNk8xUjl4SnpEbWIwWGErWW5XeGFlbHRVYW9pcTVmVzhnWmtnamc2?=
 =?utf-8?B?amZxYzdzVHByUW5wZHN0dnFFQlVsQXF5VUtEeG5YRXZydFJJRDIvbDZ3TXhh?=
 =?utf-8?B?Uzh0QzdwMVRMdHo0RnYrdzMyeUJzdWxqNTVveHlRSlNMb0FYYjEvTUdYVkFl?=
 =?utf-8?B?c1ZDYThvWGc1Z1Vnc1dUWXo2KzM0VGNxU01OelUxbzU5UzFiVEFHOTU4NG85?=
 =?utf-8?B?SGluV0piQk5pVjJTdEgyejNPYkRPTVhTR0hYTCszblo5UnhMcEkrRGV4NDRD?=
 =?utf-8?B?SHpSaVV0ZVVKVXAzSm0vYktDbi8rZkE3c2ZNeDVQZE10MHY5VlYwY0Y4QlBD?=
 =?utf-8?B?THBXNzJRdDJMazdNdEtoMmpKcWoyRkk5YjNmVllXT0ZxV2xuNXFlSXNkOEFM?=
 =?utf-8?B?emxKWlAxcFJ3R3g4NWRzQkpmSVVnaDV4blVyU2FoWW5YNGVkckx2dUJXZ0Vy?=
 =?utf-8?B?UmdmOFFNZWFnOHcxNk1RcDBRdytWYUdzdzUvQkdLd0kweG5odXRqRkJodDlp?=
 =?utf-8?B?MEl4aHdPbTJLOFJLM3ZOeUxObS9xNCtIdmIwV1p1Nm0rc1JSWW5GYkNpOHdv?=
 =?utf-8?B?eHNsNVJBZW9zKzBQczdzNXcwN1VHVzRzVVZMdGlXRWk1YnB0c3FrR1p0bDNX?=
 =?utf-8?B?VFpIMnNRb2E4c05xaUxOUFNRMlZzVXNwbWxpam51emVEbUs1WldKbmlGWHBE?=
 =?utf-8?B?UFMrT2pTa1VyVXBBdGZtbFFNZ0grcHBwajdUV2pqaktrZ2JidVFpYkJSTElB?=
 =?utf-8?B?RFdXOHBFYzNnVHI0bjNHUW9UM2Zoa0xqYTVzZWZnOEx4RVZid1pPVGRnUHoz?=
 =?utf-8?B?M2lFRWZEb1JhSHdUdEpYTFhjcXQyb3lYcUF1RDF5OUlEVFcrckdoQS82alZz?=
 =?utf-8?B?TWl0aEh6UWpzUHpoY0Y0N01zM3FCYk55N0RnWUIwTW5KaGtHTEw2MXJtaG9C?=
 =?utf-8?B?a2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9916ed07-d6a6-4a24-3fe2-08dac270943b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 16:36:40.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uX1kKrWYv0dsWGDTsYEDwr2TJDrjxbKnofs+b+bCh26qFssGB6W44talfKGW0DG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4501
X-Proofpoint-GUID: SYGwkaUb47TXNejDXY3ghwY8UlP0-v82
X-Proofpoint-ORIG-GUID: SYGwkaUb47TXNejDXY3ghwY8UlP0-v82
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/22 1:57 AM, Eric Dumazet wrote:
> skb->vlan_present seems redundant.
> 
> We can instead derive it from this boolean expression:
> 
> vlan_present = skb->vlan_proto != 0 || skb->vlan_tci != 0
> 
> Add a new union, to access both fields in a single load/store
> when possible.
> 
> 	union {
> 		u32	vlan_all;
> 		struct {
> 		__be16	vlan_proto;
> 		__u16	vlan_tci;
> 		};
> 	};
> 
> This allows following patch to remove a conditional test in GRO stack.
> 
> Note:
>    We move remcsum_offload to keep TC_AT_INGRESS_MASK
>    and SKB_MONO_DELIVERY_TIME_MASK unchanged.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Ack except the sparc jit part:

Acked-by: Yonghong Song <yhs@fb.com>
