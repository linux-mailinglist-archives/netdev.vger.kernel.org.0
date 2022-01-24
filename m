Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2162A497EF8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbiAXMO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238940AbiAXMOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AB2C061771;
        Mon, 24 Jan 2022 04:13:52 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id j2so20653026ejk.6;
        Mon, 24 Jan 2022 04:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q+i1GXFoVnacWowwhw+GPH5NaQy9l42ewHCsWDJflOE=;
        b=CrMOXFpONHyiFS165Yv4Z38PkxPSwat+/pJm9P9jZzVszvOiYiLyr0W598sfWYRE8O
         8fpTR6NgSsPQp5XBcnlnpha1PxsWAkAP1M+d9+n/wE95lureZNk8Dm1kIdljK4b7J/x2
         FOjUuvTB001YSkS4qMIia9i3DU7xGx8DYikhVdRlje6ghp8egzpTO5Rn8jd9qqBurLQl
         e9xxXjplgtW/lBYwdIGSaXe3JK7v4vZNeqjfsLxsOCauT/MJZPNtx/Q5xUpb3WQ38KJT
         WB614eZVWpiZtMIJpKoLwuBFPsweSRV4p/VnYMR+DiC41BSeAPN/AuJtItSAKJ3geipG
         r+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q+i1GXFoVnacWowwhw+GPH5NaQy9l42ewHCsWDJflOE=;
        b=77JgJK7f7K8LjWHzPW33Z+zdvXXgztfA1YlWXzURusLLYjcs3DT+8aMWyR6llGWSqS
         Updw1YRcG16IJeaLyAX2ZcpSui+1mKKO5Dv+zAXC6wf0ivUu5OC6DDtt+HijoKxGvDT9
         SXK4X5kx4eT27/dWyOdIhuvXaQh7BMpU++9kPAh7EjwgrieJkJHOXmxCEobZnE5O+eJi
         OF7gsTDOzzhNFnWpErZzgKzn/3D4f7kalINLLj8SAEcl6eGbunfUMoFpNmnUmStvdF9k
         4NYLHWtGnetuXx05bkpNOKpXkGDEiZTDJ84PEQcei8N+ambY0di/6/i9MhuRlC0o/bPR
         3KvA==
X-Gm-Message-State: AOAM533nRgJAxvsWutQmoNpn1jUGLKO1NvPPVZzIsT6sTGfHaEbcQKL/
        zp6CyFcDeSjcJcN+A61L2G4=
X-Google-Smtp-Source: ABdhPJwoDnOBcACfXg52F5qv8WsaDF7Bkh6aTrc1pCcLkeV6xG52a8+ihIm0MkDveyHxeRJJkhdjVA==
X-Received: by 2002:a17:906:6a25:: with SMTP id qw37mr4274450ejc.1.1643026430759;
        Mon, 24 Jan 2022 04:13:50 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:50 -0800 (PST)
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
Subject: [PATCH v5 16/20] tcp: authopt: Add /proc/net/tcp_authopt listing all keys
Date:   Mon, 24 Jan 2022 14:13:02 +0200
Message-Id: <7a9d28377287757e76968e5eb006c06398e0f1a2.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides a very brief summary of all keys for debugging purposes.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  10 +++
 net/ipv4/tcp_authopt.c                   | 102 ++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletion(-)

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
index c4b3c3e0e9ca..5ea93eb495f1 100644
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
@@ -1693,26 +1694,125 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
+#ifdef CONFIG_PROC_FS
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
+#endif /* CONFIG_PROC_FS */
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

