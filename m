Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E1617545F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCBHUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43607 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCBHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:25 -0500
Received: by mail-pf1-f196.google.com with SMTP id s1so5118827pfh.10
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JHnwykakNqqbe4h/gLWcSQNt3qGCNGjmh9l/sS6gzQo=;
        b=Pvx+xT8Jxjdykc8NK4bU1s8s9ngdKzPFg++JymmjcKiIk82INfBViL2r383PqCRiiK
         aE5vXKCBkT6llhm2ed+pyCFxvnvflt1hPu60sRw7YD3knx7m91vbmVRPHJk+QwYUoVsz
         WKnqllVV24e7spTA8uhC2dO88GPPnK+CajjGrxe5DMAw3WMIFqMed+zbCR90EdB44lKS
         MElHUnFeDi+LA36t9NGdbWF258ZDoy7tVxUab9Ud65EeTiiptZ8w1DyhToMPmp3KmJrk
         VLhgcw8bpmLc1uXnXEXw2nIEspczqxJLc8iD6rYk/B5gGD46BOFaiK8vfSLDxoMqj2EN
         W9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JHnwykakNqqbe4h/gLWcSQNt3qGCNGjmh9l/sS6gzQo=;
        b=DmGxW6lQOgzkMvQmt4dpeNpK9HisR/Y3hUH+/38RpFhe6jyo0ol6TTHyCgYLC+yEEK
         IovvFXMWB2DqIdSUfDv7BSDbuJtCXuxH8NYxbMKHGsf5eU8T+ezbkeWuZb8RMyF2Weo3
         BFxo4D17fxQnZcjOjMwsuU+YbIKOYv9wmXjAHkGGN5IJ5Ee0KYdkjOKhTAFPn8O94gS2
         +RUU07JwCxzIZwM1bFGFHneq8t2HHoHtRPJBEkRx5wxsruYcXm6ckyZEgWYJE2jptSGq
         7AA59huxsKpWPrdlkFrlov3J2QpaS+xkRlKPBBWhFJYeEOI5+wMYqgfnC/eNTEf8OFQd
         cMxQ==
X-Gm-Message-State: APjAAAVIWU/ZtxHDxPAaY+JHh/0nJNGXLtuky0tDYNB37n9xxiyx3Th/
        PxpqONY6VZocyZdszdQ+luJvEi8oCfw=
X-Google-Smtp-Source: APXvYqxLNGvI4X8p2xqixZ0zO000C1p/tAxR2Rmxo1DFEN13agrrLqp/alglQ7gS86RxuoJZkXX6tA==
X-Received: by 2002:a62:ac08:: with SMTP id v8mr17120608pfe.83.1583133624249;
        Sun, 01 Mar 2020 23:20:24 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:23 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 7/7] octeontx2-af: Modify rvu_reg_poll() to check reg atleast twice
Date:   Mon,  2 Mar 2020 12:49:28 +0530
Message-Id: <1583133568-5674-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Currently on the first check if the operation is still not
finished, the poll goes to sleep for 2-5 usecs. But if for
some reason (due to other priority stuff like interrupts etc) by
the time the poll wakes up the 10ms time is expired then we don't
check if operation is finished or not and return failure.

This patch modifies poll logic to check HW operation after sleep so
that the status is checked atleast twice.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3b794df..5ff25bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -88,13 +88,15 @@ int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 	u64 reg_val;
 
 	reg = rvu->afreg_base + ((block << 28) | offset);
-	while (time_before(jiffies, timeout)) {
-		reg_val = readq(reg);
-		if (zero && !(reg_val & mask))
-			return 0;
-		if (!zero && (reg_val & mask))
-			return 0;
+again:
+	reg_val = readq(reg);
+	if (zero && !(reg_val & mask))
+		return 0;
+	if (!zero && (reg_val & mask))
+		return 0;
+	if (time_before(jiffies, timeout)) {
 		usleep_range(1, 5);
+		goto again;
 	}
 	return -EBUSY;
 }
-- 
2.7.4

