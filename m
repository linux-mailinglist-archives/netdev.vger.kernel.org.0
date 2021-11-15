Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137CD44FF89
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 08:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhKOHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhKOHyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 02:54:43 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2566C061746;
        Sun, 14 Nov 2021 23:51:48 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e7so19029304ljq.12;
        Sun, 14 Nov 2021 23:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fmv+wBbREKrq5EKjNonxF2xk5in9wemwfMUGZyPQjHY=;
        b=LOVll48TQ7SB7NGlhMydgh9pkfMA6XtyIaRfa+W3Dg76PFSIzl8urrrsz/Sq86qEdo
         a2hCxHoh+VoPipuEVCQJEXtoP5fYBmKgjVdjUsPOL+eDdKU692rgVPVB6p29Zm5GIpm2
         qCXSIBqU16I7QiC2DUmNU65zsvBDR93Y5vLbuB7zK68VGQxvcHIXQGFZ4zFMkmPXlRUK
         yKwzqlg1095Xo1mCKOqy+ADvvARMtkQbFs+FZjxZU+wRqvIwRoHiiEVWNJbl0xslHC7z
         oo4GmoTYl6QRtzG2BewmxiONzXiAMVQfCoMnYhq8O68IwgAI1gI/F1yBVPQkvL0VuzzR
         cGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fmv+wBbREKrq5EKjNonxF2xk5in9wemwfMUGZyPQjHY=;
        b=4EEh0tZhS6XTbJu5iefItXLqx9yC29prqjbgcNg/jPNv8NiLI64n1NyWwe6tzTDqTR
         zBp83HMdrR/HBEAxAzAK900YsHGgLBaKcdK0CBoMs7pPmzu6yXQX1cHtJssgeiewYyOA
         TTyVPNuY2qXvWnMHhYx++YFOM920orpl5oeAJ6yLcBsyRzLyjG+2JG3ilMrLQQprGTZB
         HfnMMTjq40kcmDFniKAHwuOXwzmhi7RMy7o2l0Zbt47kmAim9l38wWrjBsacKDcVrKNo
         enUMLY5An01EHhysuCNoR51FGgnsVtIXhJq3nbucKqcWtZElt7lMWBD94Pay/CPHVpy9
         81yA==
X-Gm-Message-State: AOAM531g7Rii1HWd5Rqj7QpIFMmjRz1PwwMWFwHC32h7BhoCG2Jh6+UB
        CyGl037NzbqnOG+B1PbZp2CRoDSOhY4=
X-Google-Smtp-Source: ABdhPJxEhOMKRFTESQSobtgTChWOZHw2cmCWFiCBSLfPk7QnRNayX/Yzvr5QHSRr8WpFYyC6yAOsVw==
X-Received: by 2002:a2e:86cc:: with SMTP id n12mr36139703ljj.275.1636962707034;
        Sun, 14 Nov 2021 23:51:47 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id m15sm1338806lfp.9.2021.11.14.23.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 23:51:46 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2] can: etas_es58x: fix error handling
Date:   Mon, 15 Nov 2021 10:51:24 +0300
Message-Id: <20211115075124.17713-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When register_candev() fails there are 2 possible device states:
NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
for calling unregister_candev(), because of following checks in
unregister_netdevice_many():

	if (dev->reg_state == NETREG_UNINITIALIZED)
		WARN_ON(1);
...
	BUG_ON(dev->reg_state != NETREG_REGISTERED);

To avoid possible BUG_ON or WARN_ON let's free current netdev before
returning from es58x_init_netdev() and leave others (registered)
net devices for es58x_free_netdevs().

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	- Fixed Fixes: tag
	- Moved es58x_dev->netdev[channel_idx] initialization at the end
	  of the function

---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a..b3af8f2e32ac 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2091,19 +2091,22 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 		return -ENOMEM;
 	}
 	SET_NETDEV_DEV(netdev, dev);
-	es58x_dev->netdev[channel_idx] = netdev;
 	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
 
 	netdev->netdev_ops = &es58x_netdev_ops;
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		free_candev(netdev);
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
 
+	es58x_dev->netdev[channel_idx] = netdev;
+
 	return ret;
 }
 
-- 
2.33.1

