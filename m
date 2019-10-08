Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770C2CF7CA
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfJHLJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:09:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42844 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfJHLJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:09:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so10568372pff.9;
        Tue, 08 Oct 2019 04:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=piBYC+xTNu6MxV9+NOSh3zpO0sO8KESWgSUsgu3eNtU=;
        b=ASdeA7+H2bVusTyCH1P+Q7Rhj97jmLuHTswSOkr0QHciMSY/aJw3XvcfHgADlYaGl6
         xvqOk7HcUhflg9m9B7o/0eaGYEludwVxVyXfwmtcX/AeQO9APsGHXMLi/AXpBVSfJQI/
         CR2On3GvcHVxACrT+qFwuVJDxM7J7QBvP1b/ZMmpskoKcPTKWGD+cChoo1wZ/AVSx07r
         1r5DaA4IP3KNQFw3hGLKiZ1MTbi423kRfQ1RwrxRCCCs2C1ysbvuno8Ow0B1oqB1/Nxd
         OZl3umhtmZ8hKkTSe3YALHx3OYgRDdmol38g4YCyW+FxTsGp/rGRiaTBH5XUSbTgkZd2
         zfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=piBYC+xTNu6MxV9+NOSh3zpO0sO8KESWgSUsgu3eNtU=;
        b=HHmGbr60sA4p6VPQo+VqedQkG4Ld/N3WIn2rlObJqZcV3mKww+Oe//7ookayzjJphX
         xF+B0WBRrEqTQVv8mu0rw26dt4qXhBnJSWEF0kfruRmWychk5PNrckj4nYxleF6zt1FL
         KDbP7N9laHy2bZHXyM03GnihfFl4oZAsAVAIrMXNtUMB4dqm9x7UbhifszL6ZD2A67Yv
         1uQzMUgbSVXqZbfKth67R9tW+6j7q4hHFiHNKz4jw7OyC5/bnB7CDr/d6idsKDmSlMZe
         nfmNA36hlND6fnJtRVDh87762Fz8ii5a+9ES+Iq2Y1LKOWuBv1MBr68bUU9Rjz+Q9Fgv
         lcqg==
X-Gm-Message-State: APjAAAXp0CJcsf/xwAtUGxsVIWe6YOLlk/jvskI73pAKDPx1Q2H+L3KU
        hgOG5Fho/FacYl7AcYJulos9SCBu
X-Google-Smtp-Source: APXvYqwATMXjt4xjrVHmjdh5oUqXwqirXyoR45x5pThzmAmfM6KlYsEg9eEgnn7dOxIg8AmoquAlQQ==
X-Received: by 2002:a63:a06c:: with SMTP id u44mr16554713pgn.10.1570532971995;
        Tue, 08 Oct 2019 04:09:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s202sm21557187pfs.24.2019.10.08.04.09.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:09:31 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, omosnace@redhat.com
Subject: [PATCH net] sctp: add chunks to sk_backlog when the newsk sk_socket is not set
Date:   Tue,  8 Oct 2019 19:09:23 +0800
Message-Id: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:

  [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
  [...] Call Trace:
  [...]  selinux_sctp_bind_connect+0x16a/0x1d0
  [...]  security_sctp_bind_connect+0x58/0x90
  [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
  [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
  [...]  sctp_do_sm+0x175/0x5a0 [sctp]
  [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
  [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
  [...]  __release_sock+0x11e/0x310
  [...]  release_sock+0x4f/0x180
  [...]  sctp_accept+0x3f9/0x5a0 [sctp]
  [...]  inet_accept+0xe7/0x720

It was caused by that the 'newsk' sk_socket was not set before going to
security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
or SCTP_PARAM_SET_PRIMARY:

  inet_accept()->
    sctp_accept():
      lock_sock():
          lock listening 'sk'
                                          do_softirq():
                                            sctp_rcv():  <-- [1]
                                                asconf chunk arrives and
                                                enqueued in 'sk' backlog
      sctp_sock_migrate():
          set asoc's sk to 'newsk'
      release_sock():
          sctp_backlog_rcv():
            lock 'newsk'
            sctp_process_asconf()  <-- [2]
            unlock 'newsk'
    sock_graft():
        set sk_socket  <-- [3]

As it shows, at [1] the asconf chunk would be put into the listening 'sk'
backlog, as accept() was holding its sock lock. Then at [2] asconf would
get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
would deref it, then kernel crashed.

Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
set when .accept() is done.

Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
flag is also needed to check in sctp_newsk_ready().

Thanks to Ondrej for reviewing the code.

Fixes: d452930fd3b9 ("selinux: Add SCTP support")
Reported-by: Ying Xu <yinxu@redhat.com>
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h |  5 +++++
 net/sctp/input.c        | 12 +++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 5d60f13..3ab5c6b 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -610,4 +610,9 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
 }
 
+static inline bool sctp_newsk_ready(const struct sock *sk)
+{
+	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 5a070fb..f277137 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -243,7 +243,7 @@ int sctp_rcv(struct sk_buff *skb)
 		bh_lock_sock(sk);
 	}
 
-	if (sock_owned_by_user(sk)) {
+	if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 		if (sctp_add_backlog(sk, skb)) {
 			bh_unlock_sock(sk);
 			sctp_chunk_free(chunk);
@@ -321,7 +321,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		local_bh_disable();
 		bh_lock_sock(sk);
 
-		if (sock_owned_by_user(sk)) {
+		if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
 				sctp_chunk_free(chunk);
 			else
@@ -336,7 +336,13 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		if (backloged)
 			return 0;
 	} else {
-		sctp_inq_push(inqueue, chunk);
+		if (!sctp_newsk_ready(sk)) {
+			if (!sk_add_backlog(sk, skb, sk->sk_rcvbuf))
+				return 0;
+			sctp_chunk_free(chunk);
+		} else {
+			sctp_inq_push(inqueue, chunk);
+		}
 	}
 
 done:
-- 
2.1.0

