Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD376C1BFA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjCTQi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjCTQie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:38:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4814D17154;
        Mon, 20 Mar 2023 09:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+Mql9h7x1E1f2vqIMTTKLEjks65lJSXsUtR3ttJKCT/uLJMRWIfUlavuIxck7xy+IZaXl6M0QwZRq1noeF1Oq3ei0Thj0sdGlr8WZdps9vlKSRV/H7KJM7SO2ITRWHgY8i/cXMx08YKax0KkNRFrcue1h64Wh9cVjGJBZwJ7XttmIApgptoppSW9wNTnE1hLxmXV2oeaKrTL5xER0ph6hxKREkR7JPI58hz+D/vyGZCl+6QD8dqLcdP154NALR2ZvOB8BQ8QkEZlZ7KJ06CNF5aptmbjILtvEKQEqHpL7e8KTceRaz4taAluI30XhRJi25rD5Zn9u00FwQo8e12Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmiQ7dnveB7EstV1nvdgEAojQI7eO+BI5Leikw72rX0=;
 b=czfPD87YrhJkwWDOQaJksbCG11/CHTNywiDwSyFXUahg9zb93cJsGqCnkC0DqUzjOikyuAnf8J1hL/3UQt5Uc0S97ejYMX8TrqoT4beFu01LTbI0mxaQt+ZW7YOWew+JpETOE+78OL/j8udhBS/lqPYRggVTEnnbTdcIw6N0hWkD1lKLhIchF4SX34OlCtP8TlPRWNS29y12tzFSQcf9sihGB5zJkiS/aiq3sqzKyMaJes6HGnch0sdUc6JGhkqN6e3taTckTtdvdLczICj3IJN+ViPCQn3cLRNwoJevqMa4rkht8g82mp6Ip4bMTZx4lTcaJtMLTdvnAd6cwqXcLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmiQ7dnveB7EstV1nvdgEAojQI7eO+BI5Leikw72rX0=;
 b=ClBKtpeD95xKrawIOoXfDK1E+c6HJWpYx1AfjLnN8HQk49/BgO0ESY61wb2DiwVvQKfVOMNnfIHj3smjZUsUdzazxDSQwH5OdE5TOo6NMvnEd92lBY7eOLwO0mvmJ7Odxrwa/eeFRvRZgjc/mLYRxQ1okJB7kYTPHATrs++JXds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4133.namprd13.prod.outlook.com (2603:10b6:208:26b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:33:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:33:02 +0000
Date:   Mon, 20 Mar 2023 17:32:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] smsc911x: only update stats when interface is
 up
