Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4D10B750
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfK0USH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:07 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37394 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfK0USH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:07 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so18205311lfp.4
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YsujNiLxYXhT3OLvxgeSK2S/UhWyyf7fGTm6bLUA6qg=;
        b=t41J2DQt6c7/x1U0pRNFiv2oR7s1muVDfnwHMqHTu895YZy0puIzVz4j4EQ5tZcaFv
         jbBLQxfji7a1/Pg0sKq9D3XUBVdJEtlRENmekMOrN/LCqHrTMFaaDpI6cRaXbCDNhhs9
         GEjiu+vGngVPogoLCzf/bVclLMfiM2o3p2E96/hD/BXLS0G8mXVEXgx2hHxB2Bjqs++8
         Kg0HI/ga7MjdYYcZormC+gY4jnUhYQhxywCwT9H9i/0B3DCdScgdl/uVt5tBiDM9JCrk
         DJlrnEbdFt3z8o0hBwtYm7Pf7JCwkmPhxS6HtioM785wgcos/Q+/1tQImQT01SBLAI/c
         ibGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YsujNiLxYXhT3OLvxgeSK2S/UhWyyf7fGTm6bLUA6qg=;
        b=lIuxG+4QBK9tE3dEzw6umSiaPoZ7OY+IpU9LDkezi3Mp3ir+ENPHj2c+x6Cd16VPPQ
         v8Qf5jEjVqG0JqEGwtxJFR7ZshxiVZH2MLGZyGvGaOPXbQaM7JZxJO0l8T7vY2Tpi+ny
         SI/Lh/KVpXEJOQpMJLE14ESw3+8cPOpTOHxzSBTkWr0IxRaL4XMXdFSqUXewmNhWFvb1
         HqQx8pLNFDjLpiS1UpcHzueDlmRiTr/mA58b+YJGCLkO7xVYIFAlLlVVd8Eau6EsAXz9
         aDF97Xiyd2GM9fJpuj6xEJYFNW7XDrljIRlZjvCkXXMMG3iGiLfnDQKOKEuO/pTFt0ly
         2gQA==
X-Gm-Message-State: APjAAAUOLmamxVhKig3S1+dGf8EmpXnc9i8zupYNHISQ9mvf/s4MLfpn
        MtPTW6y+SpZq5xr5jdcDZ+nG5Q==
X-Google-Smtp-Source: APXvYqzZd7NPZn9A07KiSxHmO3sSbPXAnxlC32skjlKgXjHJs2cbQB3MfN3cOvEPEGiQHMGBpuwBBQ==
X-Received: by 2002:ac2:4244:: with SMTP id m4mr863251lfl.85.1574885883246;
        Wed, 27 Nov 2019 12:18:03 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:02 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 3/8] net: skmsg: fix TLS 1.3 crash with full sk_msg
Date:   Wed, 27 Nov 2019 12:16:41 -0800
Message-Id: <20191127201646.25455-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS 1.3 started using the entry at the end of the SG array
for chaining-in the single byte content type entry. This mostly
works:

[ E E E E E E . . ]
  ^           ^
   start       end

                 E < content type
               /
[ E E E E E E C . ]
  ^           ^
   start       end

(Where E denotes a populated SG entry; C denotes a chaining entry.)

If the array is full, however, the end will point to the start:

[ E E E E E E E E ]
  ^
   start
   end

And we end up overwriting the start:

    E < content type
   /
[ C E E E E E E E ]
  ^
   start
   end

The sg array is supposed to be a circular buffer with start and
end markers pointing anywhere. In case where start > end
(i.e. the circular buffer has "wrapped") there is an extra entry
reserved at the end to chain the two halves together.

[ E E E E E E . . l ]

