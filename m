Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5B15FAA4
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBNXbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:31:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36622 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBNXbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:31:05 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so4286255plm.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OxCog8fVyySuAIJvK8qvH0KIiRzKGIwKHGb/B7M5EJE=;
        b=gbdzcSLsc+ZfzSJEUsZZs8j+fNOHC33/X3w+1xZik9APjAYHXDP+kIjDCIwF7Kx2hZ
         q+GaZke1cMhDZ3uY9qf3K5nDq2jOJIgpdkQFHw7sDirU2L/mTzCsIuWbUMcMO0UGvTuL
         a0xJpuNPb+zOsbuePPUj0DvkPiA42SOl7dcMpg+Q+BAFNiCoDMn5CPUvzT7O/EZvbHUP
         IqLRKPexpZSSlCBk1OCGgBV/4PXzla+dSsan9C++rcnuLXzZM18vPkmhAEsWzqdQ+JGF
         HFBd/BqjUqiBUuPaN4NjYZHXt3ntBT1+vSilLYf2+ro8qhfVETTB6knKGKeB/8SPOn3H
         qq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OxCog8fVyySuAIJvK8qvH0KIiRzKGIwKHGb/B7M5EJE=;
        b=qb58fNQ4MbkfN+B3rSsanDAuZTvJHXR8knCEYKnqXLXu/KiJp5XzpsMLVqS5lIvjCp
         ZBYdcndbTVpRhGb6JT+ormQwKKrr3z6xTJUjIGTABU3oa0LzCiBMGdvplS4S9eghq2na
         tYogTa7RJQvpw/yZ4D/Ht9Ourd3gGTT+Id7UpHsiTZ//dVVMYjSNwU1HZV2pflfj13yP
         tpwx/Wc7uclON9M4Ut8TnvgK9N3KFduA2GpDVKTAk/+GC3QoPUkvL/hEbT/CnJiXxZoi
         hrh1Y2Be5F8ZIeYoufw3FIF5+aM6y3B2UwU0DtO2bGz5mKia9aTsKBiwcTGRlBuXznrZ
         4d+A==
X-Gm-Message-State: APjAAAV8/S5Lp13R2Y7+5TJ5rBkxwf8BZ7jqqDZYxYsoOyCwxjglQWCx
        dfUWYYAyMfL5A2kA2K0OP6U=
X-Google-Smtp-Source: APXvYqw+34JbsDacim74z1Nyw9jB3yx/xzBEfwG6ccE8ORCaWwtCt88OOzMPvYT1A/QCnXIHQPS7Mg==
X-Received: by 2002:a17:90a:608:: with SMTP id j8mr6425796pjj.85.1581723064682;
        Fri, 14 Feb 2020 15:31:04 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id p23sm8687868pgn.92.2020.02.14.15.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:31:04 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com
Subject: [PATCH net-next 1/2] tcp-zerocopy: Return inq along with tcp receive zerocopy.
Date:   Fri, 14 Feb 2020 15:30:49 -0800
Message-Id: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
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

For applications using edge-triggered epoll, returning inq along with
the result of tcp receive zerocopy could remove the need to call
recvmsg()=-EAGAIN after a successful zerocopy. Generally speaking,
since normally we would need to perform a recvmsg() call for every
successful small RPC read via TCP receive zerocopy, returning inq can
reduce the number of system calls performed by approximately half.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 include/uapi/linux/tcp.h |  1 +
 net/ipv4/tcp.c           | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 74af1f759cee..19700101cbba 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -343,5 +343,6 @@ struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
 	__u32 length;		/* in/out: number of bytes to map/mapped */
 	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
+	__u32 inq; /* out: amount of bytes in read queue */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f09fbc85b108..947be81b35c5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3658,13 +3658,26 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 
 		if (get_user(len, optlen))
 			return -EFAULT;
-		if (len != sizeof(zc))
+		if (len < offsetofend(struct tcp_zerocopy_receive, length))
 			return -EINVAL;
+		if (len > sizeof(zc))
+			len = sizeof(zc);
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
 		release_sock(sk);
+		switch (len) {
+		case sizeof(zc):
+		case offsetofend(struct tcp_zerocopy_receive, inq):
+			goto zerocopy_rcv_inq;
+		case offsetofend(struct tcp_zerocopy_receive, length):
+		default:
+			goto zerocopy_rcv_out;
+		}
+zerocopy_rcv_inq:
+		zc.inq = tcp_inq_hint(sk);
+zerocopy_rcv_out:
 		if (!err && copy_to_user(optval, &zc, len))
 			err = -EFAULT;
 		return err;
-- 
2.25.0.265.gbab2e86ba0-goog

