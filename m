Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB16F6293F1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiKOJL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiKOJLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2095.outbound.protection.outlook.com [40.107.243.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB18220C9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEBhYrXwe85USM2y60ueTMePG3vDwr+vmBNqzpdcqxo4tHgZd+UD1RoioP9TRfJyryhFtGjC0e2EiUt37E0/LBVEyyYRd+TRvA5mslRzzHwTK3hn57fMAiXIqHfld/bBx7YaNDM4cPQnWS7XMvWCp8t778AuCKJyJQbN2zqn53L8KqvHg1gQ1OREcT7z1mtaFXCkpcsU7BGB4PrTKhjc5uwKbtmakHtAkiDldKeMQ60Mp5KCjHpO9fE9YHK+N0RdOcV44zaC61E5Ezs8X03iEOETNfTC/oBu3WfWRP9PMybSz5Hs/PwQpfLVL8PsNe7B4jGocDrAHRVAZnXzzPIMnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOoAHTlFEDFfKZD0Slb0jew3EvDTKhAoHZ6HAxjUS88=;
 b=QDER+VyvjvSwBychQZVqkR9KuwTBaZlFydq+6RlHXAFnzP771VaDJ31D4X5+ta8ndItmoFkwJhFDPHR1ByJ1QlDmIa4dQjPk79otd/dl30EfxLsFwflM4bo0zeLiXdz2Spm1KEtqssaYYlwk9T0TRDh0JS340QBwqs3leNvhBrgtEq7Lx2ghKVgHNleQyTaKjxx6SmCj2+gCREzwjUySI1dfo9C5ahA56md4SIX+G/kH0bT/PSoACb4/IT9r1METmf+02gkT1KeRWlLzpXwqgxeB71F+XSfJGxcRktsZpaETjhkZD42XnWTE8kXewrNdRwN8Rek2QgoDliIuRkCNZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOoAHTlFEDFfKZD0Slb0jew3EvDTKhAoHZ6HAxjUS88=;
 b=B7f/JqgxysfM/PmTodPmht+chyPNNLXVe4srP4omcTD2ImIP6MCoLuA0eN/U87YFDVTHKPeMJvn7xq9cLYzj8suP3YmWLZtbnjHK/NHIPi8JiI4CLRK5Clm7SzShTQ7u7Ks0siD4dPippGoYy9/BLbJeUEFH51FSVOHnJOuw/Cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3734.namprd13.prod.outlook.com (2603:10b6:610:9b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 09:11:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 09:11:09 +0000
Date:   Tue, 15 Nov 2022 10:11:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next v2] Documentation: nfp: update documentation
Message-ID: <Y3NXp2FQ249zFlLs@corigine.com>
References: <20221114150129.25843-1-simon.horman@corigine.com>
 <Y3NS5x8VcIUWd2qZ@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3NS5x8VcIUWd2qZ@unreal>
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3734:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d72df2b-ddd2-4bca-6a5f-08dac6e955e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJHoNWVS8XxZswgcenCD+2ULlj2xfljEBYxG8+p/EKGIQ/QoyBsos1xj+mZ6LLw9Osa4v9IyFDy+FRyH+3i4ZDn8f655tR7DQncliHN71tuTAsuiAjwjcrMmEl49QbAMwHuGiTYZWNLOtwMlOzlAOiGnzSk0p/8Ztpy/vix/+vWHXkTkhdMQYhrLPFzBMEZTin7vag4B/0s+ZQvVu5vK1k/0aDFBaRPD9OaOq2q4bsnLfB8tvzKK8rg5j5+0zAg3ySDlp4BtbNzzjOSGjtZK0HkNr6sHMPWbhrMoB3s+gE0EsjmE96lwFElxU2BJEUaFQgQkiP/iUAj9nWBvOiVlBnUEV7DoI7vniD4pDo0Nj1uyJRT7GaNrH3vrGwtyOH7eDjeyoOp+/WEqPJsv+PeS+N/X9AAfLcYyA7K51j+PSh5iDJOwEUGpitOWCTs0/Rll/T6Pg/4AibhTQvKrT9h3u8ZTEpRd8RRrvcKdjTEsqQccieJRHkGpTYKINH4Ib5PxA/6sL4w07V/N1fJDldPrb+3Z2U8GXU7TKOqAFE/kJ9E4tg4bxGmSL+BC/kp9AszNxlPL0SgIkj5IsFfL6Qm0rHcJAIJa7hymktDFnM+QLXifE3UKJVrllXXr2eGVs7QzWG05WZtdWVOOOVwVmCLcj8MX8HIJ2byy9lW1O0AfSW71WiznApfEjgwUEcassu9V4TMLe//WVOOcCoqH48uf2qMv/rbyiKeUcF2ZXMqdQcw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(366004)(39830400003)(451199015)(54906003)(4744005)(8936002)(15650500001)(5660300002)(66476007)(8676002)(66556008)(41300700001)(44832011)(66946007)(4326008)(38100700002)(316002)(6486002)(6916009)(966005)(478600001)(36756003)(6666004)(6512007)(6506007)(86362001)(107886003)(2616005)(186003)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EQptuQK+oD3AboB+gmwH22JUZVaIKOrRtyRnF+KQF0vDZRzFN3jE0u9IcIww?=
 =?us-ascii?Q?vA5LwDEUXQzfP2VF82SlOk07By2fUT26NClzxtYRF8aUtrhYTJgbV5ZeH9j2?=
 =?us-ascii?Q?T3IFo2OItlSxmH9oBwfT89JHA+qZ6+TMKr6pMMDDoZaoo718gDXPldoa2aq1?=
 =?us-ascii?Q?5F1SQLViP/vTluzO/SAInp1ueLqStA6Dg4oM6WzfcaxyXwsShAuGoI8FF1Zx?=
 =?us-ascii?Q?uTRKzsDCyxLdCk6HYy33SeqcIPwkw+ywPWNysFrOTSWHnUFXO8wbo218JAnW?=
 =?us-ascii?Q?El9iuaKlUQCnBZmF6ucijOqUSIFH94D+0MFSLpMK3ZZbiRAZawS6ZQY4FVIz?=
 =?us-ascii?Q?CNeZYcqZ/qcBxRpLu1f52yf5AqlDvn5UAn10vYDFwnfszo8Ywn7Ubi0qwqi7?=
 =?us-ascii?Q?015sA7BnIx1T6wxp8EVQxgC3obluZJRSeqqH6hYxGPFcFUwET94TPvfG9aRE?=
 =?us-ascii?Q?+Uu3HFS6Wm6VlDdNfOd6nMmfv78W5VOeg6cHploIbAEUUq5yp/vrKx6WiHYz?=
 =?us-ascii?Q?x4yK/1586k8cljuwTyGNisZrhqMYu99LRfu3LFUEnfUTM8bK+fT9l+Ae4EKd?=
 =?us-ascii?Q?yRnBPOrfC9wusCHdZ9vmCQ8ncElzrQp2rykAfQQ8VjlBJDA/nCVqxtiHfjC4?=
 =?us-ascii?Q?JMM7g5Ir8knmI5yYymFqmWzfs/2Bt0NCOxCUl5pfLR0Dia89G1w/Sl8Bl+mr?=
 =?us-ascii?Q?P1Eg1w4ZCX1Pl6wjyKgGd+dGLXnp3juiF7ZzuWhDrOs3cm2TVM0vgytuL1i+?=
 =?us-ascii?Q?lTJiZmI9yIPS6LGgMgxJ9d3k0nhaS7hCRLaOkGQyppzS5gpE4GmZbII3EyBA?=
 =?us-ascii?Q?y0sOgxKk+VYWcuT/s/S3ootsCPNO7/0D3glf1qsWbphSt+IlJ2hS31G/iRoq?=
 =?us-ascii?Q?asi0i7rW+2EwUtJxBlmZ4FjD3EvBRHnvToCUcfvTvKot6KzzrKv6/BxupIMb?=
 =?us-ascii?Q?mXck5Ha5k+P7wNv8E8XJwo09Nof9rdMSVrl1TO4KGvVy0o/Zd9paHPkCMUXP?=
 =?us-ascii?Q?futiLnTjuWkh6WQyPKnVOvbl3YEQlxB+zNl2/FASrxSX8D9RHw0pl5FBxd4A?=
 =?us-ascii?Q?wmFQfFpSpdoDWnjxi8LjTbIK/x9foY9rFlMM/t2hpr0DQbviKP3PkO/FmVUY?=
 =?us-ascii?Q?2C8MWnHi4nxa1zKNgX/3AEHua2H38hVFIaN4e34xyBlnXjgIcFiD4EOyrO1w?=
 =?us-ascii?Q?jiE1xklBVGFmKXkZGrU68IazJkHLAgOcd53gfVdkc4I14NZIaiqlfKcIYuf1?=
 =?us-ascii?Q?4SrIcJvi4WNsFgJJCjC+crnDeEFR78eksS7kvrP24q1XEhYFe0r89y5wUI2c?=
 =?us-ascii?Q?sya5+6vt68C2evhrdrO7lYWtrwCDzP92G1miHYa3bfSAxDeaUKA/xjAnw5nA?=
 =?us-ascii?Q?c8hyOSNpYqE8qfmuS2wFDlycMqxM4djSKESw3DlAIBiw1UjLCoc8GvlfqOFO?=
 =?us-ascii?Q?RQrdvKZ6UlEtXvZDA+FWsbeHte/MQakWprNAOImgdnEPm2ncm5ftPEUyALKa?=
 =?us-ascii?Q?Ndf3Jsza1lIUrHmuBVFyqQH1LloOxWHq6RYQfasA6ImtQMBJIIyKhJmG5qy7?=
 =?us-ascii?Q?ei/m+75kVsAhjJULNkugXyqqvI86sYqmNDppRqGQtrCMGBXTAFmV0C8VIl41?=
 =?us-ascii?Q?1Vx59144kdBGj6fRi4nNKF7IWhua9w4NGvCKTyJ413XGjFEDfSzsspFkYfJ3?=
 =?us-ascii?Q?d6itoQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d72df2b-ddd2-4bca-6a5f-08dac6e955e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 09:11:09.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwsKTQbv/9EYnlVtWSn+FHJ1s8tLe4hVSE/8oxoJhjAL73L8qBVnUoBcIKt2a/Bh+wEU01451F4w6eMfX0XxcFLILWJvfLXDrHQ3uAqRb9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3734
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:50:47AM +0200, Leon Romanovsky wrote:
> On Mon, Nov 14, 2022 at 04:01:29PM +0100, Simon Horman wrote:
> > From: Walter Heymans <walter.heymans@corigine.com>
> > 
> > The NFP documentation is updated to include information about Corigine,
> > and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
> > with new information about where to find firmware.
> > 
> > Two new sections are added to expand the coverage of the documentation.
> > The new sections include:
> > - Devlink Info
> > - Configure Device
> > 
> > v2
> > * Add missing include of isonum.txt for unicode macro |copy|
> 
> Please put changelog after --- trailers. It doesn't belong to commit
> message.

Thanks Leon,

fixed on v3.

* https://lore.kernel.org/netdev/20221115090834.738645-1-simon.horman@corigine.com/
