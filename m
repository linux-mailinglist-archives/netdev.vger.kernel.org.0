Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABB91186E3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfLJLoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42735 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfLJLot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:49 -0500
Received: by mail-lj1-f194.google.com with SMTP id e28so19473404ljo.9;
        Tue, 10 Dec 2019 03:44:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWOB2/IV9LlS7RQezdilUBmbfySScHur6xA52oFN8Mk=;
        b=Q2NcCZ9MkksL/3NQxvpoyzOR6VBFKo9p5yK/8B6NjPgFUfI3t6ZsTrMcwRVlM1iMYy
         lcs484KF5ZFwH90hZC9hK7Yb9hj6BCUxyjQVi1XeVWZ3hdPawEYFAmSiF7HM6snygMsM
         VxaD/DYKZ6BNgNcqNH5wg9WK4Z1/cwn2sKLrz35Wudcc1W8tbPqXfX+UuQGcne75voB6
         MTjGIjYX2MF2epTY2TwmTLkGm/3bJZcKfSxIWSuE0uIrU/N1ZHmqmtfhgmc9fdNyWxx+
         wgQjhB6YARFsH8Cmzy7P4SRhsy8IHavrPIRWnT50nnDcIMURZ/zxck3PjJ1SPXW+V4zj
         pTjQ==
X-Gm-Message-State: APjAAAWJDqm4L3C20tKD48CfAkWW6hICiueJ15Tc2pFfSVDwHkcOgdVM
        l/jlGPVXmeuk6xspFlWtsMc=
X-Google-Smtp-Source: APXvYqynsdHOtBWjaFSURKa7gPhmEPTZGQhZLn7lMHihEI1WubA2H/zTUly8AXEPYsJuWUpQ+LO9+w==
X-Received: by 2002:a2e:5850:: with SMTP id x16mr1332994ljd.228.1575978287598;
        Tue, 10 Dec 2019 03:44:47 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id x84sm1425212lfa.97.2019.12.10.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001II-Td; Tue, 10 Dec 2019 12:44:44 +0100
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
Subject: [PATCH 7/7] zd1211rw: fix storage endpoint lookup
Date:   Tue, 10 Dec 2019 12:44:26 +0100
Message-Id: <20191210114426.4713-8-johan@kernel.org>
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

Fixes: a1030e92c150 ("[PATCH] zd1211rw: Convert installer CDROM device into WLAN device")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 7b5c2fe5bd4d..8ff0374126e4 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1263,7 +1263,7 @@ static void print_id(struct usb_device *udev)
 static int eject_installer(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct usb_host_interface *iface_desc = &intf->altsetting[0];
+	struct usb_host_interface *iface_desc = intf->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;
-- 
2.24.0

