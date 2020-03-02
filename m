Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B3175A58
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCBMUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:20:51 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.79]:45296 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgCBMUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:20:51 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 0111428A09
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 06:20:07 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8k3Kjz9EBEfyq8k3Kj3jZx; Mon, 02 Mar 2020 06:20:06 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LzPJ/4uvjh/hNTol+mYUIodA/9OpKpqV2PAXxF3nbT0=; b=rtImn0oMt1FNc1RKrglfJoSYbX
        ItmzVSPy3kMLLOP7VGbn0W/KpNEz4y8QDPGhFm0zl4awyXhCXyIYjwvQ8j9ZhCT952qCsVfK6cW1G
        Ics4BQiwBxmb97rpkclGpczXvUfo4ZZ/Dykp26y9RplkObJN4p1iUVG/SQJf8chRXITJCz1Xjp6sC
        vdBDDbpPLLUciwZxsckcmrVkt+WMyZjqT0ttsLJzCfAr/iyOWJIsSmKX6lJGr5P7vbPc9TmxdZW+c
        OeSVTRDZrGGYaifbvRW2aFLP0q770wZYhcgaDpkilM8oEU6iF9wcpkviJCmijUZFWoD58a1sjlV+u
        CmesmJoQ==;
Received: from [200.39.29.128] (port=42554 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8k3J-0046va-1u; Mon, 02 Mar 2020 06:20:05 -0600
Date:   Mon, 2 Mar 2020 06:23:05 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] r8152: Replace zero-length array with flexible-array
 member
Message-ID: <20200302122305.GA1200@embeddedor>
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
X-Source-IP: 200.39.29.128
X-Source-L: No
X-Exim-ID: 1j8k3J-0046va-1u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.29.128]:42554
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 28
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
 drivers/net/usb/r8152.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index feedc0f964d8..9adfa2bbf593 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -891,7 +891,7 @@ struct fw_block {
 struct fw_header {
 	u8 checksum[32];
 	char version[RTL_VER_SIZE];
-	struct fw_block blocks[0];
+	struct fw_block blocks[];
 } __packed;
 
 /**
@@ -930,7 +930,7 @@ struct fw_mac {
 	__le32 reserved;
 	__le16 fw_ver_reg;
 	u8 fw_ver_data;
-	char info[0];
+	char info[];
 } __packed;
 
 /**
@@ -982,7 +982,7 @@ struct fw_phy_nc {
 	__le16 bp_start;
 	__le16 bp_num;
 	__le16 bp[4];
-	char info[0];
+	char info[];
 } __packed;
 
 enum rtl_fw_type {
-- 
2.25.0

