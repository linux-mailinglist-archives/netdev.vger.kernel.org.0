Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14FE3AE15E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFUBlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFUBlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:07 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00027C061756;
        Sun, 20 Jun 2021 18:38:52 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c138so26455752qkg.5;
        Sun, 20 Jun 2021 18:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VU24E5KjYlasydQy3fMihKFVsLrifSKSnS6laFXZucU=;
        b=QH80r2NjgI5T9A8P++N2ZNu2FkbGofA/14MDvfg2vDCym5Nh/tYJe/k2w+u8zLJm+A
         E2gIC0Ji0rke53y2s0veB3qcVFnACiCCG3ybfDkTyJ7yS2fQlB0CRty3wEXwG9iOXZWe
         Ueik348tysiNAN2AAR/b8QR8B+9OVFB4o3kT23a9sotV2ojMHOF/ok7nDrIqtTrFzlUc
         ulReDXadof6kx92kXgiFYXG2QjpavFLIJlTW8alC6Lfx5pBOfJg94yNAyWGIliDJzlt3
         FZv4d2wYKY3zUW8jElXrWnyuBdj44SU48ufttnU/b+q1PHYVEx59aX0gblzJACc9u0Yw
         qMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VU24E5KjYlasydQy3fMihKFVsLrifSKSnS6laFXZucU=;
        b=etEkcZxZYCUc8/Bg0gqv2tM0jxs1xVTKKVQHkriddcJk2mDJEfcDQZb7ZY/OQ7T+VW
         poDijvpyeoNTT3URNZ2xEnq9QVgwwRxKhHx+33/6+7F0eBuQCL/a6kjv8M85rG5Am30R
         AIjc9e1wf9nPPmL/GZZcyyrMpP+CbvKc8X3eM4F8Ghu1stVBm73+8YSioGF3bHdZl6Wr
         iRA+LuvT5DSsJa8MvnLkU/Yvu1kcXSyiCknaDZVENnA5s92kz7EOv/Z/NlU+jz3P7KOF
         Pa/apGjEu2NpCmAODfe3dmLlP6ygB0KJqYLRmoWgZw1jnvjYZ0TRDDS64z8IzxD4hf5+
         K1FA==
X-Gm-Message-State: AOAM533ahcUmfT7iMw6OfGJZDlWLNRtgz4gnRlYxGUdis+zqftNjf7WM
        YN5044Tex3menPtimiD+cUu5z1LudV2mQw==
X-Google-Smtp-Source: ABdhPJzGHvjihrdSNtjoOn7Qj6UYrj+1A3ow9UiSYB/7MJMVXxs9S/oINU42TAmNkvUpdd8K27OxAg==
X-Received: by 2002:a37:a89:: with SMTP id 131mr21154403qkk.473.1624239531994;
        Sun, 20 Jun 2021 18:38:51 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v12sm9864085qtp.41.2021.06.20.18.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 01/14] sctp: add pad chunk and its make function and event table
Date:   Sun, 20 Jun 2021 21:38:36 -0400
Message-Id: <638d10375213f579c13b0220b7a4a75a7a54f9ef.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chunk is defined in rfc4820#section-3, and used to pad an
SCTP packet. The receiver must discard this chunk and continue
processing the rest of the chunks in the packet.

Add it now, as it will be bundled with a heartbeat chunk to probe
pmtu in the following patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     |  7 +++++++
 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c | 26 ++++++++++++++++++++++++++
 net/sctp/sm_statetable.c | 23 +++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index bb1926589693..a86e852507b3 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -98,6 +98,7 @@ enum sctp_cid {
 	SCTP_CID_I_FWD_TSN		= 0xC2,
 	SCTP_CID_ASCONF_ACK		= 0x80,
 	SCTP_CID_RECONF			= 0x82,
+	SCTP_CID_PAD			= 0x84,
 }; /* enum */
 
 
@@ -410,6 +411,12 @@ struct sctp_heartbeat_chunk {
 };
 
 
+/* PAD chunk could be bundled with heartbeat chunk to probe pmtu */
+struct sctp_pad_chunk {
+	struct sctp_chunkhdr uh;
+};
+
+
 /* For the abort and shutdown ACK we must carry the init tag in the
  * common header. Just the common header is all that is needed with a
  * chunk descriptor.
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index fd223c94589a..09c59154634d 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -230,6 +230,7 @@ struct sctp_chunk *sctp_make_heartbeat_ack(const struct sctp_association *asoc,
 					   const struct sctp_chunk *chunk,
 					   const void *payload,
 					   const size_t paylen);
+struct sctp_chunk *sctp_make_pad(const struct sctp_association *asoc, int len);
 struct sctp_chunk *sctp_make_op_error(const struct sctp_association *asoc,
 				      const struct sctp_chunk *chunk,
 				      __be16 cause_code, const void *payload,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5b44d228b6ca..e5d470cd7c40 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1218,6 +1218,32 @@ struct sctp_chunk *sctp_make_heartbeat_ack(const struct sctp_association *asoc,
 	return retval;
 }
 
+/* RFC4820 3. Padding Chunk (PAD)
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * | Type = 0x84   |   Flags=0     |             Length            |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                                                               |
+ * \                         Padding Data                          /
+ * /                                                               \
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+struct sctp_chunk *sctp_make_pad(const struct sctp_association *asoc, int len)
+{
+	struct sctp_chunk *retval;
+
+	retval = sctp_make_control(asoc, SCTP_CID_PAD, 0, len, GFP_ATOMIC);
+	if (!retval)
+		return NULL;
+
+	skb_put_zero(retval->skb, len);
+	retval->chunk_hdr->length = htons(ntohs(retval->chunk_hdr->length) + len);
+	retval->chunk_end = skb_tail_pointer(retval->skb);
+
+	return retval;
+}
+
 /* Create an Operation Error chunk with the specified space reserved.
  * This routine can be used for containing multiple causes in the chunk.
  */
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 88ea87f4f0e7..c82c4233ec6b 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -526,6 +526,26 @@ auth_chunk_event_table[SCTP_NUM_AUTH_CHUNK_TYPES][SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_AUTH,
 }; /*state_fn_t auth_chunk_event_table[][] */
 
+static const struct sctp_sm_table_entry
+pad_chunk_event_table[SCTP_STATE_NUM_STATES] = {
+	/* SCTP_STATE_CLOSED */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_COOKIE_WAIT */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_COOKIE_ECHOED */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_ESTABLISHED */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_SHUTDOWN_PENDING */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_SHUTDOWN_SENT */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_SHUTDOWN_RECEIVED */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+	/* SCTP_STATE_SHUTDOWN_ACK_SENT */
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk),
+};	/* chunk pad */
+
 static const struct sctp_sm_table_entry
 chunk_event_table_unknown[SCTP_STATE_NUM_STATES] = {
 	/* SCTP_STATE_CLOSED */
@@ -992,6 +1012,9 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
 
 	case SCTP_CID_AUTH:
 		return &auth_chunk_event_table[0][state];
+
+	case SCTP_CID_PAD:
+		return &pad_chunk_event_table[state];
 	}
 
 	return &chunk_event_table_unknown[state];
-- 
2.27.0

