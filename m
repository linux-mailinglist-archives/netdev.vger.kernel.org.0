Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CB557C29F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGUDW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGUDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:22:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE81E47BA9;
        Wed, 20 Jul 2022 20:22:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c139so584408pfc.2;
        Wed, 20 Jul 2022 20:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tmOBFYH42N10hufY6EnMZkuSIJQa7Ph0o+F6wvrL7r4=;
        b=TnvsdkgwV7J+MzZ8FTOfBZhWP0XD7qBQRgy6NZ6A8sIt9Fm2XT5TQcwZgpVeoMCgQu
         dO6/xSi3i4CLjSiF5p5EeoF7EDlWOCEy+EvRerDJLQJGjU3ItvkpFLmJ0L7TN1a5/tr3
         K8Dgx0Fc59Tl3kPLi29F15QXEMMHZ471xtfIeIWa6ZY9MOQ2JUpSTy+tcHzigGcyZJN3
         mPvRqVYHvo/i3yoyKiMpw2ACkh/GZ1TBtSDQcYOZClXxn11qTWo9wtZ4BdmvWSYuiaUD
         OzbcfV9hFFw75Tq0Vc7GcreeN1PsBMFElZSO2w2vphoSyaVcxwXU/S1AJFU94lpi62Ql
         rftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tmOBFYH42N10hufY6EnMZkuSIJQa7Ph0o+F6wvrL7r4=;
        b=jISRjxc6d4w71WyyxAWYY1nY+im66NilllPCBrl6JigaokZ7pFLabR875LzXwYRWWj
         on8br7eSLc4YwA//URXC85uQ6nWLDnthjs+9fEJMLk1LA3TXwfzy0W+iAwf0s9ANtmW/
         rF84GSh/ZRilZf4wI58w+VH5ssyj3n6jmeWlIzLkoIppG2EdZ4xdtxcEmvvjSI0v894r
         0M2GVkhhLxM5r6rxctLdd+huaNwsAAGIXukSZafvABgvSTzbCmhXhU35385CqPcU+NaD
         XZS4gCpdpSZhG57hom9I3xOnCWnkebUTX5DmnEPPi8M09wECP/Gbonur2UyGC7KFxkr7
         6Fvw==
X-Gm-Message-State: AJIora97F9DCEbxjKLlCznAO5/12JBUk6SCnWvilz+boM5BQWX1vbtjE
        /OFlMpXB8eePaShERmPsxmE=
X-Google-Smtp-Source: AGRyM1tORNW2tFg+DpPkRBpx1jCUm6ZAFOaogXfK8IeuYViZnV8Xm2Xx/zCLnP4DdsgcOs40/acSPg==
X-Received: by 2002:a63:565f:0:b0:41a:57d8:a814 with SMTP id g31-20020a63565f000000b0041a57d8a814mr7797545pgm.517.1658373746289;
        Wed, 20 Jul 2022 20:22:26 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id z124-20020a623382000000b00528c34f514dsm391684pfz.121.2022.07.20.20.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 20:22:26 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
X-Google-Original-From: xiaolinkui <xiaolinkui@kylinos.cn>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gustavoars@kernel.org,
        quic_jjohnson@quicinc.com, keescook@chromium.org, johan@kernel.org,
        dan.carpenter@oracle.com, xiaolinkui@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] wireless: ath6kl: fix out of bound from length.
Date:   Thu, 21 Jul 2022 11:21:58 +0800
Message-Id: <20220721032158.31479-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

If length from debug_buf.length is 4294967293 (0xfffffffd), the result of
ALIGN(size, 4) will be 0.

	length = ALIGN(length, 4);

In case of length == 4294967293 after four-byte aligned access, length will
become 0.

	ret = ath6kl_diag_read(ar, address, buf, length);

will fail to read.

Fixes: bc07ddb29a7b ("ath6kl: read fwlog from firmware ring buffer")
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 drivers/net/wireless/ath/ath6kl/core.h | 2 +-
 drivers/net/wireless/ath/ath6kl/main.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 77e052336eb5..b90ad9541e09 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -907,7 +907,7 @@ void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
 int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value);
 int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
-int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
+int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, size_t length);
 int ath6kl_read_fwlogs(struct ath6kl *ar);
 void ath6kl_init_profile_info(struct ath6kl_vif *vif);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d3aa9e7a37c2..e9e66d5ad505 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -233,7 +233,7 @@ int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
 	return 0;
 }
 
-int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length)
+int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, size_t length)
 {
 	u32 count, *buf = data;
 	int ret;
@@ -272,7 +272,8 @@ int ath6kl_read_fwlogs(struct ath6kl *ar)
 {
 	struct ath6kl_dbglog_hdr debug_hdr;
 	struct ath6kl_dbglog_buf debug_buf;
-	u32 address, length, firstbuf, debug_hdr_addr;
+	u32 address, firstbuf, debug_hdr_addr;
+	size_t length;
 	int ret, loop;
 	u8 *buf;
 
-- 
2.17.1

