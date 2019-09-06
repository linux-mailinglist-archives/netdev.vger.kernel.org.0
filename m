Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1006AB69A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbfIFLHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:07:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47010 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390377AbfIFLHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:07:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so6120772wrt.13;
        Fri, 06 Sep 2019 04:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JUfMY89FxK/4PZfbkgvJJAvRZHgggwqGP387mVBSBec=;
        b=S3M0xG/jx0E4rGxCy8CVN6/zRlA0cXFS8/IV9aQhtVEJinXzEXPDKns32hds3EHFQI
         DNM7KPNRAgRlaspudMCUM06Fe88Ur24TVa2js4g1T9CQpHTBg6BWpXZ7bc5XUgZ1//FJ
         AGkdM4p7w8NdNpGUCI+Apy7DkYG+DVjq04Qom6nd4w/W0cY204ZTDtZQKEGjsbyvv/qY
         WZOAqaasWNldcqXmCwbpQw+BWOJ1B1OVJO6T844q6WtqVC/IwEh91WeoXL4+HAHsILzu
         deUs4dmp6iUimlvCrurIW5IXNaGM0DnSV4/zbFkwUHifGY67NuGs0UQw3jcOElSNqtGd
         tIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JUfMY89FxK/4PZfbkgvJJAvRZHgggwqGP387mVBSBec=;
        b=YfbVdTjBzJpV7t5/WJm8l5OL9+f23vG+Rn0R9JDMjTxfQZUgr1uYBvANeeD87lTYUa
         0kFfuRW9trsNgaxdJ85JYuXGGJu25ARRzu3kKIFM4u1WIm4t1cFRcOuzIL01t9timqxp
         nbrqBZB7yxz4WLqb9tqrOXbmDPAezE5kYf4a/6qpdWiDF5MEMnOZUK+OPeXjjcXin+Go
         6ERbW9869bjuQOEX9OrG+P6GF/Ftr0+CSanB3xIngygDFnanokQjwwqgmbIHAzovvw+Y
         mPoCRug3eDERtoOtWFS4MwTEt0RutAVHicQp82RpwrXFS9r6m79bBa3Tz6EpAetzWRRX
         RfZQ==
X-Gm-Message-State: APjAAAUXiE/btcG8HwA8+kuw1SkhjCWz6A01GGPDfc+d+TWpqHQeEl62
        dTctPC2MCR16vqHdlG5EE3U=
X-Google-Smtp-Source: APXvYqwUgxvFFbfK4J/6FC9T0gRHiyy2dDDvOAgb/kCod1chhRzVIAEm94KmawloJ8DHxeqDd3WgfQ==
X-Received: by 2002:a05:6000:108e:: with SMTP id y14mr6517608wrw.344.1567768052678;
        Fri, 06 Sep 2019 04:07:32 -0700 (PDT)
Received: from Akatsuki.lan (bzq-109-67-210-71.red.bezeqint.net. [109.67.210.71])
        by smtp.googlemail.com with ESMTPSA id j30sm7949283wrb.66.2019.09.06.04.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 04:07:32 -0700 (PDT)
From:   Dan Elkouby <streetwalkermc@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Dan Elkouby <streetwalkermc@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <computersforpeace@gmail.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Bluetooth: hidp: Fix assumptions on the return value of hidp_send_message
Date:   Fri,  6 Sep 2019 14:06:44 +0300
Message-Id: <20190906110645.27601-1-streetwalkermc@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190906101306.GA12017@kadam>
References: <20190906101306.GA12017@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hidp_send_message was changed to return non-zero values on success,
which some other bits did not expect. This caused spurious errors to be
propagated through the stack, breaking some drivers, such as hid-sony
for the Dualshock 4 in Bluetooth mode.

As pointed out by Dan Carpenter, hid-microsoft directly relied on that
assumption as well.

Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")

Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>
---
 drivers/hid/hid-microsoft.c | 2 +-
 net/bluetooth/hidp/core.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 8b3a922bdad3..2cf83856f2e4 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -303,7 +303,7 @@ static void ms_ff_worker(struct work_struct *work)
 	r->magnitude[MAGNITUDE_WEAK] = ms->weak;     /* right actuator */
 
 	ret = hid_hw_output_report(hdev, (__u8 *)r, sizeof(*r));
-	if (ret)
+	if (ret < 0)
 		hid_warn(hdev, "failed to send FF report\n");
 }
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 8d889969ae7e..bef84b95e2c4 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -267,7 +267,7 @@ static int hidp_get_raw_report(struct hid_device *hid,
 	set_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
 	data[0] = report_number;
 	ret = hidp_send_ctrl_message(session, report_type, data, 1);
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	/* Wait for the return of the report. The returned report
@@ -343,7 +343,7 @@ static int hidp_set_raw_report(struct hid_device *hid, unsigned char reportnum,
 	data[0] = reportnum;
 	set_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags);
 	ret = hidp_send_ctrl_message(session, report_type, data, count);
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	/* Wait for the ACK from the device. */
-- 
2.23.0

