Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474236933A1
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 21:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBKUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 15:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBKUUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 15:20:12 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A325E193D7;
        Sat, 11 Feb 2023 12:20:11 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id d21-20020a056830005500b0068bd2e0b25bso2611008otp.1;
        Sat, 11 Feb 2023 12:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cPpKvc1ii1yZFKy7PiMFMJNSlFtwdeSsm6XH0FLqQaE=;
        b=mADuYMBOR3jr/emS9tlA3srHWJ1JwQTV1ThJR4hCafSUVBxPVtS0Pyds0J34J0IqAi
         v/6bEnn2AVs1EHvjxvJq3crZyOFi/yPCWvhPwmbwu8rwceCRVDRiSri0ejlpHLYiQ0ZG
         Iuv5fxZJfx7qsRjouUgKQuJHnJq7e3fFeNNYSMFQSIOaIH6aoSY+MmlqZpIIYcMtzP0L
         koS0qIa1wKnBIxj1hkA/hUOsMkWDYirOkL16mz/Q5AIAQru0RSL+f1ZIdS1AGfI+0Eqh
         jfsnQqD7BN8RnCOU1MBM/eR149myTMSX4i5ZM5KBouKEmaFfUH2Fn+iZj5RuCQ3edCCH
         Ub1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPpKvc1ii1yZFKy7PiMFMJNSlFtwdeSsm6XH0FLqQaE=;
        b=s/uyw5hYJiYRpqriLg6Gh9eaQAtnzw8wYz5Nk2iJl67HU1PomSAttAWfTwTl6yy7hz
         E2L2O2noPLSLZzg2FY81Snfux+CJ8tYZj05a1/ZHBmAZkZTl3CEYpMvKamTXn4RLPyVA
         D8ztcQ2cyWT3ZWh//3Pc0S551g4U1/zmyyiHOqmzRZ6x6L3Xqm5v32El7YdVgwNZ2DXm
         mm/caRiHztDtcXnt1h6totqpFndVzpyLq5pdqx1CNNUhLxMkdB6B1kzY9iHGCUDg81Ni
         Iy0DihQA7oq+O0Kl+Woz9prb2FJeHarZ9o1RNoA4OSxQKK6RnIHX+bMmyhZbKPykQCTX
         dUnA==
X-Gm-Message-State: AO0yUKVjGZd59GcFwrSuqBfExaH3cejBrDEQnbaxDf4M3v+wJhe6XT0k
        X+b2so46VGXNvk2EMXk7JF0YceddVvA=
X-Google-Smtp-Source: AK7set/onB5pTS+ESJyHYJaEf0fSkTdSV81LBb5qnVxhi3vVSiTqOOfKNdyE6kVxULMM401GWmjWiQ==
X-Received: by 2002:a9d:37ca:0:b0:68b:e208:24d9 with SMTP id x68-20020a9d37ca000000b0068be20824d9mr9109481otb.16.1676146810702;
        Sat, 11 Feb 2023 12:20:10 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:bbce:8780:7138:8c15])
        by smtp.gmail.com with ESMTPSA id a1-20020a9d74c1000000b006864816ecd9sm3443320otl.59.2023.02.11.12.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 12:20:09 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net-next] sock_map: dump socket map id via diag
Date:   Sat, 11 Feb 2023 12:19:54 -0800
Message-Id: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently there is no way to know which sockmap a socket has been added
to from outside, especially for that a socket can be added to multiple
sockmap's. We could dump this via socket diag, as shown below.

Sample output:

  # ./iproute2/misc/ss -tnaie --sockmap
  ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1

  # bpftool map
  1: sockmap  flags 0x0
  	key 4B  value 4B  max_entries 2  memlock 4096B
	pids echo-sockmap(549)
  4: array  name pid_iter.rodata  flags 0x480
	key 4B  value 4B  max_entries 1  memlock 4096B
	btf_id 10  frozen
	pids bpftool(624)

In the future, we could dump other sockmap related stats too, hence I
make it a nested attribute.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/inet_diag.h |  1 +
 include/uapi/linux/sock_diag.h |  8 ++++++
 include/uapi/linux/unix_diag.h |  1 +
 net/core/sock_map.c            | 49 ++++++++++++++++++++++++++++++++++
 net/ipv4/inet_diag.c           |  5 ++++
 net/unix/diag.c                |  6 +++++
 7 files changed, 71 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35c18a98c21a..f23b97e0fe71 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2539,6 +2539,7 @@ int sock_map_bpf_prog_query(const union bpf_attr *attr,
 void sock_map_unhash(struct sock *sk);
 void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
+int sock_map_idiag_dump(struct sock *sk, struct sk_buff *skb, int attr);
 #else
 static inline int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log,
 					    struct bpf_prog_aux *prog_aux)
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 50655de04c9b..6c6952c2eb70 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -161,6 +161,7 @@ enum {
 	INET_DIAG_SK_BPF_STORAGES,
 	INET_DIAG_CGROUP_ID,
 	INET_DIAG_SOCKOPT,
+	INET_DIAG_SOCKMAP,
 	__INET_DIAG_MAX,
 };
 
