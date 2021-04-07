Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D375C3561CB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 05:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbhDGDRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 23:17:08 -0400
Received: from m12-17.163.com ([220.181.12.17]:59425 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhDGDRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 23:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=mGN4S
        3cp1MHI+oL9a6SpuEW+SWIbAE/tY+wbQ+oANG4=; b=S9b5ZTwzntMnSsAmQ/QIs
        srzlBT/Vv8lg17IS1IrNxCgrnmCy61MgHfnhDw6+pfcbmNVBr9yxBgKz0gL8x9zZ
        /avp3QJ/pLM4x5wSapXsXnkbjeS/RfEmG609GW5jha0NX5jjTIS+EQ+QhZveGzu0
        4X0rmr/3gSqyL7uT0GOBi4=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.52.2])
        by smtp13 (Coremail) with SMTP id EcCowAC3v5cXJG1gJoIsuA--.41782S2;
        Wed, 07 Apr 2021 11:16:41 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     davem@davemloft.net, rdunlap@infradead.org, unixbhaskar@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc/fdp: remove unnecessary assignment and label
Date:   Wed,  7 Apr 2021 11:16:38 +0800
Message-Id: <20210407031638.4416-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAC3v5cXJG1gJoIsuA--.41782S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFW8tFy5AFWxJw4fAr1UWrg_yoWrXFW8pr
        WYgasxtr1kJr1xGrnayrn8AF1F9r4fCrZrGrW8ta97A3Way34qyFWkKFySvFWfurZ8Gr17
        Aw40qF1rWF1Utw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jd73kUUUUU=
X-Originating-IP: [119.137.52.2]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERltsV7+3gaY3AAAso
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function fdp_nci_patch_otp and fdp_nci_patch_ram，many goto
out statements are used, and out label just return variable r.
in some places,just jump to the out label, and in other places,
assign a value to the variable r,then jump to the out label.
It is unnecessary, we just use return sentences to replace goto
sentences and delete out label.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/fdp/fdp.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ee2baa2b..fe0719e 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -344,7 +344,7 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 	int r = 0;
 
 	if (info->otp_version >= info->otp_patch_version)
-		goto out;
+		return r;
 
 	info->setup_patch_sent = 0;
 	info->setup_reset_ntf = 0;
@@ -353,19 +353,17 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 	/* Patch init request */
 	r = fdp_nci_patch_cmd(ndev, NCI_PATCH_TYPE_OTP);
 	if (r)
-		goto out;
+		return r;
 
 	/* Patch data connection creation */
 	conn_id = fdp_nci_create_conn(ndev);
-	if (conn_id < 0) {
-		r = conn_id;
-		goto out;
-	}
+	if (conn_id < 0)
+		return conn_id;
 
 	/* Send the patch over the data connection */
 	r = fdp_nci_send_patch(ndev, conn_id, NCI_PATCH_TYPE_OTP);
 	if (r)
-		goto out;
+		return r;
 
 	/* Wait for all the packets to be send over i2c */
 	wait_event_interruptible(info->setup_wq,
@@ -377,13 +375,12 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 	/* Close the data connection */
 	r = nci_core_conn_close(info->ndev, conn_id);
 	if (r)
-		goto out;
+		return r;
 
 	/* Patch finish message */
 	if (fdp_nci_patch_cmd(ndev, NCI_PATCH_TYPE_EOT)) {
 		nfc_err(dev, "OTP patch error 0x%x\n", r);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* If the patch notification didn't arrive yet, wait for it */
@@ -393,8 +390,7 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 	r = info->setup_patch_status;
 	if (r) {
 		nfc_err(dev, "OTP patch error 0x%x\n", r);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -403,7 +399,6 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 	 */
 	wait_event_interruptible(info->setup_wq, info->setup_reset_ntf);
 
-out:
 	return r;
 }
 
@@ -415,7 +410,7 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 	int r = 0;
 
 	if (info->ram_version >= info->ram_patch_version)
-		goto out;
+		return r;
 
 	info->setup_patch_sent = 0;
 	info->setup_reset_ntf = 0;
@@ -424,19 +419,17 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 	/* Patch init request */
 	r = fdp_nci_patch_cmd(ndev, NCI_PATCH_TYPE_RAM);
 	if (r)
-		goto out;
+		return r;
 
 	/* Patch data connection creation */
 	conn_id = fdp_nci_create_conn(ndev);
-	if (conn_id < 0) {
-		r = conn_id;
-		goto out;
-	}
+	if (conn_id < 0)
+		return conn_id;
 
 	/* Send the patch over the data connection */
 	r = fdp_nci_send_patch(ndev, conn_id, NCI_PATCH_TYPE_RAM);
 	if (r)
-		goto out;
+		return r;
 
 	/* Wait for all the packets to be send over i2c */
 	wait_event_interruptible(info->setup_wq,
@@ -448,13 +441,12 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 	/* Close the data connection */
 	r = nci_core_conn_close(info->ndev, conn_id);
 	if (r)
-		goto out;
+		return r;
 
 	/* Patch finish message */
 	if (fdp_nci_patch_cmd(ndev, NCI_PATCH_TYPE_EOT)) {
 		nfc_err(dev, "RAM patch error 0x%x\n", r);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* If the patch notification didn't arrive yet, wait for it */
@@ -464,8 +456,7 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 	r = info->setup_patch_status;
 	if (r) {
 		nfc_err(dev, "RAM patch error 0x%x\n", r);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/*
@@ -474,7 +465,6 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 	 */
 	wait_event_interruptible(info->setup_wq, info->setup_reset_ntf);
 
-out:
 	return r;
 }
 
-- 
1.9.1


