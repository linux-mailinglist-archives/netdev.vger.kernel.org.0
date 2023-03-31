Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD086D23D3
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjCaPSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjCaPSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:18:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC282127;
        Fri, 31 Mar 2023 08:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CL7wMuKABN2Y/OrwtFJKLBqKeUZZ74y9Ob51yppbypvY3LHTHvQO1TJVMSPNCZAlBgrvk4yHppiz5MLGqE91bD2Ws/0OdQEGtJZxRwcwXs2wR5IfR4hZvgiXznzawl/LINqUsYhqPAMO7WRkEZ9wKay6p0/ngAf94xnBCNPCkXC9qCE0TFEPAig/l7sZJZ/GFPOxfh99SeCANH5O3SoRdmu/NnyWkIbL5kn3/v+haMSRAxLdrl7UUYZQc5L9kqvOW00A9nFwTX2IJi9PilEDhKGLoA1Ot2Aq1ACgvuFAhdEp6RtijwAwbLC+j8+ClprDHerNzGkxF+gXb3JzB8fsnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrVS0Yw0zvqGCZarcu/ZxZMuIyCFHdwss9NE1GCFSl4=;
 b=eSyoBdp0ogrg6PEiHzZ5FVOQV8nIfA819h9bfnW0b2WkummwCdbGhz2kjPBYg9TpzEg8CpzB9n6i9FYUsrzFinPOkALjnP/qIQLmV0Y8ee/SRdCXcaar2YkjtPkLLyr+A6npXqzjLJMWV5l7FthIcyI3+tF89pcPniO4ZtSiIBWeEOzwAvl0r6c3bUfZpfyxYn2b5R0pl+G3LpQiQVdIu7VcpC0NNmqMJKuEBRvzzFPW6TJ18W4VHMq+bls7jFGbiOqa1uJC3768WXYBLwskJ5EJg9B/i1Y5Q/tYh/+X7hiYUr8ye4tkaAu8uHiU5AiOiZidEgJ8lpwdnlYTMGM7jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrVS0Yw0zvqGCZarcu/ZxZMuIyCFHdwss9NE1GCFSl4=;
 b=q07kqh5hkqfdNe6baPjHI8Mn2DI6f/aJjosSf7uygWPrK7WkEa4/V9eSlcyLloL+QObgFNPEHroUWoPI0v56ZcAepySZ2vCK5SuCYXTVgM0shRKaevEeLYQEhXzXh5kG6XxhUpe7AAwtV7E5/fTFLdqAyCMDdePUHhy2mEihKrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5162.namprd13.prod.outlook.com (2603:10b6:208:339::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 15:18:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:18:09 +0000
Date:   Fri, 31 Mar 2023 17:17:45 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rt2x00: Fix memory leak when handling surveys
Message-ID: <ZCb5meIuw+dsJrP7@corigine.com>
References: <20230330215637.4332-1-W_Armin@gmx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330215637.4332-1-W_Armin@gmx.de>
X-ClientProxiedBy: AS4P192CA0028.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 361b7c5a-3956-46ab-94d8-08db31fb223b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGcvnEsHf65/jWgW7+jW/tWUl/uXgnRnj7hUrEWc6UNYnXXiyLxiTonuuhjTaZeRcNio+Ucv+hqnOk/8Etosrs5u8u/33QN+JuHf53Ydhz3wBjYgCsQ8ZlUULevHHam/9qZpJU8niG69uWt2DgllPMHZ+p8WSnwhmFTNrTajv2IJsZKaUpu+0k/hJNjU5aTKBwA5eJNjCFmI9JlvRXfK+wewo67GiGehoUhOd0Kxfo4fCnwY2e5bLBwoe+XELBmg1p6KwKY1cNqb01TIM/vkFPp0oyt1ExVnImm+s/wWTFN9lKFFvuHTszG3Oe4jJ1icHewSRkEygxQAbEsDF8Uc2jHIoG5oioJl1f8/CjA2J7L72l9eiBcF4SP2DwTzuDf5i1klt21AHNxc2o/QFx6VKrU/7Jx9o10b2q0PIMossmKZO8AVUYu0HhRiG5Kn/5XnZTQXg08gIGYqQ4WSB693Y6zoH0tqcPuQhZbmzt30cS9R6un5HZ2t3W3egfWB6LarosFzQkdPZbhGlUFubkMSqWI0AcTx0P0/PqZpN0lRAHM2wYg4mApiVkvG5T9NGLi05tjA3Jxc2VWfAQqxv0ydxCB+SA0Un8YQeOXpdMBAGK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(346002)(376002)(136003)(451199021)(36756003)(44832011)(5660300002)(7416002)(8936002)(38100700002)(66946007)(41300700001)(86362001)(8676002)(66556008)(4326008)(6916009)(66476007)(2616005)(2906002)(6512007)(6506007)(6486002)(478600001)(6666004)(186003)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LLIXs2cRAcSrEl4SLThDbFlBDxTtjcSdnZz/p975yuiZk+jru/nY5wdDZy+p?=
 =?us-ascii?Q?+MkHZSpYiFWtPeQJ8hMdv50n6Vxw8gqIPuVW+gW+atA2NCErqguVoFdJQBcj?=
 =?us-ascii?Q?bfxPgBxiFrouTAgcosBJEt17ytSwm+CvZy/kXUBmuqJrwjml2dG0LV0eVQXZ?=
 =?us-ascii?Q?N4yB3qMG5kaULLXGl+AUdCHlx7qcYJGl+TJrocRM6BZeGofbUE2gw0ZQ/ByH?=
 =?us-ascii?Q?LiETl6cheu1LA7/M3HE0m2ssgoWH0gT4o0+0Bxeov145x7vXk50BLBjFCPEf?=
 =?us-ascii?Q?0B4HL3tAs3+8OQV9ra7W15rQ+tAS3feSMMNapLw4gUpsuvAsd2sw5nR46avj?=
 =?us-ascii?Q?H6yOXghEpKwPwBNIOTwwsYwYj/vTXwZUqPIPuF+TeoSP4FTrBsWdgUj0D410?=
 =?us-ascii?Q?4VA7bG8/l8ZmYdJB3NSkElMuFkTCGqZ0z99PdToSWoGbvYl3pihTL0igInx4?=
 =?us-ascii?Q?u/4ZPia3O+FWLBD5gFKnqTtaXLRMdbuuz6HyVmFE/Nilb+cJ7zelYVJj3qbs?=
 =?us-ascii?Q?oObMdUUJuiKhYncFEfIp1wB1re+SRFoqSQn2/DSM6eVmaSkXpjLxYfS1yrvN?=
 =?us-ascii?Q?yRvMo2J5JiOAdZZ8czsEWC4vKX8FjcC3vOcPfrZBJXqPwYc7byt8u9KUU12I?=
 =?us-ascii?Q?7IRr/RwYGIlpSa3Plyns9LOSRY0Wy3+XdsMLYABq73CupdPeC8H/bbtErHJD?=
 =?us-ascii?Q?MhYXbNULDC3VSSicOGDZDqm0VxFzFprkFxa00dhn9+LCtme/Ms6gRMQaOHug?=
 =?us-ascii?Q?DSNTBkq2tlimnfXteM0QH0t4zOaA5oE2XTGv8y8AeWSvtz7ov9GK3koAzENU?=
 =?us-ascii?Q?r59IEGFL9UdEZlpg35ixZ8j75ryrwahXG5Ou4MVvUhVDMLu9WfLjcaaX0tAr?=
 =?us-ascii?Q?tTWtbutVbu8n7C94b/hoRjMhOm4jQ/hgEwdx5Q86Hn6Fm9q29dUrktY6x9+a?=
 =?us-ascii?Q?nyPM+lxBXO/dIwVDNSyIKDgFZK96+3Oe6ZQ0o7nBhlwcDeAwFMvqSfC8f3ZT?=
 =?us-ascii?Q?O7I79x18EvRzUMeTWePD7KbIUMtdJ7eM32eKwuf+iUB58+CS8mrUrYtw3Z7I?=
 =?us-ascii?Q?olDYHrI0fMSkHWFudjRYWG1FwR/Lpt+sbwsA7UBRN4z/+aoJgOv+335nZ0fj?=
 =?us-ascii?Q?JcPhGhnNxy9hMBCnij/Dzbr44o5U+kUoYxUGfVc4fRruv1vQRSS9KiHsX+BZ?=
 =?us-ascii?Q?MhNH8BffW+InXzVMpyX++DxjZpU3vm0ICI4RKsiOzQJFpnlhYgICHtXlPfxz?=
 =?us-ascii?Q?L/7pZ+0oB89WG2GnIGY9luTCgcV2Fgd6FPNpCkGqcDYwNier6lxJYSG1JuS1?=
 =?us-ascii?Q?cHfJfplayzW4Qt0Pr8RR1G1uSqoyHJCpbaU0XdTLxr3uT96ZXtsUGjI7tsMJ?=
 =?us-ascii?Q?wJW8lWZltbvkSx89Ty0ez8kM1hFP13X3Cq0Cz2emCT9PiJgZTmyEme63uWvp?=
 =?us-ascii?Q?dwQgsbIIk2pnMncwwah3cymylOY4snNw3ql3ZsKLZMPk1hDsd8YZB2wkktoC?=
 =?us-ascii?Q?B9Hy1cdkqBFuEZ7u+3Hzsb1QQxaih+YEzoNBksx+kaL86oo6gOVJ2XQ75UAk?=
 =?us-ascii?Q?XgM2/eWbDKFKn2LfSSz3tS+EuFFy7sTbM3E4gXy7UeaxcIdMQeZ97pppw70N?=
 =?us-ascii?Q?hig9ZndMGadme0IJ5moUv8Pmr9YkvY1wvduyxLYd1y9CXDW2CZbVpk0Y9skl?=
 =?us-ascii?Q?qwWfAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361b7c5a-3956-46ab-94d8-08db31fb223b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:18:08.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uo3u27HM/AmQ8pYKYPaEeioe07Fazwq+CMjDdDBc7MBzHWKHWMEE/dCUfjHMl0rBfh6tUc6z8SqONqhgTCbCpZSWVWw5qVuOvLCbAwVn1Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5162
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:56:37PM +0200, Armin Wolf wrote:
> When removing a rt2x00 device, its associated channel surveys
> are not freed, causing a memory leak observable with kmemleak:
> 
> unreferenced object 0xffff9620f0881a00 (size 512):
>   comm "systemd-udevd", pid 2290, jiffies 4294906974 (age 33.768s)
>   hex dump (first 32 bytes):
>     70 44 12 00 00 00 00 00 92 8a 00 00 00 00 00 00  pD..............
>     00 00 00 00 00 00 00 00 ab 87 01 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffffb0ed858b>] __kmalloc+0x4b/0x130
>     [<ffffffffc1b0f29b>] rt2800_probe_hw+0xc2b/0x1380 [rt2800lib]
>     [<ffffffffc1a9496e>] rt2800usb_probe_hw+0xe/0x60 [rt2800usb]
>     [<ffffffffc1ae491a>] rt2x00lib_probe_dev+0x21a/0x7d0 [rt2x00lib]
>     [<ffffffffc1b3b83e>] rt2x00usb_probe+0x1be/0x980 [rt2x00usb]
>     [<ffffffffc05981e2>] usb_probe_interface+0xe2/0x310 [usbcore]
>     [<ffffffffb13be2d5>] really_probe+0x1a5/0x410
>     [<ffffffffb13be5c8>] __driver_probe_device+0x78/0x180
>     [<ffffffffb13be6fe>] driver_probe_device+0x1e/0x90
>     [<ffffffffb13be972>] __driver_attach+0xd2/0x1c0
>     [<ffffffffb13bbc57>] bus_for_each_dev+0x77/0xd0
>     [<ffffffffb13bd2a2>] bus_add_driver+0x112/0x210
>     [<ffffffffb13bfc6c>] driver_register+0x5c/0x120
>     [<ffffffffc0596ae8>] usb_register_driver+0x88/0x150 [usbcore]
>     [<ffffffffb0c011c4>] do_one_initcall+0x44/0x220
>     [<ffffffffb0d6134c>] do_init_module+0x4c/0x220
> 
> Fix this by freeing the channel surveys on device removal.
> 
> Tested with a RT3070 based USB wireless adapter.
> 
> Fixes: 5447626910f5 ("rt2x00: save survey for every channel visited")
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

