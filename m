Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF50848235D
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhLaK1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:49 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16680 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhLaK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:42 -0500
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JQLpr176ZzZdrh;
        Fri, 31 Dec 2021 18:24:20 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 06/13] net: hns3: refactor hclgevf_cmd_send with new hclge_comm_cmd_send API
Date:   Fri, 31 Dec 2021 18:22:36 +0800
Message-ID: <20211231102243.3006-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

This patch firstly uses new hardware description struct hclge_comm_hw as
child member of hclgevf_hw and deletes the old hardware description child
members. All the hclgevf_hw variables used in VF module is modified
according to the new hclgevf_hw.

Secondly hclgevf_cmd_send is refactored to use hclge_comm_cmd_send APIs.
The old functions called by hclgevf_cmd_send are all deleted. Still we kept
hclgevf_cmd_send to avoid too many meaningless modifications.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 296 +++---------------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  71 -----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  49 ++-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  11 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  15 +-
 5 files changed, 82 insertions(+), 360 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 416b6e41e988..526da4e8aa42 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -11,84 +11,12 @@
 #include "hclgevf_main.h"
 #include "hnae3.h"
 
-#define cmq_ring_to_dev(ring)   (&(ring)->dev->pdev->dev)
-
-static int hclgevf_ring_space(struct hclgevf_cmq_ring *ring)
-{
-	int ntc = ring->next_to_clean;
-	int ntu = ring->next_to_use;
-	int used;
-
-	used = (ntu - ntc + ring->desc_num) % ring->desc_num;
-
-	return ring->desc_num - used - 1;
-}
-
-static int hclgevf_is_valid_csq_clean_head(struct hclgevf_cmq_ring *ring,
-					   int head)
-{
-	int ntu = ring->next_to_use;
-	int ntc = ring->next_to_clean;
-
-	if (ntu > ntc)
-		return head >= ntc && head <= ntu;
-
-	return head >= ntc || head <= ntu;
-}
-
-static int hclgevf_cmd_csq_clean(struct hclgevf_hw *hw)
-{
-	struct hclgevf_dev *hdev = container_of(hw, struct hclgevf_dev, hw);
-	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
-	int clean;
-	u32 head;
-
-	head = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG);
-	rmb(); /* Make sure head is ready before touch any data */
-
-	if (!hclgevf_is_valid_csq_clean_head(csq, head)) {
-		dev_warn(&hdev->pdev->dev, "wrong cmd head (%u, %d-%d)\n", head,
-			 csq->next_to_use, csq->next_to_clean);
-		dev_warn(&hdev->pdev->dev,
-			 "Disabling any further commands to IMP firmware\n");
-		set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
-		return -EIO;
-	}
-
-	clean = (head - csq->next_to_clean + csq->desc_num) % csq->desc_num;
-	csq->next_to_clean = head;
-	return clean;
-}
-
-static bool hclgevf_cmd_csq_done(struct hclgevf_hw *hw)
-{
-	u32 head;
-
-	head = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG);
-
-	return head == hw->cmq.csq.next_to_use;
-}
-
-static bool hclgevf_is_special_opcode(u16 opcode)
+static void hclgevf_cmd_config_regs(struct hclgevf_hw *hw,
+				    struct hclge_comm_cmq_ring *ring)
 {
-	const u16 spec_opcode[] = {0x30, 0x31, 0x32};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
-		if (spec_opcode[i] == opcode)
-			return true;
-	}
-
-	return false;
-}
-
-static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
-{
-	struct hclgevf_dev *hdev = ring->dev;
-	struct hclgevf_hw *hw = &hdev->hw;
 	u32 reg_val;
 
-	if (ring->flag == HCLGEVF_TYPE_CSQ) {
+	if (ring->ring_type == HCLGEVF_TYPE_CSQ) {
 		reg_val = lower_32_bits(ring->desc_dma_addr);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_L_REG, reg_val);
 		reg_val = upper_32_bits(ring->desc_dma_addr);
@@ -117,15 +45,15 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 
 static void hclgevf_cmd_init_regs(struct hclgevf_hw *hw)
 {
-	hclgevf_cmd_config_regs(&hw->cmq.csq);
-	hclgevf_cmd_config_regs(&hw->cmq.crq);
+	hclgevf_cmd_config_regs(hw, &hw->hw.cmq.csq);
+	hclgevf_cmd_config_regs(hw, &hw->hw.cmq.crq);
 }
 
-static int hclgevf_alloc_cmd_desc(struct hclgevf_cmq_ring *ring)
+static int hclgevf_alloc_cmd_desc(struct hclge_comm_cmq_ring *ring)
 {
 	int size = ring->desc_num * sizeof(struct hclge_desc);
 
-	ring->desc = dma_alloc_coherent(cmq_ring_to_dev(ring), size,
+	ring->desc = dma_alloc_coherent(&ring->pdev->dev, size,
 					&ring->desc_dma_addr, GFP_KERNEL);
 	if (!ring->desc)
 		return -ENOMEM;
@@ -133,12 +61,12 @@ static int hclgevf_alloc_cmd_desc(struct hclgevf_cmq_ring *ring)
 	return 0;
 }
 
-static void hclgevf_free_cmd_desc(struct hclgevf_cmq_ring *ring)
+static void hclgevf_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
 {
 	int size  = ring->desc_num * sizeof(struct hclge_desc);
 
 	if (ring->desc) {
-		dma_free_coherent(cmq_ring_to_dev(ring), size,
+		dma_free_coherent(&ring->pdev->dev, size,
 				  ring->desc, ring->desc_dma_addr);
 		ring->desc = NULL;
 	}
@@ -147,12 +75,13 @@ static void hclgevf_free_cmd_desc(struct hclgevf_cmq_ring *ring)
 static int hclgevf_alloc_cmd_queue(struct hclgevf_dev *hdev, int ring_type)
 {
 	struct hclgevf_hw *hw = &hdev->hw;
-	struct hclgevf_cmq_ring *ring =
-		(ring_type == HCLGEVF_TYPE_CSQ) ? &hw->cmq.csq : &hw->cmq.crq;
+	struct hclge_comm_cmq_ring *ring =
+		(ring_type == HCLGEVF_TYPE_CSQ) ? &hw->hw.cmq.csq :
+						  &hw->hw.cmq.crq;
 	int ret;
 
-	ring->dev = hdev;
-	ring->flag = ring_type;
+	ring->pdev = hdev->pdev;
+	ring->ring_type = ring_type;
 
 	/* allocate CSQ/CRQ descriptor */
 	ret = hclgevf_alloc_cmd_desc(ring);
@@ -176,113 +105,6 @@ void hclgevf_cmd_setup_basic_desc(struct hclge_desc *desc,
 		desc->flag &= cpu_to_le16(~HCLGEVF_CMD_FLAG_WR);
 }
 
-struct vf_errcode {
-	u32 imp_errcode;
-	int common_errno;
-};
-
-static void hclgevf_cmd_copy_desc(struct hclgevf_hw *hw,
-				  struct hclge_desc *desc, int num)
-{
-	struct hclge_desc *desc_to_use;
-	int handle = 0;
-
-	while (handle < num) {
-		desc_to_use = &hw->cmq.csq.desc[hw->cmq.csq.next_to_use];
-		*desc_to_use = desc[handle];
-		(hw->cmq.csq.next_to_use)++;
-		if (hw->cmq.csq.next_to_use == hw->cmq.csq.desc_num)
-			hw->cmq.csq.next_to_use = 0;
-		handle++;
-	}
-}
-
-static int hclgevf_cmd_convert_err_code(u16 desc_ret)
-{
-	struct vf_errcode hclgevf_cmd_errcode[] = {
-		{HCLGEVF_CMD_EXEC_SUCCESS, 0},
-		{HCLGEVF_CMD_NO_AUTH, -EPERM},
-		{HCLGEVF_CMD_NOT_SUPPORTED, -EOPNOTSUPP},
-		{HCLGEVF_CMD_QUEUE_FULL, -EXFULL},
-		{HCLGEVF_CMD_NEXT_ERR, -ENOSR},
-		{HCLGEVF_CMD_UNEXE_ERR, -ENOTBLK},
-		{HCLGEVF_CMD_PARA_ERR, -EINVAL},
-		{HCLGEVF_CMD_RESULT_ERR, -ERANGE},
-		{HCLGEVF_CMD_TIMEOUT, -ETIME},
-		{HCLGEVF_CMD_HILINK_ERR, -ENOLINK},
-		{HCLGEVF_CMD_QUEUE_ILLEGAL, -ENXIO},
-		{HCLGEVF_CMD_INVALID, -EBADR},
-	};
-	u32 errcode_count = ARRAY_SIZE(hclgevf_cmd_errcode);
-	u32 i;
-
-	for (i = 0; i < errcode_count; i++)
-		if (hclgevf_cmd_errcode[i].imp_errcode == desc_ret)
-			return hclgevf_cmd_errcode[i].common_errno;
-
-	return -EIO;
-}
-
-static int hclgevf_cmd_check_retval(struct hclgevf_hw *hw,
-				    struct hclge_desc *desc, int num, int ntc)
-{
-	u16 opcode, desc_ret;
-	int handle;
-
-	opcode = le16_to_cpu(desc[0].opcode);
-	for (handle = 0; handle < num; handle++) {
-		/* Get the result of hardware write back */
-		desc[handle] = hw->cmq.csq.desc[ntc];
-		ntc++;
-		if (ntc == hw->cmq.csq.desc_num)
-			ntc = 0;
-	}
-	if (likely(!hclgevf_is_special_opcode(opcode)))
-		desc_ret = le16_to_cpu(desc[num - 1].retval);
-	else
-		desc_ret = le16_to_cpu(desc[0].retval);
-	hw->cmq.last_status = desc_ret;
-
-	return hclgevf_cmd_convert_err_code(desc_ret);
-}
-
-static int hclgevf_cmd_check_result(struct hclgevf_hw *hw,
-				    struct hclge_desc *desc, int num, int ntc)
-{
-	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
-	bool is_completed = false;
-	u32 timeout = 0;
-	int handle, ret;
-
-	/* If the command is sync, wait for the firmware to write back,
-	 * if multi descriptors to be sent, use the first one to check
-	 */
-	if (HCLGEVF_SEND_SYNC(le16_to_cpu(desc->flag))) {
-		do {
-			if (hclgevf_cmd_csq_done(hw)) {
-				is_completed = true;
-				break;
-			}
-			udelay(1);
-			timeout++;
-		} while (timeout < hw->cmq.tx_timeout);
-	}
-
-	if (!is_completed)
-		ret = -EBADE;
-	else
-		ret = hclgevf_cmd_check_retval(hw, desc, num, ntc);
-
-	/* Clean the command send queue */
-	handle = hclgevf_cmd_csq_clean(hw);
-	if (handle < 0)
-		ret = handle;
-	else if (handle != num)
-		dev_warn(&hdev->pdev->dev,
-			 "cleaned %d, need to clean %d\n", handle, num);
-	return ret;
-}
-
 /* hclgevf_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
  * @desc: prefilled descriptor for describing the command
@@ -293,44 +115,7 @@ static int hclgevf_cmd_check_result(struct hclgevf_hw *hw,
  */
 int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
 {
-	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
-	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
-	int ret;
-	int ntc;
-
-	spin_lock_bh(&hw->cmq.csq.lock);
-
-	if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state)) {
-		spin_unlock_bh(&hw->cmq.csq.lock);
-		return -EBUSY;
-	}
-
-	if (num > hclgevf_ring_space(&hw->cmq.csq)) {
-		/* If CMDQ ring is full, SW HEAD and HW HEAD may be different,
-		 * need update the SW HEAD pointer csq->next_to_clean
-		 */
-		csq->next_to_clean = hclgevf_read_dev(hw,
-						      HCLGEVF_NIC_CSQ_HEAD_REG);
-		spin_unlock_bh(&hw->cmq.csq.lock);
-		return -EBUSY;
-	}
-
-	/* Record the location of desc in the ring for this time
-	 * which will be use for hardware to write back
-	 */
-	ntc = hw->cmq.csq.next_to_use;
-
-	hclgevf_cmd_copy_desc(hw, desc, num);
-
-	/* Write to hardware */
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG,
-			  hw->cmq.csq.next_to_use);
-
-	ret = hclgevf_cmd_check_result(hw, desc, num, ntc);
-
-	spin_unlock_bh(&hw->cmq.csq.lock);
-
-	return ret;
+	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
 }
 
 static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
@@ -404,15 +189,17 @@ static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 
 int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 {
+	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
 	int ret;
 
 	/* Setup the lock for command queue */
-	spin_lock_init(&hdev->hw.cmq.csq.lock);
-	spin_lock_init(&hdev->hw.cmq.crq.lock);
+	spin_lock_init(&cmdq->csq.lock);
+	spin_lock_init(&cmdq->crq.lock);
 
-	hdev->hw.cmq.tx_timeout = HCLGEVF_CMDQ_TX_TIMEOUT;
-	hdev->hw.cmq.csq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
-	hdev->hw.cmq.crq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
+	cmdq->csq.pdev = hdev->pdev;
+	cmdq->tx_timeout = HCLGEVF_CMDQ_TX_TIMEOUT;
+	cmdq->csq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
+	cmdq->crq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
 
 	ret = hclgevf_alloc_cmd_queue(hdev, HCLGEVF_TYPE_CSQ);
 	if (ret) {
@@ -430,7 +217,7 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 
 	return 0;
 err_csq:
-	hclgevf_free_cmd_desc(&hdev->hw.cmq.csq);
+	hclgevf_free_cmd_desc(&cmdq->csq);
 	return ret;
 }
 
@@ -456,27 +243,28 @@ static int hclgevf_firmware_compat_config(struct hclgevf_dev *hdev, bool en)
 int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
 	int ret;
 
-	spin_lock_bh(&hdev->hw.cmq.csq.lock);
-	spin_lock(&hdev->hw.cmq.crq.lock);
+	spin_lock_bh(&cmdq->csq.lock);
+	spin_lock(&cmdq->crq.lock);
 
 	/* initialize the pointers of async rx queue of mailbox */
 	hdev->arq.hdev = hdev;
 	hdev->arq.head = 0;
 	hdev->arq.tail = 0;
 	atomic_set(&hdev->arq.count, 0);
-	hdev->hw.cmq.csq.next_to_clean = 0;
-	hdev->hw.cmq.csq.next_to_use = 0;
-	hdev->hw.cmq.crq.next_to_clean = 0;
-	hdev->hw.cmq.crq.next_to_use = 0;
+	cmdq->csq.next_to_clean = 0;
+	cmdq->csq.next_to_use = 0;
+	cmdq->crq.next_to_clean = 0;
+	cmdq->crq.next_to_use = 0;
 
 	hclgevf_cmd_init_regs(&hdev->hw);
 
-	spin_unlock(&hdev->hw.cmq.crq.lock);
-	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
+	spin_unlock(&cmdq->crq.lock);
+	spin_unlock_bh(&cmdq->csq.lock);
 
-	clear_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	clear_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 
 	/* Check if there is new reset pending, because the higher level
 	 * reset may happen when lower level reset is being processed.
@@ -518,7 +306,7 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	return 0;
 
 err_cmd_init:
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 
 	return ret;
 }
@@ -539,18 +327,20 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
+	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
 	hclgevf_firmware_compat_config(hdev, false);
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
+
 	/* wait to ensure that the firmware completes the possible left
 	 * over commands.
 	 */
 	msleep(HCLGEVF_CMDQ_CLEAR_WAIT_TIME);
-	spin_lock_bh(&hdev->hw.cmq.csq.lock);
-	spin_lock(&hdev->hw.cmq.crq.lock);
+	spin_lock_bh(&cmdq->csq.lock);
+	spin_lock(&cmdq->crq.lock);
 	hclgevf_cmd_uninit_regs(&hdev->hw);
-	spin_unlock(&hdev->hw.cmq.crq.lock);
-	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
+	spin_unlock(&cmdq->crq.lock);
+	spin_unlock_bh(&cmdq->csq.lock);
 
-	hclgevf_free_cmd_desc(&hdev->hw.cmq.csq);
-	hclgevf_free_cmd_desc(&hdev->hw.cmq.crq);
+	hclgevf_free_cmd_desc(&cmdq->csq);
+	hclgevf_free_cmd_desc(&cmdq->crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index cb33eb806e78..89ad11ce0381 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -22,57 +22,6 @@ struct hclgevf_firmware_compat_cmd {
 	u8 rsv[20];
 };
 
-struct hclgevf_desc_cb {
-	dma_addr_t dma;
-	void *va;
-	u32 length;
-};
-
-struct hclgevf_cmq_ring {
-	dma_addr_t desc_dma_addr;
-	struct hclge_desc *desc;
-	struct hclgevf_desc_cb *desc_cb;
-	struct hclgevf_dev  *dev;
-	u32 head;
-	u32 tail;
-
-	u16 buf_size;
-	u16 desc_num;
-	int next_to_use;
-	int next_to_clean;
-	u8 flag;
-	spinlock_t lock; /* Command queue lock */
-};
-
-enum hclgevf_cmd_return_status {
-	HCLGEVF_CMD_EXEC_SUCCESS	= 0,
-	HCLGEVF_CMD_NO_AUTH		= 1,
-	HCLGEVF_CMD_NOT_SUPPORTED	= 2,
-	HCLGEVF_CMD_QUEUE_FULL		= 3,
-	HCLGEVF_CMD_NEXT_ERR		= 4,
-	HCLGEVF_CMD_UNEXE_ERR		= 5,
-	HCLGEVF_CMD_PARA_ERR		= 6,
-	HCLGEVF_CMD_RESULT_ERR		= 7,
-	HCLGEVF_CMD_TIMEOUT		= 8,
-	HCLGEVF_CMD_HILINK_ERR		= 9,
-	HCLGEVF_CMD_QUEUE_ILLEGAL	= 10,
-	HCLGEVF_CMD_INVALID		= 11,
-};
-
-enum hclgevf_cmd_status {
-	HCLGEVF_STATUS_SUCCESS	= 0,
-	HCLGEVF_ERR_CSQ_FULL	= -1,
-	HCLGEVF_ERR_CSQ_TIMEOUT	= -2,
-	HCLGEVF_ERR_CSQ_ERROR	= -3
-};
-
-struct hclgevf_cmq {
-	struct hclgevf_cmq_ring csq;
-	struct hclgevf_cmq_ring crq;
-	u16 tx_timeout; /* Tx timeout */
-	enum hclgevf_cmd_status last_status;
-};
-
 #define HCLGEVF_CMD_FLAG_IN_VALID_SHIFT		0
 #define HCLGEVF_CMD_FLAG_OUT_VALID_SHIFT	1
 #define HCLGEVF_CMD_FLAG_NEXT_SHIFT		2
@@ -304,26 +253,6 @@ struct hclgevf_caps_bit_map {
 	u16 local_bit;
 };
 
-static inline void hclgevf_write_reg(void __iomem *base, u32 reg, u32 value)
-{
-	writel(value, base + reg);
-}
-
-static inline u32 hclgevf_read_reg(u8 __iomem *base, u32 reg)
-{
-	u8 __iomem *reg_addr = READ_ONCE(base);
-
-	return readl(reg_addr + reg);
-}
-
-#define hclgevf_write_dev(a, reg, value) \
-	hclgevf_write_reg((a)->io_base, reg, value)
-#define hclgevf_read_dev(a, reg) \
-	hclgevf_read_reg((a)->io_base, reg)
-
-#define HCLGEVF_SEND_SYNC(flag) \
-	((flag) & HCLGEVF_CMD_FLAG_NO_INTR)
-
 int hclgevf_cmd_init(struct hclgevf_dev *hdev);
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev);
 int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 28bdc9e38110..30eafb6251c6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -420,11 +420,11 @@ static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 		 * HCLGEVF_TQP_MAX_SIZE_DEV_V2.
 		 */
 		if (i < HCLGEVF_TQP_MAX_SIZE_DEV_V2)
-			tqp->q.io_base = hdev->hw.io_base +
+			tqp->q.io_base = hdev->hw.hw.io_base +
 					 HCLGEVF_TQP_REG_OFFSET +
 					 i * HCLGEVF_TQP_REG_SIZE;
 		else
-			tqp->q.io_base = hdev->hw.io_base +
+			tqp->q.io_base = hdev->hw.hw.io_base +
 					 HCLGEVF_TQP_REG_OFFSET +
 					 HCLGEVF_TQP_EXT_REG_OFFSET +
 					 (i - HCLGEVF_TQP_MAX_SIZE_DEV_V2) *
@@ -539,7 +539,7 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 	nic->pdev = hdev->pdev;
 	nic->numa_node_mask = hdev->numa_node_mask;
 	nic->flags |= HNAE3_SUPPORT_VF;
-	nic->kinfo.io_base = hdev->hw.io_base;
+	nic->kinfo.io_base = hdev->hw.hw.io_base;
 
 	ret = hclgevf_knic_setup(hdev);
 	if (ret)
@@ -576,7 +576,7 @@ static int hclgevf_get_vector(struct hnae3_handle *handle, u16 vector_num,
 		for (i = HCLGEVF_MISC_VECTOR_NUM + 1; i < hdev->num_msi; i++) {
 			if (hdev->vector_status[i] == HCLGEVF_INVALID_VPORT) {
 				vector->vector = pci_irq_vector(hdev->pdev, i);
-				vector->io_addr = hdev->hw.io_base +
+				vector->io_addr = hdev->hw.hw.io_base +
 					HCLGEVF_VECTOR_REG_BASE +
 					(i - 1) * HCLGEVF_VECTOR_REG_OFFSET;
 				hdev->vector_status[i] = 0;
@@ -1862,13 +1862,13 @@ static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 	int ret;
 
 	if (hdev->reset_type == HNAE3_VF_RESET)
-		ret = readl_poll_timeout(hdev->hw.io_base +
+		ret = readl_poll_timeout(hdev->hw.hw.io_base +
 					 HCLGEVF_VF_RST_ING, val,
 					 !(val & HCLGEVF_VF_RST_ING_BIT),
 					 HCLGEVF_RESET_WAIT_US,
 					 HCLGEVF_RESET_WAIT_TIMEOUT_US);
 	else
-		ret = readl_poll_timeout(hdev->hw.io_base +
+		ret = readl_poll_timeout(hdev->hw.hw.io_base +
 					 HCLGEVF_RST_ING, val,
 					 !(val & HCLGEVF_RST_ING_BITS),
 					 HCLGEVF_RESET_WAIT_US,
@@ -1951,7 +1951,7 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 		hdev->rst_stats.vf_func_rst_cnt++;
 	}
 
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 	/* inform hardware that preparatory work is done */
 	msleep(HCLGEVF_RESET_SYNC_TIME);
 	hclgevf_reset_handshake(hdev, true);
@@ -2219,7 +2219,7 @@ static void hclgevf_get_misc_vector(struct hclgevf_dev *hdev)
 
 	vector->vector_irq = pci_irq_vector(hdev->pdev,
 					    HCLGEVF_MISC_VECTOR_NUM);
-	vector->addr = hdev->hw.io_base + HCLGEVF_MISC_VECTOR_REG_BASE;
+	vector->addr = hdev->hw.hw.io_base + HCLGEVF_MISC_VECTOR_REG_BASE;
 	/* vector status always valid for Vector 0 */
 	hdev->vector_status[HCLGEVF_MISC_VECTOR_NUM] = 0;
 	hdev->vector_irq[HCLGEVF_MISC_VECTOR_NUM] = vector->vector_irq;
@@ -2340,7 +2340,7 @@ static void hclgevf_keep_alive(struct hclgevf_dev *hdev)
 	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
-	if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state))
+	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
 		return;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_KEEP_ALIVE, 0);
@@ -2435,7 +2435,7 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 			 "receive reset interrupt 0x%x!\n", rst_ing_reg);
 		set_bit(HNAE3_VF_RESET, &hdev->reset_pending);
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
-		set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 		*clearval = ~(1U << HCLGEVF_VECTOR0_RST_INT_B);
 		hdev->rst_stats.vf_rst_cnt++;
 		/* set up VF hardware reset status, its PF will clear
@@ -2559,8 +2559,8 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 	roce->rinfo.base_vector = hdev->roce_base_msix_offset;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
-	roce->rinfo.roce_io_base = hdev->hw.io_base;
-	roce->rinfo.roce_mem_base = hdev->hw.mem_base;
+	roce->rinfo.roce_io_base = hdev->hw.hw.io_base;
+	roce->rinfo.roce_mem_base = hdev->hw.hw.mem_base;
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
@@ -3042,11 +3042,11 @@ static int hclgevf_dev_mem_map(struct hclgevf_dev *hdev)
 	if (!(pci_select_bars(pdev, IORESOURCE_MEM) & BIT(HCLGEVF_MEM_BAR)))
 		return 0;
 
-	hw->mem_base = devm_ioremap_wc(&pdev->dev,
-				       pci_resource_start(pdev,
-							  HCLGEVF_MEM_BAR),
-				       pci_resource_len(pdev, HCLGEVF_MEM_BAR));
-	if (!hw->mem_base) {
+	hw->hw.mem_base =
+		devm_ioremap_wc(&pdev->dev,
+				pci_resource_start(pdev, HCLGEVF_MEM_BAR),
+				pci_resource_len(pdev, HCLGEVF_MEM_BAR));
+	if (!hw->hw.mem_base) {
 		dev_err(&pdev->dev, "failed to map device memory\n");
 		return -EFAULT;
 	}
@@ -3080,9 +3080,8 @@ static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 
 	pci_set_master(pdev);
 	hw = &hdev->hw;
-	hw->hdev = hdev;
-	hw->io_base = pci_iomap(pdev, 2, 0);
-	if (!hw->io_base) {
+	hw->hw.io_base = pci_iomap(pdev, 2, 0);
+	if (!hw->hw.io_base) {
 		dev_err(&pdev->dev, "can't map configuration register space\n");
 		ret = -ENOMEM;
 		goto err_clr_master;
@@ -3095,7 +3094,7 @@ static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 	return 0;
 
 err_unmap_io_base:
-	pci_iounmap(pdev, hdev->hw.io_base);
+	pci_iounmap(pdev, hdev->hw.hw.io_base);
 err_clr_master:
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
@@ -3109,10 +3108,10 @@ static void hclgevf_pci_uninit(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 
-	if (hdev->hw.mem_base)
-		devm_iounmap(&pdev->dev, hdev->hw.mem_base);
+	if (hdev->hw.hw.mem_base)
+		devm_iounmap(&pdev->dev, hdev->hw.hw.mem_base);
 
-	pci_iounmap(pdev, hdev->hw.io_base);
+	pci_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -3703,7 +3702,7 @@ static bool hclgevf_get_cmdq_stat(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
-	return test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	return test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 }
 
 static bool hclgevf_ae_dev_resetting(struct hnae3_handle *handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index f6f736c0091c..ae90925c4f4b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -133,6 +133,11 @@
 
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
 
+#define hclgevf_read_dev(a, reg) \
+	hclge_comm_read_reg((a)->hw.io_base, reg)
+#define hclgevf_write_dev(a, reg, value) \
+	hclge_comm_write_reg((a)->hw.io_base, reg, value)
+
 enum hclgevf_evt_cause {
 	HCLGEVF_VECTOR0_EVENT_RST,
 	HCLGEVF_VECTOR0_EVENT_MBX,
@@ -154,7 +159,6 @@ enum hclgevf_states {
 	HCLGEVF_STATE_RST_HANDLING,
 	HCLGEVF_STATE_MBX_SERVICE_SCHED,
 	HCLGEVF_STATE_MBX_HANDLING,
-	HCLGEVF_STATE_CMD_DISABLE,
 	HCLGEVF_STATE_LINK_UPDATING,
 	HCLGEVF_STATE_PROMISC_CHANGED,
 	HCLGEVF_STATE_RST_FAIL,
@@ -173,12 +177,9 @@ struct hclgevf_mac {
 };
 
 struct hclgevf_hw {
-	void __iomem *io_base;
-	void __iomem *mem_base;
+	struct hclge_comm_hw hw;
 	int num_vec;
-	struct hclgevf_cmq cmq;
 	struct hclgevf_mac mac;
-	void *hdev; /* hchgevf device it is part of */
 };
 
 /* TQP stats */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 31cbdbae1faf..a1040bab9a10 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -53,7 +53,8 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 	}
 
 	while ((!hdev->mbx_resp.received_resp) && (i < HCLGEVF_MAX_TRY_TIMES)) {
-		if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state))
+		if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE,
+			     &hdev->hw.hw.comm_state))
 			return -EIO;
 
 		usleep_range(HCLGEVF_SLEEP_USECOND, HCLGEVF_SLEEP_USECOND * 2);
