Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB4552F3EC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353302AbiETTng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353287AbiETTn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B2F199484;
        Fri, 20 May 2022 12:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 647B761C1A;
        Fri, 20 May 2022 19:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D2AC3411A;
        Fri, 20 May 2022 19:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075806;
        bh=BsskcfHl/eEdw8cldU32XfsJ2GFxBUuduFu3FrECxWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNQ9G5LJ/i8yRpHkY51jcEOw3Igs/cRjgDFCNjzzn98rwS1csT+Go5dTYI9gNuEYd
         me8pCC6wzl02gh1R96sDPLRpktjpH4QXom1kCibdcHHe2r8SeaXQ0U9dFGrihQVPya
         EOY8b8rvLUVrkgq7y//OMJ55WeRglxkPe4nNDJ2LzAM2JTW64reIK3u5b36/15dtQA
         U1ZAOZCkk1ZwUbk93DaQ4d7/DITXIEOWcMXRr8LJj2IrtYb5ByIxBAzLDzwPC2Cr6k
         1LZSl/GVgznNZoHuKXo8ah+DNuz98HN6TZtoQv8ulYkmj/zU6Qy93fk8fWDu/Ln4eT
         iJzBqmtdKkLUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, aspriel@gmail.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        ALSI@bang-olufsen.dk, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH net-next 6/8] wifi: brcmfmac: work around a GCC 12 -Warray-bounds warning
Date:   Fri, 20 May 2022 12:43:18 -0700
Message-Id: <20220520194320.2356236-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 really doesn't like partial struct allocations:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2202:32: warning: array subscript ‘struct brcmf_ext_join_params_le[0]’ is partly outside array bounds of ‘void[70]’ [-Warray-bounds]
 2202 |                 ext_join_params->scan_le.passive_time =
      |                                ^~

brcmfmac is trying to save 2 bytes at the end by either allocating
or not allocating a channel member. Let's keep @join_params_size
the "right" size but kmalloc() the full structure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: aspriel@gmail.com
CC: franky.lin@broadcom.com
CC: hante.meuleman@broadcom.com
CC: kvalo@kernel.org
CC: ALSI@bang-olufsen.dk
CC: linux-wireless@vger.kernel.org
CC: brcm80211-dev-list.pdl@broadcom.com
CC: SHA-cyfmac-dev-list@infineon.com
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 360b103fe898..605206abe424 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2167,7 +2167,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		offsetof(struct brcmf_assoc_params_le, chanspec_list);
 	if (cfg->channel)
 		join_params_size += sizeof(u16);
-	ext_join_params = kzalloc(join_params_size, GFP_KERNEL);
+	ext_join_params = kzalloc(sizeof(*ext_join_params), GFP_KERNEL);
 	if (ext_join_params == NULL) {
 		err = -ENOMEM;
 		goto done;
-- 
2.34.3

