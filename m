Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAEA5EF114
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbiI2I7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiI2I7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:59:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20285139412
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nhgc7Msdwmx632gLaiqjtboPTL79xxeAWp3BtItiZu5Ifmg48+XWl9/hbN979P7KbwCXxREqkKa0OfpfDB3LG4XCaQVZiMlQYojHWSLLxcJatcrlZjpoctirc9W44yFkOGi5CfOZDA1QrCL1+JzxGDj6POmw2rLdf5VpPhzzkE4gt1jq9BbPEnKi16MO/XG/91fjpOSU8VU5yQ8Tje+SXT6kCjBJtWE5l2j2aTfJQVSf3wBTd13Q/gl9VMNC1JjC6LUiRMLJGmBDWfphYN6g9EAhTTpfA+QkQNEQppJ6khTzdLOZd3Y9yRTLDf6IHsB8ri5ZE6+CWoPManCKAX8NrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPtGEevOg5TRtFqRfqds3SO1WWWczzqbyGmoybeBxgE=;
 b=gIX3UHsXn8QVaWUtX7Xiz6O4cvr69MvMdgYr4FldxgB1Mv7rpKxwXljXpo2qjUAHlAjoYqG9quJxLQ0l8O02JmxCIQ+iyX6SumXzAg/lbq9/Z8GKFRlUiUIEaKl27wOGEk8UVBZnpeN/yFs2a9GoKtivUNEW8dpwvN3yy1ncPe9WNZbxDMkXQEswxXjEHlLVnvoTD0s6B9KPXg5K7zkHfM+RHuKLERJkeUOMkHP0AyawxD1kZnX/ANwxJRY1FlmlbtmtfK4GNqQq1HCut4QHjOhnIHjCblNHCkNLFgH7x9SEzXHl7gVSXJUsgJLZ889GhAocuyxkm5CcV2UjZ7DM6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPtGEevOg5TRtFqRfqds3SO1WWWczzqbyGmoybeBxgE=;
 b=GBzm4FFm3+/cpxDAjq6zd7EkCW4Zjtg0oN1/HldzFsVE+bg719ludjWPiwU7phUA5pFkc0xdc6G6h5/Otf7vzNcArFzA/VJ266flGAIusQvO/IpZ8Ocuh08fXxuYu+e+i9oOlwPPVLJpMLyGEuOec3yBiNmT0sAkD8KLEgCjmCg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:58:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:58:57 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 3/5] nfp: refine the ABI of getting `sp_indiff` info
