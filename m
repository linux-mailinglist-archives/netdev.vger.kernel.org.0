Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860BF48A4CA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346132AbiAKBLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:11:43 -0500
Received: from mail-eopbgr80092.outbound.protection.outlook.com ([40.107.8.92]:8160
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243256AbiAKBLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5b6CUPflUl6ywDs7nYZ0kU7BQWsPFFQ4RMdso43YzSUy4T4NGEytiyvYYQhD0A+xmzP8ktP5LqvYrw99UmJNKqxFIJjROL0o5E06XCz2y8vJLngFAZcHbw+5Ib9MlEslwGONKQZdlyeeukUGzSJBy4Ncwmykr2KFL4ltZBbKHAKRaEHnIeRYdDhI+43iNjWZ3nLirYPFurRn1IHykTmtjZxlof2zvSe0sYiXBCD41kcZn8yQyVmE9aBTflh9FaXxKUbiVG+LJjvzEvX89T1Brhy3JrMQn2didsIlKC58CAY5kZbO1zhIrbmLuuYHLW49kHmvbVkoqNEnDPUMcK+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIGQK451HMQyekE/K5MaAjhokeUWC3JPhAPGa7cT7sE=;
 b=kpo4i/G0wJkFi6uPBrHodKukVDGD6/nlCBFCG6X/M7aWoCpPua+zX9tUODy2JAlKSYi/oe1Zl+Ijyf4fMoMk6YXjHdR3oECNCrRhr3rcPAAXfz0+m1X0Q6EzL1tW4i32rLYUFUc1djKogzLcGNKygzBJ1zCnbTE5Icn9b0qSbnLbbh58MX7eUpJ4OSjz0zn3PavzIUwcmzy41QNSzuyxgQPe12rv65F+hTyGyfDlW7HIGXhY1w4jwIXoxy710+pUkuTRbRbzXNkdlhk/D3OdXgQ9QLEEqaf9/ZEDCbH0oAQrbKd1mOAwTQsum4el8dkhL8T6MbVrWYve9K6oI9VUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIGQK451HMQyekE/K5MaAjhokeUWC3JPhAPGa7cT7sE=;
 b=fyDXiso/ttU//G/F7ITTK6CSqtKM34dxaBNAIhlefsN+keJwxmAtltKjCwY2vUiTN6FdLqO61Y3Kt5kOl/HWSX2faAuAaGq0QNzbTcsCe0xiv/6V2tvQ43ce1LV/a/LEtdnzMPssmaLDs117XBXjSC35LpbUrSsR0JjZIHN1ogs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM0P190MB0753.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 01:11:40 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:11:40 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: Fix deinit sequence for router
Date:   Tue, 11 Jan 2022 03:11:29 +0200
Message-Id: <20220111011129.5457-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::16) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7de175bc-14a8-47d2-cd26-08d9d49f52a1
X-MS-TrafficTypeDiagnostic: AM0P190MB0753:EE_
X-Microsoft-Antispam-PRVS: <AM0P190MB0753C360E7A7A3AF4CCC7E6293519@AM0P190MB0753.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqIghcrT3AbfMMtzzr+xqqdglF0qVYUF4CQ9mhPsPh2JIn/YvvzyajQcInU6RhQHO/NNPk6nghJjTEsCJj24ikB6PamlriuFqwE/CGD0Kk1dGBBTjPf81FLbsFsNOrTLkIWO5hRbXpc9agiKRfayt/HQy+HICvN4bwy6UQbPAH5ujxPgQG+bSDu0IRZheUpHa2Tst9Uhm3swiutz726qkKZpK6oaYM4G9BImV/dgGgW55qeTg8GsFbj/QbAft7ZLTyUQJPIfd+4d3SkDoa43r7GutZuZ6WghuoaeClcDnsIf8fU4FxU8/vip3pIiuvJqZ0TneglFuswuyhEVtHT8KPJOQjxaNbYSvOE1x6KvS/dY4WFFo+AdSLAHMGpoxKOHuOPCklSQz3wyWGuF+t8OTWKtIzl1/2wfDxYzBaMMMzl1IBHNfVpTLYqjJA7lfhnZwXrXC+SfuKxlKsW9jh90ru3OhvopGneGXkjG3A7qGLxRMAsEDSca6GQmVoa/jC/pmwBNnH57nRntsjwMdGiA08KIVWpuOnaBrsaNPhgTd8n+ZPWsHiWSS4zCYRUGQQL/j9u8/jVr1hPSa+OX2mQG1E9J5prD3wweT9rd/wd7D4rkQVkWZzkCB6Ewbuyf9OKRmky/R4JKdVG9hoG/OpXVU8FFULSwVjkpnGM0DqxGV2tdubZcWSSpf66p2tSntZG+71v0yjzRpNrLSLAyCCML7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39830400003)(1076003)(83380400001)(6486002)(54906003)(66574015)(36756003)(52116002)(66946007)(8676002)(86362001)(316002)(8936002)(6506007)(66476007)(66556008)(6666004)(6512007)(4326008)(2616005)(38100700002)(5660300002)(2906002)(38350700002)(26005)(508600001)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jugNHSXZ5BTx63xdBpcwbMSW70R6epDiHpCh501fqb7HV57UoWtXWdv4dChc?=
 =?us-ascii?Q?f3qysaIZDH8SJgj0toSXFeSYmYD1Hcf+E6jy0c1O2T5rKO8X1WT/yo0SDxrm?=
 =?us-ascii?Q?d4Sesxt1XWKkq5GqITSBXRFIrvN4GpfYQayx7i+/+FZs64uB+vzsNfSX8eLh?=
 =?us-ascii?Q?JbWD5B7lWgryH6LLDFifZromEXEj69H1sgHwoufIEPRLT4PucGAWstqsUVCw?=
 =?us-ascii?Q?mnCUnY2RDp9ZFU8Nq2LtzZKdt1kT3EEhfy+NYE2XSy5UeOZyG74N1k7YTJ1I?=
 =?us-ascii?Q?io+XMT4oMmN2sL6H854VRmzvFOwxeibCzmVE4JJGuVJcG+Nf+I2Bc/lzqe/x?=
 =?us-ascii?Q?3qkSL415Xg0wxDLIb/pz+WfQzksHV9DIP6t/O2gZJ+hPijqh3pKtbyTT3brQ?=
 =?us-ascii?Q?aRpjFQcI6sM6dqA6zuoEy3eiCWzD5dkz04UG/TLDpkBVhpJuXuBrF1i3CKYl?=
 =?us-ascii?Q?QLzo27h06EAOZAhtXRLRq5R5+TDno/2U8SOlQ/nRPZb0jsuUJOPfhCOMWTQ1?=
 =?us-ascii?Q?HVgoySamh5A/AWbx8EYkfhZNMxO/VjHVqqEDQRyAFqNMwZWHzXSIdjcWzS42?=
 =?us-ascii?Q?ucYKRlMDw26Y44B9whh0QLHufwG3TgmPsHYzJ5ujbqSPFBCup7FbWcog+6tG?=
 =?us-ascii?Q?+ffMlvSkU2id9WT68M5jQkq99UXi14EVrToF+x+XwVCJF/fknd/Zy8XJEsfL?=
 =?us-ascii?Q?dH6BUTUKpfWjPJgR23GurOQX+novw9S7AN7cmhskOm686WF6glrYZpqw70qZ?=
 =?us-ascii?Q?jPPSIzVGzVg7PXANqc6XgkWg7Q+2P/s34M+6HbPvGDSPaUmlG4OuSu1ESAQr?=
 =?us-ascii?Q?Ro6FYIN3bAk+EL6si2y6IOlGZMrpOurUymAN6Mf6aM8LoRvjvMC8CD/Gwy8l?=
 =?us-ascii?Q?TJhiPYIwQwsJKAPlz3zj1DwmeQgOxl/OLPvOJXzgVg8svpeZVmxdsshop1mp?=
 =?us-ascii?Q?z3Dq2C4FFtWoPveWc8Y+CuhH9IzXaR6JjQlAGtly20ixht0AP1VLPbIDu3Dr?=
 =?us-ascii?Q?Mr9a0hjXtdJBE8Toy31axnV+psODQTH+UXHr2IaP/YZEueasQAhWTKcM+HGx?=
 =?us-ascii?Q?VT3aQZ+oFTMe4+AufGaRA7gWtosXYCWE7jTfqhaGl3AU2FrI3TYdRO+oyqZ/?=
 =?us-ascii?Q?xTHf4Zp9BvHqpLo6hPjso6CVQsxCO5siQ+S0vo0AWVHHD/ot4mZLPrweNFdx?=
 =?us-ascii?Q?qRRWMMiqQX2yrs1TOllsgy8k6addaVio2TFaRxuryI6gw3Vzkp8bLF0mIo8z?=
 =?us-ascii?Q?KXymW7aUosiEobqbZGHpHnJwHGv9V89BkPJyS7lyDacalfHcoDQ+rBDDRPpA?=
 =?us-ascii?Q?q+AqyjwO5bdkYWbgWrv+5gzta5DZlmdJ8NL5Wfeaab0a5GKSv0mvMmz5SpBt?=
 =?us-ascii?Q?4lN3lcy1ehaA/AqPkT682iXaqYfQDFmHNNE47xSMX9PT+h1xaI6lOG4M03pj?=
 =?us-ascii?Q?S8Eztv/PoTL4gTWy8oj1Ezx1Zz2RzP/4GqGPH7cYMP4jywA/u+kPiPD5Mfsi?=
 =?us-ascii?Q?2GhgVDTYFd9Ij2wOhd+nfMpgvN1kpWBgcr6hmfRPQIP1DTu8tXx//f8ylHJV?=
 =?us-ascii?Q?+OU2pEp4mmxUx7YlBvAj7Ju07c7UcSlxMauaHLEZ02Gn+4Nw3WxokP/jZyAJ?=
 =?us-ascii?Q?v2jaUPupDe/1556Ceo56V6FYv0cHOGEWWxuXK6XWb5dEVeDIfjJWd+Vt1fbb?=
 =?us-ascii?Q?2uGRCQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de175bc-14a8-47d2-cd26-08d9d49f52a1
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 01:11:40.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtKektSeK0WDqO8jYOxOSIOdC8BZpOu4OaPosIgP07VBI0DX0HGLizhrHwi8+QNPPeUykr6GoidoamroT33R1Rn7Fuv01Rf+3On2VgG9OC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Add missed call prestera_router_fini in prestera_switch_fini
* Add prestera_router_hw_fini, which verify lists are empty

