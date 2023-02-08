Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABE368ED88
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBHLJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjBHLJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:09:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FF6241C4;
        Wed,  8 Feb 2023 03:09:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXOtKJdzSM8v52FDNaMAmm/fbVnKT+0vOoyj4NxTAyZLxkv11iKIe0NNnhi9GxwHsEyo+QpJNkOwrSuBDk2jx5DCyu9YRKyGZU/0PsIlmCf6UYmKfceQRjUZTcQqBt/+s2KQ/RDlZxov1uLMIVn4mjXyq4E58NaxzmJL6WJojpC5RjnUYSIl/6gCb5uxsLA6iQx/U1+gYIwqgTpqpHpFbwh1ulyf1GzCU7OHtm2hh7mbI2rYNPev3LkLHSO8LICg9/N4cnDOY0Q57hJ6HgtsPhnmUQVI0M/C72WcaYjktHN2MgSeb6hyX1ly377KGA5ftepPqfLe5w2L72WlPauMdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXKBL3+tZEBSBx46MOMSM3nVDa1JNx//RTW9qYE1agw=;
 b=YA6ooFFWd6Yabuc2QxwD5kuANgn2X92ylZQjRj/MjFgmPHKzCCQlv85chwKUwFXR5m9bMIEOjuzb9oqP2NbL5Y28Zzyx4DFdcP2694eQHfwMwd04rIX0Sv/9n5s2+RNghyV7lw6yrrKRGiEhQBBnLNKmWQ5q9PxDKtn4cJSl0TdckXGajdTi4+/vEVUomWRbslPrZG1EfbcDyrh3bUj01/bRUC5bWmv6erfkt2Bz4UeQjosAmA/SWQL26tfvLbj93jPlAUcvAAygcnfCjyViaNOnBlLM1GXoGgRpLsS9bcimdXtc3E/0rKT2NZ9yIggrNL0FdtXjcNuymxdYoIPhmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXKBL3+tZEBSBx46MOMSM3nVDa1JNx//RTW9qYE1agw=;
 b=dOP/McAG2lm/eQ6z43JUWm56r4OO7JkGAoO8QiqpQQFF0+gxEBsz867oMvjsW5MuEg/3CrZKdMJZvku3Ygrf8cZEU/HTUnthPgNgvzOh+d30PdFjurZzC67jVnHHM4OaZhqcR3t24t6V7+FzEIx33GP05CQt8e5K61RSDud8lFoMwMeveriyZv0JkDo78nZmoY2t2itFWNKnlTIwIrL3C2g3TNfpBRunbF61zoU0BWFXW3vhOpTeOyMu0o6mSmigcxGqp4AJMzF4vJeiYN6VncFnrOK0PgLiz04mOLwIG1LzYUOh/RAWv0lbKPe9fDHfUj7bzIBorenyRdrWGVwCig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB2485.namprd12.prod.outlook.com (2603:10b6:4:bb::29) by
 BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 11:09:05 +0000
