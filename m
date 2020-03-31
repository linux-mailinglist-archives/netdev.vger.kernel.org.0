Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B779198A85
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgCaDeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:34:12 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32939 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbgCaDeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:34:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id v7so21662479qkc.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 20:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6vvFvD0Fu94rDhVGbacBgOPPPl4NytLtvez2Sv9wd8=;
        b=HU/ay3aD3gOwjD6h8b4qEy11p0woY9LSL6xxVeNTwN7cUY6EjOg+kelAcaQbraYTW5
         whjWPGcGmiqaw8nMDWDtCNQcqwLVvAs4jby5CCmE+NfRqhWequ0bFX7x1gG45vHn/3rB
         TCQbb2SJ1+JSmI2ewMCjbdxCvcSLL8UH8OSdk/y6vu3EjohDf2+yomydVbkYiYA+VTJJ
         h8i4UJ6SUoeeI48XeH2kuFfQuJe7EbeU9FMnf4L07NGR04aZyEwMTXLcTaO5hRMmWK3I
         3aK4fXXXowAFT/kpKKRBKn8abMBsvJKpFzcMUeFIbWECAV3QQxE4g7TV9hQfxfxMBBaW
         iYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6vvFvD0Fu94rDhVGbacBgOPPPl4NytLtvez2Sv9wd8=;
        b=HRGff+yTSvX5NH6kF7w0Rrbkl1pjHjfyqrXyCkqruwkoMNh2FmDu5pivXyX3cLbR+u
         mYECM7tmCpuFI5j6Du91V6m07j7NU5Ypvg7p9KprEir/9BLL7ENnIuaae2c8OrNU9irs
         4k/7RLU995dQKOjpubP9po/iQXv6ohs7QUnIG//gc3NkbIeXr7D1h2enkG0Vo+qeLweN
         0mHTkz3zUaGzukqPQStEGqmzuCEf0iOdbobCatIYi81zhqhttWYX/bJkztfJkCxVfuFm
         ZMWs8r9LxcXpemw4dWsT/c51Ff8HEtkPkTREBwKDg+lhvWHgBVLx4GHr/3hCJ8dQ23Hy
         Vk9A==
X-Gm-Message-State: ANhLgQ05GjvnSf7g04KaaNxDeR+WAzREmyqmZGn098o9LaL9ubPIoR8W
        KyoNfaiUnqgWuw9Kw7E9PAgSr11EHwI=
X-Google-Smtp-Source: ADFU+vsjyInId8tm2kUNj8io0vUYqrZXOg8ZNEQWpNwobDMqkE01wdh/vOPFeYscTZlAPDjOHgkWBw==
X-Received: by 2002:a37:aa14:: with SMTP id t20mr3186171qke.401.1585625650963;
        Mon, 30 Mar 2020 20:34:10 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p38sm13077263qtf.50.2020.03.30.20.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 20:34:10 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] neigh: support smaller retrans_time settting
Date:   Tue, 31 Mar 2020 11:33:56 +0800
Message-Id: <20200331033356.29956-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we limited the retrans_time to be greater than HZ/2. For
example, if the HZ = 1000, setting retrans_time less than 500ms will
not work. This makes the user unable to achieve a more accurate control
for bonding arp fast failover.

But remove the sanity check would make the retransmission immediately
if user set retrans_time to 0 by wrong config. So I hard code the sanity
check to 10, which is 10ms if HZ is 1000 and 100ms if HZ is 100.
This number should be enough for user to get more accurate neigh
control.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 789a73aa7bd8..245bb5bd30e2 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1125,7 +1125,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 			neigh->nud_state     = NUD_INCOMPLETE;
 			neigh->updated = now;
 			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
-					 HZ/2);
+					 10);
 			neigh_add_timer(neigh, next);
 			immediate_probe = true;
 		} else {
-- 
2.19.2

