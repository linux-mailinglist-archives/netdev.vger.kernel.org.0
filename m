Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB768A9CE
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjBDMrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDMry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:47:54 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972951F910;
        Sat,  4 Feb 2023 04:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJkqEZyjGaaANKWcbidDAW3alX2ZaGzJuvUBo2DcfX70edd63raT5r3kjrvPA6jL3oLvlKW7LEmqw6Oqf+YVzzmS2m0M9a/vFelrJ0P5c8/cJCmGXlh9nb9Pgba8wP/YmmhYUaIRBpCBV95N4up8AUYHTWKgZpr36blEwWHskOYKUWhUnVX6fPJZrNBq8sewURdV6r2v8amrk9pibm2tX5lts9pqJZQHLROHbqnz86NiNMjUAuj2KT4pXdZtmwR1qKxd3vpA7VDTFF6pAr2FMKzcLskT7T8d0xTb0VmVHqPCu0wFb6uo3gg31hz+clvyRs+thZx9XfrmY0COdIzPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRMlMxESP2ZySbxAHPqj3hdNPII9qDxoYuAhfao4f98=;
 b=XNTt7WF7wUORQcnd+M2ZFSR6nuA5z1Fdeoy58OGm/RnkaTH9/z4FNEENTDL9Keqy6jBhCbgW4yBgQ3d5jFJJNuqt/u7a9P1yGemOHQMe4VXb5jUvs8krxDIwixFGjONx081uHlFDJ3EwECKG+hYNHFycpr++b+LgdJ1Xbc2vp8uqPB10kJ3TQCBCecF6RlJeZh2cijKhdtHoWz2vLiLYnfHqwhYRPeXqvSH+JV2aOx18NnMIsTGg9mWWFoow1gTD7aN0R1SwV2UJxzDuuM/cQNcO/r2bpk+2PPpx0VssjDXVuEdluPzeb8RiBlS8pzy3m/sdpzw00rEzpxiig1HLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRMlMxESP2ZySbxAHPqj3hdNPII9qDxoYuAhfao4f98=;
 b=LHyioVGeBR4zuQkM88yGcYO3/kf8szLsM/KXFa+TyeU9lVOPmc5M1CahQ9lI5Su6ijh06QTm6c9nxe29g96Zvv0b0oCrRlfvDsv7BLzpXbIwPrY2afuwll8U/WoapbZUplcHqTg/2G0JDBB12GJh2B2C8yZfodnYvBZ6dHe0RJI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5454.namprd13.prod.outlook.com (2603:10b6:510:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 12:47:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:47:52 +0000
Date:   Sat, 4 Feb 2023 13:47:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 02/10] net: microchip: sparx5: add resource pools
Message-ID: <Y95T72Thcbgwk3mr@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-3-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-3-daniel.machon@microchip.com>
X-ClientProxiedBy: AM0PR06CA0085.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 6897384f-b940-4228-ca46-08db06ae072a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a/N9qnebVCmzbDQ6XcEeBhRT+s9fJuA5gF8MyGXDLDdoCMFENHO+/osFvceRPVzgzCd6AKAJ1X40gXlV3CWgY4vtjm0Wv2nsq0JB4HnqaPIo9Nme3trr2jBs2OFXq4LB3s5GerCRnXSUOI+1AHQO2Kq2kZ29Gj94oUIlQV22hwu9nZatq+EO360VccXg+BwaX6pWhm2upViuhsKAo+Uz9S0gouYTOpUZ3iYe8dLthyzyZ2iRvxyEwdu1uxa1LIz2YIpcikEZy/qDcrF8gt3NS9iDzJ3xYVCnAugLJHfNJc50ScyuPR3dV3TyP8+DT0un7dZbDgjYpPr/34L0mLhk8C3HScp6coSbqCVCxqikmiquj6UzzNHrxga9lDmvc66XaMS9HO1r8gBAqV6KPIdpSgqTC+O4jv/FF8qk0ZblONS721I1ME6koSA+TSoIHEg1T/c8Hc8MeNd5ZTvq8FNnpU8AvBGq7zPBls/0NpV2lkrvlr0V6CH1SfaEZdcL6SWQJO6z/DgzfMJjt1j5LA5KhFe3PHXpLkTTOteJqag6iAWCWShQBB/p26ZHLIkf8xA1FGDrHFU/11Zn+/z3mgf5ExJDF5ro2zvTiaSMn+2d8gL9h6+OB9GdFhuK6i0qLgerkESAc1JwsRZ1t1FcvWlxXxQNAiBcTBdR7LoCUPl2PFDROxrY+pWM9iPw1e0jBGsg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(136003)(346002)(366004)(396003)(451199018)(2616005)(6486002)(8936002)(478600001)(7416002)(41300700001)(6666004)(6512007)(186003)(5660300002)(6506007)(316002)(66476007)(6916009)(8676002)(4326008)(66946007)(83380400001)(66556008)(86362001)(36756003)(4744005)(44832011)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6/XWg67TN3vIHmk/qyUs12YVWEwTJEtbGl+e30jT/pbJ5e40qgk41QQgfykl?=
 =?us-ascii?Q?zWTm8wjNskDJS3hdPQip/OFqBhjdGuHXjeuFbD2Ld0WIJiHWnPeU1tF5+/0V?=
 =?us-ascii?Q?ARMmy69fz7yaVgrgcPiU/d32cvKiiIOvm/n/mesGRxg1HMSd7/hoZwkI0j7J?=
 =?us-ascii?Q?JlHj7ADOazI7oEpRt/MVvDLg6lFHLy28DPj7Ix7Iquwgy6Zb8dt9jM9EgHXn?=
 =?us-ascii?Q?7usQT1y90Hw359+rwzgm4hfQklzvvsS00havDdkMgY9vtCZ3wC6gXWk7bapk?=
 =?us-ascii?Q?3T7WexkoTr3WB0IY+0f9hyVxHdSomZ52w228KBuY8HcDxJMYoAoJBpqT0c8n?=
 =?us-ascii?Q?RUTDqCXwvZVfbvK5LzoxvyiyU7wMZtabtFpQiBoeoErtdrE5yVd8e7yJrygz?=
 =?us-ascii?Q?Uz6tmCJ3XmdEZpxRrmotFPyOKHJGmNWJfKtvr1orJoXYqs7affavXP24iucq?=
 =?us-ascii?Q?9/bNu0E2GtacxFhNJGal7b1bBhea5JCqt8X3VVVzccoDzCigCqqgpHUytrNG?=
 =?us-ascii?Q?mOV6GC1TtrwpMfKoV/g06Ul5Rd6k6rzwx7a9nvuEIu/GZ0S0dEg6BYu8GsE+?=
 =?us-ascii?Q?pKQ6LLTMzZGC6j/lX0jO7hT1hn15QCYkL+FL4HuyxHf3KnWXmIgfSzdyypDw?=
 =?us-ascii?Q?/MVAKxQmwGiUGTVGbJHL2CfPCP+vt37JT0vllqAF2LS3YRSbcZGKWUCBkyUZ?=
 =?us-ascii?Q?YZMkAFgXbMRpyI18tIsxHt8Hkd/+BdELDbKB/rwM6rXSF9E4aBoaG9ZSiNrN?=
 =?us-ascii?Q?M8TzCmaTOj7a1z1uCWfL0M8/1ze/Kl/QwFoe9KZ2zAnrqcyEeRNNl1X6bFWK?=
 =?us-ascii?Q?1DvMDBENA3HvWvXvVeqGYKNzQS4spN3v5GmfZp8TUHq9Ke5fNM3HU8d2jVPC?=
 =?us-ascii?Q?BkSU65ne7LuXsaq3jcLm9PwkXIRLvhdx2y0G0715x7Msn+jI8hLYkpKBfH7W?=
 =?us-ascii?Q?/6zbIZc2O3La+NLYzYQF6YFxEDGGF9X+osw6b3VzmjkYJmr++CN2oaAKyJC8?=
 =?us-ascii?Q?MuN0BjwSrBwu0EIZcv8S06jGNcGTJrkYxPfHut7uuQLUT5+A/ueRrWCguRyd?=
 =?us-ascii?Q?IztCYmu+hUrrJTy1uttf/lLSTJrOYihW6Hgqj42hvZoY04+jtG/bYsl968x2?=
 =?us-ascii?Q?zIZuoOTf8HNiqwg3dOuMsMz7VpEakcajtCMb7si3lYTVmbPurpySLYzCjg4Y?=
 =?us-ascii?Q?h83WLVi6VAHNm9kZuMUwjN8lI8wJPew/6n8HuHZKEKqI3Ul1Aa9FvLBFQuj2?=
 =?us-ascii?Q?K8p637HK+u8l6ROyXlE7MZO5a3cCTJijtr7Ai4tT2KSD0Vuh/m9mxgT4xrrn?=
 =?us-ascii?Q?989eVJ7ZQjk29ETs2sAg6upd71y2Okr+wTRqwufR9kQgIrG8EH9OcfQTtUO3?=
 =?us-ascii?Q?sRWimZPgjCegvfk11e7xiP7y3Q03PR4RMTyY4wNI8EVoXtG/rsKFcmcpg496?=
 =?us-ascii?Q?/gp6jpB/xc7K7tbV0vcpNZQOYfLHDgI+XvCG/SWRVdAxXy0XAa5/7RiSw/zR?=
 =?us-ascii?Q?+hLO1ajVDAmrnXIHWRSzvy9KnA6OPG8H7BdhvYTmki0Yk8u4Xj5rbwcHOh4L?=
 =?us-ascii?Q?n0nidZm+LWP8NoZg+4DYDsI2GTIO90QbhsFYp54wwl3z25jETb6H8mBOkxjT?=
 =?us-ascii?Q?ijmbiXu67mShpgwtF9lIX9AIARBunvGquhMA1pe3cUIduI366Rke2TwKK4nv?=
 =?us-ascii?Q?rJRMsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6897384f-b940-4228-ca46-08db06ae072a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:47:51.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XndRwurDuKVgTSIrTRPWuMBM1280es78lo+ty9m6GH4MQOFhe8QoCjkjBfARVrAIwKDE0QSMV8cbD6c7LaoG/3+aUQHmkFTo3yKFXkhKJgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5454
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:47AM +0100, Daniel Machon wrote:
> Add resource pools and accessor functions. These pools can be queried by
> the driver, whenever a finite resource is required. Some resources can
> be reused, in which case an index and a reference count is used to keep
> track of users.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

