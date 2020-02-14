Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A1515FAA5
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBNXbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:31:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37567 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBNXbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:31:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id z12so5704101pgl.4
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZLQknL7E6b2EIxvwkbFcnl+or+NRLvY1ZsTZInqkc4=;
        b=L+fZiOSNpJOe9E08xOItmkxceFRZT7txu/O9BqYAiOgqWyq5cWqN3TmwgjeYd6rb57
         atebjA6jjWH4LLBZxLtpialBiJIpxQI5Sjh3NL+WfPY+75bJ6S4nhzLRqtoNxXvwkghO
         ygmMHsIWI2Ur6p3QYs5qe6qc5qKXL8h2LGKD7b5hGLYDlz4aPDwh5+L1wofO+WgnAN6b
         f2fUB+5G794uuAWzxHF9aMfeA8ZRQvAwQCmax3SIjcm5wTZn2I3VpRN4smUovXPYtLA+
         bWuf0VJPw8NXsUf4MuT31UXH0MwbJiZ8LUIkDrH9opcxD6AG3NtEfc3Iasw8x5WqTWj2
         FiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZLQknL7E6b2EIxvwkbFcnl+or+NRLvY1ZsTZInqkc4=;
        b=QoHk6L6pNblQhtXZ9Pl0NTb3lrg8AaI1OvUBqMgR0Ve92FQTzDOWuuxoLgAYvPGjcx
         uPIXGZS8Kws75K/dgfPHWsQl5Cz/gizy5PFE6PY6qIk/Z3re/2MaB5UjocoWwacPyZIv
         Z5vK1QpzSh3gwLw7uhttyFH5pPD1PPdTcl07viZGJDS7brtVO+mOAYi8E34zZO7ezCnE
         m4WUPI/7FV5fvLI5Uk3HthbnhgucTZKN0u2FXhtAftGn+15n+OZOgGyonIZVvMGKQxkG
         3XnD693uH9gZ0TgRmD1w2jjt2wF5zXufImxAoHzj0ax0q2XBKZlpFiCCIj3SxO0ybdFp
         6JEA==
X-Gm-Message-State: APjAAAUBjUVOkae6KECqsXz1N4bNIp4jZdCc686bc+gr6/+jqRMrPXl0
        w/YR2rS0MAJI2WoqzweOoCr1OpO5
X-Google-Smtp-Source: APXvYqxNGFBMuRG7J3rifllQR7AFDcKTdUk9L/KlMz+DkWoj81VBqOCR8ajErp9ZNYldlhaU4dQ1qA==
X-Received: by 2002:a63:fe14:: with SMTP id p20mr5639327pgh.94.1581723068950;
        Fri, 14 Feb 2020 15:31:08 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id p23sm8687868pgn.92.2020.02.14.15.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:31:08 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com
Subject: [PATCH net-next 2/2] tcp-zerocopy: Return sk_err (if set) along with tcp receive zerocopy.
Date:   Fri, 14 Feb 2020 15:30:50 -0800
Message-Id: <20200214233050.19429-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
References: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

This patchset is intended to reduce the number of extra system calls
imposed by TCP receive zerocopy. For ping-pong RPC style workloads,
this patchset has demonstrated a system call reduction of about 30%
when coupled with userspace changes.

For applications using epoll, returning sk_err along with the result
of tcp receive zerocopy could remove the need to call
recvmsg()=-EAGAIN after a spurious wakeup.

Consider a multi-threaded application using epoll. A thread may awaken
with EPOLLIN but another thread may already be reading. The
spuriously-awoken thread does not necessarily know that another thread
'won'; rather, it may be possible that it was woken up due to the
presence of an error if there is no data. A zerocopy read receiving 0
bytes thus would need to be followed up by recvmsg to be sure.

Instead, we return sk_err directly with zerocopy, so the application
can avoid this extra system call.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 include/uapi/linux/tcp.h | 1 +
 net/ipv4/tcp.c           | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 19700101cbba..e1706a7c9d88 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -344,5 +344,6 @@ struct tcp_zerocopy_receive {
 	__u32 length;		/* in/out: number of bytes to map/mapped */
 	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
 	__u32 inq; /* out: amount of bytes in read queue */
+	__s32 err; /* out: socket error */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 947be81b35c5..0efac228bbdb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3667,14 +3667,20 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
 		release_sock(sk);
+		if (len == sizeof(zc))
+			goto zerocopy_rcv_sk_err;
 		switch (len) {
-		case sizeof(zc):
+		case offsetofend(struct tcp_zerocopy_receive, err):
+			goto zerocopy_rcv_sk_err;
 		case offsetofend(struct tcp_zerocopy_receive, inq):
 			goto zerocopy_rcv_inq;
 		case offsetofend(struct tcp_zerocopy_receive, length):
 		default:
 			goto zerocopy_rcv_out;
 		}
+zerocopy_rcv_sk_err:
+		if (!err)
+			zc.err = sock_error(sk);
 zerocopy_rcv_inq:
 		zc.inq = tcp_inq_hint(sk);
 zerocopy_rcv_out:
-- 
2.25.0.265.gbab2e86ba0-goog

