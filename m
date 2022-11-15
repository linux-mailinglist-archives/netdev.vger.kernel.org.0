Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE5462A48F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiKOVz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiKOVzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:55:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E312C10B;
        Tue, 15 Nov 2022 13:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A8661A08;
        Tue, 15 Nov 2022 21:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869EFC433C1;
        Tue, 15 Nov 2022 21:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668549350;
        bh=iQK5X8lQkyk5IDtQF7i4ML+XXWtDJaKhb1wsrEPYeKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IsTmLPLiQubsT8pjKF4wwwKt6rVvP/OmC9K3DPTAYk942qqAhx3B//gZ0cr++RwTh
         kVIWgdDqsSlsXOFZA1yJ4xQsD0ixOsSL0VHcxRyvSB7X2fAyzWaqD/FQTZZrLgQSqe
         v/qizdtnbbp1tbIpjSXmVoOutKSqhFKeIAtQjZc7yXj9VR/pJarIWIXejHujeMxfRA
         rTz9MWnG7ZCg1eBsYB08owq/tUie28CV7r17ZJJrlpjPp+QCGiPvtoypcLXe8/voSP
         OKaVpr/3z+M2W+3FUAwZmOIl1bCCbdiL83bEbsg15KsDM1lbUOOjK216Qo2lFHNC2a
         mtPn1b0XamrBw==
Date:   Tue, 15 Nov 2022 15:55:34 -0600
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
Subject: [PATCH 2/2][next] wifi: brcmfmac: Use struct_size() in code ralated
 to struct brcmf_dload_data_le
Message-ID: <41845ad3660ed4375f0c03fd36a67b2e12fafed5.1668548907.git.gustavoars@kernel.org>
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

Prefer struct_size() over open-coded versions of idiom:

sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count

where count is the max number of items the flexible array is supposed to
contain.

In this particular case, in the open-coded version sizeof(typeof-flex-array-elements)
is implicit in _count_ because the type of the flex array data is u8:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h:941:
 941 struct brcmf_dload_data_le {
 942         __le16 flag;
 943         __le16 dload_type;
 944         __le32 len;
 945         __le32 crc;
 946         u8 data[];
 947 };

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 2e836566e218..4a309e5a5707 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -110,9 +110,9 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 	dload_buf->dload_type = cpu_to_le16(DL_TYPE_CLM);
 	dload_buf->len = cpu_to_le32(len);
 	dload_buf->crc = cpu_to_le32(0);
-	len = sizeof(*dload_buf) + len;
 
-	err = brcmf_fil_iovar_data_set(ifp, "clmload", dload_buf, len);
+	err = brcmf_fil_iovar_data_set(ifp, "clmload", dload_buf,
+				       struct_size(dload_buf, data, len));
 
 	return err;
 }
@@ -139,7 +139,8 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 		return 0;
 	}
 
-	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN, GFP_KERNEL);
+	chunk_buf = kzalloc(struct_size(chunk_buf, data, MAX_CHUNK_LEN),
+			    GFP_KERNEL);
 	if (!chunk_buf) {
 		err = -ENOMEM;
 		goto done;
-- 
2.34.1

