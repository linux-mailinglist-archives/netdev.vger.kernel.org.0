Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761BF68B2F4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 01:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBFABw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 19:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBFABv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 19:01:51 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2078.outbound.protection.outlook.com [40.107.8.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DB015CB7;
        Sun,  5 Feb 2023 16:01:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTHinPi5rXiM3LmbnjIoFEpf3djg7PtCzBw2fIdMM1b6BThT2UiaV0s8w4p7qdU1QTG3WTtw9xbxGsPIHWY3/w3MJFgUDt/oYCWl76wQr3kyHQwSWR39kPHDsBtaEc+pAZgXvNErFJdvtufM2VB5URMIR2J01rGbNa+knOrVThyubepc4Za1RAg3Theoy+M7FAiF740EJGirAf77h3KYVBi7tuFQpme1Fk0sFMNHBL9uw8DldNoiULV7YNFQz2n+Ys5Sy16RGR5UqjxtThYH7piQJlwnko5Hw1tAcNEaxXTgq4d7qWLsZQGQoRbu7vJIPJLEANbB0kjTB91MFKH4ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4p+PgKsLoWygLkKxNwnJoy5CevdGD/B9nRiVVRHonc=;
 b=UtwOQBZEWonQTTx+kCWtqD5BF+b49qGTUwig9AfJSmmII3RcKEaWqUwgMqtk2tWLCVPW5HjoncSPHjUHFNf0Y62iVOz7HEeO1z2t1o/Sh1TSuzthsqsdp9cGsTVodlJr3Zyb6J+ZdP1ETkm0oKt+J2LQdBak3pamF1A6CAcIfNTE2Lg9Fdek4/8HTbHnmaFZ07oGJaYfNZSjWVRN2wi9TlztOS3wH5/X7MHUAspOqZPaYKBs62idRDLJZUJgSTqgeDczjYZew5LmIQcA+PQck76/VzLLk3aVkOtChWZ+C8SX/5GEO1QGx4cLy9/Aa2LjVUGGgM6oyPwmzQ+03nOU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4p+PgKsLoWygLkKxNwnJoy5CevdGD/B9nRiVVRHonc=;
 b=RdlMSh1oER+VGGmGpBWYPytc7HOKuCMnkhCKGVN37uPXTp20BiyGX7BVKokoVi1rOa8/dBAJqxF0+6TjWYr/a6p8SmRAJYm2AFMt9vm2WuYG1S4nn9XaAKKdWZ1nlvbMDSth23uEwIyIN8ygrEynTHK2D7/9gzQPc3AkWF5RQKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9660.eurprd04.prod.outlook.com (2603:10a6:10:31b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Mon, 6 Feb
 2023 00:01:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 00:01:47 +0000
Date:   Mon, 6 Feb 2023 02:01:44 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v2 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
Message-ID: <20230206000144.u7jdlbhaususag4i@skbuf>
References: <20230204182056.25502-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204182056.25502-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9660:EE_
X-MS-Office365-Filtering-Correlation-Id: f84c0281-5689-44ca-0a8e-08db07d556ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCpzdRENxXZAkenBCjZRwrBUFha42+dCuTbPjXYzetfJgo7k+LjBqwQCkIQgBfszUK3scXXlIJK7vCZOcuPH8gxpfGB+W3G4RGeH6PHVc107tCIoBiwuhnrqcjLFeHj4FMHZzdGigb8u0YbLH4sXh7Abb0WbxnkzryMdVTQqVwuR3f41iH+HR7IDVRf2ls4ecy1WYtwYXyuQST/do130B+hSJLoIg6DYpTK6IozZhLvnqA/ARntbz5rkZV42fZYWiKCLcS74cBkUfXuaojYGLl3R+IBDTtbGilrBwzUuQ+XcziVAvMN+9/zJrGMYeqLdmyZLk6dN5i12o7YVzxPhNgU7e5JoZMg4rR2foh9yqVNhEHgowBm4PS7ZaMDUuuj34KqyU4ARt7lzGox/pEFL/EfNyxukQyW8B+eISa/UOhDtLUcMuxX1qRFpEmhRC9p0IjhmEaygZ/X/ClNyqUieSgHWYrvfB+Y75d1J/sYXbSOciAx/saIzdRmQoAJixSoxlRvjsg8+vrsd5BBWi8HoA8dftPKWHXFR7pyOJd8FcWP4dWKrnBCarAAfCzL8ejDoMHeHckMjwAp9Iv+fKJa02qt4lpE8YhL1Pyi4DRRQlC8IdoFNk8vB+UDOEFcF/txRvSm9XnP/y3bkS2DkPhnEsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(86362001)(8676002)(38100700002)(41300700001)(8936002)(66556008)(6916009)(316002)(4326008)(66476007)(54906003)(1076003)(66946007)(7416002)(44832011)(33716001)(186003)(6666004)(478600001)(6512007)(26005)(6486002)(4744005)(2906002)(5660300002)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vAqZOGpxihMX3SAl4rRiAJJijydZZ0NMfME6iWX2/01fdux38ueZcUTyekyk?=
 =?us-ascii?Q?nOauQ3U6cipKrPN/juMl7u7xcoSu9hNOeS8nPZHIE47C2ihXsx9UTp4kNGeC?=
 =?us-ascii?Q?ubAxisjbWCxY5gWcFgnlHjj6fsnaCDigDmTZO80sNK4hAU4U8cSufVfK67/J?=
 =?us-ascii?Q?HU9Ng+OLy7n31lAksfmPapcSrbZzXAsR/HeNXDCFrCEP9PHGmmBfmUEwyGi9?=
 =?us-ascii?Q?13/lEHrRPhzBRaCZ7u2foQXSfYCo+/CGgbDS8oYM/7XzjiUPhj3SNHklNt+I?=
 =?us-ascii?Q?v1Hxqpdetb6gC1yaWSL+xjp1nJAHP8Z1Ep6/16Nmmk5fJP7notM3R1sXCGHQ?=
 =?us-ascii?Q?TFjQDRMeiLDtoPih8GtF2xdP3ItlGWuVd9e/IWiH77LyvmpnTbinbaX35sT8?=
 =?us-ascii?Q?ZWRVJ/lVkV1PZx4be+7iggUu1Q+Y/df72wh7oglHGaLaeLYkUJZyiNFJktcQ?=
 =?us-ascii?Q?a9xvinfjBhoalfoh5SoQhahxtSiawQJXGhgTXKhHvohf4ouQex3Vfi2oW6vT?=
 =?us-ascii?Q?4N4I86GKK10qW09dBb0SdUdspFDBODHFOkSUQSZtPPZBbIXWcFdQm7UK5Kuc?=
 =?us-ascii?Q?DwGiANfTXYAL1a7+fkRkvA389JfjvUQmvux6DReY1xIATrMH9ViU+iN4OC/O?=
 =?us-ascii?Q?FLV0jxhspUc0ECHFvjcyW2YQKPHieZlz+wyInZXYaRoqfAtWg+zjplEwavdb?=
 =?us-ascii?Q?WP2Drw239nKbASeGW+yqVgdmMNfyFWFLkNJ4nzmBNy8D7aTBQ7jmWstLFC08?=
 =?us-ascii?Q?2qi/n+9BTTh/zBhSJ7NIL5xm9ECEdVE3DFhiAfwb6MUcKjVWjPH6VhltyqwZ?=
 =?us-ascii?Q?SB7LttwENnoCCfPrXX7y25mzUzKabdjIy/XjzZTM+uWve0ulOXbzHSidEFsA?=
 =?us-ascii?Q?NQ+YJqOL2hhmT9doHtw5a8rmxDc3cs0GvrDfj0TkG9Jx26zjR3FD1UEE8YN8?=
 =?us-ascii?Q?d++QwSHKEvYCm9Y84HxxLOS4AUVLLfBnkiOoxHtHclWHPt4lTxCef/aA77gR?=
 =?us-ascii?Q?bIpnngBp3Zt1itI0ZP1IqVDMMWzqBcWoEn1N8YUVq+kF4SUySRhegsQUqCc2?=
 =?us-ascii?Q?o3lamc/atKFWHWBFzkxm2XV+D99T+0tyN2R63qgIQL+YR9SRuXa9IFLX5Np5?=
 =?us-ascii?Q?xn0Wz6c2V5TRsdir4QqmJHerVC2sRjym+RpvQOpl9pHMQasOgwTZqaL7pthn?=
 =?us-ascii?Q?cAfhF+Ohfvzb4bJFGi1U1BD8FcL9Nl+ZKUZH8shxMDpDXN6pK5jmizREi1mp?=
 =?us-ascii?Q?IEzHRoKsLxO8K8v3OauF9tV9lziopA7fxO6s6ko04reTMT/l69Y1A8YaMula?=
 =?us-ascii?Q?GpSGdvI3bAyV976p95O+P1wpj8X5zrlZNqRSeiMXZ09AMOquJ7fraSXYXQIy?=
 =?us-ascii?Q?zajLgXUXChELFZBqPdKrn/iFIyljai3T7k7R3/tJqLs4TcsFEU0l8RQxd+wG?=
 =?us-ascii?Q?KCZ1njdn2ZxCZ3honfsCorqledaK0ciuOiEqLdYcvhQvzu4JOD96lLGSIEr/?=
 =?us-ascii?Q?RFvRoaVzAoHBF+L2pAsmD57WbQ7sCJNsrfKEhRJ+aC0D2kTsUGZCc9Rg0SNb?=
 =?us-ascii?Q?Eanyb+sNmuHQP0cv+KLJsTsN9G8oEI+gs3gfUfIU95/k9OS50YCIYiRLD0FT?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84c0281-5689-44ca-0a8e-08db07d556ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 00:01:47.3602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMmBPLv82uzHh7Nzi1Ds74ZjEpm5BmdqfDt+3wEQkB+vw2Oeb1jBzX2ijNLtg/aiS2iE9iku8q8ORiMR8tjRqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9660
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 10:20:56AM -0800, Colin Foster wrote:
> There are no external users of the vsc7514_*_regmap[] symbols or
> vsc7514_vcap_* functions. They were exported in commit 32ecd22ba60b ("net:
> mscc: ocelot: split register definitions to a separate file") with the
> intention of being used, but the actual structure used in commit
> 2efaca411c96 ("net: mscc: ocelot: expose vsc7514_regmap definition") ended
> up being all that was needed.
> 
> Bury these unnecessary symbols.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
