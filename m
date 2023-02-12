Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7769378C
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBLN0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBLN0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DDE10434
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWZGe20A3YK8CfHMgPr3exSJgQv3lg8onnWsVertGMINa9OrszW5Q5onZURNLKoL+iC+cef9TNInjqORfBQOnldOaaWpad5CIj0R2h64CVjP5CG6J0eTnM+z3YhlR7JyqKRREE6Js/88BJNdK1GSr3Ae4Fjgc5HShIMdB+nQXXH4TkuvbBO5jAz8NTDqsFgeSNupY2CHogU0kMNP7Lvj12HkLMFq0wHAng/hdmHwhhUJDQa4szR37Vgaut+mu5l0KTmPUZ0EUqcf+i83sSUEeJaRnh+0z40xcoCSoQEUTzl8CjEdzWXNwTakLgLXYjdtsw5v6FI2dpVx28pNGIJ6iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybXRsN9IdmAMRe6MgwX2bJhpwIeFFRbBYLbKtsV2l+4=;
 b=fjRHVLRBd8gpNvQfxkuVP6a5sBvgHeF0ri7IEVaACB59oAT/ND9evMlQIbygzMD9LvgL21WPaf8dCXLgdPSQpeq1MoVcW7+yl/4o8wo/xlLED32Z/0yDuzV42cWi2syrV058nAzijtfnGgI3CmA4E0s4OIXyU0CK3wuR0DHEiS0wzuk4H0RAndJFTUYyim/Wthq1ZXqbC5fJPU+3OnCFPjltONlsjtW/ODY2euzSvN5OmJekBzVObAD1G2GNRsi1nBvyrMxmkpy8H8bKBBPWZnKaQAKZLk+mqxtiWU4Nfp9iqQdcWTkRi2KWuAbNPnnWGWKs5Iqv6j7ZfLFQv4QFmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybXRsN9IdmAMRe6MgwX2bJhpwIeFFRbBYLbKtsV2l+4=;
 b=g/o4O8x70QvXfwtctMh4YWDB+OjV3SIsFDjbvpTE/DZZ4hV08qbq2pGqVYuZxJ9s0SDLdMSid+MESz9qovrF1Hp1RGBNgxgirQW/rysQG1kyCRDgVN4fs/DRYYVyawOMynXTlE61b+qMBU2FWRAKp0moLylDbNaoo2fM9B+G1t7qYp09g20J+60v1prVQA/LsBr34U0J9b4yt0vTfgtJx+Y0xLwE7cNjKoS5in8Hh4D8Zwt+qJMeXhMuy+mmXuS7KTyKXzZQ2UM6O9ZfMdYXM69VtXesfePUiqkzWyciruErWPIpoeO7IJYy3OpQHSpMQYWWp+FhYipRzHm0qN/ihQ==
Received: from DM6PR08CA0046.namprd08.prod.outlook.com (2603:10b6:5:1e0::20)
 by CH3PR12MB8258.namprd12.prod.outlook.com (2603:10b6:610:128::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sun, 12 Feb
 2023 13:25:58 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::91) by DM6PR08CA0046.outlook.office365.com
 (2603:10b6:5:1e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:25:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.22 via Frontend Transport; Sun, 12 Feb 2023 13:25:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:46 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:45 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:42 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>
Subject: [PATCH  net-next v4 2/9] net/sched: act_pedit, setup offload action for action stats query
Date:   Sun, 12 Feb 2023 15:25:13 +0200
Message-ID: <20230212132520.12571-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT044:EE_|CH3PR12MB8258:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f53d647-198a-45f7-fe24-08db0cfcad35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Te3Eg2+ZKuGf9j8NK5Vx9KYmd3lK0xaGjizFDW0U4+QAsUKlmBaZ/3i2jWtY+gqvbDwcvqu1tCnMa6YG8r1e9FWiuYwVh3dxBHf1/uoYzL94dZCW+VM5eauxcHXbWCSMGdiVfuzRZfeWBCpBn9SDYUJB7T3857P2GQev9d9/W53LfSnj+1zFZKfYRXBXYt8EJVg47BdUi/gdy8tCIbdkOCy+WaXPAOfw6/DOn3vJv6CY9wc2AfgL3LNzUfPm+skWsFSHc0SfPRccIHHbJfUMZ9KqGU3PKO4pVzo579OgLvmed+pckeSfxHCDhW26BioPSq3sZQAn66R8TBZVHSB/+2akI0uZrOkNXRVpeV4UhWihN2U7wKDBI8grEbu5PtG9evQhkGTowF+zFovZ6SbufCwAexdI8XIlDamI3ibuu2V8Zm4VuR/hszCAlXRdHF5dZKtOeNA3duZvZj1KWY0nxwxCD0sxOfD8073h/Nl/113NzeK8y+hRzAbAZdTzBDc3H0RUPFsDO6sFuhk+jBZNRkOHJX1dZjolLADHWKFpA+uEWX747OSRYW/tz4LEjYUTeLFJ4GgK4Mmf1W0ajcGPJoumzyJZjnBQ8wVCD4zA5Yf3f78GvsVX3EedKDQatLKAp3DeqqEf6ncyMx+B4vraFgXzcXmIT1qSI2Q+/WKxbhepOM0poK2mijPZfQhkRJ0wvgxIMdXVaH+73ExB8noE1g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(1076003)(6666004)(5660300002)(82310400005)(47076005)(26005)(8936002)(426003)(336012)(41300700001)(2616005)(186003)(36756003)(4326008)(6916009)(478600001)(8676002)(2906002)(70586007)(86362001)(70206006)(356005)(82740400003)(36860700001)(40480700001)(54906003)(83380400001)(40460700003)(7636003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:25:57.8783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f53d647-198a-45f7-fe24-08db0cfcad35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8258
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single tc pedit action may be translated to multiple flow_offload
actions.
Offload only actions that translate to a single pedit command value.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

---
Change log:

V1 -> V2:
    - Add extack message on error
    - Assign the flow action id outside the for loop.
      Ensure the rest of the pedit actions follow the assigned id.

V2 -> V3:
    - Fix last_cmd initialization

V3 -> V4:
    - Compare all action types to the first action
---
 net/sched/act_pedit.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c42fcc47dd6d..35ebe5d5c261 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -545,7 +545,28 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = k;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+		u32 cmd = tcf_pedit_cmd(act, 0);
+		int k;
+
+		switch (cmd) {
+		case TCA_PEDIT_KEY_EX_CMD_SET:
+			fl_action->id = FLOW_ACTION_MANGLE;
+			break;
+		case TCA_PEDIT_KEY_EX_CMD_ADD:
+			fl_action->id = FLOW_ACTION_ADD;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+			return -EOPNOTSUPP;
+		}
+
+		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
+			if (cmd != tcf_pedit_cmd(act, k)) {
+				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 
 	return 0;
-- 
1.8.3.1

