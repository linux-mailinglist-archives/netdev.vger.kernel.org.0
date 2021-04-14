Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2703735FE8C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhDNXp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhDNXp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B4A61166;
        Wed, 14 Apr 2021 23:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618443904;
        bh=LbPsXNRXxEamjimN0qT9LvkGOE8tTJtCkKeSzIaILRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUGoQJ9E88e6XAVKia9xrC70VCa/+8cZStRLZ+la/RVG/Qop+8R+U5u8MaBcKOcFX
         +Il/hZl1NOQYBPp2XwD2RkwuDLQ4I90SyRJLAbvFydmTdP6iXaJ9ZnH8uZvxqPIgmk
         MIL9GHFZ1oaID0pHcZfvsYCRVlH/rDf4QD21DcGApkh6kUwIxA6jvTUetM2WYUsFze
         aNCFOsvNCg+CMBxfe7uQRnnDz4R2rwywG5bRQHQ4hM8IAgCGSnMB/x4b9DKmTm+wkw
         knZ+pxHYteYxf8+pHkgUpku4UvPa03Ob6ESCE2XLulIjt0NHOTMwzfmCqNtufH2RHb
         vjrAvEmrXjHaA==
Date:   Wed, 14 Apr 2021 18:45:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 2/2] wl3501_cs: Fix out-of-bounds warnings in
 wl3501_mgmt_join
Message-ID: <1fbaf516da763b50edac47d792a9145aa4482e29.1618442265.git.gustavoars@kernel.org>
References: <cover.1618442265.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618442265.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warnings by adding a new structure
wl3501_req instead of duplicating the same members in structure
wl3501_join_req and wl3501_scan_confirm:

arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [39, 108] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 36 [-Warray-bounds]
arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [25, 95] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 22 [-Warray-bounds]

Refactor the code, accordingly:

$ pahole -C wl3501_req drivers/net/wireless/wl3501_cs.o
struct wl3501_req {
        u16                        beacon_period;        /*     0     2 */
        u16                        dtim_period;          /*     2     2 */
        u16                        cap_info;             /*     4     2 */
        u8                         bss_type;             /*     6     1 */
        u8                         bssid[6];             /*     7     6 */
        struct iw_mgmt_essid_pset  ssid;                 /*    13    34 */
        struct iw_mgmt_ds_pset     ds_pset;              /*    47     3 */
        struct iw_mgmt_cf_pset     cf_pset;              /*    50     8 */
        struct iw_mgmt_ibss_pset   ibss_pset;            /*    58     4 */
        struct iw_mgmt_data_rset   bss_basic_rset;       /*    62    10 */

        /* size: 72, cachelines: 2, members: 10 */
        /* last cacheline: 8 bytes */
};

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
        struct wl3501_req          req;                  /*    36    72 */

        /* size: 108, cachelines: 2, members: 10 */
        /* last cacheline: 44 bytes */
};

$ pahole -C wl3501_scan_confirm drivers/net/wireless/wl3501_cs.o
struct wl3501_scan_confirm {
        u16                        next_blk;             /*     0     2 */
        u8                         sig_id;               /*     2     1 */
        u8                         reserved;             /*     3     1 */
        u16                        status;               /*     4     2 */
        char                       timestamp[8];         /*     6     8 */
        char                       localtime[8];         /*    14     8 */
        struct wl3501_req          req;                  /*    22    72 */
        /* --- cacheline 1 boundary (64 bytes) was 30 bytes ago --- */
        u8                         rssi;                 /*    94     1 */

        /* size: 96, cachelines: 2, members: 8 */
        /* padding: 1 */
        /* last cacheline: 32 bytes */
};

The problem is that the original code is trying to copy data into a
bunch of struct members adjacent to each other in a single call to
memcpy(). Now that a new struct wl3501_req enclosing all those adjacent
members is introduced, memcpy() doesn't overrun the length of
&sig.beacon_period and &this->bss_set[i].beacon_period, because the
address of the new struct object _req_ is used as the destination,
instead.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Add new struct wl3501_req and refactor the code, accordingly.
 - Fix one more instance of this same issue.
 - Update changelog text.

