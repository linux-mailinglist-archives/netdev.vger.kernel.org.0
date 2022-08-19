Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E8A599660
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347205AbiHSHrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiHSHrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:47:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD19D75A0;
        Fri, 19 Aug 2022 00:47:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVRVGDcQiIfohTVhbLpWGh3DRZnCq7xpj0CSAuQaYgsX7dl+ZExWl3FOoMD2xkmGQHRFMc9Dh/jx3X0djgkq8AS/smjOsOhKT/L7WQdcEU+T4vBaQ3AkFVlJ3k9Rl35D42PsustsoKaQ7D9cofRB6MZ9GRwGxndeBabk+GL5+w1+UvOAAwJUMfP7ZLGuKva+LeUnTBMJPoaka/wN2OpJLcqLYVvZfOdFXhhq3QaqozyvBDmY01eJb6/whZRPP8/bS46gDP7eYTKLWAA+spoMHXmO9ZahZg8EBsOYin0CwwgEqv0KE0a4LHHLeul3lq27dCCy0+CNN6vLgyJZ3G3kSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CULa9flY15bsPQVIiuBuA6ls7ndbAXl9Ec3WwDk5sj4=;
 b=jHYmehT7R/97bALlQdPjWDP2UETYShsWIYGVa/mfx0Qd6TUqb4ZBmujNMvb2pVzMgl4LDOokplwJBS7ueoW0EKoG/XEjtvA+JgFKwdgNpJT81eNBgs+5f7A+NzUZf8PE6wTREf/EsuQjn4YT+qiXHF3QJ7PL3XuNBzjU/AB5owPpvpYJlU/cvZF4lvK7eGnmLv83xEzMx0LZ8ih/MbmvyzfV3vS9nSQ7SVkYUOgy2rgOLsE9Q2TPg7uD9VGIuljf/aIAx2R9H4i1iBXBft4dtrYQb7crhFzsW5xPfu2JV1JnZkx9/hZb0Ck/RH41MxtcbnSmJ3ycKEJPBrOJyyC+0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CULa9flY15bsPQVIiuBuA6ls7ndbAXl9Ec3WwDk5sj4=;
 b=RVSPY0wSYi5y0ZdHhDM9VokylO/siu0DK/pkX3hOqyYYgX1FJi8egVahjmrQLPLgIkjtekl34sIBHveVvByKSe4A1zrF0XRccOnVq9y4lOYBPuNvZXiYGbfi5YJd9L+imNWYxS0Wg+Kp3SpN9EG3ZJzJ1lpiyO/k8+GcVnz873g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB6238.eurprd04.prod.outlook.com (2603:10a6:803:f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 07:47:37 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 07:47:36 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] add interface mode select and RMII
