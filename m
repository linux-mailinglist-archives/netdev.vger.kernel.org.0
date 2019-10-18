Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85827DC631
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410354AbfJRNfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:35:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43071 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfJRNfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:35:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id f21so2862217plj.10;
        Fri, 18 Oct 2019 06:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=SsJsXFic4Ds6Lk73dimunU2ietWwXXmu0ej5RwXC+UA=;
        b=GISxMSmdHRoQ6ishW/ilP5//aMCHUDDAFH5E/LaO4lJAnU3lQ+UjGv86+RCZt4Bud/
         XGtM8zFFSIfgylwzLsT/lTUeVau2ZDrnvdfZ99U7iRL3KEDI2J0Eiranv9SYdiD/tZ5r
         jNbVgAoBgA7NvN74bvp3RsnuOUdOlzgRAZ2jHINcxPdqpDlNfQ8pBaR9yd2yZ190P6Cv
         +KpMMHwryvuA5tWM5uQNjTjHQlhyI7nQO0NcW0cFJNLuOaW+dkt3f/LTAwzPi3VxhRXl
         jrdXlFLNy+NQkwlb1u2Sv0KwwAWBecE6T1jUYOvSfCtrp2ECfoKgrv3oecszHw1MnX5a
         bDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=SsJsXFic4Ds6Lk73dimunU2ietWwXXmu0ej5RwXC+UA=;
        b=jVgDl+Q64bzLzB0H+2YEoSsl4qxFsPIsOD1ophQ+skyyfvc26PGOA1HdyXXlSQCJTP
         bqoJUDlM2B8xJ9PWa+aiCX36ANBQxdUoOj5rfHMdq60xfsSge6P2FEC9j51EUD1Mh1ef
         01TwkHmi29KkQOjsNxazNqaMPesWnGGEcA+Q3+aclBOC27m3vGuSPa00P5U7/6yjPiHD
         FQdoRINTyCioN+4VPWqKyA/dONU2CCDBo6p5UGHAx3/zrNPGAx+Gj117V0Ps0Ei2wOTs
         9rsJfjLzsiedpn63nBRo5GYM+L2zEkESb4FTJMJSITS+PQF3gzM55jPr5zoXHR1zSrdL
         vh7Q==
X-Gm-Message-State: APjAAAVHMgJb/EMZCLaZiFixb70Q7d5gdxBJPMSu8zRbpdYaLyu5wezA
        NV62wNcIvR4qvZz+xLPMzHY=
X-Google-Smtp-Source: APXvYqwhWW+3kGLhJnDO7JbFfbTPaSBWfQxSxgmG2d8fwyCNuvqp0qF2VBxOO19wBJfV3FxDLDt6iA==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr10283792pla.55.1571405721031;
        Fri, 18 Oct 2019 06:35:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k66sm6163232pjb.11.2019.10.18.06.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Oct 2019 06:35:19 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hui Peng <benquike@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe
Date:   Fri, 18 Oct 2019 06:35:16 -0700
Message-Id: <20191018133516.12606-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hui Peng <benquike@gmail.com>

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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[groeck: Add driver tag to subject, fix build warning]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Fix build warning, add "ath10k:" to subject

 drivers/net/wireless/ath/ath10k/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index e1420f67f776..9ebe74ee4aef 100644
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
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 
 	pipe->urb_cnt++;
-- 
2.17.1

