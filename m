Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAAE4E74D2
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbiCYOJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiCYOJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:09:47 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2102.outbound.protection.outlook.com [40.107.24.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB01FD2C
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqmGGLf7Et97aWlEytODxji0sOHVdVWB6KYI4qgaZiLGm08EmIXwk5iM4WLOL0itO42wE2XpvSACN7ADOipTU9+/hCUYpPQPQg58Wdonrfh/vxVm2rTNKUY2gm7E2BwFTdF9ipgNDe3L69VohVuy3sQEcujPNuapRWrY/dVce8py2O2rDnzQOy5IZpNTPNEIx13z6ZVDGHHwRH3Q8LAzyNWUxu9/AgPlBgIpS7cPJSH/ngakzesOpfyxMd4/QufOoDSXl2Eefvp0Ji53Gz3VrfO780PdLPcVpZStenFkZZKL04rO4SG71RDjIpwIBq4NVK9DrtIoOphVgM4gi7tsCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYlcg67E1vIuSLIMApnCVJKoKaTihw/oSQbfe9NL1rQ=;
 b=kuWx28GVFnP4CHHIolvW7Onf8Oi8muTtSysROPKcZ7KBbXz3RHFgZdDiU8hbK7M7MizMTp9AKblDP/kNs8Z9sQ179BVjKQIJEjEazdULuHZyfLU79un4H5nnHeL531Ve9GfJRw8vq4qct5fapQY9BWWy5AzUEDSmdZuqb8nyWe532ThfQlj1xxvV73I/mTj2AO3cRHeMiM2Q+7g7IMWPnOukJfSj0Bo1Rn2dSm6gBCL1s46fwanuWKyVkTWCpZSx1yIxaDtkRCkvxGgY1cHQkbNCVp050oh9wAxezGaHoe7VYXdjaQTpkv8nKeeP59M9nS1/B0mceEk54hK0xsWKtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYlcg67E1vIuSLIMApnCVJKoKaTihw/oSQbfe9NL1rQ=;
 b=cSE/iJro/SP8zQll0kkinu5M7w8DvodEudBB6egpDnM7wC28hVj4rfwav/+IuGDC6cmRpJoXRjcTVJ9z8dXt4IH72ylRnA+6gG4KcwMe/CtSX4PsGi5FdRiKH29GLiuhz5WkL8CEZQ3SPHhJ4DyK0CPKklPfUr/s3mj1UZ9cS0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0471.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:38::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.17; Fri, 25 Mar 2022 14:08:09 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::7d6c:79fa:a2e4:ede8]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::7d6c:79fa:a2e4:ede8%5]) with mapi id 15.20.5102.017; Fri, 25 Mar 2022
 14:08:09 +0000
