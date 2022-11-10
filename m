Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC96247C6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiKJRAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiKJRAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:00:02 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7717E1209C;
        Thu, 10 Nov 2022 09:00:00 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAEUvff016087;
        Thu, 10 Nov 2022 08:59:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=E6Bn0GYpP8N4NoCWtoZnRsvgYnK+om+adpkcXMM6ywQ=;
 b=B/OpUA1G1phJy/GpqNkEIVY/yYYQqI0fWZnzhwp0uJsjcOIpDe4PhNwUMOjA5teAi6MI
 JA8JB6I6I9M6QwwqiCvunG6yLKPwPbq6FZ93z9n2ROn5PrQYJrOUF3sg1sPV8HEDhChy
 Oo10zV8HxP36yRYakxhEBidS+ISx4XsEShM7cUAePrkCExP+4+F+/kkpDvu5D5LWkbCY
 +guZPh4EOHgzLMFO6LvIc4KKwC/ZSaRweDBseyszkK+3XXyYTPKJaJ8rLyxRd4cXrzci
 7V8KKSle1NRPUPoSMksfrXK9n4HKKMToqrXaplhpk4iZkvF6Gnrj7Fx2x+vBTWGk5Pi6 GA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ks34kh553-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 08:59:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExN/KwHGBiZT+WqQmyWoRKfxZUTCKCz6Jv7oIPhE2ah8WMBwf8sDR5Dkwr1aD+AS3yhzhTJeu7DSLTSjhnaoc103R82+ydLEzdcKCEm5KSSRDvbUJrN2BAXo338KZvk6HdOsBWNZbIsjr8iP36BMFoui2eJnRvRJT7zxq8vwqyO1xJn2+Q0cgcXMTNERDWMK31cBCgfXVZ3cBcXDlHoPcLMlsJZrxantr8QbJzYKDZf+Bi9kH+4ZIgXaHwc6ImVCo+kdZ11Q406alCHyasCQiKv9jZnSdn7Z/1+AK6EIVHcmxjjo7bi+HpSo5K0YO/qVfAxiC/mLaXWPWR93it+OPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6Bn0GYpP8N4NoCWtoZnRsvgYnK+om+adpkcXMM6ywQ=;
 b=SnKCCj+yZiAMu3+u6N0V0a4yhDizEpDYIhrJ+SyxKGgst5Po/AqqykJDW94+sxwBCFcMECyJ5D/7mq42P550naJx2czEA23paYWvVOyiJUogUNYS806rs6LILzfYeICuujgYnEO8J94DtiMikxKkr/wdOxaA3yQT2TMdOQm/4LEFSVidIPf25KZFk/XS6ezCFuHC/1RBImN4yvhIThFvbksCvynq5zGpcg0F09rFt/2Lk3QZxM2OYp3Vx0a45ziqmG6Sizkt4EdM7FVqe0Cfv2W4aM1SknN0IXAeetLBnDzhwdqUABUPRCA1L6xkH/Ky5ZWWJLJeLlpEde6F1y57MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3565.namprd15.prod.outlook.com (2603:10b6:208:184::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 16:59:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:59:30 +0000
Message-ID: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
Date:   Thu, 10 Nov 2022 08:59:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] net/ipv4: Fix error: type name requires a specifier or
 qualifier
