Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06B316B70C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgBYBOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:14:24 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.233]:39612 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727378AbgBYBOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:14:23 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id DC419145B
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 19:14:21 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6OnljF1QeEfyq6OnljLJUt; Mon, 24 Feb 2020 19:14:21 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mgdZsrA1WaP1VFkgXWleWTQSkyBW12WU43wlKGK1Mek=; b=MzQWfuTDQ8qn/8fc6G5HG31Hqj
        a3i4dkHukioCThB0n3AGbMFj6r5SKwNVG0mCcHBMWzS7XHpnlC/6HLl7vz7TAusR8acrIilDNYiu+
        Jl7joiIHUEDok6C0JdOX0m0tKetJG7QpsqErmrAPk3yJweMpv8KgzgCRyC16dGbB3nV8eBBfSvjpU
        LElPIek4Q0kEWLlh69NpxpRruq/EMvPeDfbcf0DgJA99IDJvb35E5x3fFEEbsOPnKywdwUNnQx8wi
        jSk3kb1QY3JJ7pd1n9CY7u2h5hTFiQBfWXg44T4kZ9AQYwcLWBtePmrKKwi0hU7lIdlpPdBXJN6kc
        W+zf4xeQ==;
Received: from [201.166.190.58] (port=58548 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Onk-002tqM-5a; Mon, 24 Feb 2020 19:14:20 -0600
Date:   Mon, 24 Feb 2020 19:17:09 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] libertas: Replace zero-length array with
 flexible-array member
Message-ID: <20200225011709.GA601@embeddedor>
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
X-Source-IP: 201.166.190.58
X-Source-L: No
X-Exim-ID: 1j6Onk-002tqM-5a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.190.58]:58548
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
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
 drivers/net/wireless/marvell/libertas/host.h    | 4 ++--
 drivers/net/wireless/marvell/libertas/if_sdio.c | 2 +-
 drivers/net/wireless/marvell/libertas/if_spi.c  | 2 +-
 drivers/net/wireless/marvell/libertas/if_usb.h  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/host.h b/drivers/net/wireless/marvell/libertas/host.h
index a4fc3f79bb17..dfa22468b14a 100644
--- a/drivers/net/wireless/marvell/libertas/host.h
+++ b/drivers/net/wireless/marvell/libertas/host.h
@@ -461,7 +461,7 @@ struct cmd_ds_802_11_scan {
 
 	uint8_t bsstype;
 	uint8_t bssid[ETH_ALEN];
-	uint8_t tlvbuffer[0];
+	uint8_t tlvbuffer[];
 } __packed;
 
 struct cmd_ds_802_11_scan_rsp {
@@ -469,7 +469,7 @@ struct cmd_ds_802_11_scan_rsp {
 
 	__le16 bssdescriptsize;
 	uint8_t nr_sets;
-	uint8_t bssdesc_and_tlvbuffer[0];
+	uint8_t bssdesc_and_tlvbuffer[];
 } __packed;
 
 struct cmd_ds_802_11_get_log {
diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 30f1025ecb9b..acf61b93b782 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -103,7 +103,7 @@ MODULE_FIRMWARE("sd8688.bin");
 struct if_sdio_packet {
 	struct if_sdio_packet	*next;
 	u16			nb;
-	u8			buffer[0] __attribute__((aligned(4)));
+	u8			buffer[] __aligned(4);
 };
 
 struct if_sdio_card {
diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
index d07fe82c557e..3625baa66d3e 100644
--- a/drivers/net/wireless/marvell/libertas/if_spi.c
+++ b/drivers/net/wireless/marvell/libertas/if_spi.c
@@ -35,7 +35,7 @@
 struct if_spi_packet {
 	struct list_head		list;
 	u16				blen;
-	u8				buffer[0] __attribute__((aligned(4)));
+	u8				buffer[] __aligned(4);
 };
 
 struct if_spi_card {
diff --git a/drivers/net/wireless/marvell/libertas/if_usb.h b/drivers/net/wireless/marvell/libertas/if_usb.h
index 8dc14bec3e16..7d0daeb33c3f 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.h
+++ b/drivers/net/wireless/marvell/libertas/if_usb.h
@@ -91,7 +91,7 @@ struct fwheader {
 struct fwdata {
 	struct fwheader hdr;
 	__le32 seqnum;
-	uint8_t data[0];
+	uint8_t data[];
 };
 
 /* fwsyncheader */
-- 
2.25.0

