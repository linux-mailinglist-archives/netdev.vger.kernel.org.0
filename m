Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77595605970
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiJTIOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiJTIOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:14:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E31B78C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:14:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYJg9S/pmrjXa1u3QBw4O+QHsgDN6rO5tDqj4t6Hn3imoCa1+U701lkqB+TS5xMXR2c/MLj91oevYKBBe5HIMfsfsQP6T+x1y3xGdahPmeox9J3i8Xf7Lt69tEJ/JqQFnS/3dloFgDOEkCAqPks5NN33MWtlacMboyPXaZReAR0frPm1lQI9azRQNSRj0tw59W8T13aEXo1WgMDtZNVs6wJ0u2YgJDPBHWpnxoOJ53r7Z9ev+lthcfXTETPZXBL84BX7cWonc1GnPtzUDW5ZZ7NBBNB6Z8xomAxuxwHXXgeN7YlG+TymYb0tyKL4jRkLKpFB7Bb0kZhcLcwSGpoRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjvl0RNKu49x0LJVRBSDjhuAzYEfQ6K3Rem5xrRjiFw=;
 b=BfN7kMrxfuPnYI78P+bgnoi2wxyFZ08B2KPIs80WxWgReNk3WLCqtV6bE4VMa90jTI5UQGwth3bYb4egdUXiIEZISzlYXXMlfqEQ9UaCOo7ztwf/IA0PDE1VVES51VNLGiTTR37PCHtY/O8Wdp+wO+13jpNiReY/tmq+kEXlj3g0p+mQrYuxdbMdxN/b0CliFxEB5+zPeY5kFS9TfujELJqEp6vBcnDnO9yFl3fFmUrHVHMENeYGGiWGXnfWq9n1KiKDnK0iJ3M7srSlg8DlvJOqxZyOJGCcjXolk0jOHn5+xrzLQucQQWIM1pSOHiiz2f1NiWL2LVloPx1/aL4l0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjvl0RNKu49x0LJVRBSDjhuAzYEfQ6K3Rem5xrRjiFw=;
 b=UocXhOjeFb0dMRaSEfV+YjuS7mIDMcnHumKM3Hibx6QQXAkbZ6HxzZavMGMnHE4LXZQlFrA04VnDNoQXcwiDw4QFZbghfe+wJ9zrj24c1U7ynbUyB021Jf4zzvmvQnAfXkV5c/TTcggbmMTnIA7lYiueSDuDnze9J0Sx7zR2Nq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4011.namprd13.prod.outlook.com (2603:10b6:303:2c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 08:14:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Thu, 20 Oct 2022
 08:14:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: only clean `sp_indiff` when application firmware is unloaded
Date:   Thu, 20 Oct 2022 09:14:11 +0100
Message-Id: <20221020081411.80186-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0026.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4011:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f57a2b-92bb-4b20-48cf-08dab273215b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OfIBhULPYhfbS3EB/q3rIugkLfOYy4KePPFlWQVT1Z42pDrzKoLGM+V+kqx25A8vu/mQ4jlTjgvW83QXEmmsY5iSkFfrP5JD/G6JE2ZM4ubeHBO3pQEbGa35FwSBJMh9ScAmgd6Bhe9ewS4qYqluFK6mwS4KLH7YjKEcJfHQnLpvRG9GCF+XD56VWS0PbRtZ85PCaG6RO+shtF0DnE6bZMPPsopRXsDV5QML+z/StfvRILtuJVDp7xiC/YUOFbSTqkb614HRnfg7zxAhI1XeZYZKY/r+mwQGg7zd5re2uAGk7qGxTnFbCpVIrRsBdcME4DmKDKbGN19Kqvooyp0OkxSY1VsgcxOm39ZHXbc8/UwSQvsP+HaO9wZXg0JEp0ZuGlpLy4XbMqtty56vgH6zmRGRHncdAabWXjSQBGLO3ZETkqEwUKEPOWG2ZamIkjK/MFBG7Dv1a/U0KqSW9+FLVOa/Bls1SELnaF2xqVySA51NwUYudo90L1vE7hpaDm1VU4+H4gdJntFVUToRsLjaj9AWAC1tLqNAQTKIddW1K70Ldyi+fIsjCY3jSojnzP8TGQ8Yp9ctUe2oyxHQ42f0KETwF2/I8i+idjFjYKBepBpyNssqk18St7Buerjgr0U94suyE8oXbXf8UhsUreTHVLPxGGpuoAVoTFGhw1o7WLsE5Q+xd0AKfgCSK7o8ZoT6Ctj/lUfOMxZTUcjDN7QIn8x4WdpK2tlNH6eDcRXi9x8rpBK6xZ43kbrhHK7/jZdOEWtGbDKURRFaBvttoJbiyZIqD+5DpDoJA4x3lYqq9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(136003)(366004)(376002)(396003)(346002)(451199015)(107886003)(36756003)(478600001)(6486002)(83380400001)(6666004)(86362001)(38100700002)(54906003)(2906002)(110136005)(44832011)(316002)(186003)(1076003)(2616005)(8936002)(41300700001)(52116002)(8676002)(6506007)(6512007)(66476007)(5660300002)(4326008)(66946007)(66556008)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pjW8Q8/MlzNMytUvsTrb8EuCplMKPQ/PsJJRBqrJb2uq7rJflMocX33y4Pf+?=
 =?us-ascii?Q?NrR/NHRW8gLPMe7UwhVHuJa3PxogHZWx6fBtPlQfW+k9E79fPag5u+EDQSc7?=
 =?us-ascii?Q?odNCQ40SjXi+370jwP9B8mHL1IYe3XpA9K4UDqSnvPTrSB0uDxCZXDX+Z4AW?=
 =?us-ascii?Q?Z8bBMnMc/s8ypYG4q+H7wgeJemb1L/SgE2bPPlWCuYERIOHND4s1QJQFN9SC?=
 =?us-ascii?Q?t7PkFx0D5s8xZC19ggTPxtsjsSRFUwi43qmSntlVx9twr06sLPsMBjauAE7h?=
 =?us-ascii?Q?a2RdYl9Ndahr3B1hbIQ0IpLZbh6Tbkxrcih5XzDdlmFLdMuJlyuBRo7RB/Sf?=
 =?us-ascii?Q?A0zQTMU8un7hpYBw6e0/LAd/hJB3Z38qf/fv5fFziCfpM0lDpuxrqaH5r195?=
 =?us-ascii?Q?5rKlxlM2/ItMTvpynYgyyXJIvmwWxRj6L90O0p0z55V171jFVgsZGwwKdwUb?=
 =?us-ascii?Q?PgRj91OnoDaNtfDuJfAd7NfMkyy3B/y/fZ/B+ud0+JUvBOxPefGZRl6z1+MQ?=
 =?us-ascii?Q?BJWL2chQzQzRJOXd4DegvEw5dbynOoqhKPDLvNAjrOnc0UhDiPPMycO1fQ6W?=
 =?us-ascii?Q?JvGHgoVjKtjjA1oMbO1Spn4HpMizudnufTPTcHCpSO9m5CGwkcngGO2FAdG7?=
 =?us-ascii?Q?J0g3YUdU/CjTV9Kc5HBfmxh9ALSyinGn+h6b9FYlPJbsrfZbUIAYH7+i0UIW?=
 =?us-ascii?Q?g2EFRg3hBjXVYXh3gPSalklP4mRn0CQut2bg6lODosFGxe3dp3ea1Ou1gHlP?=
 =?us-ascii?Q?MFKTZ7cyVRBNNtAUxzOMO977p8HYG+d46kso3fILqb6da0jS+8F0KPYXzy86?=
 =?us-ascii?Q?Cc6PqmtWBPDl2TXANzVhYA2kjJ7JtfERhZhUYXQ6mvULrMGoaCuwteTF8MH8?=
 =?us-ascii?Q?gZnw2wYdiKfnyBq18duC59J3hw0Av2yXTqsjFwrHgGgqrAjWfrtY4y94Lzzg?=
 =?us-ascii?Q?FkuYX+X1+ecrm66CQNdKZK6cwYWkOBGAkIo4siOociXiR0qhfPhh/tQZeoM2?=
 =?us-ascii?Q?DVcuSAzYu70M7NzDeoj8NDXPAPkq8SHqYgWRcyOfaRNAr98ZObBPZSfH5Qmd?=
 =?us-ascii?Q?5ticSyzUtYBe2lBLIvMNrmPnMXxgKXuzwFcRV4JJEdSyRF8UyqE5AdJrDbDX?=
 =?us-ascii?Q?IgI93oXdVo6WP7BywMaTXniHiqY18CQz2qOMViYHKh5iyXCySApQWzoSzaL6?=
 =?us-ascii?Q?pMPcyOnRCwFpMFyFo22R4A9/UtdjVqm01o8SNKlww4of7tMKwZdaoPgV6UQ5?=
 =?us-ascii?Q?So8Tahn0g6gW5KOKqSqchja0/dy6ze1nTmlmWB0UXXqZ0ogmicZ4xndHV7FX?=
 =?us-ascii?Q?4MO99W41jKMR6D/AIUKmnG2CzmvLFoTQ/mdRVHmKXd8qMo8F49F6+R4LXky5?=
 =?us-ascii?Q?gv7Jitap7Ze3nick14uiHr3c5K6JfZv98a6XZz6rUQJPSb9dgfYCt/cay0At?=
 =?us-ascii?Q?3vSOWGVLyI+UzXaifN++LdiPqfJ5uwK9tmTAMOPqbmhKrkqsFgrPYTI7sy4g?=
 =?us-ascii?Q?KGfrgvR0bBjgPoOKgC7Jpj7ousYZqRMcO+OSjfeh7LL5CpF89FDtT7HEJZf4?=
 =?us-ascii?Q?FIIF4hEiw2u3EEnBGK0iO0nUaUCMHniAAvRiCmzcno+440LeqrpYfZWm9ac3?=
 =?us-ascii?Q?D9bQ6dN1LUcP9ECvRZO+jNX6fyR3YBC0o/5iwcVjHeqxQgPFD7CrJpAzjWSH?=
 =?us-ascii?Q?HIAxmQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f57a2b-92bb-4b20-48cf-08dab273215b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 08:14:37.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1cXy7hr7rYDyM7SpXBr8IxD+IGB0rkeEaO0+AuCLesb65SMUjVU1mHCgs3QOrPs1MWqD8hBaSL8baVfAEhkHMBrUPY9A0lP/SgTIiFjuD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4011
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently `sp_indiff` is cleaned when driver is removed. This will
cause problem in multi-PF/multi-host case, considering one PF is
removed while another is still in use.

Since `sp_indiff` is the application firmware property, it should
only be cleaned when the firmware is unloaded. Now let management
firmware to clean it when necessary, driver only set it.

Fixes: b1e4f11e426d ("nfp: refine the ABI of getting `sp_indiff` info")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 38 ++++++++-----------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index e66e548919d4..71301dbd8fb5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -716,16 +716,26 @@ static u64 nfp_net_pf_get_app_cap(struct nfp_pf *pf)
 	return val;
 }
 
