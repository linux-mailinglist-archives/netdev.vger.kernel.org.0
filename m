Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991AA49F4D3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347142AbiA1ICV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347134AbiA1ICU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:02:20 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5D1C061714;
        Fri, 28 Jan 2022 00:02:20 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id k4so5142363qvt.6;
        Fri, 28 Jan 2022 00:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yW5QG4rrD+/B7qft18hixZxkbtsm5e7Opd0+mp8n/tQ=;
        b=ZQ5KH9rsnCvPqVlpfKt2Dl+27bHWqwXcMC9s80qKI8UZvoetp+9Vs47sQ6feBKXhZ5
         zgO0IGj6dcDES6niuOwQbvlqFzlS1ljzVFK6kblwxoLCLNzqrzcmgs6Pkd26u1opzEnd
         6eloov3mwrLv3gMcZqhGfAJvLuGaiqG7QU/oOppaICT6x+Yt3VUOoiRH07vVsC0x4bWt
         Fp2SoGIs5TBUF/EKe7Q3IqTAiTX63mhzha9Fk3dmOLKNqLjHLY8KmgSGGsbYT/wqcRF5
         w2D8bYnhp8Z8Ja36ykln6g/ni6m1aKi1h1P2ca5lZEEmq1mvloKkJ+l+ovLCDGPBbmyd
         ZDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yW5QG4rrD+/B7qft18hixZxkbtsm5e7Opd0+mp8n/tQ=;
        b=YMn95Pw1x1zhjY66CYLpciGRWIWtSo6QIoGbDM3QBelv/yku72du5fAxJ3HE58lii3
         C0EZIkm+g0x53vjxiKZ6emylxdrqo5nBcnn5XzCkC2g1dyuSH6w4OH8L0n2Mou5FW7uM
         byCYqRdk0ci5Ewd0wO2TkbXgKOtQVuYjkiMPWRt4eoJBmLr7OvFAn6qDRRBXlloYMGEb
         1lDrQhSph3cKnorm2Sgng5NpHLGTXOae3onZ+09yOVrXPcM0grkLS8eR447kA6Yy7YZ1
         H97ZoGNT06BDyW0fPdf7xIUc8s0U2+pl8cXgRGYpGBpskWqj1QsvZJlWdNc1SpcyQVO0
         999A==
X-Gm-Message-State: AOAM530u+saTFRkJMUFIVTCUpoFl8Al+YpUQ5oxLGTw1OGD/6xS5GuRD
        1Z9kfdma19zvtM8n6YKwFSs=
X-Google-Smtp-Source: ABdhPJzbPCyORNv0otx9NukxaXsWEZhHv/AeIerNzf5LU2/lH/Ffr/tPr0UsC5suG5HSgJY0a6cU2A==
X-Received: by 2002:a05:6214:300c:: with SMTP id ke12mr6236897qvb.56.1643356939934;
        Fri, 28 Jan 2022 00:02:19 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c4sm2814908qkp.0.2022.01.28.00.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 00:02:19 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     luciano.coelho@intel.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        trix@redhat.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] dvm: use struct_size over open coded arithmetic
Date:   Fri, 28 Jan 2022 08:02:06 +0000
Message-Id: <20220128080206.1211452-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct iwl_wipan_noa_data {
	...
	u8 data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index db0c41bbeb0e..d0d842b25b86 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -915,7 +915,7 @@ static void iwlagn_rx_noa_notification(struct iwl_priv *priv,
 		len += 1 + 2;
 		copylen += 1 + 2;
 
-		new_data = kmalloc(sizeof(*new_data) + len, GFP_ATOMIC);
+		new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
 		if (new_data) {
 			new_data->length = len;
 			new_data->data[0] = WLAN_EID_VENDOR_SPECIFIC;
-- 
2.25.1


