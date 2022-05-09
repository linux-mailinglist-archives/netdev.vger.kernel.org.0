Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A13D5204F9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiEITNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240438AbiEITM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:12:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB392C512D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:09:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id x12so12814468pgj.7
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F23hvNdZVN0CdwC6BDdwdQ1zcLt+U3y9nLMorclWjn4=;
        b=GmPS2/u/atWfhpEDJ46EekvU36Yt0L2WEtm6xRsSZyXTbsLmjkLnD1OcLeqIGZPsoa
         dAGVgHj5XMFAZ0JF1X8ZYORVoqL356t0JBytSRS/9GEK5e1VOmL4tRzEhC7qxkUEastB
         zOg/jNIqEC8bLwftvqarQE+GDIIeO60Ap5SJjt1eQETu/AFSgD4FIhG7JyWUgO91ywJX
         v46WJOYFZyvXWqloza1qGqTp/TMLvPggly8oxnJcA3FmtzzVsR1Fu1q14ozdBEidTUOI
         M8F+m6GOE7zJP1vYTLYbB7wJulrdqyFhJ4jLSqks52iaq49r9RjPAS6+FX9Biwt+mArb
         IVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F23hvNdZVN0CdwC6BDdwdQ1zcLt+U3y9nLMorclWjn4=;
        b=DrGnW8LGnAXAr0rsEZBEOqb8QQUxlvUJKsEXtaO8F2qi5zRqxcCbY94JERu552SVun
         7nEqBF5JQyk2Q5TqQmva7Gxda055d/iqJUn8a9cHE/NlnCbfyeuCkXhSR/fSxWhCgXit
         7qju14iq5U7VLqQe28P/eyhh3g+DkBFyMbvxrExrez1l+rOSbBb0b8ZhFWeblOLozGAi
         fn2YTInfMrAXRen6foKkrLJVS5ajjAOqF8J2xRkifjl/2neGzv2K0JbGwuoTcauL5lHD
         y8yk2XfmCCnrVVam+kwh2aL7fKavUwTv+UYchWHs55WwAl26gkLBBF04Bu2VteMIpggm
         H9aw==
X-Gm-Message-State: AOAM533njIhTdtEI1G5j2K554HMNgV4qBrDaW6pU/2kvcyNEoZj9OV6/
        PoSST2eza83EpXk4ysvIdJs=
X-Google-Smtp-Source: ABdhPJwt06tor8/5bLEYJ3btoY2iYz/FzuDxuPlVo9yfFRyGmm4d2NiJ+j4DLXKfkVYQeUuExT/3Lw==
X-Received: by 2002:a05:6a00:230d:b0:4f6:ec4f:35ff with SMTP id h13-20020a056a00230d00b004f6ec4f35ffmr17270195pfh.53.1652123341451;
        Mon, 09 May 2022 12:09:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0050dc7628174sm9032631pfg.78.2022.05.09.12.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:09:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: remove two BUG() from skb_checksum_help()
Date:   Mon,  9 May 2022 12:08:51 -0700
Message-Id: <20220509190851.1107955-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509190851.1107955-1-eric.dumazet@gmail.com>
References: <20220509190851.1107955-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

I have a syzbot report that managed to get a crash in skb_checksum_help()

If syzbot can trigger these BUG(), it makes sense to replace
them with more friendly WARN_ON_ONCE() since skb_checksum_help()
can instead return an error code.

Note that syzbot will still crash there, until real bug is fixed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4da3ffc52c4f2402427054b831e8a..e12f8310dd86b312092c5d8fd50fa2ab60fce310 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3265,11 +3265,15 @@ int skb_checksum_help(struct sk_buff *skb)
 	}
 
 	offset = skb_checksum_start_offset(skb);
-	BUG_ON(offset >= skb_headlen(skb));
+	ret = -EINVAL;
+	if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+		goto out;
+
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
+	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb)))
+		goto out;
 
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
 	if (ret)
-- 
2.36.0.512.ge40c2bad7a-goog

