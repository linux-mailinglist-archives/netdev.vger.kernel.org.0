Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BD11581F7
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBJSC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:56 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43384 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgBJSCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:55 -0500
Received: by mail-oi1-f195.google.com with SMTP id p125so10028859oif.10;
        Mon, 10 Feb 2020 10:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pObL5DfR2yUaAQRXWmA8DaLHKZi59ZWx28shRwr6qq8=;
        b=ONHjn8epZXq+TgXplIsC4SJSlHptL9GrX/2mpNEv2WC0Y6bBD/ZolH17UZfRPJZumc
         bCTtSciGcy5I2TmN+/AfwAlNG3sjA8R6foGzjTSYcfaUAd9qN1av3oG55xt7+7Oy4S+l
         EOLdA5E2VOwK4I4fHFecNBQYGlWMltBsQqhimX+xH1QaZ6YTIfjM3GwA97+oaOW+3o+N
         GX+yXJWd2UIW4m2lV0OjquHb0zvDHUtUwRSNDOeqkd5ex6OUCPg4i5LzzARRxkCr82Pm
         HpDIonzuMOAl1E1s2FV3/WHWltctHzqfjOocwmeGq+ZIbZ9wFXBhq2hxBuWS51AWr97p
         VnLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=pObL5DfR2yUaAQRXWmA8DaLHKZi59ZWx28shRwr6qq8=;
        b=SYjkE7oaHJ98mYIVDApaQBfZuGgni/dQLdY6lvtAD/M972Ld+bXxnrJ0NsAQKuPfyP
         TR+NgdMJU7Z/uzAHkpup3jOcFptGGj99I7AKwMGm4/zmvyjhx32+aPNERwtxb8jVpOMu
         +KlxIqd7jwgAGDfvGMrtYmUxitQiChagBY+nHEff3KGREfvOCWyVV/B37PNkS2rL/qoV
         xJH/lN0q/1sexDWuw12FR4X+0DXJ2mvLjg7WXqgdRKU5Cs5bTXaD0SJICpMxcknk3mef
         nfcHTovHFoEDTodvjF54LQlHjwpvYGjavy9zSTg5MG24QRbftjh0pORgcRX7tTgDyqNR
         9Fng==
X-Gm-Message-State: APjAAAVwFbL/9epL1Vc7tf4EVE1aqcREebSwa5oMSHcMUMeYXikZCuXK
        hJ488xQhamCCgJlRq027/6w=
X-Google-Smtp-Source: APXvYqza/1k8Xmid5cRjcFihHMIA8WULIJkc5+IClSDLFvtK61MUtODlYskhUoZereG86E0fCccRqQ==
X-Received: by 2002:a54:468a:: with SMTP id k10mr186553oic.3.1581357774173;
        Mon, 10 Feb 2020 10:02:54 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:53 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 4/6] staging: rtl8723bs: Fix potential overuse of kernel memory
Date:   Mon, 10 Feb 2020 12:02:33 -0600
Message-Id: <20200210180235.21691-5-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
References: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In routine wpa_supplicant_ioctl(), the user-controlled p->length is
checked to be at least the size of struct ieee_param size, but the code
does not detect the case where p->length is greater than the size
of the struct, thus a malicious user could be wasting kernel memory.
Fixes commit 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
-# Please enter the commit message for your changes. Lines starting
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 3128766dd50e..2ac0d84f090e 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -3373,7 +3373,7 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 
 	/* down(&ieee->wx_sem); */
 
-	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
+	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.0

