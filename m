Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0190E59B759
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiHVB74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiHVB7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:59:53 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EC02181B;
        Sun, 21 Aug 2022 18:59:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGiqet77yTOguMs8ZxjePbzfCw4loUuOKzY3sa6nP3ThYONrTMSIzR/FKaChEDfLcGnWvEK+gI/MzLs44przIse7fAWFbvzPwpgLlUvZcg27mWMxGle1iPIXrs45L/u/FXfbiKltW7m6sz3MxaguVixwJMPybxyVfL16KiTytUV/U8HUpNI5iKCLeceaNun4UFne7Gv7NzFAMK3s1bwESRoTb+x26/Pk+Elfyh1qXOg+0tVVIBzuZGLW6PILNkFD1abhBV5zVPg5jHhzS62M8KriSeHHXnp3ceVpn/GpTfLlX0G00Twa3yeTHhJbsL0HS2ozl1OnOI4HnbMpy0YYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVSi8P+xSDiHEg8G1iW09xz59slsdaPet9lFQLeN5UU=;
 b=mhGyp/PeTgjilO6AqqgZf03H4ozykquyh0BO0bmpNCcUb6wvB2B1jL08uWx67gLFlWwuy8TSjys/0gFPbfToPQbXQVHISdpXCJKvN1KqKFkS7wtCNkqEeqePToJ0gHki71aMQyeAyZehaEW/ueXFAbOZ+di4/7PP2o0H1ybUisYy6WEyVw64cR9bhg3KRa5cNJMjXrK3DTE5oXY8T32D3mfjugZJsPTHj2xT5owJKJ7gFokFf6tPaNNnjtqqbYiWESvM8WMj8ENxj3GF/8BPh4btqsU729zl0Kokk9iFWnFyWRX3vgj730KaW+YTKv6O4bHylvIv4G21ZVQbYEbRjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVSi8P+xSDiHEg8G1iW09xz59slsdaPet9lFQLeN5UU=;
 b=OlZvF6/PjOZ4xX5L2vnkW6zIj2W4AKcz3qCXoh9OfoS+viCdQ/bJJoHMasN8e8dv384h0oYC7vf3RiuYuKdI3MhDhVZbgSxG4EM/u2TvuERMhv0ovZt97BNLq304eq3gEvW5pn2a+CxxLPNOe085qk6s/mXKKO/d8UJw8EXU75I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR0402MB3335.eurprd04.prod.outlook.com (2603:10a6:209:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 22 Aug
 2022 01:59:50 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 01:59:50 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in property
Date:   Mon, 22 Aug 2022 09:59:48 +0800
Message-Id: <20220822015949.1569969-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822015949.1569969-1-wei.fang@nxp.com>
References: <20220822015949.1569969-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0029.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::16)
 To DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6e81d29-9eaa-43d7-eba4-08da83e1ff31
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wcVIH1OZapzjdARul5UImRnNL4q5TqgCXQtoA7lpZbg4TAmVOx94/E/vxKdFwGJjzQw0O0uo7+BamLyjTvRHjejzgjW/+RsD9Bb/DrfETaPjNKIN9NIaI1iA7Dv8vtvI+92HdP2QbaPca9C1hJvBZm/EEIDXx9TuXrgh8d58ZWRO8t1EK8NQ++pIKdQseTU/98PPN03cpzTXnnmEz8Paal0DAl3gDUjfe1zwgCEn/h91wMp//y3rW3cPyhOlYX5L3J9q9LS3VkNcNsAvydKC4cXI502E7NUZSwS9S2hIlGRDtwNZ9SENhf3mjSRtOGr2xhLX7n8jHuXQ6zxcpuq+CiCkvHtrWQ/gXgX0Owwqbrgx37raph/kQAEtWuQNR2ybm4xUFARbq1cWWdB7JDiI943OqCTkZEapnGQyfz5KgbTwGmh9LtpdFXcR4FQQF1ytZJMUbOGzdpM7wLyKdnLhhwALovKDLM5QPnBVzXX21SsFx2FolA5X5K1O3SNJSZRs6s55ibOKnwsUWz5BYqU57ifcJcuxUh5ulN9KOhBFVpQ42fvBuTNBClVQdNqRughJUWJHCARVZPT2WJjNadOyUrjrWwh0UGE2Q2juu588Ltpq1OIrS8oorPcK9/t5Gy0G1AGfpKJaViYR1u7iCGxSgOmIjHBI+GrDcdXJOtikQkh1PEHHyj+ymR3v55J6M4Da7eggGfQyI+j7uItck0u9onxrn6JuuvNwe4rLHkpy0tyPY8jqk4crY4cfBH8lC23Xi7s7pOD1FzVDpsGqbPxzYLA2brhZSAK7k8PX9Dq0rg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(66476007)(66946007)(38350700002)(4326008)(86362001)(8676002)(66556008)(921005)(8936002)(36756003)(38100700002)(6512007)(6506007)(6486002)(1076003)(52116002)(316002)(478600001)(2616005)(2906002)(83380400001)(41300700001)(5660300002)(9686003)(26005)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raKaK+/2R0V6dUXnCRmlpLJbaONHSQB1+cyAgpDEzO8YDxDzziDmLsJIlbGI?=
 =?us-ascii?Q?DfsMgVGCKeGTx/MshlErYS1yO8+zBAlubsbaMs2AAX7nWlQ8kVaDdncnyO+0?=
 =?us-ascii?Q?UG3YIcGsqNzpjcufB6OvS0Y4iUp9MYYlh+FTj9lFU8ZqNStBKnHKNOFaCcqO?=
 =?us-ascii?Q?VQlUl3WxZ+n+V1imDVBZRwr6yeIB54FUYXAHkmgU2fDO4NPQwmwThg71MmPQ?=
 =?us-ascii?Q?6uPOWhhDODlowG4M0byXQZeg9unieyJ2ubAt3tkVzNvqRUw7bK/RRNHt7rbT?=
 =?us-ascii?Q?7Q52v1rLfIXwNuiDbK/v9Cr2Mgdmw/PqpneBIyzuVkw5wm1MIfJCxCsnUyfw?=
 =?us-ascii?Q?g6zkqkSMDQMXfOPowC2yi8rN7eP60PmmNqmdb6tpjQN75qdPQ4em1JfShORH?=
 =?us-ascii?Q?prMEb40BL9k+L8y0wgZtQaYRYe/aGnQeqHUl4oJyzdWOR7eNfAUed2KsGSEQ?=
 =?us-ascii?Q?7jPLACdLUVBXjy2CrncZ22qO97v05Xi1irN2ogKrIEz+at+W34dratv0nRQU?=
 =?us-ascii?Q?g/BLViEYhGl7RQM/+g3qPsa4z1ZljjwwMgTa73AryC4M11LP6kWfN90oEmUE?=
 =?us-ascii?Q?iqUJprHghQpJxD+eb8ksJgQmtxsFK/QUrAiu1t5ruUCsH6PZMFbWxgxI8Cg5?=
 =?us-ascii?Q?SQCJC98pD2vIwkZQYPFwl23mLRtyBF3bYvsb5x2koI4YYvggK2SrQ3KIMBIk?=
 =?us-ascii?Q?7ovajF3aNJUHOn+Yco3CmN4jb5iYxPM3Qrq9usjMoqztImENs49Y/d44Cl7O?=
 =?us-ascii?Q?lOBqKWHfJvRUxRF8bxYfCFeq/aJMVv3ocY4m4vndIfqjBvd+qFYBhrVKI5yf?=
 =?us-ascii?Q?zNVgSs4pp5Nfq8/evZ8Gk7ZULpm2KkiIpXl3gAxeBqurVrDtbDaJK0RJMU8h?=
 =?us-ascii?Q?w3EHinOEMVOIhKo2EPeAc+31mwAe9XaJF8GhijYCtSYIV2vxvinMCzIIHnv9?=
 =?us-ascii?Q?bi4bjPd5t57dd0VzxLjuLo1T2ugF+pMgjvWDLPcIsFDuf4Dc4oiWrX3904a4?=
 =?us-ascii?Q?4tQzL8wN+hPtldy1yQ6tdvvCwJLsnUjbM//0tJToQ6X8CkhoL+oBIuYKVnXk?=
 =?us-ascii?Q?lelh5K7jLiYJLJvYApZr2bLNBCoQm61Qvdjvhba3vMaNu1E2iXNgULhgJEwO?=
 =?us-ascii?Q?8+vN7M+kP5UGYYjDXDNA6zuXrsGI35P1bfet9m1cADTBsIVzIVbdubrnc2oW?=
 =?us-ascii?Q?Z9kPXD7Ys7TEZjz7e8OZzEQOtEQGjD9RNAckiE0HGHlvibhb85oO2pdet4D9?=
 =?us-ascii?Q?8I8zSwX9L/PZz1y+WrII34DD8Arvy+Yj/jZwCIvptBXIKMZpRnzqAQxGXLOJ?=
 =?us-ascii?Q?NlIXfJ7TNrc3OUBKtrE96uLGTuIKggcoLo5Y621XE3duIapsCDOOzum3OOdb?=
 =?us-ascii?Q?GgoCMhWgzRYmVV5Ht0fOYCrfIqv0ndebwLYgYfZgEnJs8ze6kaJqxoVhiyu7?=
 =?us-ascii?Q?4ThJVDVBJGah91xr4xWYcWB59Vku2Njx5wK9ThOoykUx27dlfotG0W3ZBIQC?=
 =?us-ascii?Q?vK/cpsgxAIMpoL9kjsQjmGGBC5/DGHC8h+/8Ta2IOwevA51eW6FQqRD7bp3c?=
 =?us-ascii?Q?OHGrQ/5o1SDhKadH8c/jjazaUcId1mY7eUkWcF3e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e81d29-9eaa-43d7-eba4-08da83e1ff31
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 01:59:50.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFZJ3tPcmSY3/YpK3AsRoGjBCRKk4HDAbMthr3lU9YPe6Xn/PoFexcMA6sr2cC/0euMS9zTYw7xKzWTEy3SiZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

