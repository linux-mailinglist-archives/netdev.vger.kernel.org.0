Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15B3264A6F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIJQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgIJQzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:55:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E4EC06138E
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:50 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id u23so3971616qku.17
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=xA7IbJ3yaVDET7+RE99G6nvD4sMERSruE+q/sYEPOkY=;
        b=XUdbLo5fsRgZxPVP3yAbJSxea+yI+YdMMlXPmCsLu6nvZaC820S6+Ma9TgXnOBM0oE
         swVMorBF8bUP0ga/WUl0G2Ob7Bxgv2ILom+8SJCIy8/e0MIvEPzQGSO4nKpkCzuflKeU
         WUB+MJWFPVMl8CVuWWPK71IBigF6+xz1sphE46moJcDAykXOllvHEOzZGzQQQhnPpl/a
         YqQxAhj9Uih0gVyrxmQBHIzVgURklPTk+54IE/LIOuCZQfW+MqGW15aoEeeuQiZ9zyyz
         GMqnn63Lj+WeYTaUK648r1PglgSct1b7SJZQ5QHm6XcOFgU2g+0+780gS1ZAG3FFcdmm
         xWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=xA7IbJ3yaVDET7+RE99G6nvD4sMERSruE+q/sYEPOkY=;
        b=TRdZcYCJnbmiOUf1Uj/tjNTO3tlQ+ywiTXSg03SM9ISmLLfyUzLAnym0BnjfIiVQb1
         gAt9LMFPQYb/xSuo20Tcu2G/AH8cryQoC4H7BNTo5ip3O2umNbQ33y2GW22ddjlGNX15
         wVJdzrYDb/4esY3DW0pc8fbp8/lJ9AYHR8J+4s2+037zxTA71eEfMDOJmvQ+GraoESix
         7PH3tcH9Vnhh67fiuso+zdziJN1nbncUfNbBCE6WqXELCzBtb8rg9Fx8DbXrnyygYaTW
         ErnUZZJI/F8+LKlWT16dF+4Iq81L91aF6JYLcaa2OYgB2v6Md3Pk6TLnOH2MIcbRYa/s
         h0QQ==
X-Gm-Message-State: AOAM531PdT0AFzbdwqMAu3R8SUkdDjJGjjWeMX8E58rsN8DZwsp1Eq6X
        8ND+6jgjW/iboy8AMVXmc9nHmezje351Nuc=
X-Google-Smtp-Source: ABdhPJxfeJSqv6PfZ0s3RbzjlJhevlrx5pwRq2o6VFCC621ttCF37+geB+RKjG77fA+A4MdokQzuas4NszsjRzc=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:9c84:: with SMTP id
 i4mr8922353qvf.112.1599756829425; Thu, 10 Sep 2020 09:53:49 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:53:47 -0400
Message-Id: <20200910165347.2031665-1-ncardwell@google.com>
Mime-Version: 1.0
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

