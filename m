Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5FF16B709
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgBYBLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:11:31 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:17780 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728226AbgBYBLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:11:30 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 38BBD400D793D
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 19:11:28 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6OkyjK3hDSl8q6Okyjz5XR; Mon, 24 Feb 2020 19:11:28 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rzMLcS2/ZUpYVpdJI43BRpgzSfEuuyjXrY5HzICY5lU=; b=ZP4B0m1M6tm079nzgpmYt0ILyG
        5Pybfw+yRZIJ15oHp4SO0AwAHczetoTrQ48NxdpDGb6sL/+/GdP9UJ5HQYEDaNT91J4/DHIlPVnyq
        GAZqMVydJBxNvDSVxxWkiKhhtzPnmFdxoQkrIc3/Rj0wPBz4y0zuufu+yCqDA9UYhr/nOEw09VkyJ
        H2Wnpt/2NW10dEU2hH1bBcMb0CinWZAYChiW88tyGTLFYTof+Kyfy92pbzJBB1dkYI9IZIUlYDntt
        7YtgeVjuUbU0Jlg6798SX21xl+tSImTvq6oTVXnhwVLVgMjYxM+YPozm0IbjOXf93w0O9UReeVO09
        0PBXnLSA==;
Received: from [201.166.191.54] (port=58506 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Okw-002sYf-D4; Mon, 24 Feb 2020 19:11:26 -0600
Date:   Mon, 24 Feb 2020 19:14:15 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] orinoco: Replace zero-length array with flexible-array
 member
Message-ID: <20200225011415.GA31868@embeddedor>
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
X-Source-IP: 201.166.191.54
X-Source-L: No
X-Exim-ID: 1j6Okw-002sYf-D4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.54]:58506
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
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
 drivers/net/wireless/intersil/orinoco/fw.c          | 2 +-
 drivers/net/wireless/intersil/orinoco/hermes.h      | 2 +-
 drivers/net/wireless/intersil/orinoco/hermes_dld.c  | 6 +++---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/fw.c b/drivers/net/wireless/intersil/orinoco/fw.c
index 400a35217644..015af782881b 100644
--- a/drivers/net/wireless/intersil/orinoco/fw.c
+++ b/drivers/net/wireless/intersil/orinoco/fw.c
@@ -49,7 +49,7 @@ struct orinoco_fw_header {
 	__le32 pdr_offset;      /* Offset to PDR data from eof header */
 	__le32 pri_offset;      /* Offset to primary plug data */
 	__le32 compat_offset;   /* Offset to compatibility data*/
-	char signature[0];      /* FW signature length headersize-20 */
+	char signature[];      /* FW signature length headersize-20 */
 } __packed;
 
 /* Check the range of various header entries. Return a pointer to a
diff --git a/drivers/net/wireless/intersil/orinoco/hermes.h b/drivers/net/wireless/intersil/orinoco/hermes.h
index 121fdd8e5da2..9f668185b7d2 100644
--- a/drivers/net/wireless/intersil/orinoco/hermes.h
+++ b/drivers/net/wireless/intersil/orinoco/hermes.h
@@ -341,7 +341,7 @@ struct agere_ext_scan_info {
 	__le64	timestamp;
 	__le16	beacon_interval;
 	__le16	capabilities;
-	u8	data[0];
+	u8	data[];
 } __packed;
 
 #define HERMES_LINKSTATUS_NOT_CONNECTED   (0x0000)
diff --git a/drivers/net/wireless/intersil/orinoco/hermes_dld.c b/drivers/net/wireless/intersil/orinoco/hermes_dld.c
index 4a10b7aca043..dbeadfcfefe2 100644
--- a/drivers/net/wireless/intersil/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/intersil/orinoco/hermes_dld.c
@@ -64,7 +64,7 @@
 struct dblock {
 	__le32 addr;		/* adapter address where to write the block */
 	__le16 len;		/* length of the data only, in bytes */
-	char data[0];		/* data to be written */
+	char data[];		/* data to be written */
 } __packed;
 
 /*
@@ -76,7 +76,7 @@ struct pdr {
 	__le32 id;		/* record ID */
 	__le32 addr;		/* adapter address where to write the data */
 	__le32 len;		/* expected length of the data, in bytes */
-	char next[0];		/* next PDR starts here */
+	char next[];		/* next PDR starts here */
 } __packed;
 
 /*
@@ -87,7 +87,7 @@ struct pdr {
 struct pdi {
 	__le16 len;		/* length of ID and data, in words */
 	__le16 id;		/* record ID */
-	char data[0];		/* plug data */
+	char data[];		/* plug data */
 } __packed;
 
 /*** FW data block access functions ***/
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index e753f43e0162..a77bbcd544d6 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -202,7 +202,7 @@ struct ezusb_packet {
 	__le16 crc;		/* CRC up to here */
 	__le16 hermes_len;
 	__le16 hermes_rid;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /* Table of devices that work or may work with this driver */
-- 
2.25.0

