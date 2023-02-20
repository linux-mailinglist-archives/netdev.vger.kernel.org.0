Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8577969C728
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjBTJBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjBTJBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:01:34 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2112.outbound.protection.outlook.com [40.107.101.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D096C155
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 01:01:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2jXzAjc9d5WIkJU4uL6sgHce5bZ8o2NJUjphg4iK8eKGnEmSuJzVHNnPFS7ZnVma/rwof3H3ovXCZ/Rn3ImlEwIW+4rLNJBXI7/RjEN8h2Ud05vwe/o8+Q6ETOXgFYR2YA7oFaXlh+jXkpsQFEekwO6mBX5nEOUXQWdEWcMAJzRUK5BKAnOH8vZ+lHHeT0J3meaWcm4WW4hqzMSNOrzbXW2FTeqECvrpztmIj1y2Gyh86BtG3UEglHvWYzk/KENzQ06spTrXsNMiYBrmi8cgmOE0V2GWGoee0PXPVHCsMBr37fuokkaCkRBgvr0A6p1+5fW1TEJteFv9AvEdkY4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMz+o0/wHyuorJjgNTifHiTy7jtVbEuYFFWKZ0PSllA=;
 b=HhakgZNM33p/pwIL14yqX59PQc5HtRbi93NZq/05cANzzzQionm1SgpQbhjPJd8wdQ/iTHjsVrRyvJkQxltLcAOijXBlZSu2immxG+snx4LNVzuXNa6gGBw7e9Bl7e518/lBV7oyPdwIM2i5v4tHkNtalljW2KK1ZHjX/lCx5buLWKh/7m/eEA46OQukbQLR9PwY2aoI4FX1xhFESkgWr6QPXDXqEA19NJMCsFSIT9DH+82bmW2AIxv+SIEoGRWaCXIryiswECy7Ikl4i8tjsFh7cPwDkMmE7P2YyMv/hz7vXFpczVeIWN+pgTifCcxHEyPBszKmnf7fW3YF3XdKWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMz+o0/wHyuorJjgNTifHiTy7jtVbEuYFFWKZ0PSllA=;
 b=PieTz4E66FFClRdkduTygeqgu8qVxIslJueDLzuX/kzreCB+y72bHFZTYzms/XosBZN0LZjiv6UydgBQ0Z4G7guXjwfUQfnwvCl/B5xIe5QDgwtxpdT3Iwli8+ddJGSA1eVMZFHd2a0feyuXQlqatPvMefXYqlQM+1mt9peiRU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3629.namprd13.prod.outlook.com (2603:10b6:208:1e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 09:01:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 09:01:23 +0000
Date:   Mon, 20 Feb 2023 10:01:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v2] devlink: don't allow to change net namespace
 for FW_ACTIVATE reload action
Message-ID: <Y/M23e0tJtfVhSNI@corigine.com>
References: <20230213115836.3404039-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213115836.3404039-1-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR02CA0190.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3629:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9054cb-a39a-41c3-418e-08db13210a96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ocZ1ibLv3jEzGJx9rqbwFpy6mNpMLpFYNhU/KpfC8HZzcGMpmTGOMjZokE/ES51VEyaYiSurDeZGYJuWS8z6u588ruz/oeHqykXlw8Rxd4qjFw+M5PmXVaE5nOhod62Ny84RJPeYYr01yDfMa65T5scY02qOMbShzvo++RVW99K8dPG3ywEPzwhP5553HoaaNahZHoSFzb3+0oZuFVMcUMHxSMsmWKy82IRw/PfZ81AstlPufTh5W4LbYRNXcqh5tJFsye+rPywT7DGqL5p94xMW+VYWYXC1dd3aZkREjGUvYCJdAh0rlbA6q4J3otXqAHO2M+W1GVxHwFNOhq8FovmkavgErC35e/YYqt/90uPIGpWADHFYCRiY73bRlP8OFQyeXzslcaCtB6wILfRH5p8mWuoA9rHghAA/kAUu3V9p19CRPJvcrvvVaIakmEPzWOs7X7f15NlSNECi7Fo4ZdmbBLI1wJ+Bdy2CA9cmfRpyGX61/RX1tYndi417Z/5MZxTsB0wHHbFBcTKN2rUYVQ1y0sV1P0Wd9EBlYL5Sz8lLMaU/uSp93TcBSNGHoY02pxBMaEvshexqFKc22cIIwpVHprdzDRerGnKThuOGhtwYBNMcdqIpktC6x9mJHITXf1c0rDgb8yWJChrDzR9DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(346002)(376002)(366004)(451199018)(8936002)(2616005)(5660300002)(4326008)(6916009)(8676002)(66476007)(66946007)(86362001)(66556008)(36756003)(83380400001)(316002)(478600001)(6486002)(41300700001)(186003)(6512007)(2906002)(38100700002)(6506007)(44832011)(6666004)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v9EDS4dUmcZlJruVMoVin8YaqE1+NQmQzOApm1dh6YdA8hbWjjkpwLRpn7PV?=
 =?us-ascii?Q?wO1cg1uMUK1sCEvrMpQ/oqHRzd3VrswHSpa9x+WmOx32NehH4rcDftJ1vvYB?=
 =?us-ascii?Q?0hgnoZjrOAShetItwz/8YogdKTZUCbkE4AkPNDXJY7uINr6dgBv8ucuY6nsS?=
 =?us-ascii?Q?/HSk2Ab1fwktFK94lBlqkyFeyoS96EbhbRpDUDLToa3lUrXXBCMzHSOurXXP?=
 =?us-ascii?Q?ZdkN6xknH2+PNmSGNJkquju5o+YK7yopaDOLtf4T8Q7gSzPJVyD1XujnHogY?=
 =?us-ascii?Q?AsvpIr8n6J86aiT3PQwIXyoA6gojf9QqaiS9YhAU9bEot1bXXYjGOi2HRfBG?=
 =?us-ascii?Q?ilZcCfkwBnZG7m0X/Io3FxPS6EfKzGaBDJh46Cw6G0/MvbKR7CFyY12POzJk?=
 =?us-ascii?Q?a25YtDOlanA9WeSUhjTG75cHpXB6pk2T6Gg5BTkv0ZOJ0PpwlQiZp9fbvvko?=
 =?us-ascii?Q?n6Jqs0COXsOjU4t1zybP+bxizcB7XNXxDL5p8TkATzaexqd42Qa4oDq4HSsR?=
 =?us-ascii?Q?2qixzyQaMfyYg7I4jneaeiL0b9VapU+FIiqb0KqTytl1KJmd2Zs8TR2EK8aO?=
 =?us-ascii?Q?jcZHrvOuwe85aZQZ4cOvWwkDdaTeeMUo9TNzMlP2SFCAu2RHjVAYwL+TklA3?=
 =?us-ascii?Q?c2TAtRGt/G9sdpo0bkM0hTOes8L45RDMFxAbWogreeBdVgwAF+6y0fpzOb86?=
 =?us-ascii?Q?l6AfJW/4nhIo4V5Efyarw65nOeHUzW7VjOxffdXEpnpZsXc3hjmeTpr2Yv++?=
 =?us-ascii?Q?X1qoDABCFEEcM2S8301tOrWzfFDu2TsDzxMcpSQ+ziSZUsayYdgnubQ9yEs1?=
 =?us-ascii?Q?AyHjnht7cUPgyX9dKfJYyvS6WHkc7FKoFxjWFvVuqTQJY0TdSMhGvWT+L148?=
 =?us-ascii?Q?0vn2rZKdDFVbsNzdRbHXxRJASrdRAa8q0JO/d9xelms/7V841oqsfRTmMYYB?=
 =?us-ascii?Q?PRt/VEdUlnjBRMLR1LZzoD4OWTZGrC9JgAV6KZ+XhiN/js3lSI1+/xDO1T/L?=
 =?us-ascii?Q?5Sv4RpYLgn4/Z88Ni8LwQFdqYGjTnmvJOsdCK3vwYR6Yg5DJMHw6V/qR5tfF?=
 =?us-ascii?Q?GPJghfVBS2QSNyskpvSqkGIj7W63JtKLw7AivelE86UOvSh224Prcfulm9Lw?=
 =?us-ascii?Q?DSfnDucOPvDQt2hTe+nfHsxUpG+JARNlB4ivD30UYnVBVq+SqEq1PLaR9oCY?=
 =?us-ascii?Q?uHZUzfB9Ozp+10xGM6ndn9o9TE6hEFp+NZyE/PEWhA8+qymxJzVFwEjIrvGU?=
 =?us-ascii?Q?0rzuSxAuat2b/iUx0mnDGAR5tEJQ0vsx/ETJcnqE/sOObfqTwj7N7q9BDpcW?=
 =?us-ascii?Q?A/Tkn/JpMyXP/ceheovpu7QRFFYlAqrLOb8AtZ4X9rVtoCF/tXzkO/W0/QLq?=
 =?us-ascii?Q?REUp6K/wEbIjIR0k5wYhX75KDEoVoA+d94lOqs64++fstYzJdQ5HyWIH9aVq?=
 =?us-ascii?Q?anoC/Vmn2+iF1zgz/5KbqgxHzJsn0CBDvGy715RT0zwfgbmkSCtI5HFjK202?=
 =?us-ascii?Q?p1JKLQ9ykmi5/AoC+4ZenqbU4vk049sM40ta/BGuSwhAd+KVpPKBVRmb9gq+?=
 =?us-ascii?Q?ZesR3WJCcJrfrkck79gPcVlJdWPPtnNhbY0k7BxOZC48DzuKSzczqUQJdvzQ?=
 =?us-ascii?Q?JQicJC9hSZpeeTysiN3/zCE79HGa+VgwyJxc2Elwx51nMYZHcEqDIBsfU6WP?=
 =?us-ascii?Q?9gqrug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9054cb-a39a-41c3-418e-08db13210a96
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 09:01:23.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BRA8xbmQpOStW/uGZMhaNuwiymW1evVQP4n07fS85BuZY4FTBzgI8pgAyp93c36ulxTCJjBfsnA37aNEARaMHaX0gOVADl11YUQlK2Al64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 12:58:36PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The change on network namespace only makes sense during re-init reload
> action. For FW activation it is not applicable. So check if user passed
> an ATTR indicating network namespace change request and forbid it.
> 
> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> Sending to net-next as this is not actually fixing any real bug,
> it just adds a forgotten check.
> ---
> v1->v2:
> - don't fail in case the user requests change to the current namespace

Thanks for fixing my feedback on v1 and sorry for not
reviewing v2 earlier - I was taking a break last week.

For the record, and I know the patch has already been accepted,
this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
