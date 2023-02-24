Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49F46A228E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBXTxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBXTxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:53:18 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA4831E00
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:53:17 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p14-20020a170902ebce00b001963da9cc71so219925plg.11
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkRn+6AoxobFYVvnDPTVGQq+gGNHibmmav9mWkGQcVk=;
        b=ILZLCrgZS1VLizZWWAK+C1MzdNr6RID8mWa3hzE+XcEW2p6iM/BvO/yRxHWiOSEEgy
         gYSwauIfvjWlABo2DKzMfpSLuGdnPjEuKIUgTlKzhKRh+odB1SLOlZV+yDufYDWEhxUy
         WsDH90DLicnkiGnUWJwiT9OWnpMSKDl7RfsPud9BUtPeR+Ks+VTMRRYFBdUOI8SB5jhY
         NBaABFh0QiuVy14AjA9bAdJQRChJ7oHSMOTA4UYQCdBLtb4FybP1jZsLwElPtf9IXhLF
         w3I2g4LJ5yfkWDEc5tNZPkNydfd6+LFhQ/rnKnA/m9qv5RR6lMdOwz5AZm9QDj0iv95E
         BdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkRn+6AoxobFYVvnDPTVGQq+gGNHibmmav9mWkGQcVk=;
        b=BhezT6272oKrUPkEzHd+fjGUIantn+Sc1rxdj+pMsEa9tgpFhOE5LWMyd8bUa1fchc
         Xxx8nRUubQFevB92TyKvwHWH8I++UxXPS/QCCuGZkXewn43dBii2rJ9Qt1ObhY9Tf3MA
         C4Nq29T66gPCgU6Ng1IoW9axXBVw7wS9eCpd/Ue6lTsXPNDHImExr3LzWyS1SK0sRPmK
         6fzv4+8SIApi60tyEA7KfHRp9Nda+OiTlVzgCtZEVQWMeG2ITf1AAdOrHSweCDY6N6/v
         SGopqbw/BM1RBrsWQ4O/Q2lCOlwY458z7oR7VjnhgTRAwJcMp2MPGrTQRESyuBAKvMMl
         I68A==
X-Gm-Message-State: AO0yUKVX+ISRkigdtPjYE23kpY0CqWKsu3LudOwkAr+xC1UVbIIA/GBq
        K0qZnqh5y9Yhcs/MOqiZc91o6iUfhWbz
X-Google-Smtp-Source: AK7set8uBBgqkM+ht7YzOeEtgi5m6MwPtlIpSVoxsGaDBblHFL+pwGXlPcFSCwhTOk7CHYOuazpqRQNCrhox
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:903:2348:b0:199:6e3:187a with SMTP id
 c8-20020a170903234800b0019906e3187amr443395plh.6.1677268397322; Fri, 24 Feb
 2023 11:53:17 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:53:13 -0800
In-Reply-To: <20230224195313.1877313-1-jiangzp@google.com>
Mime-Version: 1.0
References: <20230224195313.1877313-1-jiangzp@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230224115310.kernel.v2.1.If0578b001c1f12567f2ebcac5856507f1adee745@changeid>
Subject: [kernel PATCH v2 1/1] Bluetooth: hci_sync: clear workqueue before
 clear mgmt cmd
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Zhengping Jiang <jiangzp@google.com>,
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

Clear cmd_sync_work queue before clearing the mgmt cmd list to avoid
racing conditions which cause use-after-free.

When powering off the adapter, the mgmt cmd list will be cleared. If a
work is queued in the cmd_sync_work queue at the same time, it will
cause the risk of use-after-free, as the cmd pointer is not checked
before use.

Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v2:
- Add function to clear the queue without stop the timer

Changes in v1:
- Clear cmd_sync_work queue before clearing the mgmt cmd list

 net/bluetooth/hci_sync.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..b70365dfff0c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -636,6 +636,23 @@ void hci_cmd_sync_init(struct hci_dev *hdev)
 	INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
 }
 
+static void hci_pend_cmd_sync_clear(struct hci_dev *hdev)
+{
+	struct hci_cmd_sync_work_entry *entry, *tmp;
+
+	mutex_lock(&hdev->cmd_sync_work_lock);
+	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
+		if (entry->destroy) {
+			hci_req_sync_lock(hdev);
+			entry->destroy(hdev, entry->data, -ECANCELED);
+			hci_req_sync_unlock(hdev);
+		}
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+}
+
 void hci_cmd_sync_clear(struct hci_dev *hdev)
 {
 	struct hci_cmd_sync_work_entry *entry, *tmp;
@@ -4842,8 +4859,10 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	if (!auto_off && hdev->dev_type == HCI_PRIMARY &&
 	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    hci_dev_test_flag(hdev, HCI_MGMT))
+	    hci_dev_test_flag(hdev, HCI_MGMT)) {
+		hci_pend_cmd_sync_clear(hdev);
 		__mgmt_power_off(hdev);
+	}
 
 	hci_inquiry_cache_flush(hdev);
 	hci_pend_le_actions_clear(hdev);
-- 
2.39.2.722.g9855ee24e9-goog

