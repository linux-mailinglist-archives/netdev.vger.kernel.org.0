Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3EC421727
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhJDTR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:56 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238701AbhJDTRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgzV2I2lu0BEklaDiP9qLsnGv6EfTc9vM2zsRrjBwtLoeg+c5Ldy2fVRl7qUqAnHNQ0PU9/lFmnf6FJ2Icw0ppiBRhdfZ1SYAMhMOyToyNuFNeq3VBOyeZu8ptvEv+15y9GoKZvTNTketN28UIfDB+Bej6S0ieMAR+Or4j7zgbyjDmpWUVw/6SHqw9Ge4POsPUGDBZLTASlZ0kD88Dvy9kfh0qg4KBFnyoo7lB+CIcEpjsOSH4rgTAQwbGgNBn499McVjsaJLJdfxyq5dsu95DsU8r/k4zewA/5RG31Ns5u4FosFU5E/iPeXFBdudFq7YBnYEnz02pcUXQh9xlrZ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zcV+V9vqx4I0QGoauP9o3uHlpdQvHAU4lLAVs78ndY=;
 b=EHvI0l81PCZmhaBEd79rqxdWnfYDmJangYKicZUG5+xG76aG2W+Iz94QZAnxMNcGVJMq1kzOZRR0wIkJxgB7TeXhVMpN1bLeYVE0RBML3lxzt3LNQLxvsPkL91Feo6CDapmKJ66vGxMUcEbfnOfegfWSDY1v1/wAztNeGVEww2UdYZUmscRNsVJVeircAqiqEdtmJzBF+gCXLRdHJ5sjhAGKpnPtjxonCiPPmiAghJCr6CWxNqXlLffs5BZspoeOr0QqTwwzIxyc4eTGoyB9sb7n4TRRH7hA278Dbgac0Lr6WcLA/8GCUQeVuduo1OrGip4usgZR4M66Rf5Qt3EMqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zcV+V9vqx4I0QGoauP9o3uHlpdQvHAU4lLAVs78ndY=;
 b=NGo7QVRavTna30zeCBQfVa1zsQF0VNLDtroo1p970A0F1jC8ssx1LHD7pY+BFWu8gGfeHY4Ddu4FtKtfNOtowYVMz3uq6IddrNYpkikrLqeteF5PPpuukz+DEFBXoRzFhcH+wQ89TDUz+Zj6lYVPVIianB+S6uUHvZvkXkeyBEU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:56 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 06/16] net: phylink: Add function for optionally adding a PCS
