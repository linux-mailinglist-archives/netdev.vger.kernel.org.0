Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B321F5F86F1
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJHSyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJHSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:53:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78288402C9;
        Sat,  8 Oct 2022 11:52:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiwKxR57DOaLP7+gYvPUoC4ReJe6HTPCgDOZEzGTLJ/0uCL3mFhAywMyx7eyTlaAznK6UUuQIkh4uCeHihcSCIc9xgWSuAODyFErT0qv3WTe5VwwyY/CgqaFSpNPuzgKrH4ciboTymyVluE73Sw12GxZd2ueBqRP6ot5rgitFA26BYGh3juxEGAhHAZfkm0qaBiN4/d8o7byNRByFTpFjC2vle4QjjWIKth1rS5JstkctTIwzmXRQ28gdJWEbCLtAh3LqZ/8IyXrlpSvvMeamxoEIqRfEdA8pImG91NLCBquH2x8J9QPSZyFdsPJkSp7BsOnStu/fKbufyazfDjhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipgiLXPDFyxA0eZ2ZHTJPTiI4br7AlU490iR6iem6T4=;
 b=SL4lqcRt8nQA6aa5XyqUCfXy615kWGSK7j6ErUHVARUoKb9I3nXShQuSUsoj1G5W6BMSrWmA04dBMnN4L19EjjR6V0f2i4bo1yq1vak3MoQwFgAoce078CNuIXFKQmgK9KTxKLr86BXTXGJnsg4gy1WwIBw8O4upvbnyVEoW672dWIQiAEGW9LQl+rA3LBmuf3Ynd6LT62k8a4bwhrP19hzOwyduNGfojyNd6kXKPc/8v4D3duVbx61rkSZy2S345iRkEBeASMRWtDpNPPg2KsZnkqv3O16ipMTbZX4vEgWloTubyHNaTL2pIlY+/cCNePecDofaVDwuJxpFO5Gi7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipgiLXPDFyxA0eZ2ZHTJPTiI4br7AlU490iR6iem6T4=;
 b=y9E1boLAthKCbkuosUvTm/vyIuVzUnJrEXXkisipnv5wsHTEmSqtEHQbPIOSQ9GgnocLrdff0Ep2N9UUNVFsh8TJ6IW24o5SeE9Y4mM8heQrJMX/vZnY81ocj6OIfEKiP+8WU+rYJUm037FuVQuxfIjiXzb67r5RF6Y/IWioSzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:11 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 14/17] dt-bindings: mfd: ocelot: add ethernet-switch hardware support
