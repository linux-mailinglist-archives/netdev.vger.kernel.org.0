Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76E0149613
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 15:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAYOeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 09:34:06 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43237 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYOeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 09:34:05 -0500
Received: by mail-yb1-f196.google.com with SMTP id k15so2522427ybd.10;
        Sat, 25 Jan 2020 06:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CII6fgxbbjlcfCpxODLXxfNy5r0J8+wQSLmq3GYEul8=;
        b=bCU7L5sVpBqdGp101C3t9B7mPY5AA86EIWEbjwzOBx7DLxkZH7t1SK7kR8d7E1d7Zk
         76q7Sj/QVgHWs/y+psith8oD9iPNbbz6ErD8HjLmlPiVwUL4+2IXnf2qByLuw40R6sjF
         KwX6Q09tMbE97pTFrc6CJ7AnyCWeRHxmVac56L4PC/dr5My5gJHevMkF2KvrxA4dlafo
         Z50Wf2Yj0MKJlns9kBdROmBehotF9B7umAjGCFZtLmr7JZa7+7N6xpI4edzveC1rp0EL
         R+1AIqOzbrqnsHqDzOdtBhuEZFVdzGpLlTwlMMTU/BOEHj9yp5ComC7W541do6cGB2jx
         XuGw==
X-Gm-Message-State: APjAAAUROxTT72gzEUuvPvfNKCccetpfnyk6fz/KlVx1+bpf8p2x3iPo
        G0gfgjJqdAcMzTiOQokHd+E=
X-Google-Smtp-Source: APXvYqyz8SWMF/sNYdsq9JDkVs9ZnyCPh+bhesv9tVDOFL94tGNrbROb3Dmgkdh4KJ03cU8P1sNnbA==
X-Received: by 2002:a25:6184:: with SMTP id v126mr6092142ybb.427.1579962844821;
        Sat, 25 Jan 2020 06:34:04 -0800 (PST)
Received: from localhost.localdomain (h198-137-20-41.xnet.uga.edu. [198.137.20.41])
        by smtp.gmail.com with ESMTPSA id w132sm3723295ywc.51.2020.01.25.06.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 06:34:03 -0800 (PST)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net (moderated list:ATM),
        netdev@vger.kernel.org (open list:ATM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] firestream: fix memory leaks
Date:   Sat, 25 Jan 2020 14:33:29 +0000
Message-Id: <20200125143329.11766-1-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fs_open(), 'vcc' is allocated through kmalloc() and assigned to
'atm_vcc->dev_data.' In the following execution, if an error occurs, e.g.,
there is no more free channel, an error code EBUSY or ENOMEM will be
returned. However, 'vcc' is not deallocated, leading to memory leaks. Note
that, in normal cases where fs_open() returns 0, 'vcc' will be deallocated
in fs_close(). But, if fs_open() fails, there is no guarantee that
fs_close() will be invoked.

To fix this issue, deallocate 'vcc' before the error code is returned.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/atm/firestream.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index aad00d2b28f5..cc87004d5e2d 100644
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
@@ -935,6 +937,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 			    tc, sizeof (struct fs_transmit_config));
 		if (!tc) {
 			fs_dprintk (FS_DEBUG_OPEN, "fs: can't alloc transmit_config.\n");
+			kfree(vcc);
 			return -ENOMEM;
 		}
 
-- 
2.17.1

