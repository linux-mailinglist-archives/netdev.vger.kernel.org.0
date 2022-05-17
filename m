Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD0529FD1
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344569AbiEQK42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344652AbiEQK4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:56:09 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8BE2942EDD;
        Tue, 17 May 2022 03:56:00 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [124.236.130.193])
        by mail-app4 (Coremail) with SMTP id cS_KCgB3yOAff4NiIzBaAA--.7931S2;
        Tue, 17 May 2022 18:55:41 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, krzysztof.kozlowski@linaro.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v2] NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
Date:   Tue, 17 May 2022 18:55:26 +0800
Message-Id: <20220517105526.114421-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgB3yOAff4NiIzBaAA--.7931S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AF4kGF17ZFyfArWUGw1fCrg_yoW7Cr4rpa
        9YgFy3ArZ5Aw48WFWDZwn2vF4Y9w409Fy3C3y7C3WxK3yFvFnFqF1Ut342kFZ5ArWxAwsr
        XF1jqw1UWF47W37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggNAVZdtZu2IgABs2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when the request to secure
element of st21nfca is timeout. The root cause is that kzalloc and
alloc_skb with GFP_KERNEL parameter and mutex_lock are called in
st21nfca_se_wt_timeout which is a timer handler. The call tree shows
the execution paths that could lead to bugs:

   (Interrupt context)
st21nfca_se_wt_timeout
  nfc_hci_send_event
    nfc_hci_hcp_message_tx
      kzalloc(..., GFP_KERNEL) //may sleep
      alloc_skb(..., GFP_KERNEL) //may sleep
      mutex_lock() //may sleep

This patch changes allocation mode of kzalloc and alloc_skb from
GFP_KERNEL to GFP_ATOMIC and changes mutex_lock to spin_lock in
order to prevent atomic context from sleeping.

Fixes: 2130fb97fecf ("NFC: st21nfca: Adding support for secure element")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v2:
  - Change mutex_lock to spin_lock.

 include/net/nfc/hci.h |  3 ++-
 net/nfc/hci/core.c    | 18 +++++++++---------
 net/nfc/hci/hcp.c     | 10 +++++-----
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index 756c11084f6..8f66e6e6b91 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -103,7 +103,8 @@ struct nfc_hci_dev {
 
 	bool shutting_down;
 
-	struct mutex msg_tx_mutex;
+	/* The spinlock is used to protect resources related with hci message TX */
+	spinlock_t msg_tx_spin;
 
 	struct list_head msg_tx_queue;
 
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index ceb87db57cd..fa22f9fe5fc 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -68,7 +68,7 @@ static void nfc_hci_msg_tx_work(struct work_struct *work)
 	struct sk_buff *skb;
 	int r = 0;
 
-	mutex_lock(&hdev->msg_tx_mutex);
+	spin_lock(&hdev->msg_tx_spin);
 	if (hdev->shutting_down)
 		goto exit;
 
@@ -120,7 +120,7 @@ static void nfc_hci_msg_tx_work(struct work_struct *work)
 		  msecs_to_jiffies(hdev->cmd_pending_msg->completion_delay));
 
 exit:
-	mutex_unlock(&hdev->msg_tx_mutex);
+	spin_unlock(&hdev->msg_tx_spin);
 }
 
 static void nfc_hci_msg_rx_work(struct work_struct *work)
@@ -165,7 +165,7 @@ static void __nfc_hci_cmd_completion(struct nfc_hci_dev *hdev, int err,
 void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
 			   struct sk_buff *skb)
 {
-	mutex_lock(&hdev->msg_tx_mutex);
+	spin_lock(&hdev->msg_tx_spin);
 
 	if (hdev->cmd_pending_msg == NULL) {
 		kfree_skb(skb);
@@ -175,7 +175,7 @@ void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
 	__nfc_hci_cmd_completion(hdev, nfc_hci_result_to_errno(result), skb);
 
 exit:
-	mutex_unlock(&hdev->msg_tx_mutex);
+	spin_unlock(&hdev->msg_tx_spin);
 }
 
 void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
@@ -833,7 +833,7 @@ static int hci_se_io(struct nfc_dev *nfc_dev, u32 se_idx,
 
 static void nfc_hci_failure(struct nfc_hci_dev *hdev, int err)
 {
-	mutex_lock(&hdev->msg_tx_mutex);
+	spin_lock(&hdev->msg_tx_spin);
 
 	if (hdev->cmd_pending_msg == NULL) {
 		nfc_driver_failure(hdev->ndev, err);
@@ -843,7 +843,7 @@ static void nfc_hci_failure(struct nfc_hci_dev *hdev, int err)
 	__nfc_hci_cmd_completion(hdev, err, NULL);
 
 exit:
-	mutex_unlock(&hdev->msg_tx_mutex);
+	spin_unlock(&hdev->msg_tx_spin);
 }
 
 static void nfc_hci_llc_failure(struct nfc_hci_dev *hdev, int err)
@@ -1009,7 +1009,7 @@ EXPORT_SYMBOL(nfc_hci_free_device);
 
 int nfc_hci_register_device(struct nfc_hci_dev *hdev)
 {
-	mutex_init(&hdev->msg_tx_mutex);
+	spin_lock_init(&hdev->msg_tx_spin);
 
 	INIT_LIST_HEAD(&hdev->msg_tx_queue);
 
@@ -1031,7 +1031,7 @@ void nfc_hci_unregister_device(struct nfc_hci_dev *hdev)
 {
 	struct hci_msg *msg, *n;
 
-	mutex_lock(&hdev->msg_tx_mutex);
+	spin_lock(&hdev->msg_tx_spin);
 
 	if (hdev->cmd_pending_msg) {
 		if (hdev->cmd_pending_msg->cb)
@@ -1044,7 +1044,7 @@ void nfc_hci_unregister_device(struct nfc_hci_dev *hdev)
 
 	hdev->shutting_down = true;
 
-	mutex_unlock(&hdev->msg_tx_mutex);
+	spin_unlock(&hdev->msg_tx_spin);
 
 	del_timer_sync(&hdev->cmd_timer);
 	cancel_work_sync(&hdev->msg_tx_work);
diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index 05c60988f59..f7eccb4ce35 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -30,7 +30,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 	int hci_len, err;
 	bool firstfrag = true;
 
-	cmd = kzalloc(sizeof(struct hci_msg), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd == NULL)
 		return -ENOMEM;
 
@@ -58,7 +58,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 			  data_link_len + ndev->tx_tailroom;
 		hci_len -= data_link_len;
 
-		skb = alloc_skb(skb_len, GFP_KERNEL);
+		skb = alloc_skb(skb_len, GFP_ATOMIC);
 		if (skb == NULL) {
 			err = -ENOMEM;
 			goto out_skb_err;
@@ -90,16 +90,16 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 		skb_queue_tail(&cmd->msg_frags, skb);
 	}
 
-	mutex_lock(&hdev->msg_tx_mutex);
+	spin_lock(&hdev->msg_tx_spin);
 
 	if (hdev->shutting_down) {
 		err = -ESHUTDOWN;
-		mutex_unlock(&hdev->msg_tx_mutex);
+		spin_unlock(&hdev->msg_tx_spin);
 		goto out_skb_err;
 	}
 
 	list_add_tail(&cmd->msg_l, &hdev->msg_tx_queue);
-	mutex_unlock(&hdev->msg_tx_mutex);
+	spin_unlock(&hdev->msg_tx_spin);
 
 	schedule_work(&hdev->msg_tx_work);
 
-- 
2.17.1

