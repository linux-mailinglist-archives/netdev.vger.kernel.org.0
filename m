Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AEB1186EA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfLJLpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:45:22 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37414 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfLJLos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:48 -0500
Received: by mail-lj1-f196.google.com with SMTP id u17so19512419lja.4;
        Tue, 10 Dec 2019 03:44:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HPkUmO3G/A16rgtcZUNme6uiy2GoRkfbpmQRAn7AWJ8=;
        b=dQ7Oj5c8M+t5mw86y+GO8Lr4JA3roQ3I7gCesNcM68pUbkL/1Ivcjrfgy2tqdr6R9b
         w0B8SPVw3NTaqd+WqyCE8GeWApB8wIMqyCEsT1rElFPlHGgdBSyIKAOLRT9fpK6Yp7mQ
         oJK6eSS4Rvrf+Tv0ZSdEF4Ps07cllspTiK1d/Q56QeGtx63YZWOLue5R79VPicj62OP3
         9FK7TEzrkgURvNmKD7a2D6wKcabk1GWB7ahqo/Xc8KgFdzyyRmvPVGhxKOrlQcnS07Ct
         o1GqN75JIbGRHr+4oYVgp60wJxBYybThamnJ4AfbdlNfMxt846Xef68HHIBh77qr6B7G
         i6nA==
X-Gm-Message-State: APjAAAXYrJszBQuX9y92iUTMUGyKNMR9C6Eq973VgkrhdDSV8mrH1cSQ
        kFBcrduS83DaQO6qc0VwTOE=
X-Google-Smtp-Source: APXvYqx0tCPUjbLt1rFx+WirJ499EdZwAdGnhgcl5nl1/qoH4tw61ZDHmQb2+1PkIRQexzMBKal9HA==
X-Received: by 2002:a2e:9a11:: with SMTP id o17mr19813944lji.256.1575978285896;
        Tue, 10 Dec 2019 03:44:45 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n19sm1361305lfl.85.2019.12.10.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001I2-Kf; Tue, 10 Dec 2019 12:44:44 +0100
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
Subject: [PATCH 4/7] orinoco_usb: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:44:23 +0100
Message-Id: <20191210114426.4713-5-johan@kernel.org>
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

Fixes: 9afac70a7305 ("orinoco: add orinoco_usb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 40a8b941ad5c..8c79b963bcff 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1608,9 +1608,9 @@ static int ezusb_probe(struct usb_interface *interface,
 	/* set up the endpoint information */
 	/* check out the endpoints */
 
-	iface_desc = &interface->altsetting[0].desc;
+	iface_desc = &interface->cur_altsetting->desc;
 	for (i = 0; i < iface_desc->bNumEndpoints; ++i) {
-		ep = &interface->altsetting[0].endpoint[i].desc;
+		ep = &interface->cur_altsetting->endpoint[i].desc;
 
 		if (usb_endpoint_is_bulk_in(ep)) {
 			/* we found a bulk in endpoint */
-- 
2.24.0

