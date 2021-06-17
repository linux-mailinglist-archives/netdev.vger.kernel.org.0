Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E873ABA69
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhFQRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhFQRRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:17:33 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B394C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 10:15:25 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m2so5475323pgk.7
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 10:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1zD+T81jZZgZpyjFh0xFUsdQjL/HhqmGe6jBuS5LlYM=;
        b=VNTKhE5cST2J0ZnjsR5r3QutKIJAPxdYyKrH0WhAhImj92y8rywVUrDhn5E6UvCEVs
         jnF1hD2ZBj/+9soV3yLKupEXB/gCaqaptyKZ21N5+glwJDNV3wZyO1x4mJqmk61zA06g
         7ijTYSH+TXIBumKzmNqYu2FWwdSDsDboZTmT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1zD+T81jZZgZpyjFh0xFUsdQjL/HhqmGe6jBuS5LlYM=;
        b=BJylCtVAWw/r0nne0U0MuDSK8b3nKe2OSTc/nWnwx2Nw3FEy7boYGXeGyXjC3U88tv
         HNq4CTPCH7KqCA12bFKAVWpjLhwNRQdpyQ39iHStPgXrdW5M+HwyLBuih0t6TCyFQI8B
         iYzoDIsyKuueKHOj4OZ/b+GgzTnywscpe7zkHu0mcMJuyD7ia/p2NGD/nXrHBjLy3nCI
         RvhdFGhp51ZBDbmGNNh35djl2rAZZ665K5Vz4LptKR02NUJsl3AgGr2fxqaKl+m8Xi7V
         TRiMuavHwXl2apwSQAHtxpA1DNFGTzuIdCCTKAOmUKlbUv0Z9UsRp46cXYdYbXScB4vW
         IlRA==
X-Gm-Message-State: AOAM531DsrSnJnQ2NDXGx1s5eyyKpO4H9b1OpkZaMlMf7aVu11+Q4wdg
        8nW3xszyPQGDp48uzsexB1BaQQ==
X-Google-Smtp-Source: ABdhPJz+2jMCBEzFuT+7hJ4eMDlrWtKm4cUhhJRiazj6nJ5uWZLUBTK9YaUYt7u9fLzPz5cyGpDL8g==
X-Received: by 2002:a63:c112:: with SMTP id w18mr5792064pgf.375.1623950124830;
        Thu, 17 Jun 2021 10:15:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q21sm6146371pfn.81.2021.06.17.10.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:15:24 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] mwifiex: Avoid memset() over-write of WEP key_material
Date:   Thu, 17 Jun 2021 10:15:22 -0700
Message-Id: <20210617171522.3410951-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=8ee66baceadd27f658a8dfa2fe3397021a28ad22; i=BArkIcxklEnQKmH2E0CxJuEpf2GPz0bKINbIuaIaeGg=; m=QhaE3cdmOtrz4D6MWzL5ksVjqyQuqa6XFh/VF/68Fns=; p=0XEJ9f86jVziXDyuQV+SK180J33uce0FHTOpZ2MXGNU=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDLgykACgkQiXL039xtwCZAaQ//VPH Acw4YzlV6FoySvgPI2F9hIrqIUecqEJLuZXlKbEO/+XVh/E+asMJRVYfC8aixmaMj6xJGj+PKKpZL Qrk94z5tRQ12XIVKK+5/EOykBXLcclyyn+JsVbXH51ofvofhAHUw6MldFBCNgWVH0NIJe9zWdpwdx DORMsA2AjLkCAjNXBaiWktvfyy+PWhR7bqZwYK8Bhhz76nmlRsWR1tDb8lQUfD5Kpk9ohIBpuXMpj cey5gKDWIc+ri9vCGuF6P/Vq+3/jSvmB0mn0BdiWeito+OxIETfM4rOjwTBCKRmgT93Mn56Qg5S+h wWM+thXDZ78dKqiFlhgzeMjHM5k7nrMaMb5sLB00j9Pvu289BTmS8I8Nl4UJDQpMwGNmqgcqkkAKv c52rJ7yMm3w6VW7e1J3AEGNT8G2WH+VmebmyIGkJgjkZErnFrS4GgAqwZT3IdrHfcTTehxJ1gPOa7 1oL6gBBsos0Qx0bi9/dz7WNFYo6XCL52zVjGtJ8bZ7jHbnwmZ41fwJ/Bfi+GYTPJDTKKz5/vXh1gf 8q+hJIBNOd7tM6eY+BM9zwrD0GZVuDRHZvk+Dkt/rQe5RJ7gGnHWFmJJ/E4MxuBetyxVM4LORtedk 71BXhfbgPNN1AMJeYNwRTL4T6u2r7FgjFMUFbo3wY+ezV1dW71gAD/NSOyez5KcM=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring array fields.

When preparing to call mwifiex_set_keyparamset_wep(), key_material is
treated very differently from its structure layout (which has only a
single struct mwifiex_ie_type_key_param_set). Instead, add a new type to
the union so memset() can correctly reason about the size of the
structure.

Note that the union ("params", 196 bytes) containing key_material was
not large enough to hold the target of this memset(): sizeof(struct
mwifiex_ie_type_key_param_set) == 60, NUM_WEP_KEYS = 4, so 240
bytes, or 44 bytes past the end of "params". The good news is that
it appears that the command buffer, as allocated, is 2048 bytes
(MWIFIEX_SIZE_OF_CMD_BUFFER), so no neighboring memory appears to be
getting clobbered.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      |  6 ++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 ++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 470d669c7f14..2ff23ab259ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -995,6 +995,11 @@ struct host_cmd_ds_802_11_key_material {
 	struct mwifiex_ie_type_key_param_set key_param_set;
 } __packed;
 
+struct host_cmd_ds_802_11_key_material_wep {
+	__le16 action;
+	struct mwifiex_ie_type_key_param_set key_param_set[NUM_WEP_KEYS];
+} __packed;
+
 struct host_cmd_ds_gen {
 	__le16 command;
 	__le16 size;
@@ -2347,6 +2352,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_wmm_get_status get_wmm_status;
 		struct host_cmd_ds_802_11_key_material key_material;
 		struct host_cmd_ds_802_11_key_material_v2 key_material_v2;
+		struct host_cmd_ds_802_11_key_material_wep key_material_wep;
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_mgmt_frame_reg reg_mask;
 		struct host_cmd_ds_remain_on_chan roc_cfg;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index d3a968ef21ef..48ea00da1fc9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -840,14 +840,15 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 	}
 
 	if (!enc_key) {
-		memset(&key_material->key_param_set, 0,
-		       (NUM_WEP_KEYS *
-			sizeof(struct mwifiex_ie_type_key_param_set)));
+		struct host_cmd_ds_802_11_key_material_wep *key_material_wep =
+			(struct host_cmd_ds_802_11_key_material_wep *)key_material;
+		memset(key_material_wep->key_param_set, 0,
+		       sizeof(key_material_wep->key_param_set));
 		ret = mwifiex_set_keyparamset_wep(priv,
-						  &key_material->key_param_set,
+						  &key_material_wep->key_param_set[0],
 						  &key_param_len);
 		cmd->size = cpu_to_le16(key_param_len +
-				    sizeof(key_material->action) + S_DS_GEN);
+				    sizeof(key_material_wep->action) + S_DS_GEN);
 		return ret;
 	} else
 		memset(&key_material->key_param_set, 0,
-- 
2.25.1

