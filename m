Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B736640A0
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbjAJMg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbjAJMge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:36:34 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2107.outbound.protection.outlook.com [40.107.100.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27994479D8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:36:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbGrnS+JhD3OMyP8pJZedNzAcjHLZ4JnsYg2qmzMnl8cKq9tH0aiJeXp1/HAQ4XzcSxBIeeYLhpGN0BLIiSyvkG9XU9gj1ovivLNpW+5kJs3avGlpav15Xq6+/GCYucmp65efVYSUwKd1qMdW7cXveVvSiOj/qipiYstjv13m1br3e8pgV09SKYV2N83D+uDx11GOIJDXv5et1PU4MsvqjNe/feKn6Iay9cbNjMpnfP+GdGKzrX1yncNBoqQI6w8EoMlukVqDhsiq5Q/B3C5cbQX+WwHScXaQ9g7Vd8OWLLO/ne30mXfh/f910nIu88c/lr0LZ/n5bHH2Yl7lH6eag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18MnJASY3REdcFhN+W7wVvP3jC2yrA4u0sc5CpYMwEA=;
 b=Wg2tnHi2nKCdmq6b6umldeMQt5yk9JtaucDVaf9dBkBL1FSGwx4fiNKD/VKLjGfy9NyHHkNwgftdyumVguvHqCpUlDnsJi7ZJ9stT2MeOhuzySyFdNCHA3dtSuYHnhkzdzhQK7lqzfnMG/6ZXTtVOZemTnbFD00r5ioUPWp8o5jxInB8eBGuCaOVg6IvGqmKbhcJCad8hitxZySNK0wQPmv+PoQhsvHH1J4qeKhahVmuo5cuoFfVFezynr5aaV2gTVA8FbYfJq/TEQp4HnsYN0+NUgZL5Qqqo33/bPD0LuyqVnmZrqtH1zGjdrw8mByeOkA0b8aSnY8g7zmvUE9N6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18MnJASY3REdcFhN+W7wVvP3jC2yrA4u0sc5CpYMwEA=;
 b=U6/Fn+QhoaZfI+E4jNmFoFAyYfM7604GLnPZKgE4eV0UdZ6LC3ztequFv5m40OwHSfH54ZHW/G1RHi8pJgsQ68lR2EJb4nrxfcXCGz7NXFrZnidXIV6+CJBBA9ZSm9k3hAWyEhE014BEMxWCvFIzwXWaXFgy++BYFWpJEsZhkS8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5625.namprd13.prod.outlook.com (2603:10b6:303:180::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 12:36:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:36:03 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/2] nfp: add DCB IEEE configuration process
Date:   Tue, 10 Jan 2023 13:35:42 +0100
Message-Id: <20230110123542.46924-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230110123542.46924-1-simon.horman@corigine.com>
References: <20230110123542.46924-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: 48349d57-ea3d-4cea-1f23-08daf3073c38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWIpQ0S0OkSgNTZ8vgeBANqZEy4VfY4HlmV0oxA3n0Ug5CNpIg39Ck2kX93Z2jPinm4qkxvF7V76KRdC9H3lIs9oPI82qI2qAwriIQNu+ewMz3BLv1MFt6phSrjvlkS7vm0oeH1dk+/nM29fOyLPA+zWb53WnDAvb1KP23jMDnpoZyf0NR5j2J/AwLk16aqBzwgWwQNQ3TfEe+QqfyQxWa03F4pgGAWDu3E/G0iE8kQUCg+TIhPHuYPZ4r+y61k+3G+4j5Fj0m/RlgRr5EhIKZvLl1oUa3gcLiJEfzpyo7nFjj1TDgsYwGP33QlbekO2YGvm0Bu3BmxpWpILaaCxXk97hWJ/0zuCxygDhpeuuSr2t/4IGVm/9rbNSxMmTjWRnm6CaJIb5Zc8XzMy2bK8QO0OxPZ1DdNfztbEoKYF6hbzq9i6dTYGdunTFY3MT7daKNIe5c6tCWHQDWpp69txqh2bSPhMDFVdl2XztC2e9oT4wQInjPxA7ygXds2g3VzN68WK12BWpW6VDbIH5K5y/FyNQI6Rd4mVpSyoIqFSjiBHqMKWU7A+oSp4Mir2o10skdo1kuCuTaGeC5qyDNjdCsGQjLmIs516RS0zsvz558ovVruE5UPsRGMCDoOEodWzPO1pVj6Czohz9RnXO8FfKTzOXysG1pJX37poJETAtDK8GiT+6zHkWJYxJkwIWuqi9l0FmcGcwW2MhAsBTSmJP68/+2WrU3puCUDgTU9mkCcioUxhRQ9gAeUO+iYxJJwb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(451199015)(36756003)(86362001)(6506007)(316002)(110136005)(6486002)(52116002)(54906003)(30864003)(5660300002)(2906002)(6666004)(44832011)(478600001)(66556008)(41300700001)(8676002)(66476007)(4326008)(8936002)(66946007)(107886003)(38100700002)(2616005)(1076003)(6512007)(186003)(83380400001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O1i+3+W7QGLo8dwJqYHTn0T+aNCZkpnO3bU+A9lG8da387nuYGlzXLPZ39u3?=
 =?us-ascii?Q?f0bqeT/9WHRlWo9oKaJoIF1+DcL73m/MUTjKBD00ZxckZgxA0pAHrViuzFbZ?=
 =?us-ascii?Q?/cFZx2JkpZw6cHUpi5jJszKod+a+vUSZnwkrEGLE8fY9TCkrPPVtGixGYX/g?=
 =?us-ascii?Q?KL9nabaUiiVS1tNBe/HPFWsiMSmvHj0crT+A/AueL4hiQMLRQJHFMy3FsbJw?=
 =?us-ascii?Q?ZXLZoJUOMYJPJcxltL9OyUVLRbaADK07r+IWgeWIuBCxCExddS3JtO7PHgka?=
 =?us-ascii?Q?Bflfz0Y0pbxjlMNoTnG1Hqkl3Ih+27PRLHl39ao1Rv+vpHt0ZawTm/taTQ8w?=
 =?us-ascii?Q?Q6R+D55NDfkJG4ONz65nOnK2x7ZEykc0W4uJLe1gpBD0xDuIfe4IQzwmDEFG?=
 =?us-ascii?Q?bFBenEiyEXdLc5tvVk4W99ynJsqJNSUS39uV0YSYKNqnaLQVrAWsBdyGo4R5?=
 =?us-ascii?Q?zmqnppRrVGgY+eNyM8C4SQHxjDfWtqPKOL66WdTapC9aREi3zvxMpQ0lW97M?=
 =?us-ascii?Q?dwTI6CPGSV1+RzhuaPuRGNvALjTLmaHhWnySQKR4AHIo2BNDnf8UXKrN+KbT?=
 =?us-ascii?Q?qwtik6JAa0yvge80ziX/N8/DKno+eKCn3HAo7pi2MNqKU/ESIXKL7IJzHsr2?=
 =?us-ascii?Q?V1E2KkE0bDew6KykZdn57VlTcY4y3KoLkKI/+emKuYZECFy2QCjOzt066ahC?=
 =?us-ascii?Q?OYxrCqgA149qr+oAjvqAP2eodNpg2NhbEOQpQg3JmDhFYssCA3TL3FZRNi1p?=
 =?us-ascii?Q?aEdaBYF4CcnAbIK+TYUAc2oTVxPqx7pfeGrRqborXPvKXS7HekRA+aLvKqgy?=
 =?us-ascii?Q?NVAKchfS2ENMhm23oy64xTMQcEun7p/WWnnn4i+UydXPsfEP6oVELkoCWgwg?=
 =?us-ascii?Q?hVzQ6HTpG0teO0v3abmRNLQaGoUuGLuApd0IqDAIuZUiPI5bQ9R7yuEOKb8n?=
 =?us-ascii?Q?3xWib8v8oiskVR98HHJDSs+YzRJ5KTZeMn+w6VORr19asRHiWnFRows8VfiH?=
 =?us-ascii?Q?d+uWGLVhHa+9cmYan3F4bDwGOriGF4HEBU4w2MCHBDW23uxnInhGArQ1EY1s?=
 =?us-ascii?Q?Zf1vE/tJg6ZMzyJlxqBPE4evTkwUmFFSvKJU5HjArtpNYYDGZ5+TQU031Vd6?=
 =?us-ascii?Q?7QKitJtHwYh7ewnsadhUcDM5L9kcLJogsppahTy9UJd2UJM7wDwj3s5fwieh?=
 =?us-ascii?Q?XUqbY9AgHT8YLc9WsjrymKwT1VfLxwV6V5c9W/mOiQuF9lJyFN5CmaDXhyBI?=
 =?us-ascii?Q?8XBrbjfnVu8rMXv1x3NsLg1QjFDf97dvhmhfYZpTKe248H1oh2yeTAokHrkP?=
 =?us-ascii?Q?ZPewilYrcmi+oKLqBlgE4e9rUIaAINtPRXCykL1M5Ag4Qtp8XaOhyq3z2RFr?=
 =?us-ascii?Q?Y+h8bgAuNKwZKmPjToKhxFXkduItDV425l+Km6uKgfT2+mEC/HiZgM9SZzOS?=
 =?us-ascii?Q?P71MzMiUn6N8kBspStRpvG6wxGoY6FxmRjEfINeVeVEZyAXDAj8imTRGhDWr?=
 =?us-ascii?Q?hiTqb0w/ygQI5lr7+LBtmoR4epqzKaNuMFeVI9UfZvh/rYVg4xFuXeU+OxIp?=
 =?us-ascii?Q?SMRR1fc4oUuKDkowlR8iwXlcgf7cEUkQVHHcy8oYkeMOA7dzSYu6mfTSazfJ?=
 =?us-ascii?Q?phF7/mRyHudWD/Iz4YkYmiLnyWM0J8qHEpzlg00CNnvP76jyyrVKR3HgXGON?=
 =?us-ascii?Q?JBfOaA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48349d57-ea3d-4cea-1f23-08daf3073c38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:36:02.9946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Skoy3+zZP1ez0O2iTPocqdTtvse8kcF+HG396xuzE5eXZFNrwyURk7ikeSA3zyR74FOPcGp3X6oO6UiQieh/mPggXh5SfDxPMQRTsonEBKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5625
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

Basic completion of DCB support, including ETS and other functions.
Implemented DCB IEEE callbacks in order to add or remove DSCP to
user priority mapping and added DCB IEEE bandwidth percentage checks.

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.c |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 drivers/net/ethernet/netronome/nfp/nic/dcb.c  | 523 +++++++++++++++++-
 drivers/net/ethernet/netronome/nfp/nic/main.h |  25 +-
 4 files changed, 536 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index f469950c7265..5d792bbacbfd 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -10,6 +10,7 @@
 #include "../nfp_main.h"
 #include "../nfp_net.h"
 #include "../nfp_port.h"
+#include "../nfp_net_ctrl.h"
 #include "fw.h"
 #include "main.h"
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 51124309ae1f..a4096050c9bd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -413,6 +413,7 @@
 #define NFP_NET_CFG_MBOX_CMD_IPSEC 3
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
+#define NFP_NET_CFG_MBOX_CMD_DCB_UPDATE			7
 
 #define NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD		8
 #define NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL		9
diff --git a/drivers/net/ethernet/netronome/nfp/nic/dcb.c b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
index 91508222cbd6..7a882a398470 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/dcb.c
+++ b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
@@ -2,31 +2,325 @@
 /* Copyright (C) 2020 Netronome Systems, Inc. */
 /* Copyright (C) 2021 Corigine, Inc. */
 
-#include "../nfp_net.h"
+#include <linux/device.h>
 #include <linux/netdevice.h>
 #include <net/dcbnl.h>
+
+#include "../nfp_app.h"
+#include "../nfp_net.h"
+#include "../nfp_main.h"
+#include "../nfpcore/nfp_cpp.h"
+#include "../nfpcore/nfp_nffw.h"
+#include "../nfp_net_sriov.h"
+
 #include "main.h"
 
+#define NFP_DCB_TRUST_PCP	1
+#define NFP_DCB_TRUST_DSCP	2
+#define NFP_DCB_TRUST_INVALID	0xff
+
+#define NFP_DCB_TSA_VENDOR	1
+#define NFP_DCB_TSA_STRICT	2
+#define NFP_DCB_TSA_ETS		3
+
+#define NFP_DCB_GBL_ENABLE	BIT(0)
+#define NFP_DCB_QOS_ENABLE	BIT(1)
+#define NFP_DCB_DISABLE		0
+#define NFP_DCB_ALL_QOS_ENABLE	(NFP_DCB_GBL_ENABLE | NFP_DCB_QOS_ENABLE)
+
+#define NFP_DCB_UPDATE_MSK_SZ	4
+#define NFP_DCB_TC_RATE_MAX	0xffff
+
+#define NFP_DCB_DATA_OFF_DSCP2IDX	0
+#define NFP_DCB_DATA_OFF_PCP2IDX	64
+#define NFP_DCB_DATA_OFF_TSA		80
+#define NFP_DCB_DATA_OFF_IDX_BW_PCT	88
+#define NFP_DCB_DATA_OFF_RATE		96
+#define NFP_DCB_DATA_OFF_CAP		112
+#define NFP_DCB_DATA_OFF_ENABLE		116
+#define NFP_DCB_DATA_OFF_TRUST		120
+
+#define NFP_DCB_MSG_MSK_ENABLE	BIT(31)
+#define NFP_DCB_MSG_MSK_TRUST	BIT(30)
+#define NFP_DCB_MSG_MSK_TSA	BIT(29)
+#define NFP_DCB_MSG_MSK_DSCP	BIT(28)
+#define NFP_DCB_MSG_MSK_PCP	BIT(27)
+#define NFP_DCB_MSG_MSK_RATE	BIT(26)
+#define NFP_DCB_MSG_MSK_PCT	BIT(25)
+
+static struct nfp_dcb *get_dcb_priv(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb = &((struct nfp_app_nic_private *)nn->app_priv)->dcb;
+
+	return dcb;
+}
+
+static u8 nfp_tsa_ieee2nfp(u8 tsa)
+{
+	switch (tsa) {
+	case IEEE_8021QAZ_TSA_STRICT:
+		return NFP_DCB_TSA_STRICT;
+	case IEEE_8021QAZ_TSA_ETS:
+		return NFP_DCB_TSA_ETS;
+	default:
+		return NFP_DCB_TSA_VENDOR;
+	}
+}
+
 static int nfp_nic_dcbnl_ieee_getets(struct net_device *dev,
 				     struct ieee_ets *ets)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
 
-	return -EOPNOTSUPP;
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		ets->prio_tc[i] = dcb->prio2tc[i];
+		ets->tc_tx_bw[i] = dcb->tc_tx_pct[i];
+		ets->tc_tsa[i] = dcb->tc_tsa[i];
+	}
+
+	return 0;
+}
+
+static bool nfp_refresh_tc2idx(struct nfp_net *nn)
+{
+	u8 tc2idx[IEEE_8021QAZ_MAX_TCS];
+	bool change = false;
+	struct nfp_dcb *dcb;
+	int maxstrict = 0;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		tc2idx[i] = i;
+		if (dcb->tc_tsa[i] == IEEE_8021QAZ_TSA_STRICT)
+			maxstrict = i;
+	}
+
+	if (maxstrict > 0 && dcb->tc_tsa[0] != IEEE_8021QAZ_TSA_STRICT) {
+		tc2idx[0] = maxstrict;
+		tc2idx[maxstrict] = 0;
+	}
+
+	for (unsigned int j = 0; j < IEEE_8021QAZ_MAX_TCS; j++) {
+		if (dcb->tc2idx[j] != tc2idx[j]) {
+			change = true;
+			dcb->tc2idx[j] = tc2idx[j];
+		}
+	}
+
+	return change;
+}
+
+static int nfp_fill_maxrate(struct nfp_net *nn, u64 *max_rate_array)
+{
+	struct nfp_app *app  = nn->app;
+	struct nfp_dcb *dcb;
+	u32 ratembps;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		/* Convert bandwidth from kbps to mbps. */
+		ratembps = max_rate_array[i] / 1024;
+
+		/* Reject input values >= NFP_DCB_TC_RATE_MAX */
+		if (ratembps >= NFP_DCB_TC_RATE_MAX) {
+			nfp_warn(app->cpp, "ratembps(%d) must less than %d.",
+				 ratembps, NFP_DCB_TC_RATE_MAX);
+			return -EINVAL;
+		}
+		/* Input value 0 mapped to NFP_DCB_TC_RATE_MAX for firmware. */
+		if (ratembps == 0)
+			ratembps = NFP_DCB_TC_RATE_MAX;
+
+		writew((u16)ratembps, dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_RATE + dcb->tc2idx[i] * 2);
+		/* for rate value from user space, need to sync to dcb structure */
+		if (dcb->tc_maxrate != max_rate_array)
+			dcb->tc_maxrate[i] = max_rate_array[i];
+	}
+
+	return 0;
+}
+
+static int update_dscp_maxrate(struct net_device *dev, u32 *update)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+
+	err = nfp_fill_maxrate(nn, dcb->tc_maxrate);
+	if (err)
+		return err;
+
+	*update |= NFP_DCB_MSG_MSK_RATE;
+
+	/* We only refresh dscp in dscp trust mode. */
+	if (dcb->dscp_cnt > 0) {
+		for (unsigned int i = 0; i < NFP_NET_MAX_DSCP; i++) {
+			writeb(dcb->tc2idx[dcb->prio2tc[dcb->dscp2prio[i]]],
+			       dcb->dcbcfg_tbl + dcb->cfg_offset +
+			       NFP_DCB_DATA_OFF_DSCP2IDX + i);
+		}
+		*update |= NFP_DCB_MSG_MSK_DSCP;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_set_trust(struct nfp_net *nn, u32 *update)
+{
+	struct nfp_dcb *dcb;
+	u8 trust;
+
+	dcb = get_dcb_priv(nn);
+
+	if (dcb->trust_status != NFP_DCB_TRUST_INVALID)
+		return;
+
+	trust = dcb->dscp_cnt > 0 ? NFP_DCB_TRUST_DSCP : NFP_DCB_TRUST_PCP;
+	writeb(trust, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_TRUST);
+
+	dcb->trust_status = trust;
+	*update |= NFP_DCB_MSG_MSK_TRUST;
+}
+
+static void nfp_nic_set_enable(struct nfp_net *nn, u32 enable, u32 *update)
+{
+	struct nfp_dcb *dcb;
+	u32 value = 0;
+
+	dcb = get_dcb_priv(nn);
+
+	value = readl(dcb->dcbcfg_tbl + dcb->cfg_offset +
+		      NFP_DCB_DATA_OFF_ENABLE);
+	if (value != enable) {
+		writel(enable, dcb->dcbcfg_tbl + dcb->cfg_offset +
+		       NFP_DCB_DATA_OFF_ENABLE);
+		*update |= NFP_DCB_MSG_MSK_ENABLE;
+	}
+}
+
+static int dcb_ets_check(struct net_device *dev, struct ieee_ets *ets)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	bool ets_exists = false;
+	int sum = 0;
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		/* For ets mode, check bw percentage sum. */
+		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
+			ets_exists = true;
+			sum += ets->tc_tx_bw[i];
+		} else if (ets->tc_tx_bw[i]) {
+			nfp_warn(app->cpp, "ETS BW for strict/vendor TC must be 0.");
+			return -EINVAL;
+		}
+	}
+
+	if (ets_exists && sum != 100) {
+		nfp_warn(app->cpp, "Failed to validate ETS BW: sum must be 100.");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_fill_ets(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		writeb(dcb->tc2idx[dcb->prio2tc[i]],
+		       dcb->dcbcfg_tbl + dcb->cfg_offset + NFP_DCB_DATA_OFF_PCP2IDX + i);
+		writeb(dcb->tc_tx_pct[i], dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_IDX_BW_PCT + dcb->tc2idx[i]);
+		writeb(nfp_tsa_ieee2nfp(dcb->tc_tsa[i]), dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_TSA + dcb->tc2idx[i]);
+	}
+}
+
+static void nfp_nic_ets_init(struct nfp_net *nn, u32 *update)
+{
+	struct nfp_dcb *dcb = get_dcb_priv(nn);
+
+	if (dcb->ets_init)
+		return;
+
+	nfp_nic_fill_ets(nn);
+	dcb->ets_init = true;
+	*update |= NFP_DCB_MSG_MSK_TSA | NFP_DCB_MSG_MSK_PCT | NFP_DCB_MSG_MSK_PCP;
 }
 
 static int nfp_nic_dcbnl_ieee_setets(struct net_device *dev,
 				     struct ieee_ets *ets)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	bool change;
