Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2178E5E7FD9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiIWQdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiIWQdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:31 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA84E13EEA1;
        Fri, 23 Sep 2022 09:33:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYgC7wM5r6r0EliZOLtmzIE6ziFg7t1vb/C74XIhgRTFkraGfG+2VlvTBGtmk/0YBR4f8Swrreb44lsXzR+TIUTbRjiRCWTl9Pq1ixf5a82njICvCJu5vYZjMc/5RgvFw2M0OyMrqoT+fUj1WH2j/1OgeLSMfSKzuTg0bLsdhQef+tcxxorUKMtbDt1qSqJWQvf3l4VnwWY8k+ZhIFG76X643wonjCo+elO6YuPHCeZszcIvncMmTMA/TRcA/OhvAkc5fDkLCLgaM3yv3doqQ549CL5zOP0X3MFcRvLlFWdXZrMmkN22+HsCCF/gtOgYaPD5r2WLwlwj2RJcgB7HWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYmX8GNzk2hhjzacqwVe+rd4e417YN1Rn+qmxJLqH5I=;
 b=h9l1rs1K9Du1t/f5nKEStmo1d1vkJGQpVa+1523p2FCCT1AzissTOIEdVz/Q+ek2ye/eBnR8bAlSegqGKgCn8ba8kqN2ogas2Yyk5+D1/kTAYqb+rhdElb/QFogSOxIWj1qNAujjNI6wLyUkNTr4yV5XPVf39hbus7jRYmDfzBBKbCeRuvA4YDf9W9MXxc028/AenNt0jantv+uhHvqCf4/kNlzYd0k9SDM1kNpRsiMCh8m+joq4/A+77Ru4sE2fKchGJBLXgdTPjCnvIWksiTwzYH0j+achGWB3JfzGuGz3zoCOrS4KbIwMdtkOl1AdJXpWwBAb6Rz73yxC1/h68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYmX8GNzk2hhjzacqwVe+rd4e417YN1Rn+qmxJLqH5I=;
 b=T9fVe2hg0RLHicACOzxCvmumbtytuBZPRZelPCgXYp8X8I0GmkggYWZrweoXEAchvlHCF5RmD8/g5NGOseS/3jN77Q4EGgoVf3oyRfpT/4MZ71+loS9UoTNg+7y45myNVR5IQU91f3apRSY4AP9Y02PPIAIxEQu7BvCfwEuzFNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:00 +0300
