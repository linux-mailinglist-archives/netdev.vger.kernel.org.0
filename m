Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C3523A00E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHCHIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:30 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:25506
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgHCHI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ig6Y4S+A8e9yHd52F0Z4PogE3p8I2+FJLF607KxA238jFdDk2kD0gW3MxVPDf3g3Cu/ITwmMJnXW3lH8rKYoIxgwgdM6hdrli1m11vVkEL4xxCJaUI6AE6e7TX3SxyEjkSmtY9LxZooulQOH092U9eRoFRSrNpeP00mPZautvrvWz2ob0OzGq0Vt0ci7hiUV//vtl3cpTgTiGtX46WXtSbk9L0lSAtbkSegykB22+BFUg3D6I8O60zoWELNdbFiX1Jk+GdUC1ewzZzoDzwEqVNEDg/87Ni9Tc9Zn6PgEUSDu3uM1/YzXXxI3G5zcOo5Dp9O0JZ6nBqmRe60nWdQnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv7Sb1aIddJ4o0o7SJYBx/eg2HRonbYEfVA+c/wT/Lw=;
 b=DgtCPgeyjAJdQCPJTNPQy/5TbMHQFJuJc9w/lxf9j/K2AV+ZoHB/9ko80IDxbr5sxH/7LCkLEJmWldFSCCr8+ckL90i5QfL/M1sKjBCG6PMvfkZzq4nA5R8zZ6AcWueEK7mt16srvU36HgX59NszGV3wMqSXbjSpfXc6CqFNL2xfJbUfs4WbBNxRKVoWVTmMjvb+dIK3mptkwUCZndi7U8/jwyeN7Y2WLIq4Bw5evr9ZNQ7pX8r3aT9Cd50zORX88ItjsTWi3N2pdBh7uO4tBF23F5zD5yTzx50vpufhfVREUnJs2h/iKOjtXanKH9/h6olJze+qAvxmxXsboHdm+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv7Sb1aIddJ4o0o7SJYBx/eg2HRonbYEfVA+c/wT/Lw=;
 b=OkLFv+3l4voDVljDivTXvwzj7f4HusS3ghiZPM3UrA5k4bVB7UYeb0TImjN3ylGFqsOFyqULk3lAwCD+Bk5MpKLdiV3FBI4tAiP4D1v4ANBK6hOHGF/tW3FI6Y+83mfHb7Tx2S+wZ7YH8Ot52sRv0ozOpiZUSI/SpuNjxbvR6hk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB4356.eurprd04.prod.outlook.com (2603:10a6:208:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 07:08:05 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:05 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 5/5] fsl/fman: fix eth hash table allocation
Date:   Mon,  3 Aug 2020 10:07:34 +0300
Message-Id: <1596438454-4895-6-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:04 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62f7b1a0-615c-43da-afcd-08d8377bf7cf
X-MS-TrafficTypeDiagnostic: AM0PR04MB4356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43565D3FA01CD1BB69BF0078FB4D0@AM0PR04MB4356.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DK+eYYcB/0VBuDgow0lGWYjJsj4n+JP9glizwsaNRGnREt7ZEE8D/kXlM7iRBULNYLyH1eB1RZ485uIBtI0vc+HaJkrTiJWkyrvGbQtbx7Z3VeTFLWMTyOhCTPrZcj31AS+eMNdmzVmSilaWXd+0+csTGZ4mfjVInuapmlMALCn3rc5OV1EunHS2w9YhPnvTzVKA4k0gf+5aOkLCajJVe6ST5UjhH2DToW2lcw+TGadEk47F00iN/+C7wrYhboCbW1nJQaH7eghij9CJbKbYk9j6qoHW4QD3B5RZOrYzqNvnWPpzsfPMo6UXzGssnyzYz3vN2KGdGeCK16CLasTU0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(956004)(6506007)(52116002)(83380400001)(6512007)(2616005)(316002)(36756003)(66946007)(2906002)(86362001)(6666004)(478600001)(66476007)(66556008)(3450700001)(6486002)(26005)(4326008)(8936002)(5660300002)(186003)(44832011)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vG0DFWvc7ldCK7kOTT44UU8tRx3vLMv1QKFJHvk9c//WeFwGcm0uNYpP0WkumuVSpatIFbnutNBWyTnDbtIUyKgKWXb2lflJYjmPrTC1rQkaQyjvAccgJ5Pb5dKXvfP7JIUvYe6Fq1GsMUuWD2YnOb9LuEhJG4NJmGLjvoiZQ1cRJ5Oja0V34kD2XB8xzu9E7P3H6srjBdcdaEjLrAkg8gUGSV+KsPR+gurkFyN1TJ3wLXtAryz89YDdkOSBEWEBRXDrqBNQQtS0fnf0xgoyx7UVYlKVK63EzcvzzYgFoijHzLdRqe94PQ/5XZB0eqgXGozt8q79SmDUQNyxTx+WcHCCGwDDgAcVq5+cw/9idelJqAy8QAXqqHylymmOyX+m5FQ+YFAaaKg/eSQxcCfmgcwEC1R4xPCvayZ4vA5CMsTIBJYJaEve6UOwHfElPkOAhV5UEC/f7R2C4043sj2La1al1ri8ncQFRd3dU8f4DOsDlyanGqThA0+3jDrWttuCrNxCddrEXs65Ep4XhG9GzevrtP1lyK9/mlIyLCpSLmVnErM61M01HZAhO9YH8MRa9ulbYc0hc2/gVDUTJQbQUlzV1Y1a3ro9Kz5v+37/moadCcGjJj8fZtGRme2kDW1CHpAWeovPYikA6zsEC1OwFw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f7b1a0-615c-43da-afcd-08d8377bf7cf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:05.2622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZcxHmXo888SOy++VOgF81akj20pJMQFnGv6RNZL8aj+wLDrFWxznXVT6/3QXnLFh5dXeCTNKRt8regs5oaHJVbESstOBtbMooI/GZknOwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memory allocation for ethernet address hash table.
The code was wrongly allocating an array for eth hash table which
is incorrect because this is the main structure for eth hash table
(struct eth_hash_t) that contains inside a number of elements.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
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

