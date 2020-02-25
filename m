Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0064216B710
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgBYBP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:15:59 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.233]:12998 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727378AbgBYBP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:15:59 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id AD2D74FBD
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 19:15:58 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6OpKjceJs8vkB6OpKjY7ab; Mon, 24 Feb 2020 19:15:58 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4ZONqfZvH7bzk4RzAb0rhx7k0LPOnWZiXRSfaQxFDBc=; b=rRHmkRv/WmAQmtIfWH7msi9NHT
        OqplrG0gmw9jc2UZ+x8LIjVmS47bsh2MoWkfZcKonbouD/JaETlw3nLPM+9ABOt0tvKY1tjtA+m57
        ejY/3fzfaL6jwHC6J4IcENu730Jfqn3It2ANgJ6e9pbb5P4mT3UZ7p94PUCfwlREAM3xemY+/TUSo
        htV8OMk0n3tq1aEWdRiCRfC6QIKKrOPS4f694N4BGCbKKpRh6Q0Vay/u0540bGGo8MSJylTSOh/63
        2HQERzqYCSN8eArMln55wR8yRiPryN4VkafHbmEWbdGzswR4UUDgLO6nySrdmFQeZwMcpGmeqhoxV
        FzGxKM9w==;
Received: from [201.166.191.27] (port=58584 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6OpI-002uUc-U7; Mon, 24 Feb 2020 19:15:57 -0600
Date:   Mon, 24 Feb 2020 19:18:46 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] p54: Replace zero-length array with flexible-array
 member
Message-ID: <20200225011846.GA2773@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.191.27
X-Source-L: No
X-Exim-ID: 1j6OpI-002uUc-U7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.27]:58584
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 22
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intersil/p54/eeprom.h | 8 ++++----
 drivers/net/wireless/intersil/p54/lmac.h   | 6 +++---
 drivers/net/wireless/intersil/p54/p54.h    | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.h b/drivers/net/wireless/intersil/p54/eeprom.h
index b8f46883a292..1d0aaf54389a 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.h
+++ b/drivers/net/wireless/intersil/p54/eeprom.h
@@ -24,7 +24,7 @@
 struct pda_entry {
 	__le16 len;	/* includes both code and data */
 	__le16 code;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct eeprom_pda_wrap {
@@ -32,7 +32,7 @@ struct eeprom_pda_wrap {
 	__le16 pad;
 	__le16 len;
 	__le32 arm_opcode;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct p54_iq_autocal_entry {
@@ -87,7 +87,7 @@ struct pda_pa_curve_data {
 	u8 channels;
 	u8 points_per_channel;
 	u8 padding;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct pda_rssi_cal_ext_entry {
@@ -119,7 +119,7 @@ struct pda_custom_wrapper {
 	__le16 entry_size;
 	__le16 offset;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/intersil/p54/lmac.h b/drivers/net/wireless/intersil/p54/lmac.h
index e00761536cfc..8adde6ba35ab 100644
--- a/drivers/net/wireless/intersil/p54/lmac.h
+++ b/drivers/net/wireless/intersil/p54/lmac.h
@@ -81,7 +81,7 @@ struct p54_hdr {
 	__le16 type;	/* enum p54_control_frame_types */
 	u8 rts_tries;
 	u8 tries;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define GET_REQ_ID(skb)							\
@@ -176,7 +176,7 @@ struct p54_rx_data {
 	u8 rssi_raw;
 	__le32 tsf32;
 	__le32 unalloc0;
-	u8 align[0];
+	u8 align[];
 } __packed;
 
 enum p54_trap_type {
@@ -267,7 +267,7 @@ struct p54_tx_data {
 		} __packed normal;
 	} __packed;
 	u8 unalloc2[2];
-	u8 align[0];
+	u8 align[];
 } __packed;
 
 /* unit is ms */
diff --git a/drivers/net/wireless/intersil/p54/p54.h b/drivers/net/wireless/intersil/p54/p54.h
index 0a9c1a19380f..3356ea708d81 100644
--- a/drivers/net/wireless/intersil/p54/p54.h
+++ b/drivers/net/wireless/intersil/p54/p54.h
@@ -126,7 +126,7 @@ struct p54_cal_database {
 	size_t entry_size;
 	size_t offset;
 	size_t len;
-	u8 data[0];
+	u8 data[];
 };
 
 #define EEPROM_READBACK_LEN 0x3fc
-- 
2.25.0