Content-Language: en-US
To:     Rong Tao <rtoax@foxmail.com>, davem@davemloft.net
Cc:     Rong Tao <rongtao@cestc.cn>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF [MISC]" <bpf@vger.kernel.org>
References: <tencent_3E0335A1CE2C91CB09159057B15138441F07@qq.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <tencent_3E0335A1CE2C91CB09159057B15138441F07@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR11CA0054.namprd11.prod.outlook.com
 (2603:10b6:a03:80::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MN2PR15MB3565:EE_
X-MS-Office365-Filtering-Correlation-Id: aaccee3b-0c91-4c39-881d-08dac33ceec9
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+v9+H+NkrI8dHVpJnx2u30wz7Y5PqYjnUVU9L6WCmqH7dOhsn3uDSu+ZKIT9/l/4v2T1OTuvN+blejgVreRD5vFH1vS4xBx15Zfl6XOAq96RC7ysJiQ8RFccWyz87iQasKbWBpEaNPp+fPI9fojOj8MPepJXUq+/GoEOGJwjq44uGX6ytWzUxcKh1l44xFbSnyQJEQMhshCPE3zFekC8GnARMTSFA/by26fNWFUvnfyxYLxbtJcbqPHtFF1HwcN0y0Xpge5xp0+xri6KBLL6HGjnPjnDcCuwGnJmpS6OuA3vtYOCExds6YLjBTT2bpYAcVQaCZ+TRkCjM0HL1z6sPI7GlIddBxTkC1lSre9X/BegmZ6wGgOrdGL0r2WnrtwibXKwqUP9Fxo5dsnJNubPdYRX8pEgKy6ytfA7VP2xNywV8xu1nmPaVm2xMtxZ4jEDO0HpCCJya4eYH09peE2ny4zmNLXnqgC+XqeHJuZim0oivL7HtWmg3aqeyhE5wjobZsUvw/actnDfVwKLfp1zChY4OIbAwXjzlOZkjzZ2FHIuCiA+iUkud/qfV0AsJZwzBmGrkpE9xIdOA9z2DRLfdMNg1fnqqzjqsp8NHQharlPae0Z8JRM47e/B+YKbWAfAQmRhn4fNd7oDGbomM6xcBM2/w+kaEjZmtW/p5zOo3QoPcGgXmgIW9FdWpkOK41hTb53mTn9/hS45uJER/Xa9V9Jozf4ADn+oa86mw8vANhFgRVWdV9Vx0X2EXn/QhIg6uZ2tcdYUs8svQkwD9Tet822oTz3OY9WNf8PuUEqSToLdUJ4bqNqJ4jrE2OFwH+wc+O2YF3r77FObznscOzq8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(36756003)(6666004)(2906002)(7416002)(8936002)(6506007)(8676002)(66476007)(38100700002)(66556008)(6486002)(966005)(54906003)(316002)(4326008)(41300700001)(31696002)(31686004)(2616005)(5660300002)(186003)(53546011)(86362001)(478600001)(83380400001)(6512007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEpTb0hVeFpOczhyNlg3MUNScmVpODBZNkVXTVQ1S0RmSnhVK0s2R0FBQ05I?=
 =?utf-8?B?YzFDTTNyRE1wa2dtNjJOTXJEZ21WcXBsQ1V6WEgrbjdrRWhHb29kazRPSDVL?=
 =?utf-8?B?SDlxWmRTLytpcjhINGNjUFBhSkVhczhiT3ptaEFpWWxzYjhxL0RJYmZqVmpt?=
 =?utf-8?B?WEtCLzVqMVZ1RUhIMlB1THVhMm16dWdtNm5JaFNYQS9SM2VGajJiMGljeWpp?=
 =?utf-8?B?RG1TSFJiVzVEUDB4V2Z2Tk9weHNzY3RaRmxKSEtoajkvMFltUGo2UVQ3Rmsz?=
 =?utf-8?B?NGtOWHJ5NVBMM2M1NTdpbmh2Q29FRXFLS3p0cGJCRlZpdlhTWVhJNVdUVWxH?=
 =?utf-8?B?cjdodTFaclJKNkpjU1pMRksxUVF0c3J5ai9IVGxlNkVNTkJiR2hsTVRyVW0z?=
 =?utf-8?B?UWlGNVJ1dU9aVlNHNGVINnN3ZWI2MmZaMUorSjFmN3ZxTFRpZ3pnQis1N25V?=
 =?utf-8?B?WUYxcFVFWUUrN0pTN0k3Z0JOVVErZEloTjRrUkdpclE4ZEl4WTllNkpjRHd5?=
 =?utf-8?B?YlJMY3FFWUxxbSswRHhWZk1ZUHZ1RVB1S1lFVFFpL2tDSVRJNHl3OWJQekFm?=
 =?utf-8?B?d1g0TThVZS9jaTVIbnpHai9EWnZPWmtrcDJUcUVrbUg4dHpZR0d4NG1nNW4z?=
 =?utf-8?B?S3RaeDU2Q09JVHVnenRNTmNTOS93d1dlcUREVE5CRE96Z0xMKzlsMnBkRWN6?=
 =?utf-8?B?eGYrak1UZVJ6dHQwbEttWkxTSERiTWt3WW5VMFdkZCtMa3U2VGFHbm5RWFNi?=
 =?utf-8?B?SnlRbE1SK1BvQjRWVmZnOHJmUFBhVGt3OC9xWVlBamVZUUhCVW1TdFovVTlw?=
 =?utf-8?B?UHRzbWJTNHk1bllmZTlhbjJyWHdEUndrdXNKczczTFFoOFllOFhaanJ5VVpM?=
 =?utf-8?B?cnRkVFdCMk9VQy92UU85TmoxSThSUW5QUk44RjJFbnpsS0J2Q2VnQTc1dXJX?=
 =?utf-8?B?UGdnaEtPeER5YWo1Z1ZCb3VKM3F5ekpGNkNWUEhqYjBWTVpNMHIyRHhqVjRT?=
 =?utf-8?B?Q3BNYVVQNmF3dnoxK0Z3b0VVQVhQSVpOVTQyS00yaUhSL3V1U1JBdkpmMkRw?=
 =?utf-8?B?cmtQdEw1ZFJOSEtSTFluNnZXZFlwbFFOVjZ6RmJBS2xnak9vTFc4YmpFTzM2?=
 =?utf-8?B?aVVuUkhnSFBJdDJPYjZKQjdnMWE3U2hKVHEvUDNpZzErM3lJemJaL2IxVWMr?=
 =?utf-8?B?TSthN3hyc0Vna3h1V3VDbCtaZFZoZ2d6T1U3dVZZSGV5MzdFejNSTzNvNzBN?=
 =?utf-8?B?TUdlUFU1TE1hVDMxU1N1MDdnMjFoQnlzajJiaG1McUZ2WUJOYytvSUVxTllq?=
 =?utf-8?B?L1ZsNkJ4OE11eDYxSUszeUJnZVk5QjU1NU16dWtXbDIrYUhrUnpDYVZobGJ4?=
 =?utf-8?B?aXp2ZHBCZit0ZStjN3ZXVEpiSEpLNkJSdDNCdVlZQ1ZKbUJWaGhOSjNxUmFy?=
 =?utf-8?B?VnBkcDFXSUg1Mkd0dnRSYk4wR1NxMVhnYWRUTFk5NzB3WHJoaWs1VkdMSDRQ?=
 =?utf-8?B?MGM0YlUwRUQxM2VKcVNDamJWYkVESldSVDFjN2kzZkpmYkdQRmlZckEvUUk0?=
 =?utf-8?B?bk1YRm1JS1BYb1kxV210RGN1bGMrTCtCOWxEdWtEcGdUMndHcHZvQmZDd3gv?=
 =?utf-8?B?aWRZM0VhVHFrZWNQaWN4V1k1dXFQSklPbyt2aitoWGlXQ1ZCN09IWVJMSzlj?=
 =?utf-8?B?TkJ1RUhMd1REUjBjK2RoOWxXeWhSNXJCakM0QTJxNDU4eTlLeFVtYkZhcVpN?=
 =?utf-8?B?c3ZMZjExT0ZsUzFGZmwyOW9YKytvVUxNUkZXcTB4NjdvN1cvd1pDd3ZRUlRJ?=
 =?utf-8?B?cVFZV0NXVXo1aCtNNTBXWXM1WHNSK1NTbEd3cHMzcWF4MkR5dFRnZU1WeGRq?=
 =?utf-8?B?VFZ5VVdaYXRRcVRIQ1B1NFg0bURGcTlZdFZlSCtsYUtzMG9BQ1RNek90NmRF?=
 =?utf-8?B?NTB2NmsvYVlKMGlzcnVUdS9NVG1Va25qYWEwWS8vVGp1VTViOWNaQzVBZFZ2?=
 =?utf-8?B?b0F4TUJhanFyVjVZRzNZNEZRL0RFbno1RWJFRm9EUkJXVU9kcXp3OE8rcUpi?=
 =?utf-8?B?anI4dkNVcmpRMWJ0dW1SYTBsQjdoRk1ZUVhKaXg2Y3ZsSWRLSzBTV1hnMmhk?=
 =?utf-8?B?K3JFZE1mUGI4cVR1Zit1YlluYUtEZTA2QnJMNHB4UU4xU1QzL0V3NW9jMDNP?=
 =?utf-8?B?V2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaccee3b-0c91-4c39-881d-08dac33ceec9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:59:29.9235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ju9e4Q4PoMaJI4P3fz1AP0wgpw++W3hqTEsfBUkDRQqfIfx3h8H9P6ALj4Pxjrbj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3565
X-Proofpoint-ORIG-GUID: 22G5Sbx-_6DlaYKnzqwPPePxqJ5t2pK4
X-Proofpoint-GUID: 22G5Sbx-_6DlaYKnzqwPPePxqJ5t2pK4
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_11,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 7:17 AM, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> since commit 5854a09b4957("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
> linux/in.h use __DECLARE_FLEX_ARRAY() macro, and sync to tools/ in commit
> 036b8f5b8970("tools headers uapi: Update linux/in.h copy"), this macro
> define in linux/stddef.h, which introduced in commit 3080ea5553cc("stddef:
> Introduce DECLARE_FLEX_ARRAY() helper"), thus, stddef.h should be included
> in in.h, which resolves the compilation error below:
> 
> How to reproduce this compilation error:
> 
> $ make -C tools/testing/selftests/bpf/
> In file included from progs/bpf_flow.c:8:
> linux/in.h:199:3: error: type name requires a specifier or qualifier
>                  __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                  ^
> linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
>                  __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                                               ^
> 2 errors generated.
> 
> Same error occurs with cgroup_skb_sk_lookup_kern.c, connect_force_port4.c,
> connect_force_port6.c, etc. that contain the header linux/in.h.

It has been fixed in bpf tree:
    https://lore.kernel.org/bpf/20221102182517.2675301-1-andrii@kernel.org/
The fix will be merged to bpf-next once it reached to linus tree and 
went back to bpf-next.

At the same time, you can workaround the issue locally.

> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> ---
>   include/uapi/linux/in.h       | 1 +
>   tools/include/uapi/linux/in.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index f243ce665f74..07a4cb149305 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -20,6 +20,7 @@
>   #define _UAPI_LINUX_IN_H
>   
>   #include <linux/types.h>
> +#include <linux/stddef.h>
>   #include <linux/libc-compat.h>
>   #include <linux/socket.h>
>   
> diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
> index f243ce665f74..07a4cb149305 100644
> --- a/tools/include/uapi/linux/in.h
> +++ b/tools/include/uapi/linux/in.h
> @@ -20,6 +20,7 @@
>   #define _UAPI_LINUX_IN_H
>   
>   #include <linux/types.h>
> +#include <linux/stddef.h>
>   #include <linux/libc-compat.h>
>   #include <linux/socket.h>
>   
