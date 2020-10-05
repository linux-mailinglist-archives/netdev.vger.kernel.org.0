Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2221F28330D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJEJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:20:20 -0400
Received: from mail-eopbgr680068.outbound.protection.outlook.com ([40.107.68.68]:30720
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgJEJUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 05:20:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMsr+aiq93I+BKfMoAy1UIYybSv8dLXC1y63FSsJv8CmKski/wXXZwTJbiqfv6DOJuPa7mpQrecHg85VSIVYg61dppoPUsU0KRTL9iWS1Ob44XXboTMk1knlFOdIMLFzHim3BOp8zT39fsSkFHPLGnd0wwEFyic0Uufzpow1Rq5dEiw316OiJ+oN+dPPmQ8K3W7hya/RGTtiZ7tzgBBUISLZYuihvHac+mqTNKS6Ss9sQ/nEBGEYcjs20Gp+VMqC1zj16nVz+AjNJtpfrVPljIt57I7s7bhcXqT7VQnWZbeAm4gMMslQyywpFEOUJxf/ZpcAd6xRQIMmn/ITL5vdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kctmlg0ShEREel+lRtHSfrLPxX03EO6LLd1wt5g29EM=;
 b=kw8c1eRped+K12xr2n3I/DnXZCygy/+Z7MJvK8KfoMVajMLUOdEZxM28XzXnNXbw/lS7l12a9r2pMUa80PkEg8SeN/u8Sk+r9qOyHAj/XWPF8POGJAqg89eEuFJDRvOmfB/1alpFi/onVvPIeh7sAL95Mww8NBHdgnXRzeG3Lq6hi45jZCp/pS2ubtspgddAeiX4rx0nshMFSwPDNtJfkoYY8L20Z8xddk7nhh8DHW2Mnnuyr3j/9kJXEUEf4oMA15YDhJiILKxhPrPaP85+L0vjrn5+OpvBlSCNJnzuBoo5bcHT6TnetENyc9yd8vYPhlHGQoNXKBaIGjXGrS2O5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kctmlg0ShEREel+lRtHSfrLPxX03EO6LLd1wt5g29EM=;
 b=NvqdO79UW/T+gvVNb419jkdpUEGgkBDIAItSAzHaYQDt9XTEbIQe+roKR3jYKSyYDbeWC6pGdAUcWe1gcdB3IVC5ckLiL8KEpDrxZR09QaVZzpTf6euVBHIsy52B07clX9PQx7GV2udElX0lKG1tVNL5NY7ukL2HADAdkWlqzFc=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DS7PR03MB5560.namprd03.prod.outlook.com (2603:10b6:5:2d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 09:20:18 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:20:18 +0000
Date:   Mon, 5 Oct 2020 17:19:50 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: marvell: Use phy_read_paged() instead of open
 coding it
Message-ID: <20201005171804.735de777@xhacker.debian>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.74.246.114]
X-ClientProxiedBy: TY2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:404:e2::31) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR02CA0067.apcprd02.prod.outlook.com (2603:1096:404:e2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Mon, 5 Oct 2020 09:20:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78ea45c9-9df2-431f-4b4c-08d8690fe021
X-MS-TrafficTypeDiagnostic: DS7PR03MB5560:
X-Microsoft-Antispam-PRVS: <DS7PR03MB55608E491BD5318A160354A6ED0C0@DS7PR03MB5560.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+z6Mu3IrJTX1T2VmKLX+LxzvP60r1yTLdM8dgDMlJemgfoTuIU2M4PnHQlrUBHk91VNkn8nAtDNrL8UzYVKlcqrjvMqijYd0YSxiiFc9QM70KOFpq64I7DtMaAVNPEuYVPhZ/klDm0bnKzrdjjpqCol6+fnRne96Ba82Yrf29ypFfZAaOtrHWUn40hkFjRkeWzn29r+ttmZGEMxmmlF5bygJ114FE159Zgk8JENGN90I+5MPzYE10EZQsxkNli1Tt65xLop/vp59rj4mSeWNAvNYeAQhywpqUSnLF5S1sDn0+5cQNI4IvmHY5zGsH3JJ6ynPF091f3i+adGva8ovQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(396003)(346002)(376002)(136003)(2906002)(8936002)(9686003)(16526019)(66946007)(66556008)(66476007)(186003)(26005)(8676002)(55016002)(83380400001)(1076003)(5660300002)(6666004)(478600001)(52116002)(7696005)(316002)(110136005)(6506007)(4326008)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BmrArEkc40TYxrNbShLBzvliSACMlaLltCx5k2ah5Fh875j9Lx/6RZXX1UYvXcYtFkWFCN9wmFYZVYGjuklBfByyxrsLwQqcq67xLmjzW9ZZJfELv2zC2C1WaSW85eADWJ5sT/2dzCPNWCXOt9qMCwP3gNrOdzX9yH/80un3/jlzsL5MCZrlgS8HMXPN1Gcae66dStqP/qS6ploEnYqEoFGjj/yTDFFIiS5o0pGBn9mzGNvL/HA0vjEPken/+v7vZ1K2gURxYAc87HLVcZi4RxP3XGegTN+8D8WwTCUDAJvpFjkTkdfx84wcFkLOdOj0o//h2xI7D3k3SyDU1Mk26oGHrHpH69dIRD3FFMcixNJYq3u4IMDceCf1qbMFTxg1uLf10Ug090YdxndmzPIeuYsZGqnVJgQiSBfqJG6y+rhmodsF2f5V4QUZjpDo140x8SKV1j4ys79v6iCGAYKa+RJZ9708IL+oSeC4pbC64JhnX2PFJFBr0b3OITY+zNlL5Mq0WdmCxC6misnKUyVFkKQjt37yBrxydKMn9HZn7je7zZHF5fi4VgPjHlG61LKHxz5VYJdrDYIYFA0rAvhNMGLteKIcw5Uh2irEtvo4+BWmWJ6jMFFPWsqyEV+fBguAHu0u/AHVkiKPK7FpNPZ7ZQ==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ea45c9-9df2-431f-4b4c-08d8690fe021
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 09:20:18.0588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHNSos8tkHbMndNuCqSH28U5UZxyHizgltjPpk+w2V1pf4Z/vm02e6QjxhJAntkRscjsI1+DhxzfbGXwRJBnmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR03MB5560
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert m88e1318_get_wol() to use the well implemented phy_read_paged()
instead of open coding it.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/marvell.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd092..5aec673a0120 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1598,21 +1598,15 @@ static int m88e1121_did_interrupt(struct phy_device *phydev)
 static void m88e1318_get_wol(struct phy_device *phydev,
 			     struct ethtool_wolinfo *wol)
 {
-	int oldpage, ret = 0;
+	int ret;
 
 	wol->supported = WAKE_MAGIC;
 	wol->wolopts = 0;
 
-	oldpage = phy_select_page(phydev, MII_MARVELL_WOL_PAGE);
-	if (oldpage < 0)
-		goto error;
-
-	ret = __phy_read(phydev, MII_88E1318S_PHY_WOL_CTRL);
-	if (ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
+	ret = phy_read_paged(phydev, MII_MARVELL_WOL_PAGE,
+			     MII_88E1318S_PHY_WOL_CTRL);
+	if (ret >= 0 && ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
 		wol->wolopts |= WAKE_MAGIC;
-
-error:
-	phy_restore_page(phydev, oldpage, ret);
 }
 
 static int m88e1318_set_wol(struct phy_device *phydev,
-- 
2.28.0

