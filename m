Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83230610411
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiJ0VLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiJ0VLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:11:19 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2058.outbound.protection.outlook.com [40.107.247.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B81008
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:08:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+/6qBbbi+zgyO94zj1lExC5zHCuSQ/UfklIE+oL4/gEd5I2v5YAve7z37bPc/JGSPISo7jwJQGcMkoP9czOw3Mn04NKaMTssFWHJ1obgJL/EDUrU6jTxpoEv+/hu1dMNWh3tC+BkbCxvIOV+yo7+Gs+k8oZlKVzPuCCO4XGw34X5zX756FsEwri8xR7SrzIElq00hRIbVPfEQ997xJtiE+tOkbLjBa4q5b7t0SsZQ7Npll4zkq0Qs+lOpKO4oZAuxXdbqo2O241AwHQEd4kqKf2EmDHsHn7dzyapy0N9k+hLjkUXEHYD4cUJkqqJd1D3fCChGe0MnFQSAQDyBRxrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiEF6UHV0boHTHdrsd1IB8UwCQslNjjJaT2Pr+3pOKI=;
 b=JsmeP6EI2bVHHUDwuf4MQ1fVOP8BzKQDTftsz2p/HtO3FKfazlVmRsfMOV2Edi88FPXyuzSUwEVpjwyyPAe3Aio8a0tEfLmbO0Dr3o7E8ivlmIepeyX3yf/JiEkskFBS3CN1ysvMVwhBUM9Fh+mK/KFFVWinTDviwKhezv2rHgcYdlxYDa8PAVN91Ed9tOmBBWCcdLUPy2v3rd3Hzvnq3hdG/u72vNCm+yiHDuxN0gm+Ipy/g3zvPWWhRDhg4t13XmvYlX5+9D8BauEJpSNbEUlESnNyZww8bIJirLyFHOA5vc2RgEyKZL+9GMvjcC84LmTu5iaXQPcAg/T1UOsy0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiEF6UHV0boHTHdrsd1IB8UwCQslNjjJaT2Pr+3pOKI=;
 b=hf8twGrB+AX9e/ZOJ9UwSmP6e8a9yO7SugyhJyk17tey/Id+2gx+rxUHKGW3lH8rRK4SNEKga+5adlYRK+Jf1AMo4byBc6XwCe5aY7hnMXpa8kmONcV1MvcQM4Re4tcxxx65so5LEAbXw7rRy3SaV/RsgACEX7wNC/st8SoJ21U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8575.eurprd04.prod.outlook.com (2603:10a6:102:216::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 21:08:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 21:08:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [RFC PATCH net-next 1/3] net: dsa: fall back to default tagger if we can't load the one from DT
Date:   Fri, 28 Oct 2022 00:08:28 +0300
Message-Id: <20221027210830.3577793-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 421f004c-814b-4af7-8ef7-08dab85f6dce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo4JGaZXw6MZ9sQfazdOtt0UxCO2QaIeOAG+yTIiXTgSUmO8IiqXu+HeHr4lWUITQsDzu19fcs/ZnG3EkYuFvnfw8q1Pc3UnZDomFbbL4Io+ccvVgkqdPiNtCshWMAhzaSdfNs15ur71X9+8YKXYgB+k+Wq3/fNQaISel+itxrFrd9NENt3Ci15v3v/C6WXLqlJUQW0VGRbozrmli6URrtLIrE8AfqKwV2rCn5XGforYXcnfKh3zQsCyAhtBZMVMN1w4NXHi59+n2JpuxESi58ZrSSp2uCiLddP8QrBVoknhmOTCzbKyWBBIJwt4g979uwMxKGIwkQ+Vt9ueWajhBjC1nYdqJBHcKnYUWXj1cYlvjLirj/C45JNfKINGMlq+hEoLaYhSD4Ia57JM+Bfw858JvwlhQN/g3n6ZQvBopJ/k4eGetNRHnxzYfEBEOCoEpL+FjdnvmdXdEI1pWB++4RH3jffNj9hIQlE7OIEQ7Pk3zXHe8lRtsXLpb+RwtZOoh2MgQBVqY7SSow2S5/H0IEPvwObRc4tw17M/FjLPZR57H/1OiTZlxky6Df3wvrxGIKAHindhsgQtbF5U5pppQL0QEbVTWiz8sErsaYQfu+dOD/J1Hd28GmgxXa6CZMvORizs65oduPcz1YjStcRr5RYZits/OL8oOUqGekiyDgY9JDlk1oUbNrjB0aOoA2Bpx+bQPXytnZVcLUXO8SyHwGiddYAYIvWoBO4JiXLwQ0aKkKdoYfHRw0w9sy1mo8DIa/D37L8TQXIxekwjYh2+NrU6Sp8sn45zneTqzJz3MTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(41300700001)(86362001)(38100700002)(6512007)(38350700002)(7416002)(5660300002)(2906002)(4326008)(66946007)(66556008)(66476007)(8936002)(44832011)(6506007)(52116002)(6666004)(478600001)(2616005)(186003)(54906003)(26005)(1076003)(316002)(8676002)(966005)(6486002)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h7dM+rlHMYrd8ZOg//Mxrf72T3gCr5me2YDqjmLgmg+GyRFug8q9bloHkK6i?=
 =?us-ascii?Q?bbObKHqNOukXzx5xGC2XmsARey6/uian3mmK3/vbaqQCOQXWd6RSximlbTjP?=
 =?us-ascii?Q?Iaal7wqiiAsurITuoBLxim1phdHjIEUqmj5eBKE5qQug/2Gerb1bk8D1ZShz?=
 =?us-ascii?Q?5vQxsl9yUxkuGQNOEz9+z+f3CBbWzXfTHiUXsEvgCkagFbcwZg8rfTttseRP?=
 =?us-ascii?Q?zo3bwPkJuykHZ6VzTUF+Tu5Bwynk7RVoxAyymo7LJSg825DnXcbI1n3lsvMF?=
 =?us-ascii?Q?XsLSkAHJIaiPEZfxVqLIm61YfNbT+e0o0c4riMAgxQej2bk4Vt0DKzEhstPj?=
 =?us-ascii?Q?8fHeIN65eK06kuig+3UvGdgzD8ZiGMpuDJaQ/0McjNshlrmXznGq0HSzuJGv?=
 =?us-ascii?Q?YUUVxYs93AGmOEt1QToVJX4HZH8O0ToCmABkPzK3E/ft/Rd3wexCrp/Oyd0G?=
 =?us-ascii?Q?4h2e7NO75M4d3yn65F18j3DgPDqUDV5n0ZkpjxlbY39EgMVKTE3QRmYtsCGu?=
 =?us-ascii?Q?kie1127DUPEQozbJCO35Gxw096QUbw0LtX4IohoNihHOUSoiEjEbWZH9pqRY?=
 =?us-ascii?Q?au725dFMtJn4JMLPXP4i/tLekMCN/KMRRDBRBjlrUZN17KGwyJvhUxr9WXz1?=
 =?us-ascii?Q?IXkcQZoDAJPxxD4Dd+okclro7FJKLccLl4hZ0wRMQZ+NUPmVlZQVQl9YnC2h?=
 =?us-ascii?Q?DSJ9Sx7hJJNdhVtiy1wXpKYtITGg+0Q1V+Zs0xKsJQqK2Iru10hN7gAvJRnX?=
 =?us-ascii?Q?vro4KZxBJm0XpiPowCQ7Z9+QW/RD1YlLDEs+FKYqxqsgSaH2oh0aHXq2/ID8?=
 =?us-ascii?Q?j9FJtIxjgqNzxc6UYt+qYcTm5q9aF49ZFPPEmVI9NWv7obHfaHh1nsG7UV85?=
 =?us-ascii?Q?xnyIP2KBBVg+qJFQ+BI2eqoqYjNEZVNiCjUe0p4+0sApr/M5kFP9vAfGumg9?=
 =?us-ascii?Q?aLdUTU13F6DYUdcYHWFlBZ8ocpHqoD3Afkmvhj88bqPskqYNs0jURwSNHlT/?=
 =?us-ascii?Q?tlTxAXzPM8n2U+GfS0Ed4ltUQabuMWXyR0ITu/fKesM5WOAE6IkeNWm5khc1?=
 =?us-ascii?Q?N0UyWrjNo/75qm77JsIiXx5rUWVb/oNC4Rw8Wf8Z0BEDr7GC3xTKg0/yKn2A?=
 =?us-ascii?Q?aUTmp2wfKRUtQOUmol86GNZl0lcMUiWuDniz7MV+npDKzbKqf1uJGGPREHAF?=
 =?us-ascii?Q?aBE4MGudDBRZc4x3mXCpjYi/UOtfG80QAhy+RRwr5QSYmaMKDo6XmuHYx/qI?=
 =?us-ascii?Q?HLbdDNep6bMFWnRZT0KqEdGkrXnkO5W3uz06Ddt7IPwghye9kLk22NrGZ6cX?=
 =?us-ascii?Q?KoJc5pSwCj1SaPpkoM3x8G8sSBF7AtnAu28LysWb+4XQd8csnIwtJV8kD9k4?=
 =?us-ascii?Q?Q7JvDSGkQp8eyhD3iiQ4j7z9GTqTDureS8cD7B4nBf2vO0J+4/ruFUguiJgU?=
 =?us-ascii?Q?+NEs8davjZWbOcsbrYj2GtYzfR4foLHvtI2t6UkesC6CJehP+MoP71dZDQGe?=
 =?us-ascii?Q?EoZCmrivvBBq/qOjtvgZ4cYiAjI0qFSpF0FXaiI/ivNcbuvuzYZZEQa+Jxoy?=
 =?us-ascii?Q?ugZGA7IpMp/Kd5ccpL9ZJ9FIIbJoK9qv29tmXShIpxxpWdM+yl+uYkHHmDfS?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421f004c-814b-4af7-8ef7-08dab85f6dce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 21:08:43.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUYv9Gv6JTYPo21m0jOAuEGLF2OO8vKG2RuynMfvS2uCDe/1z730AoqT8c5EJhDdKma44/2Iq8TamIS09Fy7ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA tagging protocol drivers can be changed at runtime through sysfs and
at probe time through the device tree (support for the latter was added
later).

When changing through sysfs, it is assumed that the module for the new
tagging protocol was already loaded into the kernel (in fact this is
only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
and tag_ocelot_8021q.ko; for every other switch, the default and
alternative protocols are compiled within the same .ko, so there is
nothing for the user to load).

The kernel cannot currently call request_module(), because it has no way
of constructing the modalias name of the tagging protocol driver
("dsa_tag-%d", where the number is one of DSA_TAG_PROTO_*_VALUE).
The device tree only contains the string name of the tagging protocol
("ocelot-8021q"), and the only mapping between the string and the
DSA_TAG_PROTO_OCELOT_8021Q_VALUE is present in tag_ocelot_8021q.ko.
So this is a chicken-and-egg situation and dsa_core.ko has nothing based
on which it can automatically request the insertion of the module.

As a consequence, if CONFIG_NET_DSA_TAG_OCELOT_8021Q is built as module,
the switch will forever defer probing.

The long-term solution is to make DSA call request_module() somehow,
but that probably needs some refactoring.

What we can do to keep operating with existing device tree blobs is to
cancel the attempt to change the tagging protocol with the one specified
there, and to remain operating with the default one. Depending on the
situation, the default protocol might still allow some functionality
(in the case of ocelot, it does), and it's better to have that than to
fail to probe.

Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be overridden from DT")
Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index af0e2c0394ac..e504a18fc125 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1409,9 +1409,9 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 			      const char *user_protocol)
 {
+	const struct dsa_device_ops *tag_ops = NULL;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
 
 	/* Find out which protocol the switch would prefer. */
@@ -1434,10 +1434,17 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		}
 
 		tag_ops = dsa_find_tagger_by_name(user_protocol);
-	} else {
-		tag_ops = dsa_tag_driver_get(default_proto);
+		if (IS_ERR(tag_ops)) {
+			dev_warn(ds->dev,
+				 "Failed to find a tagging driver for protocol %s, using default\n",
+				 user_protocol);
+			tag_ops = NULL;
+		}
 	}
 
+	if (!tag_ops)
+		tag_ops = dsa_tag_driver_get(default_proto);
+
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
 			return -EPROBE_DEFER;
-- 
2.34.1