+	int err;
 
-	return -EOPNOTSUPP;
+	err = dcb_ets_check(dev, ets);
+	if (err)
+		return err;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		dcb->prio2tc[i] = ets->prio_tc[i];
+		dcb->tc_tx_pct[i] = ets->tc_tx_bw[i];
+		dcb->tc_tsa[i] = ets->tc_tsa[i];
+	}
+
+	change = nfp_refresh_tc2idx(nn);
+	nfp_nic_fill_ets(nn);
+	dcb->ets_init = true;
+	if (change || !dcb->rate_init) {
+		err = update_dscp_maxrate(dev, &update);
+		if (err) {
+			nfp_warn(app->cpp,
+				 "nfp dcbnl ieee setets ERROR:%d.",
+				 err);
+			return err;
+		}
+
+		dcb->rate_init = true;
+	}
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nfp_nic_set_trust(nn, &update);
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_TSA | NFP_DCB_MSG_MSK_PCT |
+		  NFP_DCB_MSG_MSK_PCP);
+
+	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
 }
 
 static int nfp_nic_dcbnl_ieee_getmaxrate(struct net_device *dev,
 					 struct ieee_maxrate *maxrate)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+		maxrate->tc_maxrate[i] = dcb->tc_maxrate[i];
 
 	return -EOPNOTSUPP;
 }
