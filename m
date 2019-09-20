Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F939B88F4
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394628AbfITBgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:36:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46888 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389293AbfITBgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 21:36:47 -0400
Received: by mail-io1-f66.google.com with SMTP id d17so12335618ios.13;
        Thu, 19 Sep 2019 18:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2vkYM2Vw9GpvccAiSSIMhifEzfuK8Ld4R3bwXVgh1ps=;
        b=nljLTTHaQr3RenMHyxOGrtAwE/I0ES0GK9UJLdYkS7iEalzRrwu+/ygif0A/YnEFuE
         fMLFG5zBRN2I7SpqvTBqaxAYJbA+a5Nnb5ymeV3s6Ef+CcGHE165IRfi+4dxEt/RvV3k
         4CjBDTDWGnnBO1wfDcS0WW9TqjJEoxFKWNCL+8oAzUyMten4zs8XPRUPlZVc5dHnkqC9
         LmLWnaSBjm2g5JG0GJKSrT8KrYP2mv4yGUR0HaWruQWwfQQ8NJc2RyXm1Ml99KZkoU73
         TG98jQSy2dcHrVqaNRfpAtyj0WEwXdLqMfT1ggk69p1ZfC7ol/7QEQxzgDIU0EFn2r59
         owvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2vkYM2Vw9GpvccAiSSIMhifEzfuK8Ld4R3bwXVgh1ps=;
        b=Hyi2mcH+USr7WGJ8oO/idsyoKCLl+d4m89yBVH8t4CoX7P0zSZ8m9MqctDqu7+thiv
         I44/mQra4hOC17UhVbitBayfcTqbOZdivlZ8DMIBEqpTKl+3VRAryBGSoWAjjNG78iE5
         qzII+tBVaxNiw/ZDE29ML5KCTRzJgiWh4utQBQrxL2UtArFSI9nNobDOcMWpSGg9fF6s
         24fLUkPhifpSTRmno4GJ0ps3FDbKr97NyTmegb0odxfujMPy+/wgzXMq8vd3jSmehEjH
         M8aNgDpVetxfBuVDO+wC5lmTSfr1U85758CBdpxsWerU1Md8gdZ0k1zy3E41z0Io6XWJ
         HAcA==
X-Gm-Message-State: APjAAAUJMIRIWx2CnoljjsP0uSf1TrUJuJPFbs4ExJNOd/HNa3yToECg
        EcVP0fYdPYDDYIvfeoUpkVE=
X-Google-Smtp-Source: APXvYqzLPqJkNUviwDSfcaSYJH+eUFOLc0fBeZpgji797e/U5UAY6XAi9Cq7iKldElsnElvAmFWNCw==
X-Received: by 2002:a6b:8f15:: with SMTP id r21mr3490587iod.259.1568943406715;
        Thu, 19 Sep 2019 18:36:46 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id x12sm335602ioh.76.2019.09.19.18.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 18:36:45 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: fix memory leak
Date:   Thu, 19 Sep 2019 20:36:26 -0500
Message-Id: <20190920013632.30796-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath10k_usb_hif_tx_sg the allocated urb should be released if
usb_submit_urb fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/ath/ath10k/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index e1420f67f776..730ed22e08a0 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -435,6 +435,7 @@ static int ath10k_usb_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 			ath10k_dbg(ar, ATH10K_DBG_USB_BULK,
 				   "usb bulk transmit failed: %d\n", ret);
 			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			ret = -EINVAL;
 			goto err_free_urb_to_pipe;
 		}
-- 
2.17.1

