Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD41F694C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKJOH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:29 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35312 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:29 -0500
Received: by mail-pg1-f195.google.com with SMTP id q22so7461706pgk.2;
        Sun, 10 Nov 2019 06:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eU8YcK7QmEzgV0st1+64+ecJ2UFrzFdTVmX7+bTQHP0=;
        b=iCV/dOMt1Gxk9wD35Bds5vRMgfgQvWjuluHI8tie+4FFYwR0998MKuplvLQFnBJp/B
         A8nzAtnI+sxOgpdl9SzBuXyOO34cvuveEM+KwgNqV3ESwmN+ni/03WGaH1dNgdXipUEL
         xqWsXtQev+WX9Nwdfmt+oritax4VtSLT8dzmEkCKdFhgCiWbtHStR9aqBjxqEtJQcHDz
         JSlKI3itKlTQXrQh24BjQrbYDZeaxrvDIEifZPLazbM5baQ93GI0FYgxIN2N+iGExYL2
         AcZp3GycHovPo6RxWCYkRxL7uxwEv8+PVrEqekLpf1AybBrOvdNMVjR8d0++mGIrS5ri
         ObhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eU8YcK7QmEzgV0st1+64+ecJ2UFrzFdTVmX7+bTQHP0=;
        b=SoH6ArLEcOCPQYJNEPcOT8pQEYaQwATOjubG0W92eUHPRUrSBgRZL9lU0vuWglKwqe
         /7/xLvMpOO/5oBw7HqDKLUhXj75QM3EG7eS3hOlBZwtxUnJcivbq3jLyQwrJ9DpUq+Ir
         a5lcvqaIRR3wlDLmya+QMNx+KDJbd0eilZx1JIHci76Hf7OIMonziEkBKqfRP/5u9ojG
         h1mFwlX7tdC0sbqjP3vHYKN+SZhedzUSlV3kWNQYG9FCm6iDw+aq35rQP+pDoDcaenFQ
         hBI3hvno406EE1xYE0aHdLjOw0GyhFmnATU+3UOVpQWDsXRsgUkNUmsrDafRp1GaZfIe
         aELA==
X-Gm-Message-State: APjAAAXP/LlURMUtlX24ujSKlZdoJ8NcTfW25UFXc89tSsNSbg1CCF9D
        0xDllvVA8sFYTbkC11kJfRk=
X-Google-Smtp-Source: APXvYqwemy1rr3PRyYeBoTH00pTVQ3zewYcQ0DbOrpCd/MlP5CKPo5HW2QO+pfqB/dc5HnjOuqoU3Q==
X-Received: by 2002:a63:e801:: with SMTP id s1mr16008814pgh.213.1573394848386;
        Sun, 10 Nov 2019 06:07:28 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:3f8f:27cb:abb4:d0bd:49cb])
        by smtp.gmail.com with ESMTPSA id c12sm12520388pfp.178.2019.11.10.06.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 06:07:27 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net
Cc:     glider@google.com, gregkh@linuxfoundation.org,
        hslester96@gmail.com, kstewart@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tranmanphong@gmail.com
Subject: [[Patch V2]] usb: asix: cleanup the buffer in asix_read_cmd
Date:   Sun, 10 Nov 2019 21:07:16 +0700
Message-Id: <20191110140716.11996-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107.152118.922830217121663373.davem@davemloft.net>
References: <20191107.152118.922830217121663373.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for fixing KMSAN: uninit-value in asix_mdio_write
comes from syzbot.

Reported-by: syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com

Tested by:

https://groups.google.com/d/msg/syzkaller-bugs/3H_n05x_sPU/07UIX_TUEgAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/asix_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e39f41efda3e..f3eeb7875a4d 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -22,6 +22,8 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	else
 		fn = usbnet_read_cmd_nopm;
 
+	memset(data, 0, size);
+
 	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 value, index, data, size);
 
-- 
2.20.1

