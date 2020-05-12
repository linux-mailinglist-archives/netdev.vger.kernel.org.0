Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770801CF2CA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 12:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgELKqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 06:46:18 -0400
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:6240
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgELKqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 06:46:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmM3tnvcO3FesllDvt4JdHxbiIKR6RZgfc9AdnKiEk2h6NQ219g3y0HCNotWOT1KSqypvyMRHv/W1jmKcdBotYrBZW9kUEwARdA1TDgGrL6XaVeOH73yhjgK8V3jK4URtHpWVs37rY+QhrP/ia4QmszBq5dw+oJPlE8xo7yCjM5ZpBhLvdkC2Q44vI4WXFqT1wd4o9PCsJx0Sy5Mqfl3GvSzrvZ+eol4xbSO7luNoPN2RQl9TRPePvPkl4A6BrNVHw4/YW0oJL8WZnAJBbWvbUsDKVwOht53Oc7Bfqb5ZIFaPw4wuj19u/PeJxNFHiB3eG500dG2/RsW5rhcIPQqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/INPiDwLm7Y7o+u+nwaJB2Eas52FPS76u7R1hv6MwSc=;
 b=HXZSmUGvIWMCIxVE9gQ0EdvXAVLraFnnBtoWGyrGrbdtrUIJw8dXaUJcU8sMInDrB9mNX848lybZndqXFhbXQFNzbhqbnxtYEQGCvm+IMnQoVB536CaHqwLelqEusrIQKlKKoFF46FTbxOat0UC2hyWWfrJyO9+JgZUpEvC/RJ3CLsaCqdDammGmJt+k64wyjrAdV8ndqo8uc/ReUCIUKcIR0+s1HDij7gW9B0qK/uGNzuh2JB81fxwMkKFNTSh6S5B2M1qtdELVBU6Mt0M84rRHuVXehNkVuhsdiGxarMmPhpBVpCE9CN4xTnitdmRrdFWGSrR/YV1uKAcazbj8fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/INPiDwLm7Y7o+u+nwaJB2Eas52FPS76u7R1hv6MwSc=;
 b=GnzuB0Ia4wqqAg2qF1RSbawSiiPmeweN8URbZETpAzdfG7wygDUpshHi+P6+5Ft9SI6udBwrz2GfAmAVHMMxifpoJ/6DndzpLtUNf4NCiNi6B6DvzyqVjX8ZBvOMpy5kxUDmj7iKbwKAZCen27rrI3EXhTwNqHvp1Pv0RHJeDvc=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB3671.namprd03.prod.outlook.com (2603:10b6:a02:ab::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Tue, 12 May
 2020 10:46:14 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 10:46:14 +0000
Date:   Tue, 12 May 2020 18:46:01 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: realtek: clear interrupt during init for rtl8211f
Message-ID: <20200512184601.40b1758a@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:404:f6::16) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR04CA0004.apcprd04.prod.outlook.com (2603:1096:404:f6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 12 May 2020 10:46:12 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afde11a5-79be-4b60-8234-08d7f661b146
X-MS-TrafficTypeDiagnostic: BYAPR03MB3671:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3671B8F477D027E3055824BBEDBE0@BYAPR03MB3671.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILxHXgg2+LXI8su7+Vb3fRZhDVJN6bJbmqz33boEJADp7em9piFixK/TE9Xrc4lncCLVBhQFFoPqkMY2BWCNZmMhdYNoMGydCRt7mjkClsitP0hsRie0n0z3l6d6uUQkpNlwLcHuJRi9+PmqZDVYhe7xXdtg3pWFktYDgq+Yp4Fgxpxcit5VqUJcNDhoanwn4LsuAUJKhhoatQdDJApdMlUrijerLVPkAGVz7nr2BBgMQyKoyQS5wfLuuk44tLP76S65YFhPcJaEZzQtlYlS7fRUxSLTEhKKLNxy42jgmqwEKjznD3vNSGuTEp6O82MqsXhCYiAZlIBz67ZoizPVFdI7/erXYI43SjDxO+DKqfQIn3xhHoBbXX84oT90sHoqvtTvYxQRWrtpK/XSaFjbpVQPZxf5TGziVoE9MgULEP9bQwUBS2m+WhfGUUbvrdd1YaajMOd7UwWE2oACWpashIYI/mRuq0hji5cZBbtD7ju+9AIi83xkn91oytaPoH0FtetBlretkzauEK+jD3NvmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(9686003)(956004)(6666004)(6506007)(26005)(498600001)(4326008)(186003)(16526019)(66476007)(110136005)(8676002)(7696005)(66556008)(52116002)(33440700001)(55016002)(66946007)(86362001)(8936002)(2906002)(1076003)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iOYBRQIeITUv/oAxnoTsETHZ0qEefNfO7Z4Zk0HdkWbb1/3tbygHa3Ix9jrRWG+eenS31h1SDSCTvCuHkRIKa7iwuTmYSTWNALKL8C64D7lEeaMFktEfFoZjdUmVNIkfCNS9Za3z68fAJW4a1emOrIL4LJK7II+7oP8CF7/wcmjUjYQhPPrJm6Owe975kOuqcacyud/yLLCdOZ6ZNEFYmGkQcMbLNZ/yov7n9fzEFpiBcGu2KOTESpPVSFdrjS5Lz/rmK/N6QVSIIFhweUC4eNE9VEC8HdfD5QViHPE1farJHHP23NtYhssApHUs4MQVu0XWg5N//zxlyPRvvZ/vMzCSlb/BInP3xKgdcmAc+2XBgmp3z9dwkC9/f2gaXsjIu9hbb5cnHrl7GXYPPm3srst1f8wdmyndWwv1jLZWZvhMeOMAq3vxUvnQeMAym46WxVz9+jJt0KNFQjgVslgUDlVhyUiKIEocPVdTDR+9T4X8JtxdBxnu12cUe1zYcn/l
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afde11a5-79be-4b60-8234-08d7f661b146
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 10:46:14.5571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: by2KEl96S1e9FqGR81cPApUlzrPo21vcAjKwqrfSWFi1Qko/wK24635kvFa4pI+tT89c+F9lD/faJwWcgkN+6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY Register Accessible Interrupt is enabled by default, so
there's such an interrupt during init. In PHY POLL mode case, the
INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
calling rtl8211f_ack_interrupt().

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 2d99e9de6ee1..398607268a3c 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -179,6 +179,10 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	u16 val_txdly, val_rxdly;
 	int ret;
 
+	ret = rtl8211f_ack_interrupt(phydev);
+	if (ret < 0)
+		return ret;
+
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		val_txdly = 0;
-- 
2.26.2

