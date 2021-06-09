Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141FC3A1A18
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbhFIPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbhFIPtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:49:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F97C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 08:47:54 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n12so31744608lft.10
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:from:to:cc:subject:date:message-id:mime-version;
        bh=VTOOV2HamW2xff+Be3idNu/kmRGU5Py9AUeUXwSEtGw=;
        b=XLLMEpas+9Ur0pSHE8VV7V+/tSISv8xdtslDPxq2tpngkIGA7IIkuCbzJOVgHKNBBv
         fvf9ECLApxsxQklrK5orVkfEQfQd2QvWmUu+REESRWuFid1IYHEvl3zp1jIy7lwkZHP5
         okeO54snKnOpL153vB8DQlbueN92kPT65qo3U2pnwKwucY6H5hY0ne28p+pmGCK/8AzG
         xx5O3+wSR/SzT1KQUoDGX+XfvsvqqJAUkg/bpAdPp07Ir6myC8abT7AkNza1w/loF5r0
         O1RzHkaGJhcH4lZpoyX+QJ4RWwYHRpmxh9ynLkrn4ZAn/BWLtiem6lYcNPPw/Dpei8Ab
         CpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:from:to:cc:subject:date:message-id
         :mime-version;
        bh=VTOOV2HamW2xff+Be3idNu/kmRGU5Py9AUeUXwSEtGw=;
        b=FyGiEBVu4amaE9169mdMiXyKR+vI6snnnOXUGzgwZus6fDDKWaGCszau1rvwdxJzHB
         kUH0tRt7zrITFAByZe4X9VpPfA/SF4fanQtGsaYZK7+ZPXCCa4Vdg/bC3jrTMYPHwW1T
         dpMrEvdWHQnFBLgsmakCB0qUKBIz/E5whacM0QmGqls1TrmEriw4x/cC7503p1aNnazS
         uG3DWt7ajPZ2Nq8Y2HuX2FVORrBbUKR636FuVGPu9GOU0kkNm6FyFnaT+2mFHeu8mmc5
         FQSD08LFXcNo9mJ3dQO3Ch4c/Ta3cd/SIXUfrkGomceOaafT34U7nJG0m1rzBZ60DwOu
         42GA==
X-Gm-Message-State: AOAM5317jNLbFdggoLt7+WmLMGhGTbrlLhO3uVfs9mYrsnvPtQarjzPF
        dwXCUKJKfeur/J/LbFUDd9SC3u0dS6pL6w==
X-Google-Smtp-Source: ABdhPJyRmPHU4Ryls5OGGDOKofkG/3kd8f2zEiysgn//1LknTv6na2RKyVkHti6mdRS8sw/mQTWk5w==
X-Received: by 2002:ac2:53ad:: with SMTP id j13mr125752lfh.594.1623253672192;
        Wed, 09 Jun 2021 08:47:52 -0700 (PDT)
Received: from localhost ([95.165.9.116])
        by smtp.gmail.com with ESMTPSA id 2sm14746ljr.127.2021.06.09.08.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 08:47:51 -0700 (PDT)
User-agent: mu4e 1.4.12; emacs 27.2
From:   Peter Kosyh <p.kosyh@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Peter Kosyh <p.kosyh@gmail.com>,
        'Mikhail Smirnov' <smirnov@factor-ts.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject:  [PATCH] udp: compute_score and sk_bound_dev_if regression
Date:   Wed, 09 Jun 2021 18:47:51 +0300
Message-ID: <87a6nzrqe0.fsf@factor-ts.ru>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


udp: commit 6da5b0f027a825df2aebc1927a27bda185dc03d4
introduced regression in compute_score() Previously for addr_any sockets an
interface bound socket had a higher priority than an unbound socket that
seems right. For example, this feature is used in dhcprelay daemon and now it
is broken.
So, this patch returns the old behavior and gives higher score for sk_bound_dev_if sockets.

Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
---
 net/ipv4/udp.c | 3 ++-
 net/ipv6/udp.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..4239ffa93c6f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -390,7 +390,8 @@ static int compute_score(struct sock *sk, struct net *net,
 					dif, sdif);
 	if (!dev_match)
 		return -1;
-	score += 4;
+	if (sk->sk_bound_dev_if)
+		score += 4;

 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 199b080d418a..c2f88b5def25 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -133,7 +133,8 @@ static int compute_score(struct sock *sk, struct net *net,
 	dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
 	if (!dev_match)
 		return -1;
-	score++;
+	if (sk->sk_bound_dev_if)
+		score++;

 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
--
2.31.1
