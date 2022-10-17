Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCB1600662
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 07:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJQFjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 01:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiJQFjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 01:39:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC3DDF31;
        Sun, 16 Oct 2022 22:39:37 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29GAbpaV025873;
        Sun, 16 Oct 2022 22:39:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=yF/uBpQ34LbfmmVSldlgDZGhc4WHGMoqE7IddUFBPf4=;
 b=Oo+osPpqRpEHTogYpFvkJyRbbICL9Q1eNIOaHgA/uK5KTdC1UiY+UaU+prnmK5xxW3Xt
 eaHJOXlELW+k8WndE5MCyebKQFNnXT+esMboDASBcPESwMA5kdJpiF8NH6DgCh0tQsRU
 hF2JPYbeWGTiOTePRlTMJdcmp7wMB8oByC1qApJuEjb2d4rmI3weGioUE9ft5Z2FNNSY
 ppv8ljiyqa0T/bDajNCEl5tRi3gu5xau8D8d4TyCtkyFJACOCF1M7OavtTwkHgd7bmjq
 tJB5TlUdlSoE3GU6Rar6676U+BmsNDwI9so3n9y1NdcxNHs9C8fZbbrQDSamAhxlUCSt tA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by m0089730.ppops.net (PPS) with ESMTPS id 3k7rc8n8qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Oct 2022 22:39:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxvAP0zKnXEYBlvmxkCW/Z9al0fkWBVewm0y0cPeI6/3yrr1ziW5wPVW1RWsY59veNeR6B+jxfBAfdLbYDYdDyvja0IHvemWAULyIhnx8zV4zsiKOTBylkmmHX2TVLRt32Ycb91XMxfiAezVA6hyVquQyRzGaqbsJTsp6gDhdk5YY/sXSWq1q7YCCbZamDTwiooVTGOuTrqwQTEspw7PgLecli8crz5n1GRW0hkXOJXXQfgsSOys20Jd1+xnjIOAsbqmMOKIS4H4X4eBYsn2Xa+JXXCNgQ284LzdoCzDe/8Mq0umDr8VLAS8AW8KEVwaCTwTGmTATLPGvwTzoGPGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtNw7y0Q4b2cNwc31XgARfOkSEQ2pODfRmJSAGGe+DA=;
 b=NPnrhSnEvaQE4oG8Ly+cPxrs8tmP3HHvNSyN46l/w36LHgFyYUvVRZHx5HOcdfaPJL7/kr6pTeNhSCjn26AszWxndElJ00DLJyXsBUmtftG8IQqINOsDv/Xeo2wqJLre8nkBFVjE+gUYO94c6VDztHx7uOlekiAeF6oD9DiSSz3K42O+/aE4LdpWXEbWVXyFJrbz+IfeYb/x8R5t/6Iu2wAhU/y6MInkxh0GLRT9mgaYT2Jz0U2nBqUbClUkTBmgdsLt22ReDOc+pqesDiVUkXIAP8yN97lG8YKHPXWjcGA4K6uxLtHLVE/kdKsbQ2xfkQ+TCsNfnN6RVOK9e8XBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY5PR15MB4274.namprd15.prod.outlook.com (2603:10b6:a03:1b4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 17 Oct
 2022 05:39:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::6e08:a405:4130:f36e]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::6e08:a405:4130:f36e%6]) with mapi id 15.20.5723.032; Mon, 17 Oct 2022
 05:39:03 +0000
Message-ID: <6e661da6-23df-bab0-da84-e55205412ca7@meta.com>
Date:   Sun, 16 Oct 2022 22:38:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [syzbot] general protection fault in security_inode_getattr
Content-Language: en-US
To:     syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, hdanton@sina.com,
        jmorris@namei.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        netdev@vger.kernel.org, omosnace@redhat.com, paul@paul-moore.com,
        serge@hallyn.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        yhs@fb.com
