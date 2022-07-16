Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58862576C15
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 07:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiGPFpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 01:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiGPFpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 01:45:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AA15A44B;
        Fri, 15 Jul 2022 22:45:43 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26FKnD42019058;
        Fri, 15 Jul 2022 21:38:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GVCfmy6/ADWW0gKUennD3UfdoRud5qGMuQH78Nis0Wc=;
 b=Q/TN7PLlOawFSamcGMiA/WZAqism8FdgwqRTyL63ujel6k/DgLgqUaYicBdfH4OMn7UX
 DVJ/dPhibmAfozCbQSl1VuTq1c0teyQPHXwwbOaCuTL2WOYVmOmQH9WhSLpvrJokUA5r
 eyAfTL+5JjGs+Cho+vrzrz03pLwipoIIBQo= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hamy3ub37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 21:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FN0HbXpgArhjKzmv0pJCeBC3yWf1cuDW6h1VwemWycqVg+5KRBhjvVBgEN7RMFO+o5MzGZVoM6ugdYqb3WGfTNA62a/2Isn9dP9eNM1oz1YvuVdvX75fYB0d1Zk3fI31trEyh6S5TJD9PizUWoU1fsLMoFpCgN2jU1GrKRtxEU6PQ9oRc8ee8hOrSu22yf3aWaC8AMfDUJfLSnucX9fou38EoMPiwYTFCXLyYlJOfVn9ZTvoYsAir2KtSOVNXy4JRiQaqUvNeWCYqdgsLI9QGSdJ51VWuxANMWWYyyKOa6ER5XFX0FROMCjzxG9U2yEmsnJPHMxZ4eci7od7Kow9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVCfmy6/ADWW0gKUennD3UfdoRud5qGMuQH78Nis0Wc=;
 b=O+SkMhJ8ciRsC51Xx0/t97uDx1WR/gS8Oa9nt/z/Ym0XScy9nuEUb47OyhA/VY8/U7+/i1Y7FRF+4H27xmtEje7rwfYNZiC+va3jnla2SySuQL2P8lJ9BKZQ7Rua7dwDSbyMVv4wZY0WbWPZH0aGzJrzHmbYEaOd3RzT3H22sp1mpouUh3uUl1W6TX7ZCgnO2jBO2kECALmbeGNrto3V7vhbgSGMo/tiFCZOxsF6mMOe36YBj4hliboi4WjJknyilGieLUX8ycgmXN0SlfjtcuE33COKw/JCw7FFju5GYmBDbgK2ug12e0QyRY91BLQCihVK5r3AJpZY99WGMdBpoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1455.namprd15.prod.outlook.com (2603:10b6:300:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.18; Sat, 16 Jul
 2022 04:38:00 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 04:37:59 +0000
Message-ID: <fedd05d9-b243-6e25-e385-9d79839dbf9e@fb.com>
Date:   Fri, 15 Jul 2022 21:37:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 07/23] bpf: prepare for more bpf syscall to be
 used from kernel and user space.
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-8-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-8-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73e7ff60-2fd6-4545-d195-08da66e4f611
X-MS-TrafficTypeDiagnostic: MWHPR15MB1455:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kENrLGVDYAqfXRcSYyfEM1rD+H++mLHbTq6ZW7eCglm0f/vzBv8DxZhZ0TDdYGqUuWYRPMI/M00vI+Ork/0LMshL+TL1GGIYrx8abZnA4F01YEoBl+DTpTKpCiyGIY3oT6ZB1MIERuQCWUTXf1J7rcX90peN6/7zjZ85ocWCtXMI5xbapoQ2oX0ReEFIfK7LDH821FrtMVdQLObTZIvFyhHM4ENkERxunqr42/22+6opWuatODmziwDMlpcAhBlWjR4ErM51e8jAJFr7/goN69usp/bXlXknEpB2Xb2/fsMkhQPAE35JTWCKadMfS/LwuBevHDo/3Uktg/OAI4/HSTR/19z99qn63p7miskokKUgA/uRsnw2RHfW5Cw8qECqOXiU2e7cLUpwzICjKVCuDXn5O7y1NjPXAjIOrnDpLjVUkZ176YE+A/DRdk2kckLv6UrSIBCI1kqlbOqLbugSbckvFwhtzdq01xJ4IywyQmemWsEKKT0To5sIUB7fmJZp3VlrPtWf/cb8bElzMFxXKiYhRF9CkYtPIuUvbOk3DuA2xk0SmPw5oXNp28LW4lnVjwZhRSb7J+nu4W/ZUGksyhiSql5qFid9zknOrOnFxMFFXeLn/DsWZBSMYBMhGohhObrOntClg3zXyYtSMuPu5vWiL7a6IgcAykmkvZaFynLqZ5wLqCF5+3Pk0xhoqRnbQRKm8niZfPdpxx4kZnWs1hvKjN8j20NT+do60ra/prWO+6uiBLqpZm69I9Z2jTeL/s59XMmN1VSYDsF5dNQNIf27HvmEFt19QiH2nhvDRLfzZU3fb36BvaHnFsQc9EJhkiKPwI5CJj3j0UErBBe5ybbsiaZprX6dut/2GOolzCeShdhHnyXl+9UtkBxKHPwG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(53546011)(6506007)(41300700001)(6666004)(6486002)(83380400001)(478600001)(5660300002)(4744005)(6512007)(186003)(2616005)(2906002)(7416002)(316002)(110136005)(8936002)(66946007)(8676002)(4326008)(66476007)(66556008)(31696002)(38100700002)(921005)(36756003)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTVOTWJNWWtObGZ2RmxLM09ZdUpkY3NDS2todjltdFZrV0FxUFVESkY3azYy?=
 =?utf-8?B?bWlhNnptRVA2UVZyeVI5UlpPbUpHTWFaVEhtQ1JlRXdMQ2pER1Fxc095SWlM?=
 =?utf-8?B?aWdtaHk5UXYvYStOVlpOVmN0QnVYRmNJUlRJOExIekU5b1dCYTB4K01QcjFD?=
 =?utf-8?B?SWNpc2lpdm1kY3lJTWNNR2t5UWUyaVlxTU50ODFBOWxwVUg0M2Y1NExseTlH?=
 =?utf-8?B?WlNsMUo3SXh2SnFxY3F1REEvNzhqR0hnclJvSHRTV1hYZW5NNTYvbnc0ZTJU?=
 =?utf-8?B?VEV0UzNsNFk5WGYxbjJuYXF4cVdXNGMzSml2OXhQZG9zQTd3ZTRYVENPUnJu?=
 =?utf-8?B?MXE1TzJUU2dla0pFZ3ZiTFZKdk5JWWVVR0pwMGF1ZEF3K2hvQkpRSHVEcWdH?=
 =?utf-8?B?VksyWFZ3MXlMRGQraWJjNzh5eXRGL3Bxd1RJK1ZiRVVVcGlSZEtxYUhwNEtt?=
 =?utf-8?B?aUsybHRZQW9nQm9CL1lOalUrV3JRZFloaEI1aDZnSmJUdmpyM3lkTUo0aVUx?=
 =?utf-8?B?WlloakpPZEVkMnN3blNPbjJVTVlhL04xUmZrUkhsVm5xR3VtYXNBMnJiMWFR?=
 =?utf-8?B?dkQzL2JvRjF3RXE1M3dKVVIyMFMxejRVMFp6SGViWDJxU0QxbXdkSWpSR0pm?=
 =?utf-8?B?ZmdRdjFtYnVUdjF6RnZadFBCNVN2SVlXbUpxNkQwNktneC9DMUtCTFlNMTRB?=
 =?utf-8?B?QXZFUWpHRzJId0tNUGQzbVZJUjgwd1Evcy9YUHBPOWg0L1ZONHRuK3o4d3h2?=
 =?utf-8?B?alZUUEx4TmJCK25jNmZrd1VnYk51TytCcmRidTZFN1QwdlUzR01wZERFckNh?=
 =?utf-8?B?Z3FQOVg3ZEROeGJRbnhQbDdDMGNjbDcvcXcra3R4bkhBY0x3U29FeExESHZX?=
 =?utf-8?B?allHaUQ2emgvNnpUeWl5M3k3a3BiUHhNTTFBdDI0MlNPM3NWcW9nUXNOeVJq?=
 =?utf-8?B?Ui8zOUZlOUgwNFo1SkVzN2hpUEtqc3ZidlNibTN3NDRycGREVFlia2xkMGZh?=
 =?utf-8?B?WlZtWjJ0QU4yYnJuV09NTlpHNlBjWjhkSUkyV1pVZG54Q0tvOEVkeVVJUTUy?=
 =?utf-8?B?S2VaSFhhc2ZzemU4aTkyb2hUeVdONXNmWDdId3U2ZDM2NmIwcnU0TVp4dHVO?=
 =?utf-8?B?UmJEWkV6VDY5NTBkTDJlNHVHc2VXWVJLUG1BbnpscU1UTVJKeW1BTXl0K0ds?=
 =?utf-8?B?WVZqcmlBb1dxWi9CTDh1TGJQUVZKRHpWU3Iyd1RNa01KdTFMejNLWWZKVDZi?=
 =?utf-8?B?V2U5eGdjdmVjNlV4NmZNcjAvZjIvTmdLWDkvYW9uTlNqZ3h1aXIrd2dMYlg0?=
 =?utf-8?B?THEwdEN4RkVoZzZ0STZkK0ZuQXR0STdzRHNoZWxJaXBCRjBOVDcrMWpoYnc0?=
 =?utf-8?B?eFF0cGVXUW12clowNU9CeTJaSHVqcVNXaGZCcUdkRnVZUTRTaDBsR3NwbklF?=
 =?utf-8?B?OHBNemkxUmU1aVhhSm1Md2xZUnlNaWwwNDNmY2dPdUNSSHdjWXZ5LzR1dmdu?=
 =?utf-8?B?VUdlYldtYUNvcUdjdG9MY011VDV3Q3d0T0lPckhuNngvNSs3REtZbGhJeEtT?=
 =?utf-8?B?SXFIUXVWVjVqV1Fiek5ldE41a3RXWDVieXFEU1lSVWYwMHJzOEFnTXVzdDR4?=
 =?utf-8?B?QXZCV3VGMWc4YUtpVFZUT2FyL3ZQbWNaUjBvVXdJRzNKMm1WNTI1cFF4VVFZ?=
 =?utf-8?B?Q3ZEOVlsQUp1MGRiemFZRUhzVFJBQ0tGQW1DWkV0YW05Z0hXQUk1SHI4Q3Jw?=
 =?utf-8?B?ZEd4VVU4eGJiUlNFcllEZW1PN2lacUlnSHdTQi92WGQ0UmUvNVgrNUVKUGc1?=
 =?utf-8?B?R2JDRnZxUC9naWE3V3AzZmdIUkMyNUlhYVdURGJ1K25DMUxhMXZSanpyaDhR?=
 =?utf-8?B?dXV0Z2RtTStMV2M0QWZVU1VBMTZVMVZsSDgwU2x5WnlKdVNzRzQzRVNRcysr?=
 =?utf-8?B?TlN0bzVsazVvSHpldCtqRk5yUFMxSFZnM3hnd25xQ1pOODNxTExBL2IxZG8x?=
 =?utf-8?B?OGFZMFc3WXJwU0hpRHlETTFLMHF5Sy8vU1FVTHowL3UwbkNPYi9XajVObzdz?=
 =?utf-8?B?bkdhVXpzMk9YZFpKTUNPbUlLck14MkxnNmt1VDZHcFIzb2QwVFNWbmJzRDdu?=
 =?utf-8?B?TEg4NjlWZVNRb0VwUmJhdkd3eGFsVjBPZlptd09TUDR3YVhGWTRnYTFjL0JR?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e7ff60-2fd6-4545-d195-08da66e4f611
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 04:37:59.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4HH45kjV9bJD0RPuACdm3cKvDQUZHQjNdkb8/S/GdYZcW9rozi1uGGwAsP8T9hc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1455
X-Proofpoint-GUID: puPWJIjHCjrox3zZZHyTR74hEKE9KrY9
X-Proofpoint-ORIG-GUID: puPWJIjHCjrox3zZZHyTR74hEKE9KrY9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_03,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> Add BPF_MAP_GET_FD_BY_ID and BPF_MAP_DELETE_PROG.
> 
> Only BPF_MAP_GET_FD_BY_ID needs to be amended to be able
> to access the bpf pointer either from the userspace or the kernel.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
