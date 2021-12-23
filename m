Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7947E5C6
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349351AbhLWPlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349168AbhLWPlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:41:09 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BF9C06179C;
        Thu, 23 Dec 2021 07:41:08 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bm14so22947590edb.5;
        Thu, 23 Dec 2021 07:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4iUq/OcSfjWYCqr9JUkzg33/o8TN8G5Po1f+UBWAkdc=;
        b=BVffC+NmjubKsmKg0fVG3XWKoVupntAcAMgFs4YXFGPNto8HftLmDl6RGM/JrhD4XC
         EuckqX+ZQ8u2K3mUbrj23lqN0dQd05gRfeSIHruGfRpGwCO44qU/dO3fNHLZWSOCsrC/
         SbsBHxdZeUn4uORnXRYICAVqghtcTAnGke0gpmdn7EhH56pjTt+RbzM7YUjOGn0MG7uu
         fBdSrgzI++xciR+SpEp68eFz8NhgwYimeMEDHfi9kwWQlBQqkrMOhTYIffkIRCG2/hUw
         Pd4qXBRJAxa9xS/kzTh2s8bcaV3kkI4Hz7lTCeZb8dqGqnH4wgWmI/FNFvMu3cYo0+NP
         pHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4iUq/OcSfjWYCqr9JUkzg33/o8TN8G5Po1f+UBWAkdc=;
        b=hlMahct7Ma+Gx6QtLFHNb7HzCgxG58Ttilt01656EdlOjaYRAkE73pRsMMWCj1d4xn
         kc8OWAl8pmUnK9QBE51JYlucm7opZbCpaR8ma5U6e2BlrGn9+UFW9vj4M9AwpnlrOlLs
         jruRGHeg46AxVG333/1t1lv/FP1tGXgoCTs2O5HmKI859V4adetjWOw+4OzJPGkw8YyI
         vhLppx5mQ65PIOR7a908yBd91RJnmzvarGPGAGoyGQyWFLSMiQI9Dr267BYvVPo1LPac
         /9ESvtRAX7G0GTDBz4rw3ww7+HqSfea3g5MpB66Wq+2SHF7TizqNPu87zfHdov5EbycD
         2tJQ==
X-Gm-Message-State: AOAM530+xhOvSqwNiKviBn6QjoGbjmJ9Uv0/4rtiEnGa1WHb0WLITKQY
        eRk4lP3+MVpIvjJYa1BhsDU=
X-Google-Smtp-Source: ABdhPJxJHU3KajZgoUKDODBZwe3SOa5UFbtWtH4URSYNBLyZY4qEWR4/5XOTzkzxShhv08g3xH2tdQ==
X-Received: by 2002:a17:906:9b91:: with SMTP id dd17mr2332545ejc.371.1640274067040;
        Thu, 23 Dec 2021 07:41:07 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:41:06 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 16/19] tcp: authopt: Add /proc/net/tcp_authopt listing all keys
Date:   Thu, 23 Dec 2021 17:40:11 +0200
Message-Id: <80510f065b3b17d36626962cd7c7719036a6f9e1.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  10 +++
 net/ipv4/tcp_authopt.c                   | 100 ++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index 6520c6d02755..eaf389f99139 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -69,10 +69,20 @@ The rnextkeyid value sent on the wire is usually the recv_id of the current
 key used for sending. If the TCP_AUTHOPT_LOCK_RNEXTKEY flag is set in
 `tcp_authopt.flags` the value of `tcp_authopt.send_rnextkeyid` is send
 instead.  This can be used to implement smooth rollover: the peer will switch
 its keyid to the received rnextkeyid when it is available.
 
+Proc interface
+--------------
+
+The ``/proc/net/tcp_authopt`` file contains a tab-separated table of keys. The
+first line contains column names. The number of columns might increase in the
+future if more matching criteria are added. Here is an example of the table::
+
+	flags	send_id	recv_id	alg	addr	l3index
+	0x44	0	0	1	10.10.2.2/31	0
+
 ABI Reference
 =============
 
 .. kernel-doc:: include/uapi/linux/tcp.h
    :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 64bcb2a38472..22ce68c933a9 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -5,10 +5,11 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 #include <linux/inetdevice.h>
