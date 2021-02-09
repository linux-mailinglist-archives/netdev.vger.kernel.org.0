Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3426B31574A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhBIT6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbhBITq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:46:58 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26F9C061224
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:20:37 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o21so11696898pgn.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0Iw2wOHN1641GyiRl5J1CA2TZYNgtZQZmyhVPXKe9g=;
        b=ZnxWb8L+lnAX2clf6e2m+1QaBsrHQg6caYu1dEe6DOQymkeP1vX5Gw+3xwBzcQNKmt
         +L7xtaol7M0nUBDmGjJ1dmR7jEcXTPCANgIowVKQk4m+shanwlOXJO8RTbQRTeQAswzO
         qWrCZrKB7fDXozPoC3lRw68sbqtTmKdBUjmjasT/+eVP4Q143uZUaZ4MRfK72iTNHCm4
         E1aXOR86DmjBxjKwNTGSq1wzbYkPbrN/qQmGcbOwH9wkZiNBFn57jtqjmdQj4paC7Js/
         m1mVxc1D27eiQl2PUPoJ8i5pQeU7oL0oV4/bz8+q/SNdKsKtbicnvWNZBjJAlX11O/wY
         H7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0Iw2wOHN1641GyiRl5J1CA2TZYNgtZQZmyhVPXKe9g=;
        b=jUuZIb4qX5bK//+zUL4p2w8da+4fmUx9nWogyR0aQzqoZqlaY7DLPh4+reIUaClj2Z
         2Db3xeh24XgCk3AFZO2AuN1GU2RgY7il17k0YVtqctX0DsVtWev/UyOI3mOhxxQ3L4Ay
         UtSqKSDEkOYp/XYmmGwfPjATsMKiyJBxwplqAK5UI4hYwLm2+FJQ0nIq4ir9eEQ5bZv4
         8ccD4v9bvJmxK5GhNGk56H44FoTbVBY6ZBYIb+YydUPmHfbNNmrtZ2hZQX6r32K3KCSr
         Sif9R5CYv4rtyCnce1HglZB7+D0tlF41VAdns8Yz4Zk2Cn8k/6GWGG36w+v4VEePzQG3
         XzzQ==
X-Gm-Message-State: AOAM531nsW/0sa9f8VxLqmDBDm8pF/KaNBW2OSLRLZp/62iBhMPam23J
        dGtzst3FGb8DU7o7Aa3P074=
X-Google-Smtp-Source: ABdhPJwr6PDkTm5p0N5+08UYhEF2m7s/TjEsCxFinXpOB5Cgd4ZjeqMQAACn45qQIE4PvkThtxLNpQ==
X-Received: by 2002:a63:e0c:: with SMTP id d12mr2380021pgl.67.1612898437366;
        Tue, 09 Feb 2021 11:20:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3965:c391:f1c0:1de0])
        by smtp.gmail.com with ESMTPSA id p12sm3252390pju.35.2021.02.09.11.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:20:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 2/2] tcp: add some entropy in __inet_hash_connect()
Date:   Tue,  9 Feb 2021 11:20:28 -0800
Message-Id: <20210209192028.3350290-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210209192028.3350290-1-eric.dumazet@gmail.com>
References: <20210209192028.3350290-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Even when implementing RFC 6056 3.3.4 (Algorithm 4: Double-Hash
Port Selection Algorithm), a patient attacker could still be able
to collect enough state from an otherwise idle host.

Idea of this patch is to inject some noise, in the
cases __inet_hash_connect() found a candidate in the first
attempt.

This noise should not significantly reduce the collision
avoidance, and should be zero if connection table
is already well used.

Note that this is not implementing RFC 6056 3.3.5
because we think Algorithm 5 could hurt typical
workloads.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/inet_hashtables.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 12808dac923a4c29cb152201140757c69ba165e5..c96866a53a664601fdb8904f486cc590675ae34f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -818,6 +818,11 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
+	/* If our first attempt found a candidate, skip next candidate
+	 * in 1/16 of cases to add some noise.
+	 */
+	if (!i && !(prandom_u32() % 16))
+		i = 2;
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
-- 
2.30.0.478.g8a0d178c01-goog

