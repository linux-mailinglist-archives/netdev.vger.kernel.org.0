Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407A21C9498
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEGPO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgEGPO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:14:56 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FEBE207DD;
        Thu,  7 May 2020 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588864496;
        bh=nH4zzLyFJaaR6EBGr6MwECFJ0OIX3tGLz6Ht3UbWkZM=;
        h=Date:From:To:Cc:Subject:From;
        b=P/qI5XcxnpOU2JlzciA5QWZCZGmLZfddp8qb5bxXx45rDzjJdI2SqlGqYARDzuB84
         TnO5gSmseGqu/btra6/WZaf7T3sS1E1uKVzKPJOzReH3MiUYqUUkXonvPEgfpQzHoh
         1Zn0pmhSYAXfa6as0z/2b2XL/DF+K29mcfG4Pofo=
Date:   Thu, 7 May 2020 10:19:21 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] carl9170: Replace zero-length array with flexible-array
Message-ID: <20200507151921.GA5083@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
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

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h | 2 +-
 drivers/net/wireless/ath/carl9170/hw.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index ea1d80f9a50e..56999a3b9d3b 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -127,7 +127,7 @@ struct carl9170_write_reg {
 struct carl9170_write_reg_byte {
 	__le32	addr;
 	__le32  count;
-	u8	val[0];
+	u8	val[];
 } __packed;
 
 #define	CARL9170FW_PHY_HT_ENABLE		0x4
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 08e0ae9c5836..555ad4975970 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -851,7 +851,7 @@ struct ar9170_stream {
 	__le16 length;
 	__le16 tag;
 
-	u8 payload[0];
+	u8 payload[];
 } __packed __aligned(4);
 #define AR9170_STREAM_LEN				4
 
-- 
2.26.2

