Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB9275460
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIWJWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgIWJWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:22:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6E2C0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 140so17640552ybf.2
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OYN0waWCzIpz4ouqNQwOPc0HvVqV4aulKVgXstFC8pM=;
        b=UTEylZUZ5updRxJyyE1aYQG2MB/kp+pzMWY5DhOtjk4PMP63yPQX5Vh2r0Nx4gPB/1
         V9zrBiDN+pQkVLjlflvjNSdooxWO4yGD3nHAzZ7CQNQ/gkOk2/DccLeqY0U7p37oAanE
         HYrMNwgimP/NEksULzdrBxeNR8m+30WlcQf8eUzLQ3oteCOE7BPiRlV0qCmZ77rX7QZJ
         1w2brV8qQ6HMyZXR6jkJdQsLRBEcefQT3hIXJlOu5K21VItm12/SvWm552hMC42DmvFz
         hYfl3JtNg2oaINdq4AZSFZzhyIHN4rU3btDdpttPcGEmxPsuGmWKTBXc8BqQ3zcFnme6
         4sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OYN0waWCzIpz4ouqNQwOPc0HvVqV4aulKVgXstFC8pM=;
        b=poT8pXU0lMSxoqBvFF5le4tDHJ/PMyiF9Fg8QHLDkX6pwEtLBxs43mYeI3abMKwXiV
         EagtH4aTKSsyhAM6PtLI8lMVyQ8YRXvzqJp0jmsQ8KJA+NrBKokv1Uxjc/uzX6X5g1ZX
         WbaTndG+S2jxN7nQFbgSwhgJz1vm/Ak0vfZQ0033DjqYuLzAbOoFkuinxYYnLy9rhB3d
         c+WvFNtu+nuRj1CPShc5iBHwhKaNpMhubm2AHngliZ8IXgezK/PXoQVgppDicFiyf9Aj
         7wNBTgGT8ZykbZ3sG5hHz2SOIatBy6Osl2ZKZZ8DM7eEJXygKO2afvo0EJdj8R4JnAMw
         CoIw==
X-Gm-Message-State: AOAM530Xm5+V9aemW+rFDYkl/WdJE81aWpMALDiJA1jEHRGuYFAmUv0P
        PLQV/FE/u2njwx4bK4MnQJ5tm2Uwm4UGcCQFWQ==
X-Google-Smtp-Source: ABdhPJzI1T8McZlIoA0sf6bztLH3WBdup6fzS5cp23Ntzzcb/8oA+VMcbFtGnTpIynAxzj4FvQFFnE7BM8+AvHZ9jQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:8746:: with SMTP id
 e6mr11266110ybn.89.1600852964527; Wed, 23 Sep 2020 02:22:44 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:22:31 +0800
In-Reply-To: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200923172129.v5.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v5 3/4] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.orgi, mcchou@chromium.org, alainm@chromium.org,
        Howard Chung <howardchung@google.com>,
        Manish Mandlik <mmandlik@chromium.org>,
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
index db44680fbe9c9..4048c82d4257f 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3083,8 +3083,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
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
2.28.0.681.g6f77f65b4e-goog

