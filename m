Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA851186F2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfLJLpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:45:23 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36205 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbfLJLor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id n12so13466222lfe.3;
        Tue, 10 Dec 2019 03:44:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pnY+PJY7SPNBPbJBBIXQDigd1msQalbdBbCvxm59meA=;
        b=qZw7pAcCCjlp+sL+q4RnQpuvzhdNhBc96Y2S6dj7LIWrTw3RHpQWkUsk5aNAxPVPSt
         CNdf531LM2820HgnLechfjgo9CniTyKl1TeM9lg2yoxVcOqLZWwIsPyEvsW+R4hmC4xv
         S5EGFGwgX7B0pjLtFS9velhaffaQplAgq5Elvn0b+GZL9NCSQR+j1Q28TMp9ut45Me1s
         6HWLsVeoDLRB7LRIrx5ItNys7KE6+GecSnUfQ0FeW9p9mpExyqtTwNrnF2f5iyJ4WAp7
         sN/XksaWEef8Ilaw5lFloQ1JwvjRvLaRt9ymJLCMJhjouyDqA6Avo3Eb8cD8/1HgxFHQ
         L1vw==
X-Gm-Message-State: APjAAAXmx3G7bGTimmONJUe5d8cF8hitGNuKibt7IBv3WrOYw8jc+s0Y
        +OYGn6oQzRegodelXft0k9I=
X-Google-Smtp-Source: APXvYqwbNRbtj2Ow9aDvwjOtvOf4OiR4OleAxoH6lR3rQqOKq931QpA1xB3+eApd+1ggaGGzZnVx9g==
X-Received: by 2002:ac2:44ce:: with SMTP id d14mr14176321lfm.140.1575978285036;
        Tue, 10 Dec 2019 03:44:45 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id a14sm1427974lfh.50.2019.12.10.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001Hx-HP; Tue, 10 Dec 2019 12:44:44 +0100
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
Subject: [PATCH 3/7] brcmfmac: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:44:22 +0100
Message-Id: <20191210114426.4713-4-johan@kernel.org>
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
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Cc: stable <stable@vger.kernel.org>     # 3.4
Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 06f3c01f10b3..7cdfde9b3dea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1348,7 +1348,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto fail;
 	}
 
-	desc = &intf->altsetting[0].desc;
+	desc = &intf->cur_altsetting->desc;
 	if ((desc->bInterfaceClass != USB_CLASS_VENDOR_SPEC) ||
 	    (desc->bInterfaceSubClass != 2) ||
 	    (desc->bInterfaceProtocol != 0xff)) {
@@ -1361,7 +1361,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	num_of_eps = desc->bNumEndpoints;
 	for (ep = 0; ep < num_of_eps; ep++) {
-		endpoint = &intf->altsetting[0].endpoint[ep].desc;
+		endpoint = &intf->cur_altsetting->endpoint[ep].desc;
 		endpoint_num = usb_endpoint_num(endpoint);
 		if (!usb_endpoint_xfer_bulk(endpoint))
 			continue;
-- 
2.24.0