Received: from DM5PR12MB2485.namprd12.prod.outlook.com
 ([fe80::bf24:f5ca:72d9:cb50]) by DM5PR12MB2485.namprd12.prod.outlook.com
 ([fe80::bf24:f5ca:72d9:cb50%5]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:09:05 +0000
Message-ID: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
Date:   Wed, 8 Feb 2023 13:08:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Tariq Toukan <tariqt@nvidia.com>
Subject: Bug report: UDP ~20% degradation
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>, Malek Imam <mimam@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0115.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::12) To DM5PR12MB2485.namprd12.prod.outlook.com
 (2603:10b6:4:bb::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB2485:EE_|BL1PR12MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c87bd7-473e-47d0-fe85-08db09c4e40f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfSlxVocY/2fBs9+qv/CueUk0urinswXyLl0GtLPnGAyM+3RrnNrOyBG2D6hs5nMLhxgTXJYUfTkRavWgxR3WZRgmP8vRwy047uKVHGJVbZpsKDQ1kyK11VdLlzSBI1r//EXZBiakRwPwMwGP2c0WqqiGCXGIbOJvKvJBsdeFhXokPWEIYwo1ERhz7GFjz5kFCpYIl/GSw/tzsKj6UqCk5Xr45g7W72p8aY2yg4CISzDm388+Q8Ii1tQZZTfxiTPLiV3HhoUPFnxVmYL4r8T1aMxD3UVtKdGMx0TiPp1SfYowwv4f5qyi6RGE52lLlxfQsbPfvMa4VRscxF+3WujITeSA+u3Rs0kQKddf7avzc5WLmEOqa8fzn8P/0wlgN4sblQ8q42SsDEptjj3r2mGUdXDOudq84uUTJ9MB4HFJvRKQzeS4uFn2gGSKy4Y+tupxfNXuLZlEyV7njlethUmQAkV40U0jsgqbyrb4EZy8jZIoFpPnZA6bUXIkhZqa7Ij9YSU6eHDW+ljvmV3jwf6G+lcinqksekROqoRko/2LAZ5UUJgGt9eAb0BXaH5fIinlBo82i/jO1n2drVip8CnRXPdQiWuoHPvfWgtAVr2jn9I3X9smBJPzUG+AEfBrX8V7xXfswT/qChMSVv+aZxoJATNX2nUH1XCKoRIDu3rNffop6Mkbm6UB1xI7QWSdvbVsWvmHGWq62xv+XibEXl8nAdegFriUStC/Q6emQI1iB/xkWxl2EOjOzyGGC1VnbduTdXVQyvhCtkbiEtvIIPKBNlM1GGQVtMUR0Xt7WtAkj1ZtCIgeWfKWRdpBOinZL1F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(6666004)(8936002)(478600001)(36756003)(966005)(6486002)(31696002)(4326008)(8676002)(66476007)(66556008)(66946007)(86362001)(110136005)(54906003)(316002)(41300700001)(7416002)(38100700002)(5660300002)(2906002)(2616005)(31686004)(6512007)(186003)(26005)(6506007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmNuZ2cyMGE3NTdOVHBrT1VpdmE2dC9EY01iYkZRMkNUNmdnK0s2Wnd6UGhX?=
 =?utf-8?B?emhnWmRRcXFDYXlMYWhCQ3VjWkVCMjZrMEVNeGl6bWVsQkR5eHZ0THBsRm9a?=
 =?utf-8?B?Y2RmUStVVGQ1R1VTRnVJWVpGbytqeWZUNDYzbi9MS0RXbnlHQTRwV2pkZnN0?=
 =?utf-8?B?cTZLSXVwRWduTkF5S1VvUzFqeTNSRkpaUUdWcjF6bHdNL0NMZUJreGhsb2Vw?=
 =?utf-8?B?NEVCckpaalUvby82Z2I5eDRRM3RyMkJaR2pZbUg1MFFvZjZuTHVsaEI3Titz?=
 =?utf-8?B?THlzd1V5a0F5b2JxWnRlSDRJMW9YckxaREJGcXp0TWxLd3ptSVY2d3V3bEU1?=
 =?utf-8?B?U0lYc0lUUGpSYVN0TG0yY0l2dFdFNk5DUE5iL1NacnVZWXVmbjVMREZaY3U3?=
 =?utf-8?B?YXFzOTdkRU9OTkZZRFJKbFlYcVBkMXdkeGx3R3g1cDRzaTZFT0MzaGsxcTV6?=
 =?utf-8?B?NUdxU3BaakE2TERzNVFDTzQvbjA1MXpkN0pxeVlaN0pEb3JRVGRNKy9lNTBp?=
 =?utf-8?B?bEFKUUc0U0dtcTlueFRFbU5pUDlVYnh2L0xtanJiNWozNXBNSmpuRnVnMUNz?=
 =?utf-8?B?TEhPdVdTWFB1NDlsNjVqaDl3QmMweHprclNwNFI3bWZ3bVYxc1grVWZOV0h2?=
 =?utf-8?B?UWgvbHozc3dTWUUvUjk1VFU3T21rcmlFanlROTUzc1ZPL0xUSjd5SnEvZkJE?=
 =?utf-8?B?amZoQ3VQbU14Mk9TdjdQeFo1VmhONHBOMkVoLzRzSlZSeG90SE5DUENuT0Zj?=
 =?utf-8?B?QzlWem11V2xoU1pKb1p0a2FPVFpvU0ZmQ2hQMDh3MHVnT0R3RHNpbGliU0h0?=
 =?utf-8?B?cEpZOVpzNm9NSnUvZXc4Z3pOaHloT3RNaWNUcVYrM2E4L2J3a01BOVc2cE9z?=
 =?utf-8?B?MC9JcW1wS3V0WGQ0MHZWcFRZZVQ4NVhvWEUzemlrUHBPUUU4c1VNQ0RHRUQr?=
 =?utf-8?B?S1ZLanEvOEpmdzQ5aWR1R1h1U0dzeUlDU2J1UWtsd0hOWEgwQnRpNDY0Zkt2?=
 =?utf-8?B?bDVYdFhOWnpadWlnNHY0Y2RoVHNxRlhDNWhEaVJMWHAxYmluR2xnbWRlQ2Jl?=
 =?utf-8?B?aXd1Qk4wWEVNc3VXUkZ5V3lvOEU0dTRhTm5HTzZ1OXQyZnF3TGJsamdzQWRE?=
 =?utf-8?B?TUh4dmtBNGRwY3duMDV2eHBjSUVxeVlKakc2ay9wTzlKREIzQ2hWVTVURTha?=
 =?utf-8?B?SGltTUFHTmkzdGVaa01kSm4wOXRsN1I0UVgxc0tnRHNuTk9SV1Q3MlhTY3lm?=
 =?utf-8?B?MDBmL1FjS2ZodUpzS3Z3ZFZjMFgyK0JmTksyWDY3ek1OQTZtZm9vMXJOV3Mr?=
 =?utf-8?B?am11aFQxODFxeXRIRzlKRXdmMHIvZkJYVVkySEwwSStmN29IaS95UmNaRW9M?=
 =?utf-8?B?c0hUeHM0a3o3VUZ2WkJ0TlJDWkpzZUI1aGhJc0pFbjNmSWc2TlAvdUpaSmVQ?=
 =?utf-8?B?VUxleEpwRXA1dFVHZTdNM1ZscDV2Y05na1NsYk4yaDFOMWVnMmxNcmJjMklp?=
 =?utf-8?B?VlJxYUxSOWZzVE5SdjRZRk56eHlmYUxSL25OVnZ3c2Q3S3J3K0lOd1dxZ29j?=
 =?utf-8?B?OUd4SmE0WG91MFVuSGlXanl1dWpZTTNlU1dYL243eEppOHJxTGx0K082aWIv?=
 =?utf-8?B?NjlkWEZGT0tVdFAvblhyN3RqeFRrVTQrakU4blViRnFqZE9VV1pveGV2ekpN?=
 =?utf-8?B?ZjhzOU1qNVpWaXg4Zm0xNGpLWjZWYmp1SGJtdVptakJueVZQYnZIa1djeUZi?=
 =?utf-8?B?NmNyOVdjS3krVWVwNHlxNG5YSC9XNXVhSUtEeTRrZC9JQzNDSVNhTnI2UDIw?=
 =?utf-8?B?RWhxa3JHeHpuY0xRRTI4QjUzNlBwc2hhZDkzZlNkTlFpeS9SQUNvU2o0VjdE?=
 =?utf-8?B?RGZkaXFmc3ViendTMGZSeEdVaFNvNXlPWUhTMllMdEYxZDVwYkVhanZjeEEv?=
 =?utf-8?B?UGY2MERyVzI1NExHREZ1aTMvVzZpRmVPU1ROWUdKQXo4ekNzVzJqVExHb00x?=
 =?utf-8?B?N3ErVzBIVkZtNVE0MzU0b1FadG16dkQ0cVU0YWMyN1hpaTc1UHRYN01aNzRr?=
 =?utf-8?B?RGE1STdwNm4wR3hkcW8vWVkrYXFNSmp6VGZhYXMyK0pST1Qyc2g0ajVVWFBO?=
 =?utf-8?Q?K4UtkY6JPgPt6SY5P4WBTiaHr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c87bd7-473e-47d0-fe85-08db09c4e40f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:09:05.0831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtbVN6yK5cVk9UgCDaBYueyEQfxrJW0ShMlvG9lDDSRF/UqkjtSG52rAWjvH1JzlFrHH5AdBOQJmwVAClKPGdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Our performance verification team spotted a degradation of up to ~20% in 
UDP performance, for a specific combination of parameters.

Our matrix covers several parameters values, like:
IP version: 4/6
MTU: 1500/9000
Msg size: 64/1452/8952 (only when applicable while avoiding ip 
fragmentation).
Num of streams: 1/8/16/24.
Num of directions: unidir/bidir.

Surprisingly, the issue exists only with this specific combination:
8 streams,
MTU 9000,
Msg size 8952,
both ipv4/6,
bidir.
(in unidir it repros only with ipv4)

The reproduction is consistent on all the different setups we tested with.

Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1 
(Bad), with ConnectX-6DX NIC.

c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].

