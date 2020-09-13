Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78F0267F49
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgIMLDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgIMLDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:03:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018D7C061573;
        Sun, 13 Sep 2020 04:03:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so10238828pfn.8;
        Sun, 13 Sep 2020 04:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D5zxQJ9/bBNYxcKz8x5u3JOFZbRfXW/8iPbkH3tADRk=;
        b=WwzVDfwfq5k/cz21r4yOwQr0MPeyuymAI3rmT9bpZzWw94dlc5EpMg0KXVqTyTxVLS
         Zp1gNxVXWyE3tddvm1ErkTdno02A0+1vvoCCLt7y6bgd0sxJXXTp+WINElVkf2YdtRBM
         CMqJC/EeXszT7ySApINm94SZlyTTM0hFM9EIkJpQnUEPDxWzIuZhoxT/PRtqTOTRZdGu
         2NkWKAe1HGg/oSFOuA3MvUyrJGZEIu4hKWgs4NrJ5VbLxy0m6in5iVF5tQnT1wKL+mwR
         41/2M5a7llz7NvvEjXswhWW6nEDsUeRNnoekqukdL1jmI8KClj3jGvvclOHaz6n/0XSX
         DyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D5zxQJ9/bBNYxcKz8x5u3JOFZbRfXW/8iPbkH3tADRk=;
        b=gHmlRLKzIjWBPODvHLVI11HeddU19qMv69JnrCRpI+yQa+8Tm7V8+5bWM757dJLhbr
         QcyXxQfKMDn7l5icpSLTpQ8t+/WgP9AuG1V4DqCPaeAU3F6wwI9fHJaH+X/rNsZcmJxO
         uV1GfNPMpo+fQ6C9wkLvPVfa0vJnpD+p+S/6KwhfMD/pAZbc7f5O5O6T+7lL4M1q7C/n
         idI54TqBKKLY/PngT/Bskj9SBy2JruRzykZbcdTlZzYKhYvyEhDAM7FBTbSfzRCzX7QX
         WN7uHU8KQyuHGdo3cFX6qr1sWBv96fiMikB3bUsCe+CM0P4yYt1MMzH2iXSrnRBnhlT6
         X+8A==
X-Gm-Message-State: AOAM5317Pqtce/x0RFaD3enlhizUvfy6JLCKwgcL8v84qTW5kzRZUBAs
        QlthwuVVg2fxO1SPQxoEwwY=
X-Google-Smtp-Source: ABdhPJzgyMnyi1zmfqskqELOP69Zjnz6hMotwDpxSOh/rRa4Mw/GuOyrcKpz38L52Hfnhptq4wvIfg==
X-Received: by 2002:a63:2063:: with SMTP id r35mr7627594pgm.320.1599995017178;
        Sun, 13 Sep 2020 04:03:37 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.61])
        by smtp.gmail.com with ESMTPSA id i17sm7319199pfa.29.2020.09.13.04.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 04:03:36 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: fix uninit value error in __sys_sendmmsg
Date:   Sun, 13 Sep 2020 16:33:13 +0530
Message-Id: <20200913110313.4239-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crash report indicated that there was a local variable;
----iovstack.i@__sys_sendmmsg created at:
 ___sys_sendmsg net/socket.c:2388 [inline]
 __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480

 that was left uninitialized.

Initializing this stack to 0s prevents this bug from happening.
Since the memory pointed to by *iov is freed at the end of the function
call, memory leaks are not likely to be an issue.

syzbot seems to have triggered this error by passing an array of 0's as
a parameter while making the system call.

Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes from v1:
	* Fixed the build warning that v1 had introduced
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index 0c0144604f81..1e6f9b54982c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2398,6 +2398,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
 	ssize_t err;
 
+	memset(iov, 0, UIO_FASTIOV);
 	msg_sys->msg_name = &address;
 
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
-- 
2.25.1

