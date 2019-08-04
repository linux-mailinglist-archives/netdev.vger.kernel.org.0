Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A34808B8
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 02:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfHDAbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 20:31:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39783 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfHDAbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 20:31:08 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so160277572ioh.6;
        Sat, 03 Aug 2019 17:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRZqAf00TpYOcC6bW+lbGU9YVHInZQbHpXUrVaIGSGA=;
        b=mE/gEiH7NhTRmWW7ly2DdFH/VIcQpG/K8k4kGRAuVrjdjWq9QYBkrhThwHk9C5luCt
         WFt0wfieUiwXrr7IBreIXNgZGMZ2OBhfKJDdglZFvEMDLGNoLhQJo8fCbxK1aKSw0L9i
         TcxEQHKXNvL+sLHTjG9QhHEs78lu34r11on9cKitCI+dQ7jh+eIOxghkFiuUf3XqmUDd
         nPti0umEif0fDgK5FxhmYC2TApQOk33FWzW4mBGcKheaXsLFti78/ayb1MCr40pl73j0
         k5xfmRE7/4X8ltd7AjDv1Y1iFyw0SCzMCzTfiRh/z9rnA37uFxSn1KhFKulSBli3KHku
         yrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRZqAf00TpYOcC6bW+lbGU9YVHInZQbHpXUrVaIGSGA=;
        b=fTO9PSNEQAH8KTptXLO/o5LLC5PJ/7JbyQAE/YXMAQhb0FJrU/p9g7lvF2hdV4zLst
         7rJ+uhLOQr5rb44R2+OeWVVVS6wbN6LG21R1RxWUxjw7zk+Fm3Vfpe9chikg6njp485I
         XMboK8k7TWsXSkgRe0BW2hZknZbZGDwYwZOLmhJzWqi0Rx4dc0clPQN1ko5rQsdzUqGT
         qxl8uMzLP0aVQKE3Fq0gDsnzSuj8fCMlaBvG084sJqSuUnKuOfIHvrzu+oxSun0+LOlq
         UFTJxhISMBvP4D3u9wM9FP5bB/3u3VxKS7OOM0ttIjIXyX8V1NGVxJUwxgunGaqzhPoE
         zWsQ==
X-Gm-Message-State: APjAAAXb/E7BxwWLRG6+DU0aHJWgMCwduh7QsRCCBk7en0egcS4E0H6z
        bcYL+HTF8X6v8ycE8NNaeUs=
X-Google-Smtp-Source: APXvYqyIUI7fSNQp8L6VocRfRHB4oSQN81MaPNSESXmH+6nxzWBATVq9Gk86g1g8CJNtBZIb6Xsg/g==
X-Received: by 2002:a02:22c6:: with SMTP id o189mr54760745jao.35.1564878667834;
        Sat, 03 Aug 2019 17:31:07 -0700 (PDT)
Received: from peng.science.purdue.edu (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.googlemail.com with ESMTPSA id s10sm171146661iod.46.2019.08.03.17.31.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 03 Aug 2019 17:31:07 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe
Date:   Sat,  3 Aug 2019 20:31:01 -0400
Message-Id: <20190804003101.11541-1-benquike@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
are initialized to point to the containing `ath10k_usb` object
according to endpoint descriptors read from the device side, as shown
below in `ath10k_usb_setup_pipe_resources`:

for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
        endpoint = &iface_desc->endpoint[i].desc;

        // get the address from endpoint descriptor
        pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
                                                endpoint->bEndpointAddress,
                                                &urbcount);
        ......
        // select the pipe object
        pipe = &ar_usb->pipes[pipe_num];

        // initialize the ar_usb field
        pipe->ar_usb = ar_usb;
}

The driver assumes that the addresses reported in endpoint
descriptors from device side  to be complete. If a device is
malicious and does not report complete addresses, it may trigger
NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
`ath10k_usb_free_urb_to_pipe`.

This patch fixes the bug by preventing potential NULL-ptr-deref.

Signed-off-by: Hui Peng <benquike@gmail.com>
Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
---
 drivers/net/wireless/ath/ath10k/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index e1420f67f776..14d86627b47f 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -38,6 +38,10 @@ ath10k_usb_alloc_urb_from_pipe(struct ath10k_usb_pipe *pipe)
 	struct ath10k_urb_context *urb_context = NULL;
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context = list_first_entry(&pipe->urb_list_head,
@@ -55,6 +59,10 @@ static void ath10k_usb_free_urb_to_pipe(struct ath10k_usb_pipe *pipe,
 {
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 
 	pipe->urb_cnt++;
-- 
2.22.0

