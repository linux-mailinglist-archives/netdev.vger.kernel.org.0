Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1D645CBD
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLGOhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLGOhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:37:06 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE0A48418
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:37:05 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id y15so16259735qtv.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa7p8qKalAmkiMSm1NVNiA0beSxZmi0VZZHRztUBhcU=;
        b=KCL4s/kkRTWMFn7kw2Sr3kB8au3xPo89mzQaCVc8mHf+nMsRkthBaVY1DxUr0jrJMw
         Ok6O8wQ2AhAgwaQj4tLUz7FKqoDoChunIEYYacj/tPEL1TFB/oztWy83pYZmOuMd5CCE
         tWULM/KbYi0QBepMVMOJ5ucvxvvTceCvSMC/L2iHn1oQQi/GmBPv2aBDIFzITbiVgaSt
         zJu/Hd6ED2DFmoweJofkvAnttkDjtpLFJWM5vddzkMYfPdxfGDtFXvtP69qTAge8daeX
         kxlyd1vr1Bj6JQvPKJdbhoM4OmQfnFB2tf8dq85Hs6gjMB6mqIXCGaWaatlaQCvUpFkH
         0WOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sa7p8qKalAmkiMSm1NVNiA0beSxZmi0VZZHRztUBhcU=;
        b=OuOkNbGGYKJyF2biQek48m9PwX4C/ozhXJgPqmIDgu3mT2z9K1huIiycyEtNVxvcdQ
         Yp51nTZAfXU18G9plQqlHvGLpLSnoen1PUMBG6ygkxlgjY9umpWwAMmJBZIaTTkQLvzK
         yvfEdgo3iEWwi1G5P0IMAXdiHE7fTO+MtPV/2fnUluQpjs0J60zg27CCft4DhIXyc4iX
         6k9nmpQwEaRAQKeSShqhXc8o2+2ZM7c7otafoxpxxNztT2RunTebENLHnGFAn4zthX+y
         DjP6J4MpMuhYBfeq8uxBx/UBat8zpzSpQiw+TVYm+Ty805g+O7h5lsfBCw82MJKdR2oQ
         uD1g==
X-Gm-Message-State: ANoB5pmCCJSBrSU/jQhiATaCeOub99CuJYOc4q5BqYDgvJWZy32QRL6l
        tYtrPr5M++0LUrbDs7I6SPP4hla4NpU=
X-Google-Smtp-Source: AA0mqf6mZ74IrMxlxM3zrF67TE2OrdUMlJcZlfJI80J5+M16Fa/EqnCLGQSXkdvq2bTebfSODd4RPA==
X-Received: by 2002:ac8:4650:0:b0:39c:dcc6:bab7 with SMTP id f16-20020ac84650000000b0039cdcc6bab7mr85075065qto.491.1670423824781;
        Wed, 07 Dec 2022 06:37:04 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id fc10-20020a05622a488a00b003a70a675066sm7623343qtb.79.2022.12.07.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:37:04 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com, sotodel@meta.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
Date:   Wed,  7 Dec 2022 09:37:01 -0500
Message-Id: <20221207143701.29861-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
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

From: Willem de Bruijn <willemb@google.com>

Add an option to initialize SOF_TIMESTAMPING_OPT_ID for TCP from
write_seq sockets instead of snd_una.

This should have been the behavior from the start. Because processes
may now exist that rely on the established behavior, do not change
behavior of the existing option, but add the right behavior with a new
flag. It is encouraged to always set SOF_TIMESTAMPING_OPT_ID_TCP on
stream sockets along with the existing SOF_TIMESTAMPING_OPT_ID.

Intuitively the contract is that the counter is zero after the
setsockopt, so that the next write N results in a notification for
the last byte N - 1.

On idle sockets snd_una == write_seq and this holds for both. But on
sockets with data in transmission, snd_una records the unacked offset
in the stream. This depends on the ACK response from the peer. A
process cannot learn this in a race free manner (ioctl SIOCOUTQ is one
racy approach).

write_seq records the offset at the last byte written by the process.
This is a better starting point. It matches the intuitive contract in
all circumstances, unaffected by external behavior.

The new timestamp flag necessitates increasing sk_tsflags to 32 bits.
Move the field in struct sock to avoid growing the socket (for some
common CONFIG variants). The UAPI interface so_timestamping.flags is
already int, so 32 bits wide.

Reported-by: Sotirios Delimanolis <sotodel@meta.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Changes v1->v2 (no code changes)
  - Refine documentation and commit message
  - Change reporter
  - Fix small typo
---
 Documentation/networking/timestamping.rst | 32 ++++++++++++++++++++++-
 include/net/sock.h                        |  6 ++---
 include/uapi/linux/net_tstamp.h           |  3 ++-
 net/core/sock.c                           |  9 ++++++-
 net/ethtool/common.c                      |  1 +
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index be4eb1242057..f17c01834a12 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -179,7 +179,8 @@ SOF_TIMESTAMPING_OPT_ID:
   identifier and returns that along with the timestamp. The identifier
   is derived from a per-socket u32 counter (that wraps). For datagram
   sockets, the counter increments with each sent packet. For stream
