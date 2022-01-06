Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4968E4865AC
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbiAFN72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:59:28 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:44357
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239687AbiAFN70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:59:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WG5CyawYjImLljbEumdSBlNCGJVhVMAQWPg/3l2iYKItHXbp0m+y59h3X7kIgucc88ZqHj3cy0ovBa5muaWQxzVQVH5qFgk/N2sZZ13Q3h5+0WY4VCQd4kbGshiMmWG4jLgXkxVljRFoMEuCv/dvsDjLaERE7/Ip0OGQCf4gJUrA9yiqxYEvFJs6dYsKu9ju9F04mMZO1Rn6qPFILdHYDGPO7DCtppRoAES4XOolEbOGTJQfxRJGLozdjmuc2TInjMPgQtSX1kqXZOoc9v8T3mTh2v0ps1BxPgr3zETiKzX/qDXhx2Drt9d04K8IurkJ38JEvFPkDm89zsYl6sPHMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyeOjFAR/01AhhC/ig2vKSqxSVMEC/ui0F8vLS4BxcI=;
 b=USZfTBjUvH2II6upOV6Ffsq6/YxbKnK+6qnL9damTV+wHL8SQSwRyXoyjhjXUyAQkpyqb+zgd+4zug3W39YqpfdLPDELhAGGI9Nwbmp2BVv5NJ/0soxfseJpG0ywog8D4WDpaMw7xUEpwt/200u4p8fetzULOUBnaufgbu6i7wnTLGpjDQyk4CyNcLop18JyD+EgGa7CAPzjdS8US7iga+AwI25g0M2LR2l2ZRvYV8oO0ZKmmBjaEPi/URSTv/+YXJ3NEatLGXxOIg+SDvlvmwIz40HlG7HHQ++5a447wfeqo+LAIEcjrXkJIE+9HvquE45W5SK/f69X9VIDZiMZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyeOjFAR/01AhhC/ig2vKSqxSVMEC/ui0F8vLS4BxcI=;
 b=bVKGxmaOBJ54z9sLq/Gw77fu1Ik6/pryNQneeFbv+E+LS/eRZf7SeVVKZVUvZ8zqwxfh9SFefOJS31uKtpEhAs7pR96Yi0OZ+lTFOchndJ2xti1VxhNccBRiBpxRuCvYk43kVZVQpL85JGtcixcyYk4m6maX1kW8PyytZAMHF2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AS4PR04MB9267.eurprd04.prod.outlook.com (2603:10a6:20b:4e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 13:59:24 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9%3]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 13:59:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, robert-ionut.alexa@nxp.com
