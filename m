Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCE34E2485
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346431AbiCUKoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiCUKn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:43:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B87B1427DD
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeRTIkX9UAZGi1qta1qfajU0PaZKDTcpPoCvHlQQC9D4kpy4kkOOvJvgqtCFMiObNR1DZwliX8ZPx1gJZKj8TAwlF9T7+DHEDWuafjgAIGXOy614O7gkZpi/nEWwtyNYxgL8xGmxecfyreuapRlmOcpMhp596AXM7WfNzbMupniK5lwqXy2ELOET06uHEb4TKCk1n2sf93aZ8jSa0iLNXplG2CazXiAvpiU5XHxoZpsYViJSAOp/W0u2yY7kVCp9w5ELrDtvr7L8Q2TtJ/Ry66N0Dvm2cfs6EWDDTXg/+Oop2yUjKtP8Uv7lVlMI1gsVJmwu2FghFVV/eECS1Wf+lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bvmNd3fNL0+vkiDsCp3Qxo9gTvFTWibHqUOwX3oEH8=;
 b=NFmeAfcF/qPdYWItrbuGWDuIMeLCWWIQ7rA9qt4njW5Ho3QpU1Or4KRS2hNdOUGqzIEDEONJM+aqAQvqp0ZIN+j1i02Ra2mq+dpvuZCnnY3zuPfKwsXxoH0PAFzuZblApI9SFlLruXObzv6TcOWrFNrqAcrMC1jGma4v5tLUQLtwOHamwQvUAkF5uD8TLyTvP22YLeBNPFBT7Akz2NbsgZm9gSnQZO1IJdoqNAUlFN2vozFCLEE9z4uBbrK6bvL5OuJB1EkxzKEk2aAZaW1VxWwjZP175U9Zkt+kq3Rmn5pAGgOB1j5mJmfOyKvAEUlH90amRIYlsJRgg+sO1UHE2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bvmNd3fNL0+vkiDsCp3Qxo9gTvFTWibHqUOwX3oEH8=;
 b=IGDlyfq2UHiiZHMhHKXHDwYKbs7kNkSf9y/lcPdJ96vPeOwte00dOPJcxcnfUBth97AyRpRrV8uZ7rvllk2uxH1DUIfJA9hzuDwaUiO8LzKCNZDcUc7x7I49yoV/rdcLUlnwVncv3W+fH+JaksG6ofjNZyA7ZWFto3ibCEtTNo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 01/10] nfp: calculate ring masks without conditionals
