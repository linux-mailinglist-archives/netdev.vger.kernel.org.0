Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB5590C26
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiHLG4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiHLG4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:56:04 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA219A9AF;
        Thu, 11 Aug 2022 23:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvNLA+vKS05zEjMOjmoQgo6H4t3atz6C9slU8CLMnPY8L21q3VxxEzky0v+KAKuLBapyt/AlYsSmcl4xDJQdkv33VKn38YB/Oa/UMULFK9jw4EjzJBO8z6Mol6b9yIWVudJpaXP0B5kIZ2nG8x5uUV9ExEjpa8K/3m3ozBrs58bggavXhCO6kvOXFNginc9vif3dyEccIsyPQrauTmE2vTizF2JyVq5tGiaj0esDsZS2caC6u/G3YIJ6y/gXzWWFcQzZAuEgvyHlsoX7Cik1dQZ0U6f69vYdAuyyXxeRao4m3j3YCvhMP2DN4T2W3wRoaGdI9Nhwo4bIyQ5hZk+yhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYlbY3q62BYY1g9+wOLJHOzFxXIIicaV0IbKyxqmz2A=;
 b=KQjVzoqyTk++N3iXYZ+g7bv7fauqXc/WCzjexh+ZG7aS9xzuDPho8D7CfMwi73WBu0JbyWq0MlOBVDp6o2A+P1TX4Bs/+BdX2msXcJXSlN7BnXx/BpDm6rPRe73IBpiLsKxcuo9fLaFAVUF8ox8wik3ve7kRYlMKOZ2lGAHt85wIz5Yq7aNp6etmVnADRMhBqt9ahmQMlxX4PMG3Ftwj/HxDKooBEmUCCudVBNQNOCuoclFSZj07ZTbhRkMeobk58M77hwknVmehtb3sDCiNtkO1NjdfaPNXf54hoAyY9r4v+n8c9c/k/8+2sOB8tv7vjteKUPWEvG2JnqaemUjfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYlbY3q62BYY1g9+wOLJHOzFxXIIicaV0IbKyxqmz2A=;
 b=jEH1Vmm3zoxUSiCj5QrlxYZX5kSTZOcOWxXGqaoGHGo8bZI/vy8FNDPyX3xn9wRuBFAdnFUV8GQjhzUewUkv+RFEQU429IZI9GmaPm1dE+A5QMDcalcY1+h1Rxsx0NGCwbOdXbVgjkzDAOMbM1JjCF3T7td9Z5ZiVQ5s+7Z6eCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU2PR04MB8616.eurprd04.prod.outlook.com (2603:10a6:10:2db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 12 Aug
 2022 06:56:00 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 06:56:00 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] Add DT property to disable hibernation mode
