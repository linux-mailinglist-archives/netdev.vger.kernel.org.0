Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E710F53BB73
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiFBPPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiFBPPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:15:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B191C2D60
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:15:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30974094b5cso44635907b3.20
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 08:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Wr2n5iI7XttDispKB41EO8G79l4qta1A1VBwdKgaGQg=;
        b=K57/WdHT4u8VdENtYRT2HFl5kLPTLI0FcXt1D8IExcQ6jqRfEB78EOmbDeXhnMLAvx
         ShM+ROjLF8dh1S+MActgGL3MfFOJKHMiqUACX0uAFFTahYnUUPNZH0ivKYqGh46n9Qvv
         JIl1EH6b3KoMsm4FozPq3FZZ3qd1TbDzgBpA0TESnZwYKtoSt3FoG+zvJsUgDUuhG7Gq
         eywRkDVmJ+53j+cYerjmufgUCW6r4D/HTR543Pqm51dozKw/gfhXZY9wwekLD183o7C+
         cxKKbP3EbNMGPVgSw88747UrRcyWeVckl8bkm/yMVsPAzekVnAjDzx4gQqY95FW0GKVn
         ZxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Wr2n5iI7XttDispKB41EO8G79l4qta1A1VBwdKgaGQg=;
        b=08vIRAK1jkRyQh1v9X45RS7uuMTY88S3EEhhdE0MfBYcWkvYaVBUV5teBQQlISSPkx
         UNiK0kYcVnTWP7aWvThlUnDqV+2ugyNXBPq/skaOwfTMBHvwmb7U09Wk1CdHlM5HNxAd
         9p5AUDqAt1cMkd/aZ0Fv6hzMjPPyPpfSGIWseRk0G0JNij114AsVCBO4d8KFXXfCFK/s
         J0Z6pLyec0++6sLKX2fcfKnyYwyxuFUpgvJkAZDGkO2dAE0THtY7EI8jbGcVnrvTUSJt
         XAIdSraE1SPdafGlqyOHqosaHkVA0i3mtPWnSUndY/AwpBHVHQTHQbx/8B1IAkn0c94u
         glKQ==
X-Gm-Message-State: AOAM530U7uTWz0gAZ3Z6UaOPELbru9Z0RndsF951DFQpVAoStexi4KvC
        Tz/sGb0dyq3li1bshAGrlCTnL64p7Bd7Ku4WKIQ=
X-Google-Smtp-Source: ABdhPJwgzfjBkuwAIlhVJU3K64/lVauaaNGCor4kJpVmZz5B9OzfxnNDf589Fln0AbrJ3JiMHsVhssHw5pKQEGTTYVM=
X-Received: from alainmic.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2890])
 (user=alainmichaud job=sendgmr) by 2002:a25:8046:0:b0:65b:9fd2:53b0 with SMTP
 id a6-20020a258046000000b0065b9fd253b0mr5804468ybn.100.1654182907005; Thu, 02
 Jun 2022 08:15:07 -0700 (PDT)
Date:   Thu,  2 Jun 2022 15:15:03 +0000
Message-Id: <20220602151456.v2.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2] Bluetooth: clear the temporary linkkey in hci_conn_cleanup
From:   Alain Michaud <alainmichaud@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

If a hardware error occurs and the connections are flushed without a
disconnection_complete event being signaled, the temporary linkkeys are
not flushed.

This change ensures that any outstanding flushable linkkeys are flushed
when the connection are flushed from the hash table.

Signed-off-by: Alain Michaud <alainm@chromium.org>

---

Changes in v2:
-Address Feedback from Luiz

 net/bluetooth/hci_conn.c  | 3 +++
 net/bluetooth/hci_event.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 352d7d612128..5911ca0c5239 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -118,6 +118,9 @@ static void hci_conn_cleanup(struct hci_conn *conn)
 	if (test_bit(HCI_CONN_PARAM_REMOVAL_PEND, &conn->flags))
 		hci_conn_params_del(conn->hdev, &conn->dst, conn->dst_type);
 
+	if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
+		hci_remove_link_key(hdev, &conn->dst);
+
 	hci_chan_list_flush(conn);
 
 	hci_conn_hash_del(hdev, conn);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6b83f9b0082c..b67fdd1ad8da 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2729,7 +2729,7 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
 	mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags);
 
 	if (conn->type == ACL_LINK) {
-		if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
+		if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
 			hci_remove_link_key(hdev, &conn->dst);
 	}
 
@@ -3372,7 +3372,7 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
 				reason, mgmt_connected);
 
 	if (conn->type == ACL_LINK) {
-		if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
+		if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
 			hci_remove_link_key(hdev, &conn->dst);
 
 		hci_req_update_scan(hdev);
-- 
2.36.1.255.ge46751e96f-goog

