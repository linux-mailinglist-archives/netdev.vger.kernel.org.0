Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B652A5E8F1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGCQ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:29:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34623 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCQ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:29:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id p10so1518165pgn.1;
        Wed, 03 Jul 2019 09:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=04Hj/WdvzuLzOJjMkD7fC2LOSN5S/bO7trpMF5tdGUM=;
        b=Om/mc10H3ZPCBSupnA4WtkyK1B97eLQft+s1Xdkd0Y8PVRbxxOuH3OtM4WG9aUHNUF
         KlZVuCVFvrdZbmxh7quYXt1cywv4vNLyL/E5U3X4aLI6D60r00JsuOfTfCnWjhdqmYXg
         GtOgpeiOfx6TeWusox8ops4V8QbAZ86E5o7LIPh4VejMGz1PA9Vko3nikYW0vCMtyE+a
         zyoB6hlIK1VPVkfz7kWj46Fm9+1KNcyf9KocY5U2Mybuv4SdjXFs5xC8ME0iK7T3RV4d
         LlsIx2Zly0mvs/FXsnQUZqEgWkAH/lOr1ot1HpYu05fGMB20wm3B+Xs1f82WOt5x5QPq
         1qaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=04Hj/WdvzuLzOJjMkD7fC2LOSN5S/bO7trpMF5tdGUM=;
        b=sU9LwjOvnSDRlXsIiNVIJcAhQlZLH2fHKaG8aOme/t1Es7R1tn9Ah2+/55uh6K0AHK
         7pYWXS7W/fcGf+R13FJAvb/X7HaE7+W62WDvBP2yVgmD3in5xxJG5A4NYEeN06nwEiXr
         wRCV6li0v3XOG5HGv53sj5WJSjriJOxeR7IL3FV+Ed9OcuUNrymR4LXjwk/wPnFiUKNG
         egXJW6PVnM8doABV5VrXIJ8wn7h3vfHw0iAJYek2QLAxAJiPtTknKFppLTPd+JNM9aao
         YHfLMCmep7d3yzvMLAFkdE66prdrrb3BGIzMBsEKsQcRtjbBwBlEFFjarmOs+T2hm22W
         8Ehg==
X-Gm-Message-State: APjAAAVOM6D8VZSxyiH6DkCluVI7en5v6n6uC/MK+jDT6xtpfx6TjKDM
        jp4WuIxMoza1LJ6b/jUZTRQ=
X-Google-Smtp-Source: APXvYqwLeW3rbu89G9n1ihIEgC4zHvxGxnLNMk5iAv8bQXBKoxUit4zjZi7Wm7ko1Wg2EhsuC1U46Q==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr38498839pgm.40.1562171370236;
        Wed, 03 Jul 2019 09:29:30 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id 3sm2908130pfp.114.2019.07.03.09.29.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:29:29 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 16/35] net/wimax: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:29:23 +0800
Message-Id: <20190703162923.32599-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

 drivers/net/wimax/i2400m/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 2075e7b1fff6..cdce6c47c444 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -155,12 +155,11 @@ int __i2400mu_send_barker(struct i2400mu *i2400mu,
 		do_autopm = 0;
 	}
 	ret = -ENOMEM;
-	buffer = kmalloc(barker_size, GFP_KERNEL);
+	buffer = kmemdup(barker, barker_size, GFP_KERNEL);
 	if (buffer == NULL)
 		goto error_kzalloc;
 	epd = usb_get_epd(i2400mu->usb_iface, endpoint);
 	pipe = usb_sndbulkpipe(i2400mu->usb_dev, epd->bEndpointAddress);
-	memcpy(buffer, barker, barker_size);
 retry:
 	ret = usb_bulk_msg(i2400mu->usb_dev, pipe, buffer, barker_size,
 			   &actual_len, 200);
-- 
2.11.0

