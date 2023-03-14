Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C796BA0DB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCNUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjCNUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:38:50 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B372A1C7ED
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:48 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id y3so13323424qvn.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678826328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYMbUZDBIlnj1ReCNJ3ahlE/3pJm6Sf1PO2UoSuItdQ=;
        b=ebBgxQE+6bzMw61HnnufNimfW2+ah48mfRzvMc6ZTXSjcOR4+x6Toh/qDthboi7WkX
         3i9LbI5fBkv4ffvyPJPiaa9z/LFS9zYFz7Kbu6EUAOwCFA6zjZDJfQNzNZKujH8tXVGf
         boz7AeF7K9TXCYRy+Km+IwYphLd6uTTNqKrns/nJovS4y20MIP9/QTgSNwuR727QJfK4
         oBrV/4hNHVw5v0Hwwa5JQyElbY8Www+5zWtliSgcN/8nvD0J6hPkLs8wyr0zj4S2GqOO
         xKOaHpoDZGLsyxCymRX7nQgi6WuDgLQbKRNChjDhwtC5C1FUNUOypi3e30BM11snVmae
         iVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678826328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYMbUZDBIlnj1ReCNJ3ahlE/3pJm6Sf1PO2UoSuItdQ=;
        b=flNL50vdJc+i0Ipj54MNO0Vdr0Y1+G/uOtF3ZpFkq1qYfhzrs+2lvvZZ5EobFylcPb
         6e3dlkApRthauWuCEuyZ1c5omKOMPfF1p8n4BEFAL9sMNBB+kkxW2aZbfZ/U92q4XHyQ
         rNjg8oj0LRYxNEG2XtdbksOA4U+Bq0CaxXMofcuad8V5MnjBOet4C50uOcA21GQv3Dd7
         Lgcc6vHuSUzVvClzRxOMe/iLGKnYoTtMZUQyB1qAy1qa1eZR1LQa0kyo74HsGkrG0qR7
         HEV5idwRVyQiQtqpK4/sof8dCRfli1NVv2fU9o5wIcVtZqxxMGFylHy7hGvz9qMVczIW
         6IWQ==
X-Gm-Message-State: AO0yUKW+2EMuUXHH6TJWOUPgcboJttJiT5hqIIuDrMywCw8upEF0GDzE
        A3tw06nr+KmPx7E/JLyiJWn80Q==
X-Google-Smtp-Source: AK7set96/RoQNwXjE0l0xFBJsYRLw4anu6diBhri0ZA++TNhnILbaUSuuRcMSQQM3GzZPwCjLvNV0w==
X-Received: by 2002:ad4:5caa:0:b0:5aa:17d5:bbfe with SMTP id q10-20020ad45caa000000b005aa17d5bbfemr10951013qvh.10.1678826327838;
        Tue, 14 Mar 2023 13:38:47 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id c2-20020a379a02000000b00745ca1c0eb6sm1947828qke.2.2023.03.14.13.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:38:47 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/4] net: ipa: reg: include <linux/bug.h>
Date:   Tue, 14 Mar 2023 15:38:38 -0500
Message-Id: <20230314203841.1574172-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314203841.1574172-1-elder@linaro.org>
References: <20230314203841.1574172-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "reg.h" got created, it included calls to WARN() and WARN_ON().
Those macros are defined via <linux/bug.h>.  In addition, it uses
is_power_of_2(), which is defined in <linux/log2.h>.  Include those
files so IPA "reg.h" has access to all definitions it requires.

Meanwhile, <linux/bits.h> is included but nothing defined therein
is required directly in "reg.h", so get rid of that.

Fixes: a476ec164a50 ("net: ipa: start generalizing "ipa_reg"")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/reg.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/reg.h b/drivers/net/ipa/reg.h
index 57b457f39b6e2..2ee07eebca677 100644
--- a/drivers/net/ipa/reg.h
+++ b/drivers/net/ipa/reg.h
@@ -6,7 +6,8 @@
 #define _REG_H_
 
 #include <linux/types.h>
-#include <linux/bits.h>
+#include <linux/log2.h>
+#include <linux/bug.h>
 
 /**
  * struct reg - A register descriptor
-- 
2.34.1

