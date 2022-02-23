Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0E64C09DE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbiBWDEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235946AbiBWDEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:04:41 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on20722.outbound.protection.outlook.com [IPv6:2a01:111:f400:feae::722])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F7850446;
        Tue, 22 Feb 2022 19:04:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0a9tz4fo8nl+7oqaB6izDiA2yITNNtHjpLAEC8Z8uT26dEhwoNEeas1b/nOrc5qOM3u5+OSYJSVcyoIzrscDLq7ShadVwbrWufutT0g7dgph5lqYaC6O+3fqHDdO7ylk1+C9UZrW3OFtbQ/QihcAGpXKMy1z8NXYdrShdPjlhkHyQivuV9feUNWBnH3yTOeoMwe3If2WNLGI0EuLCDR6u3rDXJRfK7CS2QkUpb192UhGHpM11mITuYhrZDD4BIUhFrNPLjJWySe2mHblWtJVM4qt8ApEW4Ye7LWUjofKIg8okeTaECo2+Vuod9HEu24tA/HbQeLOJIWGulQTQlqSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrmjD0JWFnaqzD9VnmlIZx5v3Ii9nglD1gVnstI0P24=;
 b=JclI3d0RRnmhwvImwv0VZrM6zFa+v3203k72uQfp3Bfad+MaBqjugWQPnRnlW5oLjH1uPRg6OpkgnB4RCS+XjWFIY+QuVlDxYlLTUVnJaNlTzyESFyWVGfHuKRAYLCLEERL8rHMzxrV60+/Wlp2NmOk3jj76Ge/w7AAM2QP/ohy+WGOYa3uCZX+hD3x+4pA5A4OOPGpFmsBM49G0OL1L2ejUJnM575thn9b7bz4iK3RD5lhvgkAcqpaVKRNrHLVDcsZtdcyI554lBWKZure7w0zhp4up7P1PapYqXnPHPp7zGGJ86OYe7Xlvvxhiy2Gks0P/5HUlhXhkvGj+a9cb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrmjD0JWFnaqzD9VnmlIZx5v3Ii9nglD1gVnstI0P24=;
 b=Di7GsQTSnhHUoX9C5KDM2GQWeYWeO7fCFHDs8NWEBQ4iZy835DVkq2kWNMmlf3qLIJRWle8d5WYKI6FjXSFlTkvSa4fHujjgQSAbGIkMjmz5ttkw1/mYxQrBWneiXj5geb9In4+79pi2eiZWdBO5gT1q5GGl1ZwS1hXVN0c1/BE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 KL1PR0601MB4225.apcprd06.prod.outlook.com (2603:1096:820:78::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 03:04:05 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 03:04:05 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     jiabing.wan@qq.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] mt76: mt7915: simplify conditional
