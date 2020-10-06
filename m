Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B93D2845DC
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgJFGM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A276FC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so7379345pgo.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A7J+7LCMnngWYfExdQcrScC+YWq3P/NsolST99HIK/M=;
        b=m2DZsMyadUBNsPBDJrwZe0cFIrZACVrKSfXIOmz2msgb47fIswXmLfh1OFeiutAtzM
         y01YzCDMdZSYvecVqqHJdhRyLtDOAn+r9/kA+tMa9m5rP1MMk+MT9brT8oNvcwqPAkcC
         we14/GMlv+uKEkieQgPXUxTphDTY3nfLum2hIXlvrg1VF5lrZ+2Wry4X29m92b3AK+dW
         zfvtgrd2GgXru/fTdevxI9mesIepAMtwCqhJpjmMFBkchj17eRJfseJv5kkqLq5yfvdd
         DmN8+sctVsjgRFj2p6DcxuOTtKIkZvB0eROwYcHm3hmjAVxHKEm6nMh8gsgdds5jE7Ew
         2bEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A7J+7LCMnngWYfExdQcrScC+YWq3P/NsolST99HIK/M=;
        b=fws7d8S4fQ5UUB7egU63iGsL5F1EFcaw4/tL6Rdoe0tL+Pls8ytfgxIPgwOhnRoa88
         10WhmqGq5wdkDAthUhpZWkbF9zYZ5soFQiqy6m4BAS5G/VLtaSnVHsxQNYg7O+tHGDVh
         3yPH3ZAcjaFptDr2qKEze+cFdNpCXjmCcYFKSquwOHTHg1DrMis7qGc5BsyRTC6vxnJ5
         HHXzYAsTdDz+BgwPxxK1RvmWL9tD6DQ8yyRZ8oXH26GhYi99fZdLMQxXGsx+cgkxRKKP
         bBpd3u1K7S1thR+1FH6fNSC0F5P3bowpFGp3jzvouEfn/z2ujA/AX15IoD2WLYM11G2u
         iJvA==
X-Gm-Message-State: AOAM533OAg+/LQiCqMTZc+KQfhwFlMNlcplv3NHCmT4iEsTRcJj+9F72
        U5NLCuVaol1+UKTUjT4P+wk=
X-Google-Smtp-Source: ABdhPJyKvtv8lbNKWYSS7vgVs64tEdTZGkobL44Db7eJM+4pL8DuIh6Axh41kbpRRnEoOJu6auppQA==
X-Received: by 2002:a62:1e81:0:b029:142:2dad:a68 with SMTP id e123-20020a621e810000b02901422dad0a68mr3264658pfe.5.1601964777162;
        Mon, 05 Oct 2020 23:12:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:56 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 10/10] net: rtl8150: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:59 +0530
Message-Id: <20201006061159.292340-11-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c8..d8f3b44ef 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -589,9 +589,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -890,7 +890,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.25.1

