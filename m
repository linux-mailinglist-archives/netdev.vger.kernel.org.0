Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAF279C7E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIZU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIZU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 16:56:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7434BC0613CE;
        Sat, 26 Sep 2020 13:56:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m15so1224797pls.8;
        Sat, 26 Sep 2020 13:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/6oAVp4TO+xMGiQqzzGIk3iSntp+7SFWtJVxbuliV8=;
        b=cE8UmjwGB7w9uS6HqnZDzVS2yzA3ib2Zx7vPmS/JELxQ80sPeUdmLaUlW19814fsiA
         jDi+avjDsOWcYLfm5Pr6fMRgFYmmwIXL9G0uahOx3RFwccUfsIthANW0L57ZGgMdiXo4
         P9yH6/jm5cB7jvrpeMaiqymueA7AaJe8/G3NhMVIhTHo9txGajSZaFX0DkmGjH6Z2YNA
         geAtxJwGUbS5C42rWwg95axt7itGqMmoBkdHBmZewD24KLuhkTV+IhUwr9jqId01wpPc
         0zk8hYCscTEsw/Rubge68BvXV6xcv81unuvhxudFYk6qaZBimK2I6IWMzIMZNUoyanFv
         k+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/6oAVp4TO+xMGiQqzzGIk3iSntp+7SFWtJVxbuliV8=;
        b=T7jaym+sW8EnKpLdjvPJCB+kZMb6UXSbC4l3lwkuoFiViou1L5DylwwpfHIAwqELsi
         kzL139KPEAzHylQnHpxBtY2upKTWJyJx9/QJFq0aNMtCpt09thE2rVMhPACHRKfYQ9vk
         V/cK3KzXDsTu9QY3xlo7epwIwAXJ0Jw8D/ySFw5UaFt7FMNRW2qa8VVNlWsE/slnQ39+
         r9Yd2zytE19hDIbvTAkACzsskYqyT2xmF5oam06ge7jNlYFWPzBpcbVVECeFUb2qqvbr
         iOkglc042jLENNmFqtQsRMavRqCaMTNd44CXJ75FIN1LWU+7bc4nKPiaCW9lkuz3pns6
         2HpA==
X-Gm-Message-State: AOAM532j5m1I5s8p6hnkcLfhdZXuwYbWg18Xzh4gb3Xwg9bVyuN++Snt
        NJE3AlToT/4Kyhygvb3Q4JLgbHRqVuc=
X-Google-Smtp-Source: ABdhPJyFjh+piDL1JEPuZI20DX+uTqkRi26FY2O695A2DXyFgWFZowJ6OWWLa91IFE2m7KwAfaeJaw==
X-Received: by 2002:a17:90a:1f43:: with SMTP id y3mr3149102pjy.28.1601153773974;
        Sat, 26 Sep 2020 13:56:13 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:199b:cbb5:5d7c:eb8d])
        by smtp.gmail.com with ESMTPSA id g206sm6397530pfb.178.2020.09.26.13.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 13:56:13 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] drivers/net/wan/x25_asy: Keep the ldisc running even when netif is down
Date:   Sat, 26 Sep 2020 13:56:10 -0700
Message-Id: <20200926205610.21045-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe it is necessary to keep the N_X25 line discipline running even
when the upper network interface is down, because otherwise, the last
frame transmitted before the interface going down may be incompletely
transmitted, and the first frame received after the interface going up
may be incompletely received.

By allowing the line discipline to continue doing R/W on the TTY, we can
ensure that the last frame before the interface goes down is completely
transmitted, and the first frame after the interface goes up is completely
received.

To achieve this, I did these changes:

1. Postpone the netif_running check in x25_asy_write_wakeup until the
transmission of data is complete.

2. Postpone the netif_running check in x25_asy_receive_buf until a
complete frame is received (in x25_asy_bump).

3. Move x25_asy_close from x25_asy_close_dev to x25_asy_close_tty,
so that when closing the interface, TTY transmission will not stop and
the line discipline's read buffer and write buffer will not be cleared.
(Do these only when the line discipline is closing.)

(Also add FIXME comments because the netif_running checks may race with
the closing of the netif. Currently there's no locking to prevent this.
This needs to be fixed.)

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/x25_asy.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index c418767a890a..22fcc0dd4b57 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -192,6 +192,10 @@ static void x25_asy_bump(struct x25_asy *sl)
 	int count;
 	int err;
 
+	/* FIXME: The netif may go down after netif_running returns true */
+	if (!netif_running(dev))
+		return;
+
 	count = sl->rcount;
 	dev->stats.rx_bytes += count;
 
@@ -257,7 +261,7 @@ static void x25_asy_write_wakeup(struct tty_struct *tty)
 	struct x25_asy *sl = tty->disc_data;
 
 	/* First make sure we're connected. */
-	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
+	if (!sl || sl->magic != X25_ASY_MAGIC)
 		return;
 
 	if (sl->xleft <= 0) {
@@ -265,7 +269,9 @@ static void x25_asy_write_wakeup(struct tty_struct *tty)
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
 		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		x25_asy_unlock(sl);
+		/* FIXME: The netif may go down after netif_running returns */
+		if (netif_running(sl->dev))
+			x25_asy_unlock(sl);
 		return;
 	}
 
@@ -529,7 +535,7 @@ static void x25_asy_receive_buf(struct tty_struct *tty,
 {
 	struct x25_asy *sl = tty->disc_data;
 
-	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
+	if (!sl || sl->magic != X25_ASY_MAGIC)
 		return;
 
 
@@ -605,6 +611,7 @@ static void x25_asy_close_tty(struct tty_struct *tty)
 		dev_close(sl->dev);
 	rtnl_unlock();
 
+	x25_asy_close(sl->dev);
 	tty->disc_data = NULL;
 	sl->tty = NULL;
 	x25_asy_free(sl);
@@ -732,8 +739,6 @@ static int x25_asy_close_dev(struct net_device *dev)
 		pr_err("%s: lapb_unregister error: %d\n",
 		       __func__, err);
 
-	x25_asy_close(dev);
-
 	return 0;
 }
 
-- 
2.25.1

