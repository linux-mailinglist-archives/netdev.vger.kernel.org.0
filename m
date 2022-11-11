Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF916253D2
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiKKGby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiKKGbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:31:18 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16262DEA5;
        Thu, 10 Nov 2022 22:28:33 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2AANE5Sb021532;
        Thu, 10 Nov 2022 22:28:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=oHi/DBjnfZMtDTO7TFE5pdwWl7jac0QlRKSwIW4T+Lc=;
 b=Es4piGJTTe8pVm9/hIkU879eODH+dOtegXk9WV2Q44cWZkLNcjlWkew9e8m+MOFt6MKa
 RUkydS0ZtACcDc6Mhr0jtOOmFtB/UnteH8L07YL6pBAXwYyoHTXYOyk9Z7fmVXQw+7oa
 mlxZHeog4uqf+/kBtJeOb83vDfXQBy6d9vqgzQeY6ac2djy+GIiYlC+lhu1MZz4Iaa0H
 k10hyySVaj7idKLkJfvdS7yheKLK1gP1sXLoMMv1UWV0O5BhfTOs0TOAFeFeEQGPxMPG
 IYi/8ZWL28429R0VbFyNf1GmIVGXQtNTiJDu9gJkEgyifAnHzany+my8/I2OCdGP7flm KA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ksaseack9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 22:28:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frTwLKfn9K302OhvVltJIswbknarGdlmxhFzIT61JVKl0ybf4wJGxhgY7mtr73KLYBFi1UzY5kgwFptopH4kgMzJ0Z77tnvqTbMEBjIfzcaldUWNDD9KRQ3nSjFRUI1lyTuu4gvrI+iWt1B6Jjf1g6ubfDGrL9U4OYUHoM8VKD043GvxLVqh0NyFAh4s06kPxM3rSr9CX5lQHmjM26t1M3aE4nKtU73TZfgRfpaWE3tqMyapTWhpmMxb7mqMR2YU6meyVtqT7GRWmydu036rFULxJM0sQB/u7ajDxbXx05ImMHE6I/e8QJHKNIwvAvDaWRI79lOwdd+wUc9uocvDEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHi/DBjnfZMtDTO7TFE5pdwWl7jac0QlRKSwIW4T+Lc=;
 b=cZI8Vr27d/KzEaLuyzANm6rTQOSqtmZwb8Ikg3aA7qCD9A7bjm4KKmPAiDqlB8HY4YT+LtYraR3bcueB9jtIEwfqP9kE0drlGQhfgLUV8lMpF/5nsNxXGOEeybwuCjysJm7sdR9xFzUXofQtnpuLp/byUsorfVV3LqI2e5I0TtS4iPwMCJR8sKdhOrJ1l1ZErl17WOPkqt2AqKmJjVrELqwYS92dZSUKtmIXWSK6xAvcHSZYVisq0q8bZqrlejhx+pdyaDtIg9yTb5zcXuizn5J7eyVunhdgwtOA9d3wuHqI5aK89Z7AIpg2M4I2kC5uZOBBcLqgd9B7sG8TyKv1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1209.namprd15.prod.outlook.com (2603:10b6:3:bf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Fri, 11 Nov 2022 06:28:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 06:28:11 +0000
Message-ID: <bc37b89e-3ccc-53b4-31fc-84c7c0146c75@meta.com>
Date:   Thu, 10 Nov 2022 22:28:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <636d82206e7c_154599208b0@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM5PR15MB1209:EE_
X-MS-Office365-Filtering-Correlation-Id: f2ef38b3-ef9c-417e-0611-08dac3ade7c6
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu7nQ3Kub88zUTCvntUBhGRlTtYhOdyTxLWTVEFztoK4Uu/vNEJ/Y4Bi8mTaZhg3OC4aJhwy1002uSWfNJWv+XhJAHAxF+B4WlJWgD+4ukVRoh3dn/trqy5Uj6uP0ttL08f+/IRf8OrNgvEA35DcIQ6sQtOKMcGlUadeQsla6tlqBEn1RKlJLEBqNfZ95y3ujISyvnC+xscAdlzxZh+DxR059sWDXfNmU+1XTgqIzz98YKu4qOvcXX+qwtAUBqx/QaXOjqNbQQTseUe3gZbx1CjUfrdPYsrHpwb0oPZBtkofRgyiCMB4dUOpDBoERIo2S2YMR5JBi2tGVAASlNY1LYfjD22vclYIh5XilNd78sBHCnZ+ugnUkQaBm3QlqivN18g1Pa0iDfXq0JACCJW1Fv3K6yLfUX84yx0az8oThS4w8JbWKYtcaKzc2QhQwt0q/YM1t6l8KtU5HTlcHFbMbTNfM72FQ9bU+jdASUh/JF5bpkKmEKiu5LiVwdg3Kl0pj0Eaa7uaYp2OPBpwbuHP/a0PD9abv7cr1IfurFKM050a74kTzTV9TMjJWUtpx4y65fdUaceRcgeYW6De4MYPDuUHK1gzVh/GzSuRxi7PextSnqaJxiJWjMutv2mLQCQMKJU4e/TTNnV7lRv74vzfk8MK0jW4kqD1CkxW7cKHCWJyftyQBHQhYga5PJqaDlB8v8vvdepy468NQ9vvKlonCh0JSpanR5Z9gPVXQVaYsTf1x1AjmiErYlSV0wIvwlEoGC6udPZcipZLjFb+MX/YbfnJne73JHnlFJ8nA6lmyhojUFKPGA2f3RxFy6wPbUIgWY9yK/pVmZx3qfpPtzLTd0DDD7vgpxyPgSt7kyzHrI7gFA903zQN51FpNAgHr3JK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(38100700002)(2616005)(186003)(83380400001)(6486002)(966005)(2906002)(478600001)(41300700001)(8676002)(31696002)(5660300002)(31686004)(316002)(66476007)(4326008)(6666004)(53546011)(86362001)(6512007)(8936002)(66946007)(66556008)(6506007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTM5dmM5Ky9lNGpLREgwQjc4QjI3WHdjNFdsanhpYk5CTUx3N1pvVnFLLzdj?=
 =?utf-8?B?cS9JcVpjcFp5YWxCM2cwTjZsRTg1WEMrVHQxYmg5c3BwWFVpOStNOGUxcVZR?=
 =?utf-8?B?Zkg2enU1NUFuQjlSQmtmMURhTzVCbkpYN0dRUkhlRVM0eHB5cnZkVXUybkYx?=
 =?utf-8?B?bXNXYWZOYWNFQ3V2OXdhVmN6L3hlS1owZlhWdkhWMDA1dzFvRDV0SFAzMytZ?=
 =?utf-8?B?b1NLR1hlZ0tZNVhQckIvSmlUWXNaWXI2WjNvWmxhTDdTcERRK0pWQ0ZpRmRv?=
 =?utf-8?B?OExZQzVaZHBocHFZdHBUQjN5WWZYOWtBeVZiUU1tV2NTT1k3dUZBOEF3OG9z?=
 =?utf-8?B?bFM5RDRKSEZabVdYVmN6eHA4VmJCZHE2Z1ZBTUZ5NEdncFFjR3dYMkhGTEor?=
 =?utf-8?B?NjdaRk9ZMjc2U0JFSlJEdTRWcmNVb3dWSG96UFM5cVY2eFB4UExPVlNnM0cr?=
 =?utf-8?B?emhYSytvUEZnUThEYnJoVDZITFVuakxOa3EwSCtkRmlwUW4yVEdFUWwwOUgw?=
 =?utf-8?B?cVJQL3FmbUt4TnNjVDlyUkNsSlIyMFJtRS9od2ZXNHVDcWFVL2EzMGdKcGVs?=
 =?utf-8?B?OUQ0L1VRV2pNR0NWQ29tV1FqQzhWTEVOQWpMYTlCek9jZjZKc1JuTWttUjBR?=
 =?utf-8?B?TkV3RXJzVEtURWhSMjZkR3dyV2lLem43ODVVaWhWSlltSUZGUXA2Q0tidXJY?=
 =?utf-8?B?ZFBkOThyY0xmWFdCUWc1NTJTVWlaU1Vhd0RVZzgrRkcxcUpla3lQbnpDMW1C?=
 =?utf-8?B?dC9wbzVrK1lLTDZMSFkxY1FlcjJQdHZ5UDU2SE4xUi95NTlFN05UWTFMdFh5?=
 =?utf-8?B?enFVZm5zbHMvOVlpcW5qZUNEUDgvTUd6K3BFbjlLTDdVZzFFMUc5VVI3dThG?=
 =?utf-8?B?czB2VDVwODlzR0l3RUhLWW45d0hmRmkrdlRVUGlTWEQrVW9TZkV5ZzZMb283?=
 =?utf-8?B?aVVUMStsaTJPNDg3c1Z5ZzltaHhicWljZ3ZtMkNIU2s0cE51YUZEUmNONTZw?=
 =?utf-8?B?Qm1KZDRSQTNqNlRhUFFPTThnRU92R0pZZnRRWmg4VmZQckE4dVpHeTZpVm96?=
 =?utf-8?B?WktpeFBIT2p0cUVCMDdiUGZvaDNESnZsWFQ3a2ptYlUyMHRHTXIzS29BWjBz?=
 =?utf-8?B?REE4VXhsZ0UyMFU1eCs0NzQ0ZTQra1c1L3E2TkdpWWplSmJIeUJNVktZNU1E?=
 =?utf-8?B?cm5SVnZpZWtqcWlYNTZTZ2pNeGx0djU0R0tWYUFIdG1XNEpLcnVjQmdqOWV2?=
 =?utf-8?B?ZlRuQ3ZBU0VJWXV2Um03ZitIY1lKTUpWOUJyK1EvcllJYWh3YlhRVnNKWGRM?=
 =?utf-8?B?SXc3SGlEVzJRWkhIazZadUFNNHlDWm1nak01RVMwWW9VU2I2a1VjUm9QcnRj?=
 =?utf-8?B?R3NGN1BHalo4U2RlNDVBM24wczJaS2M2cWpzb3hETjREdTZWT1B5NUlYRXpv?=
 =?utf-8?B?anhNNGkvM1ZraCtPVitSNlIycG83dndxRm5WSlg4QWNSaURtTncxeDVkekxn?=
 =?utf-8?B?azRlb1o2YituQnE3RytGT1JKVGdqQmNhY3Z4RytMbXdoUDh6UkhzWk9KUVFt?=
 =?utf-8?B?cWpOMS9HeWRDSFFIQjd5ZG5TV0ZqS1hFdDFaN2hjNkVYZ0pmdzFJeDVFUk9Q?=
 =?utf-8?B?bCtqUU11TGZuQ2d3TksxYTViVGM0em1pbDg5UCtsRkl0R2MxYitiYXQ1Y09B?=
 =?utf-8?B?VkRDbkhGSnY0U1FKOWhqZUw2M1pyN2lvUE1PeHh2QjVGODdibml6Vjk2dS8r?=
 =?utf-8?B?NjlsUVZ6REhZc2ZXNk5LOXQ2eTRIWi9FNUFJbHhlTnpUWmFTNTNiMUw5OUxw?=
 =?utf-8?B?Q1BTWC9XSmJMZllXVUx1VjlIdUZCMmhRUHlxVlNoRUpEZE1XbmxJQmZPM21w?=
 =?utf-8?B?S2VTOVlTaGpxVkRSMlBkdTBaNHM3cXRUZ3BuS2lQUDhjMUxHdGt2d0w2VUJP?=
 =?utf-8?B?ZVpsaDlQcjhNM2FYdXdtTGV1MEdoMm9EVVZYZDBHbjdEREo2ZEM4d0hXU2JJ?=
 =?utf-8?B?akRndVJuYXNiSHJYVXBERDhCQU14VVMyNXdoTEk3QWxIWDVjaXR5Qk5iRDJE?=
 =?utf-8?B?NHZ1MlBTbkNMbWIwQWJMbVN0RlhWOU5FZGI4bXFyUmk5Y2xLU2Qzak9jVlIz?=
 =?utf-8?B?Qko4Nk5FNGM1V015dGxIdUMycjFTLy9CeXFSTUFVbkd3ZVhsRzhwTnJkZ2py?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ef38b3-ef9c-417e-0611-08dac3ade7c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:28:11.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE+FsR4bEzY2gKdmsL0HcP2PCzb4XJofyu4AANN/26FrI43URpQIeorgQyNOKUjJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1209
X-Proofpoint-GUID: EjftGDgBxRR4kCU3pHQhXawywsvoYxGm
X-Proofpoint-ORIG-GUID: EjftGDgBxRR4kCU3pHQhXawywsvoYxGm
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_03,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 2:58 PM, John Fastabend wrote:
> Yonghong Song wrote:
>>
>>
>> On 11/9/22 6:17 PM, John Fastabend wrote:
>>> Yonghong Song wrote:
>>>>
>>>>
>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>>> to capture statistics and information about running net devices. We use
>>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>>> information about the interface not exposed through the xdp_md structures.
>>>>> This has some down sides that we want to avoid by moving these into the
>>>>> XDP hook itself. First, placing the kprobes in a generic function in
>>>>> the kernel is after XDP so we miss redirects and such done by the
>>>>> XDP networking program. And its needless overhead because we are
>>>>> already paying the cost for calling the XDP program, calling yet
>>>>> another prog is a waste. Better to do everything in one hook from
>>>>> performance side.
>>>>>
>>>>> Of course we could one-off each one of these fields, but that would
>>>>> explode the xdp_md struct and then require writing convert_ctx_access
>>>>> writers for each field. By using BTF we avoid writing field specific
>>>>> convertion logic, BTF just knows how to read the fields, we don't
>>>>> have to add many fields to xdp_md, and I don't have to get every
>>>>> field we will use in the future correct.
>>>>>
>>>>> For reference current examples in our code base use the ifindex,
>>>>> ifname, qdisc stats, net_ns fields, among others. With this
>>>>> patch we can now do the following,
>>>>>
>>>>>            dev = ctx->rx_dev;
>>>>>            net = dev->nd_net.net;
>>>>>
>>>>> 	uid.ifindex = dev->ifindex;
>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>>>            if (net)
>>>>> 		uid.inum = net->ns.inum;
>>>>>
>>>>> to report the name, index and ns.inum which identifies an
>>>>> interface in our system.
>>>>
>>>> In
>>>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>>>> Namhyung Kim wanted to access new perf data with a helper.
>>>> I proposed a helper bpf_get_kern_ctx() which will get
>>>> the kernel ctx struct from which the actual perf data
>>>> can be retrieved. The interface looks like
>>>> 	void *bpf_get_kern_ctx(void *)
>>>> the input parameter needs to be a PTR_TO_CTX and
>>>> the verifer is able to return the corresponding kernel
>>>> ctx struct based on program type.
>>>>
>>>> The following is really hacked demonstration with
>>>> some of change coming from my bpf_rcu_read_lock()
>>>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>>>>
>>>> I modified your test to utilize the
>>>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>>>>
>>>> With this single helper, we can cover the above perf
>>>> data use case and your use case and maybe others
>>>> to avoid new UAPI changes.
>>>
>>> hmm I like the idea of just accessing the xdp_buff directly
>>> instead of adding more fields. I'm less convinced of the
>>> kfunc approach. What about a terminating field *self in the
>>> xdp_md. Then we can use existing convert_ctx_access to make
>>> it BPF inlined and no verifier changes needed.
>>>
>>> Something like this quickly typed up and not compiled, but
>>> I think shows what I'm thinking.
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 94659f6b3395..10ebd90d6677 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -6123,6 +6123,10 @@ struct xdp_md {
>>>           __u32 rx_queue_index;  /* rxq->queue_index  */
>>>    
>>>           __u32 egress_ifindex;  /* txq->dev->ifindex */
>>> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
>>> +        * BTF access. Reading this gives BTF access to xdp_buff.
>>> +        */
>>> +       __bpf_md_ptr(struct xdp_buff *, self);
>>>    };
>>
>> This would be the first instance to have a kernel internal struct
>> in a uapi struct. Not sure whether this is a good idea or not.
> 
> We can use probe_read from some of the socket progs already but
> sure.
> 
>>
>>>    
>>>    /* DEVMAP map-value layout
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index bb0136e7a8e4..547e9576a918 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -9808,6 +9808,11 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>>>                   *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
>>>                                         offsetof(struct net_device, ifindex));
>>>                   break;
>>> +       case offsetof(struct xdp_md, self):
>>> +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, self),
>>> +                                     si->dst_reg, si->src_reg,
>>> +                                     offsetof(struct xdp_buff, 0));
>>> +               break;
>>>           }
>>>    
>>>           return insn - insn_buf;
>>>
>>> Actually even that single insn conversion is a bit unnessary because
>>> should be enough to just change the type to the correct BTF_ID in the
>>> verifier and omit any instructions. But it wwould be a bit confusing
>>> for C side. Might be a good use for passing 'cast' info through to
>>> the verifier as an annotation so it could just do the BTF_ID cast for
>>> us without any insns.
>>
>> We cannot change the context type to BTF_ID style which will be a
>> uapi violation.
> 
> I don't think it would be uapi violation if user asks for it
> by annotating the cast.
> 
>>
>> The helper I proposed can be rewritten by verifier as
>> 	r0 = r1
>> so we should not have overhead for this.
> 
> Agree other than reading the bpf asm where its a bit odd.
> 
>> It cover all program types with known uapi ctx -> kern ctx
>> conversions. So there is no need to change existing uapi structs.
>> Also I except that most people probably won't use this kfunc.
>> The existing uapi fields might already serve most needs.
> 
> Maybe not sure missing some things we need.
> 
>>
>> Internally we have another use case to access some 'struct sock' fields
>> but the uapi struct only has struct bpf_sock. Currently it is advised
>> to use bpf_probe_read_kernel(...) to get the needed information.
>> The proposed helper should help that too without uapi change.
> 
> Yep.
> 
> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
> the rest of the way up and test it?

I have an off-line discussion with Martin. Martin has a use case
to get the btf_id from a pointer casting, something like
     void *p = ...
     struct t *pt = (struct t *)p; // having a kfunc to do this.
So I would like to generate the above helper to be something like
    bpf_get_kern_btf_id(...)
which will cover ctx case as well.

I should be able to have a RFC patch ready next week.

> 
> .John
