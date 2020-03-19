Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E4C18C348
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbgCSWuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:50:08 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.144]:13871 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbgCSWuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:50:07 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id CAF2B5F13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:50:05 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id F3zJjStEPVQh0F3zJjhsCF; Thu, 19 Mar 2020 17:50:05 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4Xd+EIBGjgt1E9Uzt3IjK5xIRtMxS0VYzjqJP+T0LYM=; b=YBipCxykX/IiHi/cgcXtsqkRk+
        ZGg4jc2IUE2YxUFcmN3D4xCFwIouZ6Wx6ybO0esEjs9I6mG6s7IGDs/Am0pePypEu/qj+RWKFk0aD
        dSAQ4pDYNSNCTAsKOa3T2f2buxhpu2H4fE+J0n5Qj5OwWzZEuoUcCCvjAK91h2Vv2p8ZbeNp0ibnN
        G5H+jghapW8fHdekXHS6r+TCOeKdZp8Uf0a7Wx67YmNSuoEuM5KiVEC7twmstj5zckMrYgG+9J0he
        b7LcfRj7zxoHsemPgGKdNiI+mdScvJz3y6gKnkvH8HrGEvdkRT2FG3++qru5VQqW/y1nIoe+alfbt
        FVvlMrBw==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:53990 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jF3zI-002Gs1-79; Thu, 19 Mar 2020 17:50:04 -0500
Date:   Thu, 19 Mar 2020 17:50:02 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] admtek: adm8211.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200319225002.GA28673@embeddedor.com>
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
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jF3zI-002Gs1-79
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:53990
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 48
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
 drivers/net/wireless/admtek/adm8211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/admtek/adm8211.h b/drivers/net/wireless/admtek/adm8211.h
index 2c55c629de28..095625ecb8ff 100644
--- a/drivers/net/wireless/admtek/adm8211.h
+++ b/drivers/net/wireless/admtek/adm8211.h
@@ -531,7 +531,7 @@ struct adm8211_eeprom {
 	u8	lpf_cutoff[14];		/* 0x62 */
 	u8	lnags_threshold[14];	/* 0x70 */
 	__le16	checksum;		/* 0x7E */
-	u8	cis_data[0];		/* 0x80, 384 bytes */
+	u8	cis_data[];		/* 0x80, 384 bytes */
 } __packed;
 
 struct adm8211_priv {
-- 
2.23.0

