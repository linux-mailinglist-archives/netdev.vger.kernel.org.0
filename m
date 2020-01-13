Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31801139792
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 18:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgAMRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 12:24:11 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34834 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgAMRYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 12:24:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id j1so11012892lja.2;
        Mon, 13 Jan 2020 09:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QlfFAdFScE9eazBxy44sDKtFGtk3es9wEFbHmp3zDH8=;
        b=Dwi2MzSf3x75Cm3NUReGz4TmJIv3IL8zxYwqhwh7l+atsApn4JQMxRsmOKI+bbmzdu
         vx3oQz4JCRQzXeBDnRiJFTNqi420EohDflU5e7g/gqFexFG3KwZZnDIcSFlSEtdQF/JD
         eAqmnw8hFaU3o/3JPmK01bNhFinkwiltDQR5EJVU0B9C9m80K9kmIo1X06mzTBg0yUyp
         QAGS+TKhdNWCvSc2+T/4zOVgVtq2+VlJz1wyUKXUo/n5hqyikTk5pFDhzGl6Ciy4Yfum
         g78pchG55OOYohherHGgVQ+6sPbVpapPrVDe62ofAALWrkuLdjmcrFSvJoM/CgFqMSn5
         uSiQ==
X-Gm-Message-State: APjAAAU1PPxCLgv8a9uW9XgIoIu8IvN8ZDLmRGprVlgXqSU2tWnQy0K4
        54vOqI7yZlhoy9a1TXh4fKm6juZB
X-Google-Smtp-Source: APXvYqzJvte/a6SWB5ZAj9L2MQ7QjnxsCkcIXmQtT/nS+1XGi9SQt7q7KO1lF5rx8+2E6/c+2EldWA==
X-Received: by 2002:a2e:3619:: with SMTP id d25mr11668282lja.231.1578936248566;
        Mon, 13 Jan 2020 09:24:08 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 144sm6083349lfi.67.2020.01.13.09.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 09:24:07 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1ir3Rf-00084L-UG; Mon, 13 Jan 2020 18:24:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] NFC: pn533: fix bulk-message timeout
Date:   Mon, 13 Jan 2020 18:23:58 +0100
Message-Id: <20200113172358.30973-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was doing a synchronous uninterruptible bulk-transfer without
using a timeout. This could lead to the driver hanging on probe due to a
malfunctioning (or malicious) device until the device is physically
disconnected. While sleeping in probe the driver prevents other devices
connected to the same hub from being added to (or removed from) the bus.

An arbitrary limit of five seconds should be more than enough.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Cc: stable <stable@vger.kernel.org>     # 4.18
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 4590fbf82dc2..f5bb7ace2ff5 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -391,7 +391,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 		       cmd, sizeof(cmd), false);
 
 	rc = usb_bulk_msg(phy->udev, phy->out_urb->pipe, buffer, sizeof(cmd),
-			  &transferred, 0);
+			  &transferred, 5000);
 	kfree(buffer);
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
-- 
2.24.1