@@ -34,23 +328,185 @@ static int nfp_nic_dcbnl_ieee_getmaxrate(struct net_device *dev,
 static int nfp_nic_dcbnl_ieee_setmaxrate(struct net_device *dev,
 					 struct ieee_maxrate *maxrate)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	int err;
 
-	return -EOPNOTSUPP;
+	err = nfp_fill_maxrate(nn, maxrate->tc_maxrate);
+	if (err) {
+		nfp_warn(app->cpp,
+			 "nfp dcbnl ieee setmaxrate ERROR:%d.",
+			 err);
+		return err;
+	}
+
+	dcb = get_dcb_priv(nn);
+
+	dcb->rate_init = true;
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nfp_nic_set_trust(nn, &update);
+	nfp_nic_ets_init(nn, &update);
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_RATE);
+
+	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+}
+
+static int nfp_nic_set_trust_status(struct nfp_net *nn, u8 status)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+	if (!dcb->rate_init) {
+		err = nfp_fill_maxrate(nn, dcb->tc_maxrate);
+		if (err)
+			return err;
+
+		update |= NFP_DCB_MSG_MSK_RATE;
+		dcb->rate_init = true;
+	}
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nfp_nic_ets_init(nn, &update);
+	writeb(status, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_TRUST);
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_TRUST);
+
+	err = nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+	if (err)
+		return err;
+
+	dcb->trust_status = status;
+
+	return 0;
+}
+
+static int nfp_nic_set_dscp2prio(struct nfp_net *nn, u8 dscp, u8 prio)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_dcb *dcb;
+	u8 idx, tc;
+	int err;
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	dcb = get_dcb_priv(nn);
+
+	tc = dcb->prio2tc[prio];
+	idx = dcb->tc2idx[tc];
+
+	writeb(idx, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_DSCP2IDX + dscp);
+
+	nn_writel(nn, nn->tlv_caps.mbox_off +
+		  NFP_NET_CFG_MBOX_SIMPLE_VAL, NFP_DCB_MSG_MSK_DSCP);
+
+	err = nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+	if (err)
+		return err;
+
+	dcb->dscp2prio[dscp] = prio;
+
+	return 0;
 }
 
 static int nfp_nic_dcbnl_ieee_setapp(struct net_device *dev,
 				     struct dcb_app *app)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	struct nfp_net *nn = netdev_priv(dev);