Date:   Sat,  8 Oct 2022 11:51:49 -0700
Message-Id: <20221008185152.2411007-15-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 43c03faf-194b-4269-0020-08daa95e352b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C93U5a95nqQc+TfQbcjbTB5N8OQY6TATROj170u4X6kzueu7nMe5aZ0RZFytCSm3DToMNrO1CRYAfwt2kEcAyCXth4pCuBQOhbiDqO+4+tuUae2jyIDfRD0YBjfTN56wCuXn9PPhyWNmNIDQQLFPkqTDUId3OQ01iClXFqnjP/LKMAnCkxX46jps/NnDPyxRZRJCKGl+zNPpUaqcNw2RLnJWZkZVUZ0cj5UcCWaGPqaxwddv6mAn9lQaw7+VUBwn6x+43kv6TN7V2PJYvgP0Ayo12qv0/37cIyVUsMcg07b27awF+NQOyWh8afufsxwxPb7uhTXcDqC5KErSRRQwgG55XjyEyVW+/R1Ol0OveYXqwH93t1FSoHDt8dutnOCxa5o0NHxMwg560HEo76ZAdbDPt+jHwF49BwjtTCST0e0d7azYf5YB7AZVzrnYf2dwnBnw1K1Y+JTahbN3iY8SyurulDbE+LZ22Qgy3zEGNjGkF02l/XbKA0mVFkRKMD+AMHnhXoJt0ubup9I5yDM4ps4Lks/XpO4lxZwp6Wl0JXO/y236mWZCl8Y3rKpW/zZLIxroNI0A2ocqNOySFONVQiF18mkMP00T79dsn+XMP4JnZyAq3mXTNfSIg9wGjecxufN3fimrc6hCMuVGMM+P/XQeytBR6HV42zO379BED8BzXu++j3NwI0WDjOtONCfEQBjAKsg1YSX/DMINZRxBBDMTIZkmZzDrqWQ4Wv7P4LpQwT9c4SM3MsrSmbYOlTKAB0JMwMHBoeBhbYo9OujjqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(4744005)(86362001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKrF0TbP4xhZgfrqAbVpXynEvDQp2My9a6dwl06aL9d1xoRmzzIFjHHDAV0E?=
 =?us-ascii?Q?ljj41hvHG6sFGXF31UkhQkPLv/q+T4gXaiCrTAL66t46JbM5EKvaEdrjMIAG?=
 =?us-ascii?Q?Xy3RAd/W315aXeA5aYAvuDN9kzxYHaqCg+pl5zPwQaLWt28xbEG4vAdCEszm?=
 =?us-ascii?Q?a8TcBY0V000n8IcGVS02Jupwav0UtCR2HuyW5m4ed+N7S/hf20MDfOFxQyaq?=
 =?us-ascii?Q?V+EDjXbzynoVGuGwob0EcYvPcoaLLuBlMX0FDcqMdEEzs0DqLxDzXInlOqbI?=
 =?us-ascii?Q?0CQVWpNO6KbTZSfLL5e6upMiU9aB3orL1XgdGZGi5mTryb6kU0otxHrqSCUr?=
 =?us-ascii?Q?lVwBzD4z1YJ4zlYMUodqJMuCX5Uh2jk6PvhK2dnbGLftQfXLW0fAyXwgBfZD?=
 =?us-ascii?Q?GY2UAiS6c0LxkO2RP02V+Zear/cqc3SirgZrqSSOP1HUdcT/f7sE5r2xuG5f?=
 =?us-ascii?Q?qzU33dqJWO3OZd0AV3cCpVtulyqqTCUy4E49XYSDaoO5nbvmY10vsS4ETEeU?=
 =?us-ascii?Q?ou8gh7/IsefNRLj0kJmwLXvsRnVJb/eermAanOdjkWgVbnZRhdchwTz9T+Dx?=
 =?us-ascii?Q?R0JPZsj/4SuWDRRX2fipwiLeBFWUB4jvN3qg3GtCI+52Cjf7UfIZ1hSomR5d?=
 =?us-ascii?Q?lNqZ+j8N3e68gHCJsQ6DIE5oIG2md2Ukr5D78V/QRoqXy48llTQi4DXl1NTN?=
 =?us-ascii?Q?/AQgVnLkUJlasaqQJINt2tlyB/bCiidtSwYhKJUl0s/3KA+MzH3hJJx3mwqE?=
 =?us-ascii?Q?B/gJSqEGUN4qPi+Ysk+afvodiiHOSrCbCsFK69kwQ+4GugKrLU86GyigZA/e?=
 =?us-ascii?Q?QlwUe6oO8JD9D0Rgm5hMWUiMyS2e6N0vlo8yoEPLi0/16c2nf5upgaTyFe6s?=
 =?us-ascii?Q?+iRteAFixKtWA12GRGcspukB50Jzh/GeaMZCbXo0yjl+GM/qOX1DvQjhMqoA?=
 =?us-ascii?Q?TmD4UaqpSlCp+X/1K9Qij7vWqqFSjPkUMhNalLYjryjRpuICOmR9G5HYxTpD?=
 =?us-ascii?Q?a04wzCPYFl1nc6YsZJBVZK7Ve9CeDYrPQhzgs9NY4BSyeQlF2ElM4MR0/VD+?=
 =?us-ascii?Q?0wgShlQdXl8vQHTUJbks4i1ipz/YU9RM5/raZTYgiahBgDHAASVMvaxpJSzP?=
 =?us-ascii?Q?xaTHhl5xKaOHtVeqYkgH6lPZNrEJsRghUK3hdAiEKKE/8an7Lzv3obhrHyIc?=
 =?us-ascii?Q?ogLhxeH5o661EgKI7HoToC7L8G1AKA0lVARFBWK0ke328EcfoF+BhRS4YjeR?=
 =?us-ascii?Q?c63FqBKzt0dxHHLXO5FNVxlSx4wKDoWrrJl8p7RaGpHactbD5U5EqcflTvmu?=
 =?us-ascii?Q?DCmL/VWv6s2cgnJB9llyvuY1c6UhXckw6tMAKQVKjfA0Hr4bRMCnLvxzcQLW?=
 =?us-ascii?Q?vSsyPWzjFy0i/Zmq3bPQIpsgXY0jCtNjbpeEPkmQUPi1KcPeWP6NAl+GzW0w?=
 =?us-ascii?Q?mGwxVZTQPHsyR8tivrI67vyrSBrtoDoADBlJTkavi3eYlnvoLktTgq38dXZo?=
 =?us-ascii?Q?y0Gp86nPjmNroJUEL6dpsopSXgxkndyBEKnsJORQIjzV0FxB2pwbf34mOUas?=
 =?us-ascii?Q?g09QEDkvftVWF50S9oUI+fk0y8f4zIBR757U0cHjMOmwnki1BoouT+2JEX8I?=
 =?us-ascii?Q?6KvtgykJTLNv618XcirZBP0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c03faf-194b-4269-0020-08daa95e352b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:11.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6A055hEO8v8DSbpnn0Y8NrCdkypWRZXbLXjC8V81TRaQYa+fY8417JZjZcxqU6xVTzF+6QWRJWTb9IGLL8Fp5qowx4XXwM25e/8C/aoYmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of the Ocelot chips are the Ethernet switching
functionalities. Document the support for these features.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * New patch

---
 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
index c6da91211a18..9ad42721418c 100644
--- a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -56,6 +56,14 @@ patternProperties:
         enum:
           - mscc,ocelot-miim
 
+  "^ethernet-switch@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/net/dsa/mscc,ocelot.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,vsc7512-switch
+
 required:
   - compatible
   - reg
-- 
2.25.1

