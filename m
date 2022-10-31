Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B95F613E62
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 20:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJaTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJaThq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 15:37:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B42213F7C;
        Mon, 31 Oct 2022 12:37:18 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29VIA18o009806;
        Mon, 31 Oct 2022 12:36:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=IzeHw3OH1Z60P630CD5x1jMkdYyasJ2kWkvDSVnrPkM=;
 b=nxasd5++m0JtaS2asiyorv84uGfAWURyVJDabG1OSvUqwMpC09ynLXUgjUsVlo04EDXl
 V6yzBNe22NtNr1TGX30TS8Flm0RVDNgl+05FTjs6+JtxPGRCIwvFKXRUAPU66ooMq/fB
 cxasUVjntVyRwEwAP1DjtP9+Vj0icGaWu6c3SsPtaSACK8G6GHBcIfok1ykZ8ZmZQrbP
 Z7OV958QnBSPrWWnTWBh6hG62Ex3oysMAGmgAQnO99Rb/QFOeCTH0n48umFhBls8sL5a
 +WjekJn1qE1lCBa4uPXm2iYCl5BOgEIoGH9BYPPtQ5NxcgrpQI5nkJxde5OA2MDzjYIc sw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kgyux2rp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 12:36:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiWApkqNiCmP4jhL1ywoCpqN1x3ONcpMam2riyF6KUJ5+6JyTMF5ah0UFVyR2XWpmiYmrU+MrX1eMhUsUo8vDjYaeo7bUZeVSCqmVc9f9uxrmw+vCS1TnqLe96ZJAVFFlTj4CpNjbGfAgspgM6hcj/SYaT8TPPxJ9XxDLYo6dzGgz/Z1uZ5OmytzRJnfPbIwWL9re+UAiJ9Ckh+eFUbC0rVM9StHPdZR1Z9OcX371Dj8UUv/pFf3MWuGPeMQ/x0ds2wnbQHaYDrQCRUUAijUohYyIJxIiEe3mBUW10Kc1Hp1MKtjaTghjLPwLKaB+ymNKNZIQizjKDj8xsTiViFCfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzeHw3OH1Z60P630CD5x1jMkdYyasJ2kWkvDSVnrPkM=;
 b=jfueU9+rZUnGdTBAtykkrK0rnXet4dbwb0UjSbYxSEXJoUfiqNXIKK6rogNckYSRPk/+P1dU9iTtIJKB7uwi4RJ3NghujeAW1tkkAccAxWFyI4xYT+ighvXPvcIrN5HJKW/uwsI5gBJYnNXPdvEpijXwJA/ac+Oz2BMfwl1tB8U1jHaNAIQV9YY/8Z6Kj9l5xWnPnxgB1EOy8wQ+fiTsbtcwwmnVlD04g5wA7ScVoGHgqDZ7BNKwieSj/t/MMCjFAeObl1ZKcIMt+XaIsvHgCqeGiR3ROpbAFUp+IqouR7bPptdoi11l1gAiEWrTGzS09mm9hgy7AOv+glUzfguvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2331.namprd15.prod.outlook.com (2603:10b6:5:8d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 19:36:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e25d:b529:7556:1e26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::e25d:b529:7556:1e26%5]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 19:36:45 +0000