+	struct dcb_app old_app;
+	struct nfp_dcb *dcb;
+	bool is_new;
+	int err;
 
-	return -EOPNOTSUPP;
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP)
+		return -EINVAL;
+
+	dcb = get_dcb_priv(nn);
+
+	/* Save the old entry info */
+	old_app.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+	old_app.protocol = app->protocol;
+	old_app.priority = dcb->dscp2prio[app->protocol];
+
+	/* Check trust status */
+	if (!dcb->dscp_cnt) {
+		err = nfp_nic_set_trust_status(nn, NFP_DCB_TRUST_DSCP);
+		if (err)
+			return err;
+	}
+
+	/* Check if the new mapping is same as old or in init stage */
+	if (app->priority != old_app.priority || app->priority == 0) {
+		err = nfp_nic_set_dscp2prio(nn, app->protocol, app->priority);
+		if (err)
+			return err;
+	}
+
+	/* Delete the old entry if exists */
+	is_new = !!dcb_ieee_delapp(dev, &old_app);
+
+	/* Add new entry and update counter */
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		return err;
+
+	if (is_new)
+		dcb->dscp_cnt++;
+
+	return 0;
 }
 
 static int nfp_nic_dcbnl_ieee_delapp(struct net_device *dev,
 				     struct dcb_app *app)
 {
-	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+	int err;
+
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP)
+		return -EINVAL;
+
+	dcb = get_dcb_priv(nn);
+
+	/* Check if the dcb_app param match fw */
+	if (app->priority != dcb->dscp2prio[app->protocol])
+		return -ENOENT;
+
+	/* Set fw dscp mapping to 0 */
+	err = nfp_nic_set_dscp2prio(nn, app->protocol, 0);
+	if (err)
+		return err;
+
+	/* Delete app from dcb list */
+	err = dcb_ieee_delapp(dev, app);
+	if (err)
+		return err;
+
+	/* Decrease dscp counter */
+	dcb->dscp_cnt--;
+
+	/* If no dscp mapping is configured, trust pcp */
+	if (dcb->dscp_cnt == 0)
+		return nfp_nic_set_trust_status(nn, NFP_DCB_TRUST_PCP);
 
 	return -EOPNOTSUPP;
 }
