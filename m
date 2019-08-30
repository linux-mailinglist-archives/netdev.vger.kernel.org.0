Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBFCA3366
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfH3JJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:09:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47291 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfH3JJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 05:09:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i3csC-0003NG-1k; Fri, 30 Aug 2019 09:07:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] wimax/i2400m: remove debug containing bogus calculation of index
Date:   Fri, 30 Aug 2019 10:07:11 +0100
Message-Id: <20190830090711.15300-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The subtraction of the two pointers is automatically scaled by the
size of the size of the object the pointers point to, so the division
by sizeof(*i2400m->barker) is incorrect.  This has been broken since
day one of the driver and is only debug, so remove the debug completely.

Also move && in condition to clean up a checkpatch warning.

Addresses-Coverity: ("Extra sizeof expression")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: completely remove debug, clean up checkpatch warning, change subject line

---
 drivers/net/wimax/i2400m/fw.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 489cba9b284d..6c9a41bff2e0 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -397,14 +397,9 @@ int i2400m_is_boot_barker(struct i2400m *i2400m,
 
 	/* Short circuit if we have already discovered the barker
 	 * associated with the device. */
-	if (i2400m->barker
-	    && !memcmp(buf, i2400m->barker, sizeof(i2400m->barker->data))) {
-		unsigned index = (i2400m->barker - i2400m_barker_db)
-			/ sizeof(*i2400m->barker);
-		d_printf(2, dev, "boot barker cache-confirmed #%u/%08x\n",
-			 index, le32_to_cpu(i2400m->barker->data[0]));
+	if (i2400m->barker &&
+	    !memcmp(buf, i2400m->barker, sizeof(i2400m->barker->data)))
 		return 0;
-	}
 
 	for (i = 0; i < i2400m_barker_db_used; i++) {
 		barker = &i2400m_barker_db[i];
-- 
2.20.1

