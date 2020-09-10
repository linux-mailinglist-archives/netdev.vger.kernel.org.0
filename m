Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BFA26524B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgIJVOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbgIJO2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:28:31 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A1EC061346
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:48 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l1so3396108qvr.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xA7IbJ3yaVDET7+RE99G6nvD4sMERSruE+q/sYEPOkY=;
        b=YQG35bnDpcnnwuZjnW/nNyuqSr7tOnkchO8w13j8BCWRuyorpS3LNqsE1HzyTpXtne
         cVnXZgKp/Io8YK9Nsh/HTmMP2cvTB7EsmRWD7915Y68vgnybPk+FaSvXVmJZrv7lI1/s
         4n160ykKZMfKQ5qmcsVrFPvBJ9zCqbzPrsjk5c2W312BdmXbI0MUJpyvZ+OdVZd4LiFb
         YRfQI8J89JXN/ATXwQTUygxLk+pcpK5ITJc/5gsosgZTeWkAbUFzXT1gFKe+ETNv++tm
         bbEQccOFfARXaDCY6I5AIYOi/j8oJZwNnTY9Ltny0LjCAR5RRCmW87YgSVIxXHmQeO4W
         uVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xA7IbJ3yaVDET7+RE99G6nvD4sMERSruE+q/sYEPOkY=;
        b=gfZE/++0g33FacvudgmwmJjmhlM1F6chlsxCWnDEowf10WLLQ2IeVE624Owyxkt9nw
         fGFvZOykFfa/xv1hzrXKij97fqW2zujatUGJChD35Uif9aHG6CXA9SX43M/1O6hIvjpI
         eXsGby/5H9wB/1IpxJLMkX5s5lnT953y2rCos8y6padlxhRJ1RO1/XR42jHWk81+64e2
         1S9PLJuxQnaf0vx/v470DBfa5uijz80pLA0rULaM4SzYlREBW/2WCtxcY10MIvifpvI3
         Z7PqY6jjB6idCS6auHPvzcqgL4K7pKvwR0gecmzeI4eUL398EA8S9uivWbrOXmazBJWJ
         FXPw==
X-Gm-Message-State: AOAM533MelLX+UGFWPf30RRGOXfxi55NN7d00Uv5O2jZT70ofHoCToD9
        gOrZynWfp6EjR3eEp2tze8PrrmheBSxHOBc=
X-Google-Smtp-Source: ABdhPJzikJ/z/Ool8o6FS01OSPjXiNwxoGQkyIbTt86xNyu9dl0ZhDkYNdah/gvC4hNfHKpPIZzZVTC8ANkYKEc=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:b6d7:: with SMTP id
 h23mr8664387qve.17.1599746687832; Thu, 10 Sep 2020 07:04:47 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:04:28 -0400
In-Reply-To: <20200910140428.751193-1-ncardwell@google.com>
Message-Id: <20200910140428.751193-6-ncardwell@google.com>
Mime-Version: 1.0
References: <20200910140428.751193-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 5/5] tcp: simplify tcp_set_congestion_control()
 load=false case
From:   Neal Cardwell <ncardwell@google.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify tcp_set_congestion_control() by removing the initialization
code path for the !load case.

There are only two call sites for tcp_set_congestion_control(). The
EBPF call site is the only one that passes load=false; it also passes
cap_net_admin=true. Because of that, the exact same behavior can be
achieved by removing the special if (!load) branch of the logic. Both
before and after this commit, the EBPF case will call
bpf_try_module_get(), and if that succeeds then call
tcp_reinit_congestion_control() or if that fails then return EBUSY.

Note that this returns the logic to a structure very similar to the
structure before:
  commit 91b5b21c7c16 ("bpf: Add support for changing congestion control")
except that the CAP_NET_ADMIN status is passed in as a function
argument.

This clean-up was suggested by Martin KaFai Lau.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Kevin Yang <yyd@google.com>
---
 net/ipv4/tcp_cong.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index a9b0fb52a1ec..db47ac24d057 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -362,21 +362,14 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 		goto out;
 	}
 
-	if (!ca) {
+	if (!ca)
 		err = -ENOENT;
-	} else if (!load) {
-		if (bpf_try_module_get(ca, ca->owner)) {
-			tcp_reinit_congestion_control(sk, ca);
-		} else {
-			err = -EBUSY;
-		}
-	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin)) {
+	else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin))
 		err = -EPERM;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
+	else if (!bpf_try_module_get(ca, ca->owner))
 		err = -EBUSY;
-	} else {
+	else
 		tcp_reinit_congestion_control(sk, ca);
-	}
  out:
 	rcu_read_unlock();
 	return err;
-- 
2.28.0.526.ge36021eeef-goog