Date:   Thu, 29 Sep 2022 10:58:30 +0200
Message-Id: <20220929085832.622510-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ae2270-0380-405a-8681-08daa1f8d81a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ne7FTCJvnaGX05FEd9mbtSXK07y5t/2c9iJicVuv8HNi0a0BCX8g5b4z7eP/g4Wh6yNe+qMICiwf3UWtunE775GM0LQQQ6NmnVJ4IVw1WC8FgTxZRONrb01dSk9Wwkg9qO3RrLID1PM7X/z8bBoC52ny+v0fLJojkZ6pSMNWtQBOHibDkxTP/NeKFnXC84Gb1oF4rNwvlU6cfu96iqMwQn5IKf8kBRWJr+C0nXz1I0wkgWqlcGrkmzY2Nq8/82VXbQMVqXRNaWRA4zoav+t/svc50uKvzpZ9GwkBJozGBLLRs59no59p6MFvnwG36+wygc0dZkq8gqe6DObVAqrRFr1TTJdATsibDWjQsRKFLZuJZ376p30q/eRT0OwcXC3PuTfP2PMD0pHM6etoxCv2znEA5ZVGS8DHO42yG8sfjZP1SKIbIyk44GoFvfrBxC6mJ1B6qesZjK0U2mU6jxQgG3v7MaIY0US62QkThUy2E09jYs9R4u2/7sr36aDVS4R2GzYePK6XquZJJWoN68VZJN5hiJjEPgvSOKVx+Q/VyXPw4eEbj8DERiqSV7NgKjOvJTmMy0VS1BDthNqmdjJBl98F0cHCJ3GHy98msi2vztpR2BDrizBBOZpnwGTkeXQhj+L1f04kxev5haDtGwdkHtxXQA/W1hoCpbcXmB7W/VYIxts15FvQ8O4TKMKFXv1T7xfz4eoycnYv7ne/7iVz7aLM5PNSvwD80qwAnMrOPABUAgBPrLSosD3u4MYlGB2qXhtGebgZEEbBQMhFkiUyhSqp57oLlPKVt0tsyEo7AUAAcOESO0jY0uCWt1HYvMhY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(83380400001)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wu+fMbASAFEVHKkDs+nUlvPExDQceaX4+LYn5BHnB/zP1Pxjj3krQipxjVAK?=
 =?us-ascii?Q?8mOatIjvvHlbcAwpJ7HW1t8PqIcbXrNMCfU44pgEPbNWT1Eo3VL1AoXvOGJ6?=
 =?us-ascii?Q?85tl3EK8qAW3+7q/F1icim2GJoU6POAPE5xLJteK531IJItKLstxO5/RROX6?=
 =?us-ascii?Q?OUqtWCT4+2tdowGc8JSvHU+hCH+UJvRZq/uAFi3PKGlIqp0xcn2d/d0IGwLa?=
 =?us-ascii?Q?gO1hZyjIKFZfobmOEHCfFo77+XN+SZu+/okmsZoC/xXVbLp0fj2LzfXj3COI?=
 =?us-ascii?Q?/TfP+3NE1abK14BMht5LzJYa2j3doQwE0l+DPXOqJkubZmwwk6dlUv31S+pZ?=
 =?us-ascii?Q?DaDaxwfPSulD4OhndXJbNpHhtOtt8DqG3fWrFSs9zpbv4ZdCKexJLxkzOzrl?=
 =?us-ascii?Q?klwNOOIgTz/Il87F4nc5NfM7NVS5AVEvPHZHnHIuLlAn1Mk9bDkTI5IQvWe5?=
 =?us-ascii?Q?iLohC3ojvBdVYtVsJwqyu98N758gZQCw90q5lE1d6JCunOtyJgzAwhHeNziC?=
 =?us-ascii?Q?eC2HkjTRWap2pHXWULUwq4Fn7dpf2mmUEEf/qOp0tCgm38om14x8vNgObko4?=
 =?us-ascii?Q?jqyh84/kIECqRmXWDIwV7K4BKcSqYwVguhyGPVsXIQMNHhJOe1YXugvdKr7M?=
 =?us-ascii?Q?wNHuXehQtFFp6uweDqDnhsdK1r5FqdrOKmBr9JUq/vOtvOpVrKdb7/1WxYV7?=
 =?us-ascii?Q?L1YMaQkA0/UiZXWzZUCkSec62QY/z5xHNoYfoPwojvRlNDfREf+E2qWxp3QH?=
 =?us-ascii?Q?HEEaFjpf2KsY3/5x5VVRL8Sw+4b6xxMN4NaptYSeqOaHRtfvSBbXf4OcG49I?=
 =?us-ascii?Q?IBgF5MWsEd58lB1ayBunPm647ArmQruxPm8qVazyj5csCW2rCO90gzEMQcV6?=
 =?us-ascii?Q?oIDUOxQCxoP8NqtXdaZ+KdF4/sbiio7yrk9ZXWR9vp5t+Kl1DS7G9nh9jDWR?=
 =?us-ascii?Q?KFs70Rt6BV+c14drw5GtVkotEYhlnVx0SR6owx1URsmeQ9SfbSp/5nGjMXKC?=
 =?us-ascii?Q?/kBJqjAY7koKwroYWltKuuccyu5eRw8NmpvLssTwGuPVz/sbzVrHt9mYLQXE?=
 =?us-ascii?Q?3cy2/i174GJo/XuIv3NcEDv2M34+EQY37mhE6vOcX+1B0WlZJeIXp3hmpVoS?=
 =?us-ascii?Q?TBlTNu3UbamLtDErlF0LCF5ylNLYfBRcpyTJRswv6FFiPRvSnzNBJyagOthu?=
 =?us-ascii?Q?M17otZr2qHryNhKFk7JevS4Zo84lxEZz9epwWCOc5wDTpLHwUrtLIHdNhUvI?=
 =?us-ascii?Q?d09D3ooCQ6/FybxpHdMoqdNRDQnF+UmYRI0StIlZ0Tpj58D9lUki6qlsgx4+?=
 =?us-ascii?Q?NbFf/nhXVwn+ujE4XZ2b5UVUqRptyPZI0SBZamUGxR5iYDX0kvSYhgkcEXqG?=
 =?us-ascii?Q?DPSSF0rHQzMnWNRgf6JBnEr/OwXvsfECNzkhS3RcirXwVl3V9jwkY3BVigdq?=
 =?us-ascii?Q?Smh/pLFCY6MrRW9OpGl4mQ/eXIqWYL1mPcIruNrPGk+TaS+WxK50VusyUinb?=
 =?us-ascii?Q?uBrfcHuA8NP5hByxA57lX/dyMyDlghHJLsJ4uxqGfjsiTXZ3K34VuuDT5x96?=
 =?us-ascii?Q?rtnset6I2EQi80neDGbvmeACDyYIInM651i0pff1YSdGWIiyBDOiZwUbBuyw?=
 =?us-ascii?Q?766kf9MrcomF3CPLDSuQ4uEN3VhVhg6q5LfJuIeno7NasRm1PC+VFQy4taOM?=
 =?us-ascii?Q?+VV42A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ae2270-0380-405a-8681-08daa1f8d81a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:58:57.7174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd4QGXR/hhLbxy8YhXxHKvTj8Nd5lJSEDWu3fJDSvY0KTAeNnPYyyb/6in3PnbN4/7xoQkyNR7EQlhUvM6ZLJ5BjYmBtUuFExcWfuaf0XEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Considering that whether application firmware is indifferent to
