Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7433741C5
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhEEQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234503AbhEEQio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:38:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5885614A7;
        Wed,  5 May 2021 16:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232426;
        bh=m1IdrTc0PJlieHqOWMV/T/izml7M7PVd/a0+jw4+KsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhEWvuj4EYkt1qJZLTLSmOFIyxqh4fwx/Ilm4Y+GmrJszJgJiogPY0kmvNoR2v+0L
         K5diLQvPyXVqSSaebI3p2MB342UcEq0iE1oSAAkWDksjZHZPmgKz7b68vG4Au0JBtM
         PaV01veUgiR6qsPLcNoQ1JXqYuysp6Dmsl0o5y+n9ekQbbMhoDTdDiAa5QqaOONB3M
         dBLauH7sLQ3l2wbzMbEMUP/b9LZNx858ctEtX9quCoDb65Q1O3+9ZrjBSotIfHJoHa
         5wXJYXcMq/IPIpMY3n77rMj95mttoa4fZxHbA7+79GsZK6oG9wLpRFraVDxfNDRRlY
         T1WVqtaQ2EzEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 100/116] wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
Date:   Wed,  5 May 2021 12:31:08 -0400
Message-Id: <20210505163125.3460440-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 820aa37638a252b57967bdf4038a514b1ab85d45 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
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
2.30.2

