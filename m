Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DCF346AEF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhCWVTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbhCWVSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 17:18:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9B5C061764
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 14:18:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z21so103245pjr.9
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 14:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IQhrNSzzRo5IK8pWj/871CxEvc5sDb7hvYKb9bWs5PY=;
        b=KN38NpSiyK1jTjlQ83KhVeIAFt3K80SF6VSS1g2Jd6f/kh8nPpyuIJPztBAAMETnVu
         L1TuPqVmfYXaileuYB41opce3o14vJUEDGZFQm4mqdPltLJOh35UjMecsZT00vrZ45Z6
         bMk6r664cLfto6awWP6eqYTsRL/seiWKh2zQiWoafJMIrHgxtgqehsGCuzcsuz8KJR/N
         qrMlrwM9B3xSJDl67Qq2r65EjcM2nEK8GohueBoYsEWv6SXRhh5Rnmj5Pp6KbTGKyr1e
         ohWDaFpB0qusp/s6H0LYK787EY8fWslgnUp35D6SDsQXXhOeAO00QXpFaRUJaRvhifnw
         Gkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IQhrNSzzRo5IK8pWj/871CxEvc5sDb7hvYKb9bWs5PY=;
        b=pBB6p3jhnoJIO6UpLfsoJAoJmujxmC+1lGPzSejadDgh+fInuV2/8gjjLBhq1GYMcD
         9TRLhw/0AuTcrwepLmpD55ozLCN4eGg2Die2ymKwNPa3uhb0pamJWY5i67gw6ccEHm1T
         G1aaPGG/DYl8CGs5/K7ZzagBvacUu0gK7VXD4odXnt7jL/MDdtKus4ETSjZXsY2YDQno
         xvPNlpD4/1mnunDLdm+lXE8lDRQRPqJfWAZXVwu3xGL8IoBvTGjZ8AeaUqyTVUWkNYbZ
         SllO2v5WE2e5Ct59UsWTS/qG0ew1iLjBvtTQEILJmIHeDhiHFOTlJgD4s3ObSg4IokEB
         RFwQ==
X-Gm-Message-State: AOAM530QBOBnH6w1Y5RwNq0C530jt4Dm6khNFDrbIqeXybQeH6sR9d8e
        15FARUk0t3nC6XXM6DeCXAklEiOMPiSM4jZl1Y2/
X-Google-Smtp-Source: ABdhPJyA9VXXmhbh2eHFc9vjsbOs7A7JCXheNnJWzX6ciTpOXFtQyV4+cNABNQ9D75XBXirz5fTuzVlC+Uxr7nOd6GNf
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f18d:a314:46c6:7a97])
 (user=danielwinkler job=sendgmr) by 2002:a05:6a00:2348:b029:21d:4e83:7898
 with SMTP id j8-20020a056a002348b029021d4e837898mr132848pfj.65.1616534311315;
 Tue, 23 Mar 2021 14:18:31 -0700 (PDT)
Date:   Tue, 23 Mar 2021 14:18:21 -0700
Message-Id: <20210323141653.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] Bluetooth: Always call advertising disable before setting params
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __hci_req_enable_advertising, the HCI_LE_ADV hdev flag is temporarily
cleared to allow the random address to be set, which exposes a race
condition when an advertisement is configured immediately (<10ms) after
software rotation starts to refresh an advertisement.

In normal operation, the HCI_LE_ADV flag is updated as follows:

1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
   __hci_req_enable_advertising, but hci_req configures an enable
   request
2. hci_req is run, enable callback re-sets HCI_LE_ADV flag

However, in this race condition, the following occurs:

1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
   __hci_req_enable_advertising, but hci_req configures an enable
   request
2. add_advertising is called, which also calls
   __hci_req_enable_advertising. Because HCI_LE_ADV was cleared in Step
   1, no "disable" command is queued.
3. hci_req for adv_timeout_expire is run, which enables advertising and
   re-sets HCI_LE_ADV
4. hci_req for add_advertising is run, but because no "disable" command
   was queued, we try to set advertising parameters while advertising is
   active, causing a Command Disallowed error, failing the registration.

To resolve the issue, this patch removes the check for the HCI_LE_ADV
flag, and always queues the "disable" request, since HCI_LE_ADV could be
very temporarily out-of-sync. According to the spec, there is no harm in
calling "disable" when advertising is not active.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 net/bluetooth/hci_request.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 8ace5d34b01efe..2b4b99f4cedf21 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1547,8 +1547,10 @@ void __hci_req_enable_advertising(struct hci_request *req)
 	if (!is_advertising_allowed(hdev, connectable))
 		return;
 
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
-		__hci_req_disable_advertising(req);
+	/* Request that the controller stop advertising. This can be called
+	 * whether or not there is an active advertisement.
+	 */
+	__hci_req_disable_advertising(req);
 
 	/* Clear the HCI_LE_ADV bit temporarily so that the
 	 * hci_update_random_address knows that it's safe to go ahead
-- 
2.31.0.291.g576ba9dcdaf-goog

