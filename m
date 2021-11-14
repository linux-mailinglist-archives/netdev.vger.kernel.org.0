Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2E44FBAD
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 21:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhKNVCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 16:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbhKNVBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 16:01:42 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D72FC061766;
        Sun, 14 Nov 2021 12:58:45 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id z34so37857283lfu.8;
        Sun, 14 Nov 2021 12:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vs9jSLKCmdkxQSqAksYeNKq9L10k5b5K0Jq3IZwJy9k=;
        b=lazLZc7l+mVk/0XONP7Mn59/PS4C+2oozp93NEjYfStCesafIc5fV4EdfKnVneksag
         9b+eip9jCfyPFZt833d9F74eqBVtfTdP8Dsyo0sVPJppAPlH04suNH/+ON4e0RWT4vZA
         +mXl6YXP2V0cNxdpoSr90BuxnFZvnJqYdG/i9sHoU7I7dG94PZGLr1LNAUgc52PK/G7K
         Jy8+N4x6C+Co1ALIFoG631/4g6SKxSOTlG2+MjGOB80jrwSafi3S4Ad4QzQqESRhttPs
         4rQPSdDjxHNFYU/pY1AVA8BopBe8O25u3bODfKW1I8vg0zaqkz4+4ZmQqIo+2J6D92rB
         tp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vs9jSLKCmdkxQSqAksYeNKq9L10k5b5K0Jq3IZwJy9k=;
        b=8DkuACursOpi2S0jFBO5aRpXhlWgnQI2oMaJlcjVSgLu0umrnjGW6AEJ/xZGv5z3y6
         ktKQZbLRk0Iyr8terj7KsJB5ijWo6HzySneFBbG71eg1xyLWRoGNKfBmwXaQEDrq3EyJ
         PPIX69HXbUooTZ8fjufHls4AY1WVQCe381/t0vZyYgaBBYk/BMPILdd2WeOKEuN8bnfk
         tEoO31g8MKLjyyi9aYw7TsOyIkKlM6Erf8/Yd+YY/DdEkoDz7yYhbgncam4HZ4K5DOzm
         MECZNB+9I7bheqmZZPimOX9UnRTV2aSb+fwK4vAZSRv8945CtSCw0hRoMoQDNRMXBsKY
         0e2w==
X-Gm-Message-State: AOAM531ZVxUaakLBAELNQiZqyLKdIhIT3qhsYZVyK6JzgZ5rwlK6bT7Q
        fkQORExFXhL0UhQODSnp0xMJRuoHDmc=
X-Google-Smtp-Source: ABdhPJx9FQWNUjwejcG9clOBfd37aRFDTH209egLnNLI14jJd8F7dHrpR2+6gUynrDd+4vxbPsviiQ==
X-Received: by 2002:ac2:4c4e:: with SMTP id o14mr30222714lfk.148.1636923523497;
        Sun, 14 Nov 2021 12:58:43 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id z8sm916289ljj.86.2021.11.14.12.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 12:58:42 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] can: etas_es58x: fix error handling
Date:   Sun, 14 Nov 2021 23:58:39 +0300
Message-Id: <20211114205839.15316-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When register_candev() fails there are 2 possible device states:
NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
for calling unregister_candev(), because of following checks in
unregister_netdevice_many():

	if (dev->reg_state == NETREG_UNINITIALIZED)
		WARN_ON(1);
...
	BUG_ON(dev->reg_state != NETREG_REGISTERED);

To avoid possible BUG_ON or WARN_ON let's free current netdev before
returning from es58x_init_netdev() and leave others (registered)
net devices for es58x_free_netdevs().

Fixes: 004653f0abf2 ("can: etas_es58x: add es58x_free_netdevs() to factorize code")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a..41c721f2fbbe 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2098,8 +2098,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		free_candev(netdev);
+		es58x_dev->netdev[channel_idx] = NULL;
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
-- 
2.33.1

