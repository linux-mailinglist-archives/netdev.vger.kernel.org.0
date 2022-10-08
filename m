Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFF25F86EA
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJHSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJHSw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E7D3FED7;
        Sat,  8 Oct 2022 11:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iInJPKg2CEx4brzMqrmoxjHV8/WhOzNa+K5YXTUx1WxZA+xiyUvMoUdC3aFqz5XUOQzErHLR2cXWWhccFbEXyrzTZY0nhB6XNeT72TNj1pSAMsRFPrBNB0PqP12TUhti7FJ9BEFMd9TSbEuK//XezAKzUKxYsIMwly58yuanlSrmZ9Kouxa5qeJZk1yy2dVc3nAniPFczxOWLGEwIuL/9teIXQDWsoI7eYe1OOFNi9v+Qcqxa9j6Rac4OQUczEGDBTdSI//OnrQRegk0jSO373KfkqjMKv8V+FMRZRlR9PqrT6qYxVfc61wZp78yj72VrVkg1ia2o+MRH5xmJlYZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okL9VnPO8i9vqZ7LP3v6oWOx7k6OKnAwW70b5i26q5o=;
 b=DtJfeg+ltjyApeAaumaJnjFOtaYfCPFB7PZ9cn6FQfOKQuu8oSbqAG5mrEDHnDrCs1WWaAZfN1w8Tk77o8NrpJwwMMxcAUT4vyYmynpebP84gXenNzW3duq4HZBFY1zaoxJuxCBjnQjU85dsNzCsCL/rWcsT1AbXgPSIJ3cy4CPRCwCT0ZamAjrC+k3vnZJwlboxmaOAuTrFNG0xYgrAT7qNM6nXUTSH7Yx4xIO76Zn5zEk/cIivb79YChKhl8tZ020Fx49cACReFtSaSeTOLuatV4f/Uv82bcDG7hnVNTDvAQApqMznxSDhtKs48qAgIwFPwXJ/yi9Vpwr0unRgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okL9VnPO8i9vqZ7LP3v6oWOx7k6OKnAwW70b5i26q5o=;
 b=GFJb1U2XAlJ2xLmmDT8zfbXNBlEEVwGndgoyfnGA2/QgAB2PO9HvQjEm7B7sTRX2sn57j4uT05Ee+waCFuZ2OixR9fRwOauDOVqqNPMx9X+kDiY1g2n0/T8qUEzyC3z3eMKhovQhW5+fAkRQS4WHddv5nDv+SHYB5Brq8bdpvYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:11 +0000
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
Subject: [RFC v4 net-next 13/17] dt-bindings: mfd: ocelot: remove spi-max-frequency from required properties
Date:   Sat,  8 Oct 2022 11:51:48 -0700
Message-Id: <20221008185152.2411007-14-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f8f92a57-150e-44b1-f19f-08daa95e34d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2/4aallhnQhRnPgM5nsrMdWOjOGLJHbWK3O7IWjdGn4hbRmzOZSIApALQCD3P87Upi/HaN8Itv+C5kTeuMqa3kOAdzHq6b91lI8YH+M9nWmetPN2v1HXIjYHX7bEsoPnORfIGGdLAVnPaccoVj2Xo/fNzD2xPVvDzGySctyto/dE+SxcqNdSNZy6Xrjkji5mOn+Lw7mlhOAuv4eONzb0Wc022elFZ8gXJYkbUah2+HjWct8PGRwJkvBeDxs9mOQF9IY8vnK4gIewVrXrMjE+H/hjcF+tMccuVWPwS5of3U9QjYvKvE5jC0B97iet8y2XGZ94TPaqlDZXvJKmGkkpwdA1WhTZ+XGfAjCzHkZ2QTOP54vGRxPfGIH5aCC6Rv0ZulCKsQeyrBrV//650Xu3VralSAuoin1uGyschdrNbZ29bNs25ju2ZQ7pLrcp+hoUB+OhfHOhI7BAhqJR+UhIFOJqEU0G4UT1simgQiO1x0AJXxIEY56X+RLP3d+7n5B8sHuqSb/d9MaWKho37Bdd6jko9qI6LfuTCcHL76F/ri4MOqDcCnqXheB5xpoDOlr5ammZ3RgAOr69S6s9pCVQ7GTILrEvINKQDI3AvSLzK6xCyIxpHx22h9nQg+ifYh2c+fTWVosCEv6LkEHMe23NOAaLD3I61d/IaePWS3R+1lq+oe+iKKEi+Ugyr2bocobUEOHsGHw5xVUbZuRedFx0j5OJ1RLTAQO8LTj+sqw1789atZq52LJAhxHPY0/ZVQGMggTYNyKsUxxAl3KivVv+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(4744005)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hFMNpFmpkTl89L+/bUJn3Nx0K0meytxsOioAFX6hdc7wVtXrdkiOS/K00vom?=
 =?us-ascii?Q?9BSnEQrxOMOm0Itx7tN+oHTRsK4oN7DyCLb+jdkjsrmwqvM2RaWLyeu9JZMY?=
 =?us-ascii?Q?db0nsBqnPfslHrjKTergXF27DwURfa8ZMwnmb2J+Tj+q8CIa+pgOo1rCkxND?=
 =?us-ascii?Q?njx1K+JQSdwFUsIro9IZzGftfej416zXpcA/vM9cvSTphS4pPs4Iajlu2KSR?=
 =?us-ascii?Q?8qvtslHts7M0k94e9Nvpwne/UUW9zc1vfEIbjPlIIkiEEjBr9RA8TaM4de1C?=
 =?us-ascii?Q?PhNVZ4I77Wq4Ka8mOkMeegvJWkRRltJTPyrmLhXaqh5FK4pfhtiren4q9+Db?=
 =?us-ascii?Q?knKQbQkV9WnnNcMhrQlFjpxGnNm7j6XbvSKk/WC9eOhYQlmj1QcA7oMPEcX9?=
 =?us-ascii?Q?TIS+jbLjN3SDgyrpDyUcNWm2k8xQDg3wZo2djjns9QQd5Vlzsw+G9dXGJL1d?=
 =?us-ascii?Q?FBgE2sjVLAqymkFn1+lEFHLJyJcjtt/Hryss9ZtdgDnUpbhSUKWJDqq3DJLt?=
 =?us-ascii?Q?doCCbcFhz8Jh4N6ngKzxx+3iYmN0o0fi1COXBwR9uHAmD3BndlNJEWys7bB8?=
 =?us-ascii?Q?87t2Ktu2R9jHQE2jtTJ9Z/ACX2H1q9BAGE/iPVynAm8pNIOdURh7NAPtxP/v?=
 =?us-ascii?Q?iUy/l0M1KlfcXOUHv4iAvk1qQVNzXBb1ucJzsco0XgvMLPwfbEgfwXGHZ1wl?=
 =?us-ascii?Q?6X2N9oYIs3PIHMcajqBnvkVNEs0f5r3f3ISsWyojASxLS7Kg7AOG4OEnBQZ4?=
 =?us-ascii?Q?xZZq0zU4thGG5TEPtQHhnzt6Eck7cx0XA+phjd7OrA3MG+AoQKrOub2XZQ/y?=
 =?us-ascii?Q?Ne9pCsnUrvzhSuHtv+0ZaIhmPOpAnNZ4thw5Ad8VGVRpwPSohhso0ELcF8Os?=
 =?us-ascii?Q?VY7s/YFaxFwdCNOncpBoK2FSjjv6P7aWDxPL8MCDlPlAeP1EoX6CvkHodemq?=
 =?us-ascii?Q?BnNa3U1zif6ILxaJcyqew37Q1xanjDSxEG0i13FSWJDNRiGoES4TQLESzq6r?=
 =?us-ascii?Q?2FfyyykHyBsCK8UEJiQm1xj5LSvCiardXVfliSCuaM6J1DD/RunghSGpoT/r?=
 =?us-ascii?Q?xjktTecKqtnxT0GJSvhpRHEBTT1aDOmGoipCQznzxsdXkzl6v26U8d0InYEG?=
 =?us-ascii?Q?sWn6gCP1e2CR1ITaTifnPMm2pRwyVb+4IYv57TMm6neRhJnnLe9H7Lbzv5KS?=
 =?us-ascii?Q?T08tbBucpGoueLU9VZm1ey+6xsF3FvfqaA6nYmB8uR3xVzD/gIcL+LG0HHy5?=
 =?us-ascii?Q?hEAFD4lz3S/1TCoDqgfrFIoGk6Jow2uqijO2wa2Mylc15tFHT7pL/BfXt1Yy?=
 =?us-ascii?Q?enBkk4mbsDIGy38WcU/Bf2XA+IoZjBj8LkIk3dF7oBu4/Qo96PElKTXqS74X?=
 =?us-ascii?Q?giIlu2oHWI6dtXDpmJHUfPtRHpaD459J1/iR19mL+wLk2YZYW73F2DrTvv0j?=
 =?us-ascii?Q?x7PU2Ox/bwothpVTqpCIu2s9MFcEOSw+TTLoQ2kgu7t0QLL1cxmM5engKE+D?=
 =?us-ascii?Q?j54bNIGjG6HuPFs0D4lVd1vJkJE9yrtZbdyNRKljyeILrA6tOW4AAQRrJOq9?=
 =?us-ascii?Q?qQL0muB+pQ+dWuiXVWwKDMTSQ7EvY5pwB/V/Y/sKXrV7QlnBL5l1zQqW9J9e?=
 =?us-ascii?Q?W6z2Qae08EBFRJJU3P4ivag=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f92a57-150e-44b1-f19f-08daa95e34d9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:10.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bkXZVTlQuGvglKFENrOZxLr0LakXjb+jVIT2vyGukC6yEDjkAXdfOnz+6edIa3GkG1FkCez29JfNooPXZgjSSCaqEmpYY8Gjq2g8RVIBho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property spi-max-frequency was initially documented as a required
property. It is not actually required, and will break bindings validation
if other control mediums (e.g. PCIe) are used.

Remove this property from the required arguments.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * New patch

---
 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
index 8bf45a5673a4..c6da91211a18 100644
--- a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -61,7 +61,6 @@ required:
   - reg
   - '#address-cells'
   - '#size-cells'
-  - spi-max-frequency
 
 additionalProperties: false
 
-- 
2.25.1

