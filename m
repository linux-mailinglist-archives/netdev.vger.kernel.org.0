Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB29A162538
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 12:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgBRLFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 06:05:23 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:38036 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgBRLFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 06:05:21 -0500
Received: by mail-pj1-f73.google.com with SMTP id 14so1202169pjo.3
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 03:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CAoGK0unI+k/xLNKWQdh/lAz4VEEtKso1RLerS+jz98=;
        b=o6TrpqGwRyQGGsIaFlxwYKueoWgUAF4oLyN9Z3JTTL7WDa7Y45dVKy3jvooyfmhZal
         c88Ik7pzARj6rngW3H4f35VaNEbgNOHMBModA1la5bjN7qgpfUN4aYp/5fiY++J8uTX5
         7NzMK7/5IFSWXrCT2gUamB6pnGF0OVVh997QnEhkaXjCL7th7EHVPp2mhIVZg8rvBFIp
         cmm8ei+0ULdDQRGUrxXgd158260yWzyXBxa1HHyYWWYh+WOCMsiBseJkaF5qDjVEKTCj
         7kNb8u00EIQTLAMtbIBMnhnzVvuZ3hT13+X2WYS+FUTAWhj/moREt93bkbfABL/TVgl2
         XpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CAoGK0unI+k/xLNKWQdh/lAz4VEEtKso1RLerS+jz98=;
        b=M8JFwTPK3LbksfGHXBXBW9XP7h0GPsFJXMTf3egznKuvvaCC2VuyipMz9UKIXewZ8i
         PCAXKXXQ2UfdmRb7UajpEc3LYsLBlsvMX7Xx/enOUFZ/3Wg/X8uiKNMInqKVh44ZnxET
         CuPTHvFRuXmH1wCZdYpVtP6Re5THd1QHZSErewOSXjmKNFE2Ack+OPWpzQEyunj/uVc2
         vPRKxRSuK1qTrmlVyl34MH7vMTmE7b8j6B/zx8SjUFA5DJ6rIVaQyc+faI/aFUbDO4Bq
         AJVMbLmMermUFi+gt6HwypqkapwuU1Wpj4JrksEcbujYRPFt5CUM5yQeGFU4y+aGXYez
         yleQ==
X-Gm-Message-State: APjAAAVWbZDG/+pMRImyiohkI77BR15jRhYKRJJvlgSjl+z/Oj4NESyC
        AIbLHL/YrJnlSA4Ej4bgsD2sTbbupJJbGFIfzg==
X-Google-Smtp-Source: APXvYqy8QXu88UfVxv1mCeKTOtVGqBAda09uLXAcnx1IfRX/aGLHvD+3P7BIZvf5E9bFI9KyVQXAtyUv9pxhStFRHg==
X-Received: by 2002:a63:6383:: with SMTP id x125mr19783198pgb.409.1582023919543;
 Tue, 18 Feb 2020 03:05:19 -0800 (PST)
Date:   Tue, 18 Feb 2020 19:05:13 +0800
Message-Id: <20200218190509.Bluez.v1.1.I04681c6e295c27088c0b4ed7bb9b187d1bb4ed19@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [Bluez PATCH v1] bluetooth: fix passkey uninitialized when used
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        "howardchung@google.com" <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "howardchung@google.com" <howardchung@google.com>

This issue cause a warning here
https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU

Signed-off-by: Howard Chung <howardchung@google.com>
---

 net/bluetooth/smp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 50e0ac692ec4..fa40de69e487 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2179,10 +2179,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		 */
 		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
 				 hcon->role)) {
+			/* Set passkey to 0. The value can be any number since
+			 * it'll be ignored anyway.
+			 */
 			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
 							hcon->type,
-							hcon->dst_type,
-							passkey, 1);
+							hcon->dst_type, 0, 1);
 			if (err)
 				return SMP_UNSPECIFIED;
 			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
-- 
2.25.0.265.gbab2e86ba0-goog

