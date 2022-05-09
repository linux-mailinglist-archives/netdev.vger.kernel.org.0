Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43884520033
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiEIOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbiEIOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:49:41 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2132.outbound.protection.outlook.com [40.107.215.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48776186C8;
        Mon,  9 May 2022 07:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ6+3ozmw1em8gKi8FhepgyyvNgFO/FvoNIOjYtPFr6sFGzHKHxgun89QR1AHWG0QMpbm5oJYs2ObExdz9cXKg/VelcxB7S7k+jtbiPTR5TzT/B+ardNmNjjjBaASRlNcs6QZf2fMDn3CZa1AJCJVPPHJbm/+UkxHqdUoQtk8DnuTwKvwCVZt433bddn9tU0yCleZvknnEkHy+vaQP9MUzoQF2bdG4AzuuwRZJAdotohUV8DUJ2HUOIZrUWoeDJsr8oQAaIMqY2I5Ms5omIde8ZU8GPZu6CiSpg9Ay4vKPu/RDCYKMA3mA0AwGUDGZhuuzh673fl/dOhN13ZVxn7dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlsdNskJbKMItaNsiYE0Fugh6vTR9nPjA7aTWclt6UY=;
 b=A9shnLris7rulnU/z/xV3fA3q1vVJpAMo7bnlsWP8amCQJAfqs5IqsuNv7AgQXfl409XHXfW7zzSCgqUsyyEf5r3TDdMdtCHajpvtfSVm8Sovn2j5JAzc1s8d6VIkwtLQjskCgRq/BX5YypQRM7qvp69xgzsx0DWxxkNVdW5OMB3+td6Upu5VzNOkXZJ5vsdgJLm4pAl4mbrTTWjV5lnuBHUbTG+kYXvO+F8CTnfMw55A0zGu0ecHQnRGfdCP4HLz6vU8M8ACm2RmtkQrVA3BD2ZkxvnR5P3EIKa1iqdVgzFLJQDa7V9vqCXsjjhKQvOFLkOjsA5EX3mUUWiaCW8kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlsdNskJbKMItaNsiYE0Fugh6vTR9nPjA7aTWclt6UY=;
 b=Xrm94HjoJOMmyAany1ixTWcTR5ywPHicMyGgcjr322bd/iEVfwKu9Aw49PoBKPoCZ3Eq2w8WdT/cHtDibkuAcGhiK+G/+geF+KQ6UxFj9stin3miPNiPfenQhWvF0nBct9I+meNaTC9EkNGC3Hyor0nu7zroN4z5B8ijra8KlFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TYZPR06MB4096.apcprd06.prod.outlook.com (2603:1096:400:2e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.20; Mon, 9 May 2022 14:45:39 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 14:45:38 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH v2 net] net: phy: micrel: Fix incorret variable type in micrel
Date:   Mon,  9 May 2022 22:45:19 +0800
Message-Id: <20220509144519.2343399-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:203:d0::12) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c22bfc60-bc97-457b-5c78-08da31ca94fd
X-MS-TrafficTypeDiagnostic: TYZPR06MB4096:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB4096AE25A8C86B1628418C04ABC69@TYZPR06MB4096.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Dpw0AOiyzw8wDapgUEt9abV9HCyCsReyVRLvuH5OwTGVFpc3wgckntETco4Tb+YgW+AtvA80MhZgxVe7sRICR3DuBpUJyCsvTdCMQS2sLB1Fdo2rUgQFDApRN+v92C1z+9SYkfYukgOLJ0yISBKG/uO71up9z3/9jpA2ILwnFkR6KsMr89WiJlSiAzFOMs/Z/YCg0z4KocQ+BFVmeLqY+ZIIXBNMlryPt1uaBml3UTV51dYpUVChgdK0q+zA0RkrsrnbAbw3e282SOb77lb4j1lMPMBvM0q+mS9w27MfoMTpyPh8YHQMBC3LPuAiC+vIzaK9Xip5dCTF03pGtoqbNPikD0v3OeX2XxNjyTJHzaH2dJVaXLrq8lkFfC/t9JfNjN+OH4nOUbezvjt2bfngmdDwN+8dQonTA0Bfa/VxK1oEMYTeNs6l0ihlBiykGIj321CxrbjiyUObUpB7xuVL5Ra2c7vVW8C3pgOwirGXcHP8iNbklPzRKe41NJ0eyku2t/2Gpuboy9zrMeYTXGMPZJ3dTIvxrjEXqG4vfte1eO5CKG5oMsavFSxbeVg4VQBh9JumusuHpWtfekeb96Lspp+gBPyE5UAjfFdEmRvKJ/6NGOd8oCJNaLEWlU3zW6i1aHsg2yTs7yght60pE5r0OfCZtTqfuGBImzSg/DPhvTLgx65SFhpkG1AdKz5Rk3c6DF50TCo13Q/eD3lMIpdog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(83380400001)(38100700002)(66556008)(66476007)(66946007)(2906002)(921005)(110136005)(36756003)(508600001)(6666004)(316002)(6506007)(6486002)(52116002)(107886003)(2616005)(26005)(1076003)(7416002)(5660300002)(186003)(86362001)(6512007)(8936002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n4opJUGaNeAvIqGxwe6VFnN0Cs3OvqthFP//VFo57ZNYuznPVB+oXnXv9qDw?=
 =?us-ascii?Q?zmFvn21VWfyY5wOxw3PMXiSIgSHdpk4V+y/pB2IBp4qAKNT7aiX9TIg3VR+i?=
 =?us-ascii?Q?PfIbfjGiu0ntOosbJyCEqRxT/s90TlVIQsDrcZ9lh9fsGb2Jkqpb/VslAe02?=
 =?us-ascii?Q?UTusfNTkY40dnSAFVEJdDfR+Syr6fsMf8YbtOSuZqV9SScvnFOjQypRv7EOB?=
 =?us-ascii?Q?qNin8+tivWDKIk1xzuNZkrh9FLFZjvpFs/2Msq3K6Pb4GmaHbzm2QorgCDfE?=
 =?us-ascii?Q?0VdU6SV2kYTTFZuMnh5YLQ2E29qR3vMOwtYg81fSiuxRCTys2ZJmiWCJ/LvV?=
 =?us-ascii?Q?7OZSjkLj88pJPv8yYHI9Hsa8tDtIA2bLXNbJg5WWFk4nY1QZ4xPgqoUGG4qa?=
 =?us-ascii?Q?he4U5YAWsV/Hc3NKKkY9p5YyACwVkEf5rp0FRfPe8mJAyxJxv/tm5XPI3CDc?=
 =?us-ascii?Q?tw8BNlHx8VUtHfUvZf4zNiwRF9n+ra8Y/LENT9g1m4ROFgvq2tB8xBVxZDM/?=
 =?us-ascii?Q?eJLFNLkLKT+gKJ7+Mxin/p94ZeEDGi5BSKuuayvxoP05mUE0mzIQshTO6zwi?=
 =?us-ascii?Q?Jopd7oST+9A05UJJjo5PLNn0NeTq1OiQ7Z05YbMDdBAMciIMMlgeOy31gHWa?=
 =?us-ascii?Q?fthaanB6cf5jyxtMvKHJ69pqnzNi99+dxs7fpleKSgxXwVtfHJSd++2RzWwI?=
 =?us-ascii?Q?O5K1Aro61/JHSe4dxoOmmd/6DqoK7lWDrVDOv8rdELAxb9XKA69abVcuKgRG?=
 =?us-ascii?Q?2uzJptfMOhDjF9ZvhBl4V3RhrGsuvMdOl5L9Klgy0bDGm4B9HZR58xCPgeVx?=
 =?us-ascii?Q?4ndl9tl2ZwgT7K58ZBa1XuB0xtK6sP6BvG98Hr3fYSADbMvSeDafP/6pYyuE?=
 =?us-ascii?Q?mG+MmCAx4IhXEhReTbw1u01Zk0jqp5ofwJNfxfDaqYtciaQ3qYsWSw6xtGDz?=
 =?us-ascii?Q?dz6BR4yCGH7dX27SM8nEYBVd+9qnZLDOHZBLQCO2mz5bawa2EeCH8ZSHa1QY?=
 =?us-ascii?Q?/qZAYmzia90Artu+hRY2Vb97y768TGFR39UEt+JM6oDZ2DaYlLTbl8b2aye7?=
 =?us-ascii?Q?pxq4zWiKvSsNGF3jxzR2bIYXf4TTG7qfg3zKhRIEqv1kUqjAZYYvDa85ASgq?=
 =?us-ascii?Q?69mRO/5mgwEvJa9CDXMaDu+xLeLM95pMfX2sWXg2yHXTjpxWyp6GoEhWaaqz?=
 =?us-ascii?Q?SRKqUKov3yXgvMczuBcSKWROTa9H6ZR3kIU4fVuzsl5UK7lNDH5kvUSuoFV7?=
 =?us-ascii?Q?uNTgWiFUwkL7zOt4jZniNkaMjxjKVEtwALH7X1NifxDck0fhdSKeBW+n8WyN?=
 =?us-ascii?Q?pmnfYit7VHl6KfERvgEXo7TlOzTNR2rqw/zollmAM+kWtEtPgxTk+kStBGbW?=
 =?us-ascii?Q?Vgt3aAdtG4r4DgBXd/kVe9zKiP2y1JoNoDAncOHpeYw3saZtDGd0WONvzFrs?=
 =?us-ascii?Q?e/X4ocvcCsJsKsOKc86QDwiUP9dEOEcMna1pFk4wnIZ1yvu3YY7kjw5zNyzc?=
 =?us-ascii?Q?itFvn84JSs6Hskbo+0l6yLkSvcDzxzwTuokDdvQdLFm9LlAMYaOp9t1dXzRl?=
 =?us-ascii?Q?opg3G/8qasyILKmTrOT7TuByR4TF38AOHQQ7cHiMTGxTml18UoZGm9x0xtpw?=
 =?us-ascii?Q?TUJnOseIEjzKWlF2dr9AqGjugYPjfEhHMaPSKIuaos1m6Uny8oW1nBiwA9sA?=
 =?us-ascii?Q?NbMiQ5Zi364JMadPXxOP1RXmrkhsIwdCVJmsh7GS/YO/v6jBahzV32OQyw0B?=
 =?us-ascii?Q?MSriRAEFIg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22bfc60-bc97-457b-5c78-08da31ca94fd
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:45:38.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOQdLDWzkGVwJ6nflpwsfIVdAwB6z7SpY7KRmYF3iAxqfmwokwNC0nl5SzIkKL5TCCAXposawRLN9UDE2pkHYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4096
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lanphy_read_page_reg, calling __phy_read() might return a negative
error code. Use 'int' to check the error code.

Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Add a 'Fixes' tag.
---
 drivers/net/phy/micrel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a06661c07ca8..c34a93403d1e 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1959,7 +1959,7 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 
 static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
-	u32 data;
+	int data;
 
 	phy_lock_mdio_bus(phydev);
 	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
@@ -2660,8 +2660,7 @@ static int lan8804_config_init(struct phy_device *phydev)
 
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
-	u16 tsu_irq_status;
-	int irq_status;
+	int irq_status, tsu_irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
 	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
-- 
2.36.0

