Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B534787E0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhLQJjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:39:37 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:58478 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231424AbhLQJjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 04:39:36 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowADXtxTAWrxhKKCXAw--.31518S2;
        Fri, 17 Dec 2021 17:39:12 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] qlcnic: potential dereference null pointer of rx_queue->page_ring
Date:   Fri, 17 Dec 2021 17:39:11 +0800
Message-Id: <20211217093911.611537-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADXtxTAWrxhKKCXAw--.31518S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWkXF1DJF45Xr4DKF13CFg_yoWrXF45pF
        47ZFyUWr95tr1Fgw4kZw15Ar98C3y0y3sruFn3G39avryDtr4fGF15Ar1a9a1rArykGayU
        trn8Z3WUXr1DAFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8uwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUhNVgUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kcalloc() needs to be checked.
To avoid dereference of null pointer in case of the failure of alloc.
Therefore, it might be better to change the return type of
qlcnic_sriov_alloc_vlans() and return -ENOMEM when alloc fails and
return 0 the others.
Also, qlcnic_sriov_set_guest_vlan_mode() and __qlcnic_pci_sriov_enable()
should deal with the return value of qlcnic_sriov_alloc_vlans().

Fixes: 154d0c810c53 ("qlcnic: VLAN enhancement for 84XX adapters")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h    |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 12 +++++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c |  4 +++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
index 7160b42f51dd..d0111cb3b40e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
@@ -201,7 +201,7 @@ int qlcnic_sriov_get_vf_vport_info(struct qlcnic_adapter *,
 				   struct qlcnic_info *, u16);
 int qlcnic_sriov_cfg_vf_guest_vlan(struct qlcnic_adapter *, u16, u8);
 void qlcnic_sriov_free_vlans(struct qlcnic_adapter *);
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
 bool qlcnic_sriov_check_any_vlan(struct qlcnic_vf_info *);
 void qlcnic_sriov_del_vlan_id(struct qlcnic_sriov *,
 			      struct qlcnic_vf_info *, u16);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index dd03be3fc82a..42a44c97572a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -432,7 +432,7 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 					    struct qlcnic_cmd_args *cmd)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
-	int i, num_vlans;
+	int i, num_vlans, ret;
 	u16 *vlans;
 
 	if (sriov->allowed_vlans)
@@ -443,7 +443,9 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 	dev_info(&adapter->pdev->dev, "Number of allowed Guest VLANs = %d\n",
 		 sriov->num_allowed_vlans);
 
-	qlcnic_sriov_alloc_vlans(adapter);
+	ret = qlcnic_sriov_alloc_vlans(adapter);
+	if (ret)
+		return ret;
 
 	if (!sriov->any_vlan)
 		return 0;
@@ -2154,7 +2156,7 @@ static int qlcnic_sriov_vf_resume(struct qlcnic_adapter *adapter)
 	return err;
 }
 
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
 	struct qlcnic_vf_info *vf;
@@ -2164,7 +2166,11 @@ void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
 		vf = &sriov->vf_info[i];
 		vf->sriov_vlans = kcalloc(sriov->num_allowed_vlans,
 					  sizeof(*vf->sriov_vlans), GFP_KERNEL);
+		if (!vf->sriov_vlans)
+			return -ENOMEM;
 	}
+
+	return 0;
 }
 
 void qlcnic_sriov_free_vlans(struct qlcnic_adapter *adapter)
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
index 447720b93e5a..e90fa97c0ae6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
@@ -597,7 +597,9 @@ static int __qlcnic_pci_sriov_enable(struct qlcnic_adapter *adapter,
 	if (err)
 		goto del_flr_queue;
 
-	qlcnic_sriov_alloc_vlans(adapter);
+	err = qlcnic_sriov_alloc_vlans(adapter);
+	if (err)
+		goto del_flr_queue;
 
 	return err;
 
-- 
2.25.1

