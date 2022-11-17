Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5891B62D183
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiKQDQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiKQDQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:16:07 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBD964A17
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:06 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id l2so364557qtq.11
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9LBEXDD+Ph4SF0Q02heQyIynGLkO+luTsSJyIxQLi8=;
        b=JHB8aiQgqZr6T2488gjy0+mFOhHh2VyJvRopV5+pPWMJXZhxAwmnceQy5QEv3N8tOk
         Ne1NmLfUHfz0FDXUP8hNcvKOK5FPq4UpnuFxw8/1IO6+cRNfmUgFz3ciXPbZVkiiHxIV
         xS+aaBeY1m0r9PJS6zCglk21/419o+83mDIcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9LBEXDD+Ph4SF0Q02heQyIynGLkO+luTsSJyIxQLi8=;
        b=7ALGEIcfypBgz7+m9hWal6EzZyjtpBv5FATnPZK55ikfl55dyvGNKXJnTv5XI0Acaq
         RCRr6HOi2BDqNgevPIWENT08A7ZU4RyeV2GmLWytu3jGxg8SpYg1HTkIjKGXUarPvEgx
         DkZTAv+btw1sWqwKY85e0ERHPkH5XHmZ8VoRVccParRSMiCZKqD/emJFG5/iiyVxeCgY
         tJ8fswHbAuGkXezwZxcasvbxRgDZkh+MPXAzKQpubYAHQtHAOBo1tO6y9jCSdQM664ZP
         9ppl47rpCZy+NGo/SNjl1ZNriHahlK07pjIZ4z2Mh8ESw/+8FdKkXBunL5R3hpiIoa0t
         k+UQ==
X-Gm-Message-State: ANoB5pnpNk+LWHiYvS4iV+p6zYi4XQ7qhL0QsVrUwLQtpgOjX7S4sb/n
        cjPS3AZhkPWyC1EmONcXdJ4ssw==
X-Google-Smtp-Source: AA0mqf6tYbb7aqh2iSUw+/DUxtEpt+XbSFQV9UPEmammY7VOC9v7BaLxv9VBsF2YJcPh3TQAZIKKew==
X-Received: by 2002:a05:622a:4899:b0:3a5:64a0:5eba with SMTP id fc25-20020a05622a489900b003a564a05ebamr827383qtb.96.1668654965522;
        Wed, 16 Nov 2022 19:16:05 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id k19-20020a05620a415300b006cdd0939ffbsm11398318qko.86.2022.11.16.19.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:16:05 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
Subject: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
Date:   Thu, 17 Nov 2022 03:15:50 +0000
Message-Id: <20221117031551.1142289-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221117031551.1142289-1-joel@joelfernandes.org>
References: <20221117031551.1142289-1-joel@joelfernandes.org>
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

In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
causes a networking test to fail in the teardown phase.

The failure happens during: ip netns del <name>

Using ftrace, I found the callbacks it was queuing which this series fixes. Use
call_rcu_flush() to revert to the old behavior. With that, the test passes.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 net/core/dst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index bc9c9be4e080..15b16322703f 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
-			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+			call_rcu_flush(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
 EXPORT_SYMBOL(dst_release);
-- 
2.38.1.584.g0f3c55d4c2-goog

