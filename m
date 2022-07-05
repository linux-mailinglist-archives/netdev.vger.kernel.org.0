Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BA566436
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiGEHgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiGEHg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:36:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2117.outbound.protection.outlook.com [40.107.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF1513D13
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoiPxhhj11QI8Sko65y2Yf0UFB9xPfZWoScNrJPUdgU86VWi+oGfMavU9x8aZrbmyxQD3s2FbpPQk0NP8BD0mt3ftRa2VumC9CSc9vJVTTDgUripLC3sMNCX7YqPtBdG0VGZ0nkRKmd8j6t7qfc+YOi5hlMrc1Qn/2QCi2P4tE+IEA7/I8ezbn3YnUsisTQa1vMb/K4XzMUyFPgiESVC+Ck9kvK7REIKPJMjpzt5Quxs+GXZ1RG/I+4njAFra5qniBi5KlOiBv3ivzgDQ/LT2ov67BDk4m4ZSYkDXUQkN0FK3m7liQE8oehi4NeEb/Z9gA4H9xci5iACiZkb4L3gaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sq3F8iSAsbfvaJGOPu90bQ7c9DosIIx8V46kDhxgEr8=;
 b=L2di+xiBrMF1pAN0gr2ab0TwaWHMJr/0rAz3CQAnxKVt9kIziep4+fcxVk+R1rJKcfuk5OpkNDxra+S04eaKpRLWVGTzR71T24do/ZN8zvEaUU94HnXW1KFTl/BcfqOctEkBzVYjhPHhUN9pnJ6kL0bqxXj6UQki49GOfb4hKbIaxaHO2P+DPc8mnawZpcVX2pWK0eIrhkfvVk+xeQZhk9ig7bChxsRrueoLBShP5x5qUrKw8CrxKnpCG8vFXlUR9S9306YBD96mEbHq2pSZcpcxGoN9l5HfjmJGdaYqJGRlk6NtLpOCyUOFWeJ+SJ959IyKF2DJTNeR3wi41RmGcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sq3F8iSAsbfvaJGOPu90bQ7c9DosIIx8V46kDhxgEr8=;
 b=HRoNGMWQ8W/x6lTraF6psuu+NTsfCxc3AR7BAbf/kumayldBqLZI+FUrJ8azSE5FbqEsBCcl3Zk0iaG7FEgsXVsZ9L6+HB/odqDuVem8G+hATMzdVn50UbFYgArsAL2mBxmH7eSooz28XAHYQeMK7q3msDLscOUzSW7wXZXaKsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5312.namprd13.prod.outlook.com (2603:10b6:806:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.8; Tue, 5 Jul
 2022 07:36:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.013; Tue, 5 Jul 2022
 07:36:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 1/2] nfp: allow TSO packets with metadata prepended in NFDK path
Date:   Tue,  5 Jul 2022 08:36:03 +0100
Message-Id: <20220705073604.697491-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220705073604.697491-1-simon.horman@corigine.com>
References: <20220705073604.697491-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d61152be-7525-4fb6-a3c7-08da5e591055
X-MS-TrafficTypeDiagnostic: SN4PR13MB5312:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAie9/vZD7feFLbUWbW58BuS1t3cFJkWjRIoGqk7fzUaoly+sGpr2XRq7mbarQsSjZnKeXXUeDktN/ebiFa+rHxAODVQ5Oe7n5N4jWNSIRizuuyG8KGR9yEHTWeeBGUl3aKx5iWwStSmzog0gSa5egmwGv95usJXEQqTREoB7IZEt92c/ik4Bmv2kxN4pVBgA5hX8mBN9XqVflFDjnOFTZ6WxHExR9Nuwgg1DKv8rHrBcgkX6euE/0nTfMac5+EGzy8sneTx5PD83gwkP5PR+SKWZ6TMBpUmWFHHC5uyoJWs+U4wt3Wj49ttq53mA3/wVYe7gia+QPby/BVR4C5rs/+tDVPxT7fraWUiM7Zjlg/TU0BqHCOYFYnLfi3cikWvo+YXXml7iT2PvbbiyLecCOB7tzqybk/V1Mv+YTZNIP4jJmvFXUGyn11D2eILIIvF0KvZvN8xATKzGR1qZY6O0D+ptrwR2czg9Dxvo1HuDgObyC15OfBNGTn+oKbHsfIbRsISNfaXApVdKx8ZYvs6pPb0Hak9awpYSGzXcsl/t9H5FarppLZpku9sGW5FA6KWYC7daQYMNilk6oxQw2tmvqhNTXxvPysD8an1LvcCFbgCb1GiN4/k9mowjsrYUfnzmpiy0tCuZGAGQUvFWPMG0K7WFhtF3bkCkA3kMSYo7Rs+7A96rnJMXdaqXvPhsXUXXpywM5r7aAUtVh7yGKlnu18+8ztjS0r4vH/l2sKrq+AedYmQVl7zsy6HW/kk1o29gPRETF/Iaqc/neEOaaNmZDQ9lQH3kH1iQ258KxwKmVZGLOQvKRAXdsaVhOgvnHJuO21MYME5LsoMq7bRQu1YA4tkXAwFwvlJI0xa/im3rc8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(110136005)(83380400001)(44832011)(6486002)(2906002)(86362001)(478600001)(52116002)(1076003)(107886003)(2616005)(186003)(6506007)(36756003)(26005)(38100700002)(66476007)(66556008)(66946007)(38350700002)(6512007)(4326008)(8676002)(316002)(6666004)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SVlJgZcc6DFSE071/7iMYiVfNHyJDQvUln9U9tT4eZKgx9K5qK7BmbNweE/?=
 =?us-ascii?Q?AphLLN3mnhSmKY+41Fr96/zDUNz3M+vE6MXq+aEEYbvvbh5huGpPFErbpKDh?=
 =?us-ascii?Q?iF3zkGrzBiTBuD3R3SaEKCNkf3Qc+RuLph9uN2XSGe1saDPb0N/ryZxpqFtn?=
 =?us-ascii?Q?R74qN6ONpBue/zBlftY587b3tBkMzZCV3Z+InhjjYpx/ubt0pYe0aZ4L/42z?=
 =?us-ascii?Q?EWaRtzq2vlo10iGfsBkNy/IjnBghdMXiEi/OJ9r3J+o/5SDRWiFc+jdpiwMR?=
 =?us-ascii?Q?UarD2rHm5tsXAO9czafEmzPRP7gRdKtM3atTc3RAYoCIc31AGw4NHea1AzqS?=
 =?us-ascii?Q?YQ+RvP5YKRr0aUKuqS34oiizQahmCmCRKnzKwQm9j3Hdc1i3pWCHGNMQ4B0+?=
 =?us-ascii?Q?qs3j7nKIcrJRJwJ9AVAQdXVzjy/4ugK2vb/YjUZp0XnYagEpcA1L+XSwRq5K?=
 =?us-ascii?Q?CeXC1XnBaLJU+ASNGsFDg8vbNkBceOecvoprhSz1CvwS5TN0qcVH5u+PwkYM?=
 =?us-ascii?Q?epH1xvWuQbzxJM7/jHY1PX0Aq6VGxFCDaNi9fDXOvjD2ki7kSnATyjgcBuM8?=
 =?us-ascii?Q?3RgG+ulzjv2vCvF3VgBftXze0fhJwH5B/LrKp1sXabUYxUpUedIiBw2FFx5h?=
 =?us-ascii?Q?AiZF+sYqiOrFNAbYR0LerA85i7wW+hqJuJUZinD869mEf2RdXfVZ9cpxyrbG?=
 =?us-ascii?Q?oEtAdxqHKyRuAuJta5eRbayHuN+j4HEE3e789Ze0fLxgkWOSRhRBHcModR9k?=
 =?us-ascii?Q?lvFQJ+CNUoaQfKaERm6BOw94mbeyA3oSaFQm0Joz3kGXq8bcJC0GE69RZxHK?=
 =?us-ascii?Q?mZJhtXFPyU1dkfvZoqcMHpviOA6MrQV++XZE3nbNsDSyJCPSX3V8eNY92llV?=
 =?us-ascii?Q?6KfVmQWABikWcdsUs58NS3yHKP6He5crr4IG7ABOINvbygMgwiDA9LTXo9KO?=
 =?us-ascii?Q?kQQWgEylXyZoB+W5OywN6SVaDv1lsq+2zrtLp3IYMW8ahXjZNUuLqr6S2jyS?=
 =?us-ascii?Q?3cxNKuwMG+k/oUAMf+J0I5wljveClfw/kIG2W486dV4NvmQmyWsbh/1JUsA7?=
 =?us-ascii?Q?LWL+nlCvdI5V/eoC0exp2IekhqcJAQCQwvXA4WnL3/qAE0n6AU6r5yorQNvV?=
 =?us-ascii?Q?VfQrw5qKG8V35oA84VpV94Ka/wY/cP/ng8uRIbdVJST3lEYf8wpT4GDL2juk?=
 =?us-ascii?Q?8yxxicpTgmeBWL//t72qceQ5r5cHF11VGff2a5c3Hd8IeaBltzUh5px9SGhh?=
 =?us-ascii?Q?onC01hCEIJ86DJzTDHwqhONrQsqK1Kxhduigh6FXgG3JYdSycF0bvc3BBudA?=
 =?us-ascii?Q?Ebh4rLsXq8T+vMnWhLncYa5GbHps/qjTKRdcgHHoS6rSF90gKknAYxliyY0Q?=
 =?us-ascii?Q?0yXOjzdlYOaGSZzOevN4cSCw0w2S3zPEM0EOXihVBE2UckwW8JeUHoOdmapz?=
 =?us-ascii?Q?mRmV9wvTCvZupmgL2dPxX0RDIvJlbUtT7gmF8ypbTDdTb9WATwCUk7fLLobl?=
 =?us-ascii?Q?Gtmr/fst5DYjQpkAuUAm/ksNHI9ooIGp0Lz8YIwZDdnuKzLSWN9Hv7Tpx2kb?=
 =?us-ascii?Q?+pVKPL6aTuzi7GIK3XSBXoTJTKTIJ8f7kUJ55HZ3CRCGDo12oTWhCM8esNje?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61152be-7525-4fb6-a3c7-08da5e591055
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 07:36:24.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LcNOEGC5ieWOnZKSYIBrheYDoAawK9SU0oiOMu9VUK7oOMlzXn9i1ExABIIrpgVSE6Dzc8zz79Oa4zoFX/UpbjCbvQ1voZQw+0/bmEUwS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5312
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Packets with metadata prepended can be correctly handled in
firmware when TSO is enabled, now remove the error path and
related comments. Since there's no existing firmware that
uses prepended metadata, no need to add compatibility check
here.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 34fe179513bf..0b4f550aa39d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -56,17 +56,6 @@ nfp_nfdk_tx_tso(struct nfp_net_r_vector *r_vec, struct nfp_nfdk_tx_buf *txbuf,
 	segs = skb_shinfo(skb)->gso_segs;
 	mss = skb_shinfo(skb)->gso_size & NFDK_DESC_TX_MSS_MASK;
 
-	/* Note: TSO of the packet with metadata prepended to skb is not
-	 * supported yet, in which case l3/l4_offset and lso_hdrlen need
-	 * be correctly handled here.
-	 * Concern:
-	 * The driver doesn't have md_bytes easily available at this point.
-	 * The PCI.IN PD ME won't have md_bytes bytes to add to lso_hdrlen,
-	 * so it needs the full length there.  The app MEs might prefer
-	 * l3_offset and l4_offset relative to the start of packet data,
-	 * but could probably cope with it being relative to the CTM buf
-	 * data offset.
-	 */
 	txd.l3_offset = l3_offset;
 	txd.l4_offset = l4_offset;
 	txd.lso_meta_res = 0;
@@ -190,12 +179,6 @@ static int nfp_nfdk_prep_port_id(struct sk_buff *skb)
 	if (unlikely(md_dst->type != METADATA_HW_PORT_MUX))
 		return 0;
 
-	/* Note: Unsupported case when TSO a skb with metedata prepended.
-	 * See the comments in `nfp_nfdk_tx_tso` for details.
-	 */
-	if (unlikely(md_dst && skb_is_gso(skb)))
-		return -EOPNOTSUPP;
-
 	if (unlikely(skb_cow_head(skb, sizeof(md_dst->u.port_info.port_id))))
 		return -ENOMEM;
 
-- 
2.30.2

