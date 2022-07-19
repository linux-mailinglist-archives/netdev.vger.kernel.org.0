Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8957A62D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbiGSSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239906AbiGSSKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:10:30 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BBF49B65
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:29 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id v1so4456481ilg.4
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/3MfEitAhQ9m4E4qshsdwyq7KEKS1kBLIYYx8abdrwU=;
        b=TZsIhSJTBMWwUdtFn9SdzGFEBkIEt7VEc5hLI+MOxa/tg7n2v9bpQi6ip9v/QG2iTK
         Qaz5UvLQewEPwkpNGixWzAijnOGNseRYImRHPEg8hwp29exhXSwN/e1mhaD9lslz5hEi
         FgjSxqwxN50uBlo9AzeSnrTsdxB0sJuTpUnhQfDM8Ds2hoQRxY52VTAeRCgT6kUPV0gQ
         ibYnTfKReRhs25zWt2qMfIEQBc1cYE3Y2Ty8V7BtMG4dhEbFOf0Qbwh7bvgMAbcK5xBK
         QOwOzFz8DUHOh/pVlPUGdVOEYiJhuN96qCJcM4WQsu0wr4y1+BgTCtrq4ZQdoMsCTrMp
         kH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3MfEitAhQ9m4E4qshsdwyq7KEKS1kBLIYYx8abdrwU=;
        b=7QSiAyt5pI0CwzCdTB+nxrjniqt9/hMdct36iVDWjPDfhA3ldiJLgVC9wx9Onic111
         V3usDop+TBX3cTX/5LxZsIKkNJ/L1+tBHDHT/pc67xW/r6DS+BF2RRfz0cd76tWHCPWH
         Av1VggB9o6R/ceyfmEeqtiYftk1DtXlgR6xqFbiks1jgXE52L0tFoE4PjH0yTg0VbyL7
         hZBxGRYwKbTCbr1BZbvvD9ARp8bAf8OfqJMyvMiJ6seo8EAlOBCweu1FZgkmugzFeDIa
         GOOKFJpwTpPLmWMXWTqVQUv7g3P17FZopsej7p/DmFAggT+d5EycQ2Z3EpwIqGf7yuQT
         xQUA==
X-Gm-Message-State: AJIora/PIp6XiWgwgTHm6sdZ4gDwQBefIBe5bbNGKWO04phNC2elejwR
        itO4JbHntlgo2NxMbVHNySTC7w==
X-Google-Smtp-Source: AGRyM1sn7FBERUYrR/ZZP+/wK8XOYGVK73yeLvwb5PyiIU82qXUYzUSU61ptK51fzkm8K9NVNRSDXQ==
X-Received: by 2002:a05:6e02:1bcd:b0:2dc:dc40:c08f with SMTP id x13-20020a056e021bcd00b002dcdc40c08fmr7563904ilv.18.1658254228381;
        Tue, 19 Jul 2022 11:10:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm6089552ilu.56.2022.07.19.11.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:10:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: ipa: skip some cleanup for unused transactions
Date:   Tue, 19 Jul 2022 13:10:18 -0500
Message-Id: <20220719181020.372697-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719181020.372697-1-elder@linaro.org>
References: <20220719181020.372697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_trans_free(), there's no point in ipa_gsi_trans_release() if
a transaction is unused.  No used TREs means no IPA layer resources
to clean up.  So only call ipa_gsi_trans_release() if at least one
TRE was used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 3f52932e9e413..55987e35af2dd 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -404,7 +404,8 @@ void gsi_trans_free(struct gsi_trans *trans)
 	if (!last)
 		return;
 
-	ipa_gsi_trans_release(trans);
+	if (trans->used_count)
+		ipa_gsi_trans_release(trans);
 
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
 	 * (if present) info[] arrays, plus the transaction itself.
-- 
2.34.1

