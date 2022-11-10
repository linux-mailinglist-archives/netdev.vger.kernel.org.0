Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3402362476C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiKJQsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiKJQsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:48:23 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B74018B1C;
        Thu, 10 Nov 2022 08:46:55 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAEkN60004854;
        Thu, 10 Nov 2022 08:46:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=6AaJnt6RoAHc4un7LHQM/+HxInXI95zeboEfeTz9YNE=;
 b=dP2rVwRLdQWDUXS2yEOwHANsD0hP5xtpqX/KOy1Rq8UcGBLB7lctcJJPYnXx+ctQb0V8
 9KIjRBpridgqxJemZmdpP9STZQeH9a0OACPBE/4PtunJY5kCuj2Ro4kfrftM6DOGrC9j
 7/D298O7ZG4Nxr+xMzfFW98R06MMUZ1SFnDmkPmcEB8nXLnVRhfkaMTL74NJmjK7wtrP
 kwpvsuxLPgprn4zNYoMLKfAMjRCv4d0GyuwnOwdL8+GZVYesK5lQ0TgimbfwO2vmhQ59
 h7Nw6K/j0/CWi1uBLxrqKOuK9M1ybB7r/7m+kaJjEDxw7rFMNGtDUfXkKw63Sluichuo Lg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3krmkepnwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 08:46:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oF5ETdwKB4oUyz6zu8BCuygNIM+vub87gAbYLL3ePz3ykgAhIwz58osAuviWBSdNpx5xw9XcREqicupo2rlpaPjeUVmpq+0mBHUWJEjP0C+lbTDweoNBtEW0u3vi39DZpTCrMeqa2DlDZlgyH/dTuFA4vRi1boZeZy0YS1DndjX1Vo38TfZXpeY7ii/tMvIHw7yofIi32XuqRdZSr+2nbnspM1OvI/X1g23hxRhVHxa0Cg3hVzXi0Dkp6n84z+tYiJJ0Ct4eNFGZdqVbG8r0TFaByPM0nvHJZLvxuKl6EUzPKHtKDa3Zo1nJTf9IEtp6TX9tG/mp+W03gb7LSokD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AaJnt6RoAHc4un7LHQM/+HxInXI95zeboEfeTz9YNE=;
 b=FoCjR15fkzEd3cDypplVojt3v/+2BlVele0wXfOiACSQxO4c5jU5v5M0oaN6WUtlisXaxOfYFBVJY22d2Pl5Dvx7EOG526GDXUo7hvVYTxTwsP/WYSfA/ug2Onh7YwySvFa8ggDX7zpL3Lz4+NZDJJmTEZ78g2jfb9nP3wUTwMbkbFG077X3Lf9q6NlLm1No84Aglrh3Bokf/vFqfOuuhP7eNKNNO2zcg6h62lJ/8MpcGH/eNn28So22p78ICMlzn7rQ+Y3lEhenZ/0Zmh8jN/vWaLNi6WngglGeTpc9IpjiVgzryRwl0tnK3ul9MxB7pmH8SZu4QHJywU+VvVPu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2204.namprd15.prod.outlook.com (2603:10b6:5:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Thu, 10 Nov
 2022 16:46:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:46:34 +0000
Message-ID: <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
Date:   Thu, 10 Nov 2022 08:46:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
To:     John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <636c5f21d82c1_13fe5e208e9@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MN2PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:208:120::43) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB2204:EE_
X-MS-Office365-Filtering-Correlation-Id: 94608b24-126f-4e42-9ac4-08dac33b1fe2
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEiI+uTZdVA8J7TAbHXm/aQqWTLH1t0kBqEnJFp5iiIxqJ2UTWfrOZpjNdleO8Oix3t9Ai4RYHxGxYfrvuncOhZGefP77n2C1qoKxfmEpMHv3zdikOKMLsxOyjsTqNLjsvVVoIAuy27DljqWBwsnCqbVq7pdnLVPbyXo3cZg6dN7vHvfr/4egg7SF3PRv/tqdmmqCy2rROy72XNfTaMLqgD5zFJk5PXKI9CbM6MuoWfP22yX8VLbRV+2FKPCmL2UX+C++xHOq+kmihqq29WtxOA/PjJ+FkxE6I//iPulF353bI2P3I8tnDkZh1utBSNaDv+dMGfMemm+S4QFYZVm0NVf4S+boo732TLbz15TQwHvpxxViY67lCu5zofk6DefWsT7o+2xJEndThH8yXy1eqot0+6WwjGXPWsZSC30YOhXiAyUcpB5tIbBdeOKgd9+rsOIC/+Gu85GxAprNf7T9fEPDZbAc7Pyvt38szrwstpD2i0g3raF4s5LzEgUm8CVQMABqjK8Ff/3o7DcWn8XKPx9mcZzkvg1GL8mp52aO8Xxz8PjmbjYhFT0EJmS/GsgNG9eSQG0gWVvgvPOSsdDLyu7nDyARSLiLnhC290UEHoutFyxWmSPtmhfZsS66gs9Pff+S+B4P27jFotP5VE00g740a2Hc2WYhagEiy4v4/lbTeByaAU5uAjcTDoLmd9DqfD8XlzqAkZUwHUKQ7hgDfjk8XOMDQ17hgayJC2K/B6qztY4jQCJctuOhy89ObflPh0jZG80imncCVaLsJcgYfyXYbBeaeWpLzXbJtO2YDcRRjlNR883LwhjDfgkOWGfZ8GgIkK2ST/giUTp5rLP1LTBjFyaZ+j1xpJSyeB3gkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199015)(31686004)(8936002)(86362001)(5660300002)(36756003)(31696002)(2906002)(41300700001)(8676002)(4326008)(6512007)(478600001)(6486002)(53546011)(66946007)(6666004)(966005)(66476007)(66556008)(316002)(6506007)(186003)(83380400001)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ektzanAzbEpiTFdpVStwb3ZzT29mRmZPemRla0xZU2t3ODVuYjBnTkRtVy8y?=
 =?utf-8?B?K3JnMnVuSldvZXhaYlc2c1lvcW1IQU1yakNWaXRUNm5lSzhBb2pzUXRQazdO?=
 =?utf-8?B?U2ZLdlZzZFkxVE9jMGQ0MUtTMStzYVlnUW9paGR6bnMxWlVvTFZ4cXJwZVVs?=
 =?utf-8?B?eGN2YndBa09LdUZwNHJYZWJFM1dOWG1INlU1eFVwaktIUHFzVzNMRWRNUFBU?=
 =?utf-8?B?V29ldVdPVHlWdjNWVk84Y2puRnAyN0JieEFKUUpjb1FndHdnSjlwL29YRFcy?=
 =?utf-8?B?OG9DbjNscGt0cWFkRlZGeUhvdE1QUnRKNENhN2hza0JtVUdHRVlhbnQ0OElV?=
 =?utf-8?B?TVBlbEFFYVFMWjVCMkRMamo5WEZ4eEJoVXAycWFqRnQ0ZmZhSUJpTmR2bHhv?=
 =?utf-8?B?MmhKNkVkOGlZRGkrQ25CV1ZIbk56dFV3NktDeTUrdWUrMXNINVJTd1hiOWZH?=
 =?utf-8?B?SkFJRmhYaHVMem55T1hiYytKM243V05nV0lOL1JiVE9ENFNWOW0yMmtIbjc2?=
 =?utf-8?B?dUhaMUpmNjk2RUIyZ05BbnNFalplTUpzY3h0ekhvSndDUG1BYUVFeGRadzI3?=
 =?utf-8?B?OE1qUDRqM2lBeHMwK0E1TkUvelIwU09NRFRsdFVZMTF4ZzcybXVuaTY1L1E2?=
 =?utf-8?B?VVZnS2Q0WGVscnoyTUoydlRSVXpiMnptVk9TY24rY0t4QzE4RmJtVFYyTmxH?=
 =?utf-8?B?dkliM2NIOTBMQkdHaHhBdllmcTE3MGNzN2V0Y3NVdjBsOUYxdkowWEE3UnN5?=
 =?utf-8?B?RGJ5ZVdMa0wzMjFVUU85azlTZFhBTXNFZlErOE16SzdyZGRQK0UvUnROYmk1?=
 =?utf-8?B?R1lJYUpVTmNUdW56TDJad2xFRkE1ZURLVVJzeGlaVjF0aWNKandoSk45Y2Vp?=
 =?utf-8?B?NUdJeS8xc2Z2U0dheUd3U2xsZnN3c0NLZXlUa2ZTbnEvdGVZaFpxdkQ4Vkhi?=
 =?utf-8?B?NnE4dXBLazhWbHYySVZvWkI5S3FmL0laYmE4eGF3MWU2UTUyTkhxZ09yQ0Rk?=
 =?utf-8?B?OVVqRDZEMTk5Z052UFFPaUt6Q0V5UXMzSHRvdS9WZEtGUkkxVW1vbDZZYndz?=
 =?utf-8?B?NnBNMmhJUjNMc0swSUhvamp2VURRUU5rZ3ZXeUJ1MHJqMTBPTnlXZldJN2U3?=
 =?utf-8?B?ZE1JOHY5T1hGZkZaazEwVDZlb2FMNCtLZ0FTVkY3eEFrQXRVeCs4STlXc2FQ?=
 =?utf-8?B?Y1FiQnBHMTJ3K3VobllIbjB5V0FBOHRxRE5vNjZrWlpCb0RWK2ljcFhWbVgv?=
 =?utf-8?B?NHR6UUJwcmNKb0lnTmRhS0ZuNlpPWS9nTy9kUE5iQkwwR3JoS2hybHVHeUF3?=
 =?utf-8?B?WkErYWV1WnQzZ2ZOc3lhTWFzYnhTTjR2dHN3ZGUxOTR5TUlzcFB4clFYNnp1?=
 =?utf-8?B?Y3I2bTJ0Z2NBWHMybzNKZWlJTkx2ejZtWG5UNkNlV3FiQVF0bWpzdzdpYmdC?=
 =?utf-8?B?VTVmN2dTcUtjZ2FrZFZEL3pZclg1RDhJTjdMYkx2RlBXTEVZanRSS2xlQk5W?=
 =?utf-8?B?ekNXNW9KVWdWNUEySWVEdUtvczR6UkgrZVk2MUM5QjQ4UVc4ZlBXYVZpRUpu?=
 =?utf-8?B?OC9wSzRRcGFydGtXWkN5SjdqbmI5SWRmT2RsSVp0dmJValo1SFBaWVNCK1ZG?=
 =?utf-8?B?ZUNxVGZRSXUvaXUwbTZvTEt3ZlhERGJoMklKK0ZZc0RRWStQekZLQzVCNlJy?=
 =?utf-8?B?NXVaYXJLVTFLMkdvN3lZZ3BESEhNdDVldWlhU0p3UlhwTXhCKzY4d0F5OFZm?=
 =?utf-8?B?WC9KZVhkbDdHSFZGS2lLcktKMUYrTVF3K3ZwTU9DcHJjQStVODNvWmorNFQr?=
 =?utf-8?B?VWJKcGx2YWNrWXpmd05rOHUxVW9sY1FGeHI2Q2hmZHZQOWpTaXJ3MGNKUlBk?=
 =?utf-8?B?Q3Z0bTIvVG9CNFRLSFRRWm1TWFlwZ29oSHZUS0M2M3psamJqZ3lNTjZuSU5h?=
 =?utf-8?B?NW1Bek5FRG5YK1VmT1Y5TElSbVNIS0NhdkZLY3llMERxWDJUeVE0S1R5VThh?=
 =?utf-8?B?L21zaXBJL1BGYkdXQkhocUVoakhEOWJBbEdTelpmaHJjUWg1N3huQnJZT1Bx?=
 =?utf-8?B?UllVWHV6MEluVDFodzE1Q0J6OVNFQXVsN1JKUUpYK095b28rdXFGUS9WNUpT?=
 =?utf-8?B?dTMzTEtrUHdSS3FSVUlqcTl1U2VnVUpsdklnSERGNGtYU3NrcFZQbDA0WTZK?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94608b24-126f-4e42-9ac4-08dac33b1fe2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:46:33.9589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: laSEgdt8eL1wzhSQDOuZGtFYtX1gFKXKQdt6K7mF2fe7Ox16FTJqIz4NhZZml7Bb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2204
