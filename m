Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F06D13E1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfJIQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:20:06 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56641 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbfJIQUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:20:06 -0400
Received: by mail-pg1-f201.google.com with SMTP id u4so1997368pgp.23
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=x8/6sJQlj0PTWZoHoUuB9hj4CWLzDFEyk9p4/q4u0+0=;
        b=fRUj6kYzxiGvntd6r0zywr7P/LwAlhfec969iLqbsr7LRGVVG6+THHPCcTW12dqXca
         gOZOJ7Bg1VWrril0kk1n7fWzgZkHs8UZYP0qoHMWbP6olUePPISoEXr5Sekkjd3Hlu73
         Nw2Pa9OTO+/PsphGd/MjHRn6ad6aE0f41+xyZbYW74RTgyJPOTB1vOdT8QssoanIOk3V
         RRTru6mTpHuOajgqYG0gNqI5Pe94Fli8t0JVVCtwefixuSoWs/x5wkyztXxBgglKT/yj
         UP1ztG4gfU6HfJyNwoJjvRcAmU17a3UyHjAL+waxJx+Pcm6cYm294GE9IghSJlf+dZHR
         smyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=x8/6sJQlj0PTWZoHoUuB9hj4CWLzDFEyk9p4/q4u0+0=;
        b=DKKRaP93A23CAJ4lU7QcdHNqSBWe/V8Y2cz177mYNT3JmmTRSswTQpFrklA5+XM51z
         lvuGmJ/mTnlDKAgcMr3rtXirzwx7I3jiz48bW0UUNwKD4wnJ53E7AUkNAe9nt5zSUq41
         FxqZ/aTjg4OgwWmhasl0PSbh/jJWWtYDdkmVEVr637wehanuIUGXfVss8qSxcTSbFZ78
         chtqaXTQJfBQHF/h1q4mEzI9M3aUF71+zgKapliPLVVTWlFhRgnu2xEmOyRlA1d9T8iN
         hpL57piUJwFLcBRgTFJOiYKPoYNorbKhFX2VyiO0nGkAj1yIG6S1MyWQr7K0ZPXfy9Fl
         y9VQ==
X-Gm-Message-State: APjAAAUtZ0xp0YwDvv86EN/v148xnRsHPS0kdAuEexRdoWUFj8EIKBXd
        I7UhqMlL6s7BvNTXVn0mI/pzXg7sfUVKyg==
X-Google-Smtp-Source: APXvYqxn/DjUM9cK5YZEaW+FyT9M80b6w3Wd2CLyMcVlqzbiqUzl//vd5my6jaUNm5fPgcTU9gtttJ/S0faHlg==
X-Received: by 2002:a65:58c5:: with SMTP id e5mr5089842pgu.93.1570638005189;
 Wed, 09 Oct 2019 09:20:05 -0700 (PDT)
Date:   Wed,  9 Oct 2019 09:20:02 -0700
Message-Id: <20191009162002.19360-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] tun: remove possible false sharing in tun_flow_update()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Zhang Yu <zhangyu31@baidu.com>, Wang Li <wangli39@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
a C compiler can legally transform

if (e->queue_index != queue_index)
	e->queue_index = queue_index;

to :

	e->queue_index = queue_index;

Note that the code using jiffies has no issue, since jiffies
has volatile attribute.

if (e->updated != jiffies)
    e->updated = jiffies;

Fixes: 83b1bc122cab ("tun: align write-heavy flow entry members to a cache line")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhang Yu <zhangyu31@baidu.com>
Cc: Wang Li <wangli39@baidu.com>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 812dc3a65efbb9d1ee2724e73978dbc4803ec171..a8d3141582a53caf407dc9aff61c452998de068f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -526,8 +526,8 @@ static void tun_flow_update(struct tun_struct *tun, u32 rxhash,
 	e = tun_flow_find(head, rxhash);
 	if (likely(e)) {
 		/* TODO: keep queueing to old queue until it's empty? */
-		if (e->queue_index != queue_index)
-			e->queue_index = queue_index;
+		if (READ_ONCE(e->queue_index) != queue_index)
+			WRITE_ONCE(e->queue_index, queue_index);
 		if (e->updated != jiffies)
 			e->updated = jiffies;
 		sock_rps_record_flow_hash(e->rps_rxhash);
-- 
2.23.0.581.g78d2f28ef7-goog

