Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B41444974
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhKCUU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:20:58 -0400
Received: from mout-p-101.mailbox.org ([80.241.56.151]:30018 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhKCUU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:20:56 -0400
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Hkykx1D5bzQk1x;
        Wed,  3 Nov 2021 21:18:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH v4 3/3] mwifiex: Ensure the version string from the firmware is 0-terminated
Date:   Wed,  3 Nov 2021 21:18:00 +0100
Message-Id: <20211103201800.13531-4-verdre@v0yd.nl>
In-Reply-To: <20211103201800.13531-1-verdre@v0yd.nl>
References: <20211103201800.13531-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0550FC0A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume at a few places that priv->version_str is 0-terminated, but
right now we trust the firmware that this is the case with the version
string we get from it.

Let's rather ensure this ourselves and replace the last character with
'\0'.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 6c7b0b9bc4e9..1a4ae8a42a31 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -734,6 +734,9 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 		       MWIFIEX_VERSION_STR_LENGTH);
 		memcpy(priv->version_str, ver_ext->version_str,
 		       MWIFIEX_VERSION_STR_LENGTH);
+
+		/* Ensure the version string from the firmware is 0-terminated */
+		priv->version_str[MWIFIEX_VERSION_STR_LENGTH - 1] = '\0';
 	}
 	return 0;
 }
-- 
2.33.1

