Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C6E30174E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 18:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbhAWRfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 12:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWRdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 12:33:22 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C4C0613D6;
        Sat, 23 Jan 2021 09:32:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ke15so12120593ejc.12;
        Sat, 23 Jan 2021 09:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AP3OwkTp0YWxBuX7mQrwCmymgPjHNWJQuUPHDC7WEYQ=;
        b=AFHS7fvP5NonOYoSLJhPWjQ+KFbjUZM5Sk8hHImL+fI/2R7FcPSjxnXL+TSMdQtJnR
         8rRlrGwadbHw4aroITLMmDYbc3zags/wtVwWTH309/k13pgpf4/pm8vPf10CeFspUz1p
         ZMDYx+I8/B1mas0cqQTOJ2Lu+QVPNW0M/GJK3xBzOOHYNeO8gNTTJ9s3dNdt8VvsTFdr
         N3usPVVBpQfoAHTJc/O1qVYKgvjVcsFFhPsM6ravI0ASUw6p37r1X2QXWwyaS1c/PhsS
         90Sg9U2lf3+D9u09naTtgsFmqLpZYmgvU7RvYjBLLg+6WYZrpKYAPASe3RdHk5HXhoft
         tfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=AP3OwkTp0YWxBuX7mQrwCmymgPjHNWJQuUPHDC7WEYQ=;
        b=UGKoNb2rpQT6MO7MY+kGFtMhembbrGUqDviKQK+CZh66yWnLb7sLuVV8w/Xx2ZN/va
         XJj3SJXcJ/XuOw5Z/SzAzS2MH/gh9PnRNWLWsoCspucTe+KFqPysDgSn++BdkZ+inVvo
         K/rWq/Pn9ScOtY6UmK/9D+/uRD9FK+AXAF+ELvsdQBoTtkJFBss4ib1AZyWBA59qmC40
         BAxnIEyCTb2Pcc7htoD21RQLBDWuEY3MVvvF0ZTAuWXfGwKgyPLVAmXH6xKsrL16SLeG
         qt9qXjEOFvB6SrcmYZaX3SWnlue6oo0xO+WMP6f9ttIp/v1YS0GtkomIUghI3G4Ow+En
         Q0hw==
X-Gm-Message-State: AOAM532adAxNQQZT3ELczTx9mUCVUwF6raSMRQMR8qvgtFb/851NmMWz
        f6tNq/7HXdo2GFzcz+6x3lpy3Hu+DEyiOg==
X-Google-Smtp-Source: ABdhPJyUhw8YuL4ZTKWKQr73JXMdAgj1zztDlewiH3u8a/UeKSNW63n00CXBDAoEbVMfxTMO0wVDKw==
X-Received: by 2002:a17:906:cb82:: with SMTP id mf2mr5620098ejb.515.1611423160660;
        Sat, 23 Jan 2021 09:32:40 -0800 (PST)
Received: from stitch.. ([2a01:4262:1ab:c:de4:866f:76c3:151d])
        by smtp.gmail.com with ESMTPSA id e19sm7528116eds.79.2021.01.23.09.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 09:32:40 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <esmil@mailme.dk>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: usbnet: initialize tasklet using tasklet_init
Date:   Sat, 23 Jan 2021 18:32:20 +0100
Message-Id: <20210123173221.5855-2-esmil@mailme.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123173221.5855-1-esmil@mailme.dk>
References: <20210123173221.5855-1-esmil@mailme.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

Initialize tasklet using tasklet_init() rather than open-coding it.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/usb/usbnet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1447da1d5729..26455c76588f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1673,8 +1673,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	dev->bh.func = usbnet_bh_tasklet;
-	dev->bh.data = (unsigned long)&dev->delay;
+	tasklet_init(&dev->bh, usbnet_bh_tasklet, (unsigned long)&dev->delay);
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
-- 
2.30.0

