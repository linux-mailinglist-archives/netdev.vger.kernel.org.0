Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ADA5B29A2
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIHWxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiIHWxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:50 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2121.outbound.protection.outlook.com [40.107.20.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB1129534;
        Thu,  8 Sep 2022 15:53:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDQ2kLgQtabdhej5F6zDtQsWL2oqL8teFIO7yxs49qUcN5FPSYuQsxRHxNqUkwvBzId1ZL8Furnad9OHz5JuS51U94u6/MgoEGVdkpp1iVtYi2j1yCtNApY8RnXN2Cuhvr/dCknuxHbIz4WWZ3t6u1DN156g1Zg2/DAG2VXfukJZn0xMIMI1JOxUBsdP65NrPxN1wE5jsNTLCKYyLjA4LuljOjg8QZGfeAXZeyYOH1ROFuI3MbrLYvtKxc4JQnmX+ScXUFPw43AAlZ7MV+DpejDr9+yeHj7XkjRTZhBcq74nmLV0VoKQI61hTvnPbf34QglpQVluDtW82d4r6Iah7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+d13HuuiJuhC6xOlB1N15/82FVK3LEbjcNI1Io4CUA=;
 b=mpib3BSuncrlWLR+8SbsOkODVKflv06EXggrvGrt4FsVhVoLjxpbImH4MwVXmUeclMLpT1fBkUqGRy/oQO24Uf7Oh3WXSEJvCLBai3f8IcM4jItgO/aB0J7yTGDZ260ns/PgHVtHlVTEUaI5bivPnFjzzwqijEqSEDnoWjpfIJTRqXp6/snV0w9dPzyVADLFln0PMMLf69cSBeRlepP3IjpYuseXZCCuSF0N35x9oobA2hyw6NcM5qMPFHmOEkXSMHleii+L06n+AVRnj3VQCAV1awH+x2rluJ6lL0rYHxdW8Er68KPvb43lN93CP1EEE3y67NCywuM7pHRfQmqi2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+d13HuuiJuhC6xOlB1N15/82FVK3LEbjcNI1Io4CUA=;
 b=KvFtTOycOnB7A+85J3ASet5Xz9SRS14PjHgBBRwWOAPQeXbPW2W4jqiEUPQrqL221mlTFH2NH8o/iJCwkEibVTD71EXYWXlHTPfS7C7ha2G+xPkM8+lz39sQGf1x5GZT/IsL0Oa8IqDRZY2GcpCKnnvndGjoTqQcMebIhA0mcmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:35 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:35 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v5 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Fri,  9 Sep 2022 01:52:06 +0300
Message-Id: <20220908225211.31482-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4cba8f-e4c9-4023-0990-08da91ecf5fc
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5DfHGA6CDfwqbXsbY6mVzDDpobYtFpNWFtoMyxfnaB8MWETGKTgomHeamUFx5kfU4Qrb9kxH5GxU8dJaF0YToBqNkXvWnmXpHcaV+GlVAR+OYYWkw15rgS5zks2oQQMU0lxPWsupPgP9CXTDPv/yAuoinbTtZjcdjmtJqH2/BGNOgk0i8WFKv/+hiWc+JKJsdZJFNtGMc0aIhW3hXARB0MDUL2doGqQ/v3Z9gqoizUFY4mZBPD5QgkVDY+L2KIP1tie6Uwv19onFCjXxz6qc8u0KO5rFp5qh+5AyuPk3iFakrMBCkz3DxosYgYrp8o1N7s6biM0chtKW5yvGPQvV06uNYj6q79tCXEAWlYPW9iavWgCqGoVNOI7fQCfZvsXkWcLpr6u2wf1cx4ct6r+FTQX/eClCuwy+QIOXxu7kpv5Up6CiMIz0S11Tpp0tkTMGOWWF2t+BO4OCCX1npYy8L6hFgP7H0APDO+NSap/WLYw21MwDkxcBht/LRZFRruwwzQb57IB4zuY4jeAHHIuw+7eU9EuTRjrBCk6LJQWFaMDR+DDB9NAiimvn/f5kQ92CZg3R0oJazQJOv+Kop9UiVQPIdOYsJOKuYxtGthnzjlH+5dJy4jmv3Cky5k0+il4cZs6W7wz+lokn/TFkDNbSSBIm1K+f/klYvTE7Cku5yfwueyB2GlloMWIZn9ch7Zkb+7dIzBqhm53GAT57Dy9/uNmkCH9wkIMJ1dvLx4/yQ40VJxmueorSnBwfRLeYNNfRCod3IXEtqkZTmnXIEG0GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tfYqcUbrB9PTLQkOxUX3s/kloGTAUCiq9vaQ6Lcy7gLfgcCh/NrLnyis0r1h?=
 =?us-ascii?Q?23g+lQny8aXwdWf5E+9MyA+0C1DtMy5sYzGrhZlR6R/Kg+4aH9M2gmQSKgj0?=
 =?us-ascii?Q?0OUHImthBLHOlEWqwra1Ue9JU5WLjjYmWKhIFrJ24TUm2KT4aKtPyt/BHRYi?=
 =?us-ascii?Q?WpbuaYbuG/6DkXxpJzPILfVHOKjHX5XsW6VUH0FVNj1KBo1fgAcv0xkOYjLp?=
 =?us-ascii?Q?oXpUXgwz3xFJRuzN4G5ojbV223jZC/0tejQ4VsPwiRmWkToXX10FkSFquucw?=
 =?us-ascii?Q?3H5n0MzI9Uhz6lFmYel0aE5pmA/EEafMngEGkuKWoRqXl/3t3hS65Aks49wQ?=
 =?us-ascii?Q?coSfkqxZpGHowZnJUj11PWGzCaVbVqZGtVpxP9+2cWpboyA4Nh9A5V5cIx1b?=
 =?us-ascii?Q?HrEpgrXMFf7rH3G45eegU53pCOO0UwaYklA9UnL0177r11AyvKn2M5FTqPOf?=
 =?us-ascii?Q?/e33nNFzb+2j4jlJNzNtPJHBS8ZC3nU5hE8V71QHGqHa8lH9IOpqaF+MTsC/?=
 =?us-ascii?Q?NzkfI4tOOu+9UOC1kLVkGd6raZrRT30S7UOQHM5pa+BYg/S8B8hdscYKWUOx?=
 =?us-ascii?Q?nnbFu3adrchf1GZy3HM0A6IIt0j7cpLQTdRdNmNgLtcN3jTRU04JvaUs7tFU?=
 =?us-ascii?Q?7j2T6/B3RbrK1Z40t5mBBHs38ANauM1MPouev2JYIlw1hr1EcoGjzWTxJRwN?=
 =?us-ascii?Q?vlNmR6Q4uNP9hbWHuIa2kXkRE7XqCjqebL/XMRpEU0Nmu1AjIMTuwUJAadNq?=
 =?us-ascii?Q?vY2jygomr8LPT5Nb+9/QyYYfW4Y/M7MW6m5tTsmB5s+3YULIpp6FZGArnul/?=
 =?us-ascii?Q?sr1WPfCDx9Q3AsXEcus/UsBcULbS34++ngSCv02zalidL3GLaivvKY23dsfh?=
 =?us-ascii?Q?Zw5MOjNlkfGRgOU8GSK4er5l4qUeBp4Z8RQYWbgh8qwBzRUwwmwcJzN3uCYS?=
 =?us-ascii?Q?10pCh0PGwx+fmLj7N227z8UcpwFa7nYY6KZCYC3gNlyusX1QEf2ea6LGa2pX?=
 =?us-ascii?Q?OT4YfdEa7tjfidnLZddTghbr7bIdPj9uiTOc/jHmGEICDBPcSbquEIGsFi6y?=
 =?us-ascii?Q?xhTEzWP3EtIo93A7jxlObnF96wU9iHHoef2GKcq2PdNUsVixoNkEu7M5w2M4?=
 =?us-ascii?Q?RdTcSG6sbZLbppdtJ358/XrC5hrcIjkanrpb0qiqD4hR61FAy1aEQ8WKo1rc?=
 =?us-ascii?Q?1BFFDWHNRdV0rdUY+ku8XTvrtVFFK2aZlUaMjfjvX0j4oijpZDdC0nDhwDxd?=
 =?us-ascii?Q?HeKamJt4JRDNTuYPWg7vstlIFy6U66VW8ASIjtQstaKPgRY2oC/ZcL2nsbdt?=
 =?us-ascii?Q?KydMKpH9LFQ1fvG9eTDfGBQ2FQOcH2i3Q77j9sBNmgAk+7ICufNLK4e2r2LG?=
 =?us-ascii?Q?S1h1utfmu2HJh9yEI2UYy8uy1kdyW2S4xEdOmA9Sz3IJFY72q6YpARnXvLXF?=
 =?us-ascii?Q?/Q7nE107Ddle1SPp7wv5qPAA1Eyff94Ek8oHj8bWeLMpeMyGJyAILMY7HBVG?=
 =?us-ascii?Q?0giWcqyFqrQkM84a4rfCujSOeXio8ZFO8DJWbiqWPVkwQfAGxZa6Ke73xEJF?=
 =?us-ascii?Q?BQTJRNKGvQy8SRapF2rIwTKz29j1wLHdU7NSLq7M4P9y9a7b0okQkxFvxcfl?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4cba8f-e4c9-4023-0990-08da91ecf5fc
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:35.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: deNdTTyNOKX9YvwHF2HnhcEYTPY9fCRFej22EzLJ3+hksgCQ7eCFhZqL4JeytTH3yQEpaBIKS/ODJyLnRRLtoMxJc+lXJOiL23fs5Msw0lI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flushing workqueues ensures, that no more pending works, related to just
unregistered or deinitialized notifiers. After that we can free memory.

Delayed wq will be used for neighbours in next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h      |  2 ++
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++++++++++
 .../net/ethernet/marvell/prestera/prestera_router.c   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 903e2e13e687..fe0d6001a6b6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -367,6 +367,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3956d6d5df3c..c0794603a733 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -36,6 +36,17 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay)
+{
+	queue_delayed_work(prestera_wq, work, delay);
+}
+
+void prestera_queue_drain(void)
+{
+	drain_workqueue(prestera_wq);
+	drain_workqueue(prestera_owq);
+}
+
 int prestera_port_learning_set(struct prestera_port *port, bool learn)
 {
 	return prestera_hw_port_learning_set(port, learn);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index bd0b21597676..c8ef32f9171b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -645,6 +645,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