X-Proofpoint-GUID: VMIytPS_nUauIBWsuhH6RDqSrkDyH1vA
X-Proofpoint-ORIG-GUID: VMIytPS_nUauIBWsuhH6RDqSrkDyH1vA
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



On 11/9/22 6:17 PM, John Fastabend wrote:
> Yonghong Song wrote:
>>
>>
>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>> to capture statistics and information about running net devices. We use
>>> kprobes instead of other hooks tc/xdp because we need to collect
>>> information about the interface not exposed through the xdp_md structures.
>>> This has some down sides that we want to avoid by moving these into the
>>> XDP hook itself. First, placing the kprobes in a generic function in
>>> the kernel is after XDP so we miss redirects and such done by the
>>> XDP networking program. And its needless overhead because we are
>>> already paying the cost for calling the XDP program, calling yet
>>> another prog is a waste. Better to do everything in one hook from
>>> performance side.
>>>
>>> Of course we could one-off each one of these fields, but that would
>>> explode the xdp_md struct and then require writing convert_ctx_access
>>> writers for each field. By using BTF we avoid writing field specific
>>> convertion logic, BTF just knows how to read the fields, we don't
>>> have to add many fields to xdp_md, and I don't have to get every
>>> field we will use in the future correct.
>>>
>>> For reference current examples in our code base use the ifindex,
>>> ifname, qdisc stats, net_ns fields, among others. With this
>>> patch we can now do the following,
>>>
>>>           dev = ctx->rx_dev;
>>>           net = dev->nd_net.net;
>>>
>>> 	uid.ifindex = dev->ifindex;
>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>           if (net)
>>> 		uid.inum = net->ns.inum;
>>>
>>> to report the name, index and ns.inum which identifies an
>>> interface in our system.
>>
>> In
>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>> Namhyung Kim wanted to access new perf data with a helper.
>> I proposed a helper bpf_get_kern_ctx() which will get
>> the kernel ctx struct from which the actual perf data
>> can be retrieved. The interface looks like
>> 	void *bpf_get_kern_ctx(void *)
>> the input parameter needs to be a PTR_TO_CTX and
>> the verifer is able to return the corresponding kernel
>> ctx struct based on program type.
>>
>> The following is really hacked demonstration with
>> some of change coming from my bpf_rcu_read_lock()
>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>>
>> I modified your test to utilize the
>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>>
>> With this single helper, we can cover the above perf
>> data use case and your use case and maybe others
>> to avoid new UAPI changes.
> 
> hmm I like the idea of just accessing the xdp_buff directly
> instead of adding more fields. I'm less convinced of the
> kfunc approach. What about a terminating field *self in the
> xdp_md. Then we can use existing convert_ctx_access to make
> it BPF inlined and no verifier changes needed.
> 
> Something like this quickly typed up and not compiled, but
> I think shows what I'm thinking.
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 94659f6b3395..10ebd90d6677 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6123,6 +6123,10 @@ struct xdp_md {
>          __u32 rx_queue_index;  /* rxq->queue_index  */
>   
>          __u32 egress_ifindex;  /* txq->dev->ifindex */
> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
> +        * BTF access. Reading this gives BTF access to xdp_buff.
> +        */
> +       __bpf_md_ptr(struct xdp_buff *, self);
>   };