Message-ID: <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
Date:   Mon, 31 Oct 2022 12:36:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
Cc:     "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "sdf@google.com" <sdf@google.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <875yg057x1.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB2331:EE_
X-MS-Office365-Filtering-Correlation-Id: a976f06d-0804-4ed0-d2e7-08dabb773ec7
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmnMIkUvJyP2yyvI+wyXpy7pmLKyz76gF0LGtRK7zq3O728n7/wWI9kdAiilKV1ZACAlsXzVNZWBJjnsC+QeY1AH36yhkHB0gxvlgI0caWZhS2eamdvZDZvBTNzInKqaFu2GKr24xgzcuxdr0wVxZKGXXNFo8szCvfs4hp1CePMFskQTvg6MLl17daImk2B5hdS4sppapquWWyIUAp5jvkv3MmjXZeeiknE3aLZAEIE10tGMj2YRjOHxssVGKVs4NQEdaRUt1amikXparqjB+M11qC60smxJmNbKdso/+JIOJSOFizNnPdmFWv3tbv8x2WcxElVP176W/l407PhsdGhbc0cN1Qkhmlir03aZT8HZasL+PT9NS/NZA+XTFkdVteegX9qSPVKul9ZRhHrOR/WKjAKCRVwCSxjZlCp6sansa56EaMN4Ytn7sEv4EdDxZGSnAG3QEUOV32rGlGgQyP9nHg8kgWut6TAsTaNyJU6idE8Hazfvy+JNIb3rwVPWjulkrmB2qU5ms9Nuuh59OgDv6uVu4xuGXThE2714KDG+SgONUl9kVyVdOWaJNAu/Zx7751e6K+V5HMmD0x9N8VXoaYVPsDBHK39b9XLnG0Ezu1fHWvQ3Kxx4jXtkkq7Xzbt576631lou0+atE02ogHVlt7nYOcJXt4bM9DbFlnjQ9GtCSdICO8oYaP8qiLuOlE4L3nNrDpBDU2L8TRDEXAyGsPXW4TTjSoejyDzHiD4lldS97mbpQaZsHP08+mouRAp16DFyigyFn9drbid6D5XD+r154vnHCqP6mNA0QYM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(478600001)(54906003)(2616005)(36756003)(4326008)(8676002)(41300700001)(5660300002)(7416002)(8936002)(66556008)(66476007)(6486002)(66946007)(110136005)(316002)(83380400001)(53546011)(86362001)(6666004)(6506007)(31696002)(6512007)(66574015)(186003)(31686004)(38100700002)(66899015)(2906002)(4001150100001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjNHajdxVktDZDY5MjJ6N0FLbG9JdHpUNUJLWEt4anRkSWwxalJoM0RUNU1H?=
 =?utf-8?B?cmpDSVNuVENqc2hMNDYzKzNLUStMSWkyZSs0ZWlwOWxoNWcrWjZHZUtWazZa?=
 =?utf-8?B?MDJnNnRSWFVIZHhZVUtYWW05YnlHR3p5SG4vbUVOVTRqeCtFekhCbnVtNDRn?=
 =?utf-8?B?ckpFZElFSkpacER0Z3Y3ajF2TVZRU3NIQ3ZmcnE1eFBzaVJsZGlWekcxRSth?=
 =?utf-8?B?UGh0NGc2cTBZb2J6SmgrNGVxbUV1SitkTUtJdFliMzZIQk1JTWxaUTh4UG94?=
 =?utf-8?B?TDBaWnFqNXN0Y2p4NU5Vd1JEeCtDaDBXaXR6azZieERDcXlmKzNUZWE5SnBO?=
 =?utf-8?B?Z2ZKdFc4QnRzUDNwSGhQbEJBTVdKcG1HZ0JPSTE1Q2NOZ09yYkFEWWE1aWRQ?=
 =?utf-8?B?aW1IZDlUeVVSN25NUkU2dnV1SXZNQjFSR2xWTjlSMktGYkVuN0NHNFdRVTFa?=
 =?utf-8?B?R2tjWnRrcTFSR01DY3NST0FIeVpSZ1Myd2p6a0xKWWNQbXNXVHIvaTdlTVM2?=
 =?utf-8?B?aDJXOFVOYlc1ajIvY2llWGdkY1Qya0tTOFpGTUNlSWU0cEI4Nm5pRlZySUdF?=
 =?utf-8?B?Uk9qdkpFSGN3cU9LbXFBL3p1NStSbk9WM1RPSFRnWFV0NEp5dFlUL2RSYkww?=
 =?utf-8?B?NCtPbURHU1NrbWU2czkzTmo5SVhBUmVzNXl6UWozRTdkT2JjeHRWanlZcTVt?=
 =?utf-8?B?WGtoT1A1WHhqRmNkQ0xESTgzeDloNlRBZHpoRW00MklBaW9CaHhCRldTNkNS?=
 =?utf-8?B?YW5nTGZkVnFtbmpwSzRWbVpuZmNQaW5JWEF2WnpxTVNXNGxRam1ML0pHNnZk?=
 =?utf-8?B?TGJ2eGtMZjRuM2gvR1hKNEJIaGM1MTE3dGZ6cEZESFNYRm04bURoMjJ5V1Nh?=
 =?utf-8?B?OXVDSk81QnBleCtTeEtNVEl2bDc2enZTZmZqTVFzZ0hteERVUXN4RllvWmNN?=
 =?utf-8?B?eXY0dzVjSWR4S0IyVGMvRjVkMnBYNXo2MlFSdlozb004M2VQbERZY1d3dHkz?=
 =?utf-8?B?Sjh5OU1CTTcxMXd5RUNQdHMvSThldHErcHBSVXpzQkh2NkxSM3RURlE3ZWYv?=
 =?utf-8?B?QjhyaHBFR0N3bWF4cE8xNlc0eXd0OHNScWJ6ZWQ0Zm9odjF2Y2ZBb2p5eUhi?=
 =?utf-8?B?QzBoV0RsSnNNRlkyclNyaHZST25TcWp5ZDZuVXlSSCtLdnJFbTUwTWtPVHB3?=
 =?utf-8?B?WER5RkRMYjI0LzhucjJZVU1peVgrcnFsUkFXRUdLZHZBTzBUeHBzeGpZMEhM?=
 =?utf-8?B?RXBUVDUyNVJRYnAzSUpTdHZnUHdOT0VoSkdpTGpkTTNFVDh6c0U5a0FZamxY?=
 =?utf-8?B?SEk5N0JWZ3FZQzdYWG44OHpmVC9YeHlCbDlleThzekxoWlJuY3dXN3ZJMHcv?=
 =?utf-8?B?THp6NXR4TENoZEhzOUp1MTRKMUEzNHRySnMrK0lYTjAwWDZBdmdUVDk0dDEx?=
 =?utf-8?B?STNWNTdIQWRKVWJ5VFlzaVRwVHdacUo4Wk5MTUNWWkNHYmtYWHNNWHFMQjJF?=
 =?utf-8?B?ZDFiNXBkOXlCdm5XdXRXT0x2VUE2RTBDazFGOEI0U00zalNLaXVyVzljYWNn?=
 =?utf-8?B?c2lEUWZmQ1JwYlY1SlkwY01aY3lTVlRvcm9SS2Q3ek52OUNjQ0M4bXd6bHd6?=
 =?utf-8?B?MjZsaGU2cVcrdkt4VEVqVU01b2JCTm9NdlhpcFhGbExiWG1LdVlsL0hQZmxv?=
 =?utf-8?B?VFAvcHpNT05KRzBaNVBaSmxJKzFyODFNRTRUaHVhemRmcDRIc0U4SlN4Ulh5?=
 =?utf-8?B?UVpNMUZGZmExM1hVbGN2N0Z3elpqR1dFNlIrQXNZa1dwQ0l3YlByYkQ4Z1Mw?=
 =?utf-8?B?OHRLVmFFUkFPTHdyWDhJWEsvVHlSUnJTY0ZTOXo2YW1OWm1UU3NBQmNHMnVD?=
 =?utf-8?B?TXBzNEs2Qk53ZlhaeW5GRE9uTk5uaklwaXlpamJmeWpITDBDT3NKVnEvOHJI?=
 =?utf-8?B?bVdLMHVLTXZRUEFyNmwra1RSVy9OZGZ1dThDN2tMcHlBRkdvMEMxVGRqMVVs?=
 =?utf-8?B?M1dwMHpXb0RGZUwzMEhYdnd3aVNiYkJTRktzTzRwdkZTMzAxS0Rhb3Fvdjl4?=
 =?utf-8?B?dVo5aXhnVTRsOWxnSUxCVDlHRkVNVmd6MUNnMHVmUkJYTFRKQmhCUHpXRlFX?=
 =?utf-8?B?eEtNYnJHcXB3YXh0bDN3dW5qNWVHOCtJUXB4ZnQ3NHI5ZHZHdU1QZTRETjA0?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a976f06d-0804-4ed0-d2e7-08dabb773ec7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 19:36:45.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJ6Xs2h54XZUkhbIljndaByFf2ODshOI+8s1ZoMdC7hEjHPB9AjQfI+xh7o7nkz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2331
X-Proofpoint-ORIG-GUID: _IjqWFLEZnLRLp87KjLIRg-6BYkGpqe_
X-Proofpoint-GUID: _IjqWFLEZnLRLp87KjLIRg-6BYkGpqe_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_20,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/22 8:28 AM, Toke Høiland-Jørgensen wrote:
> "Bezdeka, Florian" <florian.bezdeka@siemens.com> writes:
> 
>> Hi all,
>>
>> I was closely following this discussion for some time now. Seems we
>> reached the point where it's getting interesting for me.
>>
>> On Fri, 2022-10-28 at 18:14 -0700, Jakub Kicinski wrote:
>>> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
>>>>>> And it's actually harder to abstract away inter HW generation
>>>>>> differences if the user space code has to handle all of it.
>>>>
>>>> I don't see how its any harder in practice though?
>>>
>>> You need to find out what HW/FW/config you're running, right?
>>> And all you have is a pointer to a blob of unknown type.
>>>
>>> Take timestamps for example, some NICs support adjusting the PHC
>>> or doing SW corrections (with different versions of hw/fw/server
>>> platforms being capable of both/one/neither).
>>>
>>> Sure you can extract all this info with tracing and careful
>>> inspection via uAPI. But I don't think that's _easier_.
>>> And the vendors can't run the results thru their validation
>>> (for whatever that's worth).
>>>
>>>>> I've had the same concern:
>>>>>
>>>>> Until we have some userspace library that abstracts all these details,
>>>>> it's not really convenient to use. IIUC, with a kptr, I'd get a blob
>>>>> of data and I need to go through the code and see what particular type
>>>>> it represents for my particular device and how the data I need is
>>>>> represented there. There are also these "if this is device v1 -> use
>>>>> v1 descriptor format; if it's a v2->use this another struct; etc"
>>>>> complexities that we'll be pushing onto the users. With kfuncs, we put
>>>>> this burden on the driver developers, but I agree that the drawback
>>>>> here is that we actually have to wait for the implementations to catch
>>>>> up.
>>>>
>>>> I agree with everything there, you will get a blob of data and then
>>>> will need to know what field you want to read using BTF. But, we
>>>> already do this for BPF programs all over the place so its not a big
>>>> lift for us. All other BPF tracing/observability requires the same
>>>> logic. I think users of BPF in general perhaps XDP/tc are the only
>>>> place left to write BPF programs without thinking about BTF and
>>>> kernel data structures.
>>>>
>>>> But, with proposed kptr the complexity lives in userspace and can be
>>>> fixed, added, updated without having to bother with kernel updates, etc.
>>>>  From my point of view of supporting Cilium its a win and much preferred
>>>> to having to deal with driver owners on all cloud vendors, distributions,
>>>> and so on.
>>>>
>>>> If vendor updates firmware with new fields I get those immediately.
>>>
>>> Conversely it's a valid concern that those who *do* actually update
>>> their kernel regularly will have more things to worry about.
>>>
>>>>> Jakub mentions FW and I haven't even thought about that; so yeah, bpf
>>>>> programs might have to take a lot of other state into consideration
>>>>> when parsing the descriptors; all those details do seem like they
>>>>> belong to the driver code.
>>>>
>>>> I would prefer to avoid being stuck on requiring driver writers to
>>>> be involved. With just a kptr I can support the device and any
>>>> firwmare versions without requiring help.
>>>
>>> 1) where are you getting all those HW / FW specs :S
>>> 2) maybe *you* can but you're not exactly not an ex-driver developer :S
>>>
>>>>> Feel free to send it early with just a handful of drivers implemented;
>>>>> I'm more interested about bpf/af_xdp/user api story; if we have some
>>>>> nice sample/test case that shows how the metadata can be used, that
>>>>> might push us closer to the agreement on the best way to proceed.
>>>>
>>>> I'll try to do a intel and mlx implementation to get a cross section.
>>>> I have a good collection of nics here so should be able to show a
>>>> couple firmware versions. It could be fine I think to have the raw
>>>> kptr access and then also kfuncs for some things perhaps.
>>>>
>>>>>> I'd prefer if we left the door open for new vendors. Punting descriptor
>>>>>> parsing to user space will indeed result in what you just said - major
>>>>>> vendors are supported and that's it.
>>>>
>>>> I'm not sure about why it would make it harder for new vendors? I think
>>>> the opposite,
>>>
>>> TBH I'm only replying to the email because of the above part :)
>>> I thought this would be self evident, but I guess our perspectives
>>> are different.
>>>
>>> Perhaps you look at it from the perspective of SW running on someone
>>> else's cloud, an being able to move to another cloud, without having
>>> to worry if feature X is available in xdp or just skb.
>>>
>>> I look at it from the perspective of maintaining a cloud, with people
>>> writing random XDP applications. If I swap a NIC from an incumbent to a
>>> (superior) startup, and cloud users are messing with raw descriptor -
>>> I'd need to go find every XDP program out there and make sure it
>>> understands the new descriptors.
>>
>> Here is another perspective:
>>
>> As AF_XDP application developer I don't wan't to deal with the
>> underlying hardware in detail. I like to request a feature from the OS
>> (in this case rx/tx timestamping). If the feature is available I will
>> simply use it, if not I might have to work around it - maybe by falling
>> back to SW timestamping.
>>
>> All parts of my application (BPF program included) should not be
>> optimized/adjusted for all the different HW variants out there.
> 
> Yes, absolutely agreed. Abstracting away those kinds of hardware
> differences is the whole *point* of having an OS/driver model. I.e.,
> it's what the kernel is there for! If people want to bypass that and get
> direct access to the hardware, they can already do that by using DPDK.
> 
> So in other words, 100% agreed that we should not expect the BPF
> developers to deal with hardware details as would be required with a
> kptr-based interface.
> 
> As for the kfunc-based interface, I think it shows some promise.
> Exposing a list of function names to retrieve individual metadata items
> instead of a struct layout is sorta comparable in terms of developer UI
> accessibility etc (IMO).

