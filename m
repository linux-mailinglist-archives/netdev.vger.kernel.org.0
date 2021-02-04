Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0130FB77
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhBDS2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbhBDSTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:19:44 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2EAC06178A
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:19:04 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z2so2691890pln.18
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=GkV/UHW40ojQINSJGLSD5pRuP03bJ/Yv3/kf3sMMqUY=;
        b=JWES8rpo4FSC6YxM08B3ne3WSE8mwOoe4YXK22ypOyIhZRXvmJtav1bew84WSu2he1
         o5oTUWlif2TQQ6ePgIqh8RMnovA2hkvSifp7ohmwld/5FAlGsUqFjp3umWZQ8ry6Vvgt
         bmdrqAalBy3fjnn5ZB+2LdoKuiXdQjKnlpuDDp02oSdz1bVUG6r7drR4Y5yczWre7LJN
         pyuUu7KqqxlZOB/64y6nG0p/VCy3vx40h2+kK6qgiN59kRw34gOs0oPCkvjasFWMVrEi
         AX/7n9Hhs1w2NoAeUFG84NZxzCXroqpLRvQ/wTdc45/IAh74eK2h+lHZx7lsD9e8/zCU
         tExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GkV/UHW40ojQINSJGLSD5pRuP03bJ/Yv3/kf3sMMqUY=;
        b=fLXnL/wXP98ASuRpQRhP8rN7ojcESzYB9ZBvdQZuwwyxUzx5pq1lyEMn1owMe3yAXk
         XuZ375aKpAH7d1AE0TQSP7SLRpb9+Aubzc6kuykgVPGP9B19IRNQB/RygPCOLvri9nmK
         EmZ+iEyTwLBtxucq/FLhU77yw9WmiglkFbRUyYZ0fVle9qR6dxJYjq14jqJwOEc3cyhC
         Y2qc69zvjcU9+MNp/z+FBnNLOxw9lBBWev3rhkIV7X1nOG+0Ya3Pexojs2vzfCIz7HiL
         hHOVdv0vWcoRmxw7KUwbWqP+40LJc2o5dX5Dhc7jF1LVjIDwaF+SdNlG6/JpGQVsXR5r
         E3lA==
X-Gm-Message-State: AOAM533hCOt74b9QL+oFlxiiPSb0QTU92yrOzzQGSKNcaAxhv4hiZ9lJ
        8Ldj/D6JS+pblbClFcE/YSzqGlRj0Typ
X-Google-Smtp-Source: ABdhPJzx1vsXHznamTaYWa9MvvPa0WoOBCyUpAAEP3hDPxjBYVWTXkLnj/RR88J2ZNL7dmnhiy+DO9nElJFi
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:3b44:: with SMTP id
 t4mr64655pjf.1.1612462743645; Thu, 04 Feb 2021 10:19:03 -0800 (PST)
Date:   Thu,  4 Feb 2021 18:18:39 +0000
In-Reply-To: <20210204181839.558951-1-brianvv@google.com>
Message-Id: <20210204181839.558951-2-brianvv@google.com>
Mime-Version: 1.0
References: <20210204181839.558951-1-brianvv@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next 2/2] net: fix building errors on powerpc when
 CONFIG_RETPOLINE is not set
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes the errores reported when building for powerpc:

 ERROR: modpost: "ip6_dst_check" [vmlinux] is a static EXPORT_SYMBOL
 ERROR: modpost: "ipv4_dst_check" [vmlinux] is a static EXPORT_SYMBOL
 ERROR: modpost: "ipv4_mtu" [vmlinux] is a static EXPORT_SYMBOL
 ERROR: modpost: "ip6_mtu" [vmlinux] is a static EXPORT_SYMBOL

Fixes: f67fbeaebdc0 ("net: use indirect call helpers for dst_mtu")
Fixes: bbd807dfbf20 ("net: indirect call helpers for ipv4/ipv6 dst_check functions")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 net/ipv4/route.c | 4 ++--
 net/ipv6/route.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9e6537709794..be31e2446470 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1206,7 +1206,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ipv4_dst_check(struct dst_entry *dst,
 		return NULL;
 	return dst;
 }
-EXPORT_SYMBOL(ipv4_dst_check);
+EXPORT_INDIRECT_CALLABLE(ipv4_dst_check);
 
 static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
@@ -1337,7 +1337,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ipv4_mtu);
+EXPORT_INDIRECT_CALLABLE(ipv4_mtu);
 
 static void ip_del_fnhe(struct fib_nh_common *nhc, __be32 daddr)
 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8d9e053dc071..0d1784b0d65d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2644,7 +2644,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ip6_dst_check(struct dst_entry *dst,
 
 	return dst_ret;
 }
-EXPORT_SYMBOL(ip6_dst_check);
+EXPORT_INDIRECT_CALLABLE(ip6_dst_check);
 
 static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
 {
@@ -3115,7 +3115,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ip6_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
-EXPORT_SYMBOL(ip6_mtu);
+EXPORT_INDIRECT_CALLABLE(ip6_mtu);
 
 /* MTU selection:
  * 1. mtu on route is locked - use it
-- 
2.30.0.365.g02bc693789-goog

