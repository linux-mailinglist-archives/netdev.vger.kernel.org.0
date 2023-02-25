Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5116A292B
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 11:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBYK6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 05:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYK6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 05:58:15 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018AD1204A;
        Sat, 25 Feb 2023 02:58:13 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.2])
        by mail.ispras.ru (Postfix) with ESMTPSA id AE78640737BF;
        Sat, 25 Feb 2023 10:58:10 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AE78640737BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677322690;
        bh=rGjdhJvb7X6dTiZDmK5NuegmyCAEIhgb0sexbGd+X04=;
        h=From:To:Cc:Subject:Date:From;
        b=Q4UH0r35Vt4GBSQhMqcNn41zqoi+Grwhvvav7b4fMQ8hTH2msdIFeYXiH1oq/OSHq
         kHRWjA1EpygIs6ot+rYkWcN95heLl5vqo7qm/b7HTaHv6HPjdy8dCRa5gwjzaTr0ZZ
         rbsLkuqmwHjH3mqbV4WaiCpXBn7MCjRwDoaX5PJQ=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Subject: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Date:   Sat, 25 Feb 2023 13:56:14 +0300
Message-Id: <20230225105614.379382-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback context for sending/receiving APDUs to/from the selected
secure element is allocated inside nfc_genl_se_io and supposed to be
eventually freed in se_io_cb callback function. However, there are several
error paths where the bwi_timer is not charged to call se_io_cb later, and
the cb_context is leaked.

The patch proposes to free the cb_context explicitly on those error paths.

At the moment we can't simply check 'dev->ops->se_io()' return value as it
may be negative in both cases: when the timer was charged and was not.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/nfc/st-nci/se.c   | 6 ++++++
 drivers/nfc/st21nfca/se.c | 6 ++++++
 net/nfc/netlink.c         | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index ec87dd21e054..b2f1ced8e6dd 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 					ST_NCI_EVT_TRANSMIT_DATA, apdu,
 					apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index df8d27cf2956..dae288bebcb5 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 					ST21NFCA_EVT_TRANSMIT_DATA,
 					apdu, apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 1fc339084d89..348bf561bc9f 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	rc = dev->ops->se_io(dev, se_idx, apdu,
 			apdu_length, cb, cb_context);
 
+	device_unlock(&dev->dev);
+	return rc;
+
 error:
+	kfree(cb_context);
 	device_unlock(&dev->dev);
 	return rc;
 }
-- 
2.34.1

