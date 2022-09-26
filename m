Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D09F5EB359
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiIZVmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIZVmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6465C72FCC;
        Mon, 26 Sep 2022 14:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC5E66146C;
        Mon, 26 Sep 2022 21:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA4FC433D6;
        Mon, 26 Sep 2022 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664228520;
        bh=Xa4BkxMFeIIJfKHYr4ePJYQZBBTMBlGFQ0Mb8GYffik=;
        h=Date:From:To:Cc:Subject:From;
        b=S6n/iFfWfO0akHLJkH4ZyqWVbWLfcz7qUaEqZPxOhUN/OHQ/zGk/ctEyX/E+Rb9Xd
         egpdAHEck9L41dnAlaOUBTfxfIuS3z/cs/0bstdYtRncPcUHXdwDJy99TDjNon38X/
         tFGgpHiZC646p35urLUndeRicARWEwLDVzgyeVZyW5GdxSlUKf45LzePxy/dXLIzKw
         oIDzPb+uCJUZz7782eXeYjdgRCPZvfQO4OJyUJOsRc9eqLnm4RuXTgwTkoAAJ9As8U
         OCU85uUsSaY27/Hdlv7bORY8wEK/Ac//ApJDNBvON5qK/kRyzHHVgnYKHzgc+Bp4D/
         mYnfeyFwEkP/g==
Date:   Mon, 26 Sep 2022 16:41:54 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath10k: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIcoloIQBDqGlgc@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/212
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index f06cf39204e2..c051a22fce14 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1108,8 +1108,10 @@ struct htt_rx_in_ord_ind {
 	u8 reserved;
 	__le16 msdu_count;
 	union {
-		struct htt_rx_in_ord_msdu_desc msdu_descs32[0];
-		struct htt_rx_in_ord_msdu_desc_ext msdu_descs64[0];
+		DECLARE_FLEX_ARRAY(struct htt_rx_in_ord_msdu_desc,
+				   msdu_descs32);
+		DECLARE_FLEX_ARRAY(struct htt_rx_in_ord_msdu_desc_ext,
+				   msdu_descs64);
 	} __packed;
 } __packed;
 
-- 
2.34.1

