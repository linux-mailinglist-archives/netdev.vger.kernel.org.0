Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10586817A5
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbjA3Rco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbjA3Rce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:34 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2079.outbound.protection.outlook.com [40.107.241.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB1F2BF38
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOUhpq+xnIxtcJrRzMy7PkEuQz7tAo/BBmUDqDQhj5Y3WqF/TYsHEILeqNT0mQ3rWTXQ9Fw8j0DXzJK0Y3ixlzNBHpmoC/9i8+ySphV49/SQgMDxWPOomF3lrCDpuv44I95oETKXUCXF3DLyZzZwFLgJTpHb1bHNXSr8oBM/8qMridWNNzB8P7DM0ZujYWVDyNrv328pfXWd5JpL6/+ZFKwmCemT/jgG/xtTD8frZSkzAD0hBNFCb1nRq0Xt9dX+b0BzzgJDBoLEcP/q5zbSQiOz+orqMjBcwoddUu7gv6J1JRDaXeV7B2/iIYg/YibBKUwQFHOmjsCnb1vonD25SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRXHzERPOVSS+xUMtst8SiEDQILJkv69ROaXLH6nLvk=;
 b=jF8X/7Z8q0ZMs/tTnllRnDwp4x8NcV1hzJ6eW1t/Lvgi6fUXEqMJAbOOcuP12rpm/YNlFfKbwumLMezT8IFOnUnngjdaDrLO9QysgyQxoRLMeBLXWG6i19pJHc/Tz61EEJzheo7vr534SBJEkQTSdEf8chn8cMAdlLIT+m9/iUCkHehGUtjNZ+V2kqI/aM6zTgz8QM3wKvvgLoSkbuNBxYhTU1Q+PYS99y+al7YKrkcLDRNC+QWJzW73gBrbwoWF43imlbViIx6IWUfcY6n95ofrvGJ4J2L5IAb6zooWz9Zosk952l0jjm4M7DiBYQjorS5Ypo1PH2YnFD5ywK2TUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRXHzERPOVSS+xUMtst8SiEDQILJkv69ROaXLH6nLvk=;
 b=dSgIBVyR6ZFStTj5I5unDVKl4Lldy9X+3Jj2jp2oFnEg3tfnwb+l+XrX7Z0cYHbKNBg7vng56HmEUZQcmRluOy8cwby2QlqxdV0oOryZqT4gDV6K43cTYLkYbUvkgOIp+HrG1z1YewUVpZWtn3JoOKZh8aeikL0zTCl9+XsmKJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB8547.eurprd04.prod.outlook.com (2603:10a6:20b:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:07 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 01/15] net: enetc: simplify enetc_num_stack_tx_queues()
Date:   Mon, 30 Jan 2023 19:31:31 +0200
Message-Id: <20230130173145.475943-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB8547:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc92314-995a-46f7-926e-08db02e7e890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPC3o7t5U9wb30z+UVEj9Jhuf7Q8pbLrlmr3fO7EyZcbaOTVqDTVkG2YD1tBageVTMAa8lspwQfgX6vyhaebkdSyLTY3/OO2BmIhtHrCXPEKkU6+1fTUUgzitYmRVCAsBbGO3ImFPiUmoAOxCn8+EwfjZJdef68R3q/30kCgwbr9fu/c6EUvAJTwzwjIhl8CSbXFwVGxwDejBcKu2uEAHeuP24kA4UAq4VEoyc/fTGkTtegkjkwvGRPjsj0LJjYrgXz7Ri05/EXUo2UYQfwhQCPoq3f0Me0FbQJM0UKqZa6axuIGEcj5KDM7bPSZ09qtWcqyPWu/7MANWj1HS8wTlgOdDwBJ66lg+u6UoJwpNI2r5kKEM7TjaKEdVHfXTy3lMbbW8Yt2tmJcXxSCfB/jitPzjaokNJkTX1GuoTVEQm7l9sNY15HnPimS2/d6rUjUj4Ikh8F3DHCniFi5TrrtwTeOel6AqOk12mEUY3zkG1S8c35hRLqVncSh8RkebGpUKZ1Sfx1vNUodTMKthpPyIBT0O8u/kPjnJaUyKbqTAsQw95iK8rJCLICXjhejVXFXg2sTmFISqH33nf4VBaVCy+iBKgMMaN6jwVjLZuYKhnFwxr3QaDIsUXk7Xm72+5qzAdG+qkA9cy5Bic7K+vSB/AQ4psLQeA/Sr9xSEDID59uaathFowaj0KneEH1rK+8mY0hUnMi1lIBJRYToEQYwWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199018)(44832011)(5660300002)(7416002)(36756003)(38100700002)(38350700002)(2906002)(86362001)(478600001)(52116002)(6486002)(2616005)(6512007)(6506007)(26005)(186003)(54906003)(83380400001)(66476007)(6916009)(66946007)(6666004)(1076003)(4326008)(66556008)(316002)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7W0sRo08MOgu/bYUWHm28SMalOyWn2jaMAgUkOiQFQX2NIvZilUW/xvKcNmx?=
 =?us-ascii?Q?0zBM6fBDudDpUhXvJaeidsdxJFDT8XMRR4gVLBF3x+gKK6was7CJqmSojAkZ?=
 =?us-ascii?Q?YcGNBZcI+VDG2Hc943JQhmmGnGH2gxQSm5aEWm7HmuP1c0bO+1odpcFTsMpM?=
 =?us-ascii?Q?LOd7hVRQKfQZ8ExAOU6Fuoc9Fy+itdvQzusonts8zh/s6l+rJqeVgUp1WKTa?=
 =?us-ascii?Q?ZzVW8K6iVfXBPr/fPyUTUq8yz79r5KYdbnXVwCo/emUFISrHFInInIMGpD8X?=
 =?us-ascii?Q?z0X7AKo09UBWs8r/q4gg9JuElaZpC+meQJURftDxdoEdCDiX42Vh0h9MA6Oh?=
 =?us-ascii?Q?tiBVdZ2D2ztu9NGCLt9hRpkkpPoRHn0bTwh9q+WNXWuXszQJzhaKj4RuUSCi?=
 =?us-ascii?Q?Oaa6ndZCevmuvhRSpYzC9HrQizHQXsNNTHpY1yqx8YwMGnGXyrLG9S1zvuE9?=
 =?us-ascii?Q?xX/ZEjQejuTFWj5fJzlWrilngpbla0rBmNCjH4habszPY4cm+R1I29ir0vyJ?=
 =?us-ascii?Q?msTl00k8I1qaj1+CUIZaD/bo9gtW5xlsBBFogL2T5u5rNvmQRQwDQ9/6gXqE?=
 =?us-ascii?Q?xiVOA/jW0I1RlFJYX75CVsjXo1Fb0HjwTTLaTsHWUZAQjEAtT8F5d0iTSsvw?=
 =?us-ascii?Q?wWfZuW52MCbl7aNQVecboiu7ouJ6ug50Ce0Ib7Y70+u+bW27QcEgV0XoXM86?=
 =?us-ascii?Q?WAoTVpQ4ilA7c3akEyic+L/6p5n6YYzeXQBsF/ia+CerDn9rHgo6hU0qN20z?=
 =?us-ascii?Q?GwlvMdQ4JG8F4/LBy+P9Uf3WXjbJiv9Y2R9Xe7iFCvhPHuEQkDZdNKo+j1/c?=
 =?us-ascii?Q?GDahBIL6ArC/JyzPCkE1FIGmfR+HC1tDZkG2VNgLJ3NPqdrG4i4+ht3QqZ9l?=
 =?us-ascii?Q?PinGjvBRfwFqi37HoHP0/A93LADXDh6+APjRRj0AFEGTFv821chc+P4YU01o?=
 =?us-ascii?Q?W9K/gPooBuvyantlwuqofDK2QAZGLmr/jXBkyVTmrJCI6YnRGxwIPvryVkFA?=
 =?us-ascii?Q?t5+LbhUCzEKhOgkc5Jy6x/KbnVeSJwMVzbAeNMayY7EhC8Pe6SfUq2uJsRmx?=
 =?us-ascii?Q?25BTpVfNvaWIkyUFClZY4eGkReuqYjMj3BPKuNn4p5JxLrmDWrWdwoxsU6k6?=
 =?us-ascii?Q?0BBhdAVCZCvnefoOV5NEddrOtasF1n+igkQYHKP6HeG6nFkX9IF+61b79yAO?=
 =?us-ascii?Q?cgh++CRQJdqtVRB63JtQTmmPR4g5TRgu8IiLmgGrC5hg/uU7tVkSTDFbhFKE?=
 =?us-ascii?Q?T+z090j8MYLhAyJiqm48luBD3yhFyTCWjgeJvFcEcSsr541hdooE/7g/1UzB?=
 =?us-ascii?Q?/dr1aQ7RgzS+bzaM62a4JRIUuvKbhjulTER3bfPychn9525XZ/DLtSybBJqJ?=
 =?us-ascii?Q?UapqNZHGwMew9L6qZfVWRX1gC0CtzvsY5cavL7R/OvwGI7w29Clmfkd/gvYV?=
 =?us-ascii?Q?q43fAgL25+5aG+1nZzMDEEaQXGVHSVJkzMFdB/fTqJ0UyKHgxuFZy0Ru6u0u?=
 =?us-ascii?Q?gEGHw/CPjXJFZlgMQ/YzZ39md9xwox3YglZkd57443RKyG/PQ1+f3b5lgzXW?=
 =?us-ascii?Q?9wwQO9vm3sQ/0j/hIuVmIZ18uacdSH1DflqAO/uh97/7HHhhAMC1+RzU157K?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc92314-995a-46f7-926e-08db02e7e890
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:06.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Dixacbt24YRTshjyrDPcXQc/MZHZFW/0lFgNPpic5JvkggvY8cwbxy5jiRRPkmymHjQbNfAp/jgeikzYGZXhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8547
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We keep a pointer to the xdp_prog in the private netdev structure as
well; what's replicated per RX ring is done so just for more convenient
access from the NAPI poll procedure.

Simplify enetc_num_stack_tx_queues() by looking at priv->xdp_prog rather
than iterating through the information replicated per RX ring.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 159ae740ba3c..3a80f259b17e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -28,11 +28,9 @@ EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
-	int i;
 
-	for (i = 0; i < priv->num_rx_rings; i++)
-		if (priv->rx_ring[i]->xdp.prog)
-			return num_tx_rings - num_possible_cpus();
+	if (priv->xdp_prog)
+		return num_tx_rings - num_possible_cpus();
 
 	return num_tx_rings;
 }
-- 
2.34.1

