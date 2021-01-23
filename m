Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27F8301747
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 18:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbhAWRdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 12:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbhAWRdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 12:33:23 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF6AC061786;
        Sat, 23 Jan 2021 09:32:42 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id dj23so10254585edb.13;
        Sat, 23 Jan 2021 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=klQ92AsGVun8EXhe8gKG4+W2waOu91kgDSvT3RdMYyQ=;
        b=NOQieAWGJEhAzSw1Fb7h1rvdl/vEHyN6TDSIfxv0B8EzkRgAOjqtyQkDqvnrCGHcQk
         gCEF6hKWv3MYyATOIM9p7BHPnNFg6XYbGwAH/U6Q2MXKcw83beYabuht/2vB4qWeoiLm
         dkvgMePPlfMUTpNTiofmSwzxt3rlQ5a1otpmL4vn6KLk3aYmZ84ebs8hiWpekg964Ez5
         R8j4ktGztyfi+tSia7HTDrYAZwehtjSYJreM+WVJAh/hh9d/YHi+dWra19tLhQJZ1MFE
         6KP1IChvV9AEDMLNrEDJ7QAvsZ6FIVmgZ6wZnxlj1MbDlXCVI9RQAmf9cefbkS1ljIPS
         wfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=klQ92AsGVun8EXhe8gKG4+W2waOu91kgDSvT3RdMYyQ=;
        b=U0Y+CmFFKhj/nDd4ieHv4tcKaQJqnB35Sd2QCeVFejf7fl53oNP2chvtBP30QRxtsu
         XkE8CyZf6XS54v9PZdXsXCsJBy7diYCNVLk1ZH1koKt4Qm0vHfb9qsgEmoc31gEMKX9q
         H5STyAa01wSn/hv7wf5PC+D4SwCP8Tw9idLrwiCik3UPjphVFGU5mX8c+JUDWPa8xMnI
         lPll4FEN6RmdtAVTRLAB76AGiVNwCuaJmhfSYjJed68FL3X5cRQcC90gfesUvczWM07a
         rf7noaH12pZ+G5YOY37KvBnps/8iUm3jgH+CjRBJw1++5IqdOVw1I6hQURFercs1YXEe
         sROQ==
X-Gm-Message-State: AOAM5338UOL/ofvC2os3NLpMbuh3+LAKI9mf2gJQjH+GXyU7clxkXxjf
        yz3rUg+m89VKV6lGN6R5A2Sfdpv1jEMLUw==
X-Google-Smtp-Source: ABdhPJw0TdNySwmNfIw0toZWTWGsvJ1biIjEEhKdAuRv98Mv0O5u4/pvz0mc+rbohVNwT/A423auzA==
X-Received: by 2002:a05:6402:1819:: with SMTP id g25mr1211274edy.46.1611423161375;
        Sat, 23 Jan 2021 09:32:41 -0800 (PST)
Received: from stitch.. ([2a01:4262:1ab:c:de4:866f:76c3:151d])
        by smtp.gmail.com with ESMTPSA id e19sm7528116eds.79.2021.01.23.09.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 09:32:41 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <esmil@mailme.dk>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: usbnet: use new tasklet API
Date:   Sat, 23 Jan 2021 18:32:21 +0100
Message-Id: <20210123173221.5855-3-esmil@mailme.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123173221.5855-1-esmil@mailme.dk>
References: <20210123173221.5855-1-esmil@mailme.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/usb/usbnet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 26455c76588f..e3f1b419a98f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1539,11 +1539,11 @@ static void usbnet_bh (struct timer_list *t)
 	}
 }
 
-static void usbnet_bh_tasklet(unsigned long data)
+static void usbnet_bh_tasklet(struct tasklet_struct *t)
 {
-	struct timer_list *t = (struct timer_list *)data;
+	struct usbnet *dev = from_tasklet(dev, t, bh);
 
-	usbnet_bh(t);
+	usbnet_bh(&dev->delay);
 }
 
 
@@ -1673,7 +1673,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	tasklet_init(&dev->bh, usbnet_bh_tasklet, (unsigned long)&dev->delay);
+	tasklet_setup(&dev->bh, usbnet_bh_tasklet);
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
-- 
2.30.0

