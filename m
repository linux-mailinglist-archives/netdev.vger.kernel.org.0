Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1A55245B3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350370AbiELG1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350171AbiELG0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:26:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6EA5C86B;
        Wed, 11 May 2022 23:26:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v10so3712231pgl.11;
        Wed, 11 May 2022 23:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jj3Vsqhtkkm1RpfY/9Xvn3iKl3HTI+1EXSJInVx3Io0=;
        b=YFL2t/LDgfhTvDefT84RQFkMGOEIuDXGKntAtrBFgd0oZ5mDKu5DxCqk9Ma0ENXPFk
         YDyY5xynaoQYyP8CV7SEmjkYfHvW2zMxyybEh0yW0f4QFBn/B1rbWGlo2Ha9Ph9Qnezn
         M1KEzku5FIEoVSeS9Uih97Ap0mmfTs5t3Ak34UQ4waxEzQzwtFc2qrQmRweb6gWbSCRS
         6uL4XUo9glJNbwrsUziaui3A8tTUiEN7fontoKjVovHhba4X2FdryaDg/WYHgV2tZVwe
         n2ToJfuuPzPV8uZkY+mm/ty1mKimi8/VXZtv8tmgY234tikQHLlnaAKdNY+ObhGLQVks
         RZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jj3Vsqhtkkm1RpfY/9Xvn3iKl3HTI+1EXSJInVx3Io0=;
        b=7s8PwgkiCSE/uomwvfWe1izJCXtAMneptDdIN/hGzT+2nbsV93Vm2LKBGUaJhMS08y
         0mPEXvSCL0DSiTG33ZmXh5mkjeOJrH7FM0dKDbkzr6lLMK7t/rw9/2yWgrIWpWk39791
         JgcdmHqYZK61jCX/PgrD6Xr6NYOl5pijHZxYXllet+5G77E3VFI1kvSj3rrYnFEKZrcM
         9sib7oESnhT7B2tIXmZdTC57t8/K9HQATcZ8i7ubeLQ6wegn1L+SDOzCmGH7DwwSylqd
         6VUApVjZzZ28ePdK0cwSiV3weRYS6aHOp3mql56fx9IUGN3iyrWG+9tGsHN+Ay2f7uLv
         N41w==
X-Gm-Message-State: AOAM530sQljmIXnmqtPjRHKCoDajwO/3dCwU5mfe4vpZL5XrQRC/3okE
        ShQyraBfQyaPWhUdJmCsCPA=
X-Google-Smtp-Source: ABdhPJyhAI6t/te98dvpLeUtTxAvqLHumurGzd2StGz37tEaryYvdUpxdCF9c+yfPZRQg92lQL7rRA==
X-Received: by 2002:a65:6552:0:b0:3db:772a:2465 with SMTP id a18-20020a656552000000b003db772a2465mr243103pgw.225.1652336809711;
        Wed, 11 May 2022 23:26:49 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b001d903861194sm999748pjb.30.2022.05.11.23.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:26:49 -0700 (PDT)
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
Subject: [PATCH net-next 1/4] net: dm: check the boundary of skb drop reasons
Date:   Thu, 12 May 2022 14:26:26 +0800
Message-Id: <20220512062629.10286-2-imagedong@tencent.com>
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

The 'reason' will be set to 'SKB_DROP_REASON_NOT_SPECIFIED' if it not
small that SKB_DROP_REASON_MAX in net_dm_packet_trace_kfree_skb_hit(),
but it can't avoid it to be 0, which is invalid and can cause NULL
pointer in drop_reasons.

Therefore, reset it to SKB_DROP_REASON_NOT_SPECIFIED when 'reason <= 0'.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/core/drop_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index b89e3e95bffc..020ac5f214d0 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -517,7 +517,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	if ((unsigned int)reason >= SKB_DROP_REASON_MAX)
+	if (reason >= SKB_DROP_REASON_MAX || reason <= 0)
 		reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	cb = NET_DM_SKB_CB(nskb);
 	cb->reason = reason;
-- 
2.36.1

