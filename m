Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B1417A451
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCELfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:35:02 -0500
Received: from gateway20.websitewelcome.com ([192.185.64.36]:25037 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgCELfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:35:02 -0500
X-Greylist: delayed 1444 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 06:35:01 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 6A6AC400D3D91
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 03:56:13 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 9oP3joiWWRP4z9oP3jC3pF; Thu, 05 Mar 2020 05:10:57 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/PmmIcka33M6DCpffXgPTbzuHdS7VrmxxyOXeOtKOCc=; b=BEr2mtWCniGS2h7uzC5+yZXgzV
        CYD7FwHzciKYdIXJhAIuibexDfR3Fx5/fqoCunXL2mGYlkodttzp3B2D6tqtJvXP8TkiUVb/L4wTF
        MxRckg1ebX5hOVhLYGS+YM+drBjKAYq/sJFcInsKn8OHwefe3227uKWiL6kXNS9P6f1jBeulfC+7I
        ebXryUGcRQsBer2ejFkY+MWxbxthshurmq4XB1QS5MucVjILwqnj2Ph3D18C0uhXJOA+svFSPK8d2
        J2W/71Ib1TzEJhC96th7OuZeFqXOUuna/FmIMpg8h6+5ufcRFFjiEn/YLKlndsob7K9CND2RGuowq
        wKJGFleg==;
Received: from [201.166.169.220] (port=24188 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j9oP1-003r7m-BW; Thu, 05 Mar 2020 05:10:55 -0600
Date:   Thu, 5 Mar 2020 05:14:01 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cw1200/wsm.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200305111401.GA25126@embeddedor>
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
X-Source-IP: 201.166.169.220
X-Source-L: No
X-Exim-ID: 1j9oP1-003r7m-BW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.169.220]:24188
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
 drivers/net/wireless/st/cw1200/wsm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/wsm.h b/drivers/net/wireless/st/cw1200/wsm.h
index ddea57f8c8ab..1ffa47994bb9 100644
--- a/drivers/net/wireless/st/cw1200/wsm.h
+++ b/drivers/net/wireless/st/cw1200/wsm.h
@@ -1623,7 +1623,7 @@ struct wsm_p2p_device_info {
 	u8 local_devname[D11_MAX_SSID_LEN];
 	u8 reserved2[3];
 	u8 num_secdev_supported;
-	struct wsm_p2p_device_type secdevs[0];
+	struct wsm_p2p_device_type secdevs[];
 } __packed;
 
 /* 4.36 SetWCDMABand - WO */
-- 
2.25.0

