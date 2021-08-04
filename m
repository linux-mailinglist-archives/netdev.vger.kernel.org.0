Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA483E03EA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhHDPKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:10:06 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34162
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237114AbhHDPKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:10:05 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 57B383F04E;
        Wed,  4 Aug 2021 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628089791;
        bh=jOI1MaghgNGcJtSRSTB8GoNttvxl2jIpyug9Cz3oOHk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=OW2kjVqQSto9Eac4j2zLDVIwwEpXPBKYDJSMWMQnZsOuUGaBNVLmswCLD+TtIBPRv
         Blq5wbKCOfQxL3C/hNcXCRs/6Xc41PCoihgbypXZorXxpoNrxzXxi48LEGcAfa6V5w
         Qs7+jFds+9sp3HTrJODcrYqvcjo56xAd1e+AJzmRWpajhi7O0A+FWRVDZ0QSlcnNcD
         EOPQbbvUXMSo0zNCOQNT6p03383iNgkfl+yohdzEgP4kX7dSyhtNOrBlHh7pcahCbP
         sMPhNzKrkjpHjCnEGvw8GWjWBTZtoGlz2pkSKxB78QTkTMZh2bI3NqpwfZGT79U0MM
         NH0v38Ywy3DFQ==
From:   Colin King <colin.king@canonical.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow
Date:   Wed,  4 Aug 2021 16:09:51 +0100
Message-Id: <20210804150951.116814-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An earlier commit replaced using batostr to using %pMR sprintf for the
construction of session->name. Static analysis detected that this new
method can use a total of 21 characters (including the trailing '\0')
so we need to increase the BTNAMSIZ from 18 to 21 to fix potential
buffer overflows.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: fcb73338ed53 ("Bluetooth: Use %pMR in sprintf/seq_printf instead of batostr")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bluetooth/cmtp/cmtp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/cmtp/cmtp.h b/net/bluetooth/cmtp/cmtp.h
index c32638dddbf9..f6b9dc4e408f 100644
--- a/net/bluetooth/cmtp/cmtp.h
+++ b/net/bluetooth/cmtp/cmtp.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
-#define BTNAMSIZ 18
+#define BTNAMSIZ 21
 
 /* CMTP ioctl defines */
 #define CMTPCONNADD	_IOW('C', 200, int)
-- 
2.31.1

