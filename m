Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64770628CE7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiKNXC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiKNXCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:02:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677301AD95;
        Mon, 14 Nov 2022 15:02:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0341461496;
        Mon, 14 Nov 2022 23:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DE1C43470;
        Mon, 14 Nov 2022 23:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668466943;
        bh=atvqHdQO4CQz5dyA9Aq/ZbZb/2LT5b1pm3IB1f6BEtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1RAO+mYJIKOiqI9PduVuH5ox7UFRxuY8OrEa3EcVGGJGjUlJfcX1lSB/nCVt1ao+
         HKeDoFnSR22leKuODBTvqMFdBEaRizKnHXvS+ZQYRoIVaynfBGK48r70/MGDo+9deS
         SYNTdXVP9Yr7pnn/Zf+xEpcvFUmDVGU2c1GQAGHg9+6kxh5WKOSju7ANg2c64i0KJB
         thUfF+9r2zxlZ+cDb058lle+BnPgzYJHFg5R6WTe//2CSV9/N4RI2ARQh+CMHrQp08
         99Ul7qUWHWQPrDYNM7G3AvDWz9zQkWAH+c/E29bKc/Y1E+ANkShpNYgf5sgg8HRX6L
         Bhf/lknvkid6Q==
Date:   Mon, 14 Nov 2022 17:02:06 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/2][next] wifi: brcmfmac: Use struct_size() and array_size()
 in code ralated to struct brcmf_gscan_config
Message-ID: <de0226a549c8d000d8974e207ede786220a3df1a.1668466470.git.gustavoars@kernel.org>
References: <cover.1668466470.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1668466470.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prefer struct_size() over open-coded versions of idiom:

sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count

where count is the max number of items the flexible array is supposed to
contain.

Also, use array_size() in call to memcpy().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 7c5da506637f..05f66ab13bed 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -405,7 +405,7 @@ static int brcmf_pno_config_sched_scans(struct brcmf_if *ifp)
 	if (n_buckets < 0)
 		return n_buckets;
 
-	gsz = sizeof(*gscan_cfg) + n_buckets * sizeof(*buckets);
+	gsz = struct_size(gscan_cfg, bucket, n_buckets);
 	gscan_cfg = kzalloc(gsz, GFP_KERNEL);
 	if (!gscan_cfg) {
 		err = -ENOMEM;
@@ -434,8 +434,8 @@ static int brcmf_pno_config_sched_scans(struct brcmf_if *ifp)
 	gscan_cfg->flags = BRCMF_GSCAN_CFG_ALL_BUCKETS_IN_1ST_SCAN;
 
 	gscan_cfg->count_of_channel_buckets = n_buckets;
-	memcpy(&gscan_cfg->bucket[0], buckets,
-	       n_buckets * sizeof(*buckets));
+	memcpy(gscan_cfg->bucket, buckets,
+	       array_size(n_buckets, sizeof(*buckets)));
 
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_gscan_cfg", gscan_cfg, gsz);
 
-- 
2.34.1

