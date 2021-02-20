Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AAE3204F2
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 12:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhBTLFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 06:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhBTLFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 06:05:09 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2665C061574
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 03:04:28 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id 68so4036932vsk.11
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 03:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wRs3vewzDocFstZEFqqx8FT1uTw2+RMC7G5925hh5Fk=;
        b=gnbat2bWyy2uBVVf926tV+nmA074ThIN8o13dvd6m5hSnuB9+KHCelt0Ad+mkMpM6y
         OMjrz6TON4vdmlqyqED5uB9i0C78QTHwpJl+Feyi1LisVOGGhnaODadq7K61Zwg59hRR
         3MOUqcNaboNZQrSnC1a1yOum4sWW99lF4XZ1Wuy92A78RMCx+fscqi6mi2h0EGbwstll
         XJDLtIhhv2u/X18oEgPEe2eKVfAXj92ah9ILdnB5ny4z70SeJgdDidtE5yJ4iJa9Oyz0
         g78CIkaWUcE3lXyh33M9zj/D26kcxh4pcl3Lrej/cIreE1xX04MHJcRt9Q9dXpSf8FWO
         L+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wRs3vewzDocFstZEFqqx8FT1uTw2+RMC7G5925hh5Fk=;
        b=MlAD2o7RwMOpYeXhSaRGgQV1QSHyKt1SdQNP8m3k+VnkxgpCCbYFkTHLMjxQFzocl7
         PVBSxzlQw83MM4rX3wD8/ZjtfBKVIyxknoD/8AWSxWI92ktca3crXSks3plp7A2UQ1qn
         Qr846pQ+X8Yuyrg1sHeucBqxF/aBFIlV1dDx73xS1SP0FfLCtdLEKeN1CwDae+Zwv+et
         qf/7Ab1fqvox9DQ9qOYgXi+yxPFLJf35oZ3rHqvMAc8oVkTgH0KIfx4f0ac8iq3bbXsU
         vDYHvLVXbbwcONuwJ1Z7kgnDK18sMrAFwRYcr4bETdGH3GXHb6cZg/kZb2DLYkHrjyEM
         uIoQ==
X-Gm-Message-State: AOAM533XRz5ei4ez7K4n71LXMoApcz0QJcCgXjHZPUn8bxn31DSRtjV1
        0tjcy9VmFGIcPNbBLzvekDARMOalMlSnqQ==
X-Google-Smtp-Source: ABdhPJyRy55rteDloN4fp5Ckk0jmo9LC9ah0Y/2tnfvswoQWmqTHuOp4/EhRxG6z7iY/RrH4H2rBiQ==
X-Received: by 2002:a67:8a83:: with SMTP id m125mr8274635vsd.50.1613819068052;
        Sat, 20 Feb 2021 03:04:28 -0800 (PST)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id q205sm1512370vkq.3.2021.02.20.03.04.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Feb 2021 03:04:27 -0800 (PST)
From:   Honglei Wang <redsky110@gmail.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, redsky110@gmail.com
Subject: [PATCH] tcp: avoid unnecessary loop if even ports are used up
Date:   Sat, 20 Feb 2021 19:03:56 +0800
Message-Id: <20210220110356.84399-1-redsky110@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are getting port for connect() from even ports firstly now. This
makes bind() users have more available slots at odd part. But there is a
problem here when the even ports are used up. This happens when there
is a flood of short life cycle connections. In this scenario, it starts
getting ports from the odd part, but each requirement has to walk all of
the even port and the related hash buckets (it probably gets nothing
before the workload pressure's gone) before go to the odd part. This
makes the code path __inet_hash_connect()->__inet_check_established()
and the locks there hot.

This patch tries to improve the strategy so we can go faster when the
even part is used up. It'll record the last gotten port was odd or even,
if it's an odd one, it means there is no available even port for us and
we probably can't get an even port this time, neither. So we just walk
1/16 of the whole even ports. If we can get one in this way, it probably
means there are more available even part, we'll go back to the old
strategy and walk all of them when next connect() comes. If still can't
get even port in the 1/16 part, we just go to the odd part directly and
avoid doing unnecessary loop.

Signed-off-by: Honglei Wang <redsky110@gmail.com>
---
 net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 45fb450b4522..c95bf5cf9323 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct net *net = sock_net(sk);
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
-	int ret, i, low, high;
+	int ret, i, low, high, span;
 	static u32 hint;
 	int l3mdev;
+	static bool last_port_is_odd;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	 */
 	offset &= ~1U;
 other_parity_scan:
+	/* If the last available port is odd, it means
+	 * we walked all of the even ports, but got
+	 * nothing last time. It's telling us the even
+	 * part is busy to get available port. In this
+	 * case, we can go a bit faster.
+	 */
+	if (last_port_is_odd && !(offset & 1) && remaining > 32)
+		span = 32;
+	else
+		span = 2;
+
 	port = low + offset;
-	for (i = 0; i < remaining; i += 2, port += 2) {
+	for (i = 0; i < remaining; i += span, port += span) {
 		if (unlikely(port >= high))
 			port -= remaining;
 		if (inet_is_local_reserved_port(net, port))
@@ -806,6 +818,11 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 ok:
 	hint += i + 2;
 
+	if (offset & 1)
+		last_port_is_odd = true;
+	else
+		last_port_is_odd = false;
+
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
-- 
2.14.1

