Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841B06AB945
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCFJHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjCFJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:07:36 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBD22A10
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 01:07:36 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u14-20020a170902e5ce00b0019e3ce940b7so5568000plf.12
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 01:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678093655;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4A46wKTC+CcMedW/G9j+SuC/vj+S0/LGxEORBPUqymI=;
        b=jkvSAN8NSy+uLMta6N+AwFqfJL62XqCwN2Bvyh1/a4/UbQHwRL3F/PnRe/nQwArwp+
         pOFb3Q5ynk4fHladF23EbePCt7qkXIXnZz31qzXoKEcyttpIsLznMvMwOYwFrIAZzTaa
         JQ6HYh6KSSQtTZAjFvWY2qaQCCyGsnsU+sQGrAVrIEJMzbMjsSKERgSuP8SFd1AhIIXQ
         nzs4sYU43IKvUecajKYsdYNRSr2m4gS6DyRR2g0M8z4QOplfdoba7KAt0mdbmpReptu/
         kHiIF4rCYUdxPJkcT1kxuhqhIf3ofnBN6ZJjhZayUrHE/t/M+5gSPyyhK14GKyXbNDzB
         lsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678093655;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4A46wKTC+CcMedW/G9j+SuC/vj+S0/LGxEORBPUqymI=;
        b=5GYBUChIICnibDgz88rh/euJIcNdcD63+9HbvW0Yfq0e2OFUotiRu/RX4GqHC6wcBu
         MdSmYx5PjH9qQJgqL9JQWn0Zdf5o9S5V3FKdOdTeOgl+QG9fJyGkVxW3Q8p0KOka1GpZ
         icBEeDF4GHVWekQ820FmceazNsyxOsqgl8wRFPfMRa8gWATNgRlf568UYriRGmMmwLH0
         6rPS8J/PgMSvtJkzsBHvyl5CQqh/XpIVtOMVtJJuFTHW4Yc7DtSVnSYyXLYdX+EtZv6I
         wqno7cxN78Q13EF4TTuMxTx3JmqesaqOhTC3lcnxZetdK0Dg371TNaeh8zIiPnEBss3e
         86Nw==
X-Gm-Message-State: AO0yUKVi3HUmOcawwtXTO7GQxH59uHEyKpN3BJtEyIKepYPnTjHJNcmE
        x9T8nVSDIIi3w0NtpcGap2cKpJGRTXWZ
X-Google-Smtp-Source: AK7set/jjFYkNXqa31b0x4vkHuOnIhd4oQL+wq7Pm60LeC6WBNHSXLU9Hyr58Rwz92XV5T/MwzVUExwVqHoS
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:17:d5f3:860e:1224:5e0a])
 (user=apusaka job=sendgmr) by 2002:a62:ce43:0:b0:593:dc61:2161 with SMTP id
 y64-20020a62ce43000000b00593dc612161mr4272494pfg.2.1678093655488; Mon, 06 Mar
 2023 01:07:35 -0800 (PST)
Date:   Mon,  6 Mar 2023 17:07:07 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306170628.1.I8d0612b2968dd4740a4ceaf42f329fb59d5b9324@changeid>
Subject: [PATCH] Bluetooth: hci_sync: Don't wait peer's reply when powering off
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Currently, when we initiate disconnection, we will wait for the peer's
reply unless when we are suspending, where we fire and forget the
disconnect request.

A similar case is when adapter is powering off. However, we still wait
for the peer's reply in this case. Therefore, if the peer is
unresponsive, the command will time out and the power off sequence
will fail, causing "bluetooth powered on by itself" to users.

This patch makes the host doesn't wait for the peer's reply when the
disconnection reason is powering off.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>

---

 net/bluetooth/hci_sync.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 561a519a11bd6..a6cea389b675f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5103,10 +5103,12 @@ static int hci_disconnect_sync(struct hci_dev *hdev, struct hci_conn *conn,
 	cp.handle = cpu_to_le16(conn->handle);
 	cp.reason = reason;
 
-	/* Wait for HCI_EV_DISCONN_COMPLETE not HCI_EV_CMD_STATUS when not
-	 * suspending.
+	/* Wait for HCI_EV_DISCONN_COMPLETE, not HCI_EV_CMD_STATUS, when the
+	 * reason is anything but HCI_ERROR_REMOTE_POWER_OFF. This reason is
+	 * used when suspending or powering off, where we don't want to wait
+	 * for the peer's response.
 	 */
-	if (!hdev->suspended)
+	if (reason != HCI_ERROR_REMOTE_POWER_OFF)
 		return __hci_cmd_sync_status_sk(hdev, HCI_OP_DISCONNECT,
 						sizeof(cp), &cp,
 						HCI_EV_DISCONN_COMPLETE,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