port speed is a firmware property instead of port property, now use
a new rtsym to get the property instead of parsing per-port tlv caps.
With this change, relevant code is moved to `nfp_main` layer.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 67 ++++++++++++++++++-
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  3 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |  8 ---
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 10 +--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 48 +------------
 5 files changed, 71 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 873429f7a6da..91063f19c97d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -691,6 +691,64 @@ static int nfp_pf_find_rtsyms(struct nfp_pf *pf)
 	return 0;
 }
 
+int nfp_net_pf_get_app_id(struct nfp_pf *pf)
+{
+	return nfp_pf_rtsym_read_optional(pf, "_pf%u_net_app_id",
+					  NFP_APP_CORE_NIC);
+}
+
+static u64 nfp_net_pf_get_app_cap(struct nfp_pf *pf)
+{
+	char name[32];
+	int err = 0;
+	u64 val;
+
+	snprintf(name, sizeof(name), "_pf%u_net_app_cap", nfp_cppcore_pcie_unit(pf->cpp));
+
+	val = nfp_rtsym_read_le(pf->rtbl, name, &err);
+	if (err) {
+		if (err != -ENOENT)
+			nfp_err(pf->cpp, "Unable to read symbol %s\n", name);
+
+		return 0;
+	}
+
+	return val;
+}
+
+static int nfp_pf_cfg_hwinfo(struct nfp_pf *pf, bool sp_indiff)
+{
+	struct nfp_nsp *nsp;
+	char hwinfo[32];
+	int err;
+
+	nsp = nfp_nsp_open(pf->cpp);
+	if (IS_ERR(nsp))
+		return PTR_ERR(nsp);
+
+	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
+	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
+	/* Not a fatal error, no need to return error to stop driver from loading */
+	if (err)
+		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
+
+	nfp_nsp_close(nsp);
+	return 0;
+}
+
+static int nfp_pf_nsp_cfg(struct nfp_pf *pf)
+{
+	bool sp_indiff = (nfp_net_pf_get_app_id(pf) == NFP_APP_FLOWER_NIC) ||
+			 (nfp_net_pf_get_app_cap(pf) & NFP_NET_APP_CAP_SP_INDIFF);
+
+	return nfp_pf_cfg_hwinfo(pf, sp_indiff);
+}
+
+static void nfp_pf_nsp_clean(struct nfp_pf *pf)
+{
+	nfp_pf_cfg_hwinfo(pf, false);
+}
+
 static int nfp_pci_probe(struct pci_dev *pdev,
 			 const struct pci_device_id *pci_id)
 {
@@ -791,10 +849,14 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 		goto err_fw_unload;
 	}
 
