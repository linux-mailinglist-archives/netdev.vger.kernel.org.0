Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FA2CC381
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389201AbgLBRXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:23:07 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:51084 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389091AbgLBRXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:23:06 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 129DC44048F;
        Wed,  2 Dec 2020 19:22:23 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH ethtool v2] Improve error message when SFP module is missing
Date:   Wed,  2 Dec 2020 19:22:14 +0200
Message-Id: <19fb6da036b04a465398f5b053b029ea04179aba.1606929734.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_GMODULEINFO request success indicates that SFP cage is present.
Failure of ETHTOOL_GMODULEEEPROM is most likely because SFP module is
not plugged in. Add an indication to the user as to what might be the
reason for the failure.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Limit message to likely errno values (Andrew Lunn)
---
 ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 1d9067e774af..63b3a095eded 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4855,7 +4855,11 @@ static int do_getmodule(struct cmd_context *ctx)
 	eeprom->offset = geeprom_offset;
 	err = send_ioctl(ctx, eeprom);
 	if (err < 0) {
+		int saved_errno = errno;
 		perror("Cannot get Module EEPROM data");
+		if (saved_errno == ENODEV || saved_errno == EIO ||
+				saved_errno == ENXIO)
+			fprintf(stderr, "SFP module not in cage?\n");
 		free(eeprom);
 		return 1;
 	}
-- 
2.29.2

