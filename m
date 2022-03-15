Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFD14D92E6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiCODZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbiCODZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:25:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCF035876
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:24:10 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KHdt86bt6z1GCMt;
        Tue, 15 Mar 2022 11:19:12 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:24:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:24:08 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RFC ethtool 2/2] ethtool: add support to get/set device features
Date:   Tue, 15 Mar 2022 11:18:34 +0800
Message-ID: <20220315031834.56676-3-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220315031834.56676-1-wangjie125@huawei.com>
References: <20220315031834.56676-1-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tx push is a standard feature for NICs such as Mellanox, nVidia
and Broadcom. But there is no cmd for features contained entirely to the
driver.

So this patch add cmd "ethtool --set-dev-features <dev> tx-push [on |off]"
and "ethtool --get-dev-features <dev>" to set/get features contained
entirely to the driver.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 ethtool.c            | 113 +++++++++++++++++++++++++++++++++++++++++++
 uapi/linux/ethtool.h |  27 +++++++++++
 2 files changed, 140 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index e2b4e17..3f28782 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1956,6 +1956,108 @@ static int do_spause(struct cmd_context *ctx)
 	return 0;
 }
 
+static void show_tx_push_mode(struct ethtool_dev_features *dev_features)
+{
+	fprintf(stdout, "tx push mode: %s\n",
+		dev_features->data ? "on" : "off");
+}
+
+static void dump_devfeatures(struct ethtool_dev_features *dev_feat, u32 i)
+{
+	struct dump_proto {
+		__u64 features_bit;
+		void (*show_func)(struct ethtool_dev_features *dev_feat);
+	} show_features[] = {
+		{ ETHTOOL_DEV_TX_PUSH, show_tx_push_mode }
+	};
+
+	if (i < ARRAY_SIZE(show_features) && show_features[i].show_func)
+		show_features[i].show_func(dev_feat);
+}
+
+const enum ethtool_dev_features_type dev_feature_type[] = {
+	ETHTOOL_DEV_TX_PUSH,
+};
+
+static int do_gdevfeatures(struct cmd_context *ctx)
+{
+	struct ethtool_dev_features dev_features;
+	u32 i, failed_cnt = 0;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(dev_feature_type); ++i) {
+		dev_features.cmd = ETHTOOL_GDEVFEAT;
+		dev_features.type = dev_feature_type[i];
+		ret = send_ioctl(ctx, &dev_features);
+		if (ret) {
+			++failed_cnt;
+			continue;
+		}
+
+		dump_devfeatures(&dev_features, i);
+	}
+
+	if (failed_cnt == ARRAY_SIZE(dev_feature_type)) {
+		perror("Cannot get any device features");
+		return 75;
+	}
+
+	return 0;
+}
+
+static int do_sdevfeatures(struct cmd_context *ctx)
+{
+	u32 i, unchanged_num = 0, set_value = 1;
+	struct ethtool_dev_features dev_feat;
+	struct cmdline_info feat_line[] = {
+		{
+			.name = "tx-push",
+			.type = CMDL_BOOL,
+			.wanted_val = &set_value,
+			.ioctl_val = &dev_feat.data,
+		}
+	};
+	int err, changed;
+
+	parse_generic_cmdline(ctx, &changed, feat_line, ARRAY_SIZE(feat_line));
+
+	for (i = 0; i < ARRAY_SIZE(feat_line); i++) {
+		if (!feat_line[i].has_input) {
+			++unchanged_num;
+			continue;
+		}
+
+		dev_feat.cmd = ETHTOOL_GDEVFEAT;
+		dev_feat.type = dev_feature_type[i];
+		err = send_ioctl(ctx, &dev_feat);
+		if (err) {
+			perror("Cannot get device features");
+			return err;
+		}
+
+		changed = false;
+		do_generic_set1(&feat_line[i], &changed);
+		if (!changed) {
+			++unchanged_num;
+			continue;
+		}
+
+		dev_feat.cmd = ETHTOOL_SDEVFEAT;
+		err = send_ioctl(ctx, &dev_feat);
+		if (err) {
+			perror("Cannot set device parameters");
+			return err;
+		}
+	}
+
+	if (unchanged_num == ARRAY_SIZE(feat_line)) {
+		fprintf(stderr, "no device feature parameters changed, aborting\n");
+		return 75;
+	}
+
+	return 0;
+}
+
 static int do_sring(struct cmd_context *ctx)
 {
 	struct ethtool_ringparam ering;
@@ -6062,6 +6164,17 @@ static const struct option args[] = {
 		.help	= "Set transceiver module settings",
 		.xhelp	= "		[ power-mode-policy high|auto ]\n"
 	},
+	{
+		.opts	= "--show-dev-features",
+		.func	= do_gdevfeatures,
+		.help	= "Get device driver features",
+	},
+	{
+		.opts	= "--set-dev-features",
+		.func	= do_sdevfeatures,
+		.help	= "Set device driver features",
+		.xhelp	= "		[ tx-push on|off ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 85548f9..4e3ccee 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -221,6 +221,31 @@ struct ethtool_value {
 	__u32	data;
 };
 
+/**
+ * struct ethtool_dev_features - device feature configurations
+ * @cmd: Command number = %ETHTOOL_GDEVFEAT or %ETHTOOL_SDEVFEAT
+ * @type: feature configuration type.
+ * @data: feature configuration value.
+ */
+struct ethtool_dev_features {
+	__u32 cmd;
+	__u32 type;
+	__u32 data;
+};
+
+/**
+ * enum ethtool_dev_features_type - flags definition of ethtool_dev_features
+ * @ETHTOOL_DEV_TX_PUSH: nic tx push mode set bit.
+ */
+enum ethtool_dev_features_type {
+	ETHTOOL_DEV_TX_PUSH,
+	/*
+	 * Add your fresh feature type above and remember to update
+	 * feat_line[] in ethtool.c
+	 */
+	ETHTOOL_DEV_FEATURE_COUNT,
+};
+
 #define PFC_STORM_PREVENTION_AUTO	0xffff
 #define PFC_STORM_PREVENTION_DISABLE	0
 
@@ -1582,6 +1607,8 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_GDEVFEAT	0x00000052 /* Get device features */
+#define ETHTOOL_SDEVFEAT	0x00000053 /* Set device features */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
-- 
2.33.0

