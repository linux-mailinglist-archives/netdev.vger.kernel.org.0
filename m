Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E792149251D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbiARLnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiARLnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:43:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C94DC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 03:43:45 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 78so12814443pfu.10
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 03:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+N7faLpbfNcs1Qm4WsP6feOfHuX0iiW37CaBCIfqYU=;
        b=BrsHRdrtn3uehO5+h4WoiuHgsvGQQghjCkzhngusulWWD0K9mB4zJGnqZeue52MNnX
         ngw4VcM0UbGJAKZoEq7QYk4JB0hCdcHte/QMQAJOm5zBGuxHBnTT27QQxVjtrJoP3qYa
         wLUPjK9Bu1tFkP1CRWPAdzNKKhRUEUHQgDtxu2keF0gz6sW0At/hXx2NKoYJVdLgYR16
         4zmhbE/hx/wO5Oi7jceZL/yCYbX51jVAe8/fyL+N55186r3jPEjLxx7KywcoCOdu7tBU
         toLR+RudK3m5Cc64jQX7qg6bnf5U4GnQoA+ft2Cx5Nc7pMjYfo7jAgSiBve1QAkCAiAQ
         fPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+N7faLpbfNcs1Qm4WsP6feOfHuX0iiW37CaBCIfqYU=;
        b=0VLXJXFj5G4vakA4Y43GnVX7olPpIkjXzwTBDgPzj5enIXv4+sSzjJGDieglFM5w3V
         nPoozydgBoEmP+TidB4F02lFB80fmUFe11l+P0hTmjOyIXcifZFR0eyN92g1n1RXDDGw
         a80Kk+wFyw9o1ZEbk/T+vxjGT7F8U92NNyNFemJsTXLkBzIOIGh+E0xEjOeC408NW/5O
         qFvgX2m47UYoHh98uHvG5bgOnPNoyaEU9G3+QegwQq0G/OLzNIaQ2VvL/hiGuFAiyM2t
         NY4B+kFjTrPkjE558avVL6tUUbZjBU9a3CoLXx0kJ9pfVryLXAGN5V/1mUcP5BkXhe6y
         RI4A==
X-Gm-Message-State: AOAM532Vqoo8Uhw76gjIURjUiL41btLLOZqFO1/ZFJ6Pa/ApyBdGrKKJ
        /mW6K8mXe/xKrLg1ej2KHVY=
X-Google-Smtp-Source: ABdhPJysm6quwBZEIaXvP8NZQZlcnR1Ie+KMrzkhmYxcHaXy3vOJNd2HHZn2krr08ezdOq4htfBLjQ==
X-Received: by 2002:a63:9043:: with SMTP id a64mr19436162pge.573.1642506225004;
        Tue, 18 Jan 2022 03:43:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6f4e:f5d3:49c4:16ca])
        by smtp.gmail.com with ESMTPSA id n15sm2341282pjn.32.2022.01.18.03.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 03:43:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: [PATCH net] netns: add schedule point in ops_exit_list()
Date:   Tue, 18 Jan 2022 03:43:40 -0800
Message-Id: <20220118114340.3322252-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

When under stress, cleanup_net() can have to dismantle
netns in big numbers. ops_exit_list() currently calls
many helpers [1] that have no schedule point, and we can
end up with soft lockups, particularly on hosts
with many cpus.

Even for moderate amount of netns processed by cleanup_net()
this patch avoids latency spikes.

[1] Some of these helpers like fib_sync_up() and fib_sync_down_dev()
are very slow because net/ipv4/fib_semantics.c uses host-wide hash tables,
and ifindex is used as the only input of two hash functions.
    ifindexes tend to be the same for all netns (lo.ifindex==1 per instance)
    This will be fixed in a separate patch.

Fixes: 72ad937abd0a ("net: Add support for batching network namespace cleanups")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/net_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b7171c40434985b869c1477975fc75447d78c3b..a5b5bb99c64462dac2513f7b3e28cb0763844c21 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -164,8 +164,10 @@ static void ops_exit_list(const struct pernet_operations *ops,
 {
 	struct net *net;
 	if (ops->exit) {
-		list_for_each_entry(net, net_exit_list, exit_list)
+		list_for_each_entry(net, net_exit_list, exit_list) {
 			ops->exit(net);
+			cond_resched();
+		}
 	}
 	if (ops->exit_batch)
 		ops->exit_batch(net_exit_list);
-- 
2.34.1.703.g22d0c6ccf7-goog

