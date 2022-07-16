Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B875770E5
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiGPSyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiGPSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03A1E3D4
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUxAXWqGZh3u4mO9R8VFWZH5XNCw4VmqJ7GBGT49t5sn79avG4VqbjR84NcMWnGsNXi7rfSofv1fjaNy+3W0MOrtc9qolJDfQNRYMUwoZRN5ee28rdNC2eTpesFVTrA3fsF8R6fAuj2xve6VeORCq4UcEGZdaeFE7r11Y1BiPtizeeifpgPP9quJqg5yDRRs3KLcPR6tu3Img5mtBWFnMUbOIk2zSQCdkdImlEc3zoEaVlWUQU+LdgcVJ9jU7zTqWMWl1Abv7tZ1rvA1FOTOIvGqIzH7iZInKAgyszjlSc7RMFFag7lFwpMdOR1z41pt/AAOt+zc+M82+7/o+DL3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDeHNNB+v6BkRi5jJxOHpO3ouQ6uFEiY9tSh3FVNaxI=;
 b=GPya+VqbHLfgHuvI7j1itk7eZKn7MlwW6RGxeAjT3refshs1NZqKDPeRwZF7ysEjC0Lp+X28rCGI+lW9CHso5J98A4Nlw3H9OOA8gKBGXyIFvlyseOw+PIamVNMO3p9ZcuhjnK7WhJLFXtFqNnUiDFctX7fj6gUAEArRGbde3XQPN8K7Gq/0di2dUhYPoOq2vOLu5UNwxTloGfjk8GCXpz+AFYSNpriSJAWTAV+F4L/n//VNtqoR4TLvAHlQzXgSLdlur9YUzQpXjgB7wKA8krF3BFc0aslpa7Wmg+pnFJq4ye8PtG8l+4pct2shDzZRAQnZMqozBGob1PafDq7tGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDeHNNB+v6BkRi5jJxOHpO3ouQ6uFEiY9tSh3FVNaxI=;
 b=Cx34tnt0n/W9l/XXgzy1B0JDYbg7T0+ahCOqrACv6rphXg5VQSY7uwt5j4CUMWQYU+12Np86SSziLEmBPOelPS89Ev7wlH7THZXAkLtZKD2V+35g2a9+mpSyCx0ptf5rCzbUrQ9fLkwsDNTl55Bn0ZUj535JJYC9tBdP1CO56oI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5261.eurprd04.prod.outlook.com (2603:10a6:803:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:02 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 04/15] docs: net: dsa: add more info about the other arguments to get_tag_protocol
