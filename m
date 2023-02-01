Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B768C6869E5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBAPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjBAPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:18:19 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C07D7164E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:17:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVmIpgNLoxfPRwPT5NdK1E+OgmkinEejCCGdq7E85RqFgAQYuBlDLQttEcZcfSuDJpR3h/6t1FePY+Zp09X8hqh/YbPYgNpmy8GNOT7ITamKSu4hNgDixWlzCGmOzJkRMFGRVL2dxd8gsC46mUAGlOaKRzW0PmiqQJmj2nndYu+BIP+SHYUR+9pzdpNrltrjC21/VO2KZbjxiHu56iECbfXA4Q0X0RpBho5M408Cc4Z/53VGjtGsM51wB7etFGN0WO6rJ8AZbaetwsNfzL5CC1ANoDsHxxpygzzJgQmmCON/Cmo8pv+e3CIFLf6dKXUQxARo803UpadR6RIrkkcUxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=314mbE4mO2KD2VKuOck9X3HKAI8W/K3I5T1kTUceRNM=;
 b=BFYC3QWa9LIGVZUCy9aUr0Qz/VhA8+8hGSxWo3+IkwMvAcx0xQm+ICMzI/DLj3n9Ese+b1f0yxsD8fw9MnEkniZpmApNexJOMuMalmD77dNv+VO9wBYub9N/2AeCm5pGFgmPmwnGgMoa0zDlwe4N04VC70HL98FywkgR4HyQvvVeD8TlAXm8fBCC2KH6aP3TGTfuzbMSHry4oB2luh8LKIcFvFvRi/6/AsxMgUWMW4S9ZNIM3wbx2CZBED0mYkjOzVFN7vMryAYR7xrTRaI1MagWlSYvp3wB4HWI5RIAYconZt/i2W3QX6QWlC3yi2fXwpOaSwbMMdVtVpf7xnnHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=314mbE4mO2KD2VKuOck9X3HKAI8W/K3I5T1kTUceRNM=;
 b=OinDYzfPsA+/pqvH0QTiYTJTkVIlcIGaXPIHJcwmvsBpsQOQQrmFVhjbMznlgw2imDRhD0YqsNi7eafWzI1lRzaJ4EJjgR0X0z1A5db4+4ulr7WQnggJeGjf+hZGYnmp9HUvM+drY0gu4D+D0yRVyWyT1j4dlg9AdMnZf9q3eTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4514.namprd13.prod.outlook.com (2603:10b6:208:1c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 15:17:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:17:20 +0000
Date:   Wed, 1 Feb 2023 16:17:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 14/15] net/sched: taprio: mask off bits in
 gate mask that exceed number of TCs