-	err = nfp_net_pci_probe(pf);
+	err = nfp_pf_nsp_cfg(pf);
 	if (err)
 		goto err_fw_unload;
 
+	err = nfp_net_pci_probe(pf);
+	if (err)
+		goto err_nsp_clean;
+
 	err = nfp_hwmon_register(pf);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register hwmon info\n");
@@ -805,6 +867,8 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 
 err_net_remove:
 	nfp_net_pci_remove(pf);
+err_nsp_clean:
+	nfp_pf_nsp_clean(pf);
 err_fw_unload:
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
@@ -844,6 +908,7 @@ static void __nfp_pci_shutdown(struct pci_dev *pdev, bool unload_fw)
 
 	nfp_net_pci_remove(pf);
 
+	nfp_pf_nsp_clean(pf);
 	vfree(pf->dumpspec);
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 6805af186f1b..afd3edfa2428 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -65,7 +65,6 @@ struct nfp_dumpspec {
  * @num_vfs:		Number of SR-IOV VFs enabled
  * @fw_loaded:		Is the firmware loaded?
  * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
- * @sp_indiff:		Is the firmware indifferent to physical port speed?
  * @ctrl_vnic:		Pointer to the control vNIC if available
  * @mip:		MIP handle
  * @rtbl:		RTsym table
@@ -115,7 +114,6 @@ struct nfp_pf {
 
 	bool fw_loaded;
 	bool unload_fw_on_remove;
-	bool sp_indiff;
 
 	struct nfp_net *ctrl_vnic;
 
@@ -163,6 +161,7 @@ bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
 
 int nfp_pf_rtsym_read_optional(struct nfp_pf *pf, const char *format,
 			       unsigned int default_val);
+int nfp_net_pf_get_app_id(struct nfp_pf *pf);
 u8 __iomem *
 nfp_pf_map_rtsym(struct nfp_pf *pf, const char *name, const char *sym_fmt,
 		 unsigned int min_size, struct nfp_cpp_area **area);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index d81bd8697047..c3a763134e79 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -148,14 +148,6 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 							  true))
 				return -EINVAL;
 			break;
-		case NFP_NET_CFG_TLV_TYPE_SP_INDIFF:
-			if (length) {
-				dev_err(dev, "Unexpected len of SP_INDIFF TLV:%u\n", length);
-				return -EINVAL;
-			}
-
-			caps->sp_indiff = true;
-			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 1d53f721a1c8..6714d5e8fdab 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -14,6 +14,9 @@
 
 #include <linux/types.h>
 
+/* 64-bit per app capabilities */
+#define NFP_NET_APP_CAP_SP_INDIFF	BIT_ULL(0) /* indifferent to port speed */
+
 /* Configuration BAR size.
  *
  * The configuration BAR is 8K in size, but due to
@@ -492,10 +495,6 @@
  * %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN:
  * Same as %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS, but crypto TLS does stream scan
  * RX sync, rather than kernel-assisted sync.
- *
- * %NFP_NET_CFG_TLV_TYPE_SP_INDIFF:
- * Empty, indicate the firmware is indifferent to port speed. Then no need to
- * reload driver and firmware when port speed is changed.
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -509,7 +508,6 @@
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS		11 /* see crypto/fw.h */
 #define NFP_NET_CFG_TLV_TYPE_VNIC_STATS		12
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN	13
-#define NFP_NET_CFG_TLV_TYPE_SP_INDIFF		14
 
 struct device;
 