References: <000000000000618a8205eb160404@google.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <000000000000618a8205eb160404@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BL0PR0102CA0068.prod.exchangelabs.com
 (2603:10b6:208:25::45) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BY5PR15MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: e26c1c4c-bd9f-4910-ada0-08dab001e621
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7821YAa8K0+1tzXK4ZRFaYFXujPoBP0uH4l92AdU6SZWDH9OWw4bn9xL2M/yQ3S4PuQvJPSi7ow22bO6gyM1LT/pTHyWVXItQ+8M4KZCCvJBEaijvg5Uhg/8s1Uijyccqwq5BfLIlvi5t7IMVSjZVMDN8uq2DTaNu/uP4nxcjkrnfd7E8Scb3sx5HEN4awJhzYuLs/Y/1mjafjxup0YZ6GY1GPFizbRRTX1M6wWen41RUfLyDNqjfHhgdyMgzCYV/ljH6dNMWer5Ln1Leloj2wftlxpZZqC/94Lk4ZFHpQdiFLlZ7XIY+dwcye9xOkHPAWUWCELF/32Zs9W0XdTjFTjUsyhvaoGOfFDuD6HKE/d1Rrl3rqf8uVzB6dInc56/DJLgmNDZryG10DO/DBnqP4HvKEuur9qynN3SDviQ5jsFOzvRbFrgccwDMbNSau0NpSr3VZC6LRLZCXR9mufuzq9BZf3Ev9/LA3eTi2XhwN9mJGWt9V0AKlFXYTe5Dir73Etjb/YuOdh8FB3UOA4/xPKFPacqNY2fD+iLbBZbqPc6TNnP3uDFG0C2wY/tHPPfNQYCC/qepBY6fkBAbDZjRrwuyg2dblWcF/TdUWm8QlUjBQX8JqW9tPZLRJ8E3FMfaUObQq5qBooeeaMrijuOu0NmISKf35jTVW18PZi0FgqQvYwbWx6H/FYT0vaEb0JUB9IdZg4+I5WvGoIF93IN9lHwyd89WmTB5t5CtSwiFB7pPOB6zafUZNqe4+uUGgewmIstJFPC7EwoSyx7AkITUKma+po9uZtogoGQumpilUEGG6dMUDpeFuaKyBEWvEZFk7axel/wUA8heIGC1RmdyLYEfKEBGd4HorDLET7f9PZNFWT5v8fP2/jSrybicG/G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(5660300002)(7416002)(966005)(8676002)(66946007)(8936002)(66476007)(38100700002)(2906002)(31696002)(41300700001)(36756003)(921005)(6512007)(15650500001)(66556008)(53546011)(6666004)(6486002)(86362001)(316002)(2616005)(186003)(6506007)(478600001)(83380400001)(45080400002)(31686004)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNVblVET1VhWk1pdmZ3Z3FiM0w0V1ZqWGJhOW5jSDZFbVhEenlQcElhSzVL?=
 =?utf-8?B?alNQNEtrd0NUSXo4NFdWZFRhVE5vREtXc25UWFMxdEVPd1g5NXRlWFVJaTR3?=
 =?utf-8?B?ZEx3d3BpdWxocjJ2MGNqSk8zQXBaWmQ0Wi9xaE1ONDNrR2Zqd054SXcra2NC?=
 =?utf-8?B?YnBhTERYUTVIT1VvQk9USzdqZWxUK2oyR3NRNVdad1V0VTY5dmJpU2JLcXgz?=
 =?utf-8?B?T1V6QUJHTG82Nk95SlgzSHdLajVHckZIV3dLTElDbEl3bXh5QUFxZkZZVGkz?=
 =?utf-8?B?UkFWYXZUdzRVZGRmYnVXVVVNUFZzZC9BUFhWR3pkUUUrSTFkcmdjbWEyMXox?=
 =?utf-8?B?MGFzbHFzaFRJU2tuLzl5RnF6RnhVVU02MnpSK281WmNaQnpXSERFQmliVHFj?=
 =?utf-8?B?eU5ONzlDWXhCU3h2eVhrZGtoMHE4QVVJSm5SYTJVZnlBZlVGb0NmZ1d4ZHJj?=
 =?utf-8?B?NFVkNlBHUlpPWkNxWGVrc2UyVFJWOGdHdlpQNmxVYVUyREZMK09za3RUb2NG?=
 =?utf-8?B?dHNzR3hZanJWK3R6RFlhdEtKV0tMQ2xXdGQ1aFhDVlU3cTY1ZXZaQ05kM3lZ?=
 =?utf-8?B?THJWbk9qd1pIOVZCcXpTODZSSmVVS0xKY251YVBxa1hjY3pIVGVDMmR4U0t5?=
 =?utf-8?B?NDh0K1JtS0NrNlltY3Z3R3R4Q1dReGxlSXRvSm1BZytnRm9pTTFteXpBRGRX?=
 =?utf-8?B?cURxa0lleFdJbk5FRGdjMUY0KzNRRHpsT1ZvMnVDWEYrNW90eXpueE9PN2c4?=
 =?utf-8?B?VHhZNTBUdnFsUC90YzVoaUdpS0JmTzJBamFCeVcrYm0rZFFZM0IzbWZBajNp?=
 =?utf-8?B?R2FiRGtJZnlwaW1TOENHQnA4dXlkemdldTlsZENrYXV3VTJ2d1dkcVlObWVy?=
 =?utf-8?B?QWxEUElVdzlwaHBIV2JRRUlHem8wVDc0Tm5rL2NJQ2RrYUR4OXlvYnpiM1cw?=
 =?utf-8?B?MGdYUlREODVWNnV2aWxYeUIzVExKRU53elJhYnE3VWszaXQ2R2c3Z3hsRHQx?=
 =?utf-8?B?QllCd2NGVUNzUkR3cm1QUlJ3bjVLelFhWThQK0J5YWZuRnRWY3J0T2xUS0Jr?=
 =?utf-8?B?Nmk5dmNyZDYyTEJ3TiswV1k2QlFGdm5EQ2N3NmhVRXF1VEpPSnp0UXNPNDRH?=
 =?utf-8?B?SWhLK3h4M1dyTUlqSzdhYzdDWFV6LzJRYVQxSXFSSDJZU2ZaRVVZdDFvUGFi?=
 =?utf-8?B?WkpDRmw5RDVlcUIvZVRoTitXMUs4cG1Id1VibWxQZkhTLzlJdndFdFhNRHQ3?=
 =?utf-8?B?eTFlV0JpL3dZZy9EQVdBRkFnWDQ1WE9TRDFFeDg5TXFOczdJeWxGaDMyMDVz?=
 =?utf-8?B?M0V3TUZGUm15YTl0cWMyZS9xYml5RmVHUzJROVR1Y1NvOUtjMGp6a3ViWW9U?=
 =?utf-8?B?Uzl4d3RoSmtRaWJ0M3A3bGtDRXFxdzZSQ3lwb1cwZXoxYTdoRGpaMHRPbnNE?=
 =?utf-8?B?Y2ppeUFydUdMZHhxaWR0QmxpODZJWlpEN21OMmcrUWJMODBzMWgzR2pWR2RH?=
 =?utf-8?B?NjRWUWk4MXBmNzNVK3Ira2RPdHZyd05GbzFsTk5QbU1xcXNvN2pYOFNjUkZJ?=
 =?utf-8?B?UFB1VXYzcVNkdHY5K0xEWnltWWRhYkpydzlCcjZXZ0VJOFo1YzZLZW9oMU52?=
 =?utf-8?B?WCs4ZHBZN2ZrVzcwa3Y4S2g0Nkt0TkpGeU1WYk8wTlhEeVlHeDd4UHV0eWY1?=
 =?utf-8?B?M3V0eFh2VS85UzFHN2w4REFBOGh2b2g2dTd2VEZqK05XRHU2b2UvYnVKTDJ0?=
 =?utf-8?B?T2hSSnkvelBaK1pTY2NUVllJUXJIRFRTdFdIcld0czZrVWhDU1dxdkEwUHho?=
 =?utf-8?B?MG5iQ3UwdkNZSGh1ZUpnSFdQMlNXNUtMYURSQlduUzVwTGE4c1FHanprQzly?=
 =?utf-8?B?TUpDUmNMblgzNjlDa1p5aVcrcGNGdXFjVmtkWWZwUjNOemF3cGZrVmFnc2NV?=
 =?utf-8?B?Q3hrSlVSZ2REQWV3TDY3S1BkcG9OeWtVOHN1bjVNZ3NPcHVzN1k3WWJCTmxp?=
 =?utf-8?B?UFgzWGw3ZFhzVEpFenVybTRsdVgrQUFiOC92QkVQUm5hTHJkNmQ3WTk1SCtq?=
 =?utf-8?B?TzBwZjA3VFNiZGVCdDIwb1VnTXlqUG95eVFOeCtMbXRsRFlXd0Q2M3lUaTdN?=
 =?utf-8?B?emtaeFRzT09SbnZmZlFwL1g4eVRXaGE3QlZIVEU2ZjJGSHZFbENOb3kvYXhu?=
 =?utf-8?B?c2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26c1c4c-bd9f-4910-ada0-08dab001e621
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 05:39:03.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9RFa29fXcbA5pqipclJjBmul9mrLMHhGViatxkd6cQaybpdhMQkAHoT+h1oV2Jo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4274
X-Proofpoint-ORIG-GUID: FNRvu715JBSSAo6WhuebVcTUH5Jzix1k
X-Proofpoint-GUID: FNRvu715JBSSAo6WhuebVcTUH5Jzix1k
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 11 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_03,2022-10-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/22 10:24 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=147637c6880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
> dashboard link: https://syzkaller.appspot.com/bug?extid=f07cc9be8d1d226947ed
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1585a0c2880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1480a464880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6c791937c012/disk-55be6084.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cb21a2879b4c/vmlinux-55be6084.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/2d56267ed26f/mount_1.gz
> 
> The issue was bisected to:
> 
> commit 35697c12d7ffd31a56d3c9604066a166b75d0169
> Author: Yonghong Song <yhs@fb.com>
> Date:   Thu Jan 16 17:40:04 2020 +0000
> 
>      selftests/bpf: Fix test_progs send_signal flakiness with nmi mode

