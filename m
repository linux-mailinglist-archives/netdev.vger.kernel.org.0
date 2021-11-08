Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1C449CCD
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhKHUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237800AbhKHUEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:04:04 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B423BC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 12:01:16 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id f10so18248736ilu.5
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 12:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VkkpMgbgETGhkWrLjDuy7MIX7ArbNiB9xjyPcashqk=;
        b=QmhBF3VeCGi6qNjxFLNXIop7sMD9HhUt8pqWdlvEBJS+zy1GyWs/acy9z8GMukQvOr
         l9C1xS5FCFKmG0mlqXx/Ihhrlz67+nkSXiO69iDPyZCRKQCvSCy2DLYjEwxeh0E84RJw
         OROMeAlYwOQMYykFkvChrLEtDJKp4K3+oBmws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VkkpMgbgETGhkWrLjDuy7MIX7ArbNiB9xjyPcashqk=;
        b=MEfikeGpLjjqhwlv6hZfC/YSLW5IkpPCcw+Fh5TTQrrSJU+510bAbNaavHmSw3Mg6J
         wAvWrds73fnzZrRCTULCl/WH3oobO6BkPUMyg4LJ8vSJswLQ378M8FACM6sb3SlIdpZ7
         DDI2LJFLr3xDJ+G4A4R7E/OK5vTAGp04BK8W0qlt7rh4W5eQBpJwHylob3tNPyD1kOWv
         HLcvoaiXmy7BlMEk6tdL6Bld9eY2Rd7Q3+ySywd+nmeXfsrFTWkENiIefUoO9/UHfXGU
         i+ZQAk7Jo0GJHuxGzSdUknuapKWTUqaZgwM9BvpO8/H2W30v2Nwc9M2m8l49QGJKONe+
         QBuQ==
X-Gm-Message-State: AOAM530vykc2ooySvdXV24s/VsyBLo3IvvvLj8mPi+81ry+aHYGP8YrG
        qK5BfMxGKfzkjTCX9bmAXrvnLQ==
X-Google-Smtp-Source: ABdhPJwbjVG4yL2cXb08CXlv5Fi08RcrfCPB6jvIaj8FgLPJ3zvf2VJlBti+h4gNR1iq7RuqD0pZ0A==
X-Received: by 2002:a05:6e02:2166:: with SMTP id s6mr1200086ilv.170.1636401676182;
        Mon, 08 Nov 2021 12:01:16 -0800 (PST)
Received: from melhuishj.c.googlers.com.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id r14sm10682100iov.14.2021.11.08.12.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:01:15 -0800 (PST)
From:   Jesse Melhuish <melhuishj@chromium.org>
To:     linux-bluetooth@vger.kernel.org
Cc:     Jesse Melhuish <melhuishj@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] Bluetooth: Don't initialize msft/aosp when using user channel
Date:   Mon,  8 Nov 2021 20:01:06 +0000
Message-Id: <20211108200058.v2.1.Ide934b992a0b54085a6be469d3687963a245dba9@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A race condition is triggered when usermode control is given to
userspace before the kernel's MSFT query responds, resulting in an
unexpected response to userspace's reset command.

Issue can be observed in btmon:
< HCI Command: Vendor (0x3f|0x001e) plen 2                    #3 [hci0]
        05 01                                            ..
@ USER Open: bt_stack_manage (privileged) version 2.22  {0x0002} [hci0]
< HCI Command: Reset (0x03|0x0003) plen 0                     #4 [hci0]
> HCI Event: Command Complete (0x0e) plen 5                   #5 [hci0]
      Vendor (0x3f|0x001e) ncmd 1
	Status: Command Disallowed (0x0c)
	05                                               .
> HCI Event: Command Complete (0x0e) plen 4                   #6 [hci0]
      Reset (0x03|0x0003) ncmd 2
	Status: Success (0x00)

Signed-off-by: Jesse Melhuish <melhuishj@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
---

Changes in v2:
- Moved guard to the new home for this code.

 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b794605dc882..5f1f59ac1813 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3887,8 +3887,10 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
 		ret = hdev->set_diag(hdev, true);
 
-	msft_do_open(hdev);
-	aosp_do_open(hdev);
+	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
+		msft_do_open(hdev);
+		aosp_do_open(hdev);
+	}
 
 	clear_bit(HCI_INIT, &hdev->flags);
 
-- 
2.31.0

