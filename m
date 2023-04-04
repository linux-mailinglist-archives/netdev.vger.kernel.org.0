Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852F36D66E2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbjDDPL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbjDDPLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:11:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2136.outbound.protection.outlook.com [40.107.220.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BE644B6
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 08:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZzf1MfjR6aC2A6+1oEDw58E4CWR9Ua0HyxXgsy0+X5iHSE2dt0bqM7HoUrk7NzoZ5FsA25phnbLR4fT83qvFBOcZZYDKjM5YwLoSYa6JBU2r1VP0ElzWzBX2Fq993yV6zdFtk8E0mQtyzHsq2+y3290H77IfbOhURSe0lXgWk7JGs9mK2XAO8VJrvWnveRDl5TUqLzPt9vHGuizcAwIiJ80FLI7Bh9se0EnNHKO1Q24eSDQm+HlpGj70iEP/ayAyE/DRPJuQQqlrpScjhEhQubztECnZY9itNLtSTwp/ZsKmdDwHAjTKx6oDU+FuRPxBg2ectF/Ah7lB6Uv07UWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fwucOcoHMcR6njx5h51DHITcDKF/34QHBySTRP3K7M=;
 b=JIbrHEGqZKigvD8IaVgX9c8oRC7xBhQ8LNbgmhBRbaaGYEx2lO4Oie9dlqURHwr2nAIulEiDXgiqreRb6XmIY2fcANl8y9B+GKjni+m7H+E5CKSBpkQnC7G/EKsDr9o8TPb4ojeHf3yOKOo/bwOgyW/HGOruPcsw80qLgCFudCL9W50ZkWNA2W1V9zC1RGUOYF1Ryu7zVNerDAEhUaVp4KkAib+VR5jnq4517xzpSNpBSnvh4mqPhFkFRho3mH2QJ8cDfYE4ajplAiW/HVffH+xrzP2WhW+Bt1BB/CpUOQgY00Q1Gt+9pjnKIbJamorBoeyzFbYn0Wk7+mkrIkboZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fwucOcoHMcR6njx5h51DHITcDKF/34QHBySTRP3K7M=;
 b=oRH7fThk5w0Un8bpXilW9+pVrFp7wXW7pKEJbw67VBsIHhlaquwaAkMEEIJPFE/N5WrO/5LVTaQt3RBXDZAb3oyMetnK0FCZC9SKOBHmrKEmMHcNvWzTgZRt+LUuasrZA+osh0y0KjyZGSRbuuX85NwmVQOx7eeqqhqwobHZN8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3717.namprd13.prod.outlook.com (2603:10b6:610:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 15:11:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:11:14 +0000
Date:   Tue, 4 Apr 2023 17:10:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netlink: annotate lockless accesses to
 nlk->max_recvmsg_len
Message-ID: <ZCw9/odI4zDHOw5W@corigine.com>
References: <20230403214643.768555-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403214643.768555-1-edumazet@google.com>
X-ClientProxiedBy: AM4PR0902CA0014.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3717:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9fd6a9-fd3c-45c7-b31b-08db351ed4e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ii8pE77f9FadBLZIzsQE/4Px8faBPaxi+KPwtd7ZXr++PkyoaAxZ0Kg1OOkIzHiqCig3QvcYNifUkUsJk8pLosrQ5U2Tunk9DzKGggjblfMg5LZtrzNUc0i6Mu+8hQ0mYG0hyM+xEnnNjNB+eQVbF0zMNCCauliMCSm0mkdw00zJvorCSYh2Li9FNwnZ+XZdzArmg9Pb5XSCCvW3xcQeikn1+EHU5QSlO3RV/80mAgoDXN1tY/QUQRrRYDfaAN11MY/157fyHN6O4w+Zg9RDf6KNKUCBbcqi3zDrXjVAEpz1k/FPipmwyY/GLjFfbBFt5M6tu2Zryqw3Q7q5vQzRuKyH+nB+ZJfFz9Klxqwb/DlTqEHzbYQUcIuf4epZiT8hZcPaoBEWV+O3uIskquKt49ekVj3naLkQMqbkuyWcY9SzllSFdLzXIhB+H+TzFsdIBWLV2bHwONgRfjACMLj1/bXzEDA2COeppQDT1jdIyWdpZ9d+zmxJ5N89xMlxuCpeek3xcILXkkzO0c29p6myn2YLkYMnCSYxjCpYyc0EsRY+Zz8+ks5bmwtLEUjxhV0zqRex3MrlfpkEIMpkxgvZUyf64e0BUo6ffwsKzDCjW24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(396003)(346002)(39830400003)(451199021)(478600001)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(316002)(54906003)(8936002)(44832011)(5660300002)(38100700002)(6916009)(186003)(2616005)(6486002)(6666004)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YIRvP4wBTKLE7xaMvVZuV0NQuS/0eQeQCOsS/38yuPncFGVEBYUhLFbNRCIc?=
 =?us-ascii?Q?RDYJPAPRDcFfYEiiNJQ+wUNSDXFFLvF5GGRc3VGiwibau1vE0eZ/wZcsKQCi?=
 =?us-ascii?Q?aD1TlZDZxVbHCSPhN9T3kN0XmqcGIevFWwDc4s63lwtrK255ot5iOmI6AFaG?=
 =?us-ascii?Q?q/dRld3JBskW4VErdlehv550EDmBoHNC5DJ8BHaAXmZwdKDM56O8d0LYKbu8?=
 =?us-ascii?Q?y72hsbJ/iiXIyaUnzyu7mTC05bik33wkfg+8fNHhA9YZ1JpRGqG6Qx959RB9?=
 =?us-ascii?Q?MfxWj1A4Zt4vQ2QWc4aM8xyT01eTkJGZOgbCEZnOy3pRGfy07uU6Oi8S0LyY?=
 =?us-ascii?Q?FReK2ZKp7ZA447LVjmp/v9OxWYEOu+dl0DB9/HlXyxzVraOkLuqLIOneW0vg?=
 =?us-ascii?Q?yGYIsljxZZ8oXDHHiW4HF5Ib9AHLoHIq05ebZoUdM2FjafIVNmED8ojLFxMg?=
 =?us-ascii?Q?RtV9G4zLLEq5C1txwQZzJ2SbrqLfhk6WmOvfQDhhMXAmq6jwjiA2ZDQUffB6?=
 =?us-ascii?Q?/ZS6YB/Ri9C1PKQdYw0nhuquN47cgcI+7DagsAf52Vxk+4E5mu12nL7UjTJQ?=
 =?us-ascii?Q?U6xWrO0bk44F93USKm7ZmDqIVDbZ26QVeZAkkcF/LtLFLcIkZefIV5/VjPz0?=
 =?us-ascii?Q?+ZKpo7IZyefhO8qXrP2Tvb8q4pkaipTzmvWA7cRS+jKSdggaczhkB5FzKRJq?=
 =?us-ascii?Q?0LewgSYgWriK2gPSnGy+ZgL32U/f6RuPb1u5AREj/anbQIcsSopHaP6EvQVo?=
 =?us-ascii?Q?72wY0CyGONWUIYYjmSTA5/Zq/bxsb8xRS5ZV9nk2g9uam3dcbIEjeutvWE55?=
 =?us-ascii?Q?52//OCOkqvqyFlNOBFJNlRssaEXTGBDOIwRBnB3+nNsIvXQfpwVnNiRIl5Tu?=
 =?us-ascii?Q?nv1he8T2gvqnVqaOMjN29UnNpvkGYbt1Co4xHEEHrFdPDU86niospPaEWZfU?=
 =?us-ascii?Q?/hMWTxPjTDLyO0ScWWdcKa4/qtSSHH/cHsHlVViqxDFMKYLQY20SlTpZ9gi8?=
 =?us-ascii?Q?McbabNpZaYL7NfzDOpD3myqBkrNItn/ZxkNjT1z7FKjsfeIFOXM1265s5rto?=
 =?us-ascii?Q?7rKHfnEaHWvTy9YUrCazc2UJ37GBnt5Szqp5EJBpoFmowrdawdtQl3bOIqJ/?=
 =?us-ascii?Q?jFyvCIEUd6N6QkVm7nC8T2YrhXHRqlrt9/wDHmEfnxj1WQEdl3iM4hByXrfw?=
 =?us-ascii?Q?by+mmDnj6vV8LMF58sY8zmTu8E09r6A6O+FwguTP0H9GGVKPZ68ns0ERCAI7?=
 =?us-ascii?Q?hw2eBEZdm5XZGqMGiU3E6piHklHLbQKWocs/PKF3Uf6R6XxETkM4h/krhbjs?=
 =?us-ascii?Q?Lb/EsR7VClledGcArXyqeA7GHFpw8/VTlIVQfNRKtfTC0QJtHN/SaLgJvA/a?=
 =?us-ascii?Q?ssc9PFuveasr2Jn+09eEqMJsDhb9w/uGv1vo78k8FKSesvZYjAWvRe8zyyto?=
 =?us-ascii?Q?yIM1SeQRHrZmH3K+kvYAui6Tbqa/nEjWw8PqvmwzEBEPsyD3FTH24GpYn+6U?=
 =?us-ascii?Q?o3jmS+PAk5iKL3O7JnSQPop96tuh2aP0xQ7YBJIMEL6J8p2Nx3kOXBZySvH6?=
 =?us-ascii?Q?1UkHLv0w94BiRRFMcfndeAnsheu8vAfb4UDidtAtNMpk5eimYDKz7Bh20ATd?=
 =?us-ascii?Q?2Sj+XxTDO7knVKdOygs7doNkYYYlo0va5Z11sN39NeQV0BNpTbrLj2aqTQtk?=
 =?us-ascii?Q?QPPEZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9fd6a9-fd3c-45c7-b31b-08db351ed4e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:11:14.5902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4XDOEYaYDq/VWkwhTXOsqhbggy0PlCRAzz1unqP1IX4Ostat6RbcWxfTGMxbFcEb7y7FHQmZqHydXP3cbXokioLA/2lRFPjvDRvXF3VcmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3717
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:46:43PM +0000, Eric Dumazet wrote:
> syzbot reported a data-race in data-race in netlink_recvmsg() [1]
> 
> Indeed, netlink_recvmsg() can be run concurrently,
> and netlink_dump() also needs protection.
> 
> [1]
> BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg
> 
> read to 0xffff888141840b38 of 8 bytes by task 23057 on cpu 0:
> netlink_recvmsg+0xea/0x730 net/netlink/af_netlink.c:1988
> sock_recvmsg_nosec net/socket.c:1017 [inline]
> sock_recvmsg net/socket.c:1038 [inline]
> __sys_recvfrom+0x1ee/0x2e0 net/socket.c:2194
> __do_sys_recvfrom net/socket.c:2212 [inline]
> __se_sys_recvfrom net/socket.c:2208 [inline]
> __x64_sys_recvfrom+0x78/0x90 net/socket.c:2208
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> write to 0xffff888141840b38 of 8 bytes by task 23037 on cpu 1:
> netlink_recvmsg+0x114/0x730 net/netlink/af_netlink.c:1989
> sock_recvmsg_nosec net/socket.c:1017 [inline]
> sock_recvmsg net/socket.c:1038 [inline]
> ____sys_recvmsg+0x156/0x310 net/socket.c:2720
> ___sys_recvmsg net/socket.c:2762 [inline]
> do_recvmmsg+0x2e5/0x710 net/socket.c:2856
> __sys_recvmmsg net/socket.c:2935 [inline]
> __do_sys_recvmmsg net/socket.c:2958 [inline]
> __se_sys_recvmmsg net/socket.c:2951 [inline]
> __x64_sys_recvmmsg+0xe2/0x160 net/socket.c:2951
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> value changed: 0x0000000000000000 -> 0x0000000000001000
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 23037 Comm: syz-executor.2 Not tainted 6.3.0-rc4-syzkaller-00195-g5a57b48fdfcb #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> 
> Fixes: 9063e21fb026 ("netlink: autosize skb lengthes")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

