Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18651615C1D
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 07:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiKBGRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 02:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiKBGRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 02:17:09 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4DA25EB6;
        Tue,  1 Nov 2022 23:17:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667369824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrBR4SF/8VnGnxEIBn/xM0y9bHddbWKFSWf1ZZc7fnI=;
        b=Oj3SDgsjpty6Kug3fDeNvrVrODvMssx4RpnWoWgHZaQCsW7gHX/mRwJuRa1oZ3Lvq7VdiQ
        y908Mm16JlFvAum0LpJsaH51Uckb87mYHutkU/Kh859kpzchunMhcqu2wdUd/5QboroSc5
        HS/zfSkKe1GDKu+aYKjcs785KQ/+0bg=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     kuba@kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: hinic: Add support for configuration of rx-vlan-filter by ethtool
Date:   Wed,  2 Nov 2022 14:16:11 +0800
Message-Id: <20221102061621.10329-3-cai.huoqing@linux.dev>
In-Reply-To: <20221102061621.10329-1-cai.huoqing@linux.dev>
References: <20221102061621.10329-1-cai.huoqing@linux.dev>
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

