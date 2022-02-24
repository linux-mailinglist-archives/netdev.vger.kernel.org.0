Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862424C3776
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiBXVKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiBXVK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B428D396;
        Thu, 24 Feb 2022 13:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74E9BB829B3;
        Thu, 24 Feb 2022 21:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B672C340E9;
        Thu, 24 Feb 2022 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736993;
        bh=6IApdu4M+sjJDandvKx6K/9PvnrmBluI9K7FQQLLGW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j9KEW7lCO//9VFNx8CNNClk840VX7fW2bvpH3lUk0LAKuLf5OID86bAkMP5HAD1at
         wVJbn5CRNz86xwmSIjEcFCGop1vz42TxX+0DbhvQkDGQ026GS4V9WCDvno61uWJFyi
         lMywvmQbxrnhMA7Uzqr4OiW0OE6SA4NRArb4v3ktFPE8/GD6MnKPSS/y4Sa+2pLFZx
         yYEAT2+r9F/FTLRyFKzmKBO2WlnEc7Dvv7uhypvH3S66DvD0WGfdvLvmjeJ+t9CA38
         0mkgANMPlYEJr5paRSTbmb9tHUgUxFVazt50P8rq+nEc1RRyRuXXGeY9XLZ2P3mfME
         dBjl+xQLeaDFg==
Date:   Thu, 24 Feb 2022 15:17:51 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 6/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_aplist_event
Message-ID: <1b7889828f23763c034c1558cbab9c8e2066053e.1645736204.git.gustavoars@kernel.org>
References: <cover.1645736204.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645736204.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace one-element array with flexible-array member in struct
wmi_aplist_event.

Also, make use of the struct_size() helper and remove unneeded variable
ap_info_entry_size.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Revert changes in if-statement logic:
        if (len < sizeof(struct wmi_aplist_event))
   Link: https://lore.kernel.org/linux-hardening/3f408c80-cabf-5ba2-2014-2eb0550b73f9@quicinc.com/
 - Update changelog text.
 - Add Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com> tag.

 drivers/net/wireless/ath/ath6kl/wmi.c | 5 +----
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bdfc057c5a82..3787b9fb0075 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1750,7 +1750,6 @@ static int ath6kl_wmi_snr_threshold_event_rx(struct wmi *wmi, u8 *datap,
 
 static int ath6kl_wmi_aplist_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	u16 ap_info_entry_size;
 	struct wmi_aplist_event *ev = (struct wmi_aplist_event *) datap;
 	struct wmi_ap_info_v1 *ap_info_v1;
 	u8 index;
@@ -1759,14 +1758,12 @@ static int ath6kl_wmi_aplist_event_rx(struct wmi *wmi, u8 *datap, int len)
 	    ev->ap_list_ver != APLIST_VER1)
 		return -EINVAL;
 
-	ap_info_entry_size = sizeof(struct wmi_ap_info_v1);
 	ap_info_v1 = (struct wmi_ap_info_v1 *) ev->ap_list;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI,
 		   "number of APs in aplist event: %d\n", ev->num_ap);
 
-	if (len < (int) (sizeof(struct wmi_aplist_event) +
-			 (ev->num_ap - 1) * ap_info_entry_size))
+	if (len < struct_size(ev, ap_list, ev->num_ap))
 		return -EINVAL;
 
 	/* AP list version 1 contents */
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 6a7fc07cd9aa..a9732660192a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1957,7 +1957,7 @@ union wmi_ap_info {
 struct wmi_aplist_event {
 	u8 ap_list_ver;
 	u8 num_ap;
-	union wmi_ap_info ap_list[1];
+	union wmi_ap_info ap_list[];
 } __packed;
 
 /* Developer Commands */
-- 
2.27.0

