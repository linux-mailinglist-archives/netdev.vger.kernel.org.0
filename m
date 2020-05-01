Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93931C1BFC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgEARjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:39:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38787 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgEARjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:39:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jUZcr-0004Ox-2y; Fri, 01 May 2020 17:39:01 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas_tf: avoid a null dereference in pointer priv
Date:   Fri,  1 May 2020 18:39:00 +0100
Message-Id: <20200501173900.296658-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently there is a check if priv is null when calling lbtf_remove_card
but not in a previous call to if_usb_reset_dev that can also dereference
priv.  Fix this by also only calling lbtf_remove_card if priv is null.

It is noteable that there don't seem to be any bugs reported that the
null pointer dereference has ever occurred, so I'm not sure if the null
check is required, but since we're doing a null check anyway it should
be done for both function calls.

Addresses-Coverity: ("Dereference before null check")
Fixes: baa0280f08c7 ("libertas_tf: don't defer firmware loading until start()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index 25ac9db35dbf..bedc09215088 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -247,10 +247,10 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
-	if_usb_reset_device(priv);
-
-	if (priv)
+	if (priv) {
+		if_usb_reset_device(priv);
 		lbtf_remove_card(priv);
+	}
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
-- 
2.25.1

