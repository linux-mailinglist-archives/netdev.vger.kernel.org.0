Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2843DFDF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJ1LT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhJ1LT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 07:19:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355CFC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 04:17:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id n2-20020a17090a2fc200b001a1bafb59bfso3316936pjm.1
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 04:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GLQ+L+UcYTSp2/Y+0P8XzAsQnHNY9bHOBMNnmhNwbDQ=;
        b=d3NIcIwokIWonEmbf7MookaznzBcbbR/xPmbVwrpZ6ARy7MF/d2Cq7YDB37xDmq7GG
         QL8l7FWYMHnfPHZsKHYBX3bpVUXUn57ihZLs2kPlkv/uMVBplpS+T2YC2unVWRalQnOn
         JgugvJoAURa8Qt9vvQqvXurReq0r5yZybIbrvMOsiZZLimJgc07FE11UwNRe8qBqj+q4
         sQKoznSpZ/FWXU0bCBzRG4y2/f89a2Sl3E/Letp2Oj7bZ72+1wwIv1tAYeRBRxB3QLFB
         4XDu9RGA49JXcsxzZNm8RmXGHoCdTcY3SaXfASICvJ5hmNuvuB5vsn5zMpeja6pQKKMd
         ffaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GLQ+L+UcYTSp2/Y+0P8XzAsQnHNY9bHOBMNnmhNwbDQ=;
        b=2dU/oU34cL08ybeAA9Vslcaqt9PojYN2SFkyV9oKRqIfzPWFJ7YZXa/cjFECu6cKLD
         Cm7pnUn+lDAu5Nmd19SyN8/Ht2mSm+4FM1hKgV1ifQEo+usZNl8dPSX4hI0aL/lTxFv2
         Ww2f4Gh1QHCcmI+Xq4pdy00Y2nHuiNdbr4gx0y7QqVz0FU4N/Qv/JLMcTMg63WXipSjv
         dCBqIKyftkz7B1HWhtk/Zp0v12hBQGJXfdirP6nwPDhqep1RrPtUhparVy2Eog9MT32L
         K0PCswAP2nPdPA6xLOXGts1Mn9bmSq+7WklqWCembUPcR5e3mjvhgfcG0L3o/qKYRK84
         5Ivw==
X-Gm-Message-State: AOAM532OlEgH9gYhSDY61uKJ66tL62e1x1TP1aIUTwpY4JvwOffsy9Ii
        9QsjFOHYT+hj9nKGnS6zCr2lv3upfWIq
X-Google-Smtp-Source: ABdhPJzEqxn6IlTlcgdVmZzZkIoBUXuXH7A8M3mYc2iyg5hmt+gKEEUQiKxEpUouvDg+fQsOv6AiTHJj1x0U
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:a9d:c667:f9ff:b40e])
 (user=apusaka job=sendgmr) by 2002:a17:902:7608:b0:141:9a53:ceff with SMTP id
 k8-20020a170902760800b001419a53ceffmr779355pll.78.1635419850277; Thu, 28 Oct
 2021 04:17:30 -0700 (PDT)
Date:   Thu, 28 Oct 2021 19:17:25 +0800
Message-Id: <20211028191723.1.I94a358fc5abdb596412a2e22dd2b73b71f56fa82@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] Bluetooth: Fix removing adv when processing cmd complete
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

If we remove one instance of adv using Set Extended Adv Enable, there
is a possibility of issue occurs when processing the Command Complete
event. Especially, the adv_info might not be found since we already
remove it in hci_req_clear_adv_instance() -> hci_remove_adv_instance().
If that's the case, we will mistakenly proceed to remove all adv
instances instead of just one single instance.

This patch fixes the issue by checking the content of the HCI command
instead of checking whether the adv_info is found.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>

---

 net/bluetooth/hci_event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3cba2bbefcd6..894670419a27 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1326,8 +1326,10 @@ static void hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev,
 					   &conn->le_conn_timeout,
 					   conn->conn_timeout);
 	} else {
-		if (adv) {
-			adv->enabled = false;
+		if (cp->num_of_sets) {
+			if (adv)
+				adv->enabled = false;
+
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
 			 */
-- 
2.33.0.1079.g6e70778dc9-goog

