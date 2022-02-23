Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1914C0893
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiBWCdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbiBWCdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3443354BEF;
        Tue, 22 Feb 2022 18:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D436AB81DD2;
        Wed, 23 Feb 2022 02:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB55AC340F1;
        Wed, 23 Feb 2022 02:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583455;
        bh=H9zXEc7xajyp0WNLmUqmywqLWj4AFxabUZT7J4ZwI44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pO9XXYnrCCqQPomdmANKP8O9qxTbnjx61E+exDu2XW+tnjbuSvKAKWseHRJRMhU8t
         5+R5p/2OSuPBl7aTHW60WkNbnttWsgGC4mojnWOP99ZEV05EA187xYchv1l1VQ+ltU
         MsZ64e1DKkJZY//dOFdOlnMKrG7ulpalLxc/OlNKjBC39NVFlFpZCVq1qlkxx6MfB8
         wK18E7iOXvEvB2dLkSwNLYrPwhDTxkJmOA16rguBlXYHzT8yiGMV29dLWUNcZ5Xl19
         HX6C373RMnIPZ8jRkGH81+EYY2j2i17PVgRs6rpYgBgK4E3Dw7GTf+tMUr95P5iFP/
         KS8HBWNzjzQ4Q==
Date:   Tue, 22 Feb 2022 20:38:50 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 3/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array  member in struct wmi_channel_list_reply
Message-ID: <30306253b1b5e6b8f5c0faba97e935eda4638020.1645583264.git.gustavoars@kernel.org>
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
wmi_channel_list_reply.

It's also worth noting that due to the flexible array transformation,
the size of struct wmi_channel_list_reply changed, see below.

Before flex-array transformation:

struct wmi_channel_list_reply {
	u8                         reserved;             /*     0     1 */
	u8                         num_ch;               /*     1     1 */
	__le16                     ch_list[1];           /*     2     2 */

	/* size: 4, cachelines: 1, members: 3 */
	/* last cacheline: 4 bytes */
};

After flex-array transformation:

struct wmi_channel_list_reply {
	u8                         reserved;             /*     0     1 */
	u8                         num_ch;               /*     1     1 */
	__le16                     ch_list[];            /*     2     0 */

	/* size: 2, cachelines: 1, members: 3 */
	/* last cacheline: 2 bytes */
};

So, the following change preserves the logic that if _len_ is at least
4 bytes in size, this is the existence of at least one channel in
ch_list[] is being considered, then the execution jumps to call
ath6kl_wakeup_event(wmi->parent_dev);, otherwise _len_ is 2 bytes or
less and the code returns -EINVAL:

	-       if (len < sizeof(struct wmi_channel_list_reply))
	+       if (len <= sizeof(struct wmi_channel_list_reply))

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Hi!

It'd be great if someone can confirm or comment on the following
changes described in the changelog text:

	-       if (len < sizeof(struct wmi_channel_list_reply))
	+       if (len <= sizeof(struct wmi_channel_list_reply))

Thanks

 drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bdfc057c5a82..049d75f31f3c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1240,7 +1240,7 @@ static int ath6kl_wmi_ratemask_reply_rx(struct wmi *wmi, u8 *datap, int len)
 
 static int ath6kl_wmi_ch_list_reply_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	if (len < sizeof(struct wmi_channel_list_reply))
+	if (len <= sizeof(struct wmi_channel_list_reply))
 		return -EINVAL;
 
 	ath6kl_wakeup_event(wmi->parent_dev);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9e168752bec2..432e4f428a4a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1373,7 +1373,7 @@ struct wmi_channel_list_reply {
 	u8 num_ch;
 
 	/* channel in Mhz */
-	__le16 ch_list[1];
+	__le16 ch_list[];
 } __packed;
 
 /* List of Events (target to host) */
-- 
2.27.0

