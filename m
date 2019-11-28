Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6310CDC4
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK1RYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:24:53 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:32919 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1RYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:24:47 -0500
Received: by mail-lj1-f196.google.com with SMTP id t5so29295489ljk.0;
        Thu, 28 Nov 2019 09:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZNDtdmETKvubKODy6INzZo8FVEmBbwko469tiDmk0AM=;
        b=FbOmGKINtKzawJJ2mUBzCDl0j5Vs/eTV3uife+bK7l0pOl4hZvCspIo0WOI+AKxqHC
         6FgN3Zu9PDGNZH1yOA26RTz7zu7jg9afo8Ed7+M+OJb78P9gSi3y1K+qtK1sgHOfO79H
         RtrVNMpgPJAzRn4MIs0QIKNtowiPEUi+bILPwr2WJ39xzkJgdy0FoTiJfZBmiuWpTcm9
         Md/hntZ78GkHXXV+w6YZgNm0qm5OHAhXMp/I09F7rEYcpCFQO4r0v0CPO2wnivlmHUru
         eawyNRjBtI5qn5i46X9e79QPJzKKEmcwYgfmdfY6M/CGSNNTr+OJ7DzKngvBcK525H7K
         CWjQ==
X-Gm-Message-State: APjAAAWPvSkjr6rF2TqkJaBFZcqXIcc+L3r8HhXRD6EjCOzTC7ayfUvq
        Yh2VuOvMRf2ZK/+g9FScGPZb/Mb6
X-Google-Smtp-Source: APXvYqyunx60s7xYwHwsXv+RzmdWsqerfg4cVHpazXff3kOLxlOCkO82Mmc+9EGbretyrTDzA9hiVA==
X-Received: by 2002:a2e:818e:: with SMTP id e14mr20712822ljg.245.1574961884955;
        Thu, 28 Nov 2019 09:24:44 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id u7sm1860356lfn.31.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wk-SD; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5/5] rsi: add missing endpoint sanity checks
Date:   Thu, 28 Nov 2019 18:22:04 +0100
Message-Id: <20191128172204.26600-6-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191128172204.26600-1-johan@kernel.org>
References: <20191128172204.26600-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver expects at least one bulk-in endpoint when in "wifi-alone"
operating mode and two bulk-in endpoints otherwise, and would otherwise
fail to to submit the corresponding bulk URB to the default pipe during
probe with a somewhat cryptic message:

	rsi_91x: rsi_rx_urb_submit: Failed in urb submission
	rsi_91x: rsi_probe: Failed in probe...Exiting
	RSI-USB WLAN: probe of 2-2.4:1.0 failed with error -8

The current endpoint sanity check looks broken and would only bail out
early if there was no bulk-in endpoint but at least one bulk-out
endpoint.

Tighten this check to always require at least one bulk-in and one
bulk-out endpoint, and add the missing sanity check for a Bluetooth
bulk-in endpoint when in a BT operating mode. Also make sure to log an
informative error message when the expected endpoints are missing.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ead75574e10a..396b9b81c1cd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -149,9 +149,17 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 			break;
 	}
 
-	if (!(dev->bulkin_endpoint_addr[0]) &&
-	    dev->bulkout_endpoint_addr[0])
+	if (!(dev->bulkin_endpoint_addr[0] && dev->bulkout_endpoint_addr[0])) {
+		dev_err(&interface->dev, "missing wlan bulk endpoints\n");
 		return -EINVAL;
+	}
+
+	if (adapter->priv->coex_mode > 1) {
+		if (!dev->bulkin_endpoint_addr[1]) {
+			dev_err(&interface->dev, "missing bt bulk-in endpoint\n");
+			return -EINVAL;
+		}
+	}
 
 	return 0;
 }
-- 
2.24.0

