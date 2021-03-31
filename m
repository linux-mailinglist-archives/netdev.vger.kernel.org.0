Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A646350A14
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhCaWPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhCaWPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E543461005;
        Wed, 31 Mar 2021 22:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617228937;
        bh=bHCa1+1sKMV7qL9XWxievJw5T0POVXZgXEOWZMjFrNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qq0nqBTU6nhZd1s+xYWtYFiQepyHuKnHMX6VWxGU9QNpQ66AfGVQPIxZujhqsZc62
         VPiN3xfwQp6eWFH+mLGbiZJXCnvZ0gzzWvv+X1x1lX3MErylIsCktUrOmV7xzq/Owi
         uBJsmwYTjlHeuhtOF9O3EBiroQf0dyOtpNrPDjaFfImNXQuugQYQwaA0sSqeaim3eU
         b/EuZ4Uomxeq0G0GD6kdD0JGZnEhHfPgqLa1OFg7qLe97JV3l9+hj93Mhlo7HN3SeY
         YzVspawCBv37PzVF6mVwzU6wvNKGxYjGuLNiaA1cgtebJHrLF4FVW5EFUMIjdIFNN6
         5V9Blb0dWWbEw==
Date:   Wed, 31 Mar 2021 16:15:39 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 1/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_send_pkt
Message-ID: <596a83e3e4729bc24c0b3eda45cda2aa28998f88.1617223928.git.gustavoars@kernel.org>
References: <cover.1617223928.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1617223928.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning by enclosing
structure members daddr and saddr into new struct addr:

arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [18, 23] from the object at 'sig' is out of the bounds of referenced subobject 'daddr' with type 'u8[6]' {aka 'unsigned char[6]'} at offset 11 [-Warray-bounds]

Refactor the code, accordingly:

$ pahole -C wl3501_md_req drivers/net/wireless/wl3501_cs.o
struct wl3501_md_req {
	u16                        next_blk;             /*     0     2 */
	u8                         sig_id;               /*     2     1 */
	u8                         routing;              /*     3     1 */
	u16                        data;                 /*     4     2 */
	u16                        size;                 /*     6     2 */
	u8                         pri;                  /*     8     1 */
	u8                         service_class;        /*     9     1 */
	struct {
		u8                 daddr[6];             /*    10     6 */
		u8                 saddr[6];             /*    16     6 */
	} addr;                                          /*    10    12 */

	/* size: 22, cachelines: 1, members: 8 */
	/* last cacheline: 22 bytes */
};

The problem is that the original code is trying to copy data into a
couple of arrays adjacent to each other in a single call to memcpy().
Now that a new struct _addr_ enclosing those two adjacent arrays
is introduced, memcpy() doesn't overrun the length of &sig.addr,
because the address of the new struct object _addr_ is used as
destination, instead.

Also, this helps with the ongoing efforts to enable -Warray-bounds and
avoid confusing the compiler.

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/60641d9b.2eNLedOGSdcSoAV2%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/wl3501.h    | 6 ++++--
 drivers/net/wireless/wl3501_cs.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index e98e04ee9a2c..ef9d605d8c88 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -471,8 +471,10 @@ struct wl3501_md_req {
 	u16	size;
 	u8	pri;
 	u8	service_class;
-	u8	daddr[ETH_ALEN];
-	u8	saddr[ETH_ALEN];
+	struct {
+		u8	daddr[ETH_ALEN];
+		u8	saddr[ETH_ALEN];
+	} addr;
 };
 
 struct wl3501_md_ind {
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 8ca5789c7b37..384bf84dfa51 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -484,7 +484,7 @@ static int wl3501_send_pkt(struct wl3501_card *this, u8 *data, u16 len)
 			goto out;
 		}
 		rc = 0;
-		memcpy(&sig.daddr[0], pdata, 12);
+		memcpy(&sig.addr, pdata, sizeof(sig.addr));
 		pktlen = len - 12;
 		pdata += 12;
 		sig.data = bf;
-- 
2.27.0

