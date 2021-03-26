Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1281134A049
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 04:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCZDeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 23:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhCZDeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 23:34:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B20C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 20:34:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d8so249689plh.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 20:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0bvViS9LeLkNUb1dHs3t4SsHS+q0RLU7ZHpOnMbp6xk=;
        b=kahVZKYy5PkHEkeGcKLRiZee5AIb9OGTrhB4wzEJSH22dYTlt3mdRIxFO7La0yjBQP
         9NlyJ7fJR66vzPZfHbdS3jBQRTPYG/RzeDfHv1F0cxrUANh4xCJi5X35FmnTVG+RhRiN
         0rYsF47fcqy9GlXmnuZWjxr7ajst45OeiBPXQ6ZZmZnrfm9O1IG2Ldw6fHPWSBbXEcbF
         SP/jLHod8Mhf3jiyU3BbbPztoVGUOAQ/t3e3gERCR5TCNw+TW+LbXzyMA8/wPsRqGzOQ
         T+vcQmuOwFtHFaLf6SklP5T/ws4hsQDZ8BC0Y9+HNyhTEUUovLKn4yu3HII0zMQgMEc3
         ID6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0bvViS9LeLkNUb1dHs3t4SsHS+q0RLU7ZHpOnMbp6xk=;
        b=dAhTjv8Ia+bvypwMbpKWPKDCOiUFO/HShMcL08Y2csOzRr0UrAHKcYvHdsVaNYzlrR
         dGywGF3v5i/yFUy+lSaOcGETL54rePUg3zm4M0hwQ/fcWFPfA2ENn8JPO5+OHJ/B5urj
         qeVF9wo2xAbi4wl5NjT1zgExwqkhRrONXklcG47GcNv/32DoxvMfQmktTy/QHUe87IVY
         cFBtZgG9FJpjtTOuU6PEfOtcQYtATOlqER0r8Ag1AFjkf/qF9YEj0YqgaRY1qoLzvdby
         Vi1sca5eB5lM0eZN5YqBJk1Dl9uJK0D4rcRZxPECc3jZ0xCxY5JYAmrhna33DIaQRXgr
         9t6g==
X-Gm-Message-State: AOAM530bZdEaLDWorSmZpRZUQrfYWpDaHAkcqJhSr0HEA+C+Xf1BGir0
        NS/XP6Jx8MhaFmEkSBqUYhY=
X-Google-Smtp-Source: ABdhPJxCpe+h18dOOKyJYOo90HY8kFplcRcyt8nl/AYTSOCvOpCqawvQpeuumO12dTi9i+kRgJ9N0Q==
X-Received: by 2002:a17:90a:eb0b:: with SMTP id j11mr11395556pjz.62.1616729641449;
        Thu, 25 Mar 2021 20:34:01 -0700 (PDT)
Received: from ThinkCentre-M83.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id r10sm6336581pgj.29.2021.03.25.20.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 20:34:01 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Du Cheng <ducheng2@gmail.com>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: [PATCH] net:qrtr: fix allocator flag of idr_alloc_u32() in qrtr_port_assign()
Date:   Fri, 26 Mar 2021 11:33:45 +0800
Message-Id: <20210326033345.162531-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change the allocator flag of idr_alloc_u32 from GFP_ATOMIC to
GFP_KERNEL, as GFP_ATOMIC caused BUG: "using smp_processor_id() in
preemptible" as reported by syzkaller.

Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
Hi David & Jakub,

Although this is a simple fix to make syzkaller happy, I feel that maybe a more
proper fix is to convert qrtr_ports from using IDR to radix_tree (which is in
fact xarray) ? 

I found some previous work done in 2019 by Matthew Wilcox:
https://lore.kernel.org/netdev/20190820223259.22348-1-willy@infradead.org/t/#mcb60ad4c34e35a6183c7353c8a44ceedfcff297d
but that was not merged as of now. My wild guess is that it was probably
in conflicti with the conversion of radix_tree to xarray during 2020, and that
might cause the direct use of xarray in qrtr.c unfavorable.

Shall I proceed with converting qrtr_pors to use radix_tree (or just xarray)?

Regards,
Du Cheng

 net/qrtr/qrtr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index edb6ac17ceca..ee42e1e1d4d4 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -722,17 +722,17 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
 		min_port = QRTR_MIN_EPH_SOCKET;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_KERNEL);
 		if (!rc)
 			*port = min_port;
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
 		min_port = 0;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_KERNEL);
 	} else {
 		min_port = *port;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_KERNEL);
 		if (!rc)
 			*port = min_port;
 	}
-- 
2.27.0