diff --git a/include/uapi/linux/sock_diag.h b/include/uapi/linux/sock_diag.h
index 5f74a5f6091d..5deb22057d14 100644
--- a/include/uapi/linux/sock_diag.h
+++ b/include/uapi/linux/sock_diag.h
@@ -62,4 +62,12 @@ enum {
 
 #define SK_DIAG_BPF_STORAGE_MAX        (__SK_DIAG_BPF_STORAGE_MAX - 1)
 
+enum {
+	SK_DIAG_BPF_SOCKMAP_NONE,
+	SK_DIAG_BPF_SOCKMAP_MAP_ID,
+	__SK_DIAG_BPF_SOCKMAP_MAX,
+};
+
+#define SK_DIAG_BPF_SOCKMAP_MAX        (__SK_DIAG_BPF_SOCKMAP_MAX - 1)
+
 #endif /* _UAPI__SOCK_DIAG_H__ */
diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag.h
index a1988576fa8a..a21a25030b13 100644
--- a/include/uapi/linux/unix_diag.h
+++ b/include/uapi/linux/unix_diag.h
@@ -42,6 +42,7 @@ enum {
 	UNIX_DIAG_MEMINFO,
 	UNIX_DIAG_SHUTDOWN,
 	UNIX_DIAG_UID,
+	UNIX_DIAG_SOCKMAP,
 
 	__UNIX_DIAG_MAX,
 };
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a68a7290a3b2..fa3068857a8a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1636,6 +1636,55 @@ void sock_map_close(struct sock *sk, long timeout)
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
 
+int sock_map_idiag_dump(struct sock *sk, struct sk_buff *skb, int attrtype)
+{
+	struct sk_psock_link *link;
+	struct nlattr *nla, *attr;
+	int nr_links = 0, ret = 0;
+	struct sk_psock *psock;
+	u32 *ids;
+
+	rcu_read_lock();
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	nla = nla_nest_start_noflag(skb, attrtype);
+	if (!nla) {
+		sk_psock_put(sk, psock);
+		rcu_read_unlock();
+		return -EMSGSIZE;
+	}
+	spin_lock_bh(&psock->link_lock);
+	list_for_each_entry(link, &psock->link, list)
+		nr_links++;
+
+	attr = nla_reserve(skb, SK_DIAG_BPF_SOCKMAP_MAP_ID,
+			   sizeof(link->map->id) * nr_links);
+	if (!attr) {
+		ret = -EMSGSIZE;
+		goto unlock;
+	}
+
+	ids = nla_data(attr);
+	list_for_each_entry(link, &psock->link, list) {
+		*ids = link->map->id;
+		ids++;
+	}
+unlock:
+	spin_unlock_bh(&psock->link_lock);
+	sk_psock_put(sk, psock);
+	rcu_read_unlock();
+	if (ret)
+		nla_nest_cancel(skb, nla);
+	else
+		nla_nest_end(skb, nla);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sock_map_idiag_dump);
+
 static int sock_map_iter_attach_target(struct bpf_prog *prog,
 				       union bpf_iter_link_info *linfo,
 				       struct bpf_iter_aux_info *aux)
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index b812eb36f0e3..8fe43b6324c2 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -197,6 +197,11 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 		    &inet_sockopt))
 		goto errout;
 
+#ifdef CONFIG_BPF_SYSCALL
+	if (sock_map_idiag_dump(sk, skb, INET_DIAG_SOCKMAP))
+		goto errout;
+#endif
+
 	return 0;
 errout:
 	return 1;
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 616b55c5b890..0c5d39889045 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -6,6 +6,7 @@
 #include <linux/skbuff.h>
 #include <linux/module.h>
 #include <linux/uidgid.h>
+#include <linux/bpf.h>
 #include <net/netlink.h>
 #include <net/af_unix.h>
 #include <net/tcp_states.h>
@@ -172,6 +173,11 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sk_diag_dump_uid(sk, skb, user_ns))
 		goto out_nlmsg_trim;
 
+#ifdef CONFIG_BPF_SYSCALL
+	if (sock_map_idiag_dump(sk, skb, UNIX_DIAG_SOCKMAP))
+		goto out_nlmsg_trim;
+#endif
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.34.1