TJA110x REF_CLK can be configured as interface reference clock
intput or output when the RMII mode enabled. This patch add the
property to make the REF_CLK can be configurable.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Correct the property name and a typo.
---
 .../devicetree/bindings/net/nxp,tja11xx.yaml    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
index d51da24f3505..ab8867e6939b 100644
--- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
@@ -31,6 +31,22 @@ patternProperties:
         description:
           The ID number for the child PHY. Should be +1 of parent PHY.
 
+      nxp,rmii-refclk-in:
+        type: boolean
+        description: |
+          The REF_CLK is provided for both transmitted and received data
+          in RMII mode. This clock signal is provided by the PHY and is
+          typically derived from an external 25MHz crystal. Alternatively,
+          a 50MHz clock signal generated by an external oscillator can be
+          connected to pin REF_CLK. A third option is to connect a 25MHz
+          clock to pin CLK_IN_OUT. So, the REF_CLK should be configured
+          as input or output according to the actual circuit connection.
+          If present, indicates that the REF_CLK will be configured as
+          interface reference clock input when RMII mode enabled.
+          If not present, the REF_CLK will be configured as interface
+          reference clock output when RMII mode enabled.
+          Only supported on TJA1100 and TJA1101.
+
     required:
       - reg
 
@@ -44,6 +60,7 @@ examples:
 
         tja1101_phy0: ethernet-phy@4 {
             reg = <0x4>;
+            nxp,rmii-refclk-in;
         };
     };
   - |
-- 
2.25.1

