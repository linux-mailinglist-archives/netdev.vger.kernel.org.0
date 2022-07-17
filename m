Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40F257731C
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiGQCEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQCEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:04:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34AE19C1F;
        Sat, 16 Jul 2022 19:04:45 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H1mcKQ019536;
        Sat, 16 Jul 2022 19:04:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dfgDj7mfVrOR19ZKJBCbOzmUTgau+xpmUSKq+UyB1u8=;
 b=ZO+waV1UpK7vJh/p5E2G3+DrgqJ3mgHlHvoQEvxlSbBBtINVgIdiqE9nyHgGleAAWAym
 Z1oeT7qM+ftNE6IVKZ4Y9vM3iztj8eOjxTqqFhfNJMo/aedTmx5Aa2102mzT5U/wfGcs
 A6O/yOZlvsWVtPP+LOJ91h+S/q83Fa2lNvc= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbu2xja5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Jul 2022 19:04:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/3ikr735kDcNQuqmlXwM3LhDaGb05Flr/LSHDwIwx21HrJvER0rZXsulWJAojp7pmITeaFegHNZIbJh1bF917EPjIXsDfR0VxyfRYqEL/EQ8A/5aHuAlhabuk70E1s/HeyLXS6kdRJt0JRUvvn2pZmksJsJL0S/sqV8voa4/Yy1uLkOxMYCz1DUzhlKG8cfhFANHBMpU6C5pU9wAJ7MXBx8nU7O+winmXo/HApHaKc4IB0k7/2uYYxCtP4YqLQmZhP/JXK1IqNrbdkUUCWzBfXbAmAi8bMjhiUNrqjQETk0UuwoQKlwwEVsArDM0l8jxRg0JY+mhW3+uz302htVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfgDj7mfVrOR19ZKJBCbOzmUTgau+xpmUSKq+UyB1u8=;
 b=KTLalS+gPSW2DWrb65fXuKJwnu1VcS9FY8FmImJLRPDhWhPTV0LwyYEmjGe0Y0zfugIQQmBB+eH+2Bd0+ROavTLw1KGixzDax07Xa1VEwY6EyfwjB4uuknxLZdFcjbH55DAbzk6+sPEONI0P2FnJNxtmgYjentdVtqcWPh41ZtozApjn57IiCgLTTp/Qc5JdCJ9U7tAgaaQ5rB1BqdAE7rsVCKekPcHidxe5M2AJyn90xTOVciyw0BKh6Gjp0SXEKBHiBgcWCWq6h9muHr5wwxSvKmyM+IGuKRiP4YByKNdI3mFwq83eDpkyO2AfItFzhTw35XOfomIwob7mWezZDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1404.namprd15.prod.outlook.com (2603:10b6:3:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Sun, 17 Jul
 2022 02:04:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.021; Sun, 17 Jul 2022
 02:04:23 +0000
Message-ID: <5051267d-b163-a017-4c34-bcdd2d417a67@fb.com>
Date:   Sat, 16 Jul 2022 19:04:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next 3/5] selftests: bpf: Unify memory address casting
 operation style
Content-Language: en-US
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220716125108.1011206-1-pulehui@huawei.com>
 <20220716125108.1011206-4-pulehui@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220716125108.1011206-4-pulehui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:332::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1dac4eb-6dbe-4c31-ec70-08da6798ab0e
