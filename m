Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5E646B1B3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhLGEFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbhLGEFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:44 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75371C061354
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:14 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id m25so13057660qtq.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MJ0RHEHh6iPlP/wHXmf9A30Q7rZb8zmv5AU20e7Fpng=;
        b=E6Ev3+v3Z3b/2saNHSHfbMlXQ4a0AT/Bdl8j+pgS20sjZk8PL2yxalNcINW/0rdGpf
         V6HHNwUAxes+ZFhp6tH0gsu8tdyv+lPeAB4VckdG5Ahe5XeSOGL7z7x4782LsxQTy7AG
         tVGD9q3jQvV4yeMHPUsYaUM4Z0u7dTLhpz5RuAiKkTqHoIOBW55jIYkiHRLokFiiM8/+
         F8/WZYyXpcsdW9tgyhRlhM/goB3zLnHoPjn2/0VmCGI/ssIVK8t+eLi4Rb67bQo0VC/c
         2zuvaSUR+xIffqa6oj4zadsqmugbQ2Z6hc+LV7PEDo00LarB6mYGwsxisv3uOqdFsNIF
         JMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MJ0RHEHh6iPlP/wHXmf9A30Q7rZb8zmv5AU20e7Fpng=;
        b=MD9Bk1MJR5517YIoY3KwR5ViW3pkZk63FlwyCe+0O7Jw3XGDBmnUjfv3kxG3ltD1/G
         37FuNMhKtr4a6xleUxervRmZ9jHwJSfERj1HdYe4FQNHgZkqG/hDMetazy0wuEMhDS4a
         +2I7UfhlPxU9KNuZWuLOsVdvIk4WtnZaPzxUVJksOSodxEZMuazouoyQcSdMhgFWem4H
         Kyxnopx4cux4tN66MaKLCh4Gh+zAjOwG8vkvquofaZWeLhnLYlmyxEztJQEhe7BxskBz
         ObIxKoo7VIF5eMXz8JwfNmXCK/zq0wPgqJqr54/8ZdbU5bUwfPwL29Y4PqcAymTTIQZM
         ufMg==
X-Gm-Message-State: AOAM530iogBUjYphMyhGmsdZAK/Jgle3hgLkeA9rPjOE/ve8Nbx/fgbF
        MCwluuCShFFNZjSu+c3nm72Y/sD2R6H8Aw==
X-Google-Smtp-Source: ABdhPJxBrX5wLP1E4lG8I+DilBK9gQDVtVsEk09pD767Svcp3tB5L8oqoKQoV8jkwJNOobdleHapXw==
X-Received: by 2002:ac8:7d50:: with SMTP id h16mr46871829qtb.324.1638849733511;
        Mon, 06 Dec 2021 20:02:13 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/5] net: track dst refcnt with obj_cnt
Date:   Mon,  6 Dec 2021 23:02:06 -0500
Message-Id: <9dc7efe678baaafb5203da0c1f2b1127e88e81c5.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
References: <cover.1638849511.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two types are added into obj_cnt to count dst_hold* and dst_release*,
and all it does is put obj_cnt_track_by_dev() into these two
functions.

