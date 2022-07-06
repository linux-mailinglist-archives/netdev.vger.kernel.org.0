Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0D567D69
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 06:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiGFEjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 00:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGFEjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 00:39:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2996A140FD;
        Tue,  5 Jul 2022 21:39:17 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265JJIjM016561;
        Tue, 5 Jul 2022 21:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=ghAuseEe2sciQPBOlowGFFE/ZSVkTpz779ptDAgl/18=;
 b=jFSM9MjZmaP1Oyu7TKCgnLDWnFaP3PNUqF/1XgfW8TIt/i6HRAS2mGBAaZ48YT+9l9Xn
 pBfCBvpaLyWdxrgW1syHwu1WurYVDu3Blyr2YgwqxVMcwylI2Nk2OfqhvKQCUeeoQ8AY
 usDVpDo/jMsoyvLzxskMp7hqIUm2CDg25w8= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4ubuu0cf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 21:39:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfkPm2gqCwo8XhrctuXacp0lRIHsWqRNX+9D2eqO8fjXFJJdrDblSIIndMhvx/liD7+27xl68CXyla1Dys6EHr6lf6qJaHBpq/b6xj8cqXQlM1UEg+rdsYhGNxGjEkmpEEHGIm2EIcSjo941++gHUd3S0Ju95bUtKDqZ/hvE8ueayIZrfxBgL0cnP/j85AY4YOvRpAZqMB/YK6Bdl0d9KiS2JY+A5mzmpablyb3rIgazYBDNBWqEDv21f3S5iNCgS1qN6qJrVt3Yg+rCq9I5sZpGYy+aAO8s+oUM97Wmhe5M+UIXalcTCeWFV4TPWsApG1XwuT0EYXuMWvFQlsPnpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghAuseEe2sciQPBOlowGFFE/ZSVkTpz779ptDAgl/18=;
 b=V/C9hAIwvxTcQdZyQyCRbSjKaxL1DLbF2d10m4M/hFBdm7kaXzqRyvNZhVjeQbnOR0hBaGi5pfx1rYM4JRw21Gye0+5onkNiJnbAjVmsnvd6ZPiUeGAKE0AA0UdyQF8PJmUXmbo8Q8ITEPLCctoGXxv8TryxSdEA7hopYBrNNunwdKiy3qjReU+C50+mPuRjtCH1OtIqzfWbzo6ojtizmZDb3KxBjIh3GlEtld0zh5suPeDlq703ceoqp6tMX2EcVlmzDjPuvGN1jzjjNvdxUr9wST7dCJq5lKe+D8ihlwwVG+zsa45TPrD6j2rpIOYPOWBSlthFNepMpxJaQahJ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1529.namprd15.prod.outlook.com (2603:10b6:3:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 04:39:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 04:39:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Song Liu <song@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@vger.kernel.org" <x86@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Kernel Team <Kernel-team@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 1/5] module: introduce module_alloc_huge
Thread-Topic: [PATCH v5 bpf-next 1/5] module: introduce module_alloc_huge
Thread-Index: AQHYiBVqlBf3ejsVk0e2vcWl2AErh61qMkKAgAaiQYA=
Date:   Wed, 6 Jul 2022 04:39:13 +0000
Message-ID: <16959523-ABD1-4D2B-B249-118DDADD7976@fb.com>
References: <20220624215712.3050672-1-song@kernel.org>
 <20220624215712.3050672-2-song@kernel.org>
 <Yr+BV+HLZikpCU42@bombadil.infradead.org>
In-Reply-To: <Yr+BV+HLZikpCU42@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62847a26-4621-456b-e0ce-08da5f097a3d
x-ms-traffictypediagnostic: DM5PR15MB1529:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GcDYNCa9hpdNPtGZVDJynSD88rEQLmtaOvgv9TU/IHx4wedbMrIbwC4Vp765Jhf5NIe9JveRYVQbp8DgxNu3I+ApFvOneLZH8tiJmyh5vg5TDnlduXlhNY9t325e6rMGhHYtZmJYnHdb0K2UMR3yYO5FgALXaWoH2jVvuSIFvLZKriMQ6MELJfk4mGJpDvXA8svVwQI2QhSaAKpKMlEJzN7jezraoagheqSMQDrUBFK3dSFyB/ZMhBTruZCkLEGMC65pkzraD57QaGFdrTxT6nfK3Fykub+VDYtmGuqrL7Mc4vYsa0Twlo19IuZ05N0upR89tk2DpavSv1Q1Fahqb3UzwbCxfkL5ClM+iRB13zVYRdit6fc8t+72atsrLSD/LzQ5GzfYI1ym36rrsGIW39JTdRzuIdu9Wec0jym5omJWhjIjg/U3G1Y57JrjmHNVrpbQkfNT+n9+8hvuNYHMaN0yoWtP54BGrPQBhLYOJ4wnJc2MfyepSaUthzRFGBjZCJ9E4fRaU8G64cc5Lpb0FjbuPdSykiH/bZF1sqSh0E3Ee+NGxlAZUKsUqARy4VhULVH+Ov/1h8RiOCG5ZmRn4SdC7su0/W9uGM9SDtDsvDfk1fjhwtDwBEqFeIcWnGWT4iAxujJRdY3gfWzOAR67dhIiKeUaOenpoiLU7VFc9ne/lbT1tIX6h/fB4noderp2JTKYptrmpu2U7DZfO4u0yy0btQ9S1j76fC+7sZpNvh3WecPrfBJkS9oL+cJk6ftxuMDH9qrgLAm7yV3oQxrcF/xINg5b/JKVXGbxQquKqnsaCwcHJeM0Ho2T9DoE7qXIGnSVqh8yBDzdrVVbKKwrdAljCBWRN7lM/m2qOJtFEZcqUiX0XAlLsiZNdrzfQ2XU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(54906003)(83380400001)(6916009)(71200400001)(36756003)(41300700001)(186003)(33656002)(316002)(4326008)(6512007)(76116006)(8676002)(91956017)(66556008)(66476007)(66446008)(64756008)(5660300002)(66946007)(38100700002)(6506007)(8936002)(2616005)(6486002)(478600001)(122000001)(86362001)(2906002)(38070700005)(53546011)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kzg92S8Z/6w6r9nJLbbSWIf8qoJZMlX+0rP+qiFUZ1CJeAr3QILhktH1bv1x?=
 =?us-ascii?Q?Up2/PrFELXVjjS5G+t5oUShHqX+MAk7NTnpflUgaQMoAbwYsCly7NxTqAFAB?=
 =?us-ascii?Q?Ft/uF2N6tguQUWwTkTe1fW4bXc3jVUV2VOrRHAzg9miIvrQzq6P5kcIGF77q?=
 =?us-ascii?Q?yB4BOczb3/o4tER+iK/7kKg76QnESinGgzzbY1I5/dpT+R29LP/ta2Sdvu6N?=
 =?us-ascii?Q?dTRORhKF5Lkg3HQ5yt/wQXW6N3AUWd/meQXb/XS6HdkjY3rvnJZY/QbesnYd?=
 =?us-ascii?Q?whosYUsa7IFvRLzu5pcsby52jc+nAM7EWd3PewwV7SX4tBn8rLeWaw3jekp1?=
 =?us-ascii?Q?4nIaRmBrF8W56W24I9v4ejDMK7Be1+L3A4mQ0S7QJNJ/SdUdkQfwdiR6XcRN?=
 =?us-ascii?Q?4LDbA9bCRCxpGk0vZMkBU0up6MQxzq5kn+qcoK4YFz9LvUgojDFgxKYPUmaz?=
 =?us-ascii?Q?LYDgRSuQIBzreSYwr0S2RaftW8pG46GBfc7lE8pacqfk2g/Mx+HUE2tf7Tq4?=
 =?us-ascii?Q?R9FZzuxF2kj7J006kxQDsVHodKkHKuTQZia0jnNlokPrKtKkg2RBy/bWykIK?=
 =?us-ascii?Q?R/5OajIh7LuZ9aguhO4BQ64UV2lqrUmkQmogsyYu9ceNrX6k4okGZIfrriaA?=
 =?us-ascii?Q?PS1slpJ9ye38NA0Q7esesJ7cLkaePgJnCIu5cQyVK1MS8gLcsZiYdbH03eCF?=
 =?us-ascii?Q?uX2VghOjRghDWs/4/lvPE77zoz1Tjvk3f5RVHsWI4Cw19xyWDdx6P9JI0oSd?=
 =?us-ascii?Q?JgocayDgJrGzTanJIYlyZNHhUmJJKExWXkmpI5Yf1LZlGm2DG0VSyZD/0jMb?=
 =?us-ascii?Q?YAodKJkv2amdSEL4oT3oco6Z9u56QozpEJLaOUgfANiV5IKjEFeSPWfCcTSY?=
 =?us-ascii?Q?/DiXPH8CiS4LMnCYkwUp1sAm6Y4As8Tji1dvVmD8j1Vj3a8DEyNND6G0XdLW?=
 =?us-ascii?Q?RAfkTXgZhMob8lsODTSEs4HiJaEuh3nBrIFVpdY/XbrzEgu4J4UXRjOKXxoX?=
 =?us-ascii?Q?Gh6qLI/Ma2vyRC9dTZ6yOScYb7v+4jmUt5K9XrY68EhRfmT+ahpWL9opYXXu?=
 =?us-ascii?Q?jvJOOKBhV3hldDmS4zN0fB7q0crE9iU/PN6fAMsl3G3kpbJ2FAbA4nGkGX3o?=
 =?us-ascii?Q?I28CIoTz36X0vNBNOXQlT5DAvjWwTaypLARSEyk3URuJaG+qj4IuI11hOKKl?=
 =?us-ascii?Q?vpUlSx/VVTsDmBy9BmvjkbTfLOCVcrCctlycQpuuvPp/uKU10uIWydDwdYm/?=
 =?us-ascii?Q?LS0PBhukdndDZDCgbXpsvkJ3I5rS6pAZeGabzsV9yiJFo1mJU0NC/yvAOVue?=
 =?us-ascii?Q?Ry398f8J62SbuZP0pg789pLXpbCNWVPhitxWoTdZ3DBLUiTLqD01AtIoGt92?=
 =?us-ascii?Q?8W8KYgo3VT+gWbVqihs5IAv50P0OqbWtMOaM5R3jmNMwPneAErzJIG3Gs36v?=
 =?us-ascii?Q?y/v5maMShAvuoslI+TNb3cOpwls35UXu8gScJ9LV3g7qnoMzrh0AoYxS3ChB?=
 =?us-ascii?Q?Kle0iozjWcSpP0vD4+EZtR0/22a/Hz7k723s7XIDg/vwcofCTMHYbxIbXNgm?=
 =?us-ascii?Q?b9t27YY9Jgwoun1xHKsXcr24WoC4xKPniE7aEG5K2ASbE0jGqnImTXMPHyw6?=
 =?us-ascii?Q?stMPKOlF+tQLkaZ3v4f7GxE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCE18DCAAA151D4DAD97B5873C7D74B2@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62847a26-4621-456b-e0ce-08da5f097a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 04:39:13.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ROCyDf5sIRhG8eJu7gjPq8fNwkPfLNvK72lIUvn+4coNbrkoSdjj3tIoRcSYvyqh2rzw+W/hatn7MIJI7DC5gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1529
X-Proofpoint-ORIG-GUID: sXcj6vhDF247VsoBsllCKn8jwNIdUN9E
X-Proofpoint-GUID: sXcj6vhDF247VsoBsllCKn8jwNIdUN9E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 1, 2022, at 4:20 PM, Luis Chamberlain <mcgrof@kernel.org> wrote:
> 
> On Fri, Jun 24, 2022 at 02:57:08PM -0700, Song Liu wrote:
>> Introduce module_alloc_huge, which allocates huge page backed memory in
>> module memory space. The primary user of this memory is bpf_prog_pack
>> (multiple BPF programs sharing a huge page).
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
> 
> I see mm not Cc'd. I'd like review from them.

I will CC mm in the next version (or resend). Thanks for the reminder. 

> 
>> ---
>> arch/x86/kernel/module.c | 21 +++++++++++++++++++++
>> include/linux/moduleloader.h | 5 +++++
>> kernel/module/main.c | 8 ++++++++
>> 3 files changed, 34 insertions(+)
>> 
>> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
>> index b98ffcf4d250..63f6a16c70dc 100644
>> --- a/arch/x86/kernel/module.c
>> +++ b/arch/x86/kernel/module.c
>> @@ -86,6 +86,27 @@ void *module_alloc(unsigned long size)
>> 	return p;
>> }
>> 
>> +void *module_alloc_huge(unsigned long size)
>> +{
>> +	gfp_t gfp_mask = GFP_KERNEL;
>> +	void *p;
>> +
>> +	if (PAGE_ALIGN(size) > MODULES_LEN)
>> +		return NULL;
>> +
>> +	p = __vmalloc_node_range(size, MODULE_ALIGN,
>> +				 MODULES_VADDR + get_module_load_offset(),
>> +				 MODULES_END, gfp_mask, PAGE_KERNEL,
>> +				 VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
>> +				 NUMA_NO_NODE, __builtin_return_address(0));
>> +	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
>> +		vfree(p);
>> +		return NULL;
>> +	}
>> +
>> +	return p;
>> +}
> 
> 1) When things like kernel/bpf/core.c start using a module alloc it
> is time to consider genearlizing this.

I am not quite sure what the generalization would look like. IMHO, the
ideal case would have:
  a) A kernel_text_rw_allocator, similar to current module_alloc.
  b) A kernel_text_ro_allocator, similar to current bpf_prog_pack_alloc.
     This is built on top of kernel_text_rw_allocator. Different 
     allocations could share a page, thus it requires text_poke like 
     support from the arch. 
  c) If the arch supports text_poke, kprobes, ftrace trampolines, and
     bpf trampolines should use kernel_text_ro_allocator.
  d) Major archs should support CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC,
     and they should use kernel_text_ro_allocator for module text. 

Does this sound reasonable to you?

I tried to enable CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC for x86_64, 
but that doesn't really work. Do we have plan to make this combination
work?

> 
> 2) How we free is important, and each arch does something funky for
> this. This is not addressed here.

How should we address this? IIUC, x86_64 just calls vfree. 

> 
> And yes I welcome generalizing generic module_alloc() too as suggested
> before. The concern on my part is the sloppiness this enables.

One question I have is, does module_alloc (or kernel_text_*_allocator 
above) belong to module code, or mm code (maybe vmalloc)?

I am planning to let BPF trampoline use bpf_prog_pack on x86_64, which 
is another baby step of c) above. 

Thanks,
Song