Subject: [PATCH net-next 1/3] dpaa2-mac: bail if the dpmacs fwnode is not found
Date:   Thu,  6 Jan 2022 15:59:03 +0200
Message-Id: <20220106135905.81923-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106135905.81923-1-ioana.ciornei@nxp.com>
References: <20220106135905.81923-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf307329-c1d6-486d-4b05-08d9d11cbf03
X-MS-TrafficTypeDiagnostic: AS4PR04MB9267:EE_
X-Microsoft-Antispam-PRVS: <AS4PR04MB9267795DE44F35CDDA88E256E04C9@AS4PR04MB9267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG+xsLgA4lPz8lT7ZerBRut11bg4Q0FwcVf0LYNHtbFuLJJi9Rdb4yShm79wF7L5UNbOUVpRKF/DsnK1Yu6lUnZX1ATHpJ6KU/ecmNdtoRcrRJTKtzuoLihwntImNzIGKGN0nJm2oOWr2pjrW5Mx/rhSoz03wG60uMKpYYm0VN0LN3aqsfAPnsW0xtG9PMYWiLk59yXGR3MlLzHSuxu1NrDWBZGnd3OGKUm834OkRKp5z/brlm2mwborTaf366eF5M3027fMYuuiQ/9QGcBbDfKxjjpgNA35IThMNCFW17AO4+paF8FKj6htjRU9ZF9J4prxRB6qiDHHu+2YzxyDORt4Bmp4T5sIrriXIXoGllZcUJFaomaQGVxMBf+J0dZykALI+zFk4110bPT5vnhQrzSyQYYmggT3KJIycxPS+E52NGA8Z6GIBil/l63QuXr6Z+24mbZfTFxCH0XzLqKHf+kSqnvbysDcp0kJb8KD5xnaYUfO6GdgszqpPbSKSw/mPC5sHVbqUCebEYdA2e8lO6VWhIPkDnyXrF0RITkSNaYihUrUKetvPEJRLry8SBbOtZ8ewZDApDRjJhHhqWauIkTJ2Zvf+ip1tb3m+0YLy+GrMKfamrV872g07LeUmZDn/EtIhsZW6km3NFl6/C1J7o4GUWT/n+XrnZWfgjLM5PQbVC5EZtwkBQsWR9GFjFOTkxDSAPkfOHl10azHJ5bcqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6512007)(66556008)(6486002)(66946007)(66476007)(6666004)(2616005)(4326008)(44832011)(186003)(508600001)(26005)(38350700002)(38100700002)(83380400001)(52116002)(316002)(36756003)(8676002)(2906002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?el1beCqQs39hs9JggsbNkCbXvdBGQQ67gYKAL0mUJMnJuuGD/jhuLgeiCxOs?=
 =?us-ascii?Q?6ceNQC2omO3PaaRuPYd4Yy5H4Dr64v6kUzkRISLG8xuMZLuP6b3fym/z64pz?=
 =?us-ascii?Q?gFBuCyDw8+NgIzvVpy1VQx2B+LxqVuSg0vecRD7KofrjsLDje94h5tPu4+pi?=
 =?us-ascii?Q?2J/TwwhjTu8BIklKrgduRLmoKCmBeOv8kUeEBkjTqcFFSXH7MAszJitmV+Rg?=
 =?us-ascii?Q?8VO4++WGnJkCp9oOdFhP+x5rRKGD1K1y4IyOGBvxviggEVCehTwUd7b4S8Wc?=
 =?us-ascii?Q?TcnV4hjp5GkzlFE2MaL+j7R/gyK5PyCbknb+wt9BzBruTrZfk1nWqYLCEf70?=
 =?us-ascii?Q?WFW5zAqPAi0x8gSTzX0b4LBiEq8ZsIBy+xevjS6gkhR0rSvVqq6yEd9CgrTy?=
 =?us-ascii?Q?8gPJEGjNkAm2aLVIb+P4rHrkavZ+fd9JxYkvkYEVP9i6dBniNACnC31A+ZnV?=
 =?us-ascii?Q?zPjIVnG3TL8zKyqcKB8a0MSt3PnNsCZRVM4Il0wB1Op1wR5B8YXMksnwTl/q?=
 =?us-ascii?Q?zvFbtMH87zyLp5SGMpiTzFqVr/q3a5Z/ePzdL1w92ns40dzESLLNvqcPAd7k?=
 =?us-ascii?Q?3NdeBTv6xgYIHNYKdL7d8M/+J/QN8ptnKQDOV1cGMda6Y62Ds+qLXrsd49S9?=
 =?us-ascii?Q?c7sYFeImVrPZM0RqP8lH1KogtNIua3IQw2SIWV1P9Y+hquOJKzo7NDZP7Iw8?=
 =?us-ascii?Q?gZOoRPQecL1ZQCD5YKcrt5TaDHXLuWFgvSx78fivBN5M6+fv6msC9ocGgizA?=
 =?us-ascii?Q?yfN9dHFvp3ayZHALxPGNpAujcaz5KNuO8+tDA+2o0Rt/D9js+LCLjMiEcXL+?=
 =?us-ascii?Q?9+uXSUCZG6V/zW4XrVfTJtoY7+Cq0z7RPt2egoEdE+5JnIn2AcMnlE3eczVv?=
 =?us-ascii?Q?SiB0ZQ3TDCt1PxMt33yV7P+Zbr1EWcRusKsfouMb2fEVe/xJqFyBSlIaHu9y?=
 =?us-ascii?Q?Rf4eAn3dCOcGL3RZE9bQbZpyzoNMrnQ9A2tJaLMUiDmWoYssJlirs5wvSWCk?=
 =?us-ascii?Q?/jI5ac6A/Za562Te0QSWbQM1vLdjQcM3fgEfyxiWUuZZOYKfsGB1p2nI2Qmt?=
 =?us-ascii?Q?Ea/YcNn/BYSL+9pQx7OVpBe/FB1+rzumSQzDMy8Un5b+k0OKgr9TmNnyiDbv?=
 =?us-ascii?Q?GEj0g5omWD+0EgyFRHxJPrRmG63kV5+p6HiJqzibxlOI9emhhU4nQ+RiRziA?=
 =?us-ascii?Q?zLMEa/LkKHPp1ivBoKIU/5CLZzuJfmwlb7FtfaCgXNmmLEIwMoxscoe9VH4D?=
 =?us-ascii?Q?AQYkZ88ZMhFFJebcaHqdGe58AtEFSBKJcHzXOTCw+HfWmsZ6fVAkhcbKaAAY?=
 =?us-ascii?Q?eYrCYYXtZf5Vna3qJrblFM8cwpxde8zvfCCiZnxh5496SlL6MuXKCVQPVXNl?=
 =?us-ascii?Q?ykRUs9fRU1JrXFO5cIOG28Ftnn9H/TSk13p+BTTCVoV/+/GC2qGlc6MdTgF1?=
 =?us-ascii?Q?NWMwh2P+DTanMbQZ+LMjqDeN5bZXWgIqqpwtCYdVr9Z/92SaOjj8U8gl4qus?=
 =?us-ascii?Q?Xjg55LceL3p/8RoMPYBEUmHDgY8ZVrb/tYgdAEcpN6+pqRR6pzEhObaN+pPz?=
 =?us-ascii?Q?9zfmbZPkZ+KmfgaPpD2YvI0TZczwfwd7T2w6nbRsSEKiLIt3EZ+x4kifKFjL?=
 =?us-ascii?Q?tbYErO7TYzuWygtX7TB8CAc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf307329-c1d6-486d-4b05-08d9d11cbf03
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 13:59:24.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uafWTYZYjzxkFk8tWBZBlYyBWQywXoGWpekcumzoEcNH5F2ZZsSr72JM3EYqRblL9mH0xNbg2iP6PP997SAvPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The parent pointer node handler must be declared with a NULL
initializer. Before using it, a check must be performed to make
sure that a valid address has been assigned to it.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 7f509f427e3d..e80376c6e55e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -41,7 +41,7 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 						u16 dpmac_id)
 {
-	struct fwnode_handle *fwnode, *parent, *child  = NULL;
+	struct fwnode_handle *fwnode, *parent = NULL, *child  = NULL;
 	struct device_node *dpmacs = NULL;
 	int err;
 	u32 id;
@@ -56,6 +56,9 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 		parent = fwnode;
 	}
 
+	if (!parent)
+		return NULL;
+
 	fwnode_for_each_child_node(parent, child) {
 		err = -EINVAL;
 		if (is_acpi_device_node(child))
-- 
2.33.1