Date:   Sat, 13 Aug 2022 00:50:07 +1000
Message-Id: <20220812145009.1229094-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efc2b412-6b2d-4f6f-2416-08da7c2fb6fc
X-MS-TrafficTypeDiagnostic: DU2PR04MB8616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nff4V+9hLuZwSBSKDK3tzZSxDTKE9LqzK0z1/7nWS8s92TAy9OwIeaNbI9ewwpOEVFYmQznkECoLCzjKTZamN4vCSvpzPqbbE1263DmhzTlPNQfnGFwWRUjsnGGRzXAOwj3tDJR5LKd4VOS7vZs3gcpziwn3XmDAW+qTd4ThXIQVGBERvpOWrsDN74e38DYRdVqBUrgSma8wOVbR/WyBqHK5Ar8R3XUlmGsBPxS0qgZlXi0PXP8Zs5I1vhw4Jp/1/RKccIQoCvtnZvj2E98qSu+8/U866JOD6IWgzZ1SQhxP+1qs3xD+zzl+HYXp3DAD6n0/VJsLgBCri9DF/BJXbNbFgsMbBVj5vkyxS/fy5W9AG+so/I+yl3si3PS2xQ0Fa3hYIqTFVoS/1WuJeZhJRi0c8ULljlGYvKS8XAk3kn+Yqb7I/7bxqg/RMUq6GHMJ0Ipm69liD/qBGD252Q3kPxqecd8L4Nr/htShFFsZYWeNdFjDueWfEbBoEco0w1n0HDAi2YK1Tjz+ufQDTkBYr04kz4w6JRHO66CDUHlTN10kJVO4Cuw2et/WZhI2QR5fFPXcMXHqL02DjpQHKzpFkirt2b4WufTn+18faug5P4PM2SsRvQd42J2OZDNdbt29imP6n5jBR38DNGMwhjSFzVoTmDvW49fEBef83qIhhnhIBfvyxRBz6p7o7PAAa3Sa0xa2UnRL5YHAQnb8jJHzCYl61cFeZhPd7eeRkECnMAE4ED+F0V3GqUPoIetsCavW9sV5PXM2QCyPuMuGh3VytZlwXAcqDLnAIXtBXI+7hzJpCu6FdBK3+Ol/MCPmZZMvKktzSb66KgKmYE+GQ1M7iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(8676002)(66476007)(66556008)(66946007)(5660300002)(316002)(4744005)(7416002)(2906002)(8936002)(38100700002)(38350700002)(921005)(26005)(36756003)(6506007)(6512007)(86362001)(478600001)(9686003)(41300700001)(83380400001)(6486002)(52116002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4VsDFIRJp8jS0YNM8QSC88Fiy9tdEaX/euHRglsVQEodkOJm3EytOvS46jzQ?=
 =?us-ascii?Q?EYCHmqL8wL1uUuquApcmUvjxcnCyeRVYp7dUx3kUYteoN1FRtbgu9Ju3nB4h?=
 =?us-ascii?Q?XYUmZMuOcdbXgr9fSgsXYq011YREXoOO1aZPO/DteHwtY5L9q++7ESejRnT/?=
 =?us-ascii?Q?eBYUXA61KP3Acj/cn5WF1BYihzs8atsw3rO3JHwfBJsFZeBYty/SaSITdZDP?=
 =?us-ascii?Q?CwY5xr9cfNBhC3vEVjDMTA3LDYUI0oc7I4/+B0gvCpICo5PL8xdbjxylfrgM?=
 =?us-ascii?Q?HRYdCtK1nDTVoVH4l2URwFFk1VZpQnBDKcKDpi+zv0o9vqE1AbBZrEFYId/H?=
 =?us-ascii?Q?NEM/fwkveECNTtgiTHVm5PrLTzv0CRAYSooJYB0R4kZtmlfPnQwIOOD69FtK?=
 =?us-ascii?Q?D7hogx5B3/HOKRu+rMaNI9fGkmOHhCeEhYR5GgXXg4F6IgpkxI1tw0EcaPRn?=
 =?us-ascii?Q?greUsZQRyPhkkX+5Tic/Te0KK1pk7Aevz7tvVmeIri0JaBItVLnyzzvffrlg?=
 =?us-ascii?Q?UIovdPuJ1Ngos9hau+48+p/qdL3TFhDdgBE4loqC0vg2wbIuaT/LBNUWVD+b?=
 =?us-ascii?Q?AkUb8qE99AxF32UaQbtADAXEBX8wFathUYuXw/secIPHE5hvD4ZQrgFkMmnt?=
 =?us-ascii?Q?PXb6UfNcIuTX28Q4zHZZV6u3ZYnqZX894a7nCl3RApIApR0dHoUht5HYIcV1?=
 =?us-ascii?Q?ksxIpeDkHGIxZY7W+4a1uILSApZahnGrfkBoJYKkqR/3PPSSuy9P+kmt6sD/?=
 =?us-ascii?Q?l7us3uZUiLaCpfvHFmt3eiezEDkM5i0E4A5IQIKnXFEJHKmA4MNr0sp795Zb?=
 =?us-ascii?Q?noectaY/4i1un9HxyLjT55yGPeTdGR4I+KcIOthMXNgu081YTWHbqE04zzPr?=
 =?us-ascii?Q?/K8anmCs4zfFvnkLcxLVcFATQuyTeTdImTD75U7ZtY4XaP0aejjmDrOOO5YS?=
 =?us-ascii?Q?wwmL9fJ0PT5I+jkTw8xNiVqn+TVPDTYlnbxgF9j1pR5VJfSqP6/6jrdXnpeR?=
 =?us-ascii?Q?X8TNPwk6/W9jtjm+6yqpzb3DZ+nk0V4eSWg8GWZ+h19kN1NaEzBmhkKYpQ/P?=
 =?us-ascii?Q?w5rwBKftCQ5DsdAUOZu9QxqdBJrOXo02kiZwcFEYg3U0Syj8snFq11sW+7GZ?=
 =?us-ascii?Q?pUPVPjwbHU3Ej8nBVsECkPcE3NM0/7Sul9J9NH2KE6V2Rht0N0S9cdzjpWGT?=
 =?us-ascii?Q?LMYcBZY2h0RYeY7Mqq2IHBFteTwaOP9c//IVDIu7DGi2QP4NfGIcKZgmgc6t?=
 =?us-ascii?Q?42Sd2CtAD99nGNE2HYbGWaTXtgd6h6XNhJuqYqX/gl6UR4L4gvglTwdvAxAl?=
 =?us-ascii?Q?2mUAdpZ4084WrFaT2EhYy3DD0OVEOGSs+Z1fSYaIIpPQc5ZfJxbBEKNwe0Sh?=
 =?us-ascii?Q?eViniPOxHrDEnVvr5mxZuHuV7uFWMz3DI+AZAwY8qgi1q8Tl00l3cVFgnA1T?=
 =?us-ascii?Q?D2KXWnh0Y3cr7AmUq2TufPdQuJXCatHYtNlCWtTVTrOgffZSQiXEK7vUxqgP?=
 =?us-ascii?Q?p15lMF68fvHURhuIU/J9eEhF+to4BZaZzmu7DpEm4f0Le3b5FqDNOBBvvvJX?=
 =?us-ascii?Q?tF6HsyzmxF0rnN0JKRq4i3vF8czzUFvB9e/4wyd/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc2b412-6b2d-4f6f-2416-08da7c2fb6fc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 06:56:00.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWIsUj5asRjvStYVYbe60+iW+0xqqJdggLwg+/qOYHpYaYAGqBMgJXm5et6v+VrG0C1r6xymtn/0/mAVS6hNvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8616
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The patches add the ability to disable the hibernation mode of AR803x
PHYs. Hibernation mode defaults to enabled after hardware reset on
these PHYs. If the AR803x PHYs enter hibernation mode, they will not
provide any clock. For some MACs, they might need the clocks which
provided by the PHYs to support their own hardware logic.
So, the patches add the supoort to disable hibernation mode by adding
a boolean:
	qca,disable-hibernation
If one wished to disable hibernation mode to better match with the
specifical MAC, just add this property in the phy node of DT.

Wei Fang (2):
  dt: ar803x: Document disable-hibernation property
  net: phy: at803x: Add disable hibernation mode support

 .../devicetree/bindings/net/qca,ar803x.yaml   |  6 +++++
 drivers/net/phy/at803x.c                      | 25 +++++++++++++++++++
 2 files changed, 31 insertions(+)

-- 
2.25.1

