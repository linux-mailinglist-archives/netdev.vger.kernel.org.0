Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6666B0888
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjCHNV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjCHNVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:21:38 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C0C9C26
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 05:17:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esmF4rZu7CRwlzZhQqi+2EfSDv5Z2K2JZJKAaA2/otLp1Zj5LOpuVNGR0w8y3Lw6nicJFa/JDRS1/u9hkqdOGC+cRpnBmY/YedBqI76aQNOQR22LQRzLjSSPIywFAQb07W7+bxIz53HWBOaw62rM88zR/0apq0XYUNV/6OgVy/TjQ2cjXHXzrJQIcTJCbk6Q5OY8abcFQ5zUhnfGPtBKKg2mKNpNcngmTxymaYaFL4qeyHsimKNyXavP1imtunbMpDth9hSbXN+MUDK4Tq+WG2p169ugvh1dWf94mmS4Di0BQffGJ+9htzmL6Z1CWRiNyED4mVjrY0Sdcr25Y2F28Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzFKz2TmUtecj3TKnqfrZTFTTVLYV08oOd15e/FcDpg=;
 b=a8vIvUhovHPWBSJerPX1tr8qOEfYuPDLcU6Bb5ijXJBcwJoShdO2mLAKnaRr+3f+9s63POi3augxD+85FOW6awyZzbIBTmFun9rpyslAy/M405lPzIJpYeTYs9AnHVKyjibq+MdXnQ6/IEwpzxxPBpan+ReQRBeaVShrOf6v1NNUJDwRXo8A2lVHhY7eIF38pRhbndiD1hsmL4q54BFvdvFa/8VOXL+PY2ER4G0oqllB27KG8DlkXIz4enB51qLMphSS03JxnVXLbKLWZAscgUpeEcE3DcT5M0Mcjz3fi9q68Vk6jN+E6vVWzk7rXpQrlsfUOce0S/p5CnikfqecGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzFKz2TmUtecj3TKnqfrZTFTTVLYV08oOd15e/FcDpg=;
 b=hxMj2grTL/rGsXn1XuCK2eTh0neHCR/x6de1rN476bQquxHy+tcduXbDGrTkx/aiiKmgFNwUEvN6O/Lj9AjRrg8XwIneDul+kQYitw0YUXRbefNul3S21uqONB3L+R6MJjJ2TvYWh4u7clFENygKdkYfI6ZIgx25xIdfUZcvo7sXGvJptSWLpJm+eFCzzYJpttn5HlO9f7MvG1vV84wjpoAKuRQm1cD3PcBSiHq8B2PoJ/0J9FkTrTIDUIiBipdBuD1GuwO5RnunzQPTvznnn4CxP2fbEHaRI14e7KeHSs4BCmWXh80js8k3V3urM2yFC0ioDP9oYKfB31U1IqKrjQ==
Received: from CY5PR15CA0040.namprd15.prod.outlook.com (2603:10b6:930:1b::35)
 by DM4PR12MB5986.namprd12.prod.outlook.com (2603:10b6:8:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 13:17:19 +0000
Received: from CY4PEPF0000C981.namprd02.prod.outlook.com
 (2603:10b6:930:1b:cafe::ac) by CY5PR15CA0040.outlook.office365.com
 (2603:10b6:930:1b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 13:17:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000C981.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Wed, 8 Mar 2023 13:17:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 8 Mar 2023
 05:17:07 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 8 Mar 2023 05:17:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Wed, 8 Mar 2023 05:17:05 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>
Subject: [PATCH net-next v2 2/2] skbuff: Add likely to skb pointer in build_skb()
Date:   Wed, 8 Mar 2023 15:17:20 +0200
Message-ID: <20230308131720.2103611-3-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230308131720.2103611-1-gal@nvidia.com>
References: <20230308131720.2103611-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C981:EE_|DM4PR12MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff1cce6-0cba-4670-8b66-08db1fd7720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: McKCp2nKFRUqcucbHc1qCRV8cDmQ2gJ2CM2mLUl8IZbDVinXmcYVl5SjwAZoSdC9UkuVnYITNj4IxzNMxFLiJSCQalZq+37wluH7vJtP+w81QhajUGD7rUUVC4eEF3+1wcqS6ALQtJmsJ+Onom2pZQjU87dd8M3eXygW+jgCPyhTagH4RjaWKA4Qv/fxXMb8RkKtXQ0ubfYHYYFwVdh7u0Qa/h2g/fXJvGyN+2dwc1jsoAWL0SZcuj4dIFw6Fz33BA5mQxcGaLZ/RehnyQJ3TKnA3/1q7k+eBfkPmILvBFnxadLhcoyS6k/XSY10XY/tcJF1C1y4/USQvTuUNYP3wSO3+O7ZBBmGMoWELIS6NUGhJ1Jbcenzy3x0SVObZY9q/zcRiluOyxyWkDTq57zACrF1FxLdFR5a5nDg2RNK5XinpKiB/mymMHNhKhWckDDMufEz/CO5aMkN4QThZEazprqIi/qag+ORANDEi3dulQq2Ah6FtN96LvOw2spnC0zXsDzTFlBTuQfUBTTcaCQruUzHUmN0mWO/j3zNZkDKwCSql7Gl4xW7qF8BbfKBsJaN/oKDcikSjQn/tT0InicbTWM+7ZfyxTCTi6sCphyAvsn37FDC/tsqsux/M54zq6dgqe0RMBuofjgbmIBYZwLwSxwxynzqLzk+5DoKHP8cE8qBslmnbIKC7tJvwEMwDbC3anDHT8DWt8pWZGMliTlztA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(70206006)(40480700001)(36756003)(4326008)(8936002)(70586007)(8676002)(4744005)(41300700001)(2906002)(5660300002)(86362001)(82740400003)(7636003)(36860700001)(6666004)(7696005)(356005)(26005)(1076003)(316002)(54906003)(478600001)(110136005)(82310400005)(83380400001)(426003)(47076005)(40460700003)(336012)(2616005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:17:19.4014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff1cce6-0cba-4670-8b66-08db1fd7720f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C981.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5986
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to napi_build_skb(), it is likely the skb allocation in
build_skb() succeeded. frag_size != 0 is also likely, as stated in
__build_skb_around().

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5c1a65cc2f39..34df1aa0584b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -420,7 +420,7 @@ struct sk_buff *build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb = __build_skb(data, frag_size);
 
-	if (skb && frag_size) {
+	if (likely(skb && frag_size)) {
 		skb->head_frag = 1;
 		skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
 	}
-- 
2.39.1

