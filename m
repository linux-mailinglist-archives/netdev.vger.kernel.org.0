Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA9621DDB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiKHUnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKHUnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:43:31 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9559667133;
        Tue,  8 Nov 2022 12:43:05 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8H0dR6008692;
        Tue, 8 Nov 2022 12:42:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=/OBQ5oCYUvTgf3RuyOtaODsXG86Y8XgO1poF4NRLeXI=;
 b=eS9M9picCwgqrXAN0ytb02NGWPSoqRy647knqfCQ4q5Q/W4YpWCla2k4xF3JZIOcdBXO
 HQma3QCScWXgaZVajm2oS50hjBvrO+iU78HZUCn9FrD/iAecu5+1VL+oq77wtWlGmu/K
 RKWGdul5zciABNsoiOnkgme7l3ALf4OQMrQ//fNz4dmG63w6x4Y3Mu+UuoxL/ijWg4ra
 nAvw5UsQbaPB7AV1QXpz59dgxdLIjxdIde0BG7sVCeJ4QrStT/fra9bclok/yVSKrzpH
 qHYPUgsvfvMabyMTCC8RpgB3gf+xiHIPX7l7u6Y+37XigBJwSP5E4xNLLM9nmhMWl2eE Hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kqu4vh07m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:42:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Nov
 2022 12:42:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Nov 2022 12:42:58 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 9515C3F710D;
        Tue,  8 Nov 2022 12:42:57 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 3/8] octeon_ep_vf: add VF-PF mailbox communication.
Date:   Tue, 8 Nov 2022 12:41:54 -0800
Message-ID: <20221108204209.23071-4-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dIgBsC4bX8tuFkkxVaFORZrQiuX-GtU1
X-Proofpoint-GUID: dIgBsC4bX8tuFkkxVaFORZrQiuX-GtU1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement VF-PF mailbox to send all control commands from VF to PF
and receive responses and notifications from PF to VF.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
 .../marvell/octeon_ep_vf/octep_vf_main.c      |  13 +
 .../marvell/octeon_ep_vf/octep_vf_main.h      |   1 +
 .../marvell/octeon_ep_vf/octep_vf_mbox.c      | 290 +++++++++++++++++-
 .../marvell/octeon_ep_vf/octep_vf_mbox.h      | 118 +++++++
 4 files changed, 421 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 0fc493bd0b02..9d1fc867bf5d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -183,6 +183,19 @@ static netdev_tx_t octep_vf_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+int octep_vf_get_link_info(struct octep_vf_device *oct)
