Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D4E6B9BD8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCNQlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCNQk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:40:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2114.outbound.protection.outlook.com [40.107.93.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2153CB6;
        Tue, 14 Mar 2023 09:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QC8JYn2b/K+tOuEVJ7y7INuMLpHtVC5ZQNnNag55NNW/W6kOuLhV86+FOYq7kupsoM17/KmgHMTuayLhYjvKBS1EXGSaUnfpM6QSC+UvHfmQTNNZSd2MpVBwwuCWhBgNg7MoFvNwM0MktidzojPsyvFpUbiTcKzbEwCblNfGVCYJPl9FOgDh6e2ApZYqsaBf9xDv+L+dOeAP7ueILjvQYdfbnE0SDb96A1ZjJMonuCTyGicjqFYYlmhXr2EjqEhZONNNNni56T29wpuURCNrljUD52Y5iza4OnEFiEU1ot0lkHraeOlOWkoBv0Bh6GHHaXEKwyOCDETypehezq1nkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHaKyycY4VsKGltNHNX+S0bZ/16hsqloyNcXe9ileHk=;
 b=VpmqW4cTC1PDExoO7iTuwbvHcCkphWdlBpfXTYySybCPgvRE6/s0H2IhFQMQkqN1X8f65RkztXzRPfhDEDDcqtFSi10AxOSaZAVeXly4bEnf6X/5/IuMMbF8yovHupsgu30wJ93tpG0+t8Rms8aErH/wUfRqMIAKvMqLBI+GbynPxj56ExNgBmAyRbrgfdylXDTA74FfZg4H+AsQCzCSIPsXzaKmZ1rm+zlayA8bFn8AYlKcc5Pdzb2nBZbSOBxoxh+B+IDhIycvcVyevU98lr1Mhu2Fz7cwv8w1OIByyzdgZ6U+WEmm61GOKvXfvZhWRhNUFVfptG6yoTgRU2jF3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHaKyycY4VsKGltNHNX+S0bZ/16hsqloyNcXe9ileHk=;
 b=OL9pgd9FQes1dhV5A9eWwnIcK99byxpi3vTtuss+YHpoLQz8CoaiOLGLZoi0KFZnu676ZWjWRx8OcIVmbpoSl0ylF7yxdX/riaZQOuhQFo7dkBujb8u2r2JyCf2KDqAttqZmLe6mZziwzUe1a0x1gaQFK1BRAK537rgIVbvL3EE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4927.namprd13.prod.outlook.com (2603:10b6:806:187::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 16:40:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:40:54 +0000
Date:   Tue, 14 Mar 2023 17:40:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/4] net: set 'mac_managed_pm' at probe time
Message-ID: <ZBCjj6btYod38O7g@corigine.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: 8952b8a6-6978-408d-992f-08db24aae0ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ec0mEPNjRK3pG9qvgzT0vkOUYrqMQhIhgSJ0vHEDfzvsQh7OZZMNxDzjpjZhVqtOxs8VI/OMxPqP1IlzDFOva0z+AS/8jNx5EnCjg7IKWkSbdBPSYYFBqqWa7tW/J49+8NjtirRzD/PizqSX2aUJT+XsnRlX1ub5tAXCSMgLL0kC4Xeha1sgeYlv/Ue8nfWpOlG5Wwg8HuarKCLL05yfy3GTHHEUqHIkBQZKFand2h2cGZXLn4a/7+Ie+G03chwSodyWoSgaatNlgIoYXYYlNEE6XA96zFmOUKm/ewmUSH7lqPWR+e0EJxic112yJdytpMWub0A6s0+AIXY0RfRxOTCHENHZGN90Ds6ktpH4OSv3pS5RY2um6dsMPxwaT51Sqs/5jss6r4uEtrZraM2A37JnrMtKFVYgTNTyOGtbUf6ulMboF9zDmppRtl4ZErPCD2/S4cOgBltay7tIWTQj+bjp1wZz3zoZgHbeKZVnnB7pqi+OvhsH4Unr1i+qFMOFmk4l9sh+xVDAfbzrBmqhVuRb5BnI6SyoPmcYvne79hQkObYOWcRW+oVbxHvj22cQbtpFNAVJ+Z3w5qP9w8TkO/5bRSp2aApkFyUCKpbi9tTgBQZ1jh2iM3/HGtQSiLW9uFXwtXI5j3qodmmOIPbrGWyWYy1x/VEru3rycpdz4MVXxgbPHdQR5m8oVLJZn1No
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39840400004)(346002)(376002)(396003)(451199018)(36756003)(86362001)(38100700002)(2906002)(44832011)(41300700001)(8936002)(5660300002)(4326008)(6512007)(6506007)(186003)(2616005)(83380400001)(316002)(8676002)(66946007)(66476007)(6486002)(66556008)(6666004)(478600001)(66899018);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QmBiL4953l1FllB94spdYmxDe9+o4AqtLPpvALnzGhOIuO6/NX+3s5mhhcLL?=
 =?us-ascii?Q?XTEEoRFz/pVOEJuKhIFiWn0IX38932tP1t8yn+oF7dB0dME53GJncbg2vm3p?=
 =?us-ascii?Q?sTrRAwtw+ik8yH3OHnsvFNBt5jvuA0+zXfX7IneV81qbBqlBIem+uEG+h7Fb?=
 =?us-ascii?Q?OADyQwvsmUmm6zGabSjaoMV25WJ96wM/4AdAEBeHCYi1wRkhqxxKY3M2u/Xv?=
 =?us-ascii?Q?5JvvmX8BxFZL0qy2AXjtIBVtjYeeig3AiJjo6ctAv+qNZO1NfSDysBJMSUMB?=
 =?us-ascii?Q?BQRyZ/Fl/a+LOT1cC9wXv3TnfyqbMKqdbmBTOCJ9Uv7az8Tq8qOG3JvyX33A?=
 =?us-ascii?Q?OUPtYCqUGfKziFOqm1RczLxH6Of7Br4kMRAXWHVlxh7LETJSBLXViD9Sta/f?=
 =?us-ascii?Q?uRYjdDL0IcP8E0VrF9Vz8TjH+aIRSJzZpoGA09kh+hd/vJnVOft4/Cazu9wq?=
 =?us-ascii?Q?SAzLhvN2DltTSZx14gd/oIc1Tbp+OhB7lCEddQRq1yyZIvE2BQbK1orC/Ekv?=
 =?us-ascii?Q?9e51zvw+p6X7c5Pvs7pvBzX+lN0WFcbnvBimrbT9bnGeFAOVlMyjn3d/9huA?=
 =?us-ascii?Q?IfDI/xCv3OVZr0vGNWEDpo7/oH4cyO8UDaI0w5aslkKlibzqKdEQU3kugMOU?=
 =?us-ascii?Q?bIFi8j5veuD8dtjml64siD5NYd3z2y2J5HbSD1iW8xflhrLdrbsq3SCBjCZu?=
 =?us-ascii?Q?88ES2uVuSMzLOe01CsrXoD/xE6CPrzRSScCTEwSjbfr1D1SEiVdkpKjI0aqx?=
 =?us-ascii?Q?/eoBjr0BmUPBbr6pVtrwhcS+BsMBggSIO8H1lOnRpQR038yc3lRJMYNIzBGb?=
 =?us-ascii?Q?FEQthQ9zOGhTHGnGBb9o0YFYKhBwOQxPhTG/dbCKRopvTHw9dz/JjOdINZYl?=
 =?us-ascii?Q?IZZN5/ufVHLGpTWqJVcOPwWqdQJntwNGUd4/D/+4mJIo/PNjyGcUXPD8OgGV?=
 =?us-ascii?Q?ajjNbT7w+FdVBCBrvZyDYPvHP4dpIKbWa9HvlVgNfeUsDE3BM4BFEe+mFR+Q?=
 =?us-ascii?Q?8M4EGSw3RmilgbCVz37um6Mjx6zOOXzB8YLHiTtmQfxTnYVeH8XPjFOJX+yV?=
 =?us-ascii?Q?/ACKYt6EzTK1+HGv4qfp7pPqmesrcCl0tHFvxU+feWIOlO3u6sK0vgVBXh5Z?=
 =?us-ascii?Q?qbCuoL5Q5FHzFi8RTw0by4fEBLsuArscZOB0t8d6TRJzWFuLYlG9l7OV4c86?=
 =?us-ascii?Q?phfLE1L282KuscFyGPK4Y1+2P3a1zH+wQQUv03jI6eQTvXCFSj39vanVT7CH?=
 =?us-ascii?Q?q5oUShM6tPkqiZsyv7axLuTDiVLQbwMRd0b4rRQOJPK0u7zrvJdl/wN4pKHH?=
 =?us-ascii?Q?yA+fcCwQBwDsZ7Vdgizp5aDqVJEWBu3VWM+zf6D5RerYxPHCaWIgBgmV18eo?=
 =?us-ascii?Q?Bg2KuLcoqu7rLn7uzGoiH+q0NnUzlrSuz08eh5QeNab7nBx07kWd8Wa1tcd2?=
 =?us-ascii?Q?hK0VmYdu8YxA+xt1ttxIaETeQK/64hKyGoHodrA2zpBgEWCWtKKj2M0GuUql?=
 =?us-ascii?Q?Zry/jPF2KOo8CWhvDKq2KaeEP56eOsrBxeJ3/EMRWd2Ba7WMQBeaz9r7pZw8?=
 =?us-ascii?Q?zMiedXjbv0jpoifCF5W/6eNk2TNJ8xZ4IOkyRic9hw2E5JQL0wzRWN+K2aD+?=
 =?us-ascii?Q?CEPrvsRaUt4xyUDxilU53TU03+6guQIUHSVVDEsNI5WZG08h3vd4VzAHCqHy?=
 =?us-ascii?Q?rAGFmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8952b8a6-6978-408d-992f-08db24aae0ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:40:53.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1gY8QZ9g0gksrGNO5x6XGO00M3hNQV5ffpqOyR1WVEZ+b7yH7/MFIegOyj4UKhvFF4YmXyQvom3CHw/VG1aQZg1thvjKbN+HcmCkSub5us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4927
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:14:38PM +0100, Wolfram Sang wrote:
> When suspending/resuming an interface which was not up, we saw mdiobus
> related PM handling despite 'mac_managed_pm' being set for RAVB/SH_ETH.
> Heiner kindly suggested the fix to set this flag at probe time, not at
> init/open time. I implemented his suggestion and it works fine on these
> two Renesas drivers. These are patches 1+2.
> 
> I then looked which other drivers could be affected by the same problem.
> I could only identify two where I am quite sure. Because I don't have
> any HW, I opted to at least add a FIXME and send this out as patches
> 3+4. Ideally, they will never need to go upstream because the relevant
> people will see their patch and do something like I did for patches 1+2.
> 
> Looking forward to comments. Thanks and happy hacking!

Hi Wolfram,

an initial comment is, and I know this is a bit of a pain,
that 'net' and 'net-next' patches need to be split into separate serries.

And if there are dependencies, the 'net' series should go first, and then
the 'net-next' series should go out once the 'net' patches have been
accepted and 'net' has been merged into 'net-next', which I believe occurs
after Linus has pulled the weekly 'net' pull request, which typically
occurs on Thursdays.

> Wolfram Sang (4):
>   ravb: avoid PHY being resumed when interface is not up
>   sh_eth: avoid PHY being resumed when interface is not up
>   fec: add FIXME to move 'mac_managed_pm' to probe
>   smsc911x: add FIXME to move 'mac_managed_pm' to probe
> 
>  drivers/net/ethernet/freescale/fec_main.c |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c  | 12 ++++++++++--
>  drivers/net/ethernet/renesas/sh_eth.c     | 12 ++++++++++--
>  drivers/net/ethernet/smsc/smsc911x.c      |  1 +
>  4 files changed, 22 insertions(+), 4 deletions(-)
> 
> -- 
> 2.30.2
> 
