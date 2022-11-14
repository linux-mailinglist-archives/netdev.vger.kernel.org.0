Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930B76282A8
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiKNOgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiKNOgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:36:09 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2073.outbound.protection.outlook.com [40.107.103.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9950C63F0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:36:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNE+Uw4H6aiYREtRHAo/ESN3wP6ZH0vMaL1rdQlSzvNpoAKW0XVLmrIhuVBBSSBXQODSmnzqlLED/rH1kTZQveMYtvdTtNzuSlFTROysYKVGrRGnlrTIU2zXV4fZ0unQGHT2ScQfp//V+l7MycRsVrOAjWyLk0Smn3E7hOqvv8jSMnogkXM+Zm57y00rk9061c7g46m4murWehtpxZ+UjEEY+dTr5ebQdrpe4zoylwwwq6IFaYZOZHNDGqaEsnpaODKHH3rAPZNfu1qIj+X2FdtfhO3ifZFfUx3BzQ/MfwwVHxmOZn/2AzO0N3O5O4emfPYdwrPGk4Wwr2uUtlC6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+04US4dCgC/3ghBfESCvPfQmG9tSK9ToZp4Q4i/YbCY=;
 b=Il8FKCXEHcZ5va52jozfmX3jiyc0EeFeQ9l1UBmlitjBhs2NJJjTFoHz1x6jVyViEWJXTgImkXCObSsAf/VA7L8emgBhgne3JpNkHIUuzaFxmcPnskawD50rx1UMIUWBvwTqjsCqLOME1D0eF7oZ4vcqZAAbBinkorKPwGk13Q/IdXP/06mGFboW3oZAjdeyvmhBu39yvAOm5HB4Dq5ePRUrd6Ax7/nOHDNN8yljI5TJFfuGAnIa3pA/SQkRZXRVZaGMvpzApT0h51KEuCcHwhCxxKnNm94OmpRjdIotbCADzeWa/XSmQ6aVqqYuxgJsuj84nobmB5tU9a+ND9lD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+04US4dCgC/3ghBfESCvPfQmG9tSK9ToZp4Q4i/YbCY=;
 b=amV+DMjWjSpBLQ9ckXVIGpHjQNR3Pu2B3mb1I1oUAnxsTqb/Zcc9eWfUpZ5GmhRIcj9o7Xx9YSdygenJzadZL6EnpAvrQGIbipN0o4n3vCh03qq8H36M8edRHA2ZJ4wCc8QcOQiJxdfrHE+VgGEvD5w8ShOUMju1pJlOKjtbfK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8857.eurprd04.prod.outlook.com (2603:10a6:20b:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 14:36:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 14:36:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] net: dsa: don't leak tagger-owned storage on switch driver unbind
Date:   Mon, 14 Nov 2022 16:35:51 +0200
Message-Id: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0059.eurprd05.prod.outlook.com
 (2603:10a6:200:68::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ae25e2-14b8-45d7-0f21-08dac64d8e69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSVDvXaim/M7LigRn3jG8JiV4h9ceZ2WMVMsFlrL7mbadZTftXKGcSy0I5exczLmJFZV+OVidXCzgB2VZTyiq2OIxvZ8eI9UEuKgPXy9tzK7ZBTgTjvUmZWzAlyi2ryErLJxyziDVllrDe6ejcxSdcbOfYtnOTqIyORvfhHZ2JVOe9FoZLEFtquJiONf/sKYmtEH+ACijhyY6RfXZYcGOkV9bAZniw+CYtfEUmUQFZbV0WMyWDNLwF8GnJkNU82jz1q7/i/E5zKWJaeW1dw7YGD2OehrlkEnfNUBgkmeFkpat0gXfky2JP8I8tCV0U6cNNVRpae54ItvOIMsPv0q0lBPBAqyBwg1ySMKIEijOk3XCel4XjBX7TVVuPZkzFyZFHpT7eceYg/yIfy6wdbpQmqWn9J0qITFVh8/F49wIhQmXgTAW+eVE1dLzX7m4k3yPxT4coVtQrl0xSAFuSboVomWQbNi8jK9ojObTWRzsx1DjvTMnsUNp3IMcOZuyLhTTj/razEMIDp3ZfaT+4E56zJZaG/Ejt4BaSTLzpn3Wq+ghCXZktJVFyAatOpg2RqQmsgP4mcanFSTOQ4zxAL0UsHiwMUM9rzwbbZtBkXVoH0RyeiNAGZL7tQ3h/rNz7plmxdO7cX38BHEK3qJeIHYaic6BgFPZGCIRg1OwPKGt3u6irTwBQZ7CkBYpgn5eqUyZFa4sMYFCEVwsEHyIHWVd0s/ca986VWEelGOBXICnQHtXostu3zYFQ98UZ3nZvye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(44832011)(8936002)(5660300002)(2906002)(41300700001)(8676002)(66556008)(4326008)(66946007)(66476007)(52116002)(54906003)(478600001)(186003)(316002)(6486002)(36756003)(6506007)(6666004)(6916009)(86362001)(6512007)(1076003)(38100700002)(38350700002)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1rXRUogfZ0m5EWbNXW4MD0bWAfhutzKBGvXDpANkbMt6yLZNCEgrajY3AnG5?=
 =?us-ascii?Q?hmJ1Le/4qdP4oh4NcWSobf+Gx61ZQKPccnfnmmpnZ1ZHmJ8FpkovpoMBcTJ3?=
 =?us-ascii?Q?DHYktjEHoS+Vcrr9jhGgn8GweA3WGCXcolBRMONnRk7l1il2naEo+ClqcBGr?=
 =?us-ascii?Q?zOGC+P1cp4FS73G/FfquwZEe9ezrxs6+6ds6JK/Rxg8szJ+glXnwF25yKAxu?=
 =?us-ascii?Q?v4GfF67AUAjdclf95GeE57J1WN+Y2Ko1DwEAIO+in3SfWniY2GmOiyajgI9E?=
 =?us-ascii?Q?ta/Fo1l9AdpikLJjlQL7OyBd87ZXRxc7iQU6vibzZYWSL/UJh98zglb5nlKm?=
 =?us-ascii?Q?DFyRFsbfn8llW3XA06wqEyeKepfIhvjRuHg2Qf2AllKPDIA2ub2oWEPYTS7c?=
 =?us-ascii?Q?5s6cSORidjPMaAJ84tqViGOCAmZtjlU7wi0gczt6ghei9X7JzwDHAfV5xTYe?=
 =?us-ascii?Q?MiT9Zfvnrxxkgj5FT6z7ds2vDchtG/ZDQJvWq8WhI2DLLlPNZKFeQjt69Tgc?=
 =?us-ascii?Q?tkrQvqaYxf1ucB1bOk/hWZg2wqRi0swrh+0wnG1kvid7yxqYtrl7Ebcxalq2?=
 =?us-ascii?Q?KiC4OxYqORxknsd2vMna7EOgtqAZ5vy3qQ1T6bRSRASOuHe6O3oFQB/0wx4K?=
 =?us-ascii?Q?PKM1ovQbl7V4idUTGqhFtlZeRKzOWLTa9o7l4nLckf1kAmLrMo7Rx2vQIWzn?=
 =?us-ascii?Q?VgF6bNoS8LyuhjM3zrgRMBNVLUsh9F8HWSWIbZW3X/HLNK85yY7Bj5AJS8Vb?=
 =?us-ascii?Q?1n1nIMvaW0UELWK00PQ5sfmkBGnIYLTtZFNzzB9L4xHH+2YrZ/6s6nDuAJnu?=
 =?us-ascii?Q?OGOI47OX3IBlxiD0Jcu5PezmrGP3ZftE0Y7PQmSZZhHzFR7gyT837++YQy5B?=
 =?us-ascii?Q?jjOC0TulXX/oloaAPoYd/3BKVQlAVTJ5z53yGm1+vt0CRG4RbONwXp3Ri0+W?=
 =?us-ascii?Q?+dya0VuM4pRPLQt/cx4k0izhQSg3WGnFOhnW0iMt1Eon1RtytuttwUZ6+0Vl?=
 =?us-ascii?Q?BTMm1eZ0Ljp2WN3ObpYpjEyzqDsP9Vcn5o7bKTLF2bJVj1f4aJtBrmSi2LNY?=
 =?us-ascii?Q?sz8IEGmgWySD1fJXV3VypREZVvacq5Y3AHSzFvfZSKGWBnxKJk70OExV16RH?=
 =?us-ascii?Q?g4Q9f/qrw3v96VSU77tgoKLp8WL4REKK3MXw9tiOQCbWfbSaaLpiFbJHPb1G?=
 =?us-ascii?Q?JvHve7ekd4AIXQPCpTaGpRokVdLUv0a52U60TLT+f599/0wVX4PVxXzEqzzv?=
 =?us-ascii?Q?gJyw3em+A4bBcmHyGzP5+JIluGrtTpx46PmINcYeqESQX39g0TvIWNXIs1Eg?=
 =?us-ascii?Q?G/8panMcUKBPUpV2ehkfzo8CeG68UtHhrynj6WenEyE3A6tSV04VjoQR2qLV?=
 =?us-ascii?Q?d2Iy/e8i2DBsYVm9tKNn67V1XiVbvRm1kWnNJiC7O+dkJJIwt5A2NsuwK5Bi?=
 =?us-ascii?Q?u1O0L53P61f/ry8NUZYPfEaDv5olr+rYF0i1qHY6MegVNLWeF++/sA+AAU8x?=
 =?us-ascii?Q?SXWTEz49VfJc71QV5l/p3VnEc8hIDz4UfeZKgYNsFFXYqb+SrzoTngqb3D8A?=
 =?us-ascii?Q?iQ+Z1D0VqjTO6eQLJDOiYhTTKqvOAK243DLyqL5qT7u//y0OZ5bzErFc0fC/?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ae25e2-14b8-45d7-0f21-08dac64d8e69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 14:36:03.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lURIl+I0UCpYOamJ9Tv3y3yIewA2OD5doJhKEItnSKqkHyfXrWzy0Sh3fnublf3KyBpRbqy2ot7o9jiYjv/4yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
storage for private and shared data"), we had a call to
tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
tree teardown time.

There were problems with connecting to a switch tree as a whole, so this
got reworked to connecting to individual switches within the tree. In
this process, tag_ops->disconnect(ds) was made to be called only from
switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
changes), but the normal driver teardown code path wasn't replaced with
anything.

Solve this problem by adding a function that does the opposite of
dsa_switch_setup_tag_protocol(), which is called from the equivalent
spot in dsa_switch_teardown(). The positioning here also ensures that we
won't have any use-after-free in tagging protocol (*rcv) ops, since the
teardown sequence is as follows:

dsa_tree_teardown
-> dsa_tree_teardown_master
   -> dsa_master_teardown
      -> unsets master->dsa_ptr, making no further packets match the
         ETH_P_XDSA packet type handler
-> dsa_tree_teardown_ports
   -> dsa_port_teardown
      -> dsa_slave_destroy
         -> unregisters DSA net devices, there is even a synchronize_net()
            in unregister_netdevice_many()
-> dsa_tree_teardown_switches
   -> dsa_switch_teardown
      -> dsa_switch_teardown_tag_protocol
         -> finally frees the tagger-owned storage

Fixes: 7f2973149c22 ("net: dsa: make tagging protocols connect to individual switches from a tree")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b80dbd02e154..12145c852902 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -855,6 +855,14 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	return err;
 }
 
+static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
+{
+	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
+
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(ds);
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -944,6 +952,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->slave_mii_bus = NULL;
 	}
 
+	dsa_switch_teardown_tag_protocol(ds);
+
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
 
-- 
2.34.1

