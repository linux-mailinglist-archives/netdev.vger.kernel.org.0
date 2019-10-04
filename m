Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF86CBDB9
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389349AbfJDOpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:45:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39005 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389042AbfJDOpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:45:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id 72so4671189lfh.6;
        Fri, 04 Oct 2019 07:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8QTZK9sCzxaP06E0HfF24SaxLLLX/pXiHs6qGwe+XA=;
        b=knPkFB1BlXD+Rt06m2gkaWqTL9SJSHAPwwadA/850KPlweLkfdlHUWw/f0hCHZycYt
         aD1VBqMPVcOneJomeJc53o96jwXMm1/sba/oBBXz4gIR+lgHScbExWA5Edcmbqq2P+j6
         RJZCIy0qnkm0r1aBFF2gtw01RYr5ZnMMSKPFgFt/mV24Fal8aPJK+wXDxBSEjyNDBA+b
         jiqP/9vFg3xk5rk3UKareaJ4MFa6CmYQBt7tDMmEEeE0jHuX08MzLNeQGDLclJ919+lS
         KBYXwkCrtO8OtHHbCaYQYh6yjXq6dDXpSYh1FDa89Y+hCDtP1d1kwz8Od1VLhq5VzeI+
         Moog==
X-Gm-Message-State: APjAAAUsOcjMq8uzQ2aWtwdox6RMnEMHxnQecAYL0yspC/cEV3122jke
        dEZHMcWhOWrs+cpRCwm8ir0=
X-Google-Smtp-Source: APXvYqwGCfJTSnB86hgdZ4Gku6DN0lA1FH5FrFessynFlbJyPs2FZbz/5S5l2tTYzg1E3Bxvh7XS/Q==
X-Received: by 2002:a05:6512:14c:: with SMTP id m12mr9029400lfo.27.1570200349145;
        Fri, 04 Oct 2019 07:45:49 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id v1sm1198536lfa.87.2019.10.04.07.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:45:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iGOqG-0005V4-5l; Fri, 04 Oct 2019 16:46:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/2] rsi: drop bogus device-id checks from probe
Date:   Fri,  4 Oct 2019 16:44:22 +0200
Message-Id: <20191004144422.13003-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004144422.13003-1-johan@kernel.org>
References: <20191004144422.13003-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB core will never call a USB-driver probe function with a NULL
device-id pointer.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 760eaffeebd6..53f41fc2cadf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -785,10 +785,10 @@ static int rsi_probe(struct usb_interface *pfunction,
 
 	rsi_dbg(ERR_ZONE, "%s: Initialized os intf ops\n", __func__);
 
-	if (id && id->idProduct == RSI_USB_PID_9113) {
+	if (id->idProduct == RSI_USB_PID_9113) {
 		rsi_dbg(INIT_ZONE, "%s: 9113 module detected\n", __func__);
 		adapter->device_model = RSI_DEV_9113;
-	} else if (id && id->idProduct == RSI_USB_PID_9116) {
+	} else if (id->idProduct == RSI_USB_PID_9116) {
 		rsi_dbg(INIT_ZONE, "%s: 9116 module detected\n", __func__);
 		adapter->device_model = RSI_DEV_9116;
 	} else {
-- 
2.23.0

