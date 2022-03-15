Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B3E4D930F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344686AbiCOD3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344713AbiCOD1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:27:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59C54888B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:26:39 -0700 (PDT)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHf131ZhzzfYrn;
        Tue, 15 Mar 2022 11:25:11 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 15 Mar 2022 11:26:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:37 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get fresh device features
Date:   Tue, 15 Mar 2022 11:21:07 +0800
Message-ID: <20220315032108.57228-2-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220315032108.57228-1-wangjie125@huawei.com>
References: <20220315032108.57228-1-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

As tx push is a standard feature for NICs, but netdev_feature which is
controlled by ethtool -K has reached the maximum specification.

so this patch adds a pair of new ethtool messages：'ETHTOOL_GDEVFEAT' and
'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
drivers. The message processing functions and function hooks in struct
ethtool_ops are also added.

set-devfeatures/show-devfeatures option(s) are designed to provide set
and get function.
set cmd:
root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
get cmd:
root@wj: ethtool --show-devfeatures eth4

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 include/linux/ethtool.h      |  4 ++++
 include/uapi/linux/ethtool.h | 27 ++++++++++++++++++++++
 net/ethtool/ioctl.c          | 43 ++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 11efc45de66a..1a34bb074720 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -750,6 +750,10 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_devfeatures)(struct net_device *dev,
+				   struct ethtool_dev_features *dev_feat);
+	int	(*set_devfeatures)(struct net_device *dev,
+				   struct ethtool_dev_features *dev_feat);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7bc4b8def12c..319d7b2c6acb 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1490,6 +1490,31 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
 #define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
 
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
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
 					    * Please use ETHTOOL_GLINKSETTINGS
@@ -1584,6 +1609,8 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_GDEVFEAT	0x00000052 /* Get device features */
+#define ETHTOOL_SDEVFEAT	0x00000053 /* Set device features */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..efac23352eb9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2722,6 +2722,42 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
+static int ethtool_get_devfeatures(struct net_device *dev,
+				   void __user *useraddr)
+{
+	struct ethtool_dev_features dev_feat;
+	int ret;
+
+	if (!dev->ethtool_ops->get_devfeatures)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&dev_feat, useraddr, sizeof(dev_feat)))
+		return -EFAULT;
+
+	ret = dev->ethtool_ops->get_devfeatures(dev, &dev_feat);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(useraddr, &dev_feat, sizeof(dev_feat)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ethtool_set_devfeatures(struct net_device *dev,
+				   void __user *useraddr)
+{
+	struct ethtool_dev_features dev_feat;
+
+	if (!dev->ethtool_ops->set_devfeatures)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&dev_feat, useraddr, sizeof(dev_feat)))
+		return -EFAULT;
+
+	return dev->ethtool_ops->set_devfeatures(dev, &dev_feat);
+}
+
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
 static int
@@ -2781,6 +2817,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_PHY_GTUNABLE:
 	case ETHTOOL_GLINKSETTINGS:
 	case ETHTOOL_GFECPARAM:
+	case ETHTOOL_GDEVFEAT:
 		break;
 	default:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
@@ -3008,6 +3045,12 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_SFECPARAM:
 		rc = ethtool_set_fecparam(dev, useraddr);
 		break;
+	case ETHTOOL_GDEVFEAT:
+		rc = ethtool_get_devfeatures(dev, useraddr);
+		break;
+	case ETHTOOL_SDEVFEAT:
+		rc = ethtool_set_devfeatures(dev, useraddr);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
-- 
2.33.0

