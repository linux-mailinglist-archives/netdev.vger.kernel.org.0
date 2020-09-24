Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115C0276597
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIXBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:06:02 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25137C0613CE;
        Wed, 23 Sep 2020 18:06:02 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id e4so698542pln.10;
        Wed, 23 Sep 2020 18:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=AtzU9j2IVKPI1js+HfqCYbfNPkUBuxHykiGDefT3GX4=;
        b=tlGitdO2MdhbIvIfljqNkujgc77+mZ/rDuACm9Pw+TDpnga+QqD58kEGNEcC+7J+DW
         iCGzb0YwBIISAouUMK9OVbp9dFTMJARdNZwchjhhezUgvyquOjNc2KhelP6aSXxHQSqW
         bulNiXbjqj6pg6/nCiOioL77TDowQs17hJhGrmgVB0Nsv6C2BaND6rkdT+rO3Y1vR7J3
         S8+khNZAgmVKLAHnBrITnfmID6w0UlhSWM9zN5Pv8FtHuNtUydd+VZxIKRC0xusdWPDb
         C3RS+Qb5RISTu01JOItRWFR9Os57gVMlWJhASKYwSGD+imJC9XrDBjA5NEqF/KuRDYO5
         wl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=AtzU9j2IVKPI1js+HfqCYbfNPkUBuxHykiGDefT3GX4=;
        b=DQMriBOLK5YayClYNSHDS5ziX0GM+f6DBYTq3+vAfAeaPYKu0388v6kpN592aJqhrs
         n5hEQou7QwcCwmSLrBeAsztKgOZK75T3swvrYBH5gyeifZ4p7RBddXn+iqU/7HE3kT7l
         x95oy5T7XaDL1pbmik8ZboEjX7E8kU4UQJIOxN8EuhnG3fBvl1UDzf1w5c24sM+JoXGm
         t6JeEkEbVzHdG1XzgExj4X1EvB0DGqGzGaQ3QwGUjsASpPemjgmYDXWUf8pB3/GyPj/w
         GyYT8kEWGSBc1dSGMYVeiQLN7joWMLMoS8dVsE/iKTZ4QuY02gMFbi3PHgt8ug3MUIB9
         zGuw==
X-Gm-Message-State: AOAM53308hMzHycb9NslhigNv7hoeg+jlv2BxsTBbuCROdvnj0KCiqLo
        PvCXbQU+EOLX4XlXwu2inIo=
X-Google-Smtp-Source: ABdhPJyo6OpepoJlMUCbN2XSI5tTuyT0Xagp3lfHxVXSPr7rHuOqq2RztKxn3n2+i9B5OHAE3JvlaQ==
X-Received: by 2002:a17:90b:510:: with SMTP id r16mr1707948pjz.75.1600909561763;
        Wed, 23 Sep 2020 18:06:01 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id n21sm901910pgl.7.2020.09.23.18.06.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 18:06:01 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 15/16] mptcp: add sk_stop_timer_sync helper
Date:   Thu, 24 Sep 2020 08:30:01 +0800
Message-Id: <31247220b62d6759de9eb91b841be449714b9d69.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
 <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
 <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
 <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
 <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
 <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
 <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
 <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
 <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
 <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
 <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
 <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
 <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
 <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added a new helper sk_stop_timer_sync, it deactivates a timer
like sk_stop_timer, but waits for the handler to finish.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index eaa5cac5e836..a5c6ae78df77 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2195,6 +2195,8 @@ void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 
 void sk_stop_timer(struct sock *sk, struct timer_list *timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer);
+
 int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			struct sk_buff *skb, unsigned int flags,
 			void (*destructor)(struct sock *sk,
diff --git a/net/core/sock.c b/net/core/sock.c
index ba9e7d91e2ef..d9a537e6876a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2947,6 +2947,13 @@ void sk_stop_timer(struct sock *sk, struct timer_list* timer)
 }
 EXPORT_SYMBOL(sk_stop_timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
+{
+	if (del_timer_sync(timer))
+		__sock_put(sk);
+}
+EXPORT_SYMBOL(sk_stop_timer_sync);
+
 void sock_init_data(struct socket *sock, struct sock *sk)
 {
 	sk_init_common(sk);
-- 
2.17.1

