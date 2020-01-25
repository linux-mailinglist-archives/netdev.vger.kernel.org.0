Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A58149375
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAYFL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:58 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35038 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgAYFL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 00:11:57 -0500
Received: by mail-yb1-f195.google.com with SMTP id q190so2112078ybq.2;
        Fri, 24 Jan 2020 21:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I4SiUS67rHafeLAY0jP3WSeq1NEslNf2PNyQbRkh05o=;
        b=fjmCYgvnjJtvkyvZSIXvmvd8FjjciVXIVQj6RpU7x+gFvLFPUsz3w1tZ6usfoUxUVx
         1Jxqkj0ZSJJR+XUMdd79/HMPksKgcZXOhxch7jKKSiY1NsHycYC+JFHcKUYYQlMifyNJ
         ajONuHjC0vvamQ96wTve/QbjLkDVv4YLxju4b6S9OUGVu37b3rM8iHHsbMTc0hNWwNO9
         B9M6F86iIfdN3NJz0sTSVdGvDup154qMlUQFJusKTRUtulMjoMMS2HV93RXPS5oB/X5U
         cb89jAf7qxvzUr8/T/NgxPPujTr7oFcNr2v3Bjp+iLfI7cbl5/Rmbtj1qUNNiMtU2gag
         7EkA==
X-Gm-Message-State: APjAAAXd90P278R82ROR3Q3cC0QVIrtcdFJ5PD1DvGmV/FTVUlRaJ2RG
        lQWl0YSr4x0EgA1GjG9Ejbs=
X-Google-Smtp-Source: APXvYqybc2g/TFZ+nbpVJPDSQwk3QsFQ+kRmIvJroZ6owMX8YRRcFuGxI+0y4qEwkm0EBdNxZfzcJA==
X-Received: by 2002:a25:cf49:: with SMTP id f70mr5555367ybg.11.1579929116743;
        Fri, 24 Jan 2020 21:11:56 -0800 (PST)
Received: from localhost.localdomain (h198-137-20-41.xnet.uga.edu. [198.137.20.41])
        by smtp.gmail.com with ESMTPSA id z12sm3276887ywl.27.2020.01.24.21.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 21:11:56 -0800 (PST)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net (moderated list:ATM),
        netdev@vger.kernel.org (open list:ATM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] firestream: fix memory leaks
Date:   Sat, 25 Jan 2020 05:11:34 +0000
Message-Id: <20200125051134.11557-1-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fs_open(), 'vcc' is allocated through kmalloc() and assigned to
'atm_vcc->dev_data.' In the following execution, if there is no more free
channel, the error code EBUSY will be returned. However, 'vcc' is not
deallocated, leading to memory leaks. Note that, in normal cases where
fs_open() returns 0, 'vcc' will be deallocated in fs_close(). But, if
fs_open() fails, there is no guarantee that fs_close() will be invoked.

To fix this issue, deallocate 'vcc' before EBUSY is returned.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/atm/firestream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index aad00d2b28f5..093712e34de7 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -912,6 +912,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 			}
 			if (!to) {
 				printk ("No more free channels for FS50..\n");
+				kfree(vcc);
 				return -EBUSY;
 			}
 			vcc->channo = dev->channo;
@@ -922,6 +923,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 			if (((DO_DIRECTION(rxtp) && dev->atm_vccs[vcc->channo])) ||
 			    ( DO_DIRECTION(txtp) && test_bit (vcc->channo, dev->tx_inuse))) {
 				printk ("Channel is in use for FS155.\n");
+				kfree(vcc);
 				return -EBUSY;
 			}
 		}
-- 
2.17.1

