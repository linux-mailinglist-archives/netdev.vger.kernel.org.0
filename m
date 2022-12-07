Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191E9645947
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLGLvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLGLve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:34 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2102.outbound.protection.outlook.com [40.107.92.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430C04FF9B;
        Wed,  7 Dec 2022 03:51:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWmYKToMB059JK5QxXYpwC0P7FKO8AA581pBrr4hfNlN8Jl0NXkZpRQf8iaYLgAyThOmDYFh88bA576DkZIh9CeqGHUUhJN5qEx3OXfimshDrgiywWxpYVxHwGhPsrHpqWjzMed0mnOYXuLG3u+cuA2cAJOWAGREDxnYg8VRezBslCmmHu5GAaC6EuCCmFlsIis01tw57mBXxJvpj7niNAy0wwbNxnEZGKbFksNsvTrf1th3zMF80KIHJXylcVpZ2hBoTT8DSrCBE6kUeaQnO/qVeVGLA1PDtt9bthohzza9y8EgKa9wiW2pklriwmhTTRmr2J5CAbNkT8jB98Tp8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJreNJUmAB5ziO0IkkJna+UqDqVgAO37LZKJiqVfLG4=;
 b=KzLAqgWpa43fNvZJGAaYs7VhBWGZJhJHh4gfVEwP1JHR5+EoGo16qG90e2W+7FiejAEgCCusyOnjHvf84fkVGT1xTxUdmB1y8I/zorbb8ccKgrsrai9BrtkGWcZK28mC99bJfU4vzul4rYdwuZRRyMwhqxGkjHBcOa/kzi4XGsHZpsi35HIkLBZuk45jBs+buSYEQtGdl1uBa9y5ZwY2ie4V8YcdfNY5EuPiV0PkQsU0kLLx3h/XwpWrrLGOPixm1KuaeuHtqXyKNE7w0j6eJtdSmEusR2ZBmVwL2xQVCyuFOFWsL/UJl5oFjMovveeXUFrBm4RleYxmYPkUpZhseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJreNJUmAB5ziO0IkkJna+UqDqVgAO37LZKJiqVfLG4=;
 b=Q44PCi6bZnzlF5Awechl8pBPBq/JW4rxc5giNZes/NmG2IuBIgiL5WVZI04DNknNLEOyChpry3SJskhbJo3VpclbpxkE0jwvMTdk+dbNHcJwwq429OS6ae2Rg8jrjD2oAbI7ZyPCrzsPzYnS9LhT5cafN+p3QG6xO74MVSI80EE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5042.namprd13.prod.outlook.com (2603:10b6:a03:366::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 11:51:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 11:51:19 +0000
Date:   Wed, 7 Dec 2022 12:51:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfrm: Fix spelling mistake "tyoe" -> "type"
Message-ID: <Y5B+Lo+xaKx71p+n@corigine.com>
References: <20221207091919.2278416-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207091919.2278416-1-colin.i.king@gmail.com>
X-ClientProxiedBy: AM0PR04CA0065.eurprd04.prod.outlook.com
 (2603:10a6:208:1::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 4952e2fc-3dca-439b-1303-08dad8495aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9jpspLVMaUpDAUDkuhKJOkLpwd0sEIiLTjrOwKCT4u52+F8fNOQJKbCQz9juJPcFAUHMaKcyUxDtGfqQYpL4V18/vRlQqSacs+C3gA81u7HE3f5KcEOPyMMobB0QH13izoyxY35d2f5eVtU9ttxGPCIGrMMSxUvKV9DZeoSryiZsb/9P1GcLZG7MNiy5toC2lPO/CAA/Niz4ivQvcn9uP8Gjxm2ZBFy8ijIonGnWSEsaQFfdF8tyFcNv09ON+7nIBngDZkDxnjDbPEBtjZYNmAmkxv9TwFf9SH17Ctw6md20qx5YfAc5QLQI2I9ksCp+xFBdrq1YgJPTXvc6K6CpjDgJqykGKrqJyBL2xvxx6vPJYqvAdFZWCvW0+++QZh6fNra5tV971Bo1QQ2dQbumadVHISGWUJmsgKHPPwnHigfBWi4iTSHnX+fscTJ+48AC3VvrThHxuhaSomOvvUpr7lNWzl8mtCoK8vW9ynG1GcZJ6UqlY6cFjZs8SvSDlbdPhWXd/AQBOFh0PRXrDlNISGuLy8dLGjlcj33cvXroTVvG2DNkNKRB1PNjx+//H/moiKy5wBSbyVfD8ME1wCLe/EmrcbuiU9l17q/14aRZbUD4NpunBjE5siW1Qc1/AHP2e/0KsFWrT4fmSUJYteJG4L/9amjnqlO/5GNHRkqdC9mWqs9sqeTYqCOJOKDuNKt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39840400004)(451199015)(36756003)(4326008)(86362001)(8936002)(66476007)(66556008)(2906002)(4744005)(66946007)(478600001)(41300700001)(8676002)(44832011)(38100700002)(83380400001)(54906003)(6916009)(316002)(6486002)(2616005)(966005)(5660300002)(186003)(6506007)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aaRGLKpvGMwXbK2N6vdLhTWzvMJg/K8OvoL4UIDcrGId25E96nqu5mmy19J2?=
 =?us-ascii?Q?qRd6cwfzI4yfzEEhspDXMZ8z5FJj7zJtGKapRULNlS13GlKwcNUH00Lt79XL?=
 =?us-ascii?Q?V0QNQWMmvcdUp4Wob92psIxlg3CDD4k+JsOx+nC+R18Ibc4yK2KnUSqHmslY?=
 =?us-ascii?Q?v9fgLXEds47nOlzIyLl9rdJyZ/agBQj+R9xfs+x5sFHuKbffCtH2yTXeN8dr?=
 =?us-ascii?Q?9jV84MlrqbtR3oTNKl1ywgqCOwYc7DvFNRnhsqAtAM0fpnjXJgud4Un9z245?=
 =?us-ascii?Q?XVWTHocUDb8fo14uxSrRYmjQa6HUL/43OkBeo6ZrhSFdDTiUCDE6S8cZLNWC?=
 =?us-ascii?Q?m1YJrzv8XqfagpHNAwZCBIVUnPiWfQH8KUuAsPpNNch5HKkKvGjxsz6Ivj5O?=
 =?us-ascii?Q?5FsbJ5Bcskcv61wo8U6qYMjGjCTwNzRtsAkvHvT1jV3izao6dWW/0Ae2o26+?=
 =?us-ascii?Q?je1Bd6GsCmGX9MisWBDi/6GfhO43nx88EV4G3ESFR0DXrqn5UJDEkWBwJFN0?=
 =?us-ascii?Q?sPvYS6F462WRRBJAGHHNVrvn0mcV+a5xVL4v0RG6B2/CbgGPnyP8A0vf5W6E?=
 =?us-ascii?Q?+LNW0jH86NGl3qsixljKtClTS15wI2c6vqer/Dv8t3e9uT9DW2co+JRw1STD?=
 =?us-ascii?Q?FEi1IwOtdwsmJIBd6B1sD+fitUUi51adWex8pjooCbM/3uDntWEpOsQhS4An?=
 =?us-ascii?Q?Z8nqyx6ONnCml9Yg+UhAsgmREoL506Kcyi/q1p/CDXVTWbOeuPB51zudQ9w+?=
 =?us-ascii?Q?xaE9QqR1SEwqgc7c3JAQukWkMk8sAv0ioScMlTEeQBotJGaIuH+GJT75MFEO?=
 =?us-ascii?Q?XVrW5+orNBJ4r8I17hsDuGFtkjsaV9mvQxRe45/ZRFrmdfalucDuphJNP4rL?=
 =?us-ascii?Q?GN3FQrO+2UtbKyvLr6Ra3xrAaESFQWGWuimO8hEFpgE5BFW4IT1VqcJLrO3x?=
 =?us-ascii?Q?B6sgIqW17MhGQn/GmJ8FTlzQLzGAPk3BSiEW827SBjdVEQddwtPKstFYS0Ne?=
 =?us-ascii?Q?98i9EehXph0AeSv7TqyfUFzdpkltIn7KQ89mNrCi95ZoFcqcUNWFUz6c2sMl?=
 =?us-ascii?Q?oM/Yb1RlTtnEFLYIheT1H4JCf0n4x5+Jpq5BuNHSgf7DccFAXARZY50PGMUM?=
 =?us-ascii?Q?0mcrurLEcvLAcbfpo84jIgonTPbDzyAMfC58pbbMZ7L+KRcXVhcFpRouDp1i?=
 =?us-ascii?Q?u65P93f6mWeIVigp7k2786YGpiGAm+PW+XPFxgkEvhzKGotNiw2wjqI1Va20?=
 =?us-ascii?Q?FkGUvixapDevrN009g44/OWJO2cpBatDulx1bD6xnLHIfW6H0UQjeDdN4QBH?=
 =?us-ascii?Q?gky69aCqxpYC+bAq2zlbUy7rikZOJ3j1F/TX5PLyR3uy5NVi6eiZbTskMib7?=
 =?us-ascii?Q?vc1HVSAhrk699WfgqnuFrHLXwRGgXmf1fk9VvjEobwGC9D7zQZcerJW+IWQb?=
 =?us-ascii?Q?Wxsv0xHF4TAT1Bf9JUGCKZcjm4fpBzmWmy4r9Px/1+bXydUp4UHIQAI/48BW?=
 =?us-ascii?Q?0vCtKJE7C5QMZr+RE9z22t5alZ2yay95EBHS4Mya0rIogbLc8SRwTXZnocna?=
 =?us-ascii?Q?KDVx99avFm3VdiBUIZ6G/3wEGwR5M7k/96aTcIQgIdH/9xFAYCkxcpVljJfm?=
 =?us-ascii?Q?8F6453AxMcXiL657x/zVxQcS/18jDCxRMqZLmWZy/MsZ29KXRkcNep6lrgX4?=
 =?us-ascii?Q?qQD7PA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4952e2fc-3dca-439b-1303-08dad8495aaf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 11:51:19.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNowr2uH7EKa1JlkN2AqQAg9/b19Xf4Lcx2qJQlN9ySx1kf9b6t77wljtdYJL21xjCNpLVBaH767ARC+/7pQuWUjLGWU6LnBG9dSvKnRvqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5042
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:19:19AM +0000, Colin Ian King wrote:
> [Some people who received this message don't often get email from colin.i.king@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> There is a spelling mistake in a nn_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Hi Colin,

Thanks for fixing this.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
