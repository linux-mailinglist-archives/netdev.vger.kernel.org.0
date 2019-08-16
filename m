Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF758F98A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfHPDuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 23:50:16 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41932 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfHPDuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 23:50:15 -0400
Received: by mail-yb1-f194.google.com with SMTP id n7so1538332ybd.8;
        Thu, 15 Aug 2019 20:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HlyAjF59EodmIyM3qXcajR4GZniJoos5543aYOc+XW0=;
        b=btQj5AZ56dAs1ICKoWFSkZerkAWsY8DDUKdBSxAbKI5xEzlgG+1GSPdJoVh65IT6iT
         CKcjMP3p/BH3MzhEaNDMVCKbpxzGDF1HX8FfEyVs05uu/go8iYXxL4u2HYj5LWffBZHO
         qUdPqktDv7yZJbv00eGKeyzoQMTqAkeFg0ZgBZ1tWBHbYF6Yll7OFtxqSLMUQPDK9nLM
         wzOfGJYv22pYWO7Gkr5vTyrqxK/DTXKvfV5AiLWamJkUcBMEsi2NE0dQ/uBW4AuRU/Ti
         oM9wpiNBOfI1WB+3pI3OWsZgW/XFITMJYFs1b9tFIx57n/DboM48VgpqzoMA0Vz46JM2
         PrZg==
X-Gm-Message-State: APjAAAVfNiy5YGrm2GG74qE+1cHCKyR7tmOugZhZq3T8vTgCwjC48R3O
        75DrskCwrJpuw4KTonQtntM=
X-Google-Smtp-Source: APXvYqyluzVVRkI5Jg88I9nGUmrlyDDt+lwBFEgkQVf9GAjmf+sY7p0K7UTFO6+vsFZjoGH3cChgUg==
X-Received: by 2002:a25:b325:: with SMTP id l37mr5673202ybj.197.1565927414973;
        Thu, 15 Aug 2019 20:50:14 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id s188sm1066662ywd.7.2019.08.15.20.50.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Aug 2019 20:50:13 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] airo: fix memory leaks
Date:   Thu, 15 Aug 2019 22:50:02 -0500
Message-Id: <1565927404-4755-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In proc_BSSList_open(), 'file->private_data' is allocated through kzalloc()
and 'data->rbuffer' is allocated through kmalloc(). In the following
execution, if an error occurs, they are not deallocated, leading to memory
leaks. To fix this issue, free the allocated memory regions before
returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/wireless/cisco/airo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 9342ffb..f43c065 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5441,11 +5441,18 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
 			Cmd cmd;
 			Resp rsp;
 
-			if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
+			if (ai->flags & FLAG_RADIO_MASK) {
+				kfree(data->rbuffer);
+				kfree(file->private_data);
+				return -ENETDOWN;
+			}
 			memset(&cmd, 0, sizeof(cmd));
 			cmd.cmd=CMD_LISTBSS;
-			if (down_interruptible(&ai->sem))
+			if (down_interruptible(&ai->sem)) {
+				kfree(data->rbuffer);
+				kfree(file->private_data);
 				return -ERESTARTSYS;
+			}
 			issuecommand(ai, &cmd, &rsp);
 			up(&ai->sem);
 			data->readlen = 0;
-- 
2.7.4