Date:   Mon, 21 Mar 2022 11:42:00 +0100
Message-Id: <20220321104209.273535-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb3f5873-38e8-46d5-ee9f-08da0b277ded
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1512D9FF7BACE8452788BB1DE8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnGZbLCNhlndWu7YH2hnfxQ2CmvWuUbBu1T7FmcmYsL5JumqCmAIvYrGw8iQJOMoGuN3dBtstYPJEuiD5OV6CwWPYt00W1kqx2mRMfdOnxZlWebRvz+aG+rsCNM/q886ao7ozePHnYJTbv+SngQNtCTr7WzwaeWLeyLN/6ab0a1pHglxk2ukIwPPGnsLV+xPfX2n785sBStOp1HzJUv6sjNW+a4oz146SoW43hVFCRCaK1bwGk3pAXtnlSVZzUotpr0IruzqBHV6lyzJPZfkwV93aNhArzkHtVVUOPCyxrT0AHrAoXctkg6PXrgHBd4Nd8ZOaxBdyVmqVT52qIofYBtgpGb+SP/dcgXMMZmW5h54cc4rZLfN4nuGfTX9hzX+uSL7/Dg+z9Fqpftq9gFbrY9J0x8U50xstdUmmhWeFN9cOeRl04loOi3vkgwcf1YzLgD1ektSmRY5ggIlJCeTsJI40vBWSVbaik/IMCuXhy6993YCNWX04XKtSGakk0zb3MUt6eh5oWniTDVivthnwf7Nmvi64NOCbFsfHdUuhU9EdVYm36YtWyPZ+EpDG1s6kTIh8PLFy0zT1ViBeRyLanqLrBUyAMqDG50la8hR+QYXRp7j+j4TZ4x3DA2GRPRFvIuQZMWbclWHWOXFUReo6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/1+2jlQIuQCCSnujw2+u3GCvN97cS2YCkeQHqeqDRZ4G4WG5VXCI18M6+0b?=
 =?us-ascii?Q?A99LA0TQ+339m4EMA6tlpZaLBZD2vteAWnvY7dXuYZV0ojM9zT6HBPmsw2N/?=
 =?us-ascii?Q?9rBs5cK/3WPmydX7CjDn5nzAuoDvEiEQ1ro+o/RGZps+JdZecdQQ/maqYFeY?=
 =?us-ascii?Q?Nxw8CTZ0DJMwQjfApdq4Symlr+7euCdDAK1XJObeXm7Pb9ce3WJg2mn939Y/?=
 =?us-ascii?Q?H5pBeKZhTWtfwy1axF6Q6rUaaV8VCmOvJqGYaz+WFVQ7Ugxv43xI6PxL3S16?=
 =?us-ascii?Q?HyzOBvnyz0qtELA7h8Pr57Ndk/2qOPdgGm9dClyxxyUx9PTn2VN0SJMpdxDe?=
 =?us-ascii?Q?2XX53RIuWXkUg4VjLatX8UJtyUbsWF4GVPh2zGAsBQSE8B0thkNkarrFwifs?=
 =?us-ascii?Q?a3jPQEvcmUvs0JSjBFihfBVA1Oq2rQCk4bZonHBdOF9lc5OHudZ1qKiSk5QL?=
 =?us-ascii?Q?ZeVZZv5mj+M9iHUeKTAVFUIC3Vc42S3eeU3PIWznDfaLkkrTNsHQ3TZx1Unh?=
 =?us-ascii?Q?mhmX4ZReD4J2eFGJNDQ8RO3DhFD2dDDkA6BqjXMYmSm1D20H/zQKzm7xXP+S?=
 =?us-ascii?Q?feFTH7t9MrCzIJ1hudXZwjJ/vcX/JIyd8d2EIXcRYLna2eHxAvCcK2IkWmQ4?=
 =?us-ascii?Q?gtBGRkBMwLNM7uTt9uqpiFTR8iu5SGvXyYIFEl/w/7Xd6DiEtJw+PMOmWwZu?=
 =?us-ascii?Q?IpKw9iq0BjClgB1KVGxeZfPMHLIDGtKKhLpNHfI8rlxeF1i2KmHDOGXUwuWS?=
 =?us-ascii?Q?znYUgWCs2Gri5pSIwVYs7QtTYyKLLKmMkXDQF7P2Ex3sGsEZjqlcOztLkCwb?=
 =?us-ascii?Q?+pHO5PY3BzfPECJEmLYhizRCP09gCs8x/hy/WTFEw7EVZAbCMv1CYJuYgRz1?=
 =?us-ascii?Q?ViUOUGJ86ziL1rDeVnG9mbN4MsCRSznlB9u3uBdPev/qKUrKORICdOr6al5s?=
 =?us-ascii?Q?3gmxLYqAeWZCRWehYBjODxFQMl5VOd7unjiMXc58fPizIQzvTmgG8UxbqjCO?=
 =?us-ascii?Q?EDlAfqXkNB4ISqAKSv2JyZhPcs94AVnaevDPWCNyk3YRRFqwTUGnz4xoWZOc?=
 =?us-ascii?Q?l54DeHVwZBbXnGdjuLv67YqOwD3IiP9C7xX3YZEL5ZTLQKaQ3d3E5xTJ1Q0h?=
 =?us-ascii?Q?VdgpYl8pjfJwtLnaJAeZpP0/vNr/2s+En8KMZHHx+an8b52bbyMuSgfhSefx?=
 =?us-ascii?Q?OyfCeBLmLpy8SxTOfPegoT4HKazTpDx6T/upMOcz0X++Mg7iLyaLtyNTcvUT?=
 =?us-ascii?Q?EX+vLsU6F4oilE0bPw2eEmAd3h7ALRxXSC1D9Jofg7re5VeskbQP2F70P11U?=
 =?us-ascii?Q?EbTT3efuqBMpAROEUoLWtriW6HXl9IY6ncXZ1GJQ6oma7lZsP7VJzOVD8Xpf?=
 =?us-ascii?Q?meIizZBfuvZcnoqBHR2KlNUP4zOycX7tZ8z5ow1rpdmuU3XPt8kGMKlkODSs?=
 =?us-ascii?Q?qjrufK1MDKrJwluD15Q0Xz/hP1hs6yW3syKFd93gKigmglyOHEl7x9wh7c/2?=
 =?us-ascii?Q?2rUeG1qc6kYU3mw+b4bui/B32YcN8Va4FCeapPaGCwzqefc7VdFVi3Dm0g?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3f5873-38e8-46d5-ee9f-08da0b277ded
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:27.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLRGtwVa5ROv00qkIgDJzP21YQ6MOkczC9W1ZyngRAZAIsIXuKQ59RBR1f1KoiI2eE+cH3t2Z7UCvHPvhGN6i+AAo90SPSEDU0xVvxJlLYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Ring enable masks are 64bit long.  Replace mask calculation from:
  block_cnt == 64 ? 0xffffffffffffffffULL : (1 << block_cnt) - 1
with:
  (U64_MAX >> (64 - block_cnt))
to simplify the code.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index ef8645b77e79..50f7ada0dedd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2959,11 +2959,11 @@ static int nfp_net_set_config_and_enable(struct nfp_net *nn)
 	for (r = 0; r < nn->dp.num_rx_rings; r++)
 		nfp_net_rx_ring_hw_cfg_write(nn, &nn->dp.rx_rings[r], r);
 
-	nn_writeq(nn, NFP_NET_CFG_TXRS_ENABLE, nn->dp.num_tx_rings == 64 ?
-		  0xffffffffffffffffULL : ((u64)1 << nn->dp.num_tx_rings) - 1);
+	nn_writeq(nn, NFP_NET_CFG_TXRS_ENABLE,
+		  U64_MAX >> (64 - nn->dp.num_tx_rings));
 
-	nn_writeq(nn, NFP_NET_CFG_RXRS_ENABLE, nn->dp.num_rx_rings == 64 ?
-		  0xffffffffffffffffULL : ((u64)1 << nn->dp.num_rx_rings) - 1);
+	nn_writeq(nn, NFP_NET_CFG_RXRS_ENABLE,
+		  U64_MAX >> (64 - nn->dp.num_rx_rings));
 
 	if (nn->dp.netdev)
 		nfp_net_write_mac_addr(nn, nn->dp.netdev->dev_addr);
-- 
2.30.2