Message-ID: <Y9qCejI/C13dQsuK@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-15-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-15-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfb8fdf-7b47-4e00-94d9-08db04676960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Edr/5Lk+pqJOcJJeCiupfM4/fo/9TEFd47J5HHCmU1Ox7I2kSBROdu+2EJ+E0QSSafCmvheWrAor9MtIf/P5jSUeu+7KLN+PPWAoJtTzZ5hG1zzsuDXGYykXdR4IsWvCTF5TG8WW1Hfd7NnliPgJU7xMCrCRchWd04FIh4VCcGNigaB4bkOHD8QkbHg5k2/CB4JOqQcVjShyL9/rK+zv2aILUFYzOv4RZ6Vzp522a11OSWn8CDWYiWB8ByV7kt1GGcN3pr1P/udmdcYRoDIhMVbtUsBkvs7nRRKY6VTMuiDSNB/53EYlrHa5cmZ/Jvru2YAXcZKyZ4leBdeTBgtjOmSHHH24qP7R/zFIGfe2dF6N47va5a/FEADgk/Aod9fXfDAv71e+NwmrNM4bgu6KL/8Ml54f5Hsf7CwU3586Gub7hyNFZ7tOhhABbrfoZjG+eoOkL4cQarPtpgSj5KAqUdkl2nCPqTNSWy9Aggyjfs3rO6XlPE+G6Q80WAbNvkpD0XMqj9m2DIprLXAhSzBppzjYnpM3wqcUS1rGPYJbkolGfFsgWjmcDeIsMnFjZ3dT0YXmuUngI0FzqieRrBo3ZIbY4I1dwuT9Uvvcf7YhKzFUKQa529TrGBu7deb0Bw1SFcgZbhl54bfi720LQIF8g9O2B3BRg4VlqCGa/6b9rMKnUL6PmoqvVDaec6/FtjU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(396003)(136003)(376002)(346002)(451199018)(7416002)(2616005)(316002)(54906003)(5660300002)(4326008)(41300700001)(2906002)(8676002)(8936002)(66476007)(66556008)(478600001)(6486002)(66946007)(6512007)(6916009)(6666004)(6506007)(186003)(83380400001)(38100700002)(44832011)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IVw4ydYWbc1c8q/H15xb/WbyoDHLqQ6nXMbavJwvr4e6D6iiKMDvvXvTrKhW?=
 =?us-ascii?Q?k1/MFHWV1acB1e3kM+2iaXsv42bdXSz4ioGhwEqr891ZujyjyWpSrU6LR6gi?=
 =?us-ascii?Q?cRyt/MMdX9CAs/EL28jTW00ZYOOl03caNWlQoGe6vay/qUIafj3XXeeLIASa?=
 =?us-ascii?Q?loP0J+gx3MkQ5YQjNoF5k+/GLNaM500EhWAShCBgt5QiBN1/P9eyYYnVcG3w?=
 =?us-ascii?Q?aqDOUGivjoSBvVfzamBDH1f/KbveO5UzdT0/ZAS8ZMbiHL73K7Hh4rp/OkwV?=
 =?us-ascii?Q?TGNtvKJvLyBgDk7EiBGZN26uSMZDa8TJeeikCkg1AUOa3eCL6tlMAXGpXy5V?=
 =?us-ascii?Q?rLYNkdZnRTme4nfUQ+rnDksY8+masodb4tqrtBsvPj0XpsQMIp78s6Ti0S+x?=
 =?us-ascii?Q?4TiemG4NieA/UxtBHgF1S987CxE9ea4onzsb89pRUy0UyJOysqM8c4unl80v?=
 =?us-ascii?Q?uzxcicooO30oAT31zPHY6VNpD+Hqe0k58GmJDqKZwMWrZeV2+f8wLK8R0y7S?=
 =?us-ascii?Q?fxPU7OYd6Yj7YiWwwvZRcaD07LP/mmV5o/mI2K2hW/jHxEAZaIWQ9AIrm5nh?=
 =?us-ascii?Q?yVaLPX9xJwXcC19ObZ4aXZpMPR9tweW/cFp43cKBhqtvwkqAKdEEqv14V+M1?=
 =?us-ascii?Q?RhEAqCCmAuMOD6lC1wCYoaM616kwZg0pplM3d8whfZYsvr1aWCBsNLlD0VZn?=
 =?us-ascii?Q?7l1HSeuBg0jeuG2MJfxcz6g8prduxdsFPbrmMM7xZXjoqLWkvoQNz9applA0?=
 =?us-ascii?Q?zaUY4n6VpwUvlWi1wPTUVibt4InPKK5SArjUty1EodoVM9KpVHAZJLOJMmIc?=
 =?us-ascii?Q?cCcy+pzPR1fBxY7mSakMe9W7jnPK3kmKMuXyqN76yfKu2hq4Ok0v9a3QG3kV?=
 =?us-ascii?Q?Sm5U1UEF5njxDMh7dWX1pLA5afi5F1p/dvq8xXzpnf7yP5MlCm/nSK0Jk+iq?=
 =?us-ascii?Q?cwN58N5cyVmCi5yHJFb8R/u3jV7bY0i/ZL6cU9bgzRRj+u0lle6Aou98Iiek?=
 =?us-ascii?Q?ykuSa8oszhHJzz7vSSTz7Os63RfgtsOZbyvIfbNoE+PdSyDuNHWtr0bJXAc4?=
 =?us-ascii?Q?xaoFpVM+qVXPAjE/UpcZOGBf3VD+AXNN036nApZiz0LYgFFaqVbP26HXRiDJ?=
 =?us-ascii?Q?uLIYaSOsxX3HRv8nH8X19A7B0TTv+NKc/WBWehC56C43CBluYF05jsPc5g1J?=
 =?us-ascii?Q?vLhWhmx6eqkms8jd1TMtyvZeorfe8UzRJbNfcjzf7Q4P0FTI80P2zqJ9R94P?=
 =?us-ascii?Q?0UOjVLVLLNZSUspsx4pkCqoq/1b/cOAmyu8yxquw87abCEXGH4OGQQtFQqRM?=
 =?us-ascii?Q?n5L9bq+tu4iTiUeTrGd05BN8fS4YtbaWSUwCyL0gWt6ZBJRWrUzBvioeEPxJ?=
 =?us-ascii?Q?hVugr6STsxOzBAYtNsu0V3Ry3n1IVLbJfa1FwPaW10Vdeqozt/dmjKktJDr+?=
 =?us-ascii?Q?l5e4vQjNkRJPl0JL8nOFVLVNUqWdKsEgsJhPXTH+Evzac6zg3IBuwSikRPZb?=
 =?us-ascii?Q?uFHPAT0x+5f5QnD8uKHg/aTSxCpBmBBF0DQZQYaBqWaaDNctVfF+ZhginQI/?=
 =?us-ascii?Q?BdtiC0Pmb1usjIfA1PKeRzkGoaCY3MH884Zw2XFMh4y6wrkP5uLBvvwxqUak?=
 =?us-ascii?Q?URoMXuaUyZ8RFldkEy9ktAu/r2YULUGnPsMcYXNuKcZxYQBqz4cbYYm07ndY?=
 =?us-ascii?Q?UUZcAg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfb8fdf-7b47-4e00-94d9-08db04676960
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:17:20.1025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLtQy+WkZpkYjUSzf6XfBYlpxgU1Ii4/QHANrrPVT7J29Dx4oEqvN1Heaz2GxR2YLxLawPyb4ZeMbg0GmpRhk0tMnn9AcGpCpWHTolEUWq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4514
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:44PM +0200, Vladimir Oltean wrote:
> "man tc-taprio" says:
> 
> | each gate state allows outgoing traffic for a subset (potentially
> | empty) of traffic classes.
> 
> So it makes sense to not allow gate actions to have bits set for traffic
> classes that exceed the number of TCs of the device (according to the
> mqprio configuration).
> 
> Validating precisely that would risk introducing breakage in commands
> that worked (because taprio ignores the upper bits). OTOH, the user may
> not immediately realize that taprio ignores the upper bits (may confuse
> the gate mask to be per TXQ rather than per TC). So at least warn to
> dmesg, mask off the excess bits and continue.
> 
> For this patch to work, we need to move the assignment of the mqprio
> queue configuration to the netdev above the parse_taprio_schedule()
> call, because we make use of netdev_get_num_tc().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

