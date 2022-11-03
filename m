Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01235617855
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiKCIGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiKCIGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:06:21 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3080760DB;
        Thu,  3 Nov 2022 01:06:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667462775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrBR4SF/8VnGnxEIBn/xM0y9bHddbWKFSWf1ZZc7fnI=;
        b=wqMthqfYcVa4A5dv5mz6RYdQvJXkwpHvTj29SmRgaEc5krBIjM2bsncvtVhdx89qULiC6Y
        m/RT75u/YhgoWp1XjgKZIkF81f17K51eQTdkg1iaoHMtJYxX5MwYDqOaSqS+sUzw/xRg3P
        3mf1OTWiKN+6xTKESKmUO7y4WXiwQUo=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     kuba@kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 3/3] net: hinic: Add support for configuration of rx-vlan-filter by ethtool
Date:   Thu,  3 Nov 2022 16:05:11 +0800
Message-Id: <20221103080525.26885-3-cai.huoqing@linux.dev>
In-Reply-To: <20221103080525.26885-1-cai.huoqing@linux.dev>
References: <20221103080525.26885-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ethtool config rx-vlan-filter, the driver will send
control command to firmware, then set to hardware in this patch.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
v1->v3:
	1.Merge this patch to the series.
	comments link: https://lore.kernel.org/lkml/20221101214059.464a1d42@kernel.org/

 .../net/ethernet/huawei/hinic/hinic_main.c    | 10 ++++++
 .../net/ethernet/huawei/hinic/hinic_port.c    | 33 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 12 +++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 9d4d795e1081..977c41473ab7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1092,6 +1092,16 @@ static int set_features(struct hinic_dev *nic_dev,
 		}
 	}
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
+		ret = hinic_set_vlan_fliter(nic_dev,
+					    !!(features &
+					       NETIF_F_HW_VLAN_CTAG_FILTER));
+		if (ret) {
+			err = ret;
+			failed_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		}
+	}
+
 	if (err) {
 		nic_dev->netdev->features = features ^ failed_features;
 		return -EIO;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 0a39c3dffa9a..9406237c461e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -447,6 +447,39 @@ int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en)
 	return 0;
 }
 
+int hinic_set_vlan_fliter(struct hinic_dev *nic_dev, u32 en)
+{
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	struct hinic_vlan_filter vlan_filter;
+	u16 out_size = sizeof(vlan_filter);
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	vlan_filter.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
+	vlan_filter.enable = en;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_VLAN_FILTER,
+				 &vlan_filter, sizeof(vlan_filter),
+				 &vlan_filter, &out_size);
+	if (vlan_filter.status == HINIC_MGMT_CMD_UNSUPPORTED) {
+		err = HINIC_MGMT_CMD_UNSUPPORTED;
+	} else if ((err == HINIC_MBOX_VF_CMD_ERROR) &&
+			   HINIC_IS_VF(hwif)) {
+		err = HINIC_MGMT_CMD_UNSUPPORTED;
+	} else if (err || !out_size || vlan_filter.status) {
+		dev_err(&pdev->dev,
+			"Failed to set vlan fliter, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, vlan_filter.status, out_size);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index c9ae3d4dc547..c8694ac7c702 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -351,6 +351,16 @@ struct hinic_vlan_cfg {
 	u8      rsvd1[5];
 };
 
+struct hinic_vlan_filter {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_idx;
+	u8	rsvd1[2];
+	u32	enable;
+};
+
 struct hinic_rss_template_mgmt {
 	u8	status;
 	u8	version;
@@ -831,6 +841,8 @@ int hinic_get_vport_stats(struct hinic_dev *nic_dev,
 
 int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en);
 
+int hinic_set_vlan_fliter(struct hinic_dev *nic_dev, u32 en);
+
 int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver);
 
 int hinic_set_link_settings(struct hinic_hwdev *hwdev,
-- 
2.25.1