Date:   Fri, 19 Aug 2022 15:47:26 +0800
Message-Id: <20220819074729.1496088-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63674818-afff-4be6-56ea-08da81b71578
X-MS-TrafficTypeDiagnostic: VI1PR04MB6238:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBiyam4yDovrXTqtAI4KOlWoaE5LvZBgdEDuFlIioCscMfgF3MdcKTixcymUD/7e0yt54bnFZr4cb/8kFyoMsY79mA5Rz0HDZHB8bsoD9suisQBL1AYqC7vEt5MRazKg2Do2bg+S3ziN+vNdytaje/XIUGuzgOGd+81O/p5LEglUhNK7ZqMb00oubbq0YtEEabdkTdhlExQhvgiK+3aMRHrcCAp4oMUXdhjami/gLxP+g4ZNWbGGfhXPm+V2yLKORnngn1Cv46kYeLN4Zwb25fbdTBa86OY3spXeIyYtlocrwPutYEbSGfDMZo0vqXu7BDmpVhb8un9N3DmCxgwBQ6BZgogu4BD9sjqkQjuZMRjG3/SP4gOB3CpdnZ2jb63935YekjeHkT5piQlkphToEEUrEECVRM4WdbO/sPQTV1Pz97vZ1ZA0P+FMYbFV89EfljvSYLFcNDCE1IID1LEn5Vf0ELI7cKWOfWmQ6KIip3mfbOhTMr/hRChzPcamDRWyzWjGAXrgst68pP4Ffe8AYYKp6r1yd3vA3Bprs9ox0HZ4q+jkRotQblD4ZN2pxB43CZnTS0JEPtM38UalXRrMD2lVRxQxV2qH4jYUJV+Teg+tR3x0cfzqlBu+fIQUrzgm6XoO/VjI7N/HLY0t5WvTuJmEpIYwVTHmsE4XUoprH5q0SpApYCFZCXr8RaDJ8y2dkN+nK52dhry5zDPxHnzTqlE4hyr1wOCfC1xUP/cbmlYWrDeYAeZico26d4Ip+qVa3O6fqsIu92teHAenyay4P6bTDA6VyoootP4lBEJKPE0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(921005)(66556008)(66476007)(478600001)(6486002)(8676002)(66946007)(2906002)(41300700001)(86362001)(6512007)(52116002)(6666004)(9686003)(2616005)(1076003)(186003)(26005)(7416002)(4326008)(5660300002)(4744005)(8936002)(36756003)(6506007)(38350700002)(316002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h53oxIridfk6VKXBZdrUgfm+QitJJvXi/h3CB4Lx0pzNYxcFqnIeD1A+etMM?=
 =?us-ascii?Q?Jb02E5ZblR4wfJP7h2EGdTRdPYCakJCLzuFcRQ8zNHRunr6kgErCev20p5wd?=
 =?us-ascii?Q?OIxRkPQSqCaC21giQRhGYprCiSDPa9leUYaUuXEq3ZsX5FORaFIdvIZar+GA?=
 =?us-ascii?Q?tLjP4l44djqAlQdS1CeSHgf2rYReh1VtLsL85B5vSmC0C5FL2Wzr3xa3lyYi?=
 =?us-ascii?Q?S8Y9ZVKJlKu5aZHrnRfS0OpwEENcDLXd5OLQBBCuON37VcZ73uewSssRhw64?=
 =?us-ascii?Q?TB/fQqwXfm9E8AxQsIEIjd9kSQcgfQD6zZJqkbCFFfIDDSUlscRpgjfiS9c5?=
 =?us-ascii?Q?8L0IT9Xm5DiJrIgSUzTyuXKdeJZ9S20zo7SjGJPn2WJV40b0k2mYti2iRc/o?=
 =?us-ascii?Q?Q/s3m/BR5sap+kf36+MZqJ36ddRCodk09YTnqJ0LWMnpaueMhYxONqLRyn52?=
 =?us-ascii?Q?sr28tHRbbiNDUsTvLRKIQTqzaYWv4e2VyNoOgsoGtrQOFLMR5qm/uKGn9caS?=
 =?us-ascii?Q?REv25tEpc7PJa3WiiX24ROoYETGga2L9xd0t0JwUZE7xacWkgLS6OAZ6p/pP?=
 =?us-ascii?Q?Q1eEcHR0VUm1wD1S1HJuknaonz28GpZoQ4jW9L/4lWyrqIN+mpaniO8/CR3A?=
 =?us-ascii?Q?UOKMM3wf3aVAReMMbo4fghNy8QkH7z4mLPdfHZGLQrVL317tq990NFnI+Rfe?=
 =?us-ascii?Q?tmcyyfEly0wLQD/pZ0T0tCuWbz6io5+YQQqU9hEiSiWLKFyjvRWum+HDDnMR?=
 =?us-ascii?Q?fNT+5TGHp2AESIvp5MX58Vq2N9qTR6C9Wh9R8cMMTwfRyhMqysjVfmc+WjmH?=
 =?us-ascii?Q?RjNF9P1U+VtUKZHjaGjmxlwk4OMtC40AE54SbHo7FZmHJ0DcgSfJhMgzQsBg?=
 =?us-ascii?Q?ilLw9DvlZldajZ3oLnSKjtnT497+IoBJ5npkZ9fnvRzlURZZGjrAKe7CZIx0?=
 =?us-ascii?Q?Yt+vFh/o9Ad63ABbIOM6m0q3ZbJjbjKr2HtepjxKWEPY+uy0YiOBuqJdIrDV?=
 =?us-ascii?Q?ZcRXcXw7/pUmbXomElxi2L5o0Hmkt73AyoYGikNzposmvV4KcVqud8WBx+c+?=
 =?us-ascii?Q?YTnTXB/7YmuNJ1L/Zlo9JYO3rbBm8+nGRx7qjEEX/As5h7bZbK2FHv8Canau?=
 =?us-ascii?Q?PGxdScjbhZ438/jrrv7WtpVrjGEiITcoSFl0UqDRl6TwOBKjSD/BdvCpc+0b?=
 =?us-ascii?Q?rhdQhdEaSyUWi94aLuE/2WOrY0r+gFin5AtsCPWlMSG95vx+M+KGE2zuFk1a?=
 =?us-ascii?Q?3iMgsveyCOhnBB6gfNQr921pzD5ze4kJpVIcixOgri9Dw+3N9c8zaWRlJ7+G?=
 =?us-ascii?Q?ZzhT/Rp61BNy0782C804vzwAzXsiPD3CseI2+8Fjh+4AYGuYXWWfwu5poFUG?=
 =?us-ascii?Q?w1saasbd5newCD0LBn/3hAgmCsymxwkeQZAYuouZQzXWu81stWtDoT+VD4FC?=
 =?us-ascii?Q?PRRtKsDJaKPDY/OzceUrQ+M+3XymOJg69p0BXI/0g3zBs7DtDtyliXCf/mse?=
 =?us-ascii?Q?XZysnk2qH1wEEPH4IVOYA6gcVJuF6CzgZcz7TQZz4RZCMoggsSS5RZ8g6hzc?=
 =?us-ascii?Q?FBa412bwOReoiUT8sqq3O1ZpPGgZdM/4eoeIDie5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63674818-afff-4be6-56ea-08da81b71578
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 07:47:36.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYsc76oWDfLoeiMgiYRnixQpyxbVPWTTKUgipftdJ2SLYFWJV5BENYQnJBMYniVXDbjU3OZSGWCi2w+SaZw4Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6238
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

The patches add the below feature support for both TJA1100 and
TJA1101 PHYs cards:
- Add MII and RMII mode support.
- Add REF_CLK input/output support for RMII mode.

Wei Fang (2):
  dt-bindings: net: tja11xx: add nxp,refclk_in property
  net: phy: tja11xx: add interface mode and RMII REF_CLK support

 .../devicetree/bindings/net/nxp,tja11xx.yaml  | 17 ++++
 drivers/net/phy/nxp-tja11xx.c                 | 83 +++++++++++++++++--
 2 files changed, 95 insertions(+), 5 deletions(-)

-- 
2.25.1

