Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2E2998D4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbgJZVch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388551AbgJZVcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:32:36 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C88207C4;
        Mon, 26 Oct 2020 21:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603747956;
        bh=AYFF8wOTE/l1Y0U8+xS1E8od0GtWTnJ/ot3/H3wuly4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ur+XPMXlCWlMQZkQUXLiw5jwkWdNam2110mP+AJKo0ok08Joxkr8bwHgn0SaKEKPj
         VU3lnCzrHaAdi5MJdjLmqB+LL5tYL0cE3DVbBiIdG7puRQTeOKTzYhd4tQAaB62Wvk
         NnRNfFP04m2fzb5EWt0dT85M/v2NWETQdfw3QjXQ=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Wang Hai <wanghai38@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/11] wimax/i2400m/control: fix enum warning
Date:   Mon, 26 Oct 2020 22:29:52 +0100
Message-Id: <20201026213040.3889546-5-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra warns about mixing two enum types:

drivers/net/wimax/i2400m/control.c: In function 'i2400m_get_device_info':
drivers/net/wimax/i2400m/control.c:960:10: warning: implicit conversion from 'enum <anonymous>' to 'enum i2400m_tlv' [-Wenum-conversion]

Merge the anonymous enum into the global one that has all the other
values. It's not clear why they were originally kept separate, but this
appears to be the logical place for it.

Fixes: 3a35a1d0bdf7 ("i2400m: various functions for device management")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wimax/i2400m/control.c | 7 -------
 include/uapi/linux/wimax/i2400m.h  | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wimax/i2400m/control.c b/drivers/net/wimax/i2400m/control.c
index 8df98757d901..180d5f417bdc 100644
--- a/drivers/net/wimax/i2400m/control.c
+++ b/drivers/net/wimax/i2400m/control.c
@@ -903,13 +903,6 @@ int i2400m_cmd_enter_powersave(struct i2400m *i2400m)
 EXPORT_SYMBOL_GPL(i2400m_cmd_enter_powersave);
 
 
-/*
- * Definitions for getting device information
- */
-enum {
-	I2400M_TLV_DETAILED_DEVICE_INFO = 140
-};
-
 /**
  * i2400m_get_device_info - Query the device for detailed device information
  *
diff --git a/include/uapi/linux/wimax/i2400m.h b/include/uapi/linux/wimax/i2400m.h
index fd198bc24a3c..595ab3511d45 100644
--- a/include/uapi/linux/wimax/i2400m.h
+++ b/include/uapi/linux/wimax/i2400m.h
@@ -409,6 +409,7 @@ enum i2400m_ms {
  */
 enum i2400m_tlv {
 	I2400M_TLV_L4_MESSAGE_VERSIONS = 129,
+	I2400M_TLV_DETAILED_DEVICE_INFO = 140,
 	I2400M_TLV_SYSTEM_STATE = 141,
 	I2400M_TLV_MEDIA_STATUS = 161,
 	I2400M_TLV_RF_OPERATION = 162,
-- 
2.27.0

