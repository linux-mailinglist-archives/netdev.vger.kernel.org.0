Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAA32E3346
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgL1AP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 19:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgL1APZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 19:15:25 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D27EC061794;
        Sun, 27 Dec 2020 16:14:45 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j13so5596494pjz.3;
        Sun, 27 Dec 2020 16:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oZEv+bW9CjN9VY+lYyzIh0+MFHMRTUdBkL+wcZGDg9Y=;
        b=kwRbPeE0fgWdNQ4lqr4Jhs1gVJjwKgWhSv72K82HBsI/KW+TjSmex65EU8rReNhtUh
         OtjwVxh8PKzHED8BiYKbwaSV6vmtok0MGPVsb9OZ6z19ayn9TCdWi85ePfP2TMREy9aE
         OBESMeP3y3MiDTeFNFXE/vWfHM2yIUwHm0UkbLZIJGCMkoDkuKTg8Or31rofkKf3mtxe
         oOGfB+OVOmZampjKcs5TQ09ggOfwS5NntWeZ4BLShMnTsj7hSK5zrZ4AvySoRuWEwq41
         aEPlueCtDl5x/ZWTaVRJ9JG578dsDYXKrfRroJ51YNamg8ijdr1nKD4vyAnaOI1L4mix
         5jUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oZEv+bW9CjN9VY+lYyzIh0+MFHMRTUdBkL+wcZGDg9Y=;
        b=eMadlIzYYtm3KS6/+ZMKTT9+IdHwS5bnqT5CJ57190MKpRFW8vS7NiL1b6wWXeIkLR
         kXr2SjQhhcsdoUJRaU8R8AiEZ2WPjFBlD5uzTq37YDLz9707at29fGLuYCMH04zBFqPW
         7aNH1zIb9ldmIMeFy1D1Rae96e2Ov3+zukyoulywp9ZQ3uzrupZH3Dy+73mSAFIfJrad
         lW4a+zOBdJ/IceJ3lS9lsGrQZ531knNc5xhB2J1iBQNCL0lTg2i6QvjAhOjV6jTqMtfw
         kHTzEunSNFLloizktvRvg4AntqrBYSxCeH6QbdyLfVX45pWQRhP2tUt2ENHNHiU/kLeB
         1IHg==
X-Gm-Message-State: AOAM531TN7gzpPpK1LnRp4GFbBCnNMd0d/4/MILIKrS/1mhX5bM1a6x4
        PUF4B9wcE1EyupD/RnWRrsAW+iyIOVY=
X-Google-Smtp-Source: ABdhPJyhlMx0whdIo9jQVDIbnh+9K2BVgp9oMxEatRqEcUYClluPO3un6EJcAYJyuz5KQ499Xna5tA==
X-Received: by 2002:a17:90a:a012:: with SMTP id q18mr17928439pjp.223.1609114484297;
        Sun, 27 Dec 2020 16:14:44 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:936f:d5a6:f7f3:4f2d])
        by smtp.gmail.com with ESMTPSA id p9sm12359660pjb.3.2020.12.27.16.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 16:14:43 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: hdlc_ppp: Fix issues when mod_timer is called while timer is running
Date:   Sun, 27 Dec 2020 16:14:25 -0800
Message-Id: <20201228001425.821582-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ppp_cp_event is called directly or indirectly by ppp_rx with "ppp->lock"
held. It may call mod_timer to add a new timer. However, at the same time
ppp_timer may be already running and waiting for "ppp->lock". In this
case, there's no need for ppp_timer to continue running and it can just
exit.

If we let ppp_timer continue running, it may call add_timer. This causes
kernel panic because add_timer can't be called with a timer pending.
This patch fixes this problem.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_ppp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 64f855651336..261b53fc8e04 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -569,6 +569,13 @@ static void ppp_timer(struct timer_list *t)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ppp->lock, flags);
+	/* mod_timer could be called after we entered this function but
+	 * before we got the lock.
+	 */
+	if (timer_pending(&proto->timer)) {
+		spin_unlock_irqrestore(&ppp->lock, flags);
+		return;
+	}
 	switch (proto->state) {
 	case STOPPING:
 	case REQ_SENT:
-- 
2.27.0

