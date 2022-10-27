Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689AF60EEEA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 06:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiJ0EHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 00:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiJ0EGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 00:06:51 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C53D1578A5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 21:06:39 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id ff6-20020a05622a4d8600b0039cbf66e8b5so362082qtb.19
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 21:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s4PIEAaYE0U2atB2wfC+s+Ffs5H27SM/q/y9rUoJwnk=;
        b=bmVfAqnovSu60joE444v2ggOg4LVzkRB9JLCq5QDU72Xg8Np1Dv266ljyvzSlsSEm8
         d6Nr2izbVYf8trkrTj2QYSLfvSbN4SFxOo6n4/3FYlltBdhQ14hnPQFxu5WFhJq4MXuu
         IylJEi3sX/Apure4LBQ+1Z9bPrLPXCMUAf01mTESrLuqDWvaId9F62ZCpg5JwJkaQmYe
         xpYQngR3in/k/zhT97c0Zih8AmKYyjQW6B3C+mtuEv//X0BVnMBKyT2QZ05IfG28aQ/t
         Bexxgw9HaHBArdFkeUZRTZRfrkwAJs7SqmJMAjSGczkCnowIYeycKZ2LKdhkmye154ch
         jpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s4PIEAaYE0U2atB2wfC+s+Ffs5H27SM/q/y9rUoJwnk=;
        b=5PjL1QdDK8w0dVHF+9AAc+EekfBPikzHvuRK4GShw/D5LF0TqhNoZv8OjfBoA8JzjB
         CXWdR86okAyXx7/XEpM8ruYDlCeD/zO6yetJA4pAdIfbj1wP+k7fWYL0hE15fWCP5dzd
         8Ph+F+48gThLvZiQM4a0vLsAEmlbJSug1EUltN5oJCxaRH3ESqQF/L2nhDwo3jRIoCMr
         CCzL36+9kKoGdzi7aNkTJPpnqtZkxKjez3v6+sAiLmcLTTXQC36hXmjpvJeLj8T/tmot
         YmxzFalb5t2z5RIWHmwl9pMIKg4/LL2h7q4KSdqdZs/oaZLBPGW3jYBF5iWIEI6KIcGf
         6Ckw==
X-Gm-Message-State: ACrzQf3rZWSjJoTRaW0q8KuPv2+/lY90GK+M1jYqyjAXov0TQI1O+Ksw
        8dMHILFMxLU32W0lWMjpdD0eV0s3LvIZLw==
X-Google-Smtp-Source: AMsMyM7DjQkFcvLkk8I1jmOFER5fpOOmBLiBPyY72lE98EtyD96DReTqp8mLtUBXX+fz5NUdmNbVETQuSgsi9g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ae9:f80f:0:b0:6ee:83f2:3066 with SMTP id
 x15-20020ae9f80f000000b006ee83f23066mr32703278qkh.388.1666843598606; Wed, 26
 Oct 2022 21:06:38 -0700 (PDT)
Date:   Thu, 27 Oct 2022 04:06:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027040637.1107703-1-edumazet@google.com>
Subject: [PATCH net] kcm: do not sense pfmemalloc status in kcm_sendpage()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to changes done in TCP in blamed commit.
We should not sense pfmemalloc status in sendpage() methods.

Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 63e32f181f435334530c42e54c7a36e8e993104b..a5004228111de324a563ef6f26863181616c0241 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -839,7 +839,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	}
 
 	get_page(page);
-	skb_fill_page_desc(skb, i, page, offset, size);
+	skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
-- 
2.38.1.273.g43a17bfeac-goog

