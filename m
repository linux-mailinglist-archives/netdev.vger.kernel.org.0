Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED053BB8F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiFBPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiFBPaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:30:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A84313C1F9
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:30:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c2f3431b4so44607187b3.21
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 08:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2nAGCZ2HRmIXfv8rT8uSoEGsDABE/p5lJinXX/zQGnA=;
        b=IfIrft4dh0L+HPBnonus5+t8id1FCITlCEYwqDadPZIb9negqKU7CN3IGx3i8hTnhR
         kB6ouvKEZZZP0zF0B8cw1UOa/f8y3XVDhpPK7cRzGLWUcglbKxAbMtNc0hniyy5/hL7F
         Osuhj77CqUU9jyA7mlllRNA736rv4LPVJjfzC0DsNurQR5dVgRYPdP8tdusDwF0hE3ZR
         qyCRo4MI1G6T2kSnla0yA76He3F+Fquw4jlhF3DudC+aK0Md+LME2aC1Bi/fTYB2sq+0
         HQb17wBXpRy+YvXh3tfiB/Nk1Ba3q4rmQZEtl92xvisIC2C60EziP4l54dD3Um39VU9G
         pPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2nAGCZ2HRmIXfv8rT8uSoEGsDABE/p5lJinXX/zQGnA=;
        b=c0Bi7lsZubzqhrz+4MCPrpnJwTa/Ut7Bt1UYi0/EEWVEcm4Muv1pYwvQkKhTGVspAL
         G2NiFtkV/VzYHPNgYuhlAewxQZ/Q4O2ZwbYVG/acq3XaZ32xA0tmdXTlSR4kPDapxeba
         KQ/yfBNpNuSfps4EzkrXHSCGGNwyRxP5AKFtcr6pIDkZb+OOlQl64AeJyxd+y124kij4
         T6QOrJx7kM4AmDitUROd67NJrHNvUulNPhOvQag78nelxrz8xkqTTiBNDvplCVP1sq3n
         AHaYLiWu8l0iSGF/1pnu3h57fGNxJskMCRurUhMUd4yX6K9SbfIOeP/Dh0sefcw2TR/3
         TAyQ==
X-Gm-Message-State: AOAM532ZgDyZGz5Db3z9q5wrsKgR+/sblybtuzTwbOcYavAdoA5jJTpP
        RmA5Rkfjw4UDOm+3e1sZLw4Oq60+GFf7E/9GFcM=
X-Google-Smtp-Source: ABdhPJx9WENoVblAMpg4ET+k1EH0awq1ra4yhT0qlJy920LyMKD8OOajT85XeuhNvx8xInBSN3eh9VZql+trNKSgB1w=
X-Received: from alainmic.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2890])
 (user=alainmichaud job=sendgmr) by 2002:a25:2c4c:0:b0:65d:3767:2ef2 with SMTP
 id s73-20020a252c4c000000b0065d37672ef2mr5957046ybs.570.1654183806234; Thu,
 02 Jun 2022 08:30:06 -0700 (PDT)
Date:   Thu,  2 Jun 2022 15:30:03 +0000
Message-Id: <20220602152952.v3.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v3] Bluetooth: clear the temporary linkkey in hci_conn_cleanup
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

Additionally, this also makes use of test_and_clear_bit to avoid
multiple attempts to delete the link key that's already been flushed.

Signed-off-by: Alain Michaud <alainm@chromium.org>

---

Changes in v3:
-Adding test_and_clear_bit to the commit description based on Marcel's
feedback

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

