Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB0862A485
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiKOVxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiKOVxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:53:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D4813EB8;
        Tue, 15 Nov 2022 13:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDB54618F5;
        Tue, 15 Nov 2022 21:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CA0C433C1;
        Tue, 15 Nov 2022 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668549223;
        bh=1/A6DlUT7AQ50h5Usn7ksWgo6qyQMDQggwXLiYYZZFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E77KupNN5UhHHN2DjW4uu0qINjVti3ELuUQkgmn/bJzgSDQoRuBtxopEnk0+7UmYH
         rpPVPHC7m3IMJ4qgYLkKoYtluj58Exuk5OIsR3HydqsBcoC5xaY7w0u8lvKAIHc4mq
         BiJMA2qD6bySjYmZMKmzLEpEa7FpA6FG9n6tW/OsrKRXB9w3Q36KlUv90veVoYrSTr
         fqF9FTNtP/GifzXPEc1qIovlYyzZShmBKh5CYq2MxAhPH4GKtFM4vxzbQWtN4PUl3V
         kfZ+KAatxyrlA7UbRHRhvJs7TK+iQARjLJ7VLXCQyh61ybvCPwd+N2cpO9l5Ag0ZH9
         1YlxwgJKPJ1xA==
Date:   Tue, 15 Nov 2022 15:53:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/2][next] wifi: brcmfmac: replace one-element array with
 flexible-array member in struct brcmf_dload_data_le
Message-ID: <905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org>
References: <cover.1668548907.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1668548907.git.gustavoars@kernel.org>
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
member in struct brcmf_dload_data_le.

Important to mention is that doing a build before/after this patch results
in no binary output differences.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
on memcpy() and help us make progress towards globally enabling
-fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/230
Link: https://github.com/KSPP/linux/issues/79
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c     | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 22344e68fd59..2e836566e218 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -110,7 +110,7 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 	dload_buf->dload_type = cpu_to_le16(DL_TYPE_CLM);
 	dload_buf->len = cpu_to_le32(len);
 	dload_buf->crc = cpu_to_le32(0);
-	len = sizeof(*dload_buf) + len - 1;
+	len = sizeof(*dload_buf) + len;
 
 	err = brcmf_fil_iovar_data_set(ifp, "clmload", dload_buf, len);
 
@@ -139,7 +139,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 		return 0;
 	}
 
-	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, GFP_KERNEL);
+	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN, GFP_KERNEL);
 	if (!chunk_buf) {
 		err = -ENOMEM;
 		goto done;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index f518e025d6e4..a69339f72c66 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -943,7 +943,7 @@ struct brcmf_dload_data_le {
 	__le16 dload_type;
 	__le32 len;
 	__le32 crc;
-	u8 data[1];
+	u8 data[];
 };
 
 /**
-- 
2.34.1

