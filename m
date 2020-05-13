Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336A81D049F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEMCJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbgEMCJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:09:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7A7C061A0F
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:09:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s20so6211625plp.6
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zcD9lBfIOsrbGLPLwHavFpU04q9rS7x1jNQUtnqQyIk=;
        b=gK3dvzuSyDVkWgPlzx40qbLhAs0owj9fIDJoyReMIZDN7XH+poriF7uHhlAQ+w+Fef
         DfYQXms3qL1YXiyZFcegyl/miVUznOD7rrVn1aG88QwK6QTyvVR2rQ9JGnEXNfUDGcCG
         FsW+Xj94YC0MRj70Y4eNIEyKrmXxmy0uYMqWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zcD9lBfIOsrbGLPLwHavFpU04q9rS7x1jNQUtnqQyIk=;
        b=E/kmw2ES2kDk/lnzL7wkGnNt8mBKEbA+MlejiBsl4UDTRp6cr3SRHQ80OSFjRA3LSb
         MCZ3zJBnnC83rvG0AlUn+uTP2IyuaKMkMUbhCnNmdfUnD/H3SK1/8k/38L66ZPJLLaGE
         6VfqIe4dpypk8XVhCaljmr5tu2xmAAzybgY7Vt5FT5ZavG79AmhNGkN4sgXZ9i2cLrqw
         VkwYr/hAw5JLExSnm42H2vW1ckS0zJBy2CIp3XrEgJoGPRA7t6fSm7CnudPkLTaXiioS
         1uQqx0sB2MZdRdUG3Kmk5TTCkUqjVl23fpbq0sJH0DDX5sOjuOszLrugcqB0YSCaBxOD
         50sw==
X-Gm-Message-State: AGi0PuZwdjdruun5K3nGR2e6aZ/g/QnThnXKqwFFEAn1OzWtbqj2G/hb
        33TcLRWBal2dKMBeOvNHPtAonw==
X-Google-Smtp-Source: APiQypKUVISxkbjbdV4dsOfusvVUfRQZvsmwFin9ROrdrs/K1iU7S4CxumWbbsgAW44gvZn353OnYg==
X-Received: by 2002:a17:90b:2388:: with SMTP id mr8mr30064911pjb.97.1589335782204;
        Tue, 12 May 2020 19:09:42 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id x7sm13456749pfj.122.2020.05.12.19.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:09:41 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/2] Bluetooth: Fix incorrect type for window and interval
Date:   Tue, 12 May 2020 19:09:32 -0700
Message-Id: <20200512190924.1.Ibdf1535b0d4c63aaf337161a333b419d6d32c364@changeid>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
In-Reply-To: <20200513020933.102443-1-abhishekpandit@chromium.org>
References: <20200513020933.102443-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types for window and interval should be uint16, not uint8.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/hci_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 3f470f0e432c7..f6870e98faab2 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -890,7 +890,7 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	struct hci_dev *hdev = req->hdev;
 	u8 own_addr_type;
 	u8 filter_policy;
-	u8 window, interval;
+	u16 window, interval;
 
 	if (hdev->scanning_paused) {
 		bt_dev_dbg(hdev, "Scanning is paused for suspend");
-- 
2.26.2.645.ge9eca65c58-goog