-static int nfp_pf_cfg_hwinfo(struct nfp_pf *pf, bool sp_indiff)
+static void nfp_pf_cfg_hwinfo(struct nfp_pf *pf)
 {
 	struct nfp_nsp *nsp;
 	char hwinfo[32];
+	bool sp_indiff;
 	int err;
 
 	nsp = nfp_nsp_open(pf->cpp);
 	if (IS_ERR(nsp))
-		return PTR_ERR(nsp);
+		return;
+
+	if (!nfp_nsp_has_hwinfo_set(nsp))
+		goto end;
 
+	sp_indiff = (nfp_net_pf_get_app_id(pf) == NFP_APP_FLOWER_NIC) ||
+		    (nfp_net_pf_get_app_cap(pf) & NFP_NET_APP_CAP_SP_INDIFF);
+
+	/* No need to clean `sp_indiff` in driver, management firmware
+	 * will do it when application firmware is unloaded.
+	 */
 	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
 	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
 	/* Not a fatal error, no need to return error to stop driver from loading */
@@ -739,21 +749,8 @@ static int nfp_pf_cfg_hwinfo(struct nfp_pf *pf, bool sp_indiff)
 		pf->eth_tbl = __nfp_eth_read_ports(pf->cpp, nsp);
 	}
 
+end:
 	nfp_nsp_close(nsp);