@@ -67,7 +523,50 @@ static const struct dcbnl_rtnl_ops nfp_nic_dcbnl_ops = {
 
 int nfp_nic_dcb_init(struct nfp_net *nn)
 {
-	nn->dp.netdev->dcbnl_ops = &nfp_nic_dcbnl_ops;
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+	dcb->cfg_offset = NFP_DCB_CFG_STRIDE * nn->id;
+	dcb->dcbcfg_tbl = nfp_pf_map_rtsym(app->pf, "net.dcbcfg_tbl",
+					   "_abi_dcb_cfg",
+					   dcb->cfg_offset, &dcb->dcbcfg_tbl_area);
+	if (IS_ERR(dcb->dcbcfg_tbl)) {
+		if (PTR_ERR(dcb->dcbcfg_tbl) != -ENOENT) {
+			err = PTR_ERR(dcb->dcbcfg_tbl);
+			dcb->dcbcfg_tbl = NULL;
+			nfp_err(app->cpp,
+				"Failed to map dcbcfg_tbl area, min_size %u.\n",
+				dcb->cfg_offset);
+			return err;
+		}
+		dcb->dcbcfg_tbl = NULL;
+	}
+
+	if (dcb->dcbcfg_tbl) {
+		for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+			dcb->prio2tc[i] = i;
+			dcb->tc2idx[i] = i;
+			dcb->tc_tx_pct[i] = 0;
+			dcb->tc_maxrate[i] = 0;
+			dcb->tc_tsa[i] = IEEE_8021QAZ_TSA_VENDOR;
+		}
+		dcb->trust_status = NFP_DCB_TRUST_INVALID;
+		dcb->rate_init = false;
+		dcb->ets_init = false;
+
+		nn->dp.netdev->dcbnl_ops = &nfp_nic_dcbnl_ops;
+	}
 
 	return 0;
 }
