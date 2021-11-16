Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39E4535C3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhKPPak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:30:40 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:18738 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238210AbhKPPah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:30:37 -0500
Received: from localhost.localdomain (unknown [222.205.2.245])
        by mail-app3 (Coremail) with SMTP id cC_KCgDXnvDkzZNhFtRDCA--.7427S4;
        Tue, 16 Nov 2021 23:27:32 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, Lin Ma <linma@zju.edu.cn>
Subject: [PATCH net v5 2/2] NFC: add NCI_UNREG flag to eliminate the race
Date:   Tue, 16 Nov 2021 23:27:32 +0800
Message-Id: <20211116152732.19238-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116152652.19217-1-linma@zju.edu.cn>
References: <20211116152652.19217-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgDXnvDkzZNhFtRDCA--.7427S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZryxCFy8Kw4xtr15XF1xGrg_yoW5Zr4Dpa
        nYgFy3Kry8Cry7GrW0vw18JF1Y9w40kayfG3yruw4xGa9xXFyaqFyktFWjqa48uFZ5AFWa
        qFy3Ca4rCr1UJr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6ryrMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UgmRUUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two sites that calls queue_work() after the
destroy_workqueue() and lead to possible UAF.

The first site is nci_send_cmd(), which can happen after the
nci_close_device as below

nfcmrvl_nci_unregister_dev   |  nfc_genl_dev_up
  nci_close_device           |
    flush_workqueue          |
    del_timer_sync           |
  nci_unregister_device      |    nfc_get_device
    destroy_workqueue        |    nfc_dev_up
    nfc_unregister_device    |      nci_dev_up
      device_del             |        nci_open_device
                             |          __nci_request
                             |            nci_send_cmd
                             |              queue_work !!!

Another site is nci_cmd_timer, awaked by the nci_cmd_work from the
nci_send_cmd.

  ...                        |  ...
  nci_unregister_device      |  queue_work
    destroy_workqueue        |
    nfc_unregister_device    |  ...
      device_del             |  nci_cmd_work
                             |  mod_timer
                             |  ...
                             |  nci_cmd_timer
                             |    queue_work !!!

For the above two UAF, the root cause is that the nfc_dev_up can race
between the nci_unregister_device routine. Therefore, this patch
introduce NCI_UNREG flag to easily eliminate the possible race. In
addition, the mutex_lock in nci_close_device can act as a barrier.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/core.c         | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index a964daedc17b..ea8595651c38 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -30,6 +30,7 @@ enum nci_flag {
 	NCI_UP,
 	NCI_DATA_EXCHANGE,
 	NCI_DATA_EXCHANGE_TO,
+	NCI_UNREG,
 };
 
 /* NCI device states */
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 6fd873aa86be..1be9ad539f25 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -473,6 +473,11 @@ static int nci_open_device(struct nci_dev *ndev)
 
 	mutex_lock(&ndev->req_lock);
 
+	if (test_bit(NCI_UNREG, &ndev->flags)) {
+		rc = -ENODEV;
+		goto done;
+	}
+
 	if (test_bit(NCI_UP, &ndev->flags)) {
 		rc = -EALREADY;
 		goto done;
@@ -545,6 +550,10 @@ static int nci_open_device(struct nci_dev *ndev)
 static int nci_close_device(struct nci_dev *ndev)
 {
 	nci_req_cancel(ndev, ENODEV);
+
+	/* This mutex needs to be held as a barrier for
+	 * caller nci_unregister_device
+	 */
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
@@ -582,8 +591,8 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	del_timer_sync(&ndev->cmd_timer);
 
-	/* Clear flags */
-	ndev->flags = 0;
+	/* Clear flags except NCI_UNREG */
+	ndev->flags &= BIT(NCI_UNREG);
 
 	mutex_unlock(&ndev->req_lock);
 
@@ -1266,6 +1275,12 @@ void nci_unregister_device(struct nci_dev *ndev)
 {
 	struct nci_conn_info *conn_info, *n;
 
+	/* This set_bit is not protected with specialized barrier,
+	 * However, it is fine because the mutex_lock(&ndev->req_lock);
+	 * in nci_close_device() will help to emit one.
+	 */
+	set_bit(NCI_UNREG, &ndev->flags);
+
 	nci_close_device(ndev);
 
 	destroy_workqueue(ndev->cmd_wq);
-- 
2.33.1

