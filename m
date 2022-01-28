Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EC149F660
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347582AbiA1Jb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiA1Jb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:31:56 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694A8C061714;
        Fri, 28 Jan 2022 01:31:56 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id e16so4675420qtq.6;
        Fri, 28 Jan 2022 01:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AP1h4mmbYl/TcSR22YZ3H/TBAUMfkHF801G8StLbLHc=;
        b=C/xJnGSBeUPtZEo3oZ7dkTKSxGAVE5QdjPJ3cOF0XllUEzsU28PfeApgvtYq9Bwk0y
         0p8UpZ8PN563gqWIR08/rK0ubUfX3qWVsyr7YsdIhCMIbeO6uE9d8ro+FMFJVqOfERHn
         7+In7yrYxu7CqzHkNNa8hH36wDFJwsGMS45APF1qdGgobEBpbexqIEEB7yhu6kz3veyo
         d+IaIc9nZJ95GkzFnO0gJl3hikix0scxHJXPJZT2Fyl8dZXLQBrh/YX8bKS5evoCXNYV
         YrB3/Qx7sTOMg8eXpFnANVP4OlKMmnxaKBZWMNEacJc4tw6USdZG2YJeitcDRzVrhJZS
         CeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AP1h4mmbYl/TcSR22YZ3H/TBAUMfkHF801G8StLbLHc=;
        b=OUY13tsl/bqc5Liqm+VlB6aPISjN4/lD/ZHST0kFNmCYc9bia/FIhqjEa0L1+O4Ekt
         OAjPvPBTJOevrA00zZJCgkuaSQUS9Z1Z1hBUwL8YfSCe4uHUrPwU/C2sNWmDxFdileya
         hTkCrxKWy6QsRbwszi59zsOqu7qpWXuPF98yeO5DMKyU20KsTzHUkc4giC8+nswZtWxD
         0dqVfDgCIpGB4RPASmV5ASuXlhI56NfCGkbux7A6eyw7G6YX9zLQ1GTqqHWOTAb9xDat
         cj09Y+AJN9gGdLwlwZ3ieZG7w1B2OtRcqNt/4tKJdx5HK0nySeUK0DBoQqmFo4HZy93U
         lVPg==
X-Gm-Message-State: AOAM532VMYKcR4wcHtj9RFNGeP2TjHPoMPozR1mbCYi62wmY37GXXilN
        v3rPFBiqmWmNEDF2d+ylNyY=
X-Google-Smtp-Source: ABdhPJxhDPY6e509Z8qHrHrl7jd2T9BzQD5YWgFk4lLfsSUrnLfPf/HVZdB7ShhIPEczziCn5Mx/uw==
X-Received: by 2002:a05:622a:13cf:: with SMTP id p15mr5524945qtk.16.1643362315588;
        Fri, 28 Jan 2022 01:31:55 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y18sm2724302qtj.56.2022.01.28.01.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 01:31:55 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        johannes.berg@intel.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org, trix@redhat.com,
        zealci@zte.com.cn
Subject: [PATCH v2] iwlwifi: dvm: use struct_size over open coded arithmetic
Date:   Fri, 28 Jan 2022 09:31:47 +0000
Message-Id: <20220128093147.1213351-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87o83wi67x.fsf@kernel.org>
References: <87o83wi67x.fsf@kernel.org>
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
}

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

