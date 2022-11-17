Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C664862D180
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiKQDQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiKQDQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:16:06 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25E63CF8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:05 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id p18so407396qkg.2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVyiieWly24z0z0fYFBjEvhMrkOmEI6OGYeufoegUM4=;
        b=phUx/1hExUXj+l6ZupXb949+eS0h2KoDX51zvVMU7Ie7h3iZCBke2E+BGODPJBV4tL
         xGjPEH8PMNVD5NL6U0rDwSD9odVjl6CMe7+lYIMoTphmU1iyZXlh7qyciMp422Gumrv7
         eeX0U1xVIh4mhYZ+0J4/xwfFnxRJXhOqK1gQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVyiieWly24z0z0fYFBjEvhMrkOmEI6OGYeufoegUM4=;
        b=2mFdVKjpRTt3u2z34DChRssoCQhGQADm8aOSeREBHVpmemCXqwRnVEveq6jP3sZgvB
         e0LRyr+TSwRkUmzU+hWQsfQANv+VZ4mWpdNIIMxiuGawWZ9zEZCbVgV6ZLuzVVAI10pz
         LZtGS+5YwdogE5gCChD4HpoI/Jkt/4hjS0NZkzvkxVZhiwZQcLycmQ41uRMEV9wzw7NY
         2zC0TE1I5q3DjR7vm5mpxdqsgwewkv6S6nwqLx7pUSK+zlpgSRsURh5JBbs90nrw1Gh9
         iBIqaWkiZwWpOQKzKCHXpkZmHDTkizIeda31EUFKAPjiv2FWil3urF7W8BijLZ0qLByl
         Ilhg==
X-Gm-Message-State: ANoB5pnlk0mqhREjOlTkihFY01pOrGIJT6wEl4LYjPva1/KKouZKMtoJ
        Jq2Nqg2QJTWvrrc86uePiFAcCFnthbOB5g==
X-Google-Smtp-Source: AA0mqf4iZQlFujHEBGLFvhYWg4vhUvvJjjCO/pv1TcbmlblMbmZxj6HXge1lTpprJ/0n5Y9W2BGmxQ==
X-Received: by 2002:a05:620a:459f:b0:6fa:f76d:bbc1 with SMTP id bp31-20020a05620a459f00b006faf76dbbc1mr307187qkb.11.1668654964533;
        Wed, 16 Nov 2022 19:16:04 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id k19-20020a05620a415300b006cdd0939ffbsm11398318qko.86.2022.11.16.19.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:16:04 -0800 (PST)
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
Subject: [PATCH rcu/dev 2/3] net: Use call_rcu_flush() for in_dev_rcu_put
Date:   Thu, 17 Nov 2022 03:15:49 +0000
Message-Id: <20221117031551.1142289-2-joel@joelfernandes.org>
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
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e8b9a9202fec..98b20f333e00 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -328,7 +328,7 @@ static void inetdev_destroy(struct in_device *in_dev)
 	neigh_parms_release(&arp_tbl, in_dev->arp_parms);
 	arp_ifdown(dev);
 
-	call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
+	call_rcu_flush(&in_dev->rcu_head, in_dev_rcu_put);
 }
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
-- 
2.38.1.584.g0f3c55d4c2-goog

