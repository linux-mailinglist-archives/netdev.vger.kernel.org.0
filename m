Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7791A6756D1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjATOSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjATOSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:18:32 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C6D1E1FD
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:17:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqJz5vrOv4ztFfC1PR3EjcPzKD+qYPaD6COGSv24xARMwAHsBB7qjCXJPovDXNfzrVe9P7yIlOypKwL1d8vAjPnZqoai5GymYY1LiIgwHOEeru/jKs/hRwiPWjCqRCqUkFAnySSUrcA7MxJj4U9bl3AcgJhbQVU9XDqCGq+sA4D1CkzbvhqNXpc5gGyvvw0SROxORK2WktjN4vWWNKcWj6IqDZLN3rqBwexpHihAg8Yn/P0W9VY3u0I4iTzSJk1nePVczoYLHScDsZlHoI0/XzYYaiUPbkF1fdayGvTKQ7YTyyPfcuKdSxvPsuDIJylhdow+Dmr7MZDsmoSHSjLLXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPDAxiNESVsfapYNjRRiodB9V7EgaBsJ3kzLkpweDKQ=;
 b=gTZOF/20+cU8P77S3/bB2gF5i2emF0ArQPtEGYrIs/aKdi8FVwgT7dotlsNrlW/pi+E9KcnRTk58cP7+67l6ZTrf86zg15l7YbNJNLtaANfD4F8fP//FHeQjA5+8lpRp/GgVII188uxSw3x3HmNLASnfmqv9+EBIQ837MHNMt/hkeg/Usc5OTvGviCGQVA7Ob6WTp16vL+NVTFLjSrqD/SsHuXYOA7SIf89V/qNRh36FWtYsI/Mwq4aZ0BJdAhs3s3dtpBOWdnpXlu4aAYnybVb0HQk+F+Vn2zqhntKCG7tfnrk/sFflNXa28cFyMJYpCGxugvbJbHsLEJfBrMpy2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPDAxiNESVsfapYNjRRiodB9V7EgaBsJ3kzLkpweDKQ=;
 b=LWihBPDxbJK03r8UcRztFrrH/cMMIM033OhlF+n+TBjxP51+rrsOWo3DbmcrjJoTTvtxjkRYHAvuZrLWmQqVrR9ElBNrCMYXic/pIBdr+XecJR0cmtqZ5QvebwNJkYA6hfeUH/7Jv0CszgkEpYkHza1O0y+VYY08AdrdTeRLSIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 06/11] net: enetc: request mqprio to validate the queue counts