Message-ID: <ZBiKuJZdpGHXGImm@corigine.com>
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
 <20230320092041.1656-2-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320092041.1656-2-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AM0PR07CA0030.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f5db10-3684-4851-af1c-08db2960c5e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+3Y5Eg1WYY3G8SQIvG+/zT/I7iCT+l5+yOfPc+EntVVv8h4J76xWSO9c4Y/xplfOxeVFGfOPAx5OwwjAn36blf/0DnfJ/dpDJjnC4m/1MjhopZ87p5WdEjQLuOWZVE6WdB/WpylodPen1Q2H2Jdp/z6RE2YicMawGf/D1cEGMkux6knh5fUAzmzTlE0YIQktGq+eZSTFQRvy+QQYCBPP0GLNYA2DPw/L9LgyMWDMqHe+HDmX0TT8sE86aL15vksoDeKSBaZXJ9YG7BwjxJHobPSDmgTnuqkA6/J2wU4uSopgHFrg0/OUzxY1K6okkGfIdGqEykS5AsSnBnSSgX7Y06KkUU0eavZdhNtFSi2UhZnurjUN0RPwjCYHdG9RRExusM4fkdIZBpwUYB2czcgqzXBllS9S9IsTKt98psefUbyJFHH+5wdCBeuPp+tP+eir3KyDbqRQ12Plp4+qeiI7jqpCRUH9GAARCLKBzUQbhBCu2nrAFyAcRgd+zz2J1CQsPuHdcYYPHTQqgu8NPmt3mwb/EAUSBjITDt/e7akSbyZjIaN1yWFDOcvPwFGyPg9SMpDajRzqas9dYSLKYtRenDdAPbKLItYujNazYCKp773j81aBYC2rUN9YGYGB2WzdzoXFs7T+oxpIo51V3u4fQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199018)(38100700002)(86362001)(316002)(54906003)(4744005)(8676002)(5660300002)(66476007)(66556008)(66946007)(36756003)(4326008)(7416002)(41300700001)(8936002)(44832011)(478600001)(2906002)(83380400001)(6666004)(2616005)(6506007)(6512007)(186003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EqJt0FtFg2GW4YkEFtV/VzrwpnE4mBLglJmT1l8lEd7RDA68Gtlo84Q073Na?=
 =?us-ascii?Q?bsToO2jBoPAY/Burm7rMlNiNn3h4+2LJWwD4XyNHFnyo3lGdePrru5Ar0M6L?=
 =?us-ascii?Q?qPe3vnAPAe2LwRAV0ADh57rUHS7CNrR2PkwZ7xNPuE0AQV0raDpuBdnsgvan?=
 =?us-ascii?Q?oJiskc7Ht1cTF9zF0PVk4RPgQZhDr9k5ezF+XWGDh1FPnTYvD4fKYPShPVbm?=
 =?us-ascii?Q?V77SDMZdxUvQAHqXyF3tSql+IsnR+eBIc0h/0viPRzGJ4sxZqJWgDGNowqY0?=
 =?us-ascii?Q?SqOHlVrzLXZQtdbPwYXgAFu/hHdqbro+uMRJ3G2hTgN9YaWLJ7Cpc8YR231f?=
 =?us-ascii?Q?QeHJlBE40pnf27//l6nMu6/8UbRSIn7RfUgu6i144W240S6VluUt2/fUojXQ?=
 =?us-ascii?Q?+U5FWDK4DdojVrI8L9QbcQGihJRzo1q/2NrpXnC5Yt5v+TnclTrH2CCKd9Ki?=
 =?us-ascii?Q?Ws9j7tl5tn5tSPevrK91U9+52tpaI9R3m2PTY1fsb7hq0fXk8rlVGLIZ7Dvp?=
 =?us-ascii?Q?rLo0u6DN9mLhXyYXL+J9fIWOHjucolszZHmJgWPKmN7k7+5B1YsGIsEfQtvm?=
 =?us-ascii?Q?0hP6+XRVxQTzCe/pF1WfxhX4LOUd4Rs+vx0LVqLSXgG28/UEIJ48qM5P8aUf?=
 =?us-ascii?Q?saVvg7/VvbadKY1SHHySONJegkmwoWXUNUDDXujOc9HhTvYEBnDMhZ+qboxz?=
 =?us-ascii?Q?Djqf6UdtijP3cn+UqyW71AfW7pvJdd3dWmI2VIFmMBX6O4CKm6m6LGWQJvEw?=
 =?us-ascii?Q?YDiNREv5nt9tpRYlNTB/CHNg+TeqxeUM/jxZ5EKMzqjGLMkc+vxxs/iJiFCV?=
 =?us-ascii?Q?7PX7i0HXXBUNkZXCB/qq4hhoE5MLZLm7LwM7162eX1vNXd+Xa5xZCrDKJKft?=
 =?us-ascii?Q?SYL4TfY4Irj1vEWFMoKdvsxEXPVeB10fl5nqHEmQ80n4B2SperphTwQ0wfYk?=
 =?us-ascii?Q?7BPKm1H/S+Mo6kNTdvf9Fiq+kDp6xznQTrNx4/H/KRERNi+6VyvsV3lFUAS9?=
 =?us-ascii?Q?qnFOiJr0wYBvC5wI9DDF0fqV1GWfJvBahXfofeKykhD0bZWlksqc/UXOt/tz?=
 =?us-ascii?Q?p6ensRq7iZkMPm2LTGuJbc3vMzHmZOakNnHpXpde4IFtAcDMRH6/U/JFbT82?=
 =?us-ascii?Q?ZLUsaw/Mjwl45p3uPQkzYngloCaDZYISG3mJ1ypJzjOE4Q3VcPUEmNoGYhqq?=
 =?us-ascii?Q?W6NFmFjzXrzDEy4ChUGAjSNyhSjLQ67EI10Gz2kVDAUhZpp1WizpHR3QuBXW?=
 =?us-ascii?Q?F07F5+t20MFrlpm2U4VfnMK54kpTVjAYRUcilSuxJe00d9ALJNZJ5054nFRo?=
 =?us-ascii?Q?wCn2QvfNTFf+iNmUvGYucVye2WbzlX4a71hgeUxGu2vC+PrNcu+04BDeO38O?=
 =?us-ascii?Q?A42lh/svpfAOj2ZvlEo0S4nkIx/TmASecI6hfw+ljAlj8TaQ5bxEN6V9BfEd?=
 =?us-ascii?Q?NYT2D2gvk0TUkDtQX4qglaxqWSaNHTFzcTzz0J4iZ2P3d81MnUSn4kDpzfGc?=
 =?us-ascii?Q?tRAjzt5uf6q91cpgvCa7cSgbAxl7yz1YuBGGaFupJvom7vS0pqhcHJXBqQb/?=
 =?us-ascii?Q?GPkSmIc6qeAyk63tEnJ+VrVLUAqqbu4kv798iXaNYyP5t00XFXYii2gZY39/?=
 =?us-ascii?Q?oZjYj8/9LmPrIzkdSQ9XKn3n00x0qMplSzQF9pKgPhIGDmOSCz6uj5LwTGEz?=
 =?us-ascii?Q?5so0ng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f5db10-3684-4851-af1c-08db2960c5e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:33:01.9143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF89W6RGFi0mMAF3s3o1jwlwopR/ycWoEADYI/p8gVQLrNzpeeBCo1y/0AAPSVUd4V6zqfSk9BsOLRPKyv44BZedJB0WG2R3QOl89eP9z0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4133
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:20:40AM +0100, Wolfram Sang wrote:
> Otherwise the clocks are not enabled and reading registers will BUG.
> 
> Fixes: 1e30b8d755b8 ("net: smsc911x: Make Runtime PM handling more fine-grained")
> Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