+{
+	int ret, size;
+
+	ret = octep_vf_mbox_bulk_read(oct, OCTEP_PFVF_MBOX_CMD_GET_LINK_INFO,
+				      (u8 *)&oct->link_info, &size);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Get VF link info failed via VF Mbox\n");
+		return ret;
+	}
+	return 0;
+}
+
 /**
  * octep_vf_tx_timeout_task - work queue task to Handle Tx queue timeout.
  *
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
index 53e34c1a3b7b..7d0c18aa6f4d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
@@ -298,6 +298,7 @@ void octep_vf_oq_dbell_init(struct octep_vf_device *oct);
 void octep_vf_device_setup_cn93(struct octep_vf_device *oct);
 int octep_vf_iq_process_completions(struct octep_vf_iq *iq, u16 budget);
 int octep_vf_oq_process_rx(struct octep_vf_oq *oq, int budget);
+int octep_vf_get_link_info(struct octep_vf_device *oct);
 int octep_vf_get_if_stats(struct octep_vf_device *oct);
 void octep_vf_mbox_work(struct work_struct *work);
 #endif /* _OCTEP_VF_MAIN_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
index d44340fd9d56..931dadc14be2 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
@@ -41,29 +41,317 @@ void octep_vf_delete_mbox(struct octep_vf_device *oct)
 
 int octep_vf_mbox_version_check(struct octep_vf_device *oct)
 {
-	return 0;
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int ret;
+
+	cmd.u64 = 0;
+	cmd.s_version.opcode = OCTEP_PFVF_MBOX_CMD_VERSION;
+	cmd.s_version.version = OCTEP_VF_MBOX_VERSION;
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (!ret)
+		return 0;
+	if (ret == OCTEP_PFVF_MBOX_CMD_STATUS_NACK) {
+		dev_err(&oct->pdev->dev,
+			"VF Mbox version:%llu is not compatible with PF\n",
+			(u64)cmd.s_version.version);
+		dev_err(&oct->pdev->dev, "Upgrade driver to compatibale version\n");
+	}
+	return ret;
 }
 
 void octep_vf_mbox_work(struct work_struct *work)
 {
+	struct octep_vf_mbox_wk *wk = container_of(work, struct octep_vf_mbox_wk, work);
+	struct octep_vf_iface_link_info *link_info;
+	struct octep_vf_device *oct = NULL;
+	struct octep_vf_mbox *mbox = NULL;
+	u64 pf_vf_data;
+
+	oct = (struct octep_vf_device *)wk->ctxptr;
+	link_info = &oct->link_info;
+	mbox = oct->mbox;
+	pf_vf_data = readq(mbox->mbox_read_reg);
+	if (!(pf_vf_data & OCTEP_PFVF_LINK_STATUS_DOWN))
+		link_info->oper_up = OCTEP_PFVF_LINK_STATUS_DOWN;
+	else if (pf_vf_data & OCTEP_PFVF_LINK_STATUS_UP)
+		link_info->oper_up = OCTEP_PFVF_LINK_STATUS_UP;
+}
+
+inline void octep_vf_mbox_set_state(struct octep_vf_mbox *mbox, enum octep_pfvf_mbox_state state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mbox->lock, flags);
+	mbox->state = state;
+	spin_unlock_irqrestore(&mbox->lock, flags);
+}
+
+static enum octep_pfvf_mbox_state octep_vf_mbox_get_state(struct octep_vf_mbox *mbox)
+{
+	enum octep_pfvf_mbox_state state;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mbox->lock, flags);
+	state = mbox->state;
+	spin_unlock_irqrestore(&mbox->lock, flags);
+	return state;
+}
+
+static int __octep_vf_mbox_send_cmd(struct octep_vf_device *oct,
+				    union octep_pfvf_mbox_word cmd,
+				    union octep_pfvf_mbox_word *rsp)
+{
+	long timeout = OCTEP_PFVF_MBOX_WRITE_WAIT_TIME;
+	struct octep_vf_mbox *mbox = oct->mbox;
+	u64 reg_val = 0ull;
+	int count;
+
+	if (!mbox)
+		return OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP;
+
+	cmd.s.type = OCTEP_PFVF_MBOX_TYPE_CMD;
+	writeq(cmd.u64, mbox->mbox_write_reg);
+	for (count = 0; count < OCTEP_PFVF_MBOX_TIMEOUT_MS; count++) {
+		schedule_timeout_uninterruptible(timeout);
+		reg_val = readq(mbox->mbox_write_reg);
+		if (reg_val != cmd.u64) {
+			rsp->u64 = reg_val;
+			break;
+		}
+	}
+	if (count == OCTEP_PFVF_MBOX_TIMEOUT_MS) {
+		dev_err(&oct->pdev->dev, "mbox send command timed out\n");
+		return OCTEP_PFVF_MBOX_CMD_STATUS_TIMEDOUT;
+	}
+	if (rsp->s.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "mbox_send: Received NACK\n");
+		return OCTEP_PFVF_MBOX_CMD_STATUS_NACK;
+	}
+	rsp->u64 = reg_val;
+	return 0;
+}
+
+int octep_vf_mbox_send_cmd(struct octep_vf_device *oct, union octep_pfvf_mbox_word cmd,
+			   union octep_pfvf_mbox_word *rsp)
+{
+	struct octep_vf_mbox *mbox = oct->mbox;
+	int ret;
+
+	if (!mbox)
+		return OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP;
+	if (octep_vf_mbox_get_state(mbox) == OCTEP_PFVF_MBOX_STATE_BUSY)
+		return OCTEP_PFVF_MBOX_CMD_STATUS_BUSY;
+
+	octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_BUSY);
+	ret = __octep_vf_mbox_send_cmd(oct, cmd, rsp);
+	octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_IDLE);
+	return ret;
+}
+
+int octep_vf_mbox_bulk_read(struct octep_vf_device *oct, enum octep_pfvf_mbox_opcode opcode,
+			    u8 *data, int *size)
+{
+	struct octep_vf_mbox *mbox = oct->mbox;
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int data_len = 0, tmp_len = 0;
+	int read_cnt, i = 0, ret;
+
+	if (!mbox)
+		return OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP;
+
+	if (octep_vf_mbox_get_state(mbox) == OCTEP_PFVF_MBOX_STATE_BUSY)
+		return OCTEP_PFVF_MBOX_CMD_STATUS_BUSY;
+
+	octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_BUSY);
+	cmd.u64 = 0;
+	cmd.s_data.opcode = opcode;
+	cmd.s_data.frag = 0;
+	/* Send cmd to read data from PF */
+	ret = __octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "send mbox cmd fail for data request\n");
+		octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_IDLE);
+		return ret;
+	}
+	/*  PF sends the data length of requested CMD
+	 *  in  ACK
+	 */
+	data_len = *((int32_t *)rsp.s_data.data);
+	tmp_len = data_len;
+	cmd.u64 = 0;
+	rsp.u64 = 0;
+	cmd.s_data.opcode = opcode;
+	cmd.s_data.frag = 1;
+	while (data_len) {
+		ret = __octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+		if (ret) {
+			dev_err(&oct->pdev->dev, "send mbox cmd fail for data request\n");
+			octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_IDLE);
+			mbox->mbox_data.data_index = 0;
+			memset(mbox->mbox_data.recv_data, 0, OCTEP_PFVF_MBOX_MAX_DATA_BUF_SIZE);
+			return ret;
+		}
+		if (data_len > OCTEP_PFVF_MBOX_MAX_DATA_SIZE) {
+			data_len -= OCTEP_PFVF_MBOX_MAX_DATA_SIZE;
+			read_cnt = OCTEP_PFVF_MBOX_MAX_DATA_SIZE;
+		} else {
+			read_cnt = data_len;
+			data_len = 0;
+		}
+		for (i = 0; i < read_cnt; i++) {
+			mbox->mbox_data.recv_data[mbox->mbox_data.data_index] =
+				rsp.s_data.data[i];
+			mbox->mbox_data.data_index++;
+		}
+		cmd.u64 = 0;
+		rsp.u64 = 0;
+		cmd.s_data.opcode = opcode;
+		cmd.s_data.frag = 1;
+	}
+	memcpy(data, mbox->mbox_data.recv_data, tmp_len);
+	*size = tmp_len;
+	mbox->mbox_data.data_index = 0;
+	memset(mbox->mbox_data.recv_data, 0, OCTEP_PFVF_MBOX_MAX_DATA_BUF_SIZE);
+	octep_vf_mbox_set_state(mbox, OCTEP_PFVF_MBOX_STATE_IDLE);
+	return 0;
+}
+
+int octep_vf_mbox_set_mtu(struct octep_vf_device *oct, int mtu)
+{
+	int frame_size = mtu + ETH_HLEN + ETH_FCS_LEN;
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int ret = 0;
+
+	if (mtu < ETH_MIN_MTU || frame_size > ETH_MAX_MTU) {
+		dev_err(&oct->pdev->dev,
+			"Failed to set MTU to %d MIN MTU:%d MAX MTU:%d\n",
+			mtu, ETH_MIN_MTU, ETH_MAX_MTU);
+		return -EINVAL;
+	}
+
+	cmd.u64 = 0;
+	cmd.s_set_mtu.opcode = OCTEP_PFVF_MBOX_CMD_SET_MTU;
+	cmd.s_set_mtu.mtu = mtu;
+
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Mbox send failed; err=%d\n", ret);
+		return ret;
+	}
+	if (rsp.s_set_mtu.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "Received Mbox NACK from PF for MTU:%d\n", mtu);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int octep_vf_mbox_set_mac_addr(struct octep_vf_device *oct, char *mac_addr)
+{
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int i, ret;
+
+	cmd.u64 = 0;
+	cmd.s_set_mac.opcode = OCTEP_PFVF_MBOX_CMD_SET_MAC_ADDR;
+	for (i = 0; i < ETH_ALEN; i++)
+		cmd.s_set_mac.mac_addr[i] = mac_addr[i];
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Mbox send failed; err = %d\n", ret);
+		return ret;
+	}
+	if (rsp.s_set_mac.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "received NACK\n");
+		return -EINVAL;
+	}
+	return 0;
 }
 
 int octep_vf_mbox_get_mac_addr(struct octep_vf_device *oct, char *mac_addr)
 {
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int i, ret;
+
+	cmd.u64 = 0;
+	cmd.s_set_mac.opcode = OCTEP_PFVF_MBOX_CMD_GET_MAC_ADDR;
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "get_mac: mbox send failed; err = %d\n", ret);
+		return ret;
+	}
+	if (rsp.s_set_mac.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "get_mac: received NACK\n");
+		return -EINVAL;
+	}
+	for (i = 0; i < ETH_ALEN; i++)
+		mac_addr[i] = rsp.s_set_mac.mac_addr[i];
 	return 0;
 }
 
 int octep_vf_mbox_set_rx_state(struct octep_vf_device *oct, bool state)
 {
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int ret;
+
+	cmd.u64 = 0;
+	cmd.s_link_state.opcode = OCTEP_PFVF_MBOX_CMD_SET_RX_STATE;
+	cmd.s_link_state.state = state;
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Set Rx state via VF Mbox send failed\n");
+		return ret;
+	}
+	if (rsp.s_link_state.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "Set Rx state received NACK\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
 int octep_vf_mbox_set_link_status(struct octep_vf_device *oct, bool status)
 {
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int ret;
+
+	cmd.u64 = 0;
+	cmd.s_link_status.opcode = OCTEP_PFVF_MBOX_CMD_SET_LINK_STATUS;
+	cmd.s_link_status.status = status;
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Set link status via VF Mbox send failed\n");
+		return ret;
+	}
+	if (rsp.s_link_status.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "Set link status received NACK\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
 int octep_vf_mbox_get_link_status(struct octep_vf_device *oct, u8 *oper_up)
 {
+	union octep_pfvf_mbox_word cmd;
+	union octep_pfvf_mbox_word rsp;
+	int ret;
+
+	cmd.u64 = 0;
+	cmd.s_link_status.opcode = OCTEP_PFVF_MBOX_CMD_GET_LINK_STATUS;
+	ret = octep_vf_mbox_send_cmd(oct, cmd, &rsp);
+	if (ret) {
+		dev_err(&oct->pdev->dev, "Get link status via VF Mbox send failed\n");
+		return ret;
+	}
+	if (rsp.s_link_status.type != OCTEP_PFVF_MBOX_TYPE_RSP_ACK) {
+		dev_err(&oct->pdev->dev, "Get link status received NACK\n");
+		return -EINVAL;
+	}
+	*oper_up = rsp.s_link_status.status;
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.h
index f7a3c03a72e4..d3b975216fcd 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.h
@@ -7,10 +7,128 @@
 #ifndef _OCTEP_VF_MBOX_H_
 #define _OCTEP_VF_MBOX_H_
 
+#define OCTEP_VF_MBOX_VERSION 0
+
+enum octep_pfvf_mbox_opcode {
+	OCTEP_PFVF_MBOX_CMD_VERSION,
+	OCTEP_PFVF_MBOX_CMD_SET_MTU,
+	OCTEP_PFVF_MBOX_CMD_SET_MAC_ADDR,
+	OCTEP_PFVF_MBOX_CMD_GET_MAC_ADDR,
+	OCTEP_PFVF_MBOX_CMD_GET_LINK_INFO,
+	OCTEP_PFVF_MBOX_CMD_GET_STATS,
+	OCTEP_PFVF_MBOX_CMD_SET_RX_STATE,
+	OCTEP_PFVF_MBOX_CMD_SET_LINK_STATUS,
+	OCTEP_PFVF_MBOX_CMD_GET_LINK_STATUS,
+	OCTEP_PFVF_MBOX_CMD_LAST,
+};
+
+enum octep_pfvf_mbox_word_type {
+	OCTEP_PFVF_MBOX_TYPE_CMD,
+	OCTEP_PFVF_MBOX_TYPE_RSP_ACK,
+	OCTEP_PFVF_MBOX_TYPE_RSP_NACK,
+};
+
+enum octep_pfvf_mbox_cmd_status {
+	OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP = 1,
+	OCTEP_PFVF_MBOX_CMD_STATUS_TIMEDOUT = 2,
+	OCTEP_PFVF_MBOX_CMD_STATUS_NACK = 3,
+	OCTEP_PFVF_MBOX_CMD_STATUS_BUSY = 4
+};
+
+enum octep_pfvf_mbox_state {
+	OCTEP_PFVF_MBOX_STATE_IDLE = 0,
+	OCTEP_PFVF_MBOX_STATE_BUSY = 1,
+};
+
+enum octep_pfvf_link_status {
+	OCTEP_PFVF_LINK_STATUS_DOWN,
+	OCTEP_PFVF_LINK_STATUS_UP,
+};
+
+enum octep_pfvf_link_speed {
+	OCTEP_PFVF_LINK_SPEED_NONE,
+	OCTEP_PFVF_LINK_SPEED_1000,
+	OCTEP_PFVF_LINK_SPEED_10000,
+	OCTEP_PFVF_LINK_SPEED_25000,
+	OCTEP_PFVF_LINK_SPEED_40000,
+	OCTEP_PFVF_LINK_SPEED_50000,
+	OCTEP_PFVF_LINK_SPEED_100000,
+	OCTEP_PFVF_LINK_SPEED_LAST,
+};
+
+enum octep_pfvf_link_duplex {
+	OCTEP_PFVF_LINK_HALF_DUPLEX,
+	OCTEP_PFVF_LINK_FULL_DUPLEX,
+};
+
+enum octep_pfvf_link_autoneg {
+	OCTEP_PFVF_LINK_AUTONEG,
+	OCTEP_PFVF_LINK_FIXED,
+};
+
+#define OCTEP_PFVF_MBOX_TIMEOUT_MS     500
+#define OCTEP_PFVF_MBOX_MAX_RETRIES    2
+#define OCTEP_PFVF_MBOX_VERSION        0
+#define OCTEP_PFVF_MBOX_MAX_DATA_SIZE  6
 #define OCTEP_PFVF_MBOX_MAX_DATA_BUF_SIZE 256
+#define OCTEP_PFVF_MBOX_MORE_FRAG_FLAG 1
+#define OCTEP_PFVF_MBOX_WRITE_WAIT_TIME msecs_to_jiffies(1)
+
+union octep_pfvf_mbox_word {
+	u64 u64;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 data:48;
+	} s;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 frag:1;
+		u64 rsvd:5;
+		u8 data[6];
+	} s_data;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 version:48;
+	} s_version;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u8 mac_addr[6];
+	} s_set_mac;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 mtu:48;
+	} s_set_mtu;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 state:1;
+		u64 rsvd:53;
+	} s_link_state;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 status:1;
+		u64 rsvd:53;
+	} s_link_status;
+} __packed;
 
 int octep_vf_setup_mbox(struct octep_vf_device *oct);
 void octep_vf_delete_mbox(struct octep_vf_device *oct);
+int octep_vf_mbox_send_cmd(struct octep_vf_device *oct, union octep_pfvf_mbox_word cmd,
+			   union octep_pfvf_mbox_word *rsp);
+int octep_vf_mbox_bulk_read(struct octep_vf_device *oct, enum octep_pfvf_mbox_opcode opcode,
+			    u8 *data, int *size);
+int octep_vf_mbox_set_mtu(struct octep_vf_device *oct, int mtu);
+int octep_vf_mbox_set_mac_addr(struct octep_vf_device *oct, char *mac_addr);
 int octep_vf_mbox_get_mac_addr(struct octep_vf_device *oct, char *mac_addr);
 int octep_vf_mbox_version_check(struct octep_vf_device *oct);
 int octep_vf_mbox_set_rx_state(struct octep_vf_device *oct, bool state);
-- 
2.36.0

