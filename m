Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC55FDB0B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJMNje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJMNjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:39:31 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2063.outbound.protection.outlook.com [40.107.247.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7983F10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUPxDD6mXN+rB06s9/Kgdsy876lEgA1QOmJGGGmkglpP6nB1ekCcCs/usnYzCR88Qea0TDWPuX+x6/bIkks/rCVmtqOOScS8DBeWq/prBXgIe3Q3H+vnPjdmpWGvxVjaJC2knbrZZQyJlrnZM5AwewzTYfSdaWQdWkbNmk56xRhbnd6VJSxeSH+B8SnoSLTXVZ49oIY4PuCiYpSuUAm18oxGA921pYE+DoPf6zltrOKsRNmYdf58VMI3haM5bJHAYLlKEp1MSU5J5K+Nha+FUTLSwUzjm4+cKrg98cJ9w7wiVxwmWhigx0lAwqyn2l/KxBTRhum0fyXWOFYIYqwdIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjw4HdtirjD/hHNyxkcTgwV59ATqg3yudf1Onsctvz8=;
 b=La5S0UjxaumLvEB5CDOx8lzZqKx7oQmRzk2IALhJORzr9kGUqWeAXeoQr6t0H4TwZjDoOxzDzqwo6sO1VgLi0qKJedWm9jay0gpR1PMiYtG5L4FbbiWD8fMEaZmBX/Zfp67f7utNVv3OohiqoZWI8FXdkaAxq8u0OEL+6IlmiwMJBDSzoO16nofIaXIyEilDV4yiWJKK6eKXHk/Q3q9uLzUUbH7NVNuZq4BjwLRp22ctwuLuu23mpIUqIbJ69oeCWFCT/z7MKcNtCPkXKSHYcT+Rjak+cGL4VWrhxDTRvqjFm3eKZNHH75R9GPk/07VBAwWWO6elyuWqye8yjkLgtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjw4HdtirjD/hHNyxkcTgwV59ATqg3yudf1Onsctvz8=;
 b=L+9KqctQV8FhuNamoxnpWGn2b2nYGU8aHqn58+swIJEFP5d7BBAe9mLIk64pw7LWRnzR6AB/f3OcGREX/yCExLbymukDZHh/hCyJUX2IkOC1Gh1jwBbDpRfUXnIUaJPyt7kgcUmGQKER8gZJ83TSzu2Er6WShvzwNiMyh49zJiI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM7PR04MB7141.eurprd04.prod.outlook.com (2603:10a6:20b:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 13:39:27 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 13:39:27 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v5 0/2] net: phylink: add phylink_set_mac_pm() helper
Date:   Thu, 13 Oct 2022 08:39:02 -0500
Message-Id: <20221013133904.978802-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::13) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM7PR04MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 51466bec-eaa9-4d41-c868-08daad205924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmn6ZVpuHFGwzugpcaG70WB/61xR/tuZVKoksMNC36Lnl1E1qS57wl3fZSqKnWJBe4WSE0duc6miOEa2XOjV5WHdKuSKokFuSMyR4YTOQOmMH46TwcTRJqS4T/rft+k0RPIPFA11Wm9e5F3mcYltFwYKHFwA3w+6RqlzZ9v4COmM3O3Av1BI9QYtHkuFywj2fCz9E6XIZuj38EZvk9L6BfhFCv0H3SDPLmEOjcZMklAGd3b1vf8G1nMOauX2KBeL1/wJb6VtaJxRlSmZJgOQX+BtHwRcdo1s232qvULpikeie2X/h6WR5yguYDCoSjU0CBzkOt/TQE2611+9/uQZ6IdO2iy2H9X354ky2RZKoRC0PVXupTkFfbEayxoGC7X1QXZLp0u0fOBgxrKr7fQnZlcwDzfC733CDLyab0UTJpye/pIS6jgvfnzeWnrOiRdJ3r1Lm2IesAGRpc1MfirysEZo81Y/LSRoDrFTfgiZNnDWiSYnvogpjBdiZL6RgSmpF9ZbYgopPmPq/0R1lturEijVJc4OQsRxeS1PtgQNZ8N530QjmGXAhN2mPFk4An81r6RBmtNQpAv23D2rxHHbOGQ8/J6iDBy+6dBaEZqXPn0gC4x+DCXCp8HycGMwNX1sVgWk/FyOGnCaWhksJogSWnRbJ8Mq6DxJZRhC9g84Qn64dykecnWkpx4bnnWFX+Y/sSWOnBXGFJAaY5mO7QDF8ZjlpZwX1WBWVOAAy6ovX5256R3nLZZ0BrmyIYcVSud0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(6486002)(478600001)(4744005)(316002)(110136005)(54906003)(6666004)(8676002)(41300700001)(66946007)(66556008)(66476007)(6506007)(52116002)(5660300002)(26005)(6512007)(55236004)(8936002)(4326008)(36756003)(7416002)(44832011)(86362001)(1076003)(186003)(83380400001)(2616005)(2906002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6hn4eaRNybtaReczScL+ss6shXim3/LDs91+DPRUhsFymK5x9ahiCWUAmp6U?=
 =?us-ascii?Q?7C6uXc2q+Fj5PUHgyeUUJP//EdZI4nnYCxmVFO5Nb9p8vAISk3JO7D+GovO/?=
 =?us-ascii?Q?jzGgrf7X5IjCGVr6AINGgpAGNtt5QO2Fe0ZQWuTiZvlUmfzisy9vMJwlpNTK?=
 =?us-ascii?Q?eCuh46wXIge0ATNGcZhvvDRwWtxUH61+Z+m3Vjf9445h6RhjQZkDwbg2Uv6z?=
 =?us-ascii?Q?ZNBXibDH3szIFrWKUN+vDhvXzbi7JsUoya0wOmS79IWEZ+eJe7or6kYCd6If?=
 =?us-ascii?Q?nFier2mlIsaWrfYJyL8uHdnBcjQKSxOid489rBB8XLGbrGg2Y62UgsK10Ky5?=
 =?us-ascii?Q?Vm/E1R0S6PZNSu9QhyOo6EnTxCPL0XFIoXecLNgtYrnEzTNZCrvMuP/eiyDf?=
 =?us-ascii?Q?0eSSEyHUKoTk7xS3gzbMPWaWiPGJ1ziACDMZfr5+dERIK0b8mggiZZF+HJWZ?=
 =?us-ascii?Q?2gt0WEc3U4wmKAWy900QfT5ra7Bn81VmG89Wn2g1ID8PRTFUA3oKtSzwUYRY?=
 =?us-ascii?Q?mLbrv4yNUbjGwcqC7Eo5tYpcud6fgkEB4O6Tzy5Gjh/KlqSJB47XDjfyy1Qd?=
 =?us-ascii?Q?tUx0Khu4nnN6b3KTQnv8ruj8PNUfOB4Tovq+HJaKpJiQcNnWbvYzzK6whftZ?=
 =?us-ascii?Q?vxWuF7wL+iA7mJ0JMk2pTVSdBciYJ5KzdAadxk78bk0DmoyJ7qSU754eL0yY?=
 =?us-ascii?Q?7rGX9D/a5kPO4m3sOHPZVHtFqLR+GdDL39W4MfLF+mxYOGm7yiPMSN0FuG81?=
 =?us-ascii?Q?6xdwS8tzg7i+PIzVTt5tlJLsAkcX2DOI00Px40llk30oHWmJFZ23cxrkseSw?=
 =?us-ascii?Q?fGRYN01eul0nUsBy4GmG98yzw+6cHgHpAG84AqnQa5as3EL97A7eInADMYxD?=
 =?us-ascii?Q?91HoHRvalylnj+rG5RXih+Ke/WjbvGGx+j8hS156cF1wmPYm1dITimSG8TzW?=
 =?us-ascii?Q?g3EKpu8J6N2FKIKvu83LSw4P68xfFglPsE1S51OmrqeXCTNNU5Dr6LaAU3X+?=
 =?us-ascii?Q?BmTWlzdgcWQK2BJyXDKuKEmnp0mGDoKal8O3BAOYOywWQ9YL23BARosZPfcx?=
 =?us-ascii?Q?vUNjyNPzdWYKLaaBsC3okwL1ctts9TlvqvJaXIpbToObnB3X1rc2OC1hKqZ2?=
 =?us-ascii?Q?yfWbuTBSX38/5hlYJ0SunbXqk1QHBvwMD9Cxd2AP/R3Sf9eC/RzRjjCxEJ8m?=
 =?us-ascii?Q?ahGlJtvKT2ruNHoCJvnNhX3mmB0eYrQJZXfXAfi4VeVGie2v46HS6Ayc//I0?=
 =?us-ascii?Q?uijJen/NmNVYAtqjhlbiJU+oolBMVAUUguKKTw2kAI7pTYch7YE4ktRcMLlB?=
 =?us-ascii?Q?DrvT7uAGPiPIziRgAYmjBKncNsyEIjsxtI/Dbu8AKkRVcFzPCe55qLnLny9C?=
 =?us-ascii?Q?otKbKtxbJfRNgWSs7nUUjxUaN2hKCH3q/yQ+zBaJWIFbfgSCQlM4uTeP4dMj?=
 =?us-ascii?Q?x1P5jteTB8hwBMDqzmKdENGB2BeQ+6j934O2/YABDmduDAxoUhTB45f8I+BQ?=
 =?us-ascii?Q?2qo8KKi8JwtQEdo/qO6d39PMSCbOIhNiYskUn3ORo1Xql/34GsAXbn60gZrS?=
 =?us-ascii?Q?IpNLf8rMWWEYQTws4o4jX4li6zkVpUnj9jqfGx68?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51466bec-eaa9-4d41-c868-08daad205924
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 13:39:27.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i21agotekNit1cqGdTe5kpPE83TS9U/L/3BF7moIT7xCGVrhk6a/knSI8Q1Y83WXpXematRvrQACZvi2QZ90MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per Russell's suggestion, the implementation is changed from the helper
function to add an extra property in phylink_config structure because this
change can easily cover SFP usecase too.

Changes in v5:
 - Add fix tag in the commit message

Changes in v4:
 - Clean up the codes in phylink.c
 - Continue the version number

Shenwei Wang (2):
  net: phylink: add mac_managed_pm in phylink_config structure
  net: stmmac: Enable mac_managed_pm phylink config

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 drivers/net/phy/phylink.c                         | 3 +++
 include/linux/phylink.h                           | 2 ++
 3 files changed, 6 insertions(+)

--
2.34.1