@@ -524,7 +522,6 @@ struct device;
  * @vnic_stats_off:	offset of vNIC stats area
  * @vnic_stats_cnt:	number of vNIC stats
  * @tls_resync_ss:	TLS resync will be performed via stream scan
- * @sp_indiff:		Firmware is indifferent to port speed
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
@@ -537,7 +534,6 @@ struct nfp_net_tlv_caps {
 	unsigned int vnic_stats_off;
 	unsigned int vnic_stats_cnt;
 	unsigned int tls_resync_ss:1;
-	unsigned int sp_indiff:1;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index f3852ba8099a..3bae92dc899e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -77,12 +77,6 @@ static int nfp_net_pf_get_num_ports(struct nfp_pf *pf)
 	return nfp_pf_rtsym_read_optional(pf, "nfd_cfg_pf%u_num_ports", 1);
 }
 
-static int nfp_net_pf_get_app_id(struct nfp_pf *pf)
-{
-	return nfp_pf_rtsym_read_optional(pf, "_pf%u_net_app_id",
-					  NFP_APP_CORE_NIC);
-}
-
 static void nfp_net_pf_free_vnic(struct nfp_pf *pf, struct nfp_net *nn)
 {
 	if (nfp_net_is_data_vnic(nn))
@@ -206,7 +200,6 @@ nfp_net_pf_alloc_vnics(struct nfp_pf *pf, void __iomem *ctrl_bar,
 			nn->port->link_cb = nfp_net_refresh_port_table;
 
 		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
-		pf->sp_indiff |= nn->tlv_caps.sp_indiff;
 
 		/* Kill the vNIC if app init marked it as invalid */
 		if (nn->port && nn->port->type == NFP_PORT_INVALID)
@@ -308,36 +301,6 @@ static int nfp_net_pf_init_vnics(struct nfp_pf *pf)
 	return err;
 }
 
-static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
-{
-	struct nfp_nsp *nsp;
-	char hwinfo[32];
-	int err;
-
-	nsp = nfp_nsp_open(pf->cpp);
-	if (IS_ERR(nsp))
-		return PTR_ERR(nsp);
-
-	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
-	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
-	/* Not a fatal error, no need to return error to stop driver from loading */
-	if (err)
-		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
-
-	nfp_nsp_close(nsp);
-	return 0;
-}
-
-static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
-{
-	return nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
-}
-
-static void nfp_net_pf_clean_nsp(struct nfp_pf *pf)
-{
-	(void)nfp_net_pf_cfg_nsp(pf, false);
-}
-
 static int
 nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 {
@@ -349,8 +312,6 @@ nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 	if (IS_ERR(pf->app))
 		return PTR_ERR(pf->app);
 
-	pf->sp_indiff |= pf->app->type->id == NFP_APP_FLOWER_NIC;
-
 	devl_lock(devlink);
 	err = nfp_app_init(pf->app);
 	devl_unlock(devlink);
@@ -813,13 +774,9 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_clean_ddir;
 
-	err = nfp_net_pf_init_nsp(pf);
-	if (err)
-		goto err_free_vnics;
-
 	err = nfp_net_pf_alloc_irqs(pf);
 	if (err)
-		goto err_clean_nsp;
+		goto err_free_vnics;
 
 	err = nfp_net_pf_app_start(pf);
 	if (err)
@@ -838,8 +795,6 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_net_pf_app_stop(pf);
 err_free_irqs:
 	nfp_net_pf_free_irqs(pf);
-err_clean_nsp:
-	nfp_net_pf_clean_nsp(pf);
 err_free_vnics:
 	nfp_net_pf_free_vnics(pf);
 err_clean_ddir:
@@ -870,7 +825,6 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 		nfp_net_pf_free_vnic(pf, nn);
 	}
 
-	nfp_net_pf_clean_nsp(pf);
 	nfp_net_pf_app_stop(pf);
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
-- 
2.30.2

