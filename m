Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5C530028
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 03:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348740AbiEVBAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 21:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbiEVBAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 21:00:07 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A1D39BB9
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 18:00:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id o16so7732008ilq.8
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 18:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9nHOW+mnraB1XiSAtyqCqOmXRY0ima8MXF2hLYPrgyI=;
        b=tpNTJG3yM9Wz/y9QSl4vuGOCtsfjCxWgtWGDVssv2nSWwap6tnYkjE8HfUean1dleN
         xao8+lCvbkVBReXqb1FDVdzUz8N+P7BF8zrKfOipG7X45gGqumqVdxZUNhFSQd+yk1Uf
         zodhLnVEiarAswjBaNTIezlIOtclDKLgXqCgycRjD8887HkF5YKXNvZ1qCipPZe8/2Xj
         SsxuH4CBqBeUW1Fg6c5bX2u/Q5HQIcJiDuvd+mYET2DKDkN1GjIbxX7jPa1r3R5sb3xr
         2EtxKFFVq38XsoVqRhd/t91Mb1It69uN6czQ8Euhj7pM/Duc3jEKTq9J7uwNiLntEukn
         1g7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9nHOW+mnraB1XiSAtyqCqOmXRY0ima8MXF2hLYPrgyI=;
        b=cHUtBCkY5tYvei2vGhCYJ/tPEzXQxw9NX2Yk5Cv0Ng1qa1v8SHC8jA4bDQvV1pqxbM
         u4TXb0T8QHKenNN8IT3fVLgOWUkpkyGNcm+jj1pFIkOGvFabLsSnVFGV3sJD+Y3M+/fw
         /ymnhhUylKzWPDf15oAWT96R1rGn5lLSVKO5cgf2DIXIE7jCZ+V04CZsoYqiGPoGzQMK
         J0FOytp6f5OA3KE4VrKOYZteYVtl9Ho0zeSlH48WV/pros8/Ib316CoxZTyhOjyEzrAw
         nEZin7jRQR/iBunfMiJrtPReyEAFWSwR9IPqzqizTbFfWRe8sGNceQm2A64ykcPmeo+v
         QMzg==
X-Gm-Message-State: AOAM533A3KOwhD52HEB4syFgSXAzOkmCRmMLpWWGmP0867GnC7QhdS5v
        sdSM4KEXqbkbz2/9HJSq2X0Ccg==
X-Google-Smtp-Source: ABdhPJyjzHZPVoBDJOxEv9fzA9x6b3lvvd+2e2BtVOlQacms8+7X1Chb1aTuAc+8iH11Eim6GoHrwA==
X-Received: by 2002:a92:d486:0:b0:2d1:19cb:9eba with SMTP id p6-20020a92d486000000b002d119cb9ebamr8075908ilg.29.1653181205689;
        Sat, 21 May 2022 18:00:05 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t21-20020a02c495000000b0032eacab7e07sm939366jam.93.2022.05.21.18.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 18:00:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Sat, 21 May 2022 19:59:59 -0500
Message-Id: <20220522005959.1175181-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220522005959.1175181-1-elder@linaro.org>
References: <20220522005959.1175181-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the (possibly compound) pages used for receive buffers are
freed using __free_pages().  But according to this comment above the
definition of that function, that's wrong:
    If you want to use the page's reference count to decide
    when to free the allocation, you should allocate a compound
    page, and use put_page() instead of __free_pages().

Convert the call to __free_pages() in ipa_endpoint_replenish_one()
to use put_page() instead.

Fixes: 6a606b90153b8 ("net: ipa: allocate transaction in replenish loop")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 675b7135644b8..dac4845cf596c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1062,7 +1062,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 
 	ret = gsi_trans_page_add(trans, page, len, offset);
 	if (ret)
-		__free_pages(page, get_order(buffer_size));
+		put_page(page);
 	else
 		trans->data = page;	/* transaction owns page now */
 
-- 
2.32.0

