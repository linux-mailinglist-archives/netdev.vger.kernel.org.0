Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BFCEF13A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfKDXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:37:20 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37175 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKDXhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 18:37:20 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so13605518lfp.4
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 15:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dDKnEK6D3MYm3xL73zW7rQdCF5qjKsfHm3AZtTTw4bg=;
        b=u/t0bbe/skdemY0GbflsG9l4rwp0A9xX0DZ0L6E9EQF3yXXj1mG0NNKTvMUPAjxQZp
         41NhrbtMMI9OXKIf3XyvapX9DrG142mP8lsw9ikxk9PhscZN6Qsr4ZEUHVTAz607rbAt
         JMBWk9JJgW46XKbTXYdWYIb3m4QyEsTNbjv7tBljpzwH/Vno2sdbL9lqGOE3mDaeUu6M
         eHn3O22JRtkmF+eCAqX/KmZmGJyeVvmRVWooj4i8gIcYTRITG9kv2f3fx3QBfGdb7sMq
         LlxpSri94AIsvT4TPIsuODcQLVLsv6p8SpdJd2aodaYSTAnSyNz815v65R/f6McZCjhf
         v5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dDKnEK6D3MYm3xL73zW7rQdCF5qjKsfHm3AZtTTw4bg=;
        b=FaonstL4XM8OpYowC4iYob5RLl6wZdZqPqW87yW+RAM5Vole60dXKlZz9Ev9cl7i8H
         fKwzXqd2nUhd7+7hNQBsPh/F1qa/bB0LrB6bHcpeH4T7X2ET0DWHURqKt7JwE0d4Oz1U
         SlEWJR34uP5WrzGb2wkWJYFgloWidwUoI/fwwFz6484ZWnU+DZHNNaolXVOSKdY0DqVo
         VWHWenQGrfjbv4nn36AzbYidY66CMXem8zJrcGpDdZyy4cHB2qHeCS3zwqVbbg0CN/Ls
         5I4JCKqRYJbu40/dMBq66agZR+QySjZoPmr+2EnOxAhQ608DlzxPRZJAsx9xyhmoxUVo
         xW3A==
X-Gm-Message-State: APjAAAW2wUv6Q1EwCczbAusXRkiiuqMlRm7Ga3OcGbWIm4pxSq2o6Ggx
        DQGqc138Ots+N+/CbfF3rJztMg==
X-Google-Smtp-Source: APXvYqxoTsiFWokDpZx+PktmMgqEh1BxGNLbbvr5aCEHz+pND5MXSkjVdKZTVL0t9neTPfhSqsvtOA==
X-Received: by 2002:a19:c354:: with SMTP id t81mr4477022lff.179.1572910637599;
        Mon, 04 Nov 2019 15:37:17 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g26sm7483132lfh.1.2019.11.04.15.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 15:37:16 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH net v2] net/tls: fix sk_msg trim on fallback to copy mode
Date:   Mon,  4 Nov 2019 15:36:57 -0800
Message-Id: <20191104233657.21054-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_msg_trim() tries to only update curr pointer if it falls into
the trimmed region. The logic, however, does not take into the
account pointer wrapping that sk_msg_iter_var_prev() does nor
(as John points out) the fact that msg->sg is a ring buffer.

This means that when the message was trimmed completely, the new
curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
neither smaller than any other value, nor would it actually be
correct.

Special case the trimming to 0 length a little bit and rework
the comparison between curr and end to take into account wrapping.

This bug caused the TLS code to not copy all of the message, if
zero copy filled in fewer sg entries than memcopy would need.

Big thanks to Alexander Potapenko for the non-KMSAN reproducer.

v2:
 - take into account that msg->sg is a ring buffer (John).

Link: https://lore.kernel.org/netdev/20191030160542.30295-1-jakub.kicinski@netronome.com/ (v1)

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
Co-developed-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
CC: Eric Biggers <ebiggers@kernel.org>
CC: herbert@gondor.apana.org.au
CC: glider@google.com
CC: linux-crypto@vger.kernel.org
---
 include/linux/skmsg.h |  9 ++++++---
 net/core/skmsg.c      | 20 +++++++++++++++-----
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e4b3fb4bb77c..ce7055259877 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
 	}
 }
 
+static inline u32 sk_msg_iter_dist(u32 start, u32 end)
+{
+	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+}
+
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
@@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
 	if (sk_msg_full(msg))
 		return MAX_MSG_FRAGS;
 
-	return msg->sg.end >= msg->sg.start ?
-		msg->sg.end - msg->sg.start :
-		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
 static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..ad31e4e53d0a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
 
 	msg->sg.data[i].length -= trim;
 	sk_mem_uncharge(sk, trim);
+	/* Adjust copybreak if it falls into the trimmed part of last buf */
+	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
+		msg->sg.copybreak = msg->sg.data[i].length;
 out:
-	/* If we trim data before curr pointer update copybreak and current
-	 * so that any future copy operations start at new copy location.
+	sk_msg_iter_var_next(i);
+	msg->sg.end = i;
+
+	/* If we trim data a full sg elem before curr pointer update
+	 * copybreak and current so that any future copy operations
+	 * start at new copy location.
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = msg->sg.start;
+		msg->sg.copybreak = 0;
+	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >=
+		   sk_msg_iter_dist(msg->sg.start, msg->sg.end)) {
+		sk_msg_iter_var_prev(i);
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-	sk_msg_iter_var_next(i);
-	msg->sg.end = i;
 }
 EXPORT_SYMBOL_GPL(sk_msg_trim);
 
-- 
2.23.0