Fixes: 69204174cc5c ("net: marvell: prestera: Add prestera router infra")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c      | 1 +
 drivers/net/ethernet/marvell/prestera/prestera_router.c    | 4 ++--
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c | 6 ++++++
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 1 +
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 08fdd1e50388..cad93f747d0c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -982,6 +982,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_switchdev_fini(sw);
+	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 607b88bfa451..6ef4d32b8fdd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -168,7 +168,7 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
-	/* prestera_router_hw_fini */
+	prestera_router_hw_fini(sw);
 err_router_lib_init:
 	kfree(sw->router);
 	return err;
@@ -178,7 +178,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
-	/* router_hw_fini */
+	prestera_router_hw_fini(sw);
 	kfree(sw->router);
 	sw->router = NULL;
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 490e9b61fd8d..e5592b69ad37 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -29,6 +29,12 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 	return 0;
 }
 
+void prestera_router_hw_fini(struct prestera_switch *sw)
+{
+	WARN_ON(!list_empty(&sw->router->vr_list));
+	WARN_ON(!list_empty(&sw->router->rif_entry_list));
+}
+
 static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
 					      u32 tb_id)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index ab5e013ac3ad..b6b028551868 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -32,5 +32,6 @@ prestera_rif_entry_create(struct prestera_switch *sw,
 			  struct prestera_rif_entry_key *k,
 			  u32 tb_id, const unsigned char *addr);
 int prestera_router_hw_init(struct prestera_switch *sw);
+void prestera_router_hw_fini(struct prestera_switch *sw);
 
 #endif /* _PRESTERA_ROUTER_HW_H_ */
-- 
2.17.1

