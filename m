Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E775D27360D
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgIUW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:57:07 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:20979
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbgIUW5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClIoj9AniAeauEnkJiCtemnGaSHajqNFWKmjOCIcaOXQDoi8eERt1ZzR1hUh7x6STr4TRRMMyOUF3hPXnaNkGm1INnAh/JUn/GqDP/hbjKubYBHlEwLRLZc9a5GWKyPQ/SZqmbFEjlAB+oHUlg4/lnr9gsSJYqNhpcIvBl4v+jEpn/COQAHh0N2G0ozS5EnvxWLVqOIjg9op7QeVD7A+LrBACVWXm6jgr0LgcMYLo21ZdO0/ekXvb3YRAJgsfvpW+m4LWahpJdBnIijwtLM0V34J7RKLHuuEW+tXLJjlf7Rnr4QOO0zMy6ud0JbiGU/7QqgAyNlrq2qlyd9wpQRArg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sFRFNdbZfSY6SOrMIrM32qbc8si5AJnohMkOVIuS8g=;
 b=hNC+wQHNGRZ5GZrgAIpKzqj7skFcSPAXekA2HPyHFQClZdeU1P5Ub9R/6cJG/oZr2Zesg4kJx9e8hXACVLAlrRgzf6sx73whWRKus/gtpWbUfWItzniJXI6KboxeU2mfqM93yAeP2SVb2Lh4b0573JsN+L4jBlioafSHXk+mVfCxgDICiPeIA8n8KSZTdk0r1J9gFYw5HQMvxH6WdJDOzBBacSmtosk+Btk3DDGCoVL6ebX7qptWn4VTff5rlCFjG0TNP4k+6Kj7JItaa9pdur91o0/KitntengPLUkG9J/MPOckDcHWLYEnKyYqLTaF10GEgG4E60t2HtXaUHW3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sFRFNdbZfSY6SOrMIrM32qbc8si5AJnohMkOVIuS8g=;
 b=UcFVbbDsyxMfDjvqPD3G8IdEOyO1g8MQlGiWLcSX4w0Nggzjjnjq+f7XhszUxSa10JoVXmLh2K6HNHoNwBJ3n66evxe6JEKh1y94yU5cd/1vD/3oyzSy3MdBew0jBnjZx695gkFXBK9nKkjjs3wB6KE/fQgXzTr1JH/eiub69vo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 22:56:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 22:56:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 0/3] Fix broken tc-flower rules for mscc_ocelot switches
Date:   Tue, 22 Sep 2020 01:56:35 +0300
Message-Id: <20200921225638.114962-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0047.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::33) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR0802CA0047.eurprd08.prod.outlook.com (2603:10a6:800:a9::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Mon, 21 Sep 2020 22:56:58 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9bd16934-1bb3-42e7-1546-08d85e81a514
X-MS-TrafficTypeDiagnostic: VI1PR04MB5343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB534336C69B7552FBEF9F028FE03A0@VI1PR04MB5343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bZnrY0SGbC5nDdf1tQ9OwpbDa97fFBh00N3ciuBxRlSJCyGv6j5F5lWhTnEoykBzrt+Pz5yRCUOiTTYc8TYJekNcTquzXDJNKpVgJzLd1IzSrWnqZI+EASxz1zuncdiZGUDnFBMvJhZl1DtwlxUOqyfeDQxXkS4zTvPTsBAtJHp/7pGUB5uqpoKWZjd00CKe5MuTB3oO83Pa39iW7Bmii/oq1eIbAiTeUsQ9uUaukeeIF2I+OS+x8KV5H+Wrr0cRf3MTo8qWVIRSvV527PRR9FnR20GvDjrP/LTxTT9N9uTYA7YtZ2Ll/bpIZpMuZw+E8PduDBDISF3A78+bqLW016yb0OxCfQx/F3caPj0cfVliI9kSndLODYY/ci0YOXpLgVQIn7jIJltNZZty7zoObmjP6oV1kQCGNm9ZLhOC6/0NGz9S+PjG83/h2rwROLf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(6506007)(316002)(52116002)(6666004)(86362001)(6512007)(6486002)(2906002)(69590400008)(66556008)(8936002)(66946007)(66476007)(83380400001)(1076003)(44832011)(186003)(4744005)(26005)(5660300002)(4326008)(2616005)(478600001)(36756003)(8676002)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IN4/vdSleLxCDIHf0OQ7+hUrmDnitFFRa258q6yLv3o1p7L029WvTy30NOVB3DkvLmNzybGF36SdCzC8pzNjlhGfgYu8SMBnk7BCNWDBIgeFagIXMj8/pxOeDD+JcSNGRU9UZqyYRPk2x41zR2D7ck32ElQjl0THtQajpymFCVISoi/z8MJp+txvufsagxBfxMRJYy8SsqfVNSBk+sEXbz7kwyROhEwTaD8IsYCbjb1CBzGAyXdmSkbBCioeW1jAT4Hz2a29kh5eMEuBriyLRZrmFxilsTcitOVNU8zv8udEMZvDyRB/pb2jCIvEgzKLNA8mu7qvSW1Tv8YJVQ5BR56CiJqWyIyUyCfpUPm0m+9SWebz5+0xIcfANw/JaSjwATgKzfBB+84mVvA939awb2hKfMakDHAC/sDdKgoegGAM56qop7IgUKPazCX+vBEqXFuHPeAkubmkku/XvfuwMNhIJfWO6nKbV+V0p1GDSll7+4vTaixMeXRlZjHOlxmFgi6nNAHL2iYdLfy9SPAnCfH0kv0EC7cBfXHtk4pDDgGF/iGXZBSpZSPFn1zh4JdvEXm9B6YVIYIvE0FhSxiOr45eGXBmCzRpmSulLrQfwmuQX3sLXcJ33E7YITPFNRCrgNFaStq9qmAIgBCYk51M2A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd16934-1bb3-42e7-1546-08d85e81a514
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 22:56:58.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5RHH0GIXWOB36rvmUlexdxIh78goj0EYPWTkdYrbXqJJz9cQeJ4fsx8TXMgvDloEBcJrcsIoHEJTkXIjq5dJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All 3 switch drivers from the Ocelot family have the same bug in the
VCAP IS2 key offsets, which is that some keys are in the incorrect
order.

Vladimir Oltean (2):
  net: dsa: seville: fix some key offsets for IP4_TCP_UDP VCAP IS2
    entries
  net: mscc: ocelot: fix some key offsets for IP4_TCP_UDP VCAP IS2
    entries

Xiaoliang Yang (1):
  net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 16 ++++++++--------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 16 ++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.25.1

