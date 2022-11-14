Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90DD628CDB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbiKNXBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiKNXBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:01:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B63DF3A;
        Mon, 14 Nov 2022 15:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7229AB815BA;
        Mon, 14 Nov 2022 23:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428AEC433C1;
        Mon, 14 Nov 2022 23:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668466888;
        bh=7vxLPswcjDt5sJNpB3JWA/pifmsgpJ0fVOFRK4RZzQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uv1RHymXyPi1Y+qXIJVQkExNcPxqHsB4Rf6B8xEIz99EdAoVmNLTmGAc8VvARV7ak
         b80sjhPtAycLcDPGX9PbFNZiOu68a1s46vLmQ3v8iQpXrfbyzl/3xMJ96NBeIMkFbo
         Nyx36gwejzmGhoPwt7VO3tqu1JC24D+7PQLRyUVTq3r64o9+kL8bBTh2/v9KQ4jJNF
         lLaVlXTavAu6mnLNgRA44g5iX6Vlb8vbD8ihOmc0u1ohML/ispTztME2YzfPIFU0sc
         dn98bt5YraBXDQfGt+OxhSTjj1kZmv2TUlHvQqSSS2iqDkokHxIcgcQzhr+EUp7f1u
         BcLOkVGx2eHqA==
Date:   Mon, 14 Nov 2022 17:01:11 -0600
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
Subject: [PATCH 1/2][next] wifi: brcmfmac: Replace one-element array with
 flexible-array member
Message-ID: <7694550aa9a2753a73a687f61af9441c8cf52fd7.1668466470.git.gustavoars@kernel.org>
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

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element array with flexible-array
member in struct brcmf_gscan_config.

Important to mention is that doing a build before/after this patch results
in no binary output differences.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
on memcpy() and help us make progress towards globally enabling
-fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/241
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index f518e025d6e4..62f65dc6a3b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -1049,7 +1049,7 @@ struct brcmf_gscan_config {
 	u8 count_of_channel_buckets;
 	u8 retry_threshold;
 	__le16  lost_ap_window;
-	struct brcmf_gscan_bucket_config bucket[1];
+	struct brcmf_gscan_bucket_config bucket[];
 };
 
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 170c61c8136c..7c5da506637f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -405,7 +405,7 @@ static int brcmf_pno_config_sched_scans(struct brcmf_if *ifp)
 	if (n_buckets < 0)
 		return n_buckets;
 
-	gsz = sizeof(*gscan_cfg) + (n_buckets - 1) * sizeof(*buckets);
+	gsz = sizeof(*gscan_cfg) + n_buckets * sizeof(*buckets);
 	gscan_cfg = kzalloc(gsz, GFP_KERNEL);
 	if (!gscan_cfg) {
 		err = -ENOMEM;
-- 
2.34.1

