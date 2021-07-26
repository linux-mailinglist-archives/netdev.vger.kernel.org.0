Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE73D514A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGZByO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 21:54:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231529AbhGZByM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 21:54:12 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16Q2V1Ai029860;
        Sun, 25 Jul 2021 19:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1sR5B3AssH2/HN4m47DjHsrG20p+ixmHF2VCAJla13E=;
 b=qYAMPrn3prOtCBX9ilGNxEVg2LezvoA9+Oy3pjoOppBs0Y8zTYT77dMARhYt2063z192
 yLfmIGNb9UlNjzjqiryYg1KjIwekt0ZkddXab0bBSAXpraozlj738EL6HIOumnyXesLv
 eE98cQUqEM9NQ+FRyyT9AeepcD6jH5QNsx0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a0j67xmbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 25 Jul 2021 19:34:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Jul 2021 19:34:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzT/QWRtfKLVEy3iikCkEQ94MSrBxRT+47jNklKkRfluQpWGWDJcE5nIPRJhZMm+r3P08DTo9hth5qdfdwgki0JLive2eEsFKcNDWPE/UHCy/WnDjJwiWAUn+lfoe/n0CfDMCndvYdExfynUoxoxNMr+ucPzXAGA+i0rH2C8Eiu3ZVDElry6kCNxIklfN9z6iWvqKCO6CrgQ2GlG06avW2lxoJ7zDHJoH7E6RkZ8eZpBQzhQM3SWdZpCXUvlJT3PPZEb+s7ZegMpk+qoa4HAxUZKX6UXfx9VyOyajbMISwVTNgJjQTbEvTaGPjtSKKMmc9nAd1ue7Zj1z0AOclNu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sR5B3AssH2/HN4m47DjHsrG20p+ixmHF2VCAJla13E=;
 b=lcAAVpJVzg9itveVJoj226+HlNAcBOJtqJ8t1S3XocOg+zB8wG8fSVRYsUVPsMvcuulGJWF7tyU4yxVSu5+M0MqUKrSX/wcYv9adT+L+ym/Ds8Cc9ND+01vvw8IZNMqlCdvWg3KNJaFT2NneFM+ffrQqdTEm3mJC7TxtAbpqXZr9bhwD0MP+oD/1X9iOSFqM0rokwfq3FvEmE88r+9aT4kbJREM40mSGESy8HxhLKC1XImWvarze5POmkp/ZOEBjdYLrI1tgHR8AbuMRsWxA94oXMWEhEybwp5eDKJ5b1MczZdG21WAgpwGxDgJwLRxF2jHymmcV69QnuYzPQLzm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4417.namprd15.prod.outlook.com (2603:10b6:806:194::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 02:34:28 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 02:34:28 +0000
Subject: Re: [bpf-next 2/2] samples: bpf: Add the omitted xdp samples to
 .gitignore
To:     Juhee Kang <claudiajkang@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20210724152124.9762-1-claudiajkang@gmail.com>
 <20210724152124.9762-2-claudiajkang@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3152320b-bb48-f929-e686-d464358a0a6e@fb.com>
Date:   Sun, 25 Jul 2021 19:34:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210724152124.9762-2-claudiajkang@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:300:c0::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10b9] (2620:10d:c090:400::5:cf4) by MWHPR08CA0060.namprd08.prod.outlook.com (2603:10b6:300:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 02:34:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 452e2668-bcf4-4b76-542d-08d94fdde3fe
X-MS-TrafficTypeDiagnostic: SA1PR15MB4417:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4417D45E873413FA8473D4D3D3E89@SA1PR15MB4417.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:48;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OKfW9LcnaTtS18Hxn/h88QuDiKFOW5+nOa8/K/rf5lILys74nvah4/yW+HslJVFUSoLV+w6iK7871G8GCFKgL9OYyDylAuo4AE1AC5ZusGpesp9MSdqGwkHI8N1phnolp0yWpfSTVXW1gwyxVZIvoFy784EXM1P6618KgU+pHMTCA/YHZVyGkNxKrRVwjyEdVaLF364Z1kBrPr1C00UKEkcOClRIxd9YoE7D8CSe75OaEeZ9pxEc83zav0nd0eROtk/xuvQ9wuKtTumneU13yBUpYMWvSBYscOkHNWNhn6xRZ0JqinRmmI4FlINTo59334BS1UgzvRZnlCvauIYKb4Nh29k/E1PphavWhXjAQHxINED8ZT+dztFBdYRFnCelDZLpVeGjb28fQcB2kkU730yoVMswits0X7vVtSzNgE7DlvkD6qIy3gkfAV0a0MBPs0paDSKgaYNjDvogmneKRi6Xp/zSd8oKmz/vc1EeGMKHB6QW1SpvuJ2EMAn1Q1k+zRsHv1EcHYofR/B9PmWyrinH90L4AZwHzSu1FPaopy1IV7F6fdzIe5fLoVw5hSeW92g64sz9gqMq3S6fYgooGBvFBueVW+VYIRcyGEeMNQRq4HiSbPM89N45IvU8EhU++UtaodyZJ9WO9SmUcIBNRF5F92nArtIwVPbLfd48NAMJURpaPnHysPqcPrkV+iSA5Fsk03wqZlwLkUGjOaihRssELlUhb4NkXhocnTPUgdxjxi+HXmLtuue4BxGUoY1UrpGEoR/1MwL2nrBMJrdQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(83380400001)(36756003)(6486002)(316002)(478600001)(5660300002)(2906002)(186003)(6666004)(66476007)(31686004)(38100700002)(53546011)(8936002)(8676002)(2616005)(4326008)(86362001)(110136005)(31696002)(66946007)(66556008)(52116002)(4744005)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M29GeXphNjhXRkljZ21CajVSL3RxMUpJOTZEUFBKNDVFYzN5S0RrOVhCbHM2?=
 =?utf-8?B?dmlqUEpqdkg0dWVSWkZlaGZyMFRmOUlsN1NwZ3p2UTNsTGRFc09wQTJjdTd2?=
 =?utf-8?B?TXRqcFM0VHZ6U1g0K0Fucy80ZXBQeU1RWTZkZTVqWXZUQWwwR0FTTjV4dzU5?=
 =?utf-8?B?UDlPeC9jK3IySEluTW16dTExRTgrSStTR0V6d1cxanltV0dwYXdrR09hbWdZ?=
 =?utf-8?B?ZnhFd0dSSEdWaW5WbzY2Z3BHVzRPeUVlN3VQbmVsLytteFRuQTRKNXRtWTZu?=
 =?utf-8?B?UGhCS04zV3JXY0pvbzBpbGdkN0hMZERVejRWbTFQOGVieWpURXdEQVpsSnEw?=
 =?utf-8?B?bnZiakhtY2tLR3FEcFRSeHJOTVU5aGI3WnFsZ3NSWDR3bFhLMlVKZ3AwNTF5?=
 =?utf-8?B?bUxNME5ETTZzYUdMVERQVXR5MExveFZtWUxnY2Zab0hHdVRGNFVHanlUQVJj?=
 =?utf-8?B?UXpUTkFTY1draDBrTitvU1BFR3IyMXpSRUFIS252Y1ZoZW9DSWNiaW1PaXhJ?=
 =?utf-8?B?Ymw0bU5vWVJjMHd3YUJnSWdGMUxXSzZwOEIvWHdFd2g4NjUweXdwaG5zaG9Y?=
 =?utf-8?B?ckZTYmdQK3FZTjF0bFlaaTBaL3JNM3B1MkJTaDFETzJTWldiRkFsL1dxcnNy?=
 =?utf-8?B?c3pNNlV5VGhiOUZMTFB5aHF5eDFUYkFXNU1lSFFNWmNFdGFQV1I5dlRFL3c4?=
 =?utf-8?B?L3ovK1FObXNFU0dLdzlDTFBqb2JxdU92WHJvbmlGUXQ1a0tYS0tHRmpHTWJD?=
 =?utf-8?B?WlB2Vndwdy82dzA1cGljdzY5VDdXb2JjcklQZ2FJUzViSUFIQXdSWnM5RGl2?=
 =?utf-8?B?eWRkOVhiVU9kUkFvUnRoZzc2Sk9WM05saTZpM3RHOHhQbFF6UzVOM0VBeTI3?=
 =?utf-8?B?aEYxVEpVbktvaG50bkFhd3RRQVdPbkVYeWZwRW5YUktneVpldFRHUnAzOHAv?=
 =?utf-8?B?M2U1MDZ2WER2QktVV1JTKyt3UkFEbzU2NW1jVEQ0K2NxZU9KTThSOWV6WUFl?=
 =?utf-8?B?eVJDM2RKVEVsNmZwTUVTUWh0WS9sWWhxQW1TMXI4QWcxbDl2VENFcm11ZUJx?=
 =?utf-8?B?YXNaVUFRbC9CMmVTUmpIOEZ4MC8zdllvaTl0SUVWb2pHT3E3ZzlzREVkOFcw?=
 =?utf-8?B?a21nZEhvVEFGSmhPYnVUekVFOFVQUGwyYjNHRXB1OU03a2VuMWRSQ3JXaFZ5?=
 =?utf-8?B?UTg0SzZBNGpMNVVrZEM2VTJWUmRrdnZXTjFYVEtNa1N6dE5VbnUxeC8vUzhj?=
 =?utf-8?B?SGQ4dS9QeitCTHA5UWhQWTlUdlppQXBjVU9iTmYrRUdmTnBuY0NXMUlZQ0p4?=
 =?utf-8?B?VHRnQjZBSCthVVpZZFNhV1Y5OFEwY2RIdWkrQUJ4Ni8rdUpWQXRBcW1vUTJG?=
 =?utf-8?B?aFRFZzZmeWJETHhuNC83WFUraWF0djJlZDNXSThqRSs0ZnRXQnhCRStSZUFM?=
 =?utf-8?B?Z0tERHd6d3VKaXpsbitGZkVkT042MTBZU2VUdVpIbWR0Z2x6SkxVSWQ1L3Nq?=
 =?utf-8?B?OWRUYVhlaWZqN2kwNGluT21QMDJwSitLTXhUZ29ETVRmaFVqZWFLMHp4b29r?=
 =?utf-8?B?Qk0zQ1pyb0owZVRZV1VFQU1MMGI3YkdOQm1qWC9Sb2k3bitvSFNRbENMeFlQ?=
 =?utf-8?B?TlpGN25LV0poUlpIM0xXK3RHNjgzTEN4dVJ0bmo4TU50ZWxaeG4wd1pobjhO?=
 =?utf-8?B?QWpQenh3QXdVRG5oMEwya05RY3JKU1BHMi81RnN5amVrYXluVXc1NlN2Vk1G?=
 =?utf-8?B?ZXh6c28zTHZsTXVEczNtL3M4Ym14L2M3SUhuVTdKSUNrQmpHYkZlRGEzN2V4?=
 =?utf-8?B?b3FkcmpIbjlDUmk0d0J3Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 452e2668-bcf4-4b76-542d-08d94fdde3fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 02:34:28.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E83x1nOzG/dRyUf+cuGXShFgt20XdDi3Cp3QyfKSFtpdHioTSyFGtggi+2O0YYwd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4417
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Q6SIsvygpp9hLftH4PGiXw4VfrbPv4rd
X-Proofpoint-GUID: Q6SIsvygpp9hLftH4PGiXw4VfrbPv4rd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_08:2021-07-23,2021-07-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=849 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107260013
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/21 8:21 AM, Juhee Kang wrote:
> There are recently added xdp samples (xdp_redirect_map_multi and
> xdpsock_ctrl_proc) which are not managed by .gitignore.
> 
> This commit adds these files to .gitignore.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
