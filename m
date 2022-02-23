Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0FD4C0902
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiBWCds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiBWCdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE75E74E;
        Tue, 22 Feb 2022 18:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E63036157F;
        Wed, 23 Feb 2022 02:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFF3C340EB;
        Wed, 23 Feb 2022 02:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583463;
        bh=TiTQiThEcjMtldsoXuGuzk5+IrynefCoac+K2A/X0ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FX8vOT9INRi15jmEHdaHjHRcT7R00ciDebJJCTKPl3ZURLX0k3t8KWFCp57YgRo0J
         Dmw9OalEKv7Cvgdy+58l+TRnmZuMHHwXFRn9rfNEEPlq1TshHsxEQLCJco7Zh5214S
         iZSUMKOuTqENBm+B9D840+pcfuDMjfBWFqx/hLO5aiFyeZcbN1mklHAG4WwwXGGrNQ
         Rp8vogO3oWdK52DWDd/dH7AsKtJ3hPtTzE9yKte5hkrOJSw1I4vfnnXf3CWLs4UFSu
         tfEj9URYhHmFo5S+5zagNG1Zr/+bdhc4nxwqzun0R1GD4YO6JoXfqsvbYe4ipdh1ai
         sGIxvJa9AN+JA==
Date:   Tue, 22 Feb 2022 20:38:57 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 4/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array  member in struct wmi_connect_event
Message-ID: <8a0e347615a3516980fd8b6ad2dc4864a880613b.1645583264.git.gustavoars@kernel.org>
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
wmi_connect_event.

It's also worth noting that due to the flexible array transformation,
the size of struct wmi_connect_event changed (now the size is 1 byte
smaller), and in order to preserve the logic of before the transformation,
the following change is needed:

	-       if (len < sizeof(struct wmi_connect_event))
	+       if (len <= sizeof(struct wmi_connect_event))

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Hi!

It'd be great if someone can confirm or comment on the following
changes described in the changelog text:

        -       if (len < sizeof(struct wmi_connect_event))
        +       if (len <= sizeof(struct wmi_connect_event))

Thanks

 drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 049d75f31f3c..ccdccead688e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -857,7 +857,7 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 	struct wmi_connect_event *ev;
 	u8 *pie, *peie;
 
-	if (len < sizeof(struct wmi_connect_event))
+	if (len <= sizeof(struct wmi_connect_event))
 		return -EINVAL;
 
 	ev = (struct wmi_connect_event *) datap;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 432e4f428a4a..6b064e669d87 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1545,7 +1545,7 @@ struct wmi_connect_event {
 	u8 beacon_ie_len;
 	u8 assoc_req_len;
 	u8 assoc_resp_len;
-	u8 assoc_info[1];
+	u8 assoc_info[];
 } __packed;
 
 /* Disconnect Event */
-- 
2.27.0

