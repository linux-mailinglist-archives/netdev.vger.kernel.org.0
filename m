Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCDF35FE88
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhDNXnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhDNXna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C09361154;
        Wed, 14 Apr 2021 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618443788;
        bh=JNrMDRE8+SHDf4AlN0wA82GsuaVAEYDwobfrD9UBR3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UEQdFDb3e8h/3oDGh4gzDk8zuesSAdsTw5hVmBvOhtc3pkl4jolHMnk7m0X7RfC7t
         E6saAXOFdCPZEc4uwiBux9OZuhbSGq+dUfCT073XAgm3+1beAPUj84s9iEIP+KOK/r
         GCQxGrOQW76f/fROw+/n2jWjewK4gbxkmD3ZtUlZmB/ZS9SDk1F682upGsxwlsfgZ5
         qaMWquwQKG5GDZVlySTxPJQTpIhYNCUtF5ty6fKq6CTiZntgpFmfNVJogKFlj4knSv
         MoON3o9AXy4M7qrfhqi/z3uObS6uVuNME1hCNBl7jBskhLqRipHGmhphHkg+0KxVl9
         fLueoyb0jp17A==
Date:   Wed, 14 Apr 2021 18:43:19 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 1/2] wl3501_cs: Fix out-of-bounds warnings in
 wl3501_send_pkt
Message-ID: <d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org>
References: <cover.1618442265.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618442265.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warnings by enclosing structure members
daddr and saddr into new struct addr, in structures wl3501_md_req and
wl3501_md_ind:

arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [18, 23] from the object at 'sig' is out of the bounds of referenced subobject 'daddr' with type 'u8[6]' {aka 'unsigned char[6]'} at offset 11 [-Warray-bounds]
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

$ pahole -C wl3501_md_ind drivers/net/wireless/wl3501_cs.o
struct wl3501_md_ind {
	u16                        next_blk;             /*     0     2 */
	u8                         sig_id;               /*     2     1 */
	u8                         routing;              /*     3     1 */
	u16                        data;                 /*     4     2 */
	u16                        size;                 /*     6     2 */
	u8                         reception;            /*     8     1 */
	u8                         pri;                  /*     9     1 */
	u8                         service_class;        /*    10     1 */
	struct {
		u8                 daddr[6];             /*    11     6 */
		u8                 saddr[6];             /*    17     6 */
	} addr;                                          /*    11    12 */

	/* size: 24, cachelines: 1, members: 9 */
	/* padding: 1 */
	/* last cacheline: 24 bytes */
};

The problem is that the original code is trying to copy data into a
couple of arrays adjacent to each other in a single call to memcpy().
Now that a new struct _addr_ enclosing those two adjacent arrays
is introduced, memcpy() doesn't overrun the length of &sig.daddr[0]
and &sig.daddr, because the address of the new struct object _addr_
is used, instead.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Enclose adjacent members in struct wl3501_md_ind into new struct req.
 - Fix one more instance of this same issue in function
   wl3501_md_ind_interrupt().
 - Update changelog text.
 - Add Kees' RB tag.

Changes in v2:
 - Update changelog text.
 - Replace a couple of magic numbers with new variable sig_addr_len.

 drivers/net/wireless/wl3501.h    | 12 ++++++++----
 drivers/net/wireless/wl3501_cs.c | 10 ++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index e98e04ee9a2c..aa8222cbea68 100644
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
@@ -484,8 +486,10 @@ struct wl3501_md_ind {
 	u8	reception;
 	u8	pri;
 	u8	service_class;
-	u8	daddr[ETH_ALEN];
-	u8	saddr[ETH_ALEN];
+	struct {
+		u8	daddr[ETH_ALEN];
+		u8	saddr[ETH_ALEN];
+	} addr;
 };
 
 struct wl3501_md_confirm {
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 8ca5789c7b37..70307308635f 100644
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
@@ -980,7 +981,8 @@ static inline void wl3501_md_ind_interrupt(struct net_device *dev,
 	} else {
 		skb->dev = dev;
 		skb_reserve(skb, 2); /* IP headers on 16 bytes boundaries */
-		skb_copy_to_linear_data(skb, (unsigned char *)&sig.daddr, 12);
+		skb_copy_to_linear_data(skb, (unsigned char *)&sig.addr,
+					sizeof(sig.addr));
 		wl3501_receive(this, skb->data, pkt_len);
 		skb_put(skb, pkt_len);
 		skb->protocol	= eth_type_trans(skb, dev);
-- 
2.27.0

