Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D1D350A6F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhCaWpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhCaWpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 725836105A;
        Wed, 31 Mar 2021 22:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617230732;
        bh=eOMEKgNYxeamI99PREgwqO+0ZE43rgZqPo/0e5CC1iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/hDCtYga5ZDJ0am61+W7bi58nMV7Ay7UJ9lNi+7aWwyxcq6/3EaXcuxsWT08SG6X
         TYuFXe1InfuTZipyqH1jAeIflcOQFEe1MMuiL5qIkuNs47QoVkuZ6ZTGTjoSX9ii/Q
         dTaTVdH424f8XPHWvX7UMChlv3A5eolbl9mbJ7UGu4EX9QT7ZXPF0mdWTajad4utIo
         l2+HCNvR0mfovPyIjsiKO8F2ZFkWq4Jl1H4aVFDYK/At6Z+g48VbDqgFQRgaOH88gL
         iG133xTWJdtN1cQX6fUojwE2mXOt28KDZt04KcEiPuaz9n297LWhTqhhz0Q7//zlo1
         di2BPsRjYqBWg==
Date:   Wed, 31 Mar 2021 16:45:34 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 2/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_mgmt_join
Message-ID: <83b0388403a61c01fad8d638db40b4245666ff53.1617226664.git.gustavoars@kernel.org>
References: <cover.1617226663.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1617226663.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning by enclosing
some structure members into new struct req:

arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [39, 108] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 36 [-Warray-bounds]

Refactor the code, accordingly:

$ pahole -C wl3501_join_req drivers/net/wireless/wl3501_cs.o
struct wl3501_join_req {
	u16                        next_blk;             /*     0     2 */
	u8                         sig_id;               /*     2     1 */
	u8                         reserved;             /*     3     1 */
	struct iw_mgmt_data_rset   operational_rset;     /*     4    10 */
	u16                        reserved2;            /*    14     2 */
	u16                        timeout;              /*    16     2 */
	u16                        probe_delay;          /*    18     2 */
	u8                         timestamp[8];         /*    20     8 */
	u8                         local_time[8];        /*    28     8 */
	struct {
		u16                beacon_period;        /*    36     2 */
		u16                dtim_period;          /*    38     2 */
		u16                cap_info;             /*    40     2 */
		u8                 bss_type;             /*    42     1 */
		u8                 bssid[6];             /*    43     6 */
		struct iw_mgmt_essid_pset ssid;          /*    49    34 */
		/* --- cacheline 1 boundary (64 bytes) was 19 bytes ago --- */
		struct iw_mgmt_ds_pset ds_pset;          /*    83     3 */
		struct iw_mgmt_cf_pset cf_pset;          /*    86     8 */
		struct iw_mgmt_ibss_pset ibss_pset;      /*    94     4 */
		struct iw_mgmt_data_rset bss_basic_rset; /*    98    10 */
	} req;                                           /*    36    72 */

	/* size: 108, cachelines: 2, members: 10 */
	/* last cacheline: 44 bytes */
};

The problem is that the original code is trying to copy data into a
bunch of struct members adjacent to each other in a single call to
memcpy(). Now that a new struct _req_ enclosing all those adjacent
members is introduced, memcpy() doesn't overrun the length of
&sig.beacon_period, because the address of the new struct object
_req_ is used as the destination, instead.

Also, this helps with the ongoing efforts to enable -Warray-bounds and
avoid confusing the compiler.

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/60641d9b.2eNLedOGSdcSoAV2%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - None.

 drivers/net/wireless/wl3501.h    | 22 ++++++++++++----------
 drivers/net/wireless/wl3501_cs.c |  4 ++--
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index ef9d605d8c88..774d8cac046d 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -389,16 +389,18 @@ struct wl3501_join_req {
 	u16			    probe_delay;
 	u8			    timestamp[8];
 	u8			    local_time[8];
-	u16			    beacon_period;
-	u16			    dtim_period;
-	u16			    cap_info;
-	u8			    bss_type;
-	u8			    bssid[ETH_ALEN];
-	struct iw_mgmt_essid_pset   ssid;
-	struct iw_mgmt_ds_pset	    ds_pset;
-	struct iw_mgmt_cf_pset	    cf_pset;
-	struct iw_mgmt_ibss_pset    ibss_pset;
-	struct iw_mgmt_data_rset    bss_basic_rset;
+	struct {
+		u16			    beacon_period;
+		u16			    dtim_period;
+		u16			    cap_info;
+		u8			    bss_type;
+		u8			    bssid[ETH_ALEN];
+		struct iw_mgmt_essid_pset   ssid;
+		struct iw_mgmt_ds_pset	    ds_pset;
+		struct iw_mgmt_cf_pset	    cf_pset;
+		struct iw_mgmt_ibss_pset    ibss_pset;
+		struct iw_mgmt_data_rset    bss_basic_rset;
+	} req;
 };
 
 struct wl3501_join_confirm {
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index e149ef81d6cc..399d3bd2ae76 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -590,7 +590,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
 	struct wl3501_join_req sig = {
 		.sig_id		  = WL3501_SIG_JOIN_REQ,
 		.timeout	  = 10,
-		.ds_pset = {
+		.req.ds_pset = {
 			.el = {
 				.id  = IW_MGMT_INFO_ELEMENT_DS_PARAMETER_SET,
 				.len = 1,
@@ -599,7 +599,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
 		},
 	};
 
-	memcpy(&sig.beacon_period, &this->bss_set[stas].beacon_period, 72);
+	memcpy(&sig.req, &this->bss_set[stas].beacon_period, sizeof(sig.req));
 	return wl3501_esbq_exec(this, &sig, sizeof(sig));
 }
 
-- 
2.27.0

