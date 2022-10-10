Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CCF5FA665
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJJUge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJJUgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:36:12 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2259D17884
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 13:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuWY9JPHsiNe3JgPAc1AaH5tkZYdXK2cwnfYd7M5zDue8xus5gCq351E+JffcGzNbFLmEjzRy7ZwEewXB4IeHdSTFhZY7wIp92J3p+Lua37BWYXQAlim1rBjGTZtl9KXGrJllXOBCzdH/1YbtUjCfzCK6MBatYLRRk0LHTYv0qmfRCW4oodPxZ5Jo6gCKnlvu0ZnLESbUbduyPeOTLsP9iIGzq/ErKSqTnOVkTKxWYhblGdfHZORaUQgKsCNT70PD7CTwxt6QMDk8btIVedxNk41OaWluF2hf5ZhcKvIkp+e2+GSUJL81vk5esLjbIsHYilNknK/NZiul7Bs4mw2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sCKxTHpYrVYVgR+SILu1hI3SYKyQM8gO6Ikmw1+p/Q=;
 b=Rc7G8QbCqI+TOpWY8PkwkEcMgRa/2viHy3ZbiIqDVqoF5IIGc+f9iV+qS3SD0G1w1WQmqCmHPsVdwmFvg3v99pvIS8rMwzAIdT29HXxwzpr9FuwzhiOaLQ1YPdLuDtsL0H7DGmxenEP/YzB6HLwwbJCuvPQICDzEZeIYn5cq4HrdVhbMz2yNm4dZyWXa9LAYNkr6feKPeXajxIC1TbXgnsekmedE5sPozw2TmX/aPbo2XqkVgrkX3lH687tdlVV3OQaEt4jqa90ZFGX68XkB8w7NmJT3Bk0g8YwmWyRjiMW0btz51AsyA8jqC4CRa8GjEKzC10P4InccNDXS50OHpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sCKxTHpYrVYVgR+SILu1hI3SYKyQM8gO6Ikmw1+p/Q=;
 b=nzeAh5HUb7TLE4DlR2TUv7JWp3Oomn3NXxaItAMkArKqXmmW9EoTb3CVPG3sfpWubOtZvEHZ2175uajpumrZw3OBEYOw9+opq3vqrRG1D996/zyEm5vprBj0VIXcrwJ/s5yqJKBfxluBg7JxsweydvZJcf0ONUWqIIbksh2Lq6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB9567.eurprd04.prod.outlook.com (2603:10a6:102:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.40; Mon, 10 Oct
 2022 20:33:46 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 20:33:46 +0000
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
Subject: [PATCH 0/2] net: phylink: add phylink_set_mac_pm() helper
Date:   Mon, 10 Oct 2022 15:32:59 -0500
Message-Id: <20221010203301.132622-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0042.namprd07.prod.outlook.com
 (2603:10b6:a03:60::19) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PA4PR04MB9567:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e509875-30e8-45ac-14ba-08daaafebafe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfZF9JJUDgK2Z3Xb+80+g8KKtIrPmfhQC4k00l1syrPeieUn5I875EeUqxl5yfdNogovnh1DM2Ngnr2b3D6Dgu0GMIvk42oEOp1VUKHl5VlogPOaVgexa+gsz7i94WI5UN4qN/uC8pnU1+Tg+VUogdTdGILP0TXHgp2eA9agmEIR1bIZK+GvqmeuSD0H5Tb/8UwYQJGPiVuZ4zqraVBApTrouVSLnNbHaIcXJO7jltJomHMLVISHqonr2jnHtCmGLh+uK+b/WFDt/vVyXBauPRiaVyYB+KgcvlFpXvsbexMsCbgN7gjqE7MqadMJS2r2Ou98bCNtyBCXiNbLxkW1mN0eR1SKXLimBAGtXYb12K8ktnhpz1DPkXSU78EoFuiP33YSGANKLQ+q88Cf66XBEMKPG9QYS+zAssKDGRKe85WHlFhDYNQWTnXePhW6TH2EHh6VgBpDEBmpa+jyYHn/iPuarpYufeSY7ZGf9ypxecQplCkPxu2CW+taMKm22Zf6SyRVZQmisYnoSY67tHGFoRd/zNgA1IwzSwKeurweB5JodEa6GdcekcF7aT3d9j2lzDcwNqM/NaZqF0KLD5JAkkEcld0jB5dyjVuknHh6EReJtnUpXLGhyqBKOMvqLG2DgE9ttUNUre5HUSiq85XwCCYjId9MvmUf//JGOmkckY/8r6JFtj/iW8uhMnY1lY63jmk7JdwZt6CzNQ8SzqA3wuTba7GB0CKgHhVzlYraCdOQxQiqP9NlOhlz7nhjgiIvUSy1FLWx9dw6frvZ7YhgrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(66476007)(4326008)(44832011)(38100700002)(38350700002)(2616005)(1076003)(7416002)(4744005)(2906002)(5660300002)(86362001)(8936002)(6486002)(55236004)(52116002)(8676002)(316002)(26005)(6512007)(478600001)(6506007)(110136005)(54906003)(186003)(41300700001)(66946007)(6666004)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sdOFGfkNbgOZ5KPwukciaU6YOW+Jgf7wRZcCHYsJoIZVweCgMB2k2Y4HZld?=
 =?us-ascii?Q?+EVhqsG9NYSLjaoA/CcV3Xh7D5HdXaiy4oTUqxwKrb+ZyF6bYS1QMVGcLlh+?=
 =?us-ascii?Q?lB2sqUIcPaqV50gmkqrFTh0AFGXACOM+jPOZ2aYkjhJBJCOKl2j1oPB1GCHK?=
 =?us-ascii?Q?3cZYKxXhDerMc221jb2oUKYbXPK1Hb2ZDBBm6JpkCEBNp1XolZy76C/P0+P9?=
 =?us-ascii?Q?/h2vuMDxi5sFiz/uakWVvjv+u2NV5z+NGKtZEqEw+7nkZ7NpnWJFCKRBoZed?=
 =?us-ascii?Q?ndKj0JsQUCBH4iECg0nIb8TGdvbKFHMHLK7d4crODuQYPwKcGleJe7ThPhd1?=
 =?us-ascii?Q?bsqY6DwYY/mn5yrw3Zfexl/rhmLBkHdN9TAsM1bESG9JWHNvthnEojmoz1kz?=
 =?us-ascii?Q?93PMizRH0B0JJWVKjM2C0aWSBLwQT1+K5yzS3hFY5+xgaRrxc+kFm/xSpwGx?=
 =?us-ascii?Q?8VPm0FiT0fiKCOHwiUmhBeDgqgyE+SoWvv3x3FY+uByJv1uPVy6cUvDB8Tq0?=
 =?us-ascii?Q?sYKCXx+jUJrOJIxrccK1JwJ6r6+/oFv68PulJt6OCTA3sfNwItTyLylEXzYG?=
 =?us-ascii?Q?xUJLzGgdTBA/eoOenx3z/AKEdctnBAXJzii+b/sqpd8ztzKGYsqKhaZeUcDP?=
 =?us-ascii?Q?dOwxAlqDkoVrRumiHXXyA7+huSGMAyf0tc3MCYzBiC8DKqYaBW5CowT+yODm?=
 =?us-ascii?Q?sJec1n3RAO3GijmOgB4g0cWLx0pbE3B/ZwLGprSbSyf2xk7v6gnJCbk2ToYj?=
 =?us-ascii?Q?jnGDRkIU0ahytDoelybiJ80nzDGxnmULttVJacbv5Jwtra2GJvOFOzVxBsIt?=
 =?us-ascii?Q?3xApNhvSI/uU9puNRRFDhzyqjmpLnr8DwsuGcKMzm2MM7Z+GdkQAC5aDzI5h?=
 =?us-ascii?Q?DdALBCa6D4WUGSSB4XmJJj3yxWquaiFRrHLo+ZWLYn1D2SBWB+wCWNVBjdyQ?=
 =?us-ascii?Q?+r4pulF3O94D+4X/HgRxk/U7Jw/L3hoFPxDxSyWnplcsfGE3B5z/4cW6t+Iq?=
 =?us-ascii?Q?XCF3zWb+nuVy1CuFnKIffge+RP/OsQkUkEqmip4msu53XrwRCVTUYRV8fYgl?=
 =?us-ascii?Q?OHmQVBubnchhkHRFnyZrSA7x0CmCBeUGUD0u+or+d8V4CB9JIF/wNU3YrL1y?=
 =?us-ascii?Q?ewv47I8w7v2rbwlFETItiiN//TLT4MFz4qfjyLqGX+qc2fopKvomFbV7Pzd8?=
 =?us-ascii?Q?CjfsXn0BYSeQP7mGTVpJxag6My1plr/SdA+fh3zJKTGErUCZNb/UNDGfhx02?=
 =?us-ascii?Q?aaxahHXEkjC0H1KsDotnP2nSvYL8lvVJfUYxNZAa334YVFvozd/CL+QfCsPm?=
 =?us-ascii?Q?3LhuPRMdiFD3Y1lN7cuKxxWwdPBSZ3fxYho7C8p7k0no/eqfg1omqAZGs5dt?=
 =?us-ascii?Q?Vl1DXWLefXizw+XNi/hyz/sQG2MxG8EeVaeTtPjjRnoQ8IaEGGe2uFM38pCL?=
 =?us-ascii?Q?BJB/69QxAVtrkgcOcinU0zlWrxI9fq8xzP8+iEoiqFpLNvKd3nJg1+L4/osN?=
 =?us-ascii?Q?5/mZVnEnmtcf5twtUXs4Qt6xt8mOQWCS/2H0CaTqu2ZBYjuzWUJOlJp+SY7y?=
 =?us-ascii?Q?UZ7j7l5UkkFRo+XJSQE/m+C+Aih9CQAeDio6XAANVMXj2mxeeCQidK/NI6EY?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e509875-30e8-45ac-14ba-08daaafebafe
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 20:33:46.5425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9cyfhwwu1q1a9QV7BYwgumQsqcTzwEm51Pb7M99BTk7YCrikwf5tIfH2IBtXluHWpELNo2YHDVp7ORNvA+gaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9567
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

Shenwei Wang (2):
  net: phylink: add mac_managed_pm in phylink_config structure
  net: stmmac: Enable mac_managed_pm phylink config

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 drivers/net/phy/phylink.c                         | 4 ++++
 include/linux/phylink.h                           | 2 ++
 3 files changed, 7 insertions(+)

--
2.34.1

