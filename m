Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4784100870
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 16:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfKRPk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 10:40:56 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43400 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfKRPkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 10:40:55 -0500
Received: by mail-qk1-f194.google.com with SMTP id z23so14756271qkj.10;
        Mon, 18 Nov 2019 07:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lb9xUffK0S+tRFsoPZYkXfbzmhBqUpKJNWxQK/Zlb48=;
        b=L3U3EwUQ54CTe62U/pP/8QCbpUTA1+vci2M1SeZx838VIvVHc8DCZohQL9eXoblQpF
         cba0kcKICrfZn3k0d+f9QSlVQm0qqC39B7GHA0y+owieMWqEF9G7W0Pls/6fm1i8N+k7
         DDZ4miZZ1BLmkDd3CJQBHE0SDbLtzU5ZnVmKgW6qNJ54N6fHiZYINvBqypAIJqWlaanb
         9K4CVsXbmuGSzL/vRR78OBCd4BM9HQlgQftunPT8cpjcsibUdFprMWXk9kiQFMeMHAxc
         ylG0divhSS9Hc8hAkumm5DqOjH9ILvx0JjODJl54vi4WY1HL+Yx7V6Lm7FBn2Da5ELfO
         9bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lb9xUffK0S+tRFsoPZYkXfbzmhBqUpKJNWxQK/Zlb48=;
        b=iqwWbPwrq9bBPlP6EPQYFp1BXINMWOhwAGVjpxyTz7AoasuthcGReVmvvmf/898dZq
         49JtPcAb6krMosdNG2GcnVYIpsjcz7WfsB84Ouw9ZPsdiKFrz7ycsqs7/EweWmY1rMq8
         ttb0D0sVlV5McJ90gk0NY4ri2KMwbq9e9gW0QgKQm/zqKzQj4YFHlSIJu70/94F39PKA
         rbM2qMM3itH1qHJw1uwA2ZOU17szW/w1KSJ1utgoVx/IFO7X668IfNQ3Ju/3tEwwVozT
         2kya65iDPHHKUlLueuwOa7zmqLkS+R/20+JBQLxkIxArbqQx4lhyLO9IKYqOe1babnAl
         JNrA==
X-Gm-Message-State: APjAAAVSZiiBaW9VEEa1r8f2qnT1Jzyryw+8re8B4D8eZ3y8Hvau/Ze4
        3JSWlH+/wexDYNVWTBB3Uxm+3/SH
X-Google-Smtp-Source: APXvYqzN/yFsihE08uPK1O6QVhGsFZdWXgq1rls4Idul8M2B/cKIU5vrjtRuFDOeT/UwCiAE6se6rg==
X-Received: by 2002:a05:620a:14b9:: with SMTP id x25mr25407653qkj.8.1574091654523;
        Mon, 18 Nov 2019 07:40:54 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:89db:8f93:8219:1619])
        by smtp.gmail.com with ESMTPSA id q70sm6664025qka.44.2019.11.18.07.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:40:53 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH] net/tls: enable sk_msg redirect to tls socket egress
Date:   Mon, 18 Nov 2019 10:40:51 -0500
Message-Id: <20191118154051.242699-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Bring back tls_sw_sendpage_locked. sk_msg redirection into a socket
with TLS_TX takes the following path:

  tcp_bpf_sendmsg_redir
    tcp_bpf_push_locked
      tcp_bpf_push
        kernel_sendpage_locked
          sock->ops->sendpage_locked

Also update the flags test in tls_sw_sendpage_locked to allow flag
MSG_NO_SHARED_FRAGS. bpf_tcp_sendmsg sets this.

Link: https://lore.kernel.org/netdev/CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com/T/#t
Link: https://github.com/wdebruij/kerneltools/commits/icept.2
Fixes: 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through ULP")
Fixes: f3de19af0f5b ("Revert \"net/tls: remove unused function tls_sw_sendpage_locked\"")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/net/tls.h  |  2 ++
 net/tls/tls_main.c |  1 +
 net/tls/tls_sw.c   | 11 +++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 794e297483eab..f4ad831eaa02b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -356,6 +356,8 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
+			   int offset, size_t size, int flags);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
 void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 0775ae40fcfb4..f874cc0da45df 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -908,6 +908,7 @@ static int __init tls_register(void)
 {
 	tls_sw_proto_ops = inet_stream_ops;
 	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
+	tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
 
 	tls_device_init();
 	tcp_register_ulp(&tcp_tls_ulp_ops);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 446f23c1f3ce4..319735d5c084f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1204,6 +1204,17 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	return copied ? copied : ret;
 }
 
+int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
+			   int offset, size_t size, int flags)
+{
+	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
+		      MSG_NO_SHARED_FRAGS))
+		return -ENOTSUPP;
+
+	return tls_sw_do_sendpage(sk, page, offset, size, flags);
+}
+
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags)
 {
-- 
2.24.0.432.g9d3f5f5b63-goog