Message-Id: <20220923163310.3192733-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 782b1eb7-0857-4df8-3378-08da9d81585d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2uq4dGUC4A41Nd4nC1FpPDxpEMiqhEWeDFcQeKjImoj/R3GpiZuD6nmt7iFEfnB2DPwVIUAWo2LksuqXpymvjpe+q4wts/VmrEHRio+wBmj7AOhMYerTo+hwdcrQN6DoVV2+AURCK6wZTvO0KtCCz1uQp/RcMXF5eBgOnMNSmUUnfmHZJbqiGVaj+vFyuNAUGNubwJIX7nzNZ0AsGiwFoVp/mQ3fbAbtXQGLHvmMM515VMAHud1y6JfTW0uKaKTr+qkHGNd9nH1OLLi2cEN6KBmwatta8EAaT9RkeVYjBZaSEPrsVCgs2JM7Jc7ajOJdERNOat7FcRHhxVaHAGAjy0vS4zz0IrK/oCow+AE1HixAn7Jwl7D5GQ9fdaenz+ZDk6AcPGQFMtM1QRJUHTKVQMU5IVJVEkMSituQ/Ihk0AUEAGJpdmJ8wzBuXGbXY80suoxu7JUNhsiAGBkoNXvANtyqWz+J1LEIYUAL6SFJoZsZPoj+3EpZnqOzCK5x3LJ+3tZ0h84pJ7FC50cFJtws/o2bB03l9NGS7C1xno423jbfRGgoJhtGi+m5V/P7oQWE4K0n9RaIDJh1LegWXAIIcELsuEvN//fJOuLl5LWuJiSsrbFZiI4M7F6RjdxD00MBXfa/jmODxZ8OMLFJzV9ZjORVsjFwtccCNDhek3Pz8KPykKm4w3H8BGekEpVeJGoZPqmz8079jvQEjmowa/Hdx6DkCzITTjHyk2zHkQh2cIHgDcKnVD4mH9o3G4KAj+jj/bLEHM2SlJXEBrQal/mFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(4744005)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NGir6i9IyVOwh93IBTH2rlFe6O1qgE4kiqMU2xB7eilxjjxPvHLp03VNwavG?=
 =?us-ascii?Q?mLlJ+Lnbh0pJN/BJNgzxMz1T0AViSoKJ2ROcW2GT+BJNESY5JZr52EGGgWwB?=
 =?us-ascii?Q?dfV+hqxGsQurrIrAO/cwDj083WR3QIiLg3A2RzqZoKWyS1ePYC9W7QonRtPa?=
 =?us-ascii?Q?Q5jW1GD09HA4Yy6KNNjJBHbwSGXmh1KJA5x+dvQIlaaLHAxD+LFGODwiS/e5?=
 =?us-ascii?Q?mn2xiJ+ebddV4dGiy9ppqj7mNzDbSpxpWn/2syNDmk9YvcttSSRbgBzOoTi3?=
 =?us-ascii?Q?Y9jgrj39sjpsL8JTAy/GrLv64SDvaZGlaKqI9iXxnA9nCDYQz611U6Oqp+ZO?=
 =?us-ascii?Q?9BU2M6ct+aTbAFzjUqPo4UZG1KCr/R99q4h22vcWF8jGyciW2rtOoLcjntP3?=
 =?us-ascii?Q?m8I9vv2l/jVeix9g8W7DOD9QTz9PFSBv29t1+baiYFD7nqX787ISrgFYmmBv?=
 =?us-ascii?Q?aVceB/9d3R/7Hh0UNx8ZSC01RXdj4YZG3xb5QdhWn5PsVVcJJvTzK2oxxWVF?=
 =?us-ascii?Q?f2cmDmIKKEVUGlMuYly2B4AHbi5qejq+jfVDH42d2fXcjFs1c9nVS6HxYP0i?=
 =?us-ascii?Q?LJzlwQAkq9cYesC7686ajBU8yD7Ok83wMkuqlxrSNdXGUcdwh7zKbS0rKJD8?=
 =?us-ascii?Q?8Bv1aqobiqvMJ5ki89Ct+VGJYqJ7S1qBTeuOzfnVl3//AgXcRNMM59ybMZmo?=
 =?us-ascii?Q?kNV6DQd3yrA37dq+AVcXMHJdCelwO6er0x/UMqWAoH+Qio1ChlI8HG9lv9Ix?=
 =?us-ascii?Q?lYeVMRIMq6F4H6WJgHsPdt+qAydHBqXbHk5TV5BE3TuZ4DM4vKfMWZeyoZ4i?=
 =?us-ascii?Q?aYL8SY6JotpPqdizt33Fiy4FqcfhWkdSp0BNmXG2Xjn7LS9cW5cBWvSPo5Or?=
 =?us-ascii?Q?2ttQzwQgDd4Gtulxd5BFY3md/QDzEjVEj0vpxosAGB0HL5jqk8PrtZZUDEov?=
 =?us-ascii?Q?NecaNi3JSE2uL3TyHSldTdblIId3sCivmi5Jw+rYgtM7xCqPH9GGqNNZ+cSf?=
 =?us-ascii?Q?CUnTAVZk+tYphL3r9PFGfyiNxsLQfYo6KOjk5MVVbcAz8Gc7YtGDi1wKsIhg?=
 =?us-ascii?Q?IS+FRQuwj3+Kj496YehP10Uww45BL91HF8uE1z9gvNZp/VbqmNIWyb2yzBar?=
 =?us-ascii?Q?QXWxZVML25BSGeXe4fpFB2YbqQ0W7n1uPsNcDXFE3y6vgPi01qRyMCUP9MwK?=
 =?us-ascii?Q?oZEtkSEee74Xu7MQslJ6Hd0zqbeJdnQnRR27PlHRcOZJf9+s9KnLuFPY8Ouv?=
 =?us-ascii?Q?TIVrua/4n9lEgjdnyLwY0HYSwOrHkmIRMMFokCmLnT9nMEMexCPL7qm7jKzs?=
 =?us-ascii?Q?W73Z1vP+ugIKambUNNZyHA35D5GGeG8PqxmSaXF8GdlldidjL6d13nbOim2r?=
 =?us-ascii?Q?OlntqMXSvWv/QbOU2lBVe8XDKRYXwtOtPw0p/ldNQcOOpXdpVX8R4UsO+e3O?=
 =?us-ascii?Q?kdwkPAPBafUaFLqOXzZxemebjVBTmkNH4OvGpLoQ5MKfhrvQnltY1dhOFWTY?=
 =?us-ascii?Q?3dj2ZhkM2t1Sfl5R/i84jsT5ZwIk5jUgwyjVLr7ysE3EGDZUmLL6gAOXHdVJ?=
 =?us-ascii?Q?IH39ttVDd6JlpKa2k3IztBclVNbEE3NadllzXujwsSAYlsdov5JmVBSX3vWc?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782b1eb7-0857-4df8-3378-08da9d81585d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:28.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFnj+okgWkNX6u8LwttD9vNNK2phhMkn3F0KAW9FFPNHEHQq+eK6cvChYQby16b4mPmGMfqLUGsr1aQsB1BvXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/engleder/tsnep_tc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
index c4c6e1357317..82df837ffc54 100644
--- a/drivers/net/ethernet/engleder/tsnep_tc.c
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -320,11 +320,15 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
 {
 	struct tsnep_gcl *gcl;
 	struct tsnep_gcl *curr;
-	int retval;
+	int retval, tc;
 
 	if (!adapter->gate_control)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	if (!qopt->enable) {
 		/* disable gate control if active */
 		mutex_lock(&adapter->gate_control_lock);
-- 
2.34.1

