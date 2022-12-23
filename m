Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487F56553E6
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiLWTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 14:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiLWThx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 14:37:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2126.outbound.protection.outlook.com [40.107.244.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9723EDECE
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:37:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Va21eOE9+FCAz/8HCU4yxq7MOWL2P1jUgNpmcy8LKPs0Yq6ltHrqJYSoeQb+y896OwHe/Yzfuh4qIg43sRiG91TxOaEWrxwLdLx6f48qI5YH1IcjpiUSfWojV1ja5kQgGOprUQQdgaksjhDNsBiRmpLMd6k0LTtQZ8bfkTm25/JhWCooSXbbNlpzkrcdIy5bokmLiIEImm5HrjgAadCNo2q/uVAwWK4VC7sXKESe2xrXAbn33U0QJQvjx8bur2qOrp6Km9vbqz8QhG3sOWarlAFLsALPYQ7Wo+PIT3mAhBoPCMawOd9LnbF949QB2o2JslPfgoVBedWhCBOx8Vu00g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tw2RuxtcpBOleSvaB8yycoGmienNDaua88MrQkftM38=;
 b=Ubh42wGOMBvHuYOJcxIlOoC4IQsi7ZCMjnAL9LNarSuYuZrlmxfrrjnuptDQWYDAdMYYw4SyucyUFx0ozmUeYkN+G4NV5WfKgVg7Fk6iQTCGU1Hz4j6WNa9NteiaVdWid2m9NAalqKVynMLHGmUWPzH22nouPBbXP3m+p+IJgG3lNKI6CC9RF3iw80saMgs3scOCCm41sY4HYb7q5A445Y4cR5Kb3jjPaCYZWtQAQkD6vTe9AhYPO4DENzc0ZjfDDlFMstZ0kDSpwIkYH4xbSQNQFWuVEFHlXHYbuEgJzM8Ws78rrfQqZuvJECgRanpDRCwRa6K2WnPq0mAq9g5ZoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw2RuxtcpBOleSvaB8yycoGmienNDaua88MrQkftM38=;
 b=q5V5QAuHrBhVbCsoPiXi0418mj6G7BJh0B6RFLIifRfYTfWVmDa5g/OOv5DWZlWzMqtWWO+497y1jXOqz72kBIV7XKI5XJpuU/cyupAK+b0891rr6kGOTCI7c9rix5OFYIlbIjFxZZZJg2z6lO9JNl9k8zQmeHgqOUeLik/4XP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4806.namprd10.prod.outlook.com
 (2603:10b6:510:3a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 23 Dec
 2022 19:37:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 19:37:50 +0000
Date:   Fri, 23 Dec 2022 11:37:47 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Crosschip bridge functionality
Message-ID: <Y6YDi0dtiKVezD8/@euler>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: BY3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:254::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: d5fc3d3c-e4f2-442a-3d8b-08dae51d2d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMZ6MP6MElF9P/bdxE6//BaCLBjzZ6nb4y2t86k24VCCM3Af6Y4q3UJsGJ+ZpdyFxVTb5WFYF1RkbRN+Bblwo+xWTdb+kHqCwArOx94F6lYw6E/iLdeIAKb4pcvmEUbku6AyYDz1nvIS+UKJRha4u8tF8H8KXcw69Ihm5IXWAoul1zIoz98FOfm19B9S6ed3qwCq79fTqeogZFPN7KbK/SFkFcOgpDtFbJLo7ZJ7LucMiQHrJrhp1YidzHL0mmnDSCDOOjBxQh+mrvDVsmgKGR/AIrN1oK2EpkOrWAzAxPT9RbmdIMaZ+suPwyXiX0AEHSiy/ulUIc7GMFAJMAmrfxaz5Mbt2E8PsffiKB2lXZDQ+SH/vvdKKj6oZkQjA40cN8/QFWGg60+gzafYpRE1e2x2gfLgj288m5/1x14wLSkMe8QMSnPYZzAMhhuNf+LCsN11xpZPp/yKLyqlmIrnsODNm7lSQAT2QX+Hj+SCMmUpdG/0WEc+4a2UlYy8AVEbjI0vnMylsUg63eO3c1F2jcUBtOA+OA6LrQL9p20fb/maOayBakw47LgTJnaFM85nfcxOKdONfa/12WNbaT3s2souNmT6We+TDAxMGObG/IChELdRNk/IbYc03/mqMeW7r7rxe7pGPfhHMHjqR02flA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(376002)(346002)(136003)(366004)(396003)(451199015)(478600001)(3480700007)(6486002)(86362001)(38100700002)(83380400001)(6666004)(6506007)(26005)(6512007)(186003)(9686003)(33716001)(5660300002)(8676002)(41300700001)(66476007)(66946007)(7116003)(316002)(2906002)(66556008)(8936002)(110136005)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2WDD6iIqfcwG2AMFpQTkUCrBI4Eh5vlLeN6esZoJaYtXaFaStkZQ2kxAcPM5?=
 =?us-ascii?Q?uARCnujXMAcVkaOgADLCFbyvuuAJFfz2zn3cAhoqhF3EiMJrnB6ka1D8GPpQ?=
 =?us-ascii?Q?QT0ZsePwSdmhXsSMDjSWH2D8luMLcCU3meTMqW9j7arc4Vv1u9bf7PfcWYy6?=
 =?us-ascii?Q?8TKI3suj7TW44dUbLM7l3negvfkZKKEwmRZW8WsnfFC7S42aTlk+sCw16TZT?=
 =?us-ascii?Q?ASYEVj2dD7F6fs88truie+2+q47+wE9a3ieZXEXFwhw9YX0dAdZ5kbHeUf+w?=
 =?us-ascii?Q?ptxHlUxQsxUEdIJRPZRG/e9/p2REFinudoufmAuwAZ7x91jhNV4t36dPwCMm?=
 =?us-ascii?Q?ljKze+9Igqy6VTafohk6+gpppjpPpPxn/GGelBxRMpLE3/i7k8wqpDpuAd3A?=
 =?us-ascii?Q?BnVqcPi2TRxkRC2vz8NO3nDP4RarSneok+tIzrWLW46KLU2GWs/aTOVehPmu?=
 =?us-ascii?Q?hlgZxYpoceWLg7yGpZZGpn8ArDLoPRgGhAv/8BYdOiTcgSSQ+29Nles6K9Np?=
 =?us-ascii?Q?SkcJdIRyIbj7LCFfGl0B69UfgIDOManj2jn4DZ59fU8gxSjNhKue/gRSMSVl?=
 =?us-ascii?Q?8EkvX3JoXY+zkVNi7wV97PzTnqJ8/KPX+t9L27gimulhGp3oVClYjr76YrXu?=
 =?us-ascii?Q?c2vDLr3fNx2lTOxz/+l5LC6ljlg/Ed9ba/MVQihRr8UIHXn5xvib5fFGqZCV?=
 =?us-ascii?Q?q3o8A9lTAWVJHoGKJU02EpS2X6SbNABvLb3r6EN5ALal+RW0TGFic5PwaXrV?=
 =?us-ascii?Q?NiOUXkDx+U+qzsHhGUMmWAdJjtt4dlcGNLPMzD2W/6Q0L/LVcvUu4dyO3D7f?=
 =?us-ascii?Q?u0wMudyKNFlupwgWrSjXnqWxHOKArJoOgc8DlyEQlYoMk+31lLmxHNVgAFD/?=
 =?us-ascii?Q?s4DmlpxkDolhcuwshWTU5upAuXq8HRnhDq+NDD/rm/OyZS44IJdMz5qyd6RD?=
 =?us-ascii?Q?Lqh3OjuOP7KWzqfroiy8isWIhZb4+sN/m4jcymM/giRz8JKQAOJ3E2alUixr?=
 =?us-ascii?Q?o2h9mj0Fm6Lpq6VkqI3eS74QP4cP23ZC9o6/Wu8ymaww/YvtxGJhOSO/fFzE?=
 =?us-ascii?Q?+6jPPNPSINbhniMCfC29kOzn6H+okc1o4rn1/4H8yvbzYoNmn2+3+XQtysj6?=
 =?us-ascii?Q?PfsOw1xhADLAhBJvL1If0MWG1j6HmHLFU+L1wJd338RGmQGLE8Leq0eWd71c?=
 =?us-ascii?Q?DXsq2Q+/fEw599fssMFX90oNeY3d6uf2by0bDEcvqB59W5wm8rdJ7a7Tsa/K?=
 =?us-ascii?Q?zHjNZ/BVviQ43zogE6Q3OLb2MDT4onuH5H0Umv7Hqpq174oQMY6Sv6ynVYGZ?=
 =?us-ascii?Q?rMoiKWYThFkZymEt306pHQhq9IRWe+ueGOdYyottExmBfcsNf73knhM5/VLW?=
 =?us-ascii?Q?wb+seAPLtf27I3PJr7HZek2+bIqlK52HEwBBKiLRraqEpJWbnVD6Bf3SAhK/?=
 =?us-ascii?Q?1EnhNol+FULJHx/Z8XU9TWdekEv0HJ6AGGc+/JxLCn/FtIxt2TIE7RIsSCKv?=
 =?us-ascii?Q?TGIFpn1afmEcm3l0lHz8oJgeb0hXBzpZhk5iOx9ObIvJj8jFYRnTXGrFoUiE?=
 =?us-ascii?Q?pU5cVa/T4bx+u+8O4th9MaQmg6k+qwmTrfzujCZaeANVF6HlqwMsRwUPS9+V?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5fc3d3c-e4f2-442a-3d8b-08dae51d2d3e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 19:37:50.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWWbXxflX+ijw0GcIXvV3r6xy1FRzrBi/24XQAKe/mguTkByN11YWFI1UAs2WvmzXwDpazhOTp4ro5WRS8N7PSpvWYOzBo5K9i2M37w58xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've been looking into what it would take to add the Distributed aspect
to the Felix driver, and I have some general questions about the theory
of operation and if there are any limitations I don't foresee. It might
be a fair bit of work for me to get hardware to even test, so avoiding
dead ends early would be really nice!

Also it seems like all the existing Felix-like hardware is all
integrated into a SOC, so there's really no other potential users at
this time.

For a distributed setup, it looks like I'd just need to create
felix_crosschip_bridge_{join,leave} routines, and use the mv88e6xxx as a
template. These routines would create internal VLANs where, assuming
they use a tagging protocol that the switch can offload (your
documentation specifically mentions Marvell-tagged frames for this
reason, seemingly) everything should be fully offloaded to the switches.

What's the catch?

In the Marvell case, is there any gotcha where "under these scenarios,
the controlling CPU needs to process packets at line rate"?

Thanks for all the great documentation and guidance! (and patience)


Colin Foster