-	return 0;
-}
-
-static int nfp_pf_nsp_cfg(struct nfp_pf *pf)
-{
-	bool sp_indiff = (nfp_net_pf_get_app_id(pf) == NFP_APP_FLOWER_NIC) ||
-			 (nfp_net_pf_get_app_cap(pf) & NFP_NET_APP_CAP_SP_INDIFF);
-
-	return nfp_pf_cfg_hwinfo(pf, sp_indiff);
-}
-
-static void nfp_pf_nsp_clean(struct nfp_pf *pf)
-{
-	nfp_pf_cfg_hwinfo(pf, false);
 }
 
 static int nfp_pci_probe(struct pci_dev *pdev,
@@ -856,13 +853,11 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 		goto err_fw_unload;
 	}
 
-	err = nfp_pf_nsp_cfg(pf);
-	if (err)
-		goto err_fw_unload;
+	nfp_pf_cfg_hwinfo(pf);
 
 	err = nfp_net_pci_probe(pf);
 	if (err)
-		goto err_nsp_clean;
+		goto err_fw_unload;
 
 	err = nfp_hwmon_register(pf);
 	if (err) {
@@ -874,8 +869,6 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 
 err_net_remove:
 	nfp_net_pci_remove(pf);
-err_nsp_clean:
-	nfp_pf_nsp_clean(pf);
 err_fw_unload:
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
@@ -915,7 +908,6 @@ static void __nfp_pci_shutdown(struct pci_dev *pdev, bool unload_fw)
 
 	nfp_net_pci_remove(pf);
 
-	nfp_pf_nsp_clean(pf);
 	vfree(pf->dumpspec);
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
-- 
2.30.2

