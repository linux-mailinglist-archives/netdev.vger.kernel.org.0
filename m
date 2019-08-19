Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0F95068
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 00:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfHSWCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 18:02:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33900 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbfHSWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 18:02:44 -0400
Received: by mail-io1-f67.google.com with SMTP id s21so7791675ioa.1;
        Mon, 19 Aug 2019 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkPsYIq5p1Usn95zadxgW7erLbA98guz1UFddB9orFo=;
        b=IRgzkkQ0QlYiIqgU9DslAGaSx9oz5wU5adcfTZWc60ibm3DHynGVVixJrWxAut0Pae
         ARzqaY1/pxrAMSpTdcKfCBtRoFPMFS8+WZsScW495O7Pf7bJTCDAo3OOueleEgGs9Osv
         59921BouToXc5Ovc92CQFjNHP3+/kGBqZvxV+QK34IvNWzoIEU93UHsUIxSn6eVvrsFU
         g5treQ50nJkKHPa8rwc0Oh9s6WWKODy8zKxExTJhdznLdHOm5T7muHcEccqX8YZQ5L7d
         ADPOmA+sRvWN3t/z9HxtD4g/Lgj4kzEYFnWJ9k7ClZwbnzn02QUlkT8waxriC/Wpe9nP
         q53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkPsYIq5p1Usn95zadxgW7erLbA98guz1UFddB9orFo=;
        b=oYozfHj6p7SMaYdxmSXvkqz3omwdyg+ftHjVBaHiAqBlnLj6x9531et8jUk50jueoT
         y2cU/oVuoVQsCwOEu43hu26qlol2JSmB1xXJj0Za8nKZa3h3GF5CKG8/dexHz8TzCJX1
         vo/TNPdY3AlW7Sn9JLnWCqFK+QgbPhjdBs+6Hbh+5nkCxIG5dVn0FfYbLYATeh/888YB
         pTCJ8dkbLQiWXEJam6b9NoOpcIzbpcb7rL3A355C/1AGZsCy/NlKmneuw0Va10AnswkK
         KBYv+EisB1L8oCP9l6r5fp4PUqyMH3TjrBdJddx8EQ9cq8SORiLtmmRuF8e3kdImDEK4
         6Gcw==
X-Gm-Message-State: APjAAAXB6U8H/6BuBUmOb6K7bk/qaEOOS1bw9RIpAgXyrExtL8rl/B99
        17LNTRGgJKvcUB6qlr4ZRbY=
X-Google-Smtp-Source: APXvYqzjT1oN5/e8keSQCjVxoTzLRGG1vuf4kTYM+hq51sy7QzOV0GLDOYYsYVB78xsRtsZrFijh0Q==
X-Received: by 2002:a6b:f30b:: with SMTP id m11mr21952710ioh.214.1566252163559;
        Mon, 19 Aug 2019 15:02:43 -0700 (PDT)
Received: from peng.science.purdue.edu (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.googlemail.com with ESMTPSA id z9sm2850133ior.79.2019.08.19.15.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 15:02:43 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     security@kernel.org
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix a double free bug in rsi_91x_deinit
Date:   Mon, 19 Aug 2019 18:02:29 -0400
Message-Id: <20190819220230.10597-1-benquike@gmail.com>
X-Mailer: git-send-email 2.22.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`dev` (struct rsi_91x_usbdev *) field of adapter
(struct rsi_91x_usbdev *) is allocated  and initialized in
`rsi_init_usb_interface`. If any error is detected in information
read from the device side,  `rsi_init_usb_interface` will be
freed. However, in the higher level error handling code in
`rsi_probe`, if error is detected, `rsi_91x_deinit` is called
again, in which `dev` will be freed again, resulting double free.

This patch fixes the double free by removing the free operation on
`dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
used in `rsi_disconnect`, in that code path, the `dev` field is not
 (and thus needs to be) freed.

This bug was found in v4.19, but is also present in the latest version
of kernel.

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index c0a163e40402..ac917227f708 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -640,7 +640,6 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	kfree(rsi_dev->tx_buffer);
 
 fail_eps:
-	kfree(rsi_dev);
 
 	return status;
 }
-- 
2.22.1

