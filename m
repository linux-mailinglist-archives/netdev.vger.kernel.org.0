Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012EE3EB9AE
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbhHMQBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbhHMQBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:01:43 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E200C061756;
        Fri, 13 Aug 2021 09:01:16 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t9so20717784lfc.6;
        Fri, 13 Aug 2021 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kSDrdDBPEfymGaxqgpjg+gjYzyh9YbFBDk0EflsFaxk=;
        b=szxgNzGL4CLPZmsplFwjXdvcTewQCWKnSbJuBqXT0kH5iofyoYqtohDvr7aG4d9PkV
         quqdZt/4Fl3S0bovkolR0qtaBXLVREe9MmYPCy46q1uC1EGwX9Io+Ed7AUAYot1qmmMB
         n8koog7GrmwudNfXKeU2ee//LGF5qDTXtbXqSW5zuTjS8EKOl7Jv8oKhbpdn+k7L4DTU
         XkLEtQji79VJ5UNo/scDMIn6aAJMWZCJAYGro+vabiYaVKQiSA9PdjymAt8D+gMmiWrC
         qt3g/dYQGVMnBqypsj+oCSrtigcAi0fWVFwKxSPvkkWunN9kEXsCY16uJ8KzNJxpKFQH
         OFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kSDrdDBPEfymGaxqgpjg+gjYzyh9YbFBDk0EflsFaxk=;
        b=cCxud1pbmHxT4l2qKEKdcP7G4UQpX4/HpqA6KUdzgUGSUWm3CjA4l5nG756MWNNiM7
         CD4dFaq6dfbKlNmSbZauY4p3Yylr6H/FlNRnxdxao7vQXbtUOD6eyfjXyKYyDI/5PJFx
         m4X52pNpj6ivVPE0HJvNFNLXJWk++E5Lw5HiB3L14ZMEt5inybcJh8XUaR90YJo6np6f
         q7zDn8JQKNn7ogGow9w7EiB7C8/Wnh04RvdTdzhOlUT7RUqMB9N551OdjqyBmkTNb6T+
         KeMbRjS3S0SHbxhoTELnlL+2sodBL7L4r35n0t0GbfTl5FXBaw9C3vRc117e1iDXzoQY
         ulLw==
X-Gm-Message-State: AOAM533xwATu+4jtMB0FJuk/P4fe8QD6N7DtdTZiYgwg6ccgDdpl2QHZ
        HV0YZuB0kjWyydkRJcF3vKI=
X-Google-Smtp-Source: ABdhPJx6sAK4DfFqt63A5qYw0JPrdLLcHOqs50aLX0msPRmFYku9fblCnCzQ3ZTIv0U//xRl2L/74Q==
X-Received: by 2002:a19:7510:: with SMTP id y16mr2122006lfe.191.1628870473605;
        Fri, 13 Aug 2021 09:01:13 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id c2sm207158lji.57.2021.08.13.09.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:01:13 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        himadrispandya@gmail.com, andrew@lunn.ch
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: [PATCH] net: asix: fix uninit value in asix_mdio_read
Date:   Fri, 13 Aug 2021 19:01:08 +0300
Message-Id: <20210813160108.17534-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported uninit-value in asix_mdio_read(). The problem was in
missing error handling. asix_read_cmd() should initialize passed stack
variable smsr, but it can fail in some cases. Then while condidition
checks possibly uninit smsr variable.

Since smsr is uninitialized stack variable, driver can misbehave,
because smsr will be random in case of asix_read_cmd() failure.
Fix it by adding error cheking and just continue the loop instead of
checking uninit value.

Fixes: 8a46f665833a ("net: asix: Avoid looping when the device is disconnected")
Reported-and-tested-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/asix_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index ac92bc52a85e..572ca3077f8f 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -479,7 +479,13 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV) {
+			break;
+		} else if (ret < 0) {
+			++i;
+			continue;
+		}
+	} while (!(smsr & AX_HOST_EN) && (i++ < 30));
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
-- 
2.32.0