+
+void nfp_nic_dcb_clean(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+	if (dcb->dcbcfg_tbl_area)
+		nfp_cpp_area_release_free(dcb->dcbcfg_tbl_area);
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
index 679531fe2838..c7c74349b38b 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.h
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -7,13 +7,34 @@
 #include <linux/netdevice.h>
 
 #ifdef CONFIG_DCB
+/* DCB feature definitions */
+#define NFP_NET_MAX_DSCP	4
+#define NFP_NET_MAX_TC		IEEE_8021QAZ_MAX_TCS
+#define NFP_NET_MAX_PRIO	8
+#define NFP_DCB_CFG_STRIDE	256
+
 struct nfp_dcb {
+	u8 dscp2prio[NFP_NET_MAX_DSCP];
+	u8 prio2tc[NFP_NET_MAX_PRIO];
+	u8 tc2idx[IEEE_8021QAZ_MAX_TCS];
+	u64 tc_maxrate[IEEE_8021QAZ_MAX_TCS];
+	u8 tc_tx_pct[IEEE_8021QAZ_MAX_TCS];
+	u8 tc_tsa[IEEE_8021QAZ_MAX_TCS];
+	u8 dscp_cnt;
+	u8 trust_status;
+	bool rate_init;
+	bool ets_init;
+
+	struct nfp_cpp_area *dcbcfg_tbl_area;
+	u8 __iomem *dcbcfg_tbl;
+	u32 cfg_offset;
 };
 
 int nfp_nic_dcb_init(struct nfp_net *nn);
-
+void nfp_nic_dcb_clean(struct nfp_net *nn);
 #else
-static inline int nfp_nic_dcb_init(struct nfp_net *nn) { return 0; }
+static inline int nfp_nic_dcb_init(struct nfp_net *nn) {return 0; }
+static inline void nfp_nic_dcb_clean(struct nfp_net *nn) {}
 #endif
 
 struct nfp_app_nic_private {
-- 
2.30.2

