Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DFA3D80BA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhG0VHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbhG0VHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:07:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FE6C0617A0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m1so1862703pjv.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eHJ5K8LiDBXCeTCe7PvgaP3UqQR5uDLvklqQUiAbnC0=;
        b=C9odf/LxM8hQlFgEX94OyyWcybtfMz5fkcvxUOiwkptiFAnxb7Vjc9j5fcILzWzUe0
         9SXGn/8zZ/4rPOmwRPn9BGvFK32z6oyRZbo5d8AQJpThOjubhaqeuoW3W01DCWdHwowW
         ZQKSKYcukTOUL4ao1lnoeA3vzowcOeQgLkBm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eHJ5K8LiDBXCeTCe7PvgaP3UqQR5uDLvklqQUiAbnC0=;
        b=D/dyczlWFvOH0FwyKpEco8Hb2tNydj8gRdrTi2Ez0SkKPbI/acfR3UpCA5Rs511A99
         x6WYaOiU8ZLzXTE0FXOC+dIqZ2Mm78goJreHWD2NKwmZPMGDSpYIWCfRgCfMMn+Qg4E8
         GYzUnsB7KXvh3B0xVwGD3+yhfQ3J1mQa2E/gw8d9bRvKVAIH0lJ/sm9yT1Mm+klaOjjk
         T5nb3emx2zYvpc/HdQAkn5aBh4NuOcQJA4acPOfINj3rJ/MbvKWghcchtMhJT33+aog/
         RRyinPTcnT5rkNl+7/607KL+c6T/cUCOSD93hyhj88FdEUgWiGw2b2tttT+VBipZFc7Q
         PGfA==
X-Gm-Message-State: AOAM531ZBnVknfVHZKxoiPiZg1iDEWN7R8amiIQVlKCJZfNFOT8V7/7p
        BcjLhB1OzVuDN956ZfT9Ky1g0A==
X-Google-Smtp-Source: ABdhPJyiPLiIxF0eZ6Ht4eersAStzTtAa77UuUUu3QKRioXbvWIKsuENyKgvU1Bb8BbQdCxPR7B6MQ==
X-Received: by 2002:a05:6a00:cc1:b029:32b:8465:9b59 with SMTP id b1-20020a056a000cc1b029032b84659b59mr24967310pfv.66.1627420018950;
        Tue, 27 Jul 2021 14:06:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r128sm4687668pfc.155.2021.07.27.14.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:55 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 63/64] iwlwifi: dbg_ini: Split memcpy() to avoid multi-field write
Date:   Tue, 27 Jul 2021 13:58:54 -0700
Message-Id: <20210727205855.411487-64-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; h=from:subject; bh=s7Xq57zTgnpQLZW9o4dFqvke+b60yZlygvvLnoMj4dM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOO7ylJm1Pef8Nw2Y9AVMYN/aYHsm9YN/NkJMM0 14MmcVqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjgAKCRCJcvTf3G3AJh5wD/ 0a9KvpCqyFZ9QKAdlblaiFHTvLu6J0I4KvuS/Pu8WGvbtdHoFcEc1A0J0FqancucuNe2oN76GijGN8 ZmNxkbLuDowcPvHB1KNKV+y/VKyD/GjTqJSFGbHSgE1d3XVQUqA8M80luRN12bHJex3vWEGlQIgVUS eo5mVVxa1vQFLA/APQtdO4QC3S0Rxaeq//vH7IZ+y8uTxf7ChRZtqCWERhOu6zi0YYM7UsadKsQ1UW kuKw1BHS6rVbpMLujJWWAPEyxEe0W/MD7sUJar7lh/sg2nbnVIlvXob+LuNF5xQtZwtIVnlj1/Tx1c JeZYoyxgw4/uvoQF/VaOiL8Fb1Mky8hA3J0Q0KSrMfDlDYr2psRQCz/wYgNiK8aZmkNvU6EyldhpRR jvpt2FEuN89iS51ofpMkKT9jWkj2G2IJnYUpSSBDS7x/6U33s9hWYtpjYFkmrtQS+KN+/zM7e0Wq85 h9kdtxEMB5GcqKunvfEzrJH/6l30zcuWdtxzKr+5eUMIzfT4m7IfJftQW1OHHiIRW8y1i2y9mOZGde lSqRZZ+xSG98+pb5deEI05oPi7AOE1XKeHnMMfVyygop9nOeSAmsJJWm+ExFOnNUkiTzMkM+sJqqiU uZuZWsn+50meKz7mBFEHFWpt++2rlXLf2jFCbTMaiMMKok79IQfcYfkHRDkg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid a run-time false positive in the stricter FORTIFY_SOURCE
memcpy() checks, split the memcpy() into the struct and the data.
Additionally switch the data member to a flexible array to follow
modern language conventions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h     | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 9a8c7b7a0816..226ccd3a6612 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -116,7 +116,7 @@ enum iwl_ucode_tlv_type {
 struct iwl_ucode_tlv {
 	__le32 type;		/* see above */
 	__le32 length;		/* not including type/length fields */
-	u8 data[0];
+	u8 data[];
 };
 
 #define IWL_TLV_UCODE_MAGIC		0x0a4c5749
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 0ddd255a8cc1..f4efddf3e3c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -71,7 +71,8 @@ static int iwl_dbg_tlv_add(const struct iwl_ucode_tlv *tlv,
 	if (!node)
 		return -ENOMEM;
 
-	memcpy(&node->tlv, tlv, sizeof(node->tlv) + len);
+	memcpy(&node->tlv, tlv, sizeof(node->tlv));
+	memcpy(node->tlv.data, tlv->data, len);
 	list_add_tail(&node->list, list);
 
 	return 0;
-- 
2.30.2

