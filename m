Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963D032FDB0
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 23:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhCFWNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 17:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhCFWMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 17:12:52 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3477C061760
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 14:12:51 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d8so3113430plg.10
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 14:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d7MGR4tp7113VprvERcZazEvUbTtIdBfVouZlCmQkY0=;
        b=W69RTXonP1fds/GcIu/bkUaKdrmw6W0tcMcyiAPtrnItsml0CNWNtBi6EWpcFBPOPF
         BbIzIEUTbZ0mNbKeb1W7YEqeEJR1ANXzgjGM3HjK8jljKQu+FgoiD101/9ATvzxidi/v
         6aPsaIjbvVUXGapB9Yiq4CxOfJp4rmHqjh7RM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7MGR4tp7113VprvERcZazEvUbTtIdBfVouZlCmQkY0=;
        b=Bep46XZtktzdIFIgc6auzoKzbrNo/f2nLISl9XrOtZnyWybRiIS8LFaGP5SyTCsyqB
         z4JOCzVtN8rQrdp/jtJ3oES18SGu7E0DsGmwDLPYAud4lTm4BCQktGK8iLGXYYGNTgCZ
         sNbkDlBifVKOLKAlh45t8GqzostH3S/iIP7JeMoCl2DBmAskT6VtyIGBepwGMNnz15nX
         60NeFUDyeL/EHRtJ8uL4+bewocKlOlsfyHD07+eHoxpYrAnuJ6K1vS68ykCiAMx/jjrv
         N4tfpCEhdQKoch6DO16Jb5D8YsOYCV/jG0As+9mIpKXQ2sllxjHDYNkKTJq9TpkY7qN6
         G7kg==
X-Gm-Message-State: AOAM533TE60YL9uYtW6x9bSEytw1AOMFQWBFwH3ZTnvBE7Vpuysr4AHv
        VkV3Yw7ecA4dYtuxnuBkvX8ryg==
X-Google-Smtp-Source: ABdhPJyQJuStOVPAVNxLQKM0F/hD8RTA94a4og2w0dk3TocJDb3fHWzmLFoPbmTPXqO0DtsJlm2fVQ==
X-Received: by 2002:a17:90a:16d7:: with SMTP id y23mr17876263pje.227.1615068771551;
        Sat, 06 Mar 2021 14:12:51 -0800 (PST)
Received: from grundler-glapstation.lan ([2600:1700:3ec2:905f:9c5:ceb0:502e:f28d])
        by smtp.gmail.com with ESMTPSA id n125sm5763198pfn.21.2021.03.06.14.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 14:12:51 -0800 (PST)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH net-next] net: usb: log errors to dmesg/syslog
Date:   Sat,  6 Mar 2021 14:12:32 -0800
Message-Id: <20210306221232.3382941-2-grundler@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
In-Reply-To: <20210306221232.3382941-1-grundler@chromium.org>
References: <20210306221232.3382941-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Errors in protocol should be logged when the driver aborts operations.
If the driver can carry on and "humor" the device, then emitting
the message as debug output level is fine.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/usbnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Reposting to net-next per instructions in https://www.spinics.net/lists/netdev/msg715496.html

I've applied this patch to most chromeos kernels:
    https://chromium-review.googlesource.com/q/hashtag:usbnet-rtl8156-support

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1447da1d5729..bc7b93399bd5 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -887,7 +887,7 @@ int usbnet_open (struct net_device *net)
 
 	// insist peer be connected
 	if (info->check_connect && (retval = info->check_connect (dev)) < 0) {
-		netif_dbg(dev, ifup, dev->net, "can't open; %d\n", retval);
+		netif_err(dev, ifup, dev->net, "can't open; %d\n", retval);
 		goto done;
 	}
 
-- 
2.29.2

