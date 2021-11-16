Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018EF4535BE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbhKPPaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:30:04 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:18668 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238078AbhKPPaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:30:03 -0500
Received: from localhost.localdomain (unknown [222.205.2.245])
        by mail-app3 (Coremail) with SMTP id cC_KCgC3vxvBzZNhONFDCA--.11582S4;
        Tue, 16 Nov 2021 23:26:58 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, Lin Ma <linma@zju.edu.cn>
Subject: [PATCH net v5 1/2] NFC: reorder the logic in nfc_{un,}register_device
Date:   Tue, 16 Nov 2021 23:26:52 +0800
Message-Id: <20211116152652.19217-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgC3vxvBzZNhONFDCA--.11582S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1UAFy7WFWftw4kJFW7CFg_yoW5Kr47p3
        WrGas3KryDKr4UWr4fZr47JFy5ur48tw4rZryFkryjkrZxZrWftr93Jry8Jas5Ja95AayY
        qrWUZw48ur45XF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6ryrMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        U3Ma8UUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a potential UAF between the unregistration routine and the NFC
netlink operations.

The race that cause that UAF can be shown as below:

 (FREE)                      |  (USE)
nfcmrvl_nci_unregister_dev   |  nfc_genl_dev_up
  nci_close_device           |
  nci_unregister_device      |    nfc_get_device
    nfc_unregister_device    |    nfc_dev_up
      rfkill_destory         |
      device_del             |      rfkill_blocked
  ...                        |    ...

The root cause for this race is concluded below:
1. The rfkill_blocked (USE) in nfc_dev_up is supposed to be placed after
the device_is_registered check.
2. Since the netlink operations are possible just after the device_add
in nfc_register_device, the nfc_dev_up() can happen anywhere during the
rfkill creation process, which leads to data race.

This patch reorder these actions to permit
1. Once device_del is finished, the nfc_dev_up cannot dereference the
rfkill object.
2. The rfkill_register need to be placed after the device_add of nfc_dev
because the parent device need to be created first. So this patch keeps
the order but inject device_lock to prevent the data race.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Fixes: be055b2f89b5 ("NFC: RFKILL support")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


---
 net/nfc/core.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 3c645c1d99c9..dc7a2404efdf 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -94,13 +94,13 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
-		rc = -ERFKILL;
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
 		goto error;
 	}
 
-	if (!device_is_registered(&dev->dev)) {
-		rc = -ENODEV;
+	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
+		rc = -ERFKILL;
 		goto error;
 	}
 
@@ -1125,11 +1125,7 @@ int nfc_register_device(struct nfc_dev *dev)
 	if (rc)
 		pr_err("Could not register llcp device\n");
 
-	rc = nfc_genl_device_added(dev);
-	if (rc)
-		pr_debug("The userspace won't be notified that the device %s was added\n",
-			 dev_name(&dev->dev));
-
+	device_lock(&dev->dev);
 	dev->rfkill = rfkill_alloc(dev_name(&dev->dev), &dev->dev,
 				   RFKILL_TYPE_NFC, &nfc_rfkill_ops, dev);
 	if (dev->rfkill) {
@@ -1138,6 +1134,12 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	device_unlock(&dev->dev);
+
+	rc = nfc_genl_device_added(dev);
+	if (rc)
+		pr_debug("The userspace won't be notified that the device %s was added\n",
+			 dev_name(&dev->dev));
 
 	return 0;
 }
@@ -1154,10 +1156,17 @@ void nfc_unregister_device(struct nfc_dev *dev)
 
 	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
 
+	rc = nfc_genl_device_removed(dev);
+	if (rc)
+		pr_debug("The userspace won't be notified that the device %s "
+			 "was removed\n", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
 	if (dev->rfkill) {
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
 		device_lock(&dev->dev);
@@ -1167,11 +1176,6 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		cancel_work_sync(&dev->check_pres_work);
 	}
 
-	rc = nfc_genl_device_removed(dev);
-	if (rc)
-		pr_debug("The userspace won't be notified that the device %s "
-			 "was removed\n", dev_name(&dev->dev));
-
 	nfc_llcp_unregister_device(dev);
 
 	mutex_lock(&nfc_devlist_mutex);
-- 
2.33.1