This would be the first instance to have a kernel internal struct
in a uapi struct. Not sure whether this is a good idea or not.

>   
>   /* DEVMAP map-value layout
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..547e9576a918 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9808,6 +9808,11 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>                  *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
>                                        offsetof(struct net_device, ifindex));
>                  break;
> +       case offsetof(struct xdp_md, self):
> +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, self),
> +                                     si->dst_reg, si->src_reg,
> +                                     offsetof(struct xdp_buff, 0));
> +               break;
>          }
>   
>          return insn - insn_buf;
> 
> Actually even that single insn conversion is a bit unnessary because
> should be enough to just change the type to the correct BTF_ID in the
> verifier and omit any instructions. But it wwould be a bit confusing
> for C side. Might be a good use for passing 'cast' info through to
> the verifier as an annotation so it could just do the BTF_ID cast for
> us without any insns.

We cannot change the context type to BTF_ID style which will be a
uapi violation.

The helper I proposed can be rewritten by verifier as
	r0 = r1
so we should not have overhead for this.
It cover all program types with known uapi ctx -> kern ctx
conversions. So there is no need to change existing uapi structs.
Also I except that most people probably won't use this kfunc.
The existing uapi fields might already serve most needs.

Internally we have another use case to access some 'struct sock' fields
but the uapi struct only has struct bpf_sock. Currently it is advised
to use bpf_probe_read_kernel(...) to get the needed information.
The proposed helper should help that too without uapi change.
