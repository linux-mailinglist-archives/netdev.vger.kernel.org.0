Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9D6BB072
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjCOMSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjCOMSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:18:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2096.outbound.protection.outlook.com [40.107.244.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75CA9008B;
        Wed, 15 Mar 2023 05:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8kn04dtUYaTg4vKP+jJkFjgVyDKC3RJ3yRdNwwcdA6sqLM/VDOVlWWPdlHsgp9l9gH9NBjruUJ8APupocnNrIpToC4DWlUQyueMgCaVvdTvcMr8cEETxNQ9A7NRHdCK9zhuUPueCNTkmKqOXOns/QmvxAiBM9IW+SZAM3M0rm9jd1EXMi8KIuIy7optiJgLrB3Twl/Ub8FDTLA5q43S4lLEZ6fKGeID4LSJCLYBS5KaRsiEUQaSEaBhmLl2CNk2A6AgbZlL4Hr0EbjOTLYcV/4APdhxzNfF+bhedlsEh7mmO921GqOfi0lDBHftNK4W/4wtdzkz8JfV29mBHrwWdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwWf2m2Fi0aDWdY8vTcehyyeVS93asX3b9O3/tGndz8=;
 b=Dh9kF3QSqygkWgmcDF5CRSBMcvfYeE99dqMQgU3oMJ3ViALx9Zc47KSNiE0J22UZiIf5gTcaiGafmi96Gj/PZ7SGrQkC7NA0X85FcA/OzvhAAFI937Cd/HHw7LGiL0MFV1FjEpGTqqlPtJlXHMm+XPNb7pp7WPVmLx8zLwUzxYTDp5bQ++QkIRVwGOZ4RdkjqlVX+hELjL4oHGVNV63Kc/cewinHYvfcckcZc9SsF8ZkMLTcR1yMOnAtS4Y30BZmSE4+hdTIPAWoJMY7kWLcGCOzTwigByYYLxUM4CC4gLy+OGt/7XBKCmGmA5uCHHp4ul384U912sB3O0YQPZin0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwWf2m2Fi0aDWdY8vTcehyyeVS93asX3b9O3/tGndz8=;
 b=Cns4+RVwxK6Q1kTQQuNasMBRfGZZ3l4AZPPWEvdROWi/82q3roiHykFv3ek5UPexunH/g4NahmqjyRPlrchMCiL4qQ0AqATXFP9ZOKcqce1Ulrin6dfmsi/R7k207K/aXkq6LzxLa91KRDO+YJjDHLYJoQSljmFmvSkSKmcSuDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB3986.namprd13.prod.outlook.com (2603:10b6:5:28f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 12:17:58 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 12:17:58 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net 1/1] nfp: correct number of MSI vectors requests returned
Date:   Wed, 15 Mar 2023 14:17:33 +0200
Message-Id: <20230315121733.27783-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0100.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::15) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|DM6PR13MB3986:EE_
X-MS-Office365-Filtering-Correlation-Id: 7710be0a-76fe-4b2a-8ca0-08db254f4fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JiDzinS6XIl8hN1kQpWaVo8QAaewIvhB+zMMHFqpVZpPQlS9+L0OBA25zSTfnKtTTWVopHS5s0WylDbvAyoNu9cCIS7C5UnsCfSIW2IdvxuVnmMHHzGsyZniCpe4svGHgo16Bw53LEOAZeOTgBCRRaz8r/ka+GL+/0TH5QQt6xhCZRr5SZnOpNF8iREJDxaddeNi16QELirS/HB5ANwjIZesxJ90MmQCQUamITAvVlJPS7GhbaP1CDVS6Kasi8c3sfpmNcFxSzN5YxZGIWWcWEcMV60iSgDmQBoRc+mNkEiZ10q30bONvKrw/9hPgfuTV/qFQAP4/W7C5ipVwoLOIE4jE6MNqPXDxnza7Ua7Y4GjhNIsvha5sRNa37j5l0seG6ukL8FTOcNWVbi5AxqNlO1V6JH68o5k1rYpJfIPbzsPNsTc45zL9EEkPgfw96TTCuHUadYeB3LgT63YSa6nxIyWQG2hLUSLBUJ8s0kh7lrJpIlb6l3vcxNUnIzj/XCOuHpJzd8yuuHZrVSXz2KRvB6fbu+hZC+02d6u9NfIkyRHB4Mm3FcPxToPVjipLm+hQL7UWZBUQTe7/2iRjJg4I07UJSJBLIKCZNgAgAujvAW0jnKPmjoLm1RN6kTqyG+Cb9/JYFxN7laivFu0D1pNPsmHGFp23gIu9ecljghjb1coT7bDI1q4zRuHOf/4BtTJWbe8igXAFxe93rXO5uLkYIT/m3wrVy4EeOnhhBYi5omH0Fa2ECycLRGfEUp+uZM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(366004)(136003)(346002)(396003)(451199018)(44832011)(5660300002)(110136005)(83380400001)(36756003)(52116002)(6666004)(6486002)(6512007)(107886003)(1076003)(26005)(6506007)(2616005)(478600001)(66556008)(4326008)(86362001)(38350700002)(8676002)(8936002)(66946007)(66476007)(41300700001)(316002)(186003)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?47KoVVOxj7ir2NkJOKHXRfSdb+l9KGAg0jtG02yLnOZEVRWoJ7s1KepoCQBD?=
 =?us-ascii?Q?J9ykyqjebE3xboT2oUYPwDUwzS6pmpBLxjlMj9aQC21+c38gY9kdrneF9Utc?=
 =?us-ascii?Q?wlJXiZMCLjZnZ15WaaMpTMHLrvO8+aYWsXLIQh+YelpiROwEsO96dK5c+WK/?=
 =?us-ascii?Q?7DQCAusrYhFNpXI91Wi/QbbhgGhUEi3nulTdtZfjZRajcg0ZE39+eZgG3f4i?=
 =?us-ascii?Q?sqSuqg4ew8oNuGfYKripwT6VjYVGGHCCVQidw6jz4UF54yEeLNmB8OsHCWBL?=
 =?us-ascii?Q?Gl1FOChh7p+UuF6+ReFVmRyfQt2dpOLE8WIm/spXomE2M1bRfYuHE8Uf5Ncy?=
 =?us-ascii?Q?mn7B3FoZyQ9CsckVvz32RdhFg84egB+W9vyCuno4+TGcp0hiCB+zgTzO6sM0?=
 =?us-ascii?Q?qwtFbedB1OnfdO1SRa0epaH0N8imnSpY6sRjRQhVKKu5QWXCWxmSujrlRqOF?=
 =?us-ascii?Q?EExGKxbZoZdYMernuq1KLCZaBhMXAS1vCZBPMJrZc7XHTBdENee8AD/84A5z?=
 =?us-ascii?Q?yjQLdRMWHj6E7XmXpCWIadhLPNnkL8gxnp5Tg1ZQ25I8BnOpZGLK2AzKVRK/?=
 =?us-ascii?Q?06OOT9gIkelKBzEg4iXXRnapGXdyx1NwvTtFShshdkva6gLa6jhNfuM+vrOc?=
 =?us-ascii?Q?1RNzXNJYQ8uqm6nd56zVsCsSL/nW8h7dfK6jB7b7m+ZP1jeweerjiszk0dxr?=
 =?us-ascii?Q?NDdPVp20LV4rmVH0EctpFFHAf3FijtLlAooaWuSEABfTebKSgEY8Op7KmH0j?=
 =?us-ascii?Q?9a5Dko/C6chk9m+y9h1EfGsOGwrutyadfz0iwUD4fU+Atm2Qvk0NVK0DjKap?=
 =?us-ascii?Q?A6pRttqn9YBuoO2wtmuy8cwd1qw2w2jrFxT0xhtcmwMk2xGMUiDpmmbFldvk?=
 =?us-ascii?Q?JwO1u++++ZQTggqIQ9w0ZfV+MaEwa2i/MN+XtTR3DGkfmgzDVD/7/6jcEaYD?=
 =?us-ascii?Q?SiySkSgrcE9OJwr5Qgz3ZWX1ChuaV0fml9of5lThf6PDxEPu1KQKCDsUNZre?=
 =?us-ascii?Q?fK75L5Qm2DauaVKmmnarNLW97mr9/XY7J5I/pb9sd3ifcSN2ccAWUy8i7B7s?=
 =?us-ascii?Q?K7gG8hiHRnezUm8Hgppj2HPOTKabVz3S9iGFM362RZCrtGnbjzcSlYwbNMrr?=
 =?us-ascii?Q?IGYIlsfa2KAEEn4InPsdaeNqSggpKrA57CAXPZr2LWpVgesnut/tpyeVcP6b?=
 =?us-ascii?Q?58ADqJFLs/lSqpI+d2NcvuS5xexKMS9urBiItGSN5+s/cTy2tb9voV5Y3BoH?=
 =?us-ascii?Q?yK1PD9o1REN9535bV/7Hc8UAiaKFpySgHp4wu5hg62kfhZ983WnWz1NNuP/5?=
 =?us-ascii?Q?f6GhAS/wwh0c6MUp+y8LNxW+dt3JdmxlCqyHR1iTbHg65XE/gWM/UjxTlXRF?=
 =?us-ascii?Q?tqFDbaC98tdw491h45Ak4viKVxIZCQtpTx3Ukfnk1Iod07+bDFh1Yganknmc?=
 =?us-ascii?Q?r/wP6BE9XilPx9RO6xbAwfEMUZgDoqrlOSP8h2seePfBBocY0T8a6jid7W75?=
 =?us-ascii?Q?SdLY3vd8R6dMRhLRdqA71aTQTqGNFRqCYgfjrypXC059uKq8+3xS0Xk9XBri?=
 =?us-ascii?Q?4e9CiSIDRiNj84ZMUmEy5k/BEc4v59kTjXPv6kLUeNclgE9jU/roKYc01YWk?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7710be0a-76fe-4b2a-8ca0-08db254f4fe4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:17:57.9360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enbxfvhXqBTPOZXpH1acD4tWIFH+y00amAgVXd/LrIszpyaKli8SBELzWL2xb+yFb+0j+rdlNy+RzBBMlrECW7xssjIH/n2gGTWVbg0yBbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3986
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoyu Li <xiaoyu.li@corigine.com>

Before the referenced commit, when we requested a
certain number of interrupts, if we could not meet
the requirements, the number of interrupts supported
by the hardware would be returned. But after the
referenced commit, if the hardware failed to meet
the requirements, the error of invalid argument
would be directly returned, which caused a regression
in the nfp driver preventing probing to complete.

Fixes: bab65e48cb06 ("PCI/MSI: Sanitize MSI-X checks")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyu Li <xiaoyu.li@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 62f0bf91d1e1..0e4cab38f075 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -370,6 +370,12 @@ nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
 {
 	unsigned int i;
 	int got_irqs;
+	int max_irqs;
+
+	max_irqs = pci_msix_vec_count(pdev);
+	if (max_irqs < 0)
+		return max_irqs;
+	wanted_irqs = min_t(unsigned int, max_irqs, wanted_irqs);
 
 	for (i = 0; i < wanted_irqs; i++)
 		irq_entries[i].entry = i;
-- 
2.34.1