Here is an example to track the refcnt of a dst whose dev is dummy0:

  # sysctl -w obj_cnt.control="clear" # clear the old result

  # sysctl -w obj_cnt.type=0xc     # enable dst_hold/put track
  # sysctl -w obj_cnt.name=dummy0  # count dst_hold/put(dst)
  # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' call trace
  #
  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip addr add 1.1.1.1/24 dev dummy0
  # ping 1.1.1.2 -c 2
  # ip link set dummy0 down
  # ip link del dummy0

  # sysctl -w obj_cnt.control="scan"  # print the new result
  # dmesg
  OBJ_CNT: obj_cnt_dump: obj: ffff9e45d7e8b780, type: dst_hold, cnt: 1,:
       rt_cache_route+0x45/0xc0
       rt_set_nexthop.constprop.63+0x143/0x3c0
       ip_route_output_key_hash_rcu+0x256/0x9a0
       ip_route_output_key_hash+0x72/0xa0
  OBJ_CNT: obj_cnt_dump: obj: ffff9e45cbef9100, type: dst_put, cnt: 1,:
       dst_release+0x2a/0x90
       __dev_queue_xmit+0x72c/0xc90
       ip6_finish_output2+0x2d2/0x660
       ip6_output+0x6e/0x130
  ...
  OBJ_CNT: obj_cnt_dump: obj: ffff9e45ca463d00, type: dst_put, cnt: 1,:
       dst_release+0x2a/0x90
       __dev_queue_xmit+0x72c/0xc90
       ip6_finish_output2+0x1e8/0x660
       ip6_output+0x6e/0x130
  OBJ_CNT: obj_cnt_dump: obj: ffff9e45d7e8b780, type: dst_hold, cnt: 2,:
       ip_route_output_key_hash_rcu+0x88e/0x9a0
       ip_route_output_key_hash+0x72/0xa0
       ip_route_output_flow+0x19/0x50
       raw_sendmsg+0x32b/0xe40
  ...

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/obj_cnt.h | 2 ++
 include/net/dst.h       | 8 +++++++-
 include/net/sock.h      | 3 ++-
 lib/obj_cnt.c           | 4 +++-
 net/core/dst.c          | 2 ++
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/obj_cnt.h b/include/linux/obj_cnt.h
index bb2d37484a32..ae4c12beb876 100644
--- a/include/linux/obj_cnt.h
+++ b/include/linux/obj_cnt.h
@@ -5,6 +5,8 @@
 enum {
 	OBJ_CNT_DEV_HOLD,
 	OBJ_CNT_DEV_PUT,
+	OBJ_CNT_DST_HOLD,
+	OBJ_CNT_DST_PUT,
 	OBJ_CNT_TYPE_MAX
 };
 
diff --git a/include/net/dst.h b/include/net/dst.h
index 6aa252c3fc55..e2704495d32f 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -227,6 +227,7 @@ static inline void dst_hold(struct dst_entry *dst)
 	 * If your kernel compilation stops here, please check
 	 * the placement of __refcnt in struct dst_entry
 	 */
+	obj_cnt_track_by_dev(dst, dst->dev, OBJ_CNT_DST_HOLD);
 	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
 	WARN_ON(atomic_inc_not_zero(&dst->__refcnt) == 0);
 }
@@ -298,7 +299,12 @@ static inline void skb_dst_copy(struct sk_buff *nskb, const struct sk_buff *oskb
  */
 static inline bool dst_hold_safe(struct dst_entry *dst)
 {
-	return atomic_inc_not_zero(&dst->__refcnt);
+	if (atomic_inc_not_zero(&dst->__refcnt)) {
+		obj_cnt_track_by_dev(dst, dst->dev, OBJ_CNT_DST_HOLD);
+		return true;
+	}
+
+	return false;
 }
 
 /**
diff --git a/include/net/sock.h b/include/net/sock.h
index ae61cd0b650d..07d59c27ac11 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2071,8 +2071,9 @@ sk_dst_get(struct sock *sk)
 
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
-	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+	if (dst && !dst_hold_safe(dst))
 		dst = NULL;
+
 	rcu_read_unlock();
 	return dst;
 }
diff --git a/lib/obj_cnt.c b/lib/obj_cnt.c
index 12a1fdafd632..648adc135080 100644
--- a/lib/obj_cnt.c
+++ b/lib/obj_cnt.c
@@ -16,7 +16,9 @@ static spinlock_t		obj_cnt_lock;
 
 static char *obj_cnt_str[OBJ_CNT_TYPE_MAX] = {
 	"dev_hold",
-	"dev_put"
+	"dev_put",
+	"dst_hold",
+	"dst_put"
 };
 
 struct obj_cnt {
diff --git a/net/core/dst.c b/net/core/dst.c
index d16c2c9bfebd..94ff1fe0fc09 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -169,6 +169,7 @@ void dst_release(struct dst_entry *dst)
 	if (dst) {
 		int newrefcnt;
 
+		obj_cnt_track_by_dev(dst, dst->dev, OBJ_CNT_DST_PUT);
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
 		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
@@ -184,6 +185,7 @@ void dst_release_immediate(struct dst_entry *dst)
 	if (dst) {
 		int newrefcnt;
 
+		obj_cnt_track_by_dev(dst, dst->dev, OBJ_CNT_DST_PUT);
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
 		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
-- 
2.27.0

