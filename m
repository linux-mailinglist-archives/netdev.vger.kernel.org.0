Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD2B3F1905
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbhHSMRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:17:30 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:36268
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238357AbhHSMR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:17:29 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5676440C9E;
        Thu, 19 Aug 2021 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629375411;
        bh=jsGWeGecQ1kWffqrQvCeBJMCWUwwxyDVLr5Pq+OBIQA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=qP8naA+8cHCYt7YbKmUmxvC6slgIAPThy+wi0iVhtyAfdCqx9ER7XSNn07hEcq/cK
         vfRm4ryOD58AaJU5bZrlnwXHOFqSsKT3H10wOxYI/I5OEE9B8rNjX6RGJwPVgFYbcw
         Q5QHbslXwLOWR7v0DzgAZ+izOq5w62VNEaPSWP3H6Hg9RPJvvpXs+FNniIo/iGwfVg
         KqphZBwMoKpjLR4gRaXdCukhRXULbIcSfzAkSCt3DfyvBslVHN5qklx/WHUYPNDOUs
         Y4rWP15bLPnpJSWcxlxIoZJrkwAJBxHzu4WQ3KBUdVzqgRs8/bfcSKMVvNgOEiOUlh
         aBhFM03CDAIdg==
From:   Colin King <colin.king@canonical.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: make arrays static const, makes object smaller
Date:   Thu, 19 Aug 2021 13:16:51 +0100
Message-Id: <20210819121651.7566-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the arrays wpa_oui and wps_oui on the stack but
instead them static const. Makes the object code smaller by 63 bytes:

Before:
   text   data  bss     dec    hex filename
  29453   5451   64   34968   8898 .../wireless/marvell/mwifiex/sta_ioctl.o

After:
   text	  data  bss     dec    hex filename
  29356	  5611   64   35031   88d7 ../wireless/marvell/mwifiex/sta_ioctl.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 653f9e094256..fb3b11cf123b 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1325,8 +1325,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 			  u16 ie_len)
 {
 	struct ieee_types_vendor_header *pvendor_ie;
-	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
-	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
+	static const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
+	static const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
 	u16 unparsed_len = ie_len, cur_ie_len;
 
 	/* If the passed length is zero, reset the buffer */
-- 
2.32.0