-  sockets, it increments with every byte.
+  sockets, it increments with every byte. For stream sockets, also set
+  SOF_TIMESTAMPING_OPT_ID_TCP, see the section below.
 
   The counter starts at zero. It is initialized the first time that
   the socket option is enabled. It is reset each time the option is
@@ -192,6 +193,35 @@ SOF_TIMESTAMPING_OPT_ID:
   among all possibly concurrently outstanding timestamp requests for
   that socket.
 
+SOF_TIMESTAMPING_OPT_ID_TCP:
+  Pass this modifier along with SOF_TIMESTAMPING_OPT_ID for new TCP
+  timestamping applications. SOF_TIMESTAMPING_OPT_ID defines how the
+  counter increments for stream sockets, but its starting point is
+  not entirely trivial. This option fixes that.
+
+  For stream sockets, if SOF_TIMESTAMPING_OPT_ID is set, this should
+  always be set too. On datagram sockets the option has no effect.
+
+  A reasonable expectation is that the counter is reset to zero with
+  the system call, so that a subsequent write() of N bytes generates
+  a timestamp with counter N-1. SOF_TIMESTAMPING_OPT_ID_TCP
+  implements this behavior under all conditions.
+
+  SOF_TIMESTAMPING_OPT_ID without modifier often reports the same,
+  especially when the socket option is set when no data is in
+  transmission. If data is being transmitted, it may be off by the
+  length of the output queue (SIOCOUTQ).
+
+  The difference is due to being based on snd_una versus write_seq.
+  snd_una is the offset in the stream acknowledged by the peer. This
+  depends on factors outside of process control, such as network RTT.
+  write_seq is the last byte written by the process. This offset is
+  not affected by external inputs.
+
+  The difference is subtle and unlikely to be noticed when configured
+  at initial socket creation, when no data is queued or sent. But
+  SOF_TIMESTAMPING_OPT_ID_TCP behavior is more robust regardless of
+  when the socket option is set.
 
 SOF_TIMESTAMPING_OPT_CMSG:
   Support recv() cmsg for all timestamped packets. Control messages
diff --git a/include/net/sock.h b/include/net/sock.h
index 6d207e7c4ad0..ecea3dcc2217 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -503,10 +503,10 @@ struct sock {
 #if BITS_PER_LONG==32
 	seqlock_t		sk_stamp_seq;
 #endif
-	u16			sk_tsflags;
-	u8			sk_shutdown;
 	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
+	u32			sk_tsflags;
+	u8			sk_shutdown;
 
 	u8			sk_clockid;
 	u8			sk_txtime_deadline_mode : 1,
@@ -1899,7 +1899,7 @@ static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
-	u16 tsflags;
+	u32 tsflags;
 };
 
 static inline void sockcm_init(struct sockcm_cookie *sockc,
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 55501e5e7ac8..a2c66b3d7f0f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -31,8 +31,9 @@ enum {
 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
 	SOF_TIMESTAMPING_BIND_PHC = (1 << 15),
+	SOF_TIMESTAMPING_OPT_ID_TCP = (1 << 16),
 
-	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
+	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_OPT_ID_TCP,
 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
 				 SOF_TIMESTAMPING_LAST
 };
diff --git a/net/core/sock.c b/net/core/sock.c
index 4571914a4aa8..b0ab841e0aed 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -901,13 +901,20 @@ int sock_set_timestamping(struct sock *sk, int optname,
 	if (val & ~SOF_TIMESTAMPING_MASK)
 		return -EINVAL;
 
+	if (val & SOF_TIMESTAMPING_OPT_ID_TCP &&
+	    !(val & SOF_TIMESTAMPING_OPT_ID))
+		return -EINVAL;
+
 	if (val & SOF_TIMESTAMPING_OPT_ID &&
 	    !(sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)) {
 		if (sk_is_tcp(sk)) {
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
+			if (val & SOF_TIMESTAMPING_OPT_ID_TCP)
+				atomic_set(&sk->sk_tskey, tcp_sk(sk)->write_seq);
+			else
+				atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
 			atomic_set(&sk->sk_tskey, 0);
 		}
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 21cfe8557205..6f399afc2ff2 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -417,6 +417,7 @@ const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
 	[const_ilog2(SOF_TIMESTAMPING_OPT_PKTINFO)]  = "option-pktinfo",
 	[const_ilog2(SOF_TIMESTAMPING_OPT_TX_SWHW)]  = "option-tx-swhw",
 	[const_ilog2(SOF_TIMESTAMPING_BIND_PHC)]     = "bind-phc",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_ID_TCP)]   = "option-id-tcp",
 };
 static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

