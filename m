Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510A9350E39
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 06:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhDAErM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 00:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAEqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 00:46:40 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521A0C0613E6;
        Wed, 31 Mar 2021 21:46:40 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id z8so763953ljm.12;
        Wed, 31 Mar 2021 21:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjqdiooQd5/01txoaSk7jE08J1uiZ+F+O8QxpLK+ei4=;
        b=XnpEJG2HT1OMn2+AW9X47ZWsDL892/KS0v5ic9jdz4wRnh+vIMiqMLm9Es5Hw8x4Oc
         0d2x5OQtKpp9iIWaGYSy/qT2/XopLkZ5f+PttxFU2c7SZxB2VJeRVbOg6iStAVY7s3fh
         YaqNLYTgCAoUfpS6sEUj1KLUN25w8499BmKqcxyXW/b3O3NscwUxzM+CebuGykG09Gmy
         9dBfybyE+jBVQhMHpesHzwOJDS0NttuNkAklHbujUltLDRqxBVjF1BAHkmdQ8nw0OqY9
         oWp75R4dLQdMbsvPlLxPrd7+QzO3S4moqQMcAeFagW8p6hjIzEVCWT3NZYf/LpAa/yZF
         c+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjqdiooQd5/01txoaSk7jE08J1uiZ+F+O8QxpLK+ei4=;
        b=pMJm67BoLIiD08qvHYJd2M07L5t5qJiziLKcNP2TFv1SKDh7NHUde5az8QC1Io2iV1
         4H1vXMqYXHOh/zOUBphMg+GTvSb677hx8L2mC/+IOJxoYsVe8gXLpNvV4Gl/rT6B4Gg+
         FmfYT/x1KrPFMMLOO1pV/wYJMSxa+J7IUlnCFTeVimbqLO1ay5w0CsmOQZkv5d9Af7oZ
         yX3ymeGDTp7Gbxzb75lHxe/WJmRPAnSHJxV7VhopZK/scEWLtCqDiWrVv0xdqYrx497S
         euU3DlL7UCQas6sXQKJCY6IcxF0sDD49KusDKNyqYiDP4/1PW5nBcQFK+FcqmCfK4m8j
         nAxw==
X-Gm-Message-State: AOAM5315/84beJ9eUDn7JsV7ACzY34VHITw10UiH0QrtUK6AwSN4pCwv
        SVWkmW93KfULbTJJE0lutaA=
X-Google-Smtp-Source: ABdhPJyz3NEQm9Q8izBmRjhDMCSUIjXsftQO8zVzOyEVy91PGj04o6ewrh7dbAE90v/qJhdLaTcr5w==
X-Received: by 2002:a2e:8159:: with SMTP id t25mr4263398ljg.437.1617252398843;
        Wed, 31 Mar 2021 21:46:38 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id f8sm482754ljn.1.2021.03.31.21.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 21:46:38 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com
Subject: [PATCH] drivers: net: fix memory leak in atusb_probe
Date:   Thu,  1 Apr 2021 07:46:24 +0300
Message-Id: <20210401044624.19017-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported memory leak in atusb_probe()[1].
The problem was in atusb_alloc_urbs().
Since urb is anchored, we need to release the reference
to correctly free the urb

backtrace:
    [<ffffffff82ba0466>] kmalloc include/linux/slab.h:559 [inline]
    [<ffffffff82ba0466>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
    [<ffffffff82ad3888>] atusb_alloc_urbs drivers/net/ieee802154/atusb.c:362 [inline][2]
    [<ffffffff82ad3888>] atusb_probe+0x158/0x820 drivers/net/ieee802154/atusb.c:1038 [1]

Reported-by: syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ieee802154/atusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 0dd0ba915ab9..23ee0b14cbfa 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -365,6 +365,7 @@ static int atusb_alloc_urbs(struct atusb *atusb, int n)
 			return -ENOMEM;
 		}
 		usb_anchor_urb(urb, &atusb->idle_urbs);
+		usb_free_urb(urb);
 		n--;
 	}
 	return 0;
-- 
2.30.2

