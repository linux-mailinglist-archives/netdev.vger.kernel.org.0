Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A81186E1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfLJLoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:54 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37418 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfLJLot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id u17so19512504lja.4;
        Tue, 10 Dec 2019 03:44:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVv+98+Q/wUUkUyC3i7eT9Xaj/qNxPXqvi+D40LBxA8=;
        b=AT516+M1D0z38nsihUQaSLomQPXc7jErJf1yTvIh7l1jB3NGdeLF+f5TO7+vhAno/t
         AgLWcVqM2Pb4+ltOXx/s6I9mpcaLJsLgu1ES7eG1mYFZ0YIdYo9jSxGKpLZTmWEh1qVq
         hVJYlK4CGfgsK073vpNc/Jp6sWCXVGV9meXsEidAC2V/23dZOj/5xRXhXQUYw/54I/N9
         X6dkxDZQtVs4pMkP90FOsqa5e0eeeB2bkMsE+8VgClVeRm5RVPyj9eGEz4m+mO5kUwmG
         U36PedmtIxZLJCAC+nmqgrZbP5c0kg03Nap2MCbrpDiJ3LTCPU8R4Zv3vLT336S7OLKN
         lIyQ==
X-Gm-Message-State: APjAAAWrTyXnc0S7MhZ/Tu9pPZ+ssPEoGch+eOXV2MN2mbFZse6aU6AD
        M0X1nxd9VYMg1ShGP55x1m0=
X-Google-Smtp-Source: APXvYqzNFa+fn53W1Aqp5M1Cpv1wJ6sddSRmDkbQiSSYG/sew6XIoKADsYtUfOLhzdKYpYDnENl+pw==
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr20770639lja.16.1575978287183;
        Tue, 10 Dec 2019 03:44:47 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id q10sm1583883ljj.60.2019.12.10.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001ID-QQ; Tue, 10 Dec 2019 12:44:44 +0100
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
        stable <stable@vger.kernel.org>,
        Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 6/7] rsi_91x_usb: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:44:25 +0100
Message-Id: <20191210114426.4713-7-johan@kernel.org>
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

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable <stable@vger.kernel.org>     # 3.15
Cc: Fariya Fatima <fariyaf@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index a37a436df5fb..c3ba38ed0dd0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -117,7 +117,7 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 	__le16 buffer_size;
 	int ii, bin_found = 0, bout_found = 0;
 
-	iface_desc = &(interface->altsetting[0]);
+	iface_desc = interface->cur_altsetting;
 
 	for (ii = 0; ii < iface_desc->desc.bNumEndpoints; ++ii) {
 		endpoint = &(iface_desc->endpoint[ii].desc);
-- 
2.24.0