We couldn't come up with a good explanation how this patch causes this 
issue. We also looked for related changes in the networking/UDP stack, 
but nothing looked suspicious.

Maybe someone here can help with this.
We can provide more details or do further tests/experiments to progress 
with the debug.

Thanks,
Tariq

[1]
commit c82a69629c53eda5233f13fc11c3c01585ef48a2
Author: Vincent Guittot <vincent.guittot@linaro.org>
Date:   Fri Jul 8 17:44:01 2022 +0200

     sched/fair: fix case with reduced capacity CPU

     The capacity of the CPU available for CFS tasks can be reduced 
because of
     other activities running on the latter. In such case, it's worth 
trying to
     move CFS tasks on a CPU with more available capacity.
 
 
 

     The rework of the load balance has filtered the case when the CPU 
is 
 

     classified to be fully busy but its capacity is reduced. 
 
 

 
 
 

     Check if CPU's capacity is reduced while gathering load balance 
statistic 
 

     and classify it group_misfit_task instead of group_fully_busy so we 
can 
 

     try to move the load on another CPU. 
 
 

 
 
 

     Reported-by: David Chen <david.chen@nutanix.com> 
 
 

     Reported-by: Zhang Qiao <zhangqiao22@huawei.com> 
 
 

     Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org> 
 
 

     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org> 
 
 

     Tested-by: David Chen <david.chen@nutanix.com> 
 
 

     Tested-by: Zhang Qiao <zhangqiao22@huawei.com> 
 
 

     Link: 
