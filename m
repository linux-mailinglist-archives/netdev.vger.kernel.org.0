Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1F71C64E0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgEFALp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:11:45 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.141]:40648 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgEFALo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:11:44 -0400
X-Greylist: delayed 1444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2020 20:11:43 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 06FCA94D1
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 18:47:39 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id W7Hmjo7HtSl8qW7HnjBSbL; Tue, 05 May 2020 18:47:39 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KOPjXpRAEDO9gDVQmxGovICcFiqsKOmDUl+JG+lNPqw=; b=YkBgmP2mcQEg2kn3TFnvNRqZON
        KRE3srpQZuM58jSwKcE26UGT6J4v/6H5OGCZPeOPJHti8lOK/EXnx5hlb3xh5K2WN18GM6EcY2mXJ
        aBmy/jjw2C22bdJr56JFSOIskhf9PuefI+j5jy+kGNdBdqc3UjkyZUjL3XC3qbDJA0cmQ9FtFesJJ
        ortTHl9lbXEcU7AhkCJSG+/KaoYXcJw0XKEHnBN/VM8XHa6wZSRDy3kxZ8bKI5y/v0tYrncaMayGZ
        UW+zyn19zNlqrIMLg/2RlePCiXmS30vn4kdnTSVDDQWKCX5Na5jb2aCu1G81cN9pBlJ9HJvu2vilV
        Hgb57vuA==;
Received: from [189.207.59.248] (port=57526 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jW7Hm-003MYG-Ki; Tue, 05 May 2020 18:47:38 -0500
Date:   Tue, 5 May 2020 18:52:05 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] rndis_wlan: Remove logically dead code
Message-ID: <20200505235205.GA18539@embeddedor>
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
X-Source-IP: 189.207.59.248
X-Source-L: No
X-Exim-ID: 1jW7Hm-003MYG-Ki
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.207.59.248]:57526
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

caps_buf is always of size sizeof(*caps) because
sizeof(caps->auth_encr_pair) * 16 is always zero. Notice
that when using zero-length arrays, sizeof evaluates to zero[1].

So, the code introduced by 
commit 0308383f9591 ("rndis_wlan: get max_num_pmkids from device")
is logically dead, hence is never executed and can be removed. As a
consequence, the rest of the related code can be refactored a bit.

Notice that this code has been out there since March 2010.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
In case this is actually a 10-year old bug, then we might want
calculate the size of caps_buf through the use of the struct_size
helper:

struct_size(caps, auth_encr_pair, 16);

and we might also want to allocate dynamic memory instead, as we
cannot do u8 caps_buf[struct_size(caps, auth_encr_pair, 16)];
due to -Wvla.

Thanks
--
Gustavo

 drivers/net/wireless/rndis_wlan.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 52375f3e430a..8852a1832951 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -312,17 +312,11 @@ struct ndis_80211_assoc_info {
 	__le32 offset_resp_ies;
 } __packed;
 
-struct ndis_80211_auth_encr_pair {
-	__le32 auth_mode;
-	__le32 encr_mode;
-} __packed;
-
 struct ndis_80211_capability {
 	__le32 length;
 	__le32 version;
 	__le32 num_pmkids;
 	__le32 num_auth_encr_pair;
-	struct ndis_80211_auth_encr_pair auth_encr_pair[0];
 } __packed;
 
 struct ndis_80211_bssid_info {
@@ -3109,8 +3103,7 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 		__le32	num_items;
 		__le32	items[8];
 	} networks_supported;
-	struct ndis_80211_capability *caps;
-	u8 caps_buf[sizeof(*caps) + sizeof(caps->auth_encr_pair) * 16];
+	struct ndis_80211_capability caps;
 	int len, retval, i, n;
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
@@ -3140,19 +3133,18 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	}
 
 	/* get device 802.11 capabilities, number of PMKIDs */
-	caps = (struct ndis_80211_capability *)caps_buf;
-	len = sizeof(caps_buf);
+	len = sizeof(caps);
 	retval = rndis_query_oid(usbdev,
 				 RNDIS_OID_802_11_CAPABILITY,
-				 caps, &len);
+				 &caps, &len);
 	if (retval >= 0) {
 		netdev_dbg(usbdev->net, "RNDIS_OID_802_11_CAPABILITY -> len %d, "
 				"ver %d, pmkids %d, auth-encr-pairs %d\n",
-				le32_to_cpu(caps->length),
-				le32_to_cpu(caps->version),
-				le32_to_cpu(caps->num_pmkids),
-				le32_to_cpu(caps->num_auth_encr_pair));
-		wiphy->max_num_pmkids = le32_to_cpu(caps->num_pmkids);
+				le32_to_cpu(caps.length),
+				le32_to_cpu(caps.version),
+				le32_to_cpu(caps.num_pmkids),
+				le32_to_cpu(caps.num_auth_encr_pair));
+		wiphy->max_num_pmkids = le32_to_cpu(caps.num_pmkids);
 	} else
 		wiphy->max_num_pmkids = 0;
 
-- 
2.26.2

