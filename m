Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7091350A6A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhCaWor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhCaWo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48D3E61075;
        Wed, 31 Mar 2021 22:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617230667;
        bh=yBfcXelbsR62PKT2NwaanCCwChsLT4uqAoFLOoTbdto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfI9elhtwCDTNmVm/qNFQGDxJQz7aHIMXYt/OlZm3zIPoOxaegbOn5NVwZItTOYxO
         5NZitpiGe5BRs7VvUHEt9Q9mOrvag3XslpAb0kLn18Yla0nOf2/c5V3GcazP1mK8S8
         QWfPxOfeAaNt5lzytM02TGuxfT283s5JJr1+njAa50PwQEDlfyfso5zzEyxoGMS3K0
         6YWjqKSIvXCOYj3Uf/7Orf6fk09BlVe72LGXHnFYA3/hKJw27K9Ffqav+5yIT6txgB
         fBz6d+Zl+JLlM6z/mttMEhWtt1MHp6IpBsUNS0Sy+HJjqMZdoZ54GeyPmzrs94lFy6
         xIzPrVTbESExQ==
Date:   Wed, 31 Mar 2021 16:44:29 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 1/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_send_pkt
Message-ID: <e03d36114bcbcf814ad13deb7812b0b5c196dadb.1617226663.git.gustavoars@kernel.org>
References: <cover.1617226663.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1617226663.git.gustavoars@kernel.org>
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
is introduced, memcpy() doesn't overrun the length of &sig.daddr[0],
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
Changes in v2:
 - Update changelog text.
 - Replace a couple of magic numbers with new variable sig_addr_len.

 drivers/net/wireless/wl3501.h    | 6 ++++--
 drivers/net/wireless/wl3501_cs.c | 7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

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
index 8ca5789c7b37..e149ef81d6cc 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -469,6 +469,7 @@ static int wl3501_send_pkt(struct wl3501_card *this, u8 *data, u16 len)
 	struct wl3501_md_req sig = {
 		.sig_id = WL3501_SIG_MD_REQ,
 	};
+	size_t sig_addr_len = sizeof(sig.addr);
 	u8 *pdata = (char *)data;
 	int rc = -EIO;
 
@@ -484,9 +485,9 @@ static int wl3501_send_pkt(struct wl3501_card *this, u8 *data, u16 len)
 			goto out;
 		}
 		rc = 0;
-		memcpy(&sig.daddr[0], pdata, 12);
-		pktlen = len - 12;
-		pdata += 12;
+		memcpy(&sig.addr, pdata, sig_addr_len);
+		pktlen = len - sig_addr_len;
+		pdata += sig_addr_len;
 		sig.data = bf;
 		if (((*pdata) * 256 + (*(pdata + 1))) > 1500) {
 			u8 addr4[ETH_ALEN] = {
-- 
2.27.0

