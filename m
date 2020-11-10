Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C662AD35B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgKJKSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbgKJKSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:18:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04FC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 02:18:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j10so14248101ybl.19
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 02:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C95huzuAXxK/Q/ur78yeB7NRb6+ErTiDkKW1OinYBEM=;
        b=fN+dlOttk59kV4mLEiOPuNPqRVO5JnVN+aLCHgK4Ide9SzT2SQ3I1Yp3N5t72yFdir
         34VUGkP4Cvs7PgQaYEmHpmbygeZ3AOQw1Pcu5X64sVf/KYR3/Zvp+Jtqmky9LNAMiyK9
         yHgzL0q3RFCeESLtPDPRlS44QRMGM03aVf5L8qeRpxeY5wq2LY2FbBI5YCagY3N/ML8h
         7alq99rz5kLQbnA2mlTGvhGpeRazuasVf4ZJpuJ1N3j4IJGh2yI0rCnyhq2a0ybp/N67
         JJaJ8aXsthHSK58MdaYjLmplXIPzz9REb/KjTV4SQfWagMuVv38m6r4oJ1Y95ua6bjPa
         Kodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C95huzuAXxK/Q/ur78yeB7NRb6+ErTiDkKW1OinYBEM=;
        b=omdDU6HAUiCgZXJBDYInWvPNmPUe8lqfIL2MegdUXj86dj+F3T01ubIpo8TCgA+sR0
         mavyULoNj2wuOBUpSbwDjfWD6mn940wIAM00nMfDkZpLgjQOCxP+w6nfnKtbs3ZY8eXp
         PzMnjYpl50rNFeabK9yGMaas4vXF128bnCqMFkPAKCBYs0ZH2TsYzrqNxKtM9ThuQi87
         68YjodATIvHhf4rwwp8gRFnAe7u4pKBwtAwDNEquz8WbtzM3Rrd71r3C2xrv181ojCaG
         goLLRZ3dAjfcHFCwbiENPGiUNL6VCveeMpPfoI1Sd+nGhgu3r1JfJMjN0zomTxq0gLid
         8CFQ==
X-Gm-Message-State: AOAM530MXTGdHmY0u5rk9+th4aAEFSkqCtg5cMKbV3hlG3WFiGI1E2o4
        w4189Cw6YYn31wsW7SHstq/J+ueplbOXakABjg==
X-Google-Smtp-Source: ABdhPJx69PbWxwCICMrL7Wj6VOTH3H80JJyY09ctMYN6Hw9Hg3URXQvI6M3r7B32IDzklPSaZONPScF2und96eg5ZQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:ac23:: with SMTP id
 w35mr26697654ybi.171.1605003531984; Tue, 10 Nov 2020 02:18:51 -0800 (PST)
Date:   Tue, 10 Nov 2020 18:17:53 +0800
In-Reply-To: <20201110181740.v8.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
Message-Id: <20201110181740.v8.4.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20201110181740.v8.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v8 4/6] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, mcchou@chromium.org, alainm@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the active scan during interleave
scan. The interleave scan will be canceled when users start active scan,
and it will be restarted after active scan stopped.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
---

(no changes since v1)

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index d943ad2885aa0..172ccbf4f0cd2 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3099,8 +3099,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	 * running. Thus, we should temporarily stop it in order to set the
 	 * discovery scanning parameters.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
 		hci_req_add_le_scan_disable(req, false);
+		cancel_interleave_scan(hdev);
+	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
-- 
2.29.2.222.g5d2a92d10f8-goog