It cannot be this patch as it tried to modify a bpf selftest and it
should not impact the kernel.

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13032139900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10832139900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17032139900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com
> Fixes: 35697c12d7ff ("selftests/bpf: Fix test_progs send_signal flakiness with nmi mode")
> 
> general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
> CPU: 0 PID: 3761 Comm: syz-executor352 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> RIP: 0010:d_backing_inode include/linux/dcache.h:542 [inline]
> RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1345
> Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 68 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
> RSP: 0018:ffffc9000400f578 EFLAGS: 00010212
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffffffff83bd72fe RDI: 0000000000000068
> RBP: ffffc9000400f750 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 000000000008c07d R12: ffff8880763dca48
> R13: ffffc9000400f750 R14: 00000000000007ff R15: 0000000000000000
> FS:  00007f246f27e700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f246f27e718 CR3: 00000000717a9000 CR4: 0000000000350ef0
> Call Trace:
>   <TASK>
>   vfs_getattr+0x22/0x60 fs/stat.c:158
>   ovl_copy_up_one+0x12c/0x2870 fs/overlayfs/copy_up.c:965
>   ovl_copy_up_flags+0x150/0x1d0 fs/overlayfs/copy_up.c:1047
>   ovl_maybe_copy_up+0x140/0x190 fs/overlayfs/copy_up.c:1079
>   ovl_open+0xf1/0x2d0 fs/overlayfs/file.c:152
>   do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>   do_open fs/namei.c:3557 [inline]
>   path_openat+0x1c92/0x28f0 fs/namei.c:3691
>   do_filp_open+0x1b6/0x400 fs/namei.c:3718
>   do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>   do_sys_open fs/open.c:1326 [inline]
>   __do_sys_open fs/open.c:1334 [inline]
>   __se_sys_open fs/open.c:1330 [inline]
>   __x64_sys_open+0x119/0x1c0 fs/open.c:1330
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f246f2f2b49
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f246f27e2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007f246f3774b0 RCX: 00007f246f2f2b49
> RDX: 0000000000000000 RSI: 0000000000000300 RDI: 0000000020000140
> RBP: 00007f246f3442ac R08: 00007f246f27e700 R09: 0000000000000000
> R10: 00007f246f27e700 R11: 0000000000000246 R12: 0031656c69662f2e
> R13: 79706f636174656d R14: 0079616c7265766f R15: 00007f246f3774b8
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:d_backing_inode include/linux/dcache.h:542 [inline]
> RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1345
> Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 68 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
> RSP: 0018:ffffc9000400f578 EFLAGS: 00010212
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffffffff83bd72fe RDI: 0000000000000068
> RBP: ffffc9000400f750 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 000000000008c07d R12: ffff8880763dca48
> R13: ffffc9000400f750 R14: 00000000000007ff R15: 0000000000000000
> FS:  00007f246f27e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005643c9471000 CR3: 00000000717a9000 CR4: 0000000000350ee0
> ----------------
> Code disassembly (best guess):
>     0:	48 89 fa             	mov    %rdi,%rdx
>     3:	48 c1 ea 03          	shr    $0x3,%rdx
>     7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
>     b:	0f 85 04 01 00 00    	jne    0x115
>    11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>    18:	fc ff df
>    1b:	49 8b 5d 08          	mov    0x8(%r13),%rbx
>    1f:	48 8d 7b 68          	lea    0x68(%rbx),%rdi
>    23:	48 89 fa             	mov    %rdi,%rdx
>    26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>    2e:	0f 85 d7 00 00 00    	jne    0x10b
>    34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>    3b:	fc ff df
>    3e:	48                   	rex.W
>    3f:	8b                   	.byte 0x8b
> 
