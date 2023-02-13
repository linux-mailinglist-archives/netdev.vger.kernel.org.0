Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AA3693E54
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 07:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBMGah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 01:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMGac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 01:30:32 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ADC113F7;
        Sun, 12 Feb 2023 22:30:07 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CNRm6A025027;
        Sun, 12 Feb 2023 22:29:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=QntoPU7TOnf/cCS/6CXRE0bWJU4biwTbOrDYAtR0Qm4=;
 b=hHN7udPUSIZX022JXGETMgdj/fRCbvUM/5cFOhIKQS2r/qEDSRbLbrewRPnusRMhuVxr
 hWZlu4BH7V0i8i8ZaV7Cex4il7LfcMdLZIg0FroC+W30gHMK0xgU/Ols3ZkKVgysAB3S
 iRZN2BMQsXpU1loQ1xStkuPLV6YcBMCsI8X+mWuDxZDQCQB/Lcj6jg6TF5j8E6AygJdn
 gtQn+cNGud+7Gn/6akqkefU5FgwLKVF3sXE26Lynu3vPbS/zt2tM0V348pM//bQvm36s
 B10C4NKd3ttkaRDoNFVSrUX8lG0E3aOTW8tL4hD5r85+1ZHhtsqeiyLZtMORJ/hz2TRG vw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3np9r21kmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 22:29:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBTUyANYw60F7pUAwmABthLDUp3K1nuaC83C/6gyJKKixk8iqvoN3RsVr1kmi3ARl5xX9CgyHusIo9FXeKnGxA62RG4z2OOr2vlhWOKi2nULN37pC1+5KpzBJpg66C6dKDxTRQkrkv1XqKQfcByJITT6fOkznAOBvZoCdAxxv5Dhr07CS63AL8licfIdfoZDSpSh/pVFguIBECYDUP7SZ/qad6LuPXRyybp4KTdN+j5cDCw3aif6cp1WCojXd/xKQQEMbfIdBK5V01wvpOakFHFg/zA+bD25TtwnmKGl83Bpq5WAtfQNWa4gWGFN10POY7Vk8CS8YVMieCw8Oy/CZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QntoPU7TOnf/cCS/6CXRE0bWJU4biwTbOrDYAtR0Qm4=;
 b=HS++HdWjE9GyOcp3DmtUY3fFTXJIwAK9s0WY+SeJAFunPttWlsQV09/Tui7CEP6U/kxxT011MCnUB8eOGO4T4wPZDxEXOAujJFpB3DPosmQYV5ZzDsUqKEwJoM+prE5FlO/CnmBqp46Rl3Pp9hOaJ3Wimpz/sjGkFF73dp2+RSrWmPlu2KYD6tmzUjb6UBzKAFFzqEYykCGvehEbi4qAEIgdJaSZFbrYJpe90ekCPLdRVm6fThJD4PZuRqGllbvaC8pvSK9PStB1NQYY+EI3SyFIBuV25s+vDROUoNHDDuvXzQTVQAvNrOzUdFbGDG3p4dpsmEAUb6P/WdrtM/o+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CH0PR15MB6250.namprd15.prod.outlook.com (2603:10b6:610:192::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 06:29:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18%4]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 06:29:13 +0000