X-MS-TrafficTypeDiagnostic: DM5PR15MB1404:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGjKzAPcphnbvCMJLK1RA/1QTSBFOndmqZ3JtDSoWMzQeofVeyGX5AQH/KUU2HC/PBgJjB+sAZUHIN46LupIR9Z6zvC6ta8qhkyf8OSfgsECZm45gokKhowLe6o0tW8Xej4bjgqaT6fwY9jX8xOh/eukkw0DZBI+DGU2uIuTea2GlDN9yg//v2YNkjG1Hydhfm2yq/Wxi6l5BEFShk+fgf0wGWArj5wrbwvW4OswsQ65xgNSH5SZFFMxqQQkM1cJpLZZWwJB/CRogzCfRhqt9Tf3/USCJpHl/UBnf0ESS28/Ep1u8HsC787lHKm9mMm8GbKu7mcZq83OyuR8StGBSbWpeK2N8KXUOo9ziar9eUVgAgAF8Jcfvl2w5Q088GTJSHY6vvi2ZjHVtyX8F6hToZnuVYT6u5HoAhF5kHZGlaNnBkv64smGgGU5p0GYX/GDeWKdLO+yk4yd8quAOSKDvoUJkRjAtP0yEfl4vz83Ca7jQW2h0od49AtYslNiXYuwTnxd4h6SvDR+UN0P7PwnQFAowb4DKq1KqBYNXtN0y5vpSppQwtq56sFdJnaF3uaMkBX2erIZZ6pNNBRw+IeTzvgVoUIO0dE/QfMkwWcgVS2HLd8DCyPtYxEeRoaxasNBde08wLGdd1AyOJqIDTz4F/2o3wLkwZXmr1h0DEjDyz8TeGxZvaSWc7CckTGKtwBh3eo5cqtAQ55ddwaJCi7tr/y+5igDhXv+X0C4siqgqEHqtL53o3PHZgOViwjms54c2TzUvpJBaYuSrOA8tF5MqJupMf0vNag8M+HreQee//7dFNLWgeWwUPt9c58Ma1jhXDbyyu/gppH7VrFUXKavimVnEL28cWzbDf3TzgrGYR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(36756003)(5660300002)(8936002)(6486002)(186003)(7416002)(2616005)(2906002)(38100700002)(31686004)(41300700001)(4326008)(8676002)(6512007)(66946007)(66556008)(66476007)(53546011)(86362001)(316002)(478600001)(558084003)(54906003)(6506007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGsrdXdvVmhGZHNMMk8yakRvdXVmMDEzYURmVEVmZk1EWndxaW5saEpOREVB?=
 =?utf-8?B?SnVkSGVjM1FBN1hPQndYVTZZVEVkSXd0VHFjVXdXdDZFcDFQcG5USjk4bWxx?=
 =?utf-8?B?NFE5VnRkVmRFY0MrTzIwTDBvOXhDOWRFaUIvNnpMUzcvbC9CRHZ3K005TGZp?=
 =?utf-8?B?emZVSHN3a0JVR2ordkFITmtOY2VkUVpaNERqejIwc0NhUTJEQXdJekh2TnhU?=
 =?utf-8?B?YUhPVjZEZCswbXowZGN3UlR5VUVEWGJ0R051eTlkWXBVdGx4SlZzcXhWc29o?=
 =?utf-8?B?NnpjdHJYY1Yzc2JLY1l0MjhNMmVNOVNraTh1YWY4NFEwMEdBdlQveWZtdXdQ?=
 =?utf-8?B?V1ZkQlZmdlBnaFRlM2ZQcDFlcXFyZFY3enBXYVl4NTF2d00xclhQQTdLb1lG?=
 =?utf-8?B?eXM1ZXVLb3V6LzRYMUQ2b3ZSR3BuRGJndVdLOU9ja2tWR1N3UEpzZnAvbG50?=
 =?utf-8?B?dVhGK2gyaklKWU5qUmsvR0VBeHo0SjMrNUZzejZ0QUFqa2ZTYjBNOTlmVUVT?=
 =?utf-8?B?N1AxYisvYkdBTElKSWh5QlZlWGZ5QzdMZE9MYkJGZk52RkFzUE5zY1JhS3B6?=
 =?utf-8?B?Z3hRWS9KdHF5WWlPNFV2OFIzUXRKczFnT0daQXI2K3JGeEpkSUxrNUVPVDA0?=
 =?utf-8?B?bmlBNXlVWHl1MXc1Zy9iTE1Rb2xmYm5YdGhIQ21OVDVuRVJCdW8vZTNqYXlz?=
 =?utf-8?B?WktxTmNCMTExZHlVUzl4WjVDVDBiRWJ3bHVEbEQ0OTM1Wm5SVGRKZW4zL0s5?=
 =?utf-8?B?cE9aYXk1WDJpc3VNN0VQZkt3VzFoTjZwTXB0bDRhc2tLVVR3KytRSWN6RHp2?=
 =?utf-8?B?Z3lHWDgrMFVQZE1tYjlXMDBIY3RuanpmSVo3VUR0THpHd3JLeWdWaytKQ3BO?=
 =?utf-8?B?YjhiOTNEc3ZBeGRodHM2UW5hZFJqNk9lOGxyZ0tEeXlibDR1UHFraExTTW50?=
 =?utf-8?B?QytkemZmL3BDcXJXdWR5bnBaK2FncStwUGdzRVBWU3V5NkFJVk5LL25XNm9a?=
 =?utf-8?B?ajUvMEJERllYMjVTTytQVnpZdVpMbEJXdFozZWVGQ3gxRGp3TEI2aVRyck0x?=
 =?utf-8?B?SlhNSWl5NmhHeFNiR1JnMzNIMTBlUi9wYWNpOWU1QUFwZE5sRHh2TEk2anB1?=
 =?utf-8?B?cEc3Mkl5WHBmYllWU1dkSmFrRmJFWWg5K2dBdWdCekJNQW9oeUN0VXlaUjVT?=
 =?utf-8?B?NWs1MnhIV0dHUkFFL1lERFMxLzMyTU9vWXRka3RlclN1NGpRMzNNZHBpTWUz?=
 =?utf-8?B?amdoN25Sc0Zycll3cEoxbEs3dHFDenREZDZ1aHRqUXFzUEVvSk8yODVlOUlr?=
 =?utf-8?B?WTllZHNSOEFvbmVRT0NmOTNJU3BsaXprTHlNR2tsNFdFMzBQQ3BmQnRSZVk5?=
 =?utf-8?B?VUdLc2JycnJZSmJpRGdtb25vcjBURi81RVlUZzI2THBiNmM4MVIwTUNzWVJx?=
 =?utf-8?B?ZGlQbjZ2dis5bE9Eb0JYVzQxSkdiUTBmSWxsMkJzRDhPd2xZc3ZtcHZqcTRx?=
 =?utf-8?B?bzMwNzRLOElzMXB0WklFTmFpN0VUd3pzZEVBbm92UWZtNHZuakJyNlZyTkNv?=
 =?utf-8?B?WW55dC9ubkZCS0psTjZzY2M1N0dobzBxWFZ0U2ptYlpWY2tITGl2bldYVXNz?=
 =?utf-8?B?bWtsbTBuM21hQUo3dnZxS2w5Sk9TNXBWaUh6TUlZelZLUXRhdTlwWUxBMWZ2?=
 =?utf-8?B?V1hVMFJGWDVSN3BrbEQ3akVKd0taS1JOTmxuWVhhcmJaaEpiQzlETk5kdHdF?=
 =?utf-8?B?aTljYWhJeE5qa0w3SlB6bXQ0MFRtNHFlVVNKa0prTjZIR3NUQStmUE1rVUxw?=
 =?utf-8?B?ZHczMmZvc1pHMzdGZ2cyb2lJMFdqOGVKWDBTOVlrbVIzREJ1WE94UUpLZkdp?=
 =?utf-8?B?QzlYK3N2UFNEaDM5aCtRSjZxclRUdGxVU256dC9OVXFGVFZWQUJkcE43bHR4?=
 =?utf-8?B?YmRTTnJLSzkrWmZrV1NORnoxdnBQT3QwQjF2bndVMU1EYUt4TWtONG5Hem8w?=
 =?utf-8?B?c0FFelZxa09RK0I2dlBDSDFBTWk5ZEJ1aTh0UitHNE5OSC8rekxxQkludFlJ?=
 =?utf-8?B?TnorTGE3enBteU01VzgyczNhOGRXTTU3R0E4eTk0Z0YrQ08wbnJEZC9PcENJ?=
 =?utf-8?B?MldXS2d0NFVSWFVFMXdmMEVORDBHazQvU0tON2R2a0NLaVVNRThPZHZTV3ZR?=
 =?utf-8?B?S3c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dac4eb-6dbe-4c31-ec70-08da6798ab0e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 02:04:23.0168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx2jGiNieXA67qQb+OnzyYclCW8RC5xxcgvkn+1ANEMEH3d3Oe6RmtzSoPvpb+Vd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1404
X-Proofpoint-GUID: kvUWAhhhAkEeDn0ve9b7cUxLS5lr-V6b
X-Proofpoint-ORIG-GUID: kvUWAhhhAkEeDn0ve9b7cUxLS5lr-V6b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_21,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/22 5:51 AM, Pu Lehui wrote:
> Memory addresses are conceptually unsigned, (unsigned long) casting
> makes more sense, so let's make a change for conceptual uniformity
> and there is no functional change.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
