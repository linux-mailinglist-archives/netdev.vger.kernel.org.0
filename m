Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFCC4F6164
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiDFOAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiDFOAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:00:13 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2125.outbound.protection.outlook.com [40.107.255.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD041E179;
        Wed,  6 Apr 2022 02:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAEq65/7sXHdCXXaAfBELh7zllb8jRZu6XZuphTcic34bIzKPDXKBq5hR0ksUGyv/BxWpYorQC5eCWUZy+/etqHxZJwnUAoagX6FOgeJL1FC86MRJtu15023kUuzerZRTHpAPtHmcIRuxcdo4bm2EIer/WcV1SNnlplNyzcqkrxZFzI8W6yB+sAaMdR2bdwjYWJl4EO+tck3iCP4ati9i1YX/Klo4/MuQRRd6MToH78iwwT7JuK2HdDaYTGLuHJR9u0SP5tIe8lsqHSyMYuhJnQWRa9j3zab39HIsBJDp5+DFN+Inz21zWYrM823voAdZ7HpzLaEpO1IPTt3z9dvUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TX+KffmLSdKcObPxPYq4w7P09k+IE3x2sUc4hdGshqQ=;
 b=IC0E5IEKBDAon6uwCVSCuk90O9gK4skvhdkGDH29ypl/HFYZ6khndfypbKtR1dPBzXi4ZND4u8j5lH1Z8PYLBbfZ7dsLrU6qNJDYMe4vOZDhoncdj39Kg/IFy/lQK82rTzysjN7kaPAisOx+IfaGmT3XYoN/k0UXpqaEWqWxBqHGKEYcbjPebEwOa1ZrA/z6czuilSifbtFjw14atZ5Ujl268skQ82zVJh2/qGUPe68MNOoPEO8XUi/Tq3GpUNvbOkVbFuqqBIWd4azbbqMzCaNpqBzPYbKNaO/qO7EX5aObUNLCwnNuQWDng4ump8W3/gO56etXp2mHb28wPtBeSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TX+KffmLSdKcObPxPYq4w7P09k+IE3x2sUc4hdGshqQ=;
 b=QKJPG760C3ePfXeq1HFk9oqbMepGeQjc6aLYItYodVGazESa58bbsZcW/7fXrqc4eeoensdXZM6BK7UvpCQ8+bAqH3XDmGahv1KwLkv2Z+Ept9mokUhzApOJP0ZwKAxGrp1KXiDd1PMU+4d5TJa2/nfOh4xRa2VcyewXPdUOxzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SEYPR06MB5255.apcprd06.prod.outlook.com (2603:1096:101:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 09:17:20 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::e468:c298:cfe5:84fc]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::e468:c298:cfe5:84fc%6]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 09:17:20 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH RESEND] net: usb: remove duplicate assignment