Message-ID: <32ab89e1-84e9-75f1-18c1-81db9a40d0bb@meta.com>
Date:   Sun, 12 Feb 2023 22:29:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CH0PR15MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 3043bd64-45ed-45e6-47f3-08db0d8b9fbf
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPpxLTc2LW7zYaF8O8SMJIEAclVbCH1G/3EX5rRvst9Oouk/wWIk2vpNnZmEpImnnvGZ2B/RcfRDcsTvuDubL+wg2DQgfUKpsPYcDrV1UeLVGqA7+7CVzqTZqn1vFRYbpG+FgofqO9d+edaWXgD/1UD+F89e2WkOs4CLpsErbaCnTt0ELi8RADqH8nfY5owck9fSzpQ5CSxL9LmoyV7d8Hps6C/f8rCgWSO5ZyfD1SauXu3RjkgdolymjniaUeaYcRdKFNgE4TV8jiHYzRC68dXov5olItZpsUT1BtbgVoPcE2jTFoI5pT4z6nDlckcTWcg2cw/ugiJ8fePaPVXnnEr/zu7vgXG+IrqhBPVasC/KGjDnmge6JshLoUQ0xRbhvh9ZZb5cy3svzA4rtcfq+HVJ0trrwY0b3AbaDF6BucVdbzwEieamf4cNzX5/au91Y+RU3C3IU/XJaUixuLxCF5dXl7M34zcy/hTUzrIk0HFjNnMrDQuB3Ylh9APVoHm4/dNRdBMqpvoj4tl4ZEGP2ioOgWDnY9ggIfYLVqRVR9dqb+oaMrnNerc6Ef5mgkaySwrIPEJIYo0O3MwkjnyCK5cf0VQsMgnhJjSNkKvB57mtoQvxQDAPhcYgl8LW19E/4PHn9jQzSc2MqXs1y763q22iLyPrZmTF1N+HF9iozfp56+BneCq+GUq4rjE0ERk71EHZLCptTn9W2fzCn/u/1gyoqvGraDJ+7vyG4JCUkOBU9dhl+JBAjwBprEP3vQFQaGlmuB6VLdk/GswcXUH1Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(8676002)(8936002)(38100700002)(2616005)(2906002)(36756003)(5660300002)(53546011)(31696002)(186003)(86362001)(54906003)(41300700001)(6506007)(6512007)(31686004)(966005)(478600001)(6486002)(316002)(66946007)(66476007)(4326008)(66556008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djAvNmZveTBubFRaYmRGRDZ6L1pxMGlJR25TMlpCQ29XU0p1dE9Ea2pxd3ND?=
 =?utf-8?B?aGJUYWFkMm1rbTJheW1ZbWZPNVFPOWw5akZSaGVaT1g2WGc2Q216eE1xcUJN?=
 =?utf-8?B?bHZMaU5wendiZUlOODdFRXJFMytwd1RLSllTNE5DRXBLOGNWSFI2cU9kQjhB?=
 =?utf-8?B?OERtNlc3bktvSGtEb1B2c1JuMlNNN0xwVjVqdHBSOVBZbUg5UHkzNk91WGI5?=
 =?utf-8?B?dGRDTnZzWnU2YkVMalpoeU5pVFBoOW12eWNhWTE5SW9URmxqTjd4eVZaVkZ4?=
 =?utf-8?B?ejNyZENnSnVjdnBta2pGMkhnTVZTUVVCMU9tNW1VTUN1Ym4vOFB2TUNnc0c0?=
 =?utf-8?B?STRxZE9VSnUzeUNQMzgwMmpaWXpvd2NKNVVBZkpqTjJhakpjeHRETnNtbzVH?=
 =?utf-8?B?QUh2UFdESXpKWTVwd2Q4VmdJZGtEanhhb29kMzJ2UDlEWkI1dElRVnlhcnoy?=
 =?utf-8?B?cGpHYnE5NmdkNHZ1b3ZPWERjTmtGb01RQmxCR2VzcDRuL01PaWRKcnRMK0o2?=
 =?utf-8?B?Z3Y4WW5xU0Nsb1VBYkUwdUhudzYxcWg4V3NBZXliNmlVTXdMS1phdXRkY0M5?=
 =?utf-8?B?VlN4NC8wK1hpOVpkQmJ2aEExcHQ0L3YrU2lXK3hCK2tHSTB4TUVxS21mY09p?=
 =?utf-8?B?OWN5UlR3TENmRWM3dEY5M1VIL0hKR3FwTGRFcVVjd09yUzF3VUNZOUs5V1h2?=
 =?utf-8?B?cDhKcTRmbnlRT3hrSDEvUWtxU2FlUVQ1YURPeFdzbHgyTjQ5bGJiR25wWGVR?=
 =?utf-8?B?cmVFT1BmV05mMmI1RjI2KzNJT0wybFBEQTU0c0xkUXBIZHFlR05naG55OGFm?=
 =?utf-8?B?R05UaUlkVHcrdUtQaGlIR1EvemFMellyNHMySUtFMW9jbms1THZHdlRMR1A4?=
 =?utf-8?B?aHNraDZ4bU9wb3dPNERLUWNhOU1FQ3VNcjZSakdYK2hKYlUyc1ZMTDd6Q3pE?=
 =?utf-8?B?Tm8xZDQ0YTBHblFXRkszYXRVN3R0NFB0eDQzTTI1ZG4wSzgyeUkrc2ZEQ1F5?=
 =?utf-8?B?SzQySmtZbmJob1ZuSjhsdWN4V0l5MWtPUnAxdmlVbi82TzJaVHpVdHFLYS9F?=
 =?utf-8?B?RlE2WUNsbmZHZkFnV2dxQ1BLTDIrZWs1WWwrS0NpbE10ZEd4alRyVTl5TWdG?=
 =?utf-8?B?aXdCQkFrRmZEbUZpUUNPaFRwMmE0MSs1VWV0OFdIdEQ4MzJ6NFpmd3BFbGdq?=
 =?utf-8?B?eHY1NHVDMUJRaVpOaW9QdUlackYyOXhFR21qUy96bUg5ZjJRMUdMNXk5YXZP?=
 =?utf-8?B?NktNQkprTnQvZExDcUJTQlU0eDNCeFNsdS9SMnpRNVhqajNTUTlJSlZ6UlZP?=
 =?utf-8?B?V1RvQ29LNi9YUytsWitNUFZBVFlrMG1va1lTRW01SWhzeWR1NWZkSUpuMmZh?=
 =?utf-8?B?WG5tS0xQWnorNmtJUE1ORDhXZFpHVEVzd0Zjb1ptazZ1WkExQXVsRzBxR3dM?=
 =?utf-8?B?R0w4QWVyZ045K1ZzSzloaDlrS29hU0JkNmU3Q0Z3ckhqRkVOb25Ob29GNERh?=
 =?utf-8?B?eVZydkdXKzl4WHZEZm9vSmhrUnJFVDczc0ZBV1J5eG8zL0dUdTl0NHBUaW9j?=
 =?utf-8?B?QmMrQWwzR3dLNnd3bi9KamdlSXdyeHhndWQxc004WkdFeFhkODNaQnJvY045?=
 =?utf-8?B?elZMVUVFS1JJOWJXMGc3bmY3Q2lOL0MxR0FKRndVdlhOMzJEL0lFNXBpd1NW?=
 =?utf-8?B?SDFDNGovYm5RYWlFenlUdU4xdURwMm0zWGtaR1NRb2ovd05uV2RCRGFqUkZU?=
 =?utf-8?B?TkVqMDlPWjRCdjV4d1JJQW1FZVNBRTVKZnFram96RHZyODRSYW9Hd2RzdUtl?=
 =?utf-8?B?Q25kcTVZQkVzS0ZKOXQ4eXFxR2ZTSmJiUW1ha0xDbC90MElVQVdueWN4MGVq?=
 =?utf-8?B?YUMyRHZVNDN6cUJqZ3htUVJzTnI2OHppcVY4YXROMS9QNmd3am1MeWthZjZo?=
 =?utf-8?B?bktsL2VIWTNHcE15ZkVwd3Z0SkFhVkwvMmdST1dvVjRjOENnSElidDJSNXVY?=
 =?utf-8?B?RDhCR3oyZEJqdm9vVjg4eHkvdC80djlZeG04YVIwOXI4d3p2NVYwaEsveDEy?=
 =?utf-8?B?OWpsWjBNNjd2YkVZV0NiWDNDMHhTKzdMckVGNHl2Yk4yWjJuWDRFWjJ1ellO?=
 =?utf-8?B?WDZPT2VIckJyZ1ovRWJJSnlVd2xjK2dJQjlXb1c1MTEzalBjMEdLVHMvaXVQ?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3043bd64-45ed-45e6-47f3-08db0d8b9fbf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 06:29:13.6035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGy597g/Bq+3Hi7niIdkom2+labA+A+uiCRvPmhzNjbi8kJvf+tEGSddIy6JV8kC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR15MB6250
X-Proofpoint-GUID: iaN99LqqyFVR2zJY3v2nV2rTejC5phdo
X-Proofpoint-ORIG-GUID: iaN99LqqyFVR2zJY3v2nV2rTejC5phdo
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_02,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/23 12:19 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently there is no way to know which sockmap a socket has been added
> to from outside, especially for that a socket can be added to multiple
> sockmap's. We could dump this via socket diag, as shown below.
> 
> Sample output:
> 
>    # ./iproute2/misc/ss -tnaie --sockmap
>    ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
> 
>    # bpftool map
>    1: sockmap  flags 0x0
>    	key 4B  value 4B  max_entries 2  memlock 4096B
> 	pids echo-sockmap(549)
>    4: array  name pid_iter.rodata  flags 0x480
> 	key 4B  value 4B  max_entries 1  memlock 4096B
> 	btf_id 10  frozen
> 	pids bpftool(624)
> 
> In the future, we could dump other sockmap related stats too, hence I
> make it a nested attribute.

Have you considered to implement a sockmap iterator? This will be
similar to existing hash/array/sk_local_storage map iterators. The
link below is the kernel implementation for sk_local_storage map
iterator which iterates through all sockets.
    https://lore.kernel.org/bpf/20200723184116.590602-1-yhs@fb.com

This way, in the future, if you want to print out more information
from the socket, no kernel change is needed and you can just adjust
your bpf program.

> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/inet_diag.h |  1 +
>   include/uapi/linux/sock_diag.h |  8 ++++++
>   include/uapi/linux/unix_diag.h |  1 +
>   net/core/sock_map.c            | 49 ++++++++++++++++++++++++++++++++++
>   net/ipv4/inet_diag.c           |  5 ++++
>   net/unix/diag.c                |  6 +++++
>   7 files changed, 71 insertions(+)
> 
[...]
