Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598DD233F65
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbgGaGrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:47:11 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731369AbgGaGrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:47:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evoZsEzQoSTdqokiadry6exJqo6TaKjxpuw4GL16iK6ogZJgr0gC37z8IkTr6Hqc7yCJEGytvJ7CJo2tUZjmmWrUoxHHAtb/JOfH/WfadHuKJbtPb3mz+QRl8hS9opjEAraqkpaAXFgyCu6Z5oaHVf/yrbBG0OIvuUQ0oz57glxUhtTA0bPqd+L2KARJq6UA6FyjeKKzYBzHMsuNssmlrvK/DIu9g9+7t1BYUM2HEynI4erxOQcCzXhm/UC3wpxwzzKH7+M2D7djqxLXK6KfaPA2Gar6iX45thsX0eQP8c6sa3wYi3e4CUZGqWDocPdLZXj6PCccTHw3BltK4GGy8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+oOiX9aT+OE8EfR4SSw78j88ODWfdI91Wl8rZ1rJz4=;
 b=gvQ6rXaczuF5jdZ4ZpG++7qzBw9vqabYUDaPtdFtRxGbgWpWGI9YxKCRWWSUT05hUQ5fTSCBoAICOD4pGw7xJq5Cv2Xk/TC2HccN8R/y7wnb6Zbz7Rvsl+6VukLSHwgOvzF58GtQaCNa+4EAl6BTLYXxDrephWKRpxEHy0mviSHRMbKpdzIHNQnClvM12g3OlPyZRxxiFmzLDWOWngZKEnRLCAeh0XLIie4lHYPDspVwUEsvElXAFQaV/KzyAAa9xmfY9Yn3ldLY9WPZnIQPQfnpohxiFwKyqv15nkGmP/Bto5T44l/Uq4WAx1Z9W0GEu2jG0ruFXidpi9XY0yKYNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+oOiX9aT+OE8EfR4SSw78j88ODWfdI91Wl8rZ1rJz4=;
 b=NVp8zIh/lMMOFdDaFrTi1Je71WioaHB3idnCEqmW2H/lsWAAMHeSmCfwg6gr6WtDd2cIdOWzs7iVnwIMn9zErLw/0BLjtIBblSMD6p+2iWtahCQv0mUwCz7E+UFt9SfDX1+8h24PdlQ6fK/b/ZevnR8Lhsg9ufG389a4KEW50q0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:50 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:50 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 5/5] fsl/fman: fix eth hash table allocation
Date:   Fri, 31 Jul 2020 09:46:09 +0300
Message-Id: <1596177969-27645-6-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:50 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cae1b209-d50a-48a3-e650-08d8351d80d4
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB352780B1389DA59EBB0CCF7DFB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/LL48tZ5hzLOQUn9aF21YVTGU7Qm9f8DPs+AvmUlhZQ5QbLjAOLWLpvReELz+nBysA+0LaQQRd9rCxG6pS3LhPII+dNhd678IWrOR+KxWYB22jqoU9Rn/KP8hCiZdZZyWF7smvddWkQbfTVPNwAV2I5h0qd4B54crmLbJqPjG8U8KdwdMiLZPfomC6yTjBW3gt9MDIGKVStay5zLrPAeA8POAcsZHKdXgvwIr1/U56EvkHLMq76g7aKO8IZk2+a3SgtrLSKuHW128Jr0X3Rl4NMaxm3o1cbM5gmQReYxTXj9+4Sil/lu89ulseS2sMsiKbn+R3NNwMXLGLX9s+2TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4744005)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hmKWxtGh7e/rG6LLeiomzzAeTHEOgTmZQP5IkChodyXeSbkIQ4J8HHdJ06jhnNTaxL6+lvNM4wyt1qb7zQjUR1SWC0xwsaSoKQd5UC004fv4UAAav5zfHlZPZbgvllx6y1QoeqB6dQvF0s6+KkcIoku/LLvyPE1SNCOtlD+MJhSgs/aMF4nH5mjRE26Uj4StPiWr87Ukz/H0nHucLU7hleeBUoojGaqCZLtL/U4edPOiUtmJmvk6f4D7AHnB6DBd/zVz4nHyay4bNnXVCuOLTA0cWdbWeym2wmN5qqLi7LHxmnadMCJGtc3Agz5XaMobRKoMZys7ocjBbBnRl6S5vE/lo/F91dP7FzjMAXy7CJnjJqIJk6w6VyCuHOgHmDpQ47bS/ZUssHr7lm4SoTp7AIqmqOk3KWfvZiQxZqMPLqLLApHQCfdGJetOPeg1xpIgex+LWHeHqenfwxxbwNlGUj/k+ap/izyBIsHKa/NNclw=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae1b209-d50a-48a3-e650-08d8351d80d4
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:50.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XcOw53wECZdWLPHana8n6In8HNHxeZOuZZeOtWUVQXlqyDbzle2L0+3g/Xx3ICmUFlGGfbyPY18zXe5LSMlNnKwioi5sAxaAwXl3gGQJMc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memory allocation for ethernet address hash table.
The code was wrongly allocating an array for eth hash table which
is incorrect because this is the main structure for eth hash table
(struct eth_hash_t) that contains inside a number of elements.

Fixes: 57ba4c9b ("fsl/fman: Add FMan MAC support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_mac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index dd6d052..19f327e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -252,7 +252,7 @@ static inline struct eth_hash_t *alloc_hash_table(u16 size)
 	struct eth_hash_t *hash;
 
 	/* Allocate address hash table */
-	hash = kmalloc_array(size, sizeof(struct eth_hash_t *), GFP_KERNEL);
+	hash = kmalloc(sizeof(*hash), GFP_KERNEL);
 	if (!hash)
 		return NULL;
 
-- 
1.9.1

