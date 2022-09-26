Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132115EB504
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIZXDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIZXDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FA1A6C7D;
        Mon, 26 Sep 2022 16:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5807DB81598;
        Mon, 26 Sep 2022 23:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECDDC433C1;
        Mon, 26 Sep 2022 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664233427;
        bh=LR3UfCiNXRP6GH1z7zVRQd1TAhuJoMYJwgNsk6+fF/c=;
        h=Date:From:To:Cc:Subject:From;
        b=fAm/m9gkSD2nN+h+7uUBDXchZl+l+t4u0c4r5IcnikgyLffJWVGH5KPnSDVw+vDMU
         rf8IsJz0G/HBLCvHql3JF3SaK1gA6PFQ98bQOUGmSvLPnG5uUFPO0gEcOa+5QnvwHZ
         MKyx7RIM/bkfGuzmlTT0hu8Fxd01FwG2A46zPkNBCh8q2SIdDgIBEDt3BIS/vBrQ3F
         BS7aNuT32g5vGxOEyMnKehi99g+Uyh0jQhF0q5pguELIp5G8Kzg5B19XxZPvRF8fe0
         q1JX0JFfeEqvlYFAV1Fx0bipJKdWIgUs73My5zGDLJUFZFnnNc8OJ1uI/9TulpXgVu
         fke/XqTTkwBMw==
Date:   Mon, 26 Sep 2022 18:03:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iwlegacy: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIvzc0jsYLigO8a@work>
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
Link: https://github.com/KSPP/linux/issues/223
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/commands.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/commands.h b/drivers/net/wireless/intel/iwlegacy/commands.h
index 4a97310f8fee..28cf4e832152 100644
--- a/drivers/net/wireless/intel/iwlegacy/commands.h
+++ b/drivers/net/wireless/intel/iwlegacy/commands.h
@@ -1710,7 +1710,7 @@ struct il4965_tx_resp {
 	 */
 	union {
 		__le32 status;
-		struct agg_tx_status agg_status[0];	/* for each agg frame */
+		DECLARE_FLEX_ARRAY(struct agg_tx_status, agg_status);	/* for each agg frame */
 	} u;
 } __packed;
 
@@ -3365,7 +3365,7 @@ struct il_rx_pkt {
 		struct il_compressed_ba_resp compressed_ba;
 		struct il_missed_beacon_notif missed_beacon;
 		__le32 status;
-		u8 raw[0];
+		DECLARE_FLEX_ARRAY(u8, raw);
 	} u;
 } __packed;
 
-- 
2.34.1