Changes in v2:
 - None.

 drivers/net/wireless/wl3501.h    | 35 +++++++++++--------------
 drivers/net/wireless/wl3501_cs.c | 44 +++++++++++++++++---------------
 2 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index aa8222cbea68..59b7b93c5963 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -379,16 +379,7 @@ struct wl3501_get_confirm {
 	u8	mib_value[100];
 };
 
-struct wl3501_join_req {
-	u16			    next_blk;
-	u8			    sig_id;
-	u8			    reserved;
-	struct iw_mgmt_data_rset    operational_rset;
-	u16			    reserved2;
-	u16			    timeout;
-	u16			    probe_delay;
-	u8			    timestamp[8];
-	u8			    local_time[8];
+struct wl3501_req {
 	u16			    beacon_period;
 	u16			    dtim_period;
 	u16			    cap_info;
@@ -401,6 +392,19 @@ struct wl3501_join_req {
 	struct iw_mgmt_data_rset    bss_basic_rset;
 };
 
+struct wl3501_join_req {
+	u16			    next_blk;
+	u8			    sig_id;
+	u8			    reserved;
+	struct iw_mgmt_data_rset    operational_rset;
+	u16			    reserved2;
+	u16			    timeout;
+	u16			    probe_delay;
+	u8			    timestamp[8];
+	u8			    local_time[8];
+	struct wl3501_req	    req;
+};
+
 struct wl3501_join_confirm {
 	u16	next_blk;
 	u8	sig_id;
@@ -443,16 +447,7 @@ struct wl3501_scan_confirm {
 	u16			    status;
 	char			    timestamp[8];
 	char			    localtime[8];
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
+	struct wl3501_req	    req;
 	u8			    rssi;
 };
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 70307308635f..672f5d5f3f2c 100644
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
+	memcpy(&sig.req, &this->bss_set[stas].req, sizeof(sig.req));
 	return wl3501_esbq_exec(this, &sig, sizeof(sig));
 }
 
@@ -667,35 +667,37 @@ static void wl3501_mgmt_scan_confirm(struct wl3501_card *this, u16 addr)
 	if (sig.status == WL3501_STATUS_SUCCESS) {
 		pr_debug("success");
 		if ((this->net_type == IW_MODE_INFRA &&
-		     (sig.cap_info & WL3501_MGMT_CAPABILITY_ESS)) ||
+		     (sig.req.cap_info & WL3501_MGMT_CAPABILITY_ESS)) ||
 		    (this->net_type == IW_MODE_ADHOC &&
-		     (sig.cap_info & WL3501_MGMT_CAPABILITY_IBSS)) ||
+		     (sig.req.cap_info & WL3501_MGMT_CAPABILITY_IBSS)) ||
 		    this->net_type == IW_MODE_AUTO) {
 			if (!this->essid.el.len)
 				matchflag = 1;
 			else if (this->essid.el.len == 3 &&
 				 !memcmp(this->essid.essid, "ANY", 3))
 				matchflag = 1;
-			else if (this->essid.el.len != sig.ssid.el.len)
+			else if (this->essid.el.len != sig.req.ssid.el.len)
 				matchflag = 0;
-			else if (memcmp(this->essid.essid, sig.ssid.essid,
+			else if (memcmp(this->essid.essid, sig.req.ssid.essid,
 					this->essid.el.len))
 				matchflag = 0;
 			else
 				matchflag = 1;
 			if (matchflag) {
 				for (i = 0; i < this->bss_cnt; i++) {
-					if (ether_addr_equal_unaligned(this->bss_set[i].bssid, sig.bssid)) {
+					if (ether_addr_equal_unaligned(this->bss_set[i].req.bssid,
+								       sig.req.bssid)) {
 						matchflag = 0;
 						break;
 					}
 				}
 			}
 			if (matchflag && (i < 20)) {
-				memcpy(&this->bss_set[i].beacon_period,
-				       &sig.beacon_period, 73);
+				memcpy(&this->bss_set[i].req,
+				       &sig.req, sizeof(sig.req));
 				this->bss_cnt++;
 				this->rssi = sig.rssi;
+				this->bss_set[i].rssi = sig.rssi;
 			}
 		}
 	} else if (sig.status == WL3501_STATUS_TIMEOUT) {
@@ -887,19 +889,19 @@ static void wl3501_mgmt_join_confirm(struct net_device *dev, u16 addr)
 			if (this->join_sta_bss < this->bss_cnt) {
 				const int i = this->join_sta_bss;
 				memcpy(this->bssid,
-				       this->bss_set[i].bssid, ETH_ALEN);
-				this->chan = this->bss_set[i].ds_pset.chan;
+				       this->bss_set[i].req.bssid, ETH_ALEN);
+				this->chan = this->bss_set[i].req.ds_pset.chan;
 				iw_copy_mgmt_info_element(&this->keep_essid.el,
-						     &this->bss_set[i].ssid.el);
+						     &this->bss_set[i].req.ssid.el);
 				wl3501_mgmt_auth(this);
 			}
 		} else {
 			const int i = this->join_sta_bss;
 
-			memcpy(&this->bssid, &this->bss_set[i].bssid, ETH_ALEN);
-			this->chan = this->bss_set[i].ds_pset.chan;
+			memcpy(&this->bssid, &this->bss_set[i].req.bssid, ETH_ALEN);
+			this->chan = this->bss_set[i].req.ds_pset.chan;
 			iw_copy_mgmt_info_element(&this->keep_essid.el,
-						  &this->bss_set[i].ssid.el);
+						  &this->bss_set[i].req.ssid.el);
 			wl3501_online(dev);
 		}
 	} else {
@@ -1573,30 +1575,30 @@ static int wl3501_get_scan(struct net_device *dev, struct iw_request_info *info,
 	for (i = 0; i < this->bss_cnt; ++i) {
 		iwe.cmd			= SIOCGIWAP;
 		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-		memcpy(iwe.u.ap_addr.sa_data, this->bss_set[i].bssid, ETH_ALEN);
+		memcpy(iwe.u.ap_addr.sa_data, this->bss_set[i].req.bssid, ETH_ALEN);
 		current_ev = iwe_stream_add_event(info, current_ev,
 						  extra + IW_SCAN_MAX_DATA,
 						  &iwe, IW_EV_ADDR_LEN);
 		iwe.cmd		  = SIOCGIWESSID;
 		iwe.u.data.flags  = 1;
-		iwe.u.data.length = this->bss_set[i].ssid.el.len;
+		iwe.u.data.length = this->bss_set[i].req.ssid.el.len;
 		current_ev = iwe_stream_add_point(info, current_ev,
 						  extra + IW_SCAN_MAX_DATA,
 						  &iwe,
-						  this->bss_set[i].ssid.essid);
+						  this->bss_set[i].req.ssid.essid);
 		iwe.cmd	   = SIOCGIWMODE;
-		iwe.u.mode = this->bss_set[i].bss_type;
+		iwe.u.mode = this->bss_set[i].req.bss_type;
 		current_ev = iwe_stream_add_event(info, current_ev,
 						  extra + IW_SCAN_MAX_DATA,
 						  &iwe, IW_EV_UINT_LEN);
 		iwe.cmd = SIOCGIWFREQ;
-		iwe.u.freq.m = this->bss_set[i].ds_pset.chan;
+		iwe.u.freq.m = this->bss_set[i].req.ds_pset.chan;
 		iwe.u.freq.e = 0;
 		current_ev = iwe_stream_add_event(info, current_ev,
 						  extra + IW_SCAN_MAX_DATA,
 						  &iwe, IW_EV_FREQ_LEN);
 		iwe.cmd = SIOCGIWENCODE;
-		if (this->bss_set[i].cap_info & WL3501_MGMT_CAPABILITY_PRIVACY)
+		if (this->bss_set[i].req.cap_info & WL3501_MGMT_CAPABILITY_PRIVACY)
 			iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
 		else
 			iwe.u.data.flags = IW_ENCODE_DISABLED;
-- 
2.27.0

