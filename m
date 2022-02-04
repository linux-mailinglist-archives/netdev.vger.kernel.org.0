Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11A94A9D85
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376798AbiBDRPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:15:49 -0500
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:39494
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234482AbiBDRPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:15:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV1Mm2hR1XNtVi7BkWLGNgVcmRnc2nV8wcIuWd16gkcl+21gNSnfe0j3q872SWwe9XvVRp7xaB2gNVPWiQwpFNRQTqNmusqRpfb5eEpYyL7+6fw//tphNqb5xub2HVjsB+owSqIzC7IGSTSw2ymP2DWfhPbbQNLGVJvt0Emm8H4vvGadTVTrphLcCl7ICVE8vrXoSgR6NMbQ4kRHDXcbNBZCdmUuNM7gRJq+TDBakhYQHjSNlh+yPYXQC5DzUgEOPFBBNYHJhEHA0m0T80VgfNR7EiRClpkSECcHzwfd1Wj74/mslBle0kHouGxoNRezRMYic6XAWXbP97lMDbZvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogU9PdY6nIPzgzDrpbr2JBCBnhIABz6TfGPulLFsk2U=;
 b=AzhmbdANCLnfBMhQtwfYEtheg4NGsEC0FaGnSBoLjIW2YGllmgMCTzOhfvZJ95XBpsv4qH3UqSRnyUbNevfuuI7JSjUxfaCJPvrPCl+4QpuyK+pNSj2SCa1q0ccsaBgwIglRQJOTOmWJ+QzqiHJPY41ea/Wv/5rixXn59XcWmiyvu5Q3v3zsKneEqpUecVah7YPxkMPUZMKBw3M0RJuIE17PCh2hhRTKaFUw8clo+v9ON9CjZE5c7cIO6/qk3fpOF8taWB/3cycvVAM5P5WsnsPhN3pxU6cVU97muuIQNG5G1b3wsKoAxhIKm+GcX/C3jw4/VORWBa5Izti8JONV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogU9PdY6nIPzgzDrpbr2JBCBnhIABz6TfGPulLFsk2U=;
 b=QLlaybKBA65pbtjci+qlGRS193iBznOew98LktgqGyhcZC+V76jvjWoMDNvQW5HZvCQMugouaGpMeY4alGY5rvGRLna5qLjIpxQ8slyuVo1vYBkZxX833MIExnXYJkDyR5ZDWkaDkZkN94CrWRrjhgI+QlgKiNFSVojWRd2d5Ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS8PR04MB8803.eurprd04.prod.outlook.com (2603:10a6:20b:42e::24)
 by AM6PR04MB4247.eurprd04.prod.outlook.com (2603:10a6:209:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Fri, 4 Feb
 2022 17:15:45 +0000
Received: from AS8PR04MB8803.eurprd04.prod.outlook.com
 ([fe80::a465:f23f:268e:be3]) by AS8PR04MB8803.eurprd04.prod.outlook.com
 ([fe80::a465:f23f:268e:be3%8]) with mapi id 15.20.4951.016; Fri, 4 Feb 2022
 17:15:45 +0000
Message-ID: <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
Date:   Fri, 4 Feb 2022 18:15:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed after
 scheduling NAPI
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
 <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YfzhioY0Mj3M1v4S@linutronix.de>
 <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0076.eurprd02.prod.outlook.com
 (2603:10a6:208:154::17) To AS8PR04MB8803.eurprd04.prod.outlook.com
 (2603:10a6:20b:42e::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 869e5669-b85f-4ccd-84c8-08d9e801fa6e
X-MS-TrafficTypeDiagnostic: AM6PR04MB4247:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB424772AE2F51523CADBDA1F2D2299@AM6PR04MB4247.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5icxvtDIYqiYvph8hGXGasv9IOnBWUYRkWzoCEk4oca1zdIOAGHAP4v6QHdrdqytNe8U45XJXFhbBy0afF/YMO/Qas5alLJVKmV7MZzG8Tf15b7SldYkW0RWa1iD1Z/fVeg1fEbIBBYUP04EW7VkDCAxQFEN8kIJ3bmTPrc7EqTxyE2JZn0ByR3KfKv5mXQWaJQim1VcDafyfFtmQ+lN479bTndWehBWQMZqEfUcvpDjMV5ZfFroblbf7mCrbOpMoIUMIXkFHELlrD22SVQBEt8WnwreYs7IJTWg2xeYJDtdmX+lPYCq4Y7MtQ7e0ERbV7vJNbeZRXpmCH4yAf+xGWNapkUnM+30uYLv1cigkg8mpKM/tffQjtwNH/gSDQVaK6SHc6D38yAe36IxOVfnvKvtfYv+7Sz7+oCN1YWC8rrKi4vBt8oka2swaRSJDU1hQ+PsVFG5mquh/gMVccBoN1ASZndc3yWxELPguMWSPnGhpCLzO2kiGmI2/zZfe3fVqSKIsTsROEahF5YtPF/+7T5MGdK8H8+N7Uj1fhkegePlhSZjvmrRyy5WuNKxoPEVCS1SYkD0988PsoaB6FhrF8J54J1WIqtCF8YsSyT3kEuTaYL8FYHuzD/bG0Dh2NHjDUJzB0iHDJCJ+XadxAhU8S8F0rcESZOULK1D8p/jbozOIBby3tIeXy1YcmD25FyIdE0SM0dfCYWR7Ez5UczvWKcBeVjc8QsfHWhBT1n46/W4awL0NyYZ7TjwDP49TL2lM8VyDrmM2UzhsUxQvavVzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8803.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(26005)(186003)(38350700002)(38100700002)(54906003)(66946007)(8936002)(66476007)(8676002)(4326008)(66556008)(6506007)(86362001)(52116002)(53546011)(2616005)(316002)(6512007)(2906002)(6666004)(44832011)(5660300002)(83380400001)(7416002)(6486002)(508600001)(31686004)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N21aY3dPcG1YZ2N6eDh3VUJGQlZ3Zmt6bXg1d3NxUVlSL1ZVclhKSklqUHU4?=
 =?utf-8?B?Z2JxYWtOVGsyVmlOWDA1TzY2and2SUlwc1NIQTJvQmFCQmhRcUxDdldEQ3lO?=
 =?utf-8?B?dHMyTEVqUEFhQzFnME5aUXVIdExOQVVjenN4UldFaVh6UnBYQXczQ1U4RzVN?=
 =?utf-8?B?Y1NqcjZjTnFhS3BJTWhPZ2R2RjdtMHNldUlVUGRRbEREWTJ1Nk9NU0M4dHdT?=
 =?utf-8?B?VUtIbHgwWlRkdUJzTEJTR1FMVTdVZEdOTzUxNllpd25qeEhYaDN3dDNEQlpX?=
 =?utf-8?B?MnBHVFRyWFFmdkxqQzRIdHVTeFIwU3hxdmw1QUN4bDBwTmhOV2ZGUzhieDlW?=
 =?utf-8?B?Sk5mMXZMUnludkFXcDZSYW5nUWFNWGdHa3lSVTUyWWVuNHpYeUxpTFU0STlY?=
 =?utf-8?B?ajYyS3JRdUlOKzFDb3BDWlpZcmJjQnN2RGhhMERRdDhnUU02NGl2UHRURDl6?=
 =?utf-8?B?eXlZS0NIc0pYeldwMkl0dlRNTkRPcU8xQzlmMXBPNlFwVy9hdjEyR01PU0Q0?=
 =?utf-8?B?QWY4bEczZXg4RGord2QxNVRkM3l5ZEhFSjFoK2xZa3V0aTdCY1BJbE5qZS9Q?=
 =?utf-8?B?U01VQmY2VlZxeHBIUm5SRUVVb1UzTDhuZFQ2WlYzRFI3UmJvTDNmSXF2UUdL?=
 =?utf-8?B?WUlaYkNXU1BqdytKZ0p0VXJCaG5LcmhBRHFMbFVrTmdhWUpsVGJiZ1hKRmpu?=
 =?utf-8?B?ZVVFbXU3N2pzUCtYS1pSbEFhVm9QMFlhOUl4R01YWnQzZXNUSVdKajdSRGdC?=
 =?utf-8?B?YUJGVUpDUmdBeUlNQWZTcVprV3dIdkF1YlIzS1RSQ1BHd1NEb1U5Nmc4MlBK?=
 =?utf-8?B?QTl5L1FEM05NSWdQOU5Cd09XWnhGT1JvZTNNeDJMSmpuN2c3K0NTQThEUVRl?=
 =?utf-8?B?NGtzRE5kOFdkVlVQTzFIelFDOTc0SEtjOXJpR3JwSE1NVzFpdTFyNmNocWw2?=
 =?utf-8?B?UG1qVkFPSWgzVkFScFlYWDJraFQzRGxwK0ZQWUhSNUsrQ0p6Z3VKVnFIUzdP?=
 =?utf-8?B?RzBqaUphdUJrUDhnTDVJS25pcFYzRkJTdGNyZ3dwOFBhV09YVEVsS1hXc1hq?=
 =?utf-8?B?OC80eE9sY1Z2WHdDRU4yaWVkNkdZZ2Zla3V1NlFUUmd4cFRUakZDVTBLZ1o1?=
 =?utf-8?B?K3lFVlhGRk5WbjQvbEtHWGlSRmhEL2VGZWo0eEF6cUV5aTdyZ3ZRVk5IRlNH?=
 =?utf-8?B?WmxwMXlvbFQ5UHUzS212T3lsbzE1WWx5UEdMVkRDYWlCSHdYWUFUNVovTFdw?=
 =?utf-8?B?L0F4TU9nUlNxVlVjRTd3ZVNFcEJ4WFlhaDBKRS9vWTZuMXgvQnNldWx4VE1m?=
 =?utf-8?B?clBDdFFFUkN3TnNCRVZCTkFTRmVtVytlTTh4cGFSL09ZQzhXSE1oN2d5bU81?=
 =?utf-8?B?ME9NNmFURjNWcFN0eUpvYit5MGdSbXgzR1ZtZDR6ai8zQzNQcGQ5QW1ycGtI?=
 =?utf-8?B?N3BPUm4vdHBYZ3RFdXo2VThURzRLeUV2MnRKMHB5aDVzQWZneTRJSjdzQzlR?=
 =?utf-8?B?ZFBKWGhYeURkRFZ3T25JN081eU9hSkI2b2FEV0xpRlpWUEtlMWpDeWNzWGZz?=
 =?utf-8?B?QUg4em5KWDFGcXpRMVJCOUJ6TEhveG40Lzl5WUhuRTRtVlhxdVFNRUgyZTQ3?=
 =?utf-8?B?UzQ2WU9IWVUvdFpJR0ROeVpPc3IvakJqbW5qTGxPUXZOZk5NQjY4a1A4VXpV?=
 =?utf-8?B?UUUwODkvWjVNTmkyYThNUjhNeEVPM3pDN0xROSt3YzZiQVB6SXp4eUN1UXZK?=
 =?utf-8?B?QUc1SnY1Z0JCNi9aQ0RzUzM3TGtOUEtNd3V5aUk1R2VJNGpoa014R2tvUDBW?=
 =?utf-8?B?M2EvcTEreTVrZ29QTEN6ZEZYK2p3a3ZvTlRIdE5seFlobWZROEtRem12L1FL?=
 =?utf-8?B?WEdYMEtvSFFGZFd4RGV3T01pcGJlYkVmcXBxWTJyM216NVQ5d2Y2eDVhcUdu?=
 =?utf-8?B?MlphYkpxUFJIaE51TDA0SHl6cW41TGxVNS9IWkZhOXZ4S0tRdStYSENvcUI5?=
 =?utf-8?B?enhLekZZZEl6SjgxNUMrUDZSUXR1YktldUQycnhyMVcvZ09qeUpRMndac2xN?=
 =?utf-8?B?a3lDWkpYNEtRazRlWWVqdmd3U2dDYlRBUjVGaWxaNU1UQlRUdkRnTjJzbk9Y?=
 =?utf-8?B?UnBRVjUxYmNKcWtxNVFLTjB3bi9JMHRCUnFXZzB1VDc4T25GcWJ6NEVSL3FP?=
 =?utf-8?Q?Z26h9WsuD347YqsBlCBNboI=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869e5669-b85f-4ccd-84c8-08d9e801fa6e
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8803.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 17:15:44.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5JMgyfmPDhwefFSnInL74LwHNkNDNAnZ841wtDMi/bqvcbFu+KBNj0iLtizGKHYaavuSb7joZcBTImRvthaIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4247
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/2022 4:43 PM, Jakub Kicinski wrote:
> On Fri, 4 Feb 2022 09:19:22 +0100 Sebastian Andrzej Siewior wrote:
>> On 2022-02-03 17:09:01 [-0800], Jakub Kicinski wrote:
>>> Let's be clear that the problem only exists when switching to threaded
>>> IRQs on _non_ PREEMPT_RT kernel (or old kernels). We already have a
>>> check in __napi_schedule_irqoff() which should handle your problem on
>>> PREEMPT_RT.
>>
>> It does not. The problem is the missing bh-off/on around the call. The
>> forced-threaded handler has this. His explicit threaded-handler does not
>> and needs it.
> 
> I see, what I was getting at is on PREEMPT_RT IRQs are already threaded
> so I thought the patch was only targeting non-RT, I didn't think that
> explicitly threading IRQ is advantageous also on RT.
> 

Something I forgot to mention is that the final use case I care about 
uses threaded NAPI (because of the improvement it gives when processing 
latency-sensitive network streams). And in that case, __napi_schedule is 
simply waking up the NAPI thread, no softirq is needed, and my 
controversial change isn't even needed for the whole system to work 
properly.

>>> We should slap a lockdep warning for non-irq contexts in
>>> ____napi_schedule(), I think, it was proposed by got lost.
>>
>> Something like this perhaps?:
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1baab07820f65..11c5f003d1591 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4217,6 +4217,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>>   {
>>   	struct task_struct *thread;
>>   
>> +	lockdep_assert_once(hardirq_count() | softirq_count());
>> +	lockdep_assert_irqs_disabled();
>> +
>>   	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>>   		/* Paired with smp_mb__before_atomic() in
>>   		 * napi_enable()/dev_set_threaded().
> 
> 👍 maybe with a comment above the first one saying that we want to make
> sure softirq will be handled somewhere down the callstack. Possibly push
> it as a helper in lockdep.h called "lockdep_assert_softirq_will_run()"
> so it's self-explanatory?
> 
>> Be aware that this (the first assert) will trigger in dev_cpu_dead() and
>> needs a bh-off/on around. I should have something in my RT tree :)
> 
> Or we could push the asserts only into the driver-facing helpers
> (__napi_schedule(), __napi_schedule_irqoff()).

As I explained above, everything is working fine when using threaded 
NAPI. Why then forbid such a use case?

How about something like this instead:
in the (stmmac) threaded interrupt handler:
if (test_bit(NAPI_STATE_THREADED, &napi->state))
	__napi_schedule();
else {
	local_bh_disable();
	__napi_schedule();
	local_bh_enable();
}

Then in __napi_schedule, add the lockdep checks, but __below__ the "if 
(threaded) { ... }" block.

Would that be an acceptable change? Because really, the whole point of 
my patchqueue is to remove latencies imposed on network interrupts by 
bh_disable/enable sections. If moving to explicitly threaded IRQs means 
the bh_disable/enable section is simply moved down the path and around 
__napi_schedule, there is just no point.

