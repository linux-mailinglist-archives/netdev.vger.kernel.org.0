Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45195271C63
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgIUHz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgIUHz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:55:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B231DC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:55:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u35so6383725ybd.13
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=B8Y+8LBTHvimJHhWZ6leFbSjmB7HBaNUGneyF5qrNVo=;
        b=gOJ3w0XHUt1s3W/NcjVERHtyUU3jGhxFOnp8sS+05/lJFkXW+s40ehvq5oB96ePwIC
         MpI5l56oe1ntuYW+xJYsqAmokEXaXAnNxdujOlrrYmhCZ3+WLBzVNCmyyrn+ZgdzVcJO
         dvECH2CICLBFjJTd7yxPoCobHJ4l0HKo9zYeMHUXAuRHxdTCTzkmIu84Ht1Ij2LlgiJ/
         u5YxPprocwoo150Xe7F0/lIMFKPjGvvCSOia931htTWKPPjzf/H9oBvChnbVBoZoJjA0
         qps3HpOXjoVf8N8AybhVQgzixkbH7Prg91vQpWpHUTEx57bpY1V0o4mlXfA3SBQgEefm
         1fQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=B8Y+8LBTHvimJHhWZ6leFbSjmB7HBaNUGneyF5qrNVo=;
        b=paFNs+uXs1+N6DO4OPibtEoP5e2xb1PGiFqDRL9ereSJv1YIh5inEVl9tyqxXBUzZb
         noBcWnSRnYxQ/FyNk3YtpH2b3Q2vNoqG9wq83fQFxJ0OFX8QXqeMxhe4pLK7GSmfm5d7
         VkrnfUCV6qhu+B6N6z503Cr4rsULbl/aGE9e0O2iWoi+xxRWBLpdMRvkTzeSZ6xyYCNH
         gued4zWJP7SmDWTO+IbM/1vfKkVgLXnDuf2C8/0foFZlBFPQQqOg6WzybJAb9V6OMDf8
         90AqS47XM6DEFtVajI3YIDVPRdPoNX1aoFMIzmlH1cEMPcKvExlvdrJcpaS9oGZJoWhF
         yaHg==
X-Gm-Message-State: AOAM5304pHqE54I5Ne18vcSxPq1HOTi5AtZCrHlkx5O8bCja4cWe8GHH
        DRvxeqIDMA4wLbei1eMoSNd+0e13Jxma
X-Google-Smtp-Source: ABdhPJwV9JhyQlgRTnlAmCvqsr0GwqhawJY3RB7xBcTvOGIUVrnohTplzXPDf5Odx+1QvTrhjj3sWzqVJ0Oo
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a25:9c82:: with SMTP id
 y2mr28393404ybo.364.1600674925897; Mon, 21 Sep 2020 00:55:25 -0700 (PDT)
Date:   Mon, 21 Sep 2020 15:55:13 +0800
Message-Id: <20200921155004.v2.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v2] Bluetooth: Check for encryption key size on connect
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

When receiving connection, we only check whether the link has been
encrypted, but not the encryption key size of the link.

This patch adds check for encryption key size, and reject L2CAP
connection which size is below the specified threshold (default 7)
with security block.

Here is some btmon trace.
@ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.847722
        Store hint: No (0x00)
        BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
        Key type: Unauthenticated Combination key from P-192 (0x04)
        Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
        PIN length: 0
> HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.871537
        Status: Success (0x00)
        Handle: 256
        Encryption: Enabled with E0 (0x01)
< HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.871609
        Handle: 256
> HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.872524
      Read Encryption Key Size (0x05|0x0008) ncmd 1
        Status: Success (0x00)
        Handle: 256
        Key size: 3

////// WITHOUT PATCH //////
> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.895023
      L2CAP: Connection Request (0x02) ident 3 len 4
        PSM: 4097 (0x1001)
        Source CID: 64
< ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.895213
      L2CAP: Connection Response (0x03) ident 3 len 8
        Destination CID: 64
        Source CID: 64
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)

////// WITH PATCH //////
> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.887024
      L2CAP: Connection Request (0x02) ident 3 len 4
        PSM: 4097 (0x1001)
        Source CID: 64
< ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.887127
      L2CAP: Connection Response (0x03) ident 3 len 8
        Destination CID: 0
        Source CID: 64
        Result: Connection refused - security block (0x0003)
        Status: No further information available (0x0000)

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>

---
Btw, it looks like the patch sent by Alex Lu with the title
[PATCH] Bluetooth: Fix the vulnerable issue on enc key size
also solves the exact same issue.

Changes in v2:
* Add btmon trace to the commit message

 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ade83e224567..b4fc0ad38aaa 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4101,7 +4101,8 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 
 	/* Check if the ACL is secure enough (if not SDP) */
 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
-	    !hci_conn_check_link_mode(conn->hcon)) {
+	    (!hci_conn_check_link_mode(conn->hcon) ||
+	    !l2cap_check_enc_key_size(conn->hcon))) {
 		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
 		result = L2CAP_CR_SEC_BLOCK;
 		goto response;
-- 
2.28.0.681.g6f77f65b4e-goog

