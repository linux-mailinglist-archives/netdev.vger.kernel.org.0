Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A03B4ED95B
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiCaMK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbiCaMK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:10:58 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2091.outbound.protection.outlook.com [40.107.255.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2810F1E5A6F;
        Thu, 31 Mar 2022 05:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9b9OosC+mS58rgiSdZSSmgsktIJtea6RdhKlp41vZaUA8BcpicK+e/p+D866qgnyd2E4Ovab5XsssSNJdMSeNTgbB12Kekbqc8JzIU92OMbKDEKJBY5uW847VYirIhzjgH9wogjoF2+uCg6+bfEgnx8587YDxEsGpctVloGZS1Nbz1wEuaRznYz+kCdIgf57bvqfJFDymgC5/wtebaFhZ/H3k32N0itTkkF3130lS98O2e9Shr74nco74lRCCLmvKUHhh+eVuvSL3LVwfpfKlUQxSgy8FMmmvUBDTc90y9sJijGqzUDV3f7pWRHvkIJAE8ZzkK4/K4F8jEF1MrVoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzaTI8isN2L2nFbXn2wHNEiF9xB0iVzX4iHh8M+Sh3A=;
 b=Fx0KN3424IyWzqdJVdBR2I3p8xEfvN5EptxmG2LG+mxt5LrdFGVhjPHusMCVOwchn9eUuLOnRLdrGjQkNQh/wCGuxBZe8OcHZaMbWUA5mXcJBi1QwQOUpP3rXGDTYgOF7ynAYfR5sT4E3J4+2AEvzRGmD/MK06K9tZ01V6zqOO4mulGMnbt/5LEF6X+vDo+PkecgRRFmHP3VZzoW7B1/FfIKfk4ra9vGrkT0dBOb4N/CFssq4EDKPbTap8k2fVswL6zn9Ov8mjIs7pPfja7M8wu0OmoLCsUGoC/Lnu/MOXXQd48jB4sJII2EwFJaiIhFuVoUcAkTVzqaHGHTr2kc1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzaTI8isN2L2nFbXn2wHNEiF9xB0iVzX4iHh8M+Sh3A=;
 b=kNfbAZnJ3TfZ90DYdFLZbxyGjmfnQVIkmAuHpe6aOK7UQiLC6YJ41yctjehTzdKaBdZTXwd+fJ7OWBfAluzz0g/i8/3txhGGMp/oJd7NYn+w10f6YkBIiVDMN/Kllt/WNOAT+V+xHcBx3vLGjkpIosTmeX07V3+oP0dmMZxCRlY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SI2PR06MB3882.apcprd06.prod.outlook.com (2603:1096:4:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 12:09:07 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::6c6e:d8af:2d3c:3507]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::6c6e:d8af:2d3c:3507%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 12:09:07 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: xilinx: use of_property_read_bool() instead of of_get_property
Date:   Thu, 31 Mar 2022 05:08:55 -0700
Message-Id: <1648728535-37436-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0023.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::33) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1785eaf8-c9ed-43b9-32ed-08da130f414f
X-MS-TrafficTypeDiagnostic: SI2PR06MB3882:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB3882197487B931A229396473BDE19@SI2PR06MB3882.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/rJuofNRHHJ2kwS4UUY2UZWJdSmjkH1y0QFBogJS4SXGJaHCL//EV+e5Zy1BLEIyThM4bKp3QRO92gxPJ+266whMGVxudQYKMkpx/3ilglyw28Xd10h4xZ5LC7S3TyvLjEgUJnhl3lzJ6fmiam0pyiDksx9LLGAcDgw2rMSBB5PnW1esFTxywlbzoCU/LPY1DPlJOOIUFAhlwKmyger/W1LLlnJsVo9VFThq3wGGuR872tkZF4oHhzEUHi2aV/DrPS3YPvg/WeKKDllHHb8IP+6izuw+YvnUdfNNbcYFGl6+Yn2yK+amphhaPwZqIESVRL9M6z/25RSGZrGQCMNV6Na+aXEwiaePdM0fnzh2j5xVlrkvhr5HUlvjf4TBZOcGHUQVrBdhqtBxTxBRPF7/koXemszx/o6KgQ3dU+dDitpoOPWVrXJn9s1xXTjy7amaxX/Nns3gZh1DrtUWSmvtDjTtSfEB+nZY+XKMoYYe4yS0XGQxhj+cLtb9L11lT21xItqhBQSDUCuVdMzVpAhR0iHgwbxCmQepiYxzDdWxkB78/VL67gO5FXF5+qNoJhOAlSoPyMshuV6VUwoICg0Pca++0EZdZPcOotU6w2eHjAQXKDrEczybYu3mwu2x+JCSGSpx43MpRVkwJxlo08s4zyD59n2lVOTxH2VSW7+70f0QmiO1vFMvEVXRuD59GMmbnt70erW+xDvxFTWXmi+gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(38350700002)(38100700002)(86362001)(316002)(8936002)(4326008)(66946007)(66556008)(66476007)(8676002)(107886003)(2616005)(26005)(186003)(83380400001)(6666004)(508600001)(6486002)(6512007)(52116002)(6506007)(36756003)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z4O0DjhpCxyfoJL75mcl53HUuxWOurPHA62hKUsPpphHxCeI2cNCp4HPUxcJ?=
 =?us-ascii?Q?Q/HQEdjbkC+thk59MCe2ENnUpys54Tp4qg+S3g4708cYtt+SMzxLCZv9aKA5?=
 =?us-ascii?Q?OAc5G+xDmLfwI9a6L1d2rBkmIaEBGskUlmB70gnhPFDWJBfYnzIq4Ie3E6e9?=
 =?us-ascii?Q?LS8H9oX0SBlMlArylzWvEvJqkhz+I0VQeGG2+Bb0l2W3uPqpApecEvnPpSM6?=
 =?us-ascii?Q?AZ8O/GqKUDVRJ4Fezj3CdDcaZbVu4h3tdrJa0xTIKxQZuqkKly+a0IVIUwKX?=
 =?us-ascii?Q?gpV2MvyMAKyssRlIUpxo/QVEy16g0yXBQ/H02WKyok14LI2mMIVVg8zMiGil?=
 =?us-ascii?Q?JsaTHPEZHyCREaIgxGZgIuYt7mAowMh5uENl1XZE+PqmocWIm1rUJ/0+djmp?=
 =?us-ascii?Q?P3w2THNRlzGf8hSZAwlaN5ZmmgxDGp04PhclwN6Fb+Iu1g2i71MheINKUMG+?=
 =?us-ascii?Q?f2CRYS5R9u0EORTzP3iC2Hn3TEmLrbRJ3STQlG4KNdIQvetWyO3UpdacuBIS?=
 =?us-ascii?Q?E01sc+dRoruxGPuQJOjlY+gRmjeS/rxEkJYbtGlZ1qSZ+7uI/XsdgVUmNWtz?=
 =?us-ascii?Q?6QTFw+FnjYZ1EsDmVK99LBVaj/2wLWVcjrUkAG3WKWab9agAA5nyEu5BDGEg?=
 =?us-ascii?Q?oXEEbVRONwjD3bOM7q4Z14zMQ7LY/P3mBonY8QMQ6cSpBYLDH7IHPBjEWhtL?=
 =?us-ascii?Q?b1FFWh8ZDIhtR+NTvB/8SWNOPBfVVOdYU5wmqnsyohNNGF8gHiDEFPPN10Vp?=
 =?us-ascii?Q?vCCVl+5Cpu7s3miSnvb23sbKbnXErCxWbGe6wxBhI2P8l/rIbn2EEYk1fjnW?=
 =?us-ascii?Q?f6ezCOt1+lVoYsMajOCmR5heAoK1Ayb7Fsbm96HASETZ/LgDVIMjg3KJ0ajq?=
 =?us-ascii?Q?R67uQ5i5j2ld3v/s+q+d+v8+dQAhd9pHfH2MO75oRdEtX2QDLgSz9c5re4aJ?=
 =?us-ascii?Q?UK5lAt07VduDC29RqDAymldd5gOBgbqFe6eiTtaz2oylM1ojF4DgXuxYSFnF?=
 =?us-ascii?Q?RhB4e4ssxLyDJ6uwfDCvyUMpioLty3vmeTvBdKj5yX+vJawUiHKWGbrh4A38?=
 =?us-ascii?Q?v6CTuzuoaH8yKf0gEqMpHKssCRPwRZunEJsd38sbpPKn3z/xUVfpfA+lOnpk?=
 =?us-ascii?Q?Zx8pqtuXxNp6kNIP4yGDND5Mp5MwKtu/uE73kKb2v44rrqSvMaPGqVva0qkN?=
 =?us-ascii?Q?v+xis30a99OZFZRk+os1UnqbX0lTWq8V42Z94KZiiv4yTBNNtTx5eflE2GN0?=
 =?us-ascii?Q?fPwcl6EA2hUhbcIUhL6ZclFtbbWDama0/IoWPIdfwslnhCdYhSmpYon8ImYn?=
 =?us-ascii?Q?C+0AjWQz1Bf5PE2KuX++bf5huXbc/MXWm+93a2jCvWWHoBZNEjhToZiymr6X?=
 =?us-ascii?Q?8PyMrMK1SQSllEBgb6JHlurlv126iOrdQ0qaA/tRsH/B43UrdV26CM6dIi0Z?=
 =?us-ascii?Q?t4TAtN33hc97BPdWM30yde+F4zXNEJWPpo8nzfH5ra6t0WiOHb4PdOPRWkpG?=
 =?us-ascii?Q?6hRjjCwBAzCsaPJYCMLEd3Ih3cyTaO2ecT9L3y5McL1VqN6Bf2FRNesiwser?=
 =?us-ascii?Q?+iNfQkbJz0yrIDBzCGVcs2ueF9gkp0HJZOZjYv+MnKG9+EYk7NB13waoidrM?=
 =?us-ascii?Q?cejSdmp5e+oGxTmdc1Mm9Zl3zZYdI2PLW4NpJXEJLVK2y/sM+3F7oJoo7/kx?=
 =?us-ascii?Q?sYypPfypvDvDdIZ0sUHbTIAoZrTOZvbal2LVA8EeRj9P6Msq+SSLLy5jU2Et?=
 =?us-ascii?Q?RId/zrGBqw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1785eaf8-c9ed-43b9-32ed-08da130f414f
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 12:09:06.9211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ugboikd+k94aoiOI8eYdtGrHx5ljqcEwzlqlGhgab8IDjNkxsSfVHvO4ioIiBybrAOIA7Z6/Tah52ha+u4yaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB3882
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

"little-endian" has no specific content, use more helper function
of_property_read_bool() instead of of_get_property()

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 869e362..3f6b9df
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1515,7 +1515,7 @@ static int temac_probe(struct platform_device *pdev)
 				of_node_put(dma_np);
 				return PTR_ERR(lp->sdma_regs);
 			}
-			if (of_get_property(dma_np, "little-endian", NULL)) {
+			if (of_property_read_bool(dma_np, "little-endian")) {
 				lp->dma_in = temac_dma_in32_le;
 				lp->dma_out = temac_dma_out32_le;
 			} else {
-- 
2.7.4