(Where l is the reserved entry for "looping" back to front.

As suggested by John, let's reserve another entry for chaining
SG entries after the main circular buffer. Note that this entry
has to be pointed to by the end entry so its position is not fixed.

Examples of full messages:

[ E E E E E E E E . l ]
  ^               ^
   start           end

   <---------------.
[ E E . E E E E E E l ]
      ^ ^
   end   start

Now the end will always point to an unused entry, so TLS 1.3
can always use it.

Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/linux/skmsg.h | 28 ++++++++++++++--------------
 net/core/filter.c     |  8 ++++----
 net/core/skmsg.c      |  2 +-
 net/ipv4/tcp_bpf.c    |  2 +-
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6cb077b646a5..ef7031f8a304 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -14,6 +14,7 @@
 #include <net/strparser.h>
 
 #define MAX_MSG_FRAGS			MAX_SKB_FRAGS
+#define NR_MSG_FRAG_IDS			(MAX_MSG_FRAGS + 1)
 
 enum __sk_action {
 	__SK_DROP = 0,
@@ -29,13 +30,15 @@ struct sk_msg_sg {
 	u32				size;
 	u32				copybreak;
 	unsigned long			copy;
-	/* The extra element is used for chaining the front and sections when
-	 * the list becomes partitioned (e.g. end < start). The crypto APIs
-	 * require the chaining.
+	/* The extra two elements:
+	 * 1) used for chaining the front and sections when the list becomes
+	 *    partitioned (e.g. end < start). The crypto APIs require the
+	 *    chaining;
+	 * 2) to chain tailer SG entries after the message.
 	 */
-	struct scatterlist		data[MAX_MSG_FRAGS + 1];
+	struct scatterlist		data[MAX_MSG_FRAGS + 2];
 };
-static_assert(BITS_PER_LONG >= MAX_MSG_FRAGS);
+static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
 struct sk_msg {
@@ -142,13 +145,13 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
 
 static inline u32 sk_msg_iter_dist(u32 start, u32 end)
 {
-	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+	return end >= start ? end - start : end + (NR_MSG_FRAG_IDS - start);
 }
 
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
-			var = MAX_MSG_FRAGS - 1;	\
+			var = NR_MSG_FRAG_IDS - 1;	\
 		else					\
 			var--;				\
 	} while (0)
@@ -156,7 +159,7 @@ static inline u32 sk_msg_iter_dist(u32 start, u32 end)
 #define sk_msg_iter_var_next(var)			\
 	do {						\
 		var++;					\
-		if (var == MAX_MSG_FRAGS)		\
+		if (var == NR_MSG_FRAG_IDS)		\
 			var = 0;			\
 	} while (0)
 
@@ -173,9 +176,9 @@ static inline void sk_msg_clear_meta(struct sk_msg *msg)
 
 static inline void sk_msg_init(struct sk_msg *msg)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
+	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
 	memset(msg, 0, sizeof(*msg));
-	sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
+	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
 }
 
 static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
@@ -196,14 +199,11 @@ static inline void sk_msg_xfer_full(struct sk_msg *dst, struct sk_msg *src)
 
 static inline bool sk_msg_full(const struct sk_msg *msg)
 {
-	return (msg->sg.end == msg->sg.start) && msg->sg.size;
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end) == MAX_MSG_FRAGS;
 }
 
 static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
 {
-	if (sk_msg_full(msg))
-		return MAX_MSG_FRAGS;
-
 	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index b0ed048585ba..f1e703eed3d2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2299,7 +2299,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	WARN_ON_ONCE(last_sge == first_sge);
 	shift = last_sge > first_sge ?
 		last_sge - first_sge - 1 :
-		MAX_SKB_FRAGS - first_sge + last_sge - 1;
+		NR_MSG_FRAG_IDS - first_sge + last_sge - 1;
 	if (!shift)
 		goto out;
 
@@ -2308,8 +2308,8 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	do {
 		u32 move_from;
 
-		if (i + shift >= MAX_MSG_FRAGS)
-			move_from = i + shift - MAX_MSG_FRAGS;
+		if (i + shift >= NR_MSG_FRAG_IDS)
+			move_from = i + shift - NR_MSG_FRAG_IDS;
 		else
 			move_from = i + shift;
 		if (move_from == msg->sg.end)
@@ -2323,7 +2323,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	} while (1);
 
 	msg->sg.end = msg->sg.end - shift > msg->sg.end ?
-		      msg->sg.end - shift + MAX_MSG_FRAGS :
+		      msg->sg.end - shift + NR_MSG_FRAG_IDS :
 		      msg->sg.end - shift;
 out:
 	msg->data = sg_virt(&msg->sg.data[first_sge]) + start - offset;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index a469d2124f3f..ded2d5227678 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -421,7 +421,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
-	msg->sg.end = num_sge == MAX_MSG_FRAGS ? 0 : num_sge;
+	msg->sg.end = num_sge;
 	msg->skb = skb;
 
 	sk_psock_queue_msg(psock, msg);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8a56e09cfb0e..e38705165ac9 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -301,7 +301,7 @@ EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
-	bool cork = false, enospc = msg->sg.start == msg->sg.end;
+	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
 	int ret;
-- 
2.23.0