Looks like there are quite some use cases for hw_timestamp.
Do you think we could add it to the uapi like struct xdp_md?

The following is the current xdp_md:
struct xdp_md {
         __u32 data;
         __u32 data_end;
         __u32 data_meta;
         /* Below access go through struct xdp_rxq_info */
         __u32 ingress_ifindex; /* rxq->dev->ifindex */
         __u32 rx_queue_index;  /* rxq->queue_index  */

         __u32 egress_ifindex;  /* txq->dev->ifindex */
};

We could add  __u64 hw_timestamp to the xdp_md so user
can just do xdp_md->hw_timestamp to get the value.
xdp_md->hw_timestamp == 0 means hw_timestamp is not
available.

Inside the kernel, the ctx rewriter can generate code
to call driver specific function to retrieve the data.

The kfunc approach can be used to *less* common use cases?

> 
> There are three main drawbacks, AFAICT:
> 
> 1. It requires driver developers to write and maintain the code that
> generates the unrolled BPF bytecode to access the metadata fields, which
> is a non-trivial amount of complexity. Maybe this can be abstracted away
> with some internal helpers though (like, e.g., a
> bpf_xdp_metadata_copy_u64(dst, src, offset) helper which would spit out
> the required JMP/MOV/LDX instructions?
> 
> 2. AF_XDP programs won't be able to access the metadata without using a
> custom XDP program that calls the kfuncs and puts the data into the
> metadata area. We could solve this with some code in libxdp, though; if
> this code can be made generic enough (so it just dumps the available
> metadata functions from the running kernel at load time), it may be
> possible to make it generic enough that it will be forward-compatible
> with new versions of the kernel that add new fields, which should
> alleviate Florian's concern about keeping things in sync.
> 
> 3. It will make it harder to consume the metadata when building SKBs. I
> think the CPUMAP and veth use cases are also quite important, and that
> we want metadata to be available for building SKBs in this path. Maybe
> this can be resolved by having a convenient kfunc for this that can be
> used for programs doing such redirects. E.g., you could just call
> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
> would recursively expand into all the kfunc calls needed to extract the
> metadata supported by the SKB path?
> 
> -Toke
> 
