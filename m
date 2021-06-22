Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AE73B0C7A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhFVSLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhFVSK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:56 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D9CC0611C2;
        Tue, 22 Jun 2021 11:05:03 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id x21so87950qtq.9;
        Tue, 22 Jun 2021 11:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lOaIRsk7HP5oq5mdzuR9Qy1EOzmEMsYGwEFloyPsJkw=;
        b=jGlPGve0y12rm7zM51XapUr/ACQW11lNKvUMjhbnvsGPKXA9D7dpuZcWcbSywzkocA
         RMHQmS2b+f27iLX+oHmR3CbIST3roZEssAQMLjQ3qG28hvd0D6d6hwONxg8KxTCjtGOM
         zpILRFJdz2PthgbyJZcQJFppM6VJWw5PaB2HynT6uLVbesS3DcV60+ri0hBLzh+C5oam
         EGh2nKrcrakqGu3yq6TLQCF+NkoyzHTRANm5fvMpsUKz3vhL6z2set9PVlBwLngvonM8
         gwT9nZwVwRdQyPy9IoM7BzQQRnWcmIW16OqMGe8V93j0IwBTRu22jLQf+br4+iGvavHD
         elKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOaIRsk7HP5oq5mdzuR9Qy1EOzmEMsYGwEFloyPsJkw=;
        b=ptiAg0yx06RU6mjH2ZceOKm3fwjMGTeZu5vtS7i64C/Kufw1VxbHvvQWS03UaZOHkk
         br56TYURXyfwNrBTk1F7yIFRomKxsXKLT7NOq8aaVBOrgZSzjBfQw+41c9PUnsALOjT9
         9JaYdJWUTdEwt7SyPGks7Da9vdIGJoo0w4qRYwNkdbT2zFvLFCb1OiClumlxgEfP7d9X
         gTRu/MvLdB4Q+VlTfVTZhqAmeRT+teBLlkD25i4GtU3H+Ad6jUKhKiWY+7dIeK2/hTO4
         hEam6AVeC7OfKZefdx1yYLEelIO/eqI5Q4QcE5z6V2CAXeN98zew48Qzi8VUKvPS8jrK
         1BTw==
X-Gm-Message-State: AOAM5326J1imWga1uJaPtavnVuYmOIv+tb1xlN7idnpG1vquze0vuMMc
        9xfbI9FH3Lmw63suIauUDvdrU8TIik0=
X-Google-Smtp-Source: ABdhPJwaYv450Erf1uUJ3goehHVoPaofqrg59D8poyoqfJhJAl/dIQve1JixmZGZQ2EVzqYwM7o3iA==
X-Received: by 2002:ac8:444f:: with SMTP id m15mr34938qtn.340.1624385102360;
        Tue, 22 Jun 2021 11:05:02 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c80sm9349399qkg.120.2021.06.22.11.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 01/14] sctp: add pad chunk and its make function and event table
Date:   Tue, 22 Jun 2021 14:04:47 -0400
Message-Id: <242246f380811284c371014fbde90b85cfea67de.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

