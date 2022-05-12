Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180605245B6
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350390AbiELG1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiELG04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:26:56 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1765C675;
        Wed, 11 May 2022 23:26:54 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x52so3894925pfu.11;
        Wed, 11 May 2022 23:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0V/g4vf7d52LTUG/UsmwgEG5VgHlj0HZXVekJyZLmLw=;
        b=JAvvl9iVFuRWt0giu6Rwh3EdHz0j+mUXfhVs1/bb/cMKT82K/sFGAYYspCHfUPShse
         O1vD4wYWSOxdKvs/quqWY0WDC5ilC4f6Lk5slDAvnwduQ/HDmf8844QCxMP8KW758Oco
         mhuO5jwmMSgqiWnlOpfhGKw4PHY6tMR+1CsGFCrh7H8KB479SVUPNx3Okm/TDp0SxNEf
         TTzlyEo1SAzEj7WNGABDdgBS0lyKYDm8kph82798x0WwVXHyqcgC8jOfAaTPqpWpXuDP
         c0F8Cvx1t3IRjMw0kVMIzlcrDWuVl2ZZe3HEs3FETcANOkr7KPC5JWbdXJ1gBUajzijX
         aoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0V/g4vf7d52LTUG/UsmwgEG5VgHlj0HZXVekJyZLmLw=;
        b=AAXSwOOk9zmz+SAVMA8uoc674ptc9lN9A13VdynT03yUBbu8SYoI2CBQSORibybPv4
         ThwpfAr9TyCw8yazQQfm/h08Y3C61LjvnG/Eu6mOD6/v3vfJN7UuCkYFg7DqnKl468zb
         XXv3US7LOabQGD2Te7mXiPCHTIN4G0gufA+l+B4srquSNd3vw+IcdPZdrtuD9IvNrWDv
         BP2F2yRDgpLB4gPRbI3hLs2sShxYO1F9PFFDInanNEwTH2AgA4LPu+LdBTcjJbsBJihp
         Qa9Ou1iuX7dNrHMt2c30OqZRGDmEZAH8Y5XGTRo26/ImaemrVnFbbokOtPt0aMWPvKNL
         HlQQ==
X-Gm-Message-State: AOAM531jW4SXnOmEGzOmFmsIsXDHnTvXLavdek+ZNpqZBnXoaqMUXOdh
        8QiKJcrbQqWrwBc12QPV05I=
X-Google-Smtp-Source: ABdhPJwumZvA6vnB3QhkMlMBeBllxIQd1AH+g8+eQJ+ErANn77c0uvTvU3gq1vA4OKtwL/bIUkKjiQ==
X-Received: by 2002:a05:6a00:234b:b0:510:4161:781a with SMTP id j11-20020a056a00234b00b005104161781amr28761397pfj.5.1652336814066;
        Wed, 11 May 2022 23:26:54 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b001d903861194sm999748pjb.30.2022.05.11.23.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:26:53 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: skb: check the boundrary of drop reason in kfree_skb_reason()
Date:   Thu, 12 May 2022 14:26:27 +0800
Message-Id: <20220512062629.10286-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512062629.10286-1-imagedong@tencent.com>
References: <20220512062629.10286-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Sometimes, we may forget to reset skb drop reason to NOT_SPECIFIED after
we make it the return value of the functions with return type of enum
skb_drop_reason, such as tcp_inbound_md5_hash. Therefore, its value can
be SKB_NOT_DROPPED_YET(0), which is invalid for kfree_skb_reason().

So we check the range of drop reason in kfree_skb_reason() and reset it
to NOT_SPECIFIED and print a warning with DEBUG_NET_WARN_ON_ONCE() if it
is invalid.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/core/skbuff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 15f7b6f99a8f..e49e43d4c34d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -771,6 +771,11 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 	if (!skb_unref(skb))
 		return;
 
+	if (unlikely(reason <= 0 || reason >= SKB_DROP_REASON_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	}
+
 	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-- 
2.36.1

