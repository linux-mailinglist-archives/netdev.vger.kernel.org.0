Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5B34096E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhCRP7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231899AbhCRP7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 11:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4B3964E37;
        Thu, 18 Mar 2021 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616083150;
        bh=cPtpmLxQk6MrW0Jspg5ha45X1w9RyfwN+4kw938+F9s=;
        h=From:To:Cc:Subject:Date:From;
        b=AE0nJz+x48+Nl7i9lP4wotJnAnz5XgbTfpCSWFdTfNGfyP1vLyQ72T6FXwPfqtTeo
         asOeHNcfPc+vnrDWK5NnscQJsm4ef0vha7DD7lEmW6LhktWlGalkun8r7P3HtmHCK5
         8BjNp2536d5LqmH4qN6WchHtvU5ZUivUqp/RdrONXgQMTM6hmIqVCsZ4vzv5/hR/JK
         424b8md8ZI8BDmeoz2yUw4Mop/Y3FEL2459bmQVxvaEiuvcWwxbfrWhrHElpsT46dS
         eHvpu05Nu5Yk/SGE0Ak78AwG4X24dk6mFHwIDF0K7jr9j8TZ5nrG1vA4YAZNC4Lv+C
         Xg68Osg5AqLdA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lMv3Y-0008Dn-SZ; Thu, 18 Mar 2021 16:59:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net] net: cdc-phonet: fix data-interface release on probe failure
Date:   Thu, 18 Mar 2021 16:57:49 +0100
Message-Id: <20210318155749.22597-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the disconnected flag before releasing the data interface in case
netdev registration fails to avoid having the disconnect callback try to
deregister the never registered netdev (and trigger a WARN_ON()).

Fixes: 87cf65601e17 ("USB host CDC Phonet network interface driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/cdc-phonet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index 02e6bbb17b15..8d1f69dad603 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -387,6 +387,8 @@ static int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	err = register_netdev(dev);
 	if (err) {
+		/* Set disconnected flag so that disconnect() returns early. */
+		pnd->disconnected = 1;
 		usb_driver_release_interface(&usbpn_driver, data_intf);
 		goto out;
 	}
-- 
2.26.2