Date:   Fri, 20 Jan 2023 16:15:32 +0200
Message-Id: <20230120141537.1350744-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f6fbef-f6a6-41e2-3f9c-08dafaf0d9b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7hv4Gjk1A5WrPU1Zw2lxjjtlXSn/QIBPGljnU5+YL7I3A6xW6xgLc65Vejpt5nGswvjOnGnm8CQbqFGtdzwiNMgPAr/Y5xTpX8YqC8wSK936WmGFFGi/vFJ2FAujJmK1g+/4UkZTosqw8onbJmjKfv4vD1nDrvP0ldd3bKwQkxBjlS8Zh5OWXfnhBTkViWDJZRzI3Nv8BloZnPti6KE7ORmRtRLSHh7rP4tDiTtawfcplCn7r3d+7QaRJt68gwcOG5utFcTnHuQSbFkXLdi+AAh30CTLUCqnOHH8yo8PGJWvKXcxqSF6GAq2D4lc84Jlggfku1I/Ph5CjQMjslMj5s10xyu6E2HSPffXzKhHS5E/qfps1v0YNoaP5MJZaFV3z4zMux1XalFK7Ps15qP5SLvFS4f6UYYKt03ASJbydoBCq4gsFr+DfVtFZpYhanjpKBaFC0zGPw++G6WpKryK5ksF7myOC9Kh30jKT0M9cTAf5ZVUG7AT4jaPwM8KX25m2fkVvojbK6hj3SvNO7NF9pYEf5noHH2RJjUzT6WaD9kjK/LLjc1dUB21S6EHPsR9a5J5eqaqiVLOFwH0XimgARu8j7Zs4cd5HBlyN8B928RiJo8TbhPflFni9BjQU9QlvqB8g4/mOfRUk1lMwbKdpNbUbWvAHBhCipnZxAM96cphonAxMOeYWkXuZ5gwcOY72Q1xvpAv49jLrd99rfTfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4jrt0Pib7qb70j3mYTiLN2OlK6Aak59bjpIuGkE9lNegDM8OkxsfgjG/sa5+?=
 =?us-ascii?Q?pt8QjHT9mUHB8fBYkqOli5Ch6/211Xy8e2U5KEmfMLXpMnTYjHv+35t6vDDt?=
 =?us-ascii?Q?VpOdZv5+MikUwVF6Nv6MhlZftMQYoQrgBb++zW7xh7xdDE5cpSx4NTBBA8bl?=
 =?us-ascii?Q?/Ug26eA3LsJlE8pAKXfESSn6qG9cRvxdAwjVR2smav1cWpd85VrS37Z1/3D0?=
 =?us-ascii?Q?sFzYj5uiJxA8dBTXptsvRkzzxhqk+w7ABdVwKoe3iF232mS1+tKgQ6TnBEaq?=
 =?us-ascii?Q?8Gr/4eWhQ9p4rFamwhZpJO9VXI0Nq8AynAtQ2BGuKfNZq+B81oUVAw7pPbTd?=
 =?us-ascii?Q?P4v1LFOg7fHlz9ta+iPdHbrolSkV9FwHU8a/FUJFZYDLT+QbezM+cmd73yLC?=
 =?us-ascii?Q?fG3KubUJZPXhnvzICUe0kFYS+XUT+hHiOg22kxkzxBYdz0m3yaEfDbMq0lCR?=
 =?us-ascii?Q?ypoob3IfV2n7YPwF4V8DnZhz+Wy3chEMeotA3xCLdptIySvhKxbnW8anHyRV?=
 =?us-ascii?Q?dvYPb5kUiHjnTfJ1e283hrTHpNidyawZr4dF+Bodtltyz4foa2rNBvMCgMiS?=
 =?us-ascii?Q?YvgBox3LVKkMGuF8kuG2M5f7V5B5k3V1xB21IsFVqIuCOSragaph2tmYSGco?=
 =?us-ascii?Q?lxapuANkqUWT1fBqRRFn32ITBV5v/pkBsL118CRDle5qCp5x1Ud+t0eepeeJ?=
 =?us-ascii?Q?zBuGS7RI1lcUPhPVNoBq0ZARqwCdjPLWM6JF34MkGFoHE+219bywg7iSiJ7m?=
 =?us-ascii?Q?09rKUcilYwzK1h/Nu51kUX5leVwaln15gcTHxyJuvuNxf1VYBTXqn/eMexBk?=
 =?us-ascii?Q?LdU0tjiQpFkMEcjuyyF+cOEDjdb2RH60NQHRM8oF0xhNArMMcNT6GL/iLtwl?=
 =?us-ascii?Q?6N7kHtgHSngsX0r0d9eofceK/YiUtIl58VQSNh4qNbDrwwwrAOzWb/L6h4Q1?=
 =?us-ascii?Q?3MUXLlC2RA22/fXNbYRFvBm0btd8zXfezNsrPNjdsLyLGiLv1eokqgdfAoWl?=
 =?us-ascii?Q?VnXgJmh/oMKzIL1g2vON/b6R+Cqw910MXl+D/SmbhLzIprI8d63nuSFxNz7V?=
 =?us-ascii?Q?lzMqu6lqYsoz1GTg9T73+u0Kg55amu5jw9th6dlDlT4/NVJfpi7Z6Pn2GxkE?=
 =?us-ascii?Q?HmesSnNHSPFvLCkgA3QYGU4JbqNA7d3Wkohc5pHRspbE3FbUe1jNSGrN8bP6?=
 =?us-ascii?Q?zmEFpyZO43KnamLNDoMEMxn3l92XBkhlknL5UhNcmOY0myM0OozmjDRol1as?=
 =?us-ascii?Q?xYqFza1d/0VGEW+JQlvsgy8xJgvlsPLOnkUfNof9uNT1Jw6l2bxBVqrS2kjl?=
 =?us-ascii?Q?gwwhl9Nbfa7zBbWK+fln7d0kB65JiVoet1pSm2IU1nMxZSm41GgEzDRgI4id?=
 =?us-ascii?Q?sWioa4ePPkbKytYFVXMFGThyA5MP8YD12JPYi5yVr+NReYlnOJaT0+j3hpRn?=
 =?us-ascii?Q?m9aSTmZOkYiJqqzHa3pVKqXmOadS13XJJofXkebs8bDAGlUbu95ngRxtuGff?=
 =?us-ascii?Q?LRkK6ul1kJ5Bqxffu3ZMi8afDdFtnnhL5QxcJQtQkWwfbuCxiPfxZosOdfBT?=
 =?us-ascii?Q?mD9HwsOdA31cfgQY/Sg4b0m7p3S3SPzDU0/9y7WAT3KXoY8QIEkfugdaq/CD?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f6fbef-f6a6-41e2-3f9c-08dafaf0d9b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:58.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56ydJNxlqR1p6oYcxDDQTxKEYlYNcWSLODGoSKcIReGkz1Mgq+of/+CqYKSVEnQ5mkIK69IZ7g7MQduCcRutdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enetc driver does not validate the mqprio queue configuration, so it
currently allows things like this:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1

By requesting validation via the mqprio capability structure, this is no
longer allowed, and needs no custom code in the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fcebb54224c0..6e0b4dd91509 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1611,6 +1611,13 @@ int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
 	struct enetc_si *si = priv->si;
 
 	switch (base->type) {
+	case TC_SETUP_QDISC_MQPRIO: {
+		struct tc_mqprio_caps *caps = base->caps;
+
+		caps->validate_queue_counts = true;
+
+		return 0;
+	}
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-- 
2.34.1