Date:   Mon,  4 Oct 2021 15:15:17 -0400
Message-Id: <20211004191527.1610759-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8605d6c2-d4bc-42d7-fe2c-08d9876b6424
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74348E8E6AEF3245EE31E20B96AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajGPar/7hmVms+Qk6ZlCa4BKsbQjF+7wwsoTo7O2Nw6MvIyq+j68DvU8udMJXafgs1dC+IOiEg9GnD9LrV4gqouWae+d1Hg/X6cRuF4UYp49W1ukgE8yBQoqDLqVJT3ecN1Ki+APymebhHbFP1MWJYtUWhVJVKw85Xiz9iHKUBc0KjSOh4NaZibdJsCY5As6IlZ6y899Bx7UcFVYKOYwhFcvbzJSVe/ZM7Uom6gEGkLaLVaA2tAHUX1HggZZ/OrBawtjMW1Dae4YmBm3Qhr2PXuvBbvWRA12PwYPnn0TxSXqZ/iFUuCke2G1H2ss07Rz9YIekv9z9xNFA0FmzhBT5nSvBj1MiPXQD0agVoUlGMtPcM+MX4Qay+4U57xsLL2LaySIG59ive+9IcJtjJ7QAbH4OOFiECUGQJWp5H0Fd+SD4YY8zD7mzk+6QMzSQVDeUXkke0pik0PrC1GWJ/Iqdk2XQwxCAHhMvRwIORPNYt8r3NYhHOC6wlDrczNTzPqGnn1TwZ/IAOcnaTHIEOS/ul1vCyd8L9kLwhFhBoX4VXn0lB4kF2lt2/Y7RiycKN9Izg+n2bCXIgfqWPS+rqrDY1DJFg5uvapP95PMpvYKGMVxaDhjUOwv4WyOoGO3HWgArn+oC8T101YGgLUL8GFmXG9vAG0QVOzreO3yo/TxhJcQVdMtWuzeE4Yu+jOpgwFvWGbDPtyUiJK2p8Udz9R6Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(107886003)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxEYax9fKPQGhI1cspgJdzPSTyHyOgVZiN2/8AINVPik+72xhCiAE27uL+gP?=
 =?us-ascii?Q?rN1eGH3Uk9jTv6rOGaR5ntkKh99hXiHpGhek7bY2QsMSuhYr3cveJGFQZ9aS?=
 =?us-ascii?Q?KZJdQIZo6LYvKusYR772n9abdYuUTmBd7srNf+pnANrgNSsxwNzFlmYOgep6?=
 =?us-ascii?Q?qQcQmcJY7utx/0g03uztlrBMS0f9xN1cz93h2i6EbKDekPYp+R3CJeMYPxzS?=
 =?us-ascii?Q?aWV1jYOFuUKWdLIEzoH9EUFEfoTzFP6TJcKoWyn2NQOLK0ZKBSd2Xd6Cbfi1?=
 =?us-ascii?Q?DZraMfcsoMDTtorptSGS1tuuVBAgExM1nJQvLGOlUFiqdIVl8PX78tyC2oEr?=
 =?us-ascii?Q?0iD/n5Xg++dc1wth2Qa+/NSM2sr1hNt9dLJT42xVfeV8is4vD7iRiUJQntFH?=
 =?us-ascii?Q?KHWG8cHBZScveQAhnj8iXRhCxOMVrrJa0iRRlcTL1m96/QQmLnJjrUT0Af2S?=
 =?us-ascii?Q?sBH+GTCRJ2FoBcvgpclKvB4FSCD5mibGmty8dm9hddDBH5CR6Hk9ltf/kseH?=
 =?us-ascii?Q?BUFi78SU/JIOcrm7U1LtKGDj+n+x1r35RWH2hEA8TKU1vCW/QM94re2/PQjT?=
 =?us-ascii?Q?iswuY4wXuvpL2isfiOadCvaT/0U3WZGj2ddpUANzRocvj5bFWIDviMsTx9b7?=
 =?us-ascii?Q?LtyHkvx6QpbfGcvjVzErvhot14fNf9oUM5wIA+4Qs10tJsHMwNPKL3/X3dP7?=
 =?us-ascii?Q?cj4lRxr6y15oOquFXkHu3AbPeno3H9Md3Wb/9BY6cWKMibZaLlPKW+iggdZg?=
 =?us-ascii?Q?sheD7DESLg2TQpA/tD/OTRzfA88aCTz7xFTVbYnQNH9pTuS/uQCQRBLCTW0y?=
 =?us-ascii?Q?qCnIXEZyys8aLj4RiC7HdlUFGAPjqcuRidpbtkOaUWMZbNsf3O9H4jsvcMjy?=
 =?us-ascii?Q?aytyt0incyDEcL4BsD0TYfNxrcrP/BiwImVCr3EFT4R/yAdbYtNuFwip/t+C?=
 =?us-ascii?Q?81V0o8x34wVSGn+NtAL85cVbYgf5b63kwMwxPeUUrVhN9Ldc1RiCLbDcWGVB?=
 =?us-ascii?Q?dk3+KCJtUimMEZALE9szaHUN+1e2Mg+DjrZgFvqN9TyUiSlQHasyGDQMkIak?=
 =?us-ascii?Q?lbpyRMQEh8+7IKNMpomyDKIgCkM3he2UIc5XlIonzmt+udslceQdmCpeBeGy?=
 =?us-ascii?Q?wWF9JRG2F8AA00h7fNgsaoWzpjWhzQCpMugT9QsjV7UiyX+fxN0ETjoFmG1b?=
 =?us-ascii?Q?AAm5RC/hL1OjPnAPTolZDxwWI4HB4/7a8LcRAgxF3XLoHGjEHzK/Abm7u3ee?=
 =?us-ascii?Q?Lvdvf0IvqxQ6OfAJt9IxpqPCnrvhrrn+GJxkuORxvUa+/h8QYnKnFl9ZPmZ7?=
 =?us-ascii?Q?cXqxguWbuE+L2H3VIhvchEd5?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8605d6c2-d4bc-42d7-fe2c-08d9876b6424
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:56.2833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrOZ1w1wCz7LRfyzlBeggUJwWTnk0i92v1OdpylDF/5G10fz1UWaU9Ojmw67GH54co7PEZnd/H2QS57AP8wugA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a function to set the PCS only if there is not one currently
set. The intention here is to allow MAC drivers to have a "default" PCS
(such as an internal one) which may be used when one has not been set
via the device tree. This allows for backwards compatibility for cases
where a PCS was automatically attached if necessary.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phylink.c | 26 ++++++++++++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 046fdac3597d..f82dc0f87f40 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -871,6 +871,32 @@ int phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 }
 EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
+/**
+ * phylink_set_pcs_weak() - optionally set the current PCS for phylink to use
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @pcs: a pointer to the &struct phylink_pcs
+ *
+ * Bind the MAC PCS to phylink only if there is no currently-bound PCS. This
+ * may be called to set a "default" PCS, such as an internal PCS which was
+ * previously handled by the MAC driver directly. Otherwise, this function
+ * behaves like phylink_set_pcs();
+ *
+ * Context: may sleep.
+ * Return: 1 if the PCS was set, 0 if it was not, or -errno on failure.
+ */
+int phylink_set_pcs_weak(struct phylink *pl, struct phylink_pcs *pcs)
+{
+	int ret;
+
+	if (!pl->pcs) {
+		ret = phylink_set_pcs(pl, pcs);
+		return ret ? ret : 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phylink_set_pcs_weak);
+
 static struct phylink_pcs *phylink_find_pcs(struct fwnode_handle *fwnode)
 {
 	struct phylink_pcs *pcs;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d60756b36ad3..bd0ce707d098 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -442,6 +442,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 int phylink_register_pcs(struct phylink_pcs *pcs);
 void phylink_unregister_pcs(struct phylink_pcs *pcs);
 int phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs);
+int phylink_set_pcs_weak(struct phylink *pl, struct phylink_pcs *pcs);
 
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
-- 
2.25.1

