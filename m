Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DE10381
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 02:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfEAAfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 20:35:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34229 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfEAAfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 20:35:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so6658922pgt.1;
        Tue, 30 Apr 2019 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=mK/2U6XmBVYKbHJt9nnr0L4DUMvX1gXQL2Vn7WRJlgA=;
        b=iEo+mr5hprLIwEr3/XiiyT4TNLjSDt63rR3STFMz07BLTLAeeQtx1+S/fJoMHYQOZc
         V/yOQ5aBt6YFBvx++4X9V52dbUcVwa5jDJc8CVJPuoOjfqmVg6201CNgn5xkQ5krJFnY
         +XXlUDlF/8zJ+XjS+vmLe4lriYZHY25QUsYFncuvP5okUiyVqAQVn3fPSbjb9fxd4cUv
         WjNZIrp8HGkqnLs9G9u/Yq4OXNjTBxlqy5PMe27DblqO1pbDusqLhIcmlILh1VvST0qk
         xjH0rJgcfeq9Nndp99ENmhWkGXNZAt1qo2D6SbCcoTYT2lDPvfrUIKQ0H3F0+5NWfnMp
         tY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=mK/2U6XmBVYKbHJt9nnr0L4DUMvX1gXQL2Vn7WRJlgA=;
        b=aQzPW0FVpkqbir7DwaThLZNllPUCWsB8C0xfFAHFPjkPPRM0Q279YoJnkoJSu4f5p8
         yx6f0F12IGczaDqwWuCCzjyAhQneCAJNMLWBUoHgn+d6BRYLi/Bf8tOjLvXQGdZcFCjg
         hdpjUVXLhNQQVac6bgz1luNYiBT6vgYtIBngc4aOqZ4FSM+RdZE89ADgaAjOrwfKnDFc
         5Hke84F2s3WR4mOOXKiiHrZ9JywoEfwFc8gvRx9Ce9N8y8qG9hfpKuyqDMg3sCgwyKLy
         9TX2yRCzdU1/J3k5TXzAVRhF+8iD0MEbc6ddVaZEShk60I4TBCxnDCnwmqqPX8lOCohz
         I2Uw==
X-Gm-Message-State: APjAAAUEUVFjl8ftx44zT9S+4KST+9o9uNjY42QQSsAkpYatS/2P76lZ
        kqKnbUHzG8kGeFSe1BOwpg0=
X-Google-Smtp-Source: APXvYqzmJPnGG+y1SzR33zIr2s9h3Ie9i2EMkkXVusVd/gyORnc7eLYtFqMSZZUlDdA7wJF/qs3YSg==
X-Received: by 2002:a65:638f:: with SMTP id h15mr70709646pgv.147.1556670936930;
        Tue, 30 Apr 2019 17:35:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h20sm99001780pfj.40.2019.04.30.17.35.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 17:35:36 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Gustavo A . R . Silva" <garsilva@embeddedor.com>
Subject: [PATCH] usbnet: ipheth: Remove unnecessary NULL pointer check
Date:   Tue, 30 Apr 2019 17:35:33 -0700
Message-Id: <1556670933-755-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipheth_carrier_set() is called from two locations. In
ipheth_carrier_check_work(), its parameter 'dev' is set with
container_of(work, ...) and can not be NULL. In ipheth_open(),
dev is extracted from netdev_priv(net) and dereferenced before
the call to ipheth_carrier_set(). The NULL pointer check of dev
in ipheth_carrier_set() is therefore unnecessary and can be removed.

Cc: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/usb/ipheth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index a01a71a7e48d..c247aed2dceb 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -241,8 +241,6 @@ static int ipheth_carrier_set(struct ipheth_device *dev)
 	struct usb_device *udev;
 	int retval;
 
-	if (!dev)
-		return 0;
 	if (!dev->confirmed_pairing)
 		return 0;
 
-- 
2.7.4

