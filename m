Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A86752EF
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjATLB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjATLB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:01:57 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2129.outbound.protection.outlook.com [40.107.102.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B359981994
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:01:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSYnjN1pVbV4w6HlLZlDQV+1kePbr6h0A17c6qJETP3413Kfy0EAhtKVvgsETWFtEmDN+drd12+1bpFzSTzzfBBkBEBmKnoIZ5DnrprORkT34dU+wnjxfEnLNfy+w1cWDNtiw6Vg7w67UBa+ZmbHNBXGeGShyGaHGX8CUTSWhF4UjvQRmbVohVMM58HZSj/T7hsVi/ajwmYkrxbiiSlL/5YLrVvRmpf4FgWydhrEQPW53be2xH0PZlV/9l7RtuuebeuQXYb8SSfAKeePRaY4HV7QYZv2zbJNjHkzISFVjLb0geXF5+7vtZOs8btdVLSbbHXQPIhWsf/W+jy+cHr0sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dv+rLW+CXSrG7JFZBHwgZnbr8Vwx+7SiDuruWykfKv0=;
 b=D2oVtQs8AM0QaV5r17PbbEgEgLKihe6A1018eSson7DgzXfJDEGqOAKpGvv0MVFWUEmnG7jwp5KYSlXzqr/59kcJPOhmnD2hpSr3/qL6hW+hk5qBP7wEElFKcgtssYZRbVaK0jdyMo8p4fQlaIj6JYmwGHZeJTJyEt1hVl2R4nEp2S/dsszmw9ENdWblxa2iwmoTxqR3yrHjyDogtia8yVwrdPf4xL/KcmqA5ORRTFXKxa7BuC3y0ivMm4LfaMn2qm9Frq12Qvk8RlL8V5WdNexSrYcV8F+qoOrjMQMx4JGBbLWHPjtiF/AgihxqjiRGeir69U60d4VuNcuPoUzHWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv+rLW+CXSrG7JFZBHwgZnbr8Vwx+7SiDuruWykfKv0=;
 b=cF6KDuT1bzg8y17a3vBFUIOD3FLixlpaGJ+Nq9DCziW/31kOnY8PbF0mRgglIH+ZW4UM4VZ31YkxWoWql2wFGwOSUyCmDwzKFku1HGW3LDXmA8n0L1tczyhzAQuui4PlvInMjyXIcKJmoJp2nBH1w9ZezlJivcEdrtoEmjj1yRE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5144.namprd13.prod.outlook.com (2603:10b6:5:315::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 11:01:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 11:01:51 +0000
Date:   Fri, 20 Jan 2023 12:01:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: Re: [PATCH net] net: fix UaF in netns ops registration error path
Message-ID: <Y8p0mW+6ZVucucKh@corigine.com>
References: <cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com>
X-ClientProxiedBy: AS4P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5144:EE_
X-MS-Office365-Filtering-Correlation-Id: f7760d04-d2ce-4ea9-2424-08dafad5bba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QtdolUMx2mpepId5i6FETj02PeGUGauIP78wqjrVlhlCRxoytveXKBwtbZDOG4acSAwzr6swIP/LYlxQxDYQ6Y1nCVz8msIjDkMQGxg12/VLDjc4LXGyzaf1BBEjSDoub7DAdHQEyM0YkHPI3XlgkWr5LDMIrpBplFpY0TAQ++Kc+pqVLcneMrHPkTLs5bJg/5Yd6hzGA1T7c/nMXK5/EwjRB8v1lckL5U968MKfBu/Rt2SYoTbA6Pt+7V8mk0zA7tfu3AGHyLmL/3D7rZhBenMefta1jlga/IUvpl67TO9c5ou6al0R8B4jGsWqo0ly9njyvAJvBqPk001DXmWs57rNmtwydSXj5Hsx0zTES4xQEyEog6fk4s8/dqfz35UFhL1+DKa0H/YRN/g3PzorShVvi7zPw+EqW8to6MrsPgrQEEFDNSCPGjd6RdKNKY2io2z1SPf4blwMwUtFNfYP2Piz9m+GMGrYgHgCKYFn2cP8cf6dPar3NDyJVBBAiesMIUPH1a7asXtZWqHy+eza9jFFeKG75t4mRGgPsvbVEtJCmaHM+1rd9UIEuygM8WNjaNjazLoinUTPnwbh4ss+4+vyEnrPjkQX8SIJrSv3AeEyfF8rsuEgbAmw+UM6X9yTbeqazNjsJYEAB8u7gd//HBRbF5YmPtqrxYtUNncKzWRRLsrxIUuDUV6zXCjHRMBw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199015)(41300700001)(36756003)(44832011)(6916009)(316002)(4326008)(8676002)(66946007)(66556008)(2906002)(66476007)(54906003)(86362001)(2616005)(6666004)(83380400001)(5660300002)(6506007)(8936002)(38100700002)(478600001)(6486002)(186003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUZKENcP4Uzn5j9Z7A26QaOCGPFy8VCA8pNaUskMJcvlHsIEQzuqAda2T0Xz?=
 =?us-ascii?Q?6b91t0kgs5vDsKK7KXv2Hth3SeGOFSl/PCmPCnlXvVDbhCMl3hxf7QX7iaY/?=
 =?us-ascii?Q?CrohYIHp1ggLqr38ECyAqpEvl/r6rg9V4To5BqjF1Se+o60p7iwLYSga637r?=
 =?us-ascii?Q?UcsnryWImZFFOl6Ux2WiIGe7cOjGisr1M6gpuiyjQO4C0AFZ+FOGcJnq3/Jk?=
 =?us-ascii?Q?Wjx7/dVnXPAHwgCotND0RjsBE2jqCUEJB320fxAz4VFZhVMP4nvjBopdgjOs?=
 =?us-ascii?Q?Y33bCnpIyA8OwObBt8CA+/Y93N3GD9JArdvz1Rqc43ot55dezNVZ4ja3EUkc?=
 =?us-ascii?Q?Y7VjAbMWVV2NYadYvbnzY37YXAubUjCBVcXn24zEPMJkTXeNa99LKZZm/J6T?=
 =?us-ascii?Q?uMmEnw2FOjC8ndmmQT8iJE8FH96f68Ri3DG9FJ/wc/JHGN55MYmY9vjs0Kzk?=
 =?us-ascii?Q?djCayqVBh+wiwjne2D1r/z5K5i/wGBk9TFl1ZkMQkPaitHX36sB8o501IyaS?=
 =?us-ascii?Q?NMWtQtpPWO9+Oh9pk/dUnStcKJEfboRX3NgIDO9/dQlXeRS8fTAT9yYBoIUK?=
 =?us-ascii?Q?GwC6I9zwnm7LVf+PzPOKOF9hL6j9RF9BPd/SfKTrmEN5GibaVZrt6MUF7Ewv?=
 =?us-ascii?Q?FlVHd1min9JY8hPRTwoSuLq/wrqb46H06jil7yUKxNFJMaiUsF3U+InchW/m?=
 =?us-ascii?Q?FvWWnqFZSgsPqoLiyT+4JPSfi7tupuKqk6a1hKt49rrszobDrlUZKggo0c8T?=
 =?us-ascii?Q?jFdhMBDhjYsZ8ng8pBq4jwadK31RrrTvsZ23CPsFAyRANKP12eyQPgZp3fvc?=
 =?us-ascii?Q?Mdv3WNG5HOptAHKUzMQjqCAZo9cJwG2CZ1ELmzyqs7FgSZn0ln8JvS3nbv+9?=
 =?us-ascii?Q?OLtiSGVxXBzraTamo/zzIc4McrwqKiZ1smfYZDBLkEBu+Inmqy0rWHmExrb6?=
 =?us-ascii?Q?faLFe7EqwYb6qLgBdaDgOPqy4dMeVLyio5ilT0rM2hMAwSTIaZk7Q5CVVYwf?=
 =?us-ascii?Q?OfOIYqfVj0b2G4s7SFF5R3Hu4wYNJt6clKYcjFQKmp/zZ6392Qy5whQWWuXV?=
 =?us-ascii?Q?vSDXQWuo0ENOlDqcoMsyMqCHb+CE4QAsYrwNDpjcBvJe4PlkR8E7z4s48VE4?=
 =?us-ascii?Q?5UE5sgOW1ebbcbwV4FVRDKwR5egY45vKAVZjkVk3r4udNvUzoTBcoXfFa3/g?=
 =?us-ascii?Q?CwBr+lbsrnLr0qg1DceXd/mbAMgtgudvkLwsMByRoJllZbLtDg8rvvEsLidG?=
 =?us-ascii?Q?76N2C6fNNv4uheeGZ2oiDFdppakm4meQ0lyQjAxUOlfVNeSCtAANTBSbdf0Z?=
 =?us-ascii?Q?Ok5IGj27BHfv4gS4WNoC8UhLOykkly8l1Q3ZOD9B/4o7O0wZE6uOLvx0m2X5?=
 =?us-ascii?Q?CSoE625hztUwr07Scct2Dlqbs9UaLtCDdclwUeQ6gEIz8mIneqVW+FW8GMrY?=
 =?us-ascii?Q?p2C4KGybGzlypOW2DCEhDTYAgeDcLkavQFxcr1H5g2FupERu9/evjJiSpEpX?=
 =?us-ascii?Q?fsaTumMh7a3M5dPtCs3UbvGNlrE/J9P5Mj4n6Jpp1XcjHR5/85kDxniirD7q?=
 =?us-ascii?Q?hWSd7/IhOZb7tO9AMBwaO15u2kX36SPvXIXfw7dim3wa7H1e139TRMp59XNE?=
 =?us-ascii?Q?Q9Mn0hRv5xYhD+RDylhBL5abVMHS2eItaEGMJ+Q6AffmBCscttIczT7ftoth?=
 =?us-ascii?Q?MRiCyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7760d04-d2ce-4ea9-2424-08dafad5bba1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 11:01:51.1736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUJgUUfpGPkKhrDTOeyJnmZs3bm6U3QlSFxv8/BOrG0FMhs4ieGuSQKVFW6xIblkGMT8oG8fbZ+kAdyVyROgv9jjA7TYZSroRgj8l89LVYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5144
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 07:55:45PM +0100, Paolo Abeni wrote:
> If net_assign_generic() fails, the current error path in ops_init() tries
> to clear the gen pointer slot. Anyway, in such error path, the gen pointer
> itself has not been modified yet, and the existing and accessed one is
> smaller than the accessed index, causing an out-of-bounds error:
> 
>  BUG: KASAN: slab-out-of-bounds in ops_init+0x2de/0x320
>  Write of size 8 at addr ffff888109124978 by task modprobe/1018
> 
>  CPU: 2 PID: 1018 Comm: modprobe Not tainted 6.2.0-rc2.mptcp_ae5ac65fbed5+ #1641
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x6a/0x9f
>   print_address_description.constprop.0+0x86/0x2b5
>   print_report+0x11b/0x1fb
>   kasan_report+0x87/0xc0
>   ops_init+0x2de/0x320
>   register_pernet_operations+0x2e4/0x750
>   register_pernet_subsys+0x24/0x40
>   tcf_register_action+0x9f/0x560
>   do_one_initcall+0xf9/0x570
>   do_init_module+0x190/0x650
>   load_module+0x1fa5/0x23c0
>   __do_sys_finit_module+0x10d/0x1b0
>   do_syscall_64+0x58/0x80
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>  RIP: 0033:0x7f42518f778d
>  Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
>        89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>        ff 73 01 c3 48 8b 0d cb 56 2c 00 f7 d8 64 89 01 48
>  RSP: 002b:00007fff96869688 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>  RAX: ffffffffffffffda RBX: 00005568ef7f7c90 RCX: 00007f42518f778d
>  RDX: 0000000000000000 RSI: 00005568ef41d796 RDI: 0000000000000003
>  RBP: 00005568ef41d796 R08: 0000000000000000 R09: 0000000000000000
>  R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
>  R13: 00005568ef7f7d30 R14: 0000000000040000 R15: 0000000000000000
>   </TASK>
> 
> This change addresses the issue by skipping the gen pointer
> de-reference in the mentioned error-path.
> 
> Found by code inspection and verified with explicit error injection
> on a kasan-enabled kernel.
> 
> Fixes: d266935ac43d ("net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

I don't think the error handling in net_assign_generic or
ops_init are helping us to get this right. But, FWIIW:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/core/net_namespace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 5581d22cc191..078a0a420c8a 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -137,12 +137,12 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
>  		return 0;
>  
>  	if (ops->id && ops->size) {
> -cleanup:
>  		ng = rcu_dereference_protected(net->gen,
>  					       lockdep_is_held(&pernet_ops_rwsem));
>  		ng->ptr[*ops->id] = NULL;
>  	}
>  
> +cleanup:
>  	kfree(data);
>  
>  out:
> -- 
> 2.39.0
> 
