Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93269808B4
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 02:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfHDA3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 20:29:39 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36226 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfHDA3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 20:29:39 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so56623374iom.3;
        Sat, 03 Aug 2019 17:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=86PJYgdBlM7UjsOQwJrxL+Im2FqipIlVfKPrHonN8B4=;
        b=O9USVhXRPTgtHHxYTLyQh1xeJrbeTxvqjrbi6pXgUmN5k7Id8Dfanw6Qp6iEdOPgs+
         85m3i2/kihoowrmcg0Wh+ci6Op8xgDrP5MbGJz4ic+3aJWlnKphgRiHmE7yUgNmDNsJk
         L/bnPqzoHrzUgVfb965bweaS8BFjwjRgrf2KIf1PEheZs4iVo96jwx0xjaQC49b1/4EI
         LRh4jJXem4PlfUy/YIMfmh65L1xDVhRELJIpXDBpIli8gHvYyDztIq9xVCA8I80SkZoY
         Hmk8bgHSZ8U8nBKRCdQXnn83kgYye9sl2zhsWqqKKsHFk9vdd1BO43KZ7EVSn9rdXzY0
         B5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=86PJYgdBlM7UjsOQwJrxL+Im2FqipIlVfKPrHonN8B4=;
        b=gYOq55YfI/1nGC16FYIg97YzOeZIyKNUDai/jiXqKDIXPtbiCoL4QuVYQYcuQ8HgTD
         7KBh/wJvLgl5vIwyioYmOiYjcwDVRYN3NSca56jaJ8U+aNNmrvUE49M1xZyX7GL5TsT0
         8qYmZ4gbEMWQPeyr39yu1fHaQ1AY1uJBNVVCt+ZAHVCxCDWC5jNksp7E1sNdcLQJnppu
         emaqf/zB2aqovOsfSmpu903jMy5jCUWbUtXhJ2qHHNEmr2c6sOiIrMEFCVbPXVrA8MIT
         glGR3KzSos3kEh1clnsvTLTdRLTnZsoipITv5a/iJi8FlX6zuNPToxlCyMNxYb8gfYlF
         ZMnA==
X-Gm-Message-State: APjAAAUkXusPtojwqJC6v+HKxtZNXvApVEXsVmXlKgckMEKkMsPt0cHO
        9dbSP+UgFl4JF8bNcWWYj3E=
X-Google-Smtp-Source: APXvYqw2OfxFgZMs4JjOK2/xGih0hENBHjaUw8oj/P06uwCMqq4IYpVyQhHWorFxKL00rtTzMhR42Q==
X-Received: by 2002:a02:b812:: with SMTP id o18mr35093577jam.64.1564878578620;
        Sat, 03 Aug 2019 17:29:38 -0700 (PDT)
Received: from peng.science.purdue.edu (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.googlemail.com with ESMTPSA id s10sm171136252iod.46.2019.08.03.17.29.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 03 Aug 2019 17:29:38 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe
Date:   Sat,  3 Aug 2019 20:29:04 -0400
Message-Id: <20190804002905.11292-1-benquike@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
are initialized to point to the containing `ath6kl_usb` object
according to endpoint descriptors read from the device side, as shown
below in `ath6kl_usb_setup_pipe_resources`:

for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
	endpoint = &iface_desc->endpoint[i].desc;

	// get the address from endpoint descriptor
	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
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
NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
`ath6kl_usb_free_urb_to_pipe`.

This patch fixes the bug by preventing potential NULL-ptr-deref.

Signed-off-by: Hui Peng <benquike@gmail.com>
Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 4defb7a0330f..53b66e9434c9 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pipe *pipe)
 	struct ath6kl_urb_context *urb_context = NULL;
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context =
@@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(struct ath6kl_usb_pipe *pipe,
 {
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	pipe->urb_cnt++;
 
-- 
2.22.0

