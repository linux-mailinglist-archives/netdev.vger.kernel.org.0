Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA7A1186CF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfLJLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:45 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36587 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbfLJLop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so19536008ljg.3;
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HIbOMPFeN5/NwJ3YbPrJKdOlArPlt1Io+T/N+aqc/UY=;
        b=hpMA7H6aMlCb5mifXdB4oWd67sveaziPwDWZ09YCsOajifr6nIP4UvOvvMLMEIl3uB
         Xgx1nXnVshAVX24BD05rIZw0I7fSQudC4GSyByGTXwt/U/n66Z6U0kMZwBMhGzK9BAmA
         8vzFfvwBS0gp/Bsq8bJwSWc894WzPd/wlsQ9aWjsSciwru/3vrh/axqQD0JXyZviUrPM
         5PVROogfjPAl3YFwlPK1ismTj82IyPutNxa8Dlx02513uKDVtJalZz/CKQ71ZBZBrwbI
         TE1bLCQl40t4Pd/zvuPrPkBAlFpj1Qh6dY4g1coXx9xF4UK/Ez4ivphhzB72PSAGDimI
         zYcw==
X-Gm-Message-State: APjAAAW/Sv1+Smpx5s5cqUuXydrTBZxDMvUCvdD9ZJiw2raqsq7xKHo1
        csEMSft0ibJREpSxm1/SIco=
X-Google-Smtp-Source: APXvYqyK4ihZYY8oRV5G7F87li0Hb+55Iu5uAyn/mcP70GXX368WCtLm+NOOStcXbRXyaXs4PdIy3A==
X-Received: by 2002:a2e:93d5:: with SMTP id p21mr20940877ljh.50.1575978283184;
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id r9sm1683726lfc.72.2019.12.10.03.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001Hn-BX; Tue, 10 Dec 2019 12:44:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/7] ath9k: fix storage endpoint lookup
Date:   Tue, 10 Dec 2019 12:44:20 +0100
Message-Id: <20191210114426.4713-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114426.4713-1-johan@kernel.org>
References: <20191210114426.4713-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to use the current alternate setting when verifying the
storage interface descriptors to avoid submitting an URB to an invalid
endpoint.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
Cc: stable <stable@vger.kernel.org>     # 2.6.39
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fb649d85b8fc..dd0c32379375 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1216,7 +1216,7 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 static int send_eject_command(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
-	struct usb_host_interface *iface_desc = &interface->altsetting[0];
+	struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;
-- 
2.24.0

