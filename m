Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C513F6C53B8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCVS0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjCVS00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:26:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1865C1ACFD;
        Wed, 22 Mar 2023 11:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BABD1B81D85;
        Wed, 22 Mar 2023 18:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A43C4339E;
        Wed, 22 Mar 2023 18:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679509582;
        bh=Gj//SU+GqNJVcAvg1NerL5+h1QTTjvjmzdALEMxq4XE=;
        h=Date:From:To:Cc:Subject:From;
        b=VSoBQS5iyxCUOUFLpB0RDnus8HHV4Lq8N7ODEhvT0HqT8ClGw3b8RlxNcRZEtvKdh
         So+6vuad2V0nVQmVgFvnUoGXBwKQXOtACLrjaqsy6ccQSvukwYmZvUwx98aF2xby9M
         ossP6QBJ5Vc0Eu7XF2f9UBjZ/JBz4AR8nVpWkZtJrdCDxD6V6YAg6rQ4VGWoHYtvsc
         QLgreyQZgFc3F8AU9Al5sKDSSwWzyU9s/y2lE/7CHsWHdjhCqyX5HAyT8uy4O3Kjng
         PJzNbFRSQb15jFtjtvdvyZpBKvquMal4eNmUvScyQr34UiNxLXvjPhIBpOxTmXCZfY
         X1foNftxqlxXA==
Date:   Wed, 22 Mar 2023 12:26:53 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: rndis_wlan: Replace fake flex-array with
 flexible-array member
Message-ID: <ZBtIbU77L9eXqa4j@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Address the following warning found with GCC-13 and
-fstrict-flex-array=3 enabled:
drivers/net/wireless/rndis_wlan.c:2902:23: warning: array subscript 0 is outside array bounds of ‘struct ndis_80211_auth_request[0]’ [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/274
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/legacy/rndis_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/legacy/rndis_wlan.c b/drivers/net/wireless/legacy/rndis_wlan.c
index bf72e5fd39cf..54c347fa54c4 100644
--- a/drivers/net/wireless/legacy/rndis_wlan.c
+++ b/drivers/net/wireless/legacy/rndis_wlan.c
@@ -209,7 +209,7 @@ struct ndis_80211_status_indication {
 	union {
 		__le32					media_stream_mode;
 		__le32					radio_status;
-		struct ndis_80211_auth_request		auth_request[0];
+		DECLARE_FLEX_ARRAY(struct ndis_80211_auth_request, auth_request);
 		struct ndis_80211_pmkid_cand_list	cand_list;
 	} u;
 } __packed;
-- 
2.34.1