Date:   Wed,  6 Apr 2022 02:17:03 -0700
Message-Id: <1649236624-4208-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0175.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::19) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 965d418c-c74b-4712-4c62-08da17ae4048
X-MS-TrafficTypeDiagnostic: SEYPR06MB5255:EE_
X-Microsoft-Antispam-PRVS: <SEYPR06MB52553F50270B54090D24ED28BDE79@SEYPR06MB5255.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eh8Mnoyk2uQf3Py/mi/VBVwFOKSJ4VQSWBl+KCiSrNGLDCJvVOFqHGgLwk4soZG6OheUXlEyF+hkIOQcICVfhiA2mAmxJZ5hicND7ZFYkftjlnlnBSFXFXjda9McALGEYcoSwCeLosNUDUVJALmwSt/ulVMmRWNbxYldK4V7nCVxs+cW2uSdqNrnpcoHBv9waZl9/fF3yU2FbWQKmaYqZ7d2RdPm12a4bMXcRMYPdQRoEJCZa0CL2NqVv9yC2zf+LiAgjXwueEABKqmeEKjiRBC6+jQry/84ovB6PEJvD0hKqaA9mCBiom23w64Pof49hy9+RT/XIUTplSdmNaeIB1L9hrFPaLC4gmki9rHwV46TwWrYclkHSv8GkI+WRwlwProKpxf2rYk6wEGCUSUrImv5HemgyZogtdl91ANNAUXC4xb86MeO5PffcFbYf22b1KPd+TwZHF8G7AMciDb9fwT8xEpYZVFCMzG02DgnBJ8ED9G4vpm8xocj3f82d19n8qMB7cyWvK2FEwlcuBmf5OwrNnU671vheSCmjTHdNfhm/muBd5Vw7DOEZND+dEYK/4pK2dIoAiw84VJ4YAex3eX//wEUe2m0X+w8Q+RrBHMNMlkgYpLcZvEGkxtfe5f6EizYdalNex3oSJNLy4FWI/aFMX0x1G2/MfewCixpuMGG1F9araSHPFAOksqKUoQq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6486002)(4744005)(83380400001)(6506007)(8676002)(508600001)(4326008)(66476007)(66946007)(66556008)(2906002)(86362001)(2616005)(38100700002)(8936002)(36756003)(186003)(107886003)(110136005)(38350700002)(316002)(26005)(6512007)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yfUZpUO7cbc3NRk37FlAkPb4hdfwI7f5hIkKrZRLZnXl01YCftofHjZ6pMD0?=
 =?us-ascii?Q?0ugSGOTD1r4uDWfeQihWVdbgOoIdY82dvTIK/k7zY9dUbSho2XQYP8pI8Dno?=
 =?us-ascii?Q?KHUJ4cwHaRnRZWaK8BmYZvjKCh1vbttE8seXanp0Vrw3ioDiUzPjK8rsHKOR?=
 =?us-ascii?Q?cW8iiVylTBnhzv6oOTa17Z1OwPdTg4Z1FVY+Pjkf5LEX3jyR5Pb/b67GRxtM?=
 =?us-ascii?Q?L26h6wRBwKvw9yeGGwu98ygisyXOAgxLKtFwQ+ZQRk6LG/pTSJ2CkSw2pTjj?=
 =?us-ascii?Q?ikP6dpytZBaL2gz7Yf30DxeYZdO7cObLlb59QFZZKCiVKJpUXRysGC81ZG6A?=
 =?us-ascii?Q?rT84gv91dMqh7HAc2aVSvbhUOwtprTbtIk3TG0Kt1cQMN8giZMHu3vdKUWQE?=
 =?us-ascii?Q?29VaWz08dQHdcf5GyIQu2eQmnBD6Pb/x1UWJS7bYklYODnNxpjXoM5aKcHma?=
 =?us-ascii?Q?JB1LGKpKkp1KhnSfBixnOwqAlkCMduZ0nbqkM/RvczUfXRN6m9RuPOZpMMok?=
 =?us-ascii?Q?DkHc6yjsluQSluHnaOrppwuooVfmbtbRvoF4nuzlZklzWJVO+83En4kyXLHp?=
 =?us-ascii?Q?Eoltfy4YcSaEp6Xr2CFRaF8k7OUGXDgIyEFIB+Id9VO0zagwudOP92KQh1Dd?=
 =?us-ascii?Q?7G51B9tqfcjLyXIvIzsPBbH1Pgow7y2pLbV8Hybp+52amBZHcawoPwIUWrcZ?=
 =?us-ascii?Q?nRGvJAUvazc0pQRIYFzjIYe1nvieYrGly8vyplaWoMsEuteOfEXNO81JyPXL?=
 =?us-ascii?Q?XFT5X0JchuC39/b0Gyvlav6j3NtyxghvttmeDm4npLXq2KjIqL12HxlOxcr/?=
 =?us-ascii?Q?bilTJdVo5dkXiFOaGmBoDTL9yYfx4VVVpvCY6XUBrtNaGDZjWoZ5RLKgMwt8?=
 =?us-ascii?Q?waKXyRrmxOyueUx72INCB0sfsqyk31KnWtgmlbQeOQ/+APViXeqG/MJt0iXO?=
 =?us-ascii?Q?0ipIDJUOTPdZwZRsnkAL6vsW4kWKVIMeCL1yowJoMBHHT3lxxs6Ehh7ScdnA?=
 =?us-ascii?Q?BIrIz3xqbXjsxkPqziYjxP2v3T4vq1WuYFAkVwGE177IQscUDqf6ififttaM?=
 =?us-ascii?Q?/yVzWVugw7OmYq69S63uz+527wxEhC07PAqz4NObB/zUjHKVcRQpHnEKpr2C?=
 =?us-ascii?Q?COIdfG5LrM4ITbutQ3vBA2EoQZsMaEYKTtlcP5x+/ULlZ9wWz+VGkGr+DqSD?=
 =?us-ascii?Q?q79gZYBzR0+CAjOAZWbvCvR9JVdg1OHfI2fPM3+DDcAUZmqchH+fC/quRawz?=
 =?us-ascii?Q?Dez2MvPqHk3YqW+sX3lelmRO4rBbRZv4ESaDc4SHJofvqfs/xbWDnbWUGLMs?=
 =?us-ascii?Q?VWitcJhlOhddOEOUz5vAG5jsEv2XatCcCCAuY4rhvDEyl5VYGOECpxLZ+WOX?=
 =?us-ascii?Q?u3ssdARwqIt835ZUQCGV14/9Khi3GprN++69YYG8c6MQWz8IAuWMF4Yh4jo9?=
 =?us-ascii?Q?MqqgETXvyUT577gckFSnxqZD3InPqoQlLg+kzgiqxR3CCfmH1Ul3QZ0amROb?=
 =?us-ascii?Q?GbuRa+lbR9UQ4dDNwaitDm1R8zNlEgJZUf/vj3KcfcCFfY9BMByVPuawMEH1?=
 =?us-ascii?Q?3YQXmoIt2yjubTiSCj584JnisHILOsy2SZMwh3km/dfjpKmamn+FZW9utFqz?=
 =?us-ascii?Q?onUwf78LFWh8VazYPFev0mnQE04QOFKROywDk70GTID1DHVpsyu2I/U1dwIR?=
 =?us-ascii?Q?iuwrLmHvDWvhrTrsLoMmP9Azkp5reyEbVUoW2fSMrs+Qrp1xvqMYNx6WPc4L?=
 =?us-ascii?Q?agYy7fJ3ng=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965d418c-c74b-4712-4c62-08da17ae4048
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 09:17:19.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58VJw05yOz5OHoRhs0PbX3SzN0VWjb8kRGFeZDRsNUjq0WemTAS/y+Rqz/T50TeCjVTlCpgOejhE0cGnfdiAkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5255
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

netdev_alloc_skb() has assigned ssi->netdev to skb->dev if successed,
no need to repeat assignment.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/usb/qmi_wwan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3353e76..17cf0d1
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -190,7 +190,6 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		skbn = netdev_alloc_skb(net, pkt_len + LL_MAX_HEADER);
 		if (!skbn)
 			return 0;
-		skbn->dev = net;
 
 		switch (skb->data[offset + qmimux_hdr_sz] & 0xf0) {
 		case 0x40:
-- 
2.7.4