Date:   Wed, 23 Feb 2022 11:03:44 +0800
Message-Id: <20220223030346.403418-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0008.apcprd04.prod.outlook.com
 (2603:1096:202:2::18) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51c1eee3-8b6c-4d49-6190-08d9f6792690
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4225:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4225A89BF4C6D448CAA11C36AB3C9@KL1PR0601MB4225.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDzwVXa8SBW2xU2D5cVIwsYKYVFXMnVwp+2dkG3Us/n5pa6XRLStijg4o8QvOrd8LvWHg+Wx7S8FxREb1dD0th+IxGh4TvCqA76r/6NiYcMVdckZLU2THd8kVJ30I9Gephs/r4M6jp1tE164FSCKgAK+b7Vni5yw7ODPQnEQ9EYpY9cPv2u6u7mgLRhm8vq812SWZHtA4SIaNhoqdvBzJZy7XQh+L4ajLEF8h0j9CHzpRZJrQc3chaUgcll4iUmYTI+4B0kTomjIgvUyIYYs1oK9mDm8V8G8ytH7IYqh2GmTmW50XAGwF/3ZL8/1Lkn8AkBO031QGUU1v+GRc2lQrQ412A4OI7eNOOatSDbHKbO4CREP1MafvXMKiT9xnEFCvu5iZ/Ut0VhvSh+BqkOp1jeQTgZfriMnYmOZ3DiLKu/VVurazJBKtHVK1OYmdQckR5zGBMqb/WnkrsxLAgOOu7pDt3GYBoU+z5KyOMWKje9Q8erb8YBapV4BLtWawRr4EpYrh7hU/Th8fb+YWA/q3XEQiyy3ykw90erB74SN5l0oufV834Ok5PttzGOzidByrTRAzuxjCB9RXlyyfnSOGDELnieMUjAiFsYdLXU18d3kCNTDuqozXZE/lPgT0HsnvIoFa+jLBJKTOwJKW7YyOWql1/Y4BojTMizcBOsJL8OAujloPGW4u/eEgE6H3NRHQ5POaK+pkSPFAUb/bpvSSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(110136005)(921005)(52116002)(38100700002)(38350700002)(66476007)(66946007)(66556008)(8676002)(86362001)(5660300002)(6486002)(4326008)(6506007)(6512007)(6666004)(8936002)(7416002)(26005)(1076003)(2906002)(186003)(107886003)(508600001)(36756003)(2616005)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V1xCdSm5DYgUoimeq/O0i985ytIs5CFhkPHRrm5xFO1G5aBcDprWgUDwyU6t?=
 =?us-ascii?Q?/G8TmSMaIsomI4GoATV2zJ0lZZKcEEGSGWSFdfmz7lFsraRNNwQZei0XZKtb?=
 =?us-ascii?Q?0uiikInzkJU1TaIMGP5Lc3Z4LiEqaH9jocnNekOjdBrKrc1AjNeOriTaBT/o?=
 =?us-ascii?Q?MJKNkojKSLj042NJaSAd9rb5WZFYLZevjn4nvjPAqn7x/2caHKWjtaivEZwv?=
 =?us-ascii?Q?ThBEXIvDrF5W2MHzmqs2drGA2IIm8327E0ujkEuNL5au6xZPQlhDCztRb/NT?=
 =?us-ascii?Q?s1ukBF1TxyDKthGQ/KU0oFwMcHChgLAXzktXPZkEUEe5sJriCNW2D3dN432D?=
 =?us-ascii?Q?jY0Z0Kkmj5enbK97MiGd2at9KHjXwfLRMHvzJJBDJM2Q0PbDDjTGEi2uJUCu?=
 =?us-ascii?Q?cSj2EjZ1Kz5cJ87zo1jClUV6PvUwINPILh56k74s+7I+vJa6wqttbaeueTAI?=
 =?us-ascii?Q?vwmHjQE97yLJXegPWp7Q6IUXMLIXrWJLqwFkQK9+imvBPr5l2KGwjzPey7Lw?=
 =?us-ascii?Q?07PQSMTTfqv96aZ7t5YyiO/qUYdsY4ZC3yoqrB11flL88VdFB+IhqjawGypz?=
 =?us-ascii?Q?oIJtCnN4Ql6eaGK2kQIGh7Ke1XKnmmEPN92VkJB/yB+Cv4WuVA/MqqtgNID2?=
 =?us-ascii?Q?557IopRIUOpySzYns6dfL4YawPuUkfc4ZDNZMc/+71aJQTyBRbfJwILggyGB?=
 =?us-ascii?Q?sMlmAj5JnMQHnUQi0L9WVkgWgpobXx8/fdUje5eNC6YJmLPJKTSmknM5FyjO?=
 =?us-ascii?Q?XcEdPN3ZzbY8tZsRy01NqN6NmAY6btBFrgB9Z0MJXzH+yjM2D4q38SeQmMz/?=
 =?us-ascii?Q?q7UL9+1or9IGTtNScXJGSblDixyL3TX1XYSrTvGWeA3eOPkhE6wWl2w/fEOU?=
 =?us-ascii?Q?647+tSUQeTY5niWWrMZ8RJVb0TEtWgqD6oQKNsw0a/APTmuUwFlucNoe3HZZ?=
 =?us-ascii?Q?w6YADOBMwaOTabhmAzHa1LnOSjyQ5U4QvJ6oad9tJdUkUM7/KzbgQGh+VHZl?=
 =?us-ascii?Q?xqOKr5Gv97m6yokYXOmHX3ZQtLG21GGWyDFHJuDZyLM3XNXU4biHdsMTWZ0r?=
 =?us-ascii?Q?PRqas8+f3m1wmTfbiVXY0vWw35+RyJEI6aTfW6z7Ad4MFMJnRrWhUq+Dzgjf?=
 =?us-ascii?Q?CRUQhpo/pnJ1Uz3YP+Pk1UzKXGEQj51XwIPjLlAYPTF1BGDSRrnCXX7du5h8?=
 =?us-ascii?Q?uZUEpoDsSq1kAHHF26JaIPs1qF7VO5vqLOeBU5i+1ayLEURu4mhIzhwDn09L?=
 =?us-ascii?Q?/EZ3SjlsfRBgl0RgJiV3TtP6olPzXwHu+L28OkV1pZ0h9YBOX/cnPlzIfvpj?=
 =?us-ascii?Q?C/I4Bp+ftadNnshgZES8pUvcB8hp38Gh9KnB2BvmB7VkL3ipu3zK5I26ZxIj?=
 =?us-ascii?Q?S2vAuvb3JP2nJgAu6lk6EvpdZG5CZeHw+ll2L8xkTwcPnTg+6QTdyxI+GI68?=
 =?us-ascii?Q?CK5TKOGzzbTS4hPj+yh2TbwsJAit7GmOucDzIeXGJDQtMtPjZMtLREe8lrjn?=
 =?us-ascii?Q?MOTa3E17JVTApUa+uxejneUtWgvV5GZ+AOnwu9q4L/JKZGXVBPxfKQ8kXzi3?=
 =?us-ascii?Q?kgW54X9J2ccOWvtd/13ME20kG5z/NlOoHMF8xZCrAbazF7TZzxc+C/GgPak8?=
 =?us-ascii?Q?8GvfVcmEQ/8R4G9MrPDkTg4=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c1eee3-8b6c-4d49-6190-08d9f6792690
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:04:05.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xpC5lHj7fYwlYPRd5Ap9GuDQMri/Aog1HBvkpMksefKjV41C+ooAg9SBnsJP8iEjki7iePXaP1NOvOLqNWnPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4225
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/wireless/mediatek/mt76/mt7915/mac.c:768:29-31:
WARNING !A || A && B is equivalent to !A || B

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 08ee78f6309b..7417b03b27a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -765,8 +765,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 		}
 
 		if (!is_mt7915(&dev->mt76) ||
-		    (is_mt7915(&dev->mt76) &&
-		     (rxd1 & MT_RXD1_NORMAL_GROUP_5))) {
+		    (rxd1 & MT_RXD1_NORMAL_GROUP_5)) {
 			ret = mt7915_mac_fill_rx_rate(dev, status, sband, rxv);
 			if (ret < 0)
 				return ret;
-- 
2.35.1

