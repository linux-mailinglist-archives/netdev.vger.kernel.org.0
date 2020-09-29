Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C501427CB28
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbgI2MZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbgI2Ldn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:43 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25082C0613D6
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:57 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c5so2685614qtd.12
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=m75O2982+PQQujsmqb8P0g73yWH7B3X1YjQuvuJ3s38=;
        b=P0EFlUaqz03Mx4ll/cRUbZKm0DPRGoRvKrTFutN8HNdiCtTIenEuESdO/ZTFjxPk9U
         vxeM3le0FTQL1YJQgMEEKP8dPph18/mQKGrYdKdJV4cA+vPrfrkVKdzvCpil94w/d4vg
         e2rMbo/SW80jIHb9Pw3J0btcxeW5ovaY1X9UkS0I9TNbMT/1Tv4kW65cBcuCIBKRm7ja
         gySFr6i0waDdV07DPFZmJjaRN2SM6Xio8FaTwqNTtIESERmytHtpu30HPz4wp9wcY+Ua
         tr+W/MKovNUE9PimMT+3XbyOCKXD2VfDpnBJrqgDl0EMYKQhKE7XlJVgbmGa8QP9Q9C1
         0E0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m75O2982+PQQujsmqb8P0g73yWH7B3X1YjQuvuJ3s38=;
        b=Dl3NiOYMDhvbAN1FUKut8U7zi44DFUbygiYPV2pqN7KEeBeljTv8QOhudey9fqQ0Hz
         oA/DIJE3KyiAQITjrlr8KBSoPay/AI7PUHJ/haNtRbzbxo8Gsjp1UqphuT5POJod5cjc
         O9dRzMVSgTTH13xsSG4jSxNAH0dpCsWfHMkdAWFeeNaAPqMb6chr9IQpmwR3Iz1GmHnD
         D3ZLS+vv51WSlCYNwnG3l7r19VL+k54ixQeuqvsoXOXavTKgRAAQEYJjcl5jYc1EA29m
         I0rGMwajJ+HAsYs5pwr3mVg0nviOE3wNa7EADKRjssGlKC1zhn+LSrHNSyIoLGobTv6k
         HtUQ==
X-Gm-Message-State: AOAM533t/ns1s22FxHyo8SVLSmrbbrdTJYAuhMin7vkIMG2PuvveBOfR
        AhoMh/0o57K0io7M7qf3PxJjI3k5LvK1Vc4Wgg==
X-Google-Smtp-Source: ABdhPJwSYEndcvqnyOVxihgzuHG+2ktZR5vXcAP+SWXeCZwLUBigIU9X83j1nNQWDtsbD55xexKgCizCoVS5IjnGsA==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:55ce:: with SMTP id
 bt14mr4131043qvb.2.1601378756257; Tue, 29 Sep 2020 04:25:56 -0700 (PDT)
Date:   Tue, 29 Sep 2020 19:25:25 +0800
In-Reply-To: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200929192508.v7.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v7 3/4] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
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
2.28.0.709.gb0816b6eb0-goog

