Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852B2427EA8
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJJEFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 00:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhJJEFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 00:05:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE396C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 21:03:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so12155796pjc.3
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 21:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lO2KcrazhUWI3N8hSnUs7WUv1gAP0DNivcOBBLVmD8Y=;
        b=UmALeGXiZn3XwVG+o859F8CsDbC7AUmvd9ssich6sDoMySJ3LoGzRGQeF90x4btG+e
         9XUWwuBPj1DNztYciTk8WcVm/XKx07BouchekPXj2XrEZxHfUXk7s6fXuNbjpeh23gSs
         CW23gpelGQhUWDG8n3OCTmBajM4vu8EW/Ex6uOXhr5QolJjbPI0dybh11fuLId2aQ/t8
         aajfToawZoSBg3r6P26/nmQ0m7yY9y8J/I65CMfyy5LWYCZPAagzwmqMfPNfTzpecJwo
         PPAcP94YW9dX94xXO20huQTdulWOFGpJjua3K38FFvfTmF1NiFOlTyrA9XHPHnsXQQkz
         pAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lO2KcrazhUWI3N8hSnUs7WUv1gAP0DNivcOBBLVmD8Y=;
        b=XPqxLA86bZEQvo15prtjc7ZGfTsaoPbP4u8/aRVw6Hwk83OYVES2MoTgi+sPdiGfjF
         8/nBeA0F8LGlkZbwWwJ0j6KQ7pWS3RtA2U4BsMYrLgMlzqO33z1jOljGNqpP6tml4RvR
         7ZIz35uo/3/+eg+4JZSdi1+I3FyMuPzX/gf0NntgZ+oLBq22Erga6kXS8gXalir54ab2
         74ZWR/r31AhD8W2D/ODptgSdK1MwvJirxsCMGtjZrEG5N0IutKf4gs+mAP/gK82WjKya
         Zk5kc9d5xr7SPHQYtSCmU5b6ewpN+6pfnQidKBLljw6yFFlisT8wh7/eU/QhPyzfKFhN
         RMXg==
X-Gm-Message-State: AOAM532Vm0zGbG7nxVabpZ6evlZUAlxywpLlS17mqpPuxkkEUdhOjmj+
        +e0ps86kcw6RWfEEruJ9d2NwO5io/lOmtizfLT8=
X-Google-Smtp-Source: ABdhPJzZRJMorYFkiihVmDrOls2GmolHVbtDsGb49LN/jmrDfZUi+0BsYwW4i0ipZ7fyvnF+mp7Q+w==
X-Received: by 2002:a17:90b:224e:: with SMTP id hk14mr21664216pjb.224.1633838623482;
        Sat, 09 Oct 2021 21:03:43 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m6sm3507763pff.189.2021.10.09.21.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 21:03:43 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] hv_netvsc: use netif_is_bond_master() instead of open code
Date:   Sun, 10 Oct 2021 13:03:28 +0900
Message-Id: <20211010040329.1078-3-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211010040329.1078-1-claudiajkang@gmail.com>
References: <20211010040329.1078-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_is_bond_master() function instead of open code, which is
((event_dev->priv_flags & IFF_BONDING) && (event_dev->flags & IFF_MASTER)).
This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/hyperv/netvsc_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..64e1e99548ba 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2742,8 +2742,7 @@ static int netvsc_netdev_event(struct notifier_block *this,
 		return NOTIFY_DONE;
 
 	/* Avoid Bonding master dev with same MAC registering as VF */
-	if ((event_dev->priv_flags & IFF_BONDING) &&
-	    (event_dev->flags & IFF_MASTER))
+	if (netif_is_bond_master(event_dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.25.1

