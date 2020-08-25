Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E1252434
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHYXcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgHYXcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:32:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32243C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e196so355344ybh.6
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kaUkInMqAgQ2Lzd+PreohlLW19JNhR91SpBMUzQm9p0=;
        b=PAfzZk/j+abf2vwqzxAFT3gplmX2gT7/B1H66vAmV6b/W/XwPJgtb8FtPyZDKENpe8
         tcViB/VjdULapoXGX1+NZ10q95Z0GApG28ULg75ofb7vBDHgsoJhMdvc85pLcfMtZV3L
         NbQgmUdXZ769CN8kuqLK6y3plvqnQpVXo8L7aY+pISgsrRsqa49ETbVSXd3YHuYj3/O5
         D8VnYchfeiM0YGhbU/MdVsCVzZ63RvbBxgB3ez4T3MdzdkvHpNCFSY4brrYZ+kLf0xFq
         nTxRTQVpWpKkgEg7h+fvY7ADfBsXvcDBMd268eE1GeY7hCANlw9uRxLwYupX58/Sc4Fp
         wbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kaUkInMqAgQ2Lzd+PreohlLW19JNhR91SpBMUzQm9p0=;
        b=jizFyRKgB7Ztr1z0hhx83UuDWPIZInvSv9qeeEGF+1dodPLMYhUSv8dEefN2TdHKp5
         Z9fo3sN4UukBCBAtbd78fL3EgxbjZJG0PNNKPoFVRnclY4EtlCqNmUsBITWsQSEZ7b0Q
         R3VCwNCJ5ELT4eng94Jdha8OwkErkuDqH1HfvEVWaTvaoj3cLepoNRXgFynH6cFIxwMI
         9XcNHx0XZ21HdW3Zf8Ecq2IOyI0MMVN6vWaIoVs4brqA0Mv3TZ6K+b9bMm8aTMapI1zL
         zbsOokyB0Dixz3OjFucPUS9RjYbcau6MfXw2oRiWkwKQOseKDdCJt/2BYdGHTER4/Xl8
         H97g==
X-Gm-Message-State: AOAM532LGcOkkP0yQF8m03yYnbsrvSA/JAhQUBSw3XgrhGZueG2RsyT2
        N2Ppo0uen5PUL13l0F29QNW2WWzB+D1H+etg2ecT
X-Google-Smtp-Source: ABdhPJxknta/s/oAGl30UwT+/4w1jNnjt42KUayAVjKNAjWvqKRJyEtmfW6BXOaX6IuAsQ4X260dPO/cE6HnQxsUjGv9
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a5b:70d:: with SMTP id
 g13mr17995321ybq.160.1598398325448; Tue, 25 Aug 2020 16:32:05 -0700 (PDT)
Date:   Tue, 25 Aug 2020 16:31:50 -0700
In-Reply-To: <20200825233151.1580920-1-danielwinkler@google.com>
Message-Id: <20200825163120.1.I1f7e93bc6bad468fdc24fad319de8c32621a49a7@changeid>
Mime-Version: 1.0
References: <20200825233151.1580920-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH 1/2] bluetooth: Report num supported adv instances for hw offloading
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we make sure we properly report the number of supported
advertising slots when we are using hardware offloading. If no
hardware offloading is available, we default this value to
HCI_MAX_ADV_INSTANCES for use in software rotation as before.

This change has been tested on kukui (no ext adv) and hatch (ext adv)
chromebooks by verifying "SupportedInstances" shows 5 (the default) and
6 (slots supported by controller), respectively.

Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 net/bluetooth/hci_core.c | 2 +-
 net/bluetooth/mgmt.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b66250f..500ab478769508 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2963,7 +2963,7 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 		       sizeof(adv_instance->scan_rsp_data));
 	} else {
 		if (hdev->adv_instance_cnt >= hdev->le_num_of_adv_sets ||
-		    instance < 1 || instance > HCI_MAX_ADV_INSTANCES)
+		    instance < 1 || instance > hdev->le_num_of_adv_sets)
 			return -EOVERFLOW;
 
 		adv_instance = kzalloc(sizeof(*adv_instance), GFP_KERNEL);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5bbe71002fb950..8041c9cebd5cf6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7250,7 +7250,7 @@ static int read_adv_features(struct sock *sk, struct hci_dev *hdev,
 	rp->supported_flags = cpu_to_le32(supported_flags);
 	rp->max_adv_data_len = HCI_MAX_AD_LENGTH;
 	rp->max_scan_rsp_len = HCI_MAX_AD_LENGTH;
-	rp->max_instances = HCI_MAX_ADV_INSTANCES;
+	rp->max_instances = hdev->le_num_of_adv_sets;
 	rp->num_instances = hdev->adv_instance_cnt;
 
 	instance = rp->instance;
@@ -7446,7 +7446,7 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
-	if (cp->instance < 1 || cp->instance > HCI_MAX_ADV_INSTANCES)
+	if (cp->instance < 1 || cp->instance > hdev->le_num_of_adv_sets)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				       MGMT_STATUS_INVALID_PARAMS);
 
@@ -7699,7 +7699,7 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
 				       MGMT_STATUS_REJECTED);
 
-	if (cp->instance < 1 || cp->instance > HCI_MAX_ADV_INSTANCES)
+	if (cp->instance < 1 || cp->instance > hdev->le_num_of_adv_sets)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
 				       MGMT_STATUS_INVALID_PARAMS);
 
-- 
2.28.0.297.g1956fa8f8d-goog