https://lkml.kernel.org/r/20220708154401.21411-1-vincent.guittot@linaro.org 
 
 


[2]

Detailed bisec steps:

+--------------+--------+-----------+-----------+
| Commit       | Status | BW (Gbps) | BW (Gbps) |
|              |        | run1      | run2      |
+--------------+--------+-----------+-----------+
| 526942b8134c | Bad    | ---       | ---       |
+--------------+--------+-----------+-----------+
| 2e7a95156d64 | Bad    | ---       | ---       |
+--------------+--------+-----------+-----------+
| 26c350fe7ae0 | Good   | 279.8     | 281.9     |
+--------------+--------+-----------+-----------+
| 9de1f9c8ca51 | Bad    | 257.243   | ---       |
+--------------+--------+-----------+-----------+
| 892f7237b3ff | Good   | 285       | 300.7     |
+--------------+--------+-----------+-----------+
| 0dd1cabe8a4a | Good   | 305.599   | 290.3     |
+--------------+--------+-----------+-----------+
| dfea84827f7e | Bad    | 250.2     | 258.899   |
+--------------+--------+-----------+-----------+
| 22a39c3d8693 | Bad    | 236.8     | 245.399   |
+--------------+--------+-----------+-----------+
| e2f3e35f1f5a | Good   | 277.599   | 287       |
+--------------+--------+-----------+-----------+
| 401e4963bf45 | Bad    | 250.149   | 248.899   |
+--------------+--------+-----------+-----------+
| 3e8c6c9aac42 | Good   | 299.09    | 294.9     |
+--------------+--------+-----------+-----------+
| 1fcf54deb767 | Good   | 292.719   | 301.299   |
+--------------+--------+-----------+-----------+
| c82a69629c53 | Bad    | 254.7     | 246.1     |
+--------------+--------+-----------+-----------+
| c02d5546ea34 | Good   | 276.4     | 294       |
+--------------+--------+-----------+-----------+