@@ -153,7 +154,7 @@ static bool hclgevf_cmd_crq_empty(struct hclgevf_hw *hw)
 {
 	u32 tail = hclgevf_read_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG);
 
-	return tail == hw->cmq.crq.next_to_use;
+	return tail == hw->hw.cmq.crq.next_to_use;
 }
 
 static void hclgevf_handle_mbx_response(struct hclgevf_dev *hdev,
@@ -212,14 +213,15 @@ static void hclgevf_handle_mbx_msg(struct hclgevf_dev *hdev,
 void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 {
 	struct hclge_mbx_pf_to_vf_cmd *req;
-	struct hclgevf_cmq_ring *crq;
+	struct hclge_comm_cmq_ring *crq;
 	struct hclge_desc *desc;
 	u16 flag;
 
-	crq = &hdev->hw.cmq.crq;
+	crq = &hdev->hw.hw.cmq.crq;
 
 	while (!hclgevf_cmd_crq_empty(&hdev->hw)) {
-		if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state)) {
+		if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE,
+			     &hdev->hw.hw.comm_state)) {
 			dev_info(&hdev->pdev->dev, "vf crq need init\n");
 			return;
 		}
@@ -296,7 +298,8 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 
 	/* process all the async queue messages */
 	while (tail != hdev->arq.head) {
-		if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state)) {
+		if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE,
+			     &hdev->hw.hw.comm_state)) {
 			dev_info(&hdev->pdev->dev,
 				 "vf crq need init in async\n");
 			return;
-- 
2.33.0