Date:   Sat, 16 Jul 2022 21:53:33 +0300
Message-Id: <20220716185344.1212091-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8a83839-77f7-4226-ad21-08da675c8bcc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVn3y/JU+sdWmUhs+Gp9WuZpXslcK+4lUGfWVhIVOkX/UpytroR5LzqLyb5NE3nTfh9kJ9xT6RF+ypocR9FiBy0mhliGr3jYoROwkpUtQeraNqUvMVpP1G/3F5nUSQIYnBeKMkNx5LxAcGfdTNkwF/q2I51xwZJnGoI35baZmfcxkfBChp/swivQGXTlpcQOj8rJhCqqE25p9pNWdu4f6hcfjXWMpJK9iU+BNgGWHbgy7cOzo0cPU3g1y21fsoYGXjhNNHzE+pdneIAyZb62MBp/LVfZCFHQJJ+8WKpOzmJYhQ3MgjculKiQqwzawAIFmX5h+k5VE67MqUJcPT88seTyjdVxUNXOWF04RZLqCtXwmNUqLo6IrWUeNKl3Kd6+gjlT/DdTUH996Ru2xfii1S2MsjXAbSe06EsCPYPZAgn7fuSGYHzMoeMYQVn3VWbJ9Z7XcOaPXgvjcBftHltzXMGJsCUHsI1KJ9LDHAdA76/O7cPjzAIxxdvoh9NOoMXGBUZs2KadMrPQr1wtDI5+6p3v/Ntp8qtjXjArDUoOpZZhtgaoFeyCFP59T/4fAWv9OWbsZ5LjqZXzroFG7ggeO6eFN89MkZIEJguLfOaEUOIEg5totkKj2AB+mAGdIXGKFEDbETAny3s/i0FjWjWBKNLMOCrsnkv2vYLvl7KiAL2Fvse/bwSm90fTOz5PR8YUOq9EntkYo498/DG01Jek7N3wPpl8E6+q+Gcd8URgLleii7Qww+SgdN1qrVczXAMCNe4/ODyx4C2Nv0fRKVIThzWsxtiC3kVtW8e5XCIQMVIGMsWAnnqk/i1FWWZkttER
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(2616005)(6506007)(52116002)(6512007)(26005)(86362001)(1076003)(38350700002)(38100700002)(186003)(44832011)(2906002)(8936002)(36756003)(5660300002)(6666004)(6916009)(54906003)(4326008)(8676002)(41300700001)(6486002)(478600001)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JnLrUk3my6zi6lY2Vx7Wrc3ur5dlB+DLoAn/DNaWGOYcKZ3rrsdKRyQqambG?=
 =?us-ascii?Q?WByNqIvE2UEPkhmcB+7KbOfT1eEI+1VB9/BO9DhJafKhcK77qdRk6+HxFLFY?=
 =?us-ascii?Q?L+dZOP+hZbski9AF+e8WNi/ETGSmpKa7MoEbuSQxVt/G7kXrWygS3Rx6WfSm?=
 =?us-ascii?Q?UCvL6dY3ahAXMC7dQhMobwi5OxvEkYGgocAQ9TFQnH4fX75U6xbd2pnZyS8O?=
 =?us-ascii?Q?OvnC3Upv2gc9MtI4Xkzj3WIKHK7w7AFtX590Emz8lu9BEW+prxJBh8Q/Ju2a?=
 =?us-ascii?Q?VbypYIGq/IIcNUZo+ByrdoePB9XZYi98LtTRJAnzx9HtlDCcV604DRf6jDsW?=
 =?us-ascii?Q?VoYrClur4wwcX2uM3/FjWP50+qcKUzzsu+PL9oWmXQrv4vX4gmtWUoaFn1o3?=
 =?us-ascii?Q?dbXj4LCZzNjCw6dgdzv+Ux0fRxMTSR33j4U6SNV4AIiIKjaOqH4fzjoFCjIh?=
 =?us-ascii?Q?aUDWpAXsaOoRMRb9PfZ5wZLBIrsIwfnzmikMv4s3RFln1GXTHl00l2w1oYSP?=
 =?us-ascii?Q?fY6AqC8D5dCzzb5TrjAqtYllyriF/0EKR3ScBsfh6SJ5drLUdTJcIBqYFHcK?=
 =?us-ascii?Q?zsA6lbZxp7/3tVsZXkLsSNGmwKXo+cWJKoGuQFuZEEiyw3DHxlGB/M03BIOc?=
 =?us-ascii?Q?xbn+BMEDxx6xcjbl6Ufu4W1/HqMtHh/aqdGI8IuuT2Uoqvagl2pssN/FvmgL?=
 =?us-ascii?Q?Y0gjYwPmVN6YvVzJD/NSkw4ONKVr3qcij2lxPiAgANwb6q6fKGrkWIg+ZU53?=
 =?us-ascii?Q?8k5NR4uPrMbvoCXcsYY/FNTVZK30uvjJm5KjdyLkdO0MERFj+RI6ZcHkt9hH?=
 =?us-ascii?Q?f8K0ZVHdUqjJlioboMdYitvkWQo7SWAHgZgB5iq1nFrqMZfo9gfqW2NMAxjU?=
 =?us-ascii?Q?AIh8yRQ3LuuLBR6CXo9WumxRVshlvRI2CFN1F71++00vkvbnjJ9uuEUUYFfF?=
 =?us-ascii?Q?pID4wYRhPbijrNn+DusSI8EoOczTg84rMouLLnZHrnOvkcPvs7kljN+9GE/+?=
 =?us-ascii?Q?cl6HwmgPc7g6ZSaGwME5O+FxPzeMcC6DyNPuZ9F2JbZejte4m9/GbjJbE5Ro?=
 =?us-ascii?Q?i93d1WmxFUdIZ0ZY/K81UI1CMmsy1Nei1HU49GJRjmJZMcVOfSvU/A9eGGGk?=
 =?us-ascii?Q?51hhPyFwK6PD1438s6DjPDOwjwpRv87+9thd6dnThwkGZpFJqbFRhdCsDxA7?=
 =?us-ascii?Q?R1AJTUYhP/LRksQ2DjGF0+RX7hBmoCm/ezbWlp7aBF1d9KThnXaByEPjCH4A?=
 =?us-ascii?Q?sAvaZCyMwarVgnZwvWQOePgFBYQRYzEoXpRSLUAheqTbpbduStxnP3Egs6/d?=
 =?us-ascii?Q?nk264jj5bxv5p/1RAUAgASFyMVsbm1cs+72K6v2EjdiOG0VUSCUMHCteJDVe?=
 =?us-ascii?Q?gTAuYgz4FveYMCQ5hr/y+Wi4uJrgTUq4FWiJZLKkFHTkHLTGe2WdWtIXJczi?=
 =?us-ascii?Q?kDitXX2Wqbqil4ReM7LI69rGpYMSTPXH4hioJI7ur0WAM6pMkxcS1IM/kXyQ?=
 =?us-ascii?Q?/KA69TK1lVbyTxWgLwnY8Kvbvnctevpu9NuqQB3u/sRmNWjZ1H/EzHHBDH0r?=
 =?us-ascii?Q?iNXDRiNFmM6LdiR0UJAgEEJR2UCjKaDi2SWIVRCpn7gO3GAbgLrMYW4ErgYq?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a83839-77f7-4226-ad21-08da675c8bcc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:00.9257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYONx/MBo7AaN3dn2j1wcUbgjG5lAHXc3nJnJ5bmnFlboiPEAIWL0T/UoFRbAZ4mV2IZNxtlTH7D1W0TTPl6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes were made to the prototype of get_tag_protocol without
describing at a high level what they are about. Update the documentation
to explain that.

Fixes: 5ed4e3eb0217 ("net: dsa: Pass a port to get_tag_protocol()")
Fixes: 4d776482ecc6 ("net: dsa: Get information about stacked DSA protocol")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index f49996e97363..76b0bc1abbae 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -594,7 +594,11 @@ Switch configuration
 --------------------
 
 - ``get_tag_protocol``: this is to indicate what kind of tagging protocol is
-  supported, should be a valid value from the ``dsa_tag_protocol`` enum
+  supported, should be a valid value from the ``dsa_tag_protocol`` enum.
+  The returned information does not have to be static; the driver is passed the
+  CPU port number, as well as the tagging protocol of a possibly stacked
+  upstream switch, in case there are hardware limitations in terms of supported
+  tag formats.
 
 - ``setup``: setup function for the switch, this function is responsible for setting
   up the ``dsa_switch_ops`` private structure with all it needs: register maps,
-- 
2.34.1

