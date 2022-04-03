Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C524F09A7
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358512AbiDCNKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358421AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0D10FD7
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q19so3714063wrc.6
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AtsblrA0Q/EAB3Ej64TC+StZTR9fs4Fmy33efi83Z1w=;
        b=P897ZHRZ42Kc/2lUY9RVPcWKaJeVIAp7YYv3U0oHfQo3U7EaHzoU0HRw/vWxVMDC8w
         rAvY4dFbWcBe67Gkfyd4/oRW8DBa+IKIRHzlEM0VThkebCaRpuu84yyDGjFFKgisyhz0
         XpgKB2nOtNsKYEVtKM6i54LAY0eCyAMVdLGOms5p957NAE3IgcPbjr1gGUokRNsc4/Tk
         6EWnAV1OU2tzX4iUeuhjTjh9Hg5jWgxUO4ikw2VVMfP1HJ9QkFLxMc3ov8VbaEZcC1Is
         xMF3taVLU3csWDLMXLpklCdnIDKC+6dmpfQX6nvx5hJX8kU5B8nrWvOV53f9mO9MjVWT
         mU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AtsblrA0Q/EAB3Ej64TC+StZTR9fs4Fmy33efi83Z1w=;
        b=e7tz7YGqgYOtrRkrW6EdZhU4URzSjCCd7b1o1dEDbtiYaAT2Xc8H/zabOgixkLGgBP
         Zi8Ecg9FNS1pXjqUMDAn8yC2Nzv0Cd6FSZ6W7Bw8DoVxA+1QljTX7+IINyMSyPJDcywr
         boQoTPrbcJahLiLmDG/VyQ4QleJqLVTl2jMD/9t32CtOzGEbWtCxeZQPZ6gVJlwFQuh3
         rMwOfc3P0V8hJ26NFs/n3ueH5Cg+q3/fCoucDr6rv3gTtkwZ3dUtIrfQ3I2xFWv+VTYh
         Jq2gLH5/nhoxko2mpLeIAIfdfzJXccg7hX09v4WKXwPZlcYEVUXzd2hOkDRmCHLF0m2F
         KDnA==
X-Gm-Message-State: AOAM532Q8oCtcLaR64epj0t/ol9+oPVvLGsp3M/9V/ypxxu6teWsZ+sz
        vRM5merH9eSC94Zf14pSPzcf1SNfiiw=
X-Google-Smtp-Source: ABdhPJykKr0h6gUD5OGv+7JbuG5Wf20yulnbZcXLVl4KTljwEcGay5yJ8e68xfgd1aEGMIucdW30qA==
X-Received: by 2002:a5d:6945:0:b0:206:bd5:bf90 with SMTP id r5-20020a5d6945000000b002060bd5bf90mr3092425wrw.252.1648991305990;
        Sun, 03 Apr 2022 06:08:25 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 13/27] ipv6: help __ip6_finish_output() inlining
Date:   Sun,  3 Apr 2022 14:06:25 +0100
Message-Id: <c35a7f2347bbb8ab3d02589e994a66ebafd7aabe.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

There are two callers of __ip6_finish_output(), both are in
ip6_finish_output(). We can combine the call sites into one and handle
return code after, that will inline __ip6_finish_output().

Note, error handling under NET_XMIT_CN will only return 0 if
__ip6_finish_output() succeded, and in this case it return 0.
Considering that NET_XMIT_SUCCESS is 0, it'll be returning exactly the
same result for it as before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f1ada6f2af7d..39f3e4bee9e6 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -198,7 +198,6 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
 	switch (ret) {
 	case NET_XMIT_SUCCESS:
-		return __ip6_finish_output(net, sk, skb);
 	case NET_XMIT_CN:
 		return __ip6_finish_output(net, sk, skb) ? : ret;
 	default:
-- 
2.35.1

