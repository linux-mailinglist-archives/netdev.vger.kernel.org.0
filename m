Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905DE29E29B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391131AbgJ2C2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:12 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbgJ2C2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9/aZ1bJgVQoJocJ7ZtaQHDn7xmFhngUQvwzfoMOYG7X960ZTme6OyWqY1Q0NpHRH4zv0xWfidBUrd/wy5COR15CDEknIUDABfB7JTocxk345jNKLrnXrkeHn9wa9qQcbKmhebBM7HzdZVYt2OV0JGnEkukzRsTe+9tclwTFXAWtqszWPztt32mj+kPdvwKluF8CMINmf0yZ5KwEk7rnP8IMej/QEFhpB3rGv1bxB+7oDTDwJ6ZMx/sAedZB8VDlqz8r7X59eov72qbphf6NDvMqTcQpcCwEi9TQKmRt0Om4B0j4X12maA85DbPog7e9AARd3ey5NLIuF4lylYSahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+9p/YM5vpoAqsyErAwIAYFREiLWdj2vYdbtu+L/1Tk=;
 b=BySpaL6B3TS5x8OYSw2Pup3ZJTLAD6gAsxVRu8FDiB4Riw85EHbJhVZI92k76wBP3Q50sPzF3Y+3gE7EHtOqcA+eFYtsqQbp2e359yM84djSwMj48KylBDxMQJ6oxvpuEW73yfsL6BJUHTzxpJFinSgN1Ar7hXnCPILgIxj0SmsRl8eDh4b55QXgIEY6DgiaAXySkaeKmwdmhAqSYXWMtNPfR+H5unJaDnM6PeNjBJ7ZB2lLOp41eL33/U9K6jPOCPc8psYptHgkvMu1i7Fpbu2VtW5zGYZCycAtYCJEG2fPH+YkjIgjlmYg/jpBWk1JKkrT9/eGu0zL7Emce0+8Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+9p/YM5vpoAqsyErAwIAYFREiLWdj2vYdbtu+L/1Tk=;
 b=bjt9NNWKsaAQdW4ouziy1SExf94DMW6yBsKYosgnGIleBUqGTKBhbVBwITcZKHf/Wu7jGKlik/TZItT2EdZCN+bdJdHHOKEwxtY8RQOe0CeGXK1E1ulUOdFXPvMvM2BjzXyHm/UUa5GrTkcrTCffv5AjqHkj6qGAygteOXGOXV0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:28:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:28:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: mscc: ocelot: classify L2 mdb entries as LOCKED
Date:   Thu, 29 Oct 2020 04:27:34 +0200
Message-Id: <20201029022738.722794-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029022738.722794-1-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 02:27:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 143ed29d-a466-481d-7b29-08d87bb24109
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942E4A4A94CBC41E951111FE0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0hiwHCdYD4lnDq2Nq+87sfx+j87pxLpThlAPgU1GOyDYBCS8yGCKa4RVdapJBq+ekhgg3IV5tfi88QVw07GtNFNogJiCqvlSG1ATtqIH5TlaXXmb3bzGI+UDH5ddLht7m/uzCwfZ7U2ChiWIsRqKPXuKUrtgsP+tcJMYdOFiJvlGxf/0QhJnyAwf+/+OvtS4gUeHMgtnvpp7z5FygM1l45FIOusEN1eOJTfyLnTpGcReBTVcOb0FI5tzTQzX3fW6vryN0hRGl8Jwe7lV1kAGBjIjCnEsrKSB1jW1c2gtcvHKoXCwzb4djDcM6mHBPVaATjP+Q8vpFCNWEId8yeaTM9D0v3+Q9sN7EEgEb5RrEyESa5tEa9DWZJuHCFHMD5ZwMwrIuyXubBIO5oRhvfczw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(4744005)(956004)(6512007)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AtKVCuq2+qSjMJxGBGLxqEqcMiEd8oSCY2/+tMTMn7HeBdy6njVBlx/x6TG3F5NFwB//wTAJOYQxX40bn9J2R1WNnxcARxkDsPmgOkZHnGItWBiOC+W8y0fvzSStUtsgJeYq8nil5Py8RaWEX3/OlZaHNm+WBakiGZSfiu5rhDc9eYPskEq3RXX3h7LNCgLisiM5rmV+POXspRiBXHr5mULwLGumcgrRUXnS4LAV8wZ3nDfcJHnsiUeR2f2Egi8tffI7qpNJLyqHUE8rcJC0A/hbgn2uMT+ux/2uunTgynAC8g3e4VWrmGNk85CA8++jxkhLrPwRgw7fvYfg9Mp8WoqTDWFpCuzWb/MBo0SZE1HaZKAb4dNQgKHGoGCzId3vq7VAtQvFQhkGMqt9OPTssylS+lEHDX/nDISVSYLABScPi1JM4tIVBkZQi8ZWR7gyMn7didC5O8YaDCnmOECt+J3CiLqyijgmaM7bbF2VfAHeVcNkY7q91mR/gWW8WeeqPLBPT97o6rkJNdUW7oAjnp6ybflJTPJ03edJmThnjKWVFM40mWe15FQZ6c1lagIR2dBykU73jwXbiZiuMOWb4/iidM1phiYAatrYCtdT6qiHtHRo+ZknXwrTrCHewP9Bgh/+kHc4XzlSBUZxyHxyfA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143ed29d-a466-481d-7b29-08d87bb24109
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:28:00.0139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7nQ+ne6/lq3/pJ0FlhMwO/C/Z1eH9Z4dZwkmG4v0SDletwUzRcSICxQOAmQ8iPOnAfBcfyGccCZA2TYgO22lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot.h says:

/* MAC table entry types.
 * ENTRYTYPE_NORMAL is subject to aging.
 * ENTRYTYPE_LOCKED is not subject to aging.
 * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
 * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
 */

We don't want the permanent entries added with 'bridge mdb' to be
subject to aging.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 70bf8c67d7ef..25152f1f2939 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -958,7 +958,7 @@ static enum macaccess_entry_type ocelot_classify_mdb(const unsigned char *addr)
 		return ENTRYTYPE_MACv4;
 	if (addr[0] == 0x33 && addr[1] == 0x33)
 		return ENTRYTYPE_MACv6;
-	return ENTRYTYPE_NORMAL;
+	return ENTRYTYPE_LOCKED;
 }
 
 static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
-- 
2.25.1

