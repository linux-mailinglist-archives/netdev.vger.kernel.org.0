Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AE14C090E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbiBWCdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiBWCdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DC755499;
        Tue, 22 Feb 2022 18:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 962E6B81DD2;
        Wed, 23 Feb 2022 02:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28BC340EB;
        Wed, 23 Feb 2022 02:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583477;
        bh=b4fg9t+rSbYEnlrrD0PfvXHUsfVJWu2Xtp897/eWJBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jxmoj2CZYxA+OVt0dxFgPwPk1xHQXLNTX+kgiSqd95ArDpUICHRWVm39778T7thmd
         7uBee3ECpqEZCNygF9cTUtPeNClyqd/5g3XjwUj+hxtst0lHzGRFAj+oyvuoATK7mz
         CLp2u3oGAvgHt6I+iFARqczW7Ha8ua9XJM9OsvuLoyLJ+O/xwxvzuB7/tn8kFtec4p
         e3svrFHfaZN+saF6QDWoVreAV6AkKuk6cNVIoqRxI+zWh0ES8HmvRkPNF1Skrhxdmt
         FUa1iuRrNynkXh06YzaysM9pzIKTayZC4NPh9pnvh0vLSgJls7/CqsY+Aog/JEVSJy
         TnvslMv0dp47Q==
Date:   Tue, 22 Feb 2022 20:39:11 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 6/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array  member in struct wmi_aplist_event
Message-ID: <c2116e10dd61869e17fa40a96f1e07a415820575.1645583264.git.gustavoars@kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645583264.git.gustavoars@kernel.org>
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

It's also worth noting that due to the flexible array transformation,
the size of struct wmi_aplist_event changed (now the size is 8-byte
smaller), and in order to preserve the logic of before the transformation,
the following change is needed:

        -       if (len < sizeof(struct wmi_aplist_event))
        +       if (len <= sizeof(struct wmi_aplist_event))

sizeof(struct wmi_aplist_event) before the flex-array transformation:

struct wmi_aplist_event {
	u8                         ap_list_ver;          /*     0     1 */
	u8                         num_ap;               /*     1     1 */
	union wmi_ap_info          ap_list[1];           /*     2     8 */

	/* size: 10, cachelines: 1, members: 3 */
	/* last cacheline: 10 bytes */
};

sizeof(struct wmi_aplist_event) after the flex-array transformation:

struct wmi_aplist_event {
	u8                         ap_list_ver;          /*     0     1 */
	u8                         num_ap;               /*     1     1 */
	union wmi_ap_info          ap_list[];            /*     2     0 */

	/* size: 2, cachelines: 1, members: 3 */
	/* last cacheline: 2 bytes */
};

Also, make use of the struct_size() helper and remove unneeded variable
ap_info_entry_size.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Hi!

It'd be great if someone can confirm or comment on the following
changes described in the changelog text:

        -       if (len < sizeof(struct wmi_aplist_event))
        +       if (len <= sizeof(struct wmi_aplist_event))

Thanks

 drivers/net/wireless/ath/ath6kl/wmi.c | 7 ++-----
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 645fb6cae3be..484d37e66ce6 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1750,23 +1750,20 @@ static int ath6kl_wmi_snr_threshold_event_rx(struct wmi *wmi, u8 *datap,
 
 static int ath6kl_wmi_aplist_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	u16 ap_info_entry_size;
 	struct wmi_aplist_event *ev = (struct wmi_aplist_event *) datap;
 	struct wmi_ap_info_v1 *ap_info_v1;
 	u8 index;
 
-	if (len < sizeof(struct wmi_aplist_event) ||
+	if (len <= sizeof(struct wmi_aplist_event) ||
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