+#include <linux/proc_fs.h>
 
 /* This is mainly intended to protect against local privilege escalations through
  * a rarely used feature so it is deliberately not namespaced.
  */
 int sysctl_tcp_authopt;
@@ -1661,26 +1662,123 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
+struct tcp_authopt_iter_state {
+	struct seq_net_private p;
+};
+
+static struct tcp_authopt_key_info *tcp_authopt_get_key_index(struct netns_tcp_authopt *net,
+							      int index)
+{
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry(key, &net->head, node) {
+		if (--index < 0)
+			return key;
+	}
+
+	return NULL;
+}
+
+static void *tcp_authopt_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
+{
+	struct netns_tcp_authopt *net = &seq_file_net(seq)->tcp_authopt;
+
+	rcu_read_lock();
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+	else
+		return tcp_authopt_get_key_index(net, *pos - 1);
+}
+
+static void tcp_authopt_seq_stop(struct seq_file *seq, void *v)
+	__releases(RCU)
+{
+	rcu_read_unlock();
+}
+
+static void *tcp_authopt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct netns_tcp_authopt *net = &seq_file_net(seq)->tcp_authopt;
+	void *ret;
+
+	ret = tcp_authopt_get_key_index(net, *pos);
+	++*pos;
+
+	return ret;
+}
+
+static int tcp_authopt_seq_show(struct seq_file *seq, void *v)
+{
+	struct tcp_authopt_key_info *key = v;
+
+	/* FIXME: Document somewhere */
+	/* Key is deliberately inaccessible */
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "flags\tsend_id\trecv_id\talg\taddr\tl3index\n");
+		return 0;
+	}
+
+	seq_printf(seq, "0x%x\t%d\t%d\t%d",
+		   key->flags, key->send_id, key->recv_id, (int)key->alg_id);
+	if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+		if (key->addr.ss_family == AF_INET6)
+			seq_printf(seq, "\t%pI6", &((struct sockaddr_in6 *)&key->addr)->sin6_addr);
+		else
+			seq_printf(seq, "\t%pI4", &((struct sockaddr_in *)&key->addr)->sin_addr);
+		if (key->flags & TCP_AUTHOPT_KEY_PREFIXLEN)
+			seq_printf(seq, "/%d", key->prefixlen);
+	} else {
+		seq_puts(seq, "\t*");
+	}
+	seq_printf(seq, "\t%d", key->l3index);
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations tcp_authopt_seq_ops = {
+	.start		= tcp_authopt_seq_start,
+	.next		= tcp_authopt_seq_next,
+	.stop		= tcp_authopt_seq_stop,
+	.show		= tcp_authopt_seq_show,
+};
+
+static int __net_init tcp_authopt_proc_init_net(struct net *net)
+{
+	if (!proc_create_net("tcp_authopt", 0400, net->proc_net,
+			     &tcp_authopt_seq_ops,
+			     sizeof(struct tcp_authopt_iter_state)))
+		return -ENOMEM;
+	return 0;
+}
+
+static void __net_exit tcp_authopt_proc_exit_net(struct net *net)
+{
+	remove_proc_entry("tcp_authopt", net->proc_net);
+}
+
 static int tcp_authopt_init_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 
 	mutex_init(&net->mutex);
 	INIT_HLIST_HEAD(&net->head);
 
-	return 0;
+	return tcp_authopt_proc_init_net(full_net);
 }
 
 static void tcp_authopt_exit_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 	struct tcp_authopt_key_info *key;
 	struct hlist_node *n;
 
+	tcp_authopt_proc_exit_net(full_net);
 	mutex_lock(&net->mutex);
 
 	hlist_for_each_entry_safe(key, n, &net->head, node) {
 		hlist_del_rcu(&key->node);
 		tcp_authopt_key_put(key);
-- 
2.25.1