Date:   Fri, 25 Mar 2022 15:08:08 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>
Subject: FEC MDIO timeout and polled IO
Message-ID: <20220325140808.GA1047855@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::20) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f5813ee-a40e-4937-2c18-08da0e68e40b
X-MS-TrafficTypeDiagnostic: GVAP278MB0471:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB04719EF8785D06C0C28129EEE21A9@GVAP278MB0471.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWD4v8WH7J0OMR6rUwJ2ntzTJKZHetZZo1e/MJqzL82XcuaEsTTJOMCF5DkU5PtL3hW3ny6l28mgr+YX32cFdSkNtPhwm+YWbW9ddUbaI9kXCyqRlTJT/Z1LG552/jc0tdbPdjs2+6Fa2r1j1X/Z879lDku95oezCYebisNOmsXOO1O1Tj4ocjpbjqk6u6317njqDxSBjln6l3j8pP8KO73vVNT+8CXT/48j5wgi+5xF2uhAmxSo6Z/Ig/hyqyEuUwY53vQCL6yuSyr3yaIo4J/OtkvsQh6smsuE8Ewc/1h/+l2F5aSrhzFPHwxAgohXdozSHBweTks9zxooKnI6v93CPeFWAE0pVb9mVnztGVHYjkU6Yp8yDTndvza3Vc2zz5TqrZR/diVgoM61wm+stL/vI/SrI/tzVKZ/72lcbulDv7vX+ikFwFnFDKnPluktMP4COe+PSIVnGB66yavpgmH7wN2mEUDRw5ylO48sD9zlm4qWzTFmkmsLtn/xZdWGwd5yq5QgIDJcf5s6F8yOiJBDoypsZ/UOE8qA2gRWJe9QEnJyQ/oYdgzbVefgW/2wR69GPgGEtFhrAwBbuRfXsTHCnQhnz0qG79T5r8tADDfb6mBmue1J8YDuHd2D++OMD/C9m47IGUiYEvj3Mif8fydkOpTsXE8AQ4FVilnFLKjJoevzrqpwSzQj74SILF/NMwc4m0p0mGvYg5RyMuf9iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(83380400001)(4744005)(2906002)(44832011)(33656002)(8936002)(86362001)(5660300002)(66476007)(38100700002)(4326008)(8676002)(316002)(38350700002)(110136005)(6512007)(6506007)(1076003)(52116002)(186003)(508600001)(26005)(66556008)(66946007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0fPmC85/XT0tWZ70Bb7wxdE7DkfA83o/iIblzFqU+Z1SR98tFAE2sBfkrfwe?=
 =?us-ascii?Q?NFEyuJR4OR5prJ8oAmQHla8PcVHOQK/kl7Be70ReMfRyow22gwu1X+zpB2GE?=
 =?us-ascii?Q?3yErgy1n2/nqYVP1yHDLziPdQns5G0DN26XhlyS1ulBcE2u6IzQM9gmvOSmc?=
 =?us-ascii?Q?bUudApBzak3LxS7qx9Y+8uYPmcCyxweX3kDFem7BBdj+S2bA8ZXCJklzRZDT?=
 =?us-ascii?Q?eTp6jvXZK+Co/b/H+gir+6HIG6YWkzAzdmsrcfwAkwuvqUGYz42cMk9qY4r0?=
 =?us-ascii?Q?EjNfjRyLT+RrOZm/vZaynEWtrAEs9gDUebedr8wJegGTOobftpcZIr9fglGO?=
 =?us-ascii?Q?4yCdt9/hpRDkOVyp9aoUeYPHps85F3t3K6wOuHWOnpkq/h71O5HyiGGPOALY?=
 =?us-ascii?Q?emwqaJQDwOJOs+m7ZqyKpxoowYDJfD5/Mtu2gBN+rBXhaUAjtLFI+17AI04P?=
 =?us-ascii?Q?KHuna/V9I9JPt58xZ6Dk1DJbEs49D5z9IAY4BZ3vscVRMNgz/WwwOO6DJCMP?=
 =?us-ascii?Q?aysCskX67RC2FlY+2su+27SMx+B91vIUQI9kvcd0ofvCCkoPhxsb/xVeFxus?=
 =?us-ascii?Q?jsFIpyvnNoZ49hlPSNPmsPhuBXaysPZN8FbHtVUHw5aHdXQGN+3XsCdvkbHp?=
 =?us-ascii?Q?CeiKdDzIA0E9GzrKjLxXnAJ2QJXOM8niQO3JAgZ7T6w9Q5f+qLj7v/LlkYOl?=
 =?us-ascii?Q?rShoxSWP9Hmyl7Hz210rPpTjWZyvyRar0WEzQa+/53tRFGNKrILhcH3zdV1e?=
 =?us-ascii?Q?Ggx0gZ9hFKrbMWhIjGRRmbqTBeLOwrEz256Do6PwoH+7K+Kk1JYUxJ1RcetU?=
 =?us-ascii?Q?6Ca1cVDdibmXpFfTDQw4j1Ps4gwlc9V6K4YqAxKUx/JNp10smjTjxfxWox1c?=
 =?us-ascii?Q?u70Bq27uF677mQsxJnPu/zQey4/7bJVERMPC0atOQrrGmg37+ztUMJSVtAfY?=
 =?us-ascii?Q?cVpC7R5k0fGN4kQuOwzNOx7V5kPdBg7U+F3n5AWOw822cP//j863dCUP2OwW?=
 =?us-ascii?Q?UUqfWFoiz3HnyFTuLDvYXpXQZ97vat3VU5WB1dtFxhFVTnaNbnGA17TqlWod?=
 =?us-ascii?Q?BuMUcJBKGQ8r+MkVbJuYd84hTYgegfZXuB1Md5lGACLlpfwpdN/Tgczmi+Th?=
 =?us-ascii?Q?OCKWSYge70QIPTXYAyQzX3wzV5KBeWM7klVSxKdcBwJf0vfoHVlWEexxP8Me?=
 =?us-ascii?Q?MXKhjzI1jBcQaQs2/tctOusVqD5Yaqmv4JOUij7PRqz1ZTIMUH370IusKl4d?=
 =?us-ascii?Q?KcTqetK1FPKgH7TNT4ccxAmkANzCHFFuctIanPycEXV+yGEGF+24bkn4viyD?=
 =?us-ascii?Q?9/NiuQqgp0nthXVbPIt7mrIW/ryLZPuXXLo8mCZMhE6ikLG2m9kzZgd6vUcL?=
 =?us-ascii?Q?T5hH5RhbffKjfjQ9ngjeN+MXlK3KDIKDZLgP4WNKZ8FErlnyotOO09f/of1g?=
 =?us-ascii?Q?6uJHpjfGGtypKNxkZIOQOhMezBawGBscXOBhW8gSBSljOoQyfwg3kvTtL8yw?=
 =?us-ascii?Q?IECF8AUCIWSvM+7+WuxwdgoNFyzW1/7JXx97fswaEjPOxn7zxlC2rakSScNl?=
 =?us-ascii?Q?sL/0dZyj4cvALhd8otv79weEc8mst77N/6O9NDs7bv24hPVEp8+cHe1SWdQZ?=
 =?us-ascii?Q?lJeLn1lPEPetxtR/oG/AnOvYSZYfwxwi0VPqBKrIRsjz0iOQdT7kqpZqy91w?=
 =?us-ascii?Q?ESUQhWYqeBrzoeyTBIMLap0JNA9uxOu5ga9j2ZNolmcFIBdLaNHLQstj/x5u?=
 =?us-ascii?Q?9mOydJkq9dswe0yJtOzXHSN1mZiVvGE=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5813ee-a40e-4937-2c18-08da0e68e40b
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 14:08:09.2297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNnctFKU59IQJ5OIJnkvSChVdJLeqGgQ6mDydi1kYrL2lPLEhumBBzZApKS5mdVsE9h1Ka3yQPZB0j0hE+Go6J95ZR38+LzvAFA9qFkAEnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0471
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew and all,
I was recently debugging an issue in the FEC driver, about 2% of the
time the driver is failing with "MDIO read timeout" at boot on a 5.4
kernel.

This issue is not new and from time to time appear again, it seems that
the previous interrupt based mechanism is somehow easy to break.

I backported your patch
f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)
to kernel 5.4 and it seems that it fixes the issue (I was able to do 470
power cycles, while before it was failing after a couple of hundreds
cycles best case).

Shouldn't this patch be backported to kernel 5.4? 

Francesco

