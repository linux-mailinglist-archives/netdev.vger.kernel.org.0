Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501286E7E10
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbjDSPTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbjDSPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:17 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5025FE9;
        Wed, 19 Apr 2023 08:18:47 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id fg9so12446047qtb.1;
        Wed, 19 Apr 2023 08:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917397; x=1684509397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBOL+UsV1Rmf+Bmt1XKnavmQfuZMIoYDh5MH42mWVWs=;
        b=KjFbVhJE3IKOe1QR+uivEGZVljahqn4VshS1vRTvKdFy1KtbuZMhSulhMHD58EeZOR
         yQFf5QzfG6XhyLDkeGvcW9k7NymvxWMci06afnGE5jvWAdeAMyl7jnhxbVJiN6C+uupZ
         4DLP+P3XKTf4f7H2XX84CfOzN68GqeuN7zsQbuO57Twr3hIvjHeRarVL7OsOz1VGwUml
         AhMLQdMjYQd9GZNnpGZGLzaI1XIwcOky6EjFbMvt3wtWRcJMBjFo8ZYKR21fj4slTmOU
         5Qr2TLZ+ZfdOHHlMHnAWeWoERQXfXcta6PrvWGfc0z+zvLPCyBmZwd4WSRDMBww+wyZI
         jdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917397; x=1684509397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBOL+UsV1Rmf+Bmt1XKnavmQfuZMIoYDh5MH42mWVWs=;
        b=OGkhqzMdKhYuGXtEc9gO6qH9RFyUeDlUyGCDcPsPbwW9fThCF26DEtIjdkGki0EWtZ
         OlJBnCmeKCjjWUgjAG/2Ec8vTE07KeMhxruiiUZ+lvjhv85SqDbcUMdhK7fWpF62I2TL
         x6BaUjBjQqwixXbkOToSFDKtQZE7AHdDkJp3BURDOzOfdx5JTG/Vfi83O4XcdxpFBVtX
         XoB1SsVQa2a0Ka+LRtqXCkNRuXGXcCRJ0NdBAAOYDH3eXU34j6fisP0fxXlDGIf9u++K
         HmvfUBHRzx2/byFIvyl8cVNXZrxThjcqXdZKrCJiKDek4Vukxl90+plG7NJoIdvRty4y
         nLMg==
X-Gm-Message-State: AAQBX9dM5clPq1UeYDWcKZqwwVGGZdl5aHqC/dWlvKPVwsXsRDPdc6zh
        DnlBtpu9oRk8y/DU/n6PFJ8O0CfbbqUrCA==
X-Google-Smtp-Source: AKy350alvPsrvd3vbZ46U2PcB6egpavaokgH1wa8cZgLfTivpgHYgmK/Stj6strdPZuvWc0tBqaGAg==
X-Received: by 2002:a05:622a:1888:b0:3ef:37e3:cc64 with SMTP id v8-20020a05622a188800b003ef37e3cc64mr6884024qtc.3.1681917397528;
        Wed, 19 Apr 2023 08:16:37 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 3/6] sctp: delete the nested flexible array variable
Date:   Wed, 19 Apr 2023 11:16:30 -0400
Message-Id: <438e6a7c6f51a31babcd217793a7884903813c64.1681917361.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1681917361.git.lucien.xin@gmail.com>
References: <cover.1681917361.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch deletes the flexible-array variable[] from the structure
sctp_sackhdr and sctp_errhdr to avoid some sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/sm_statefuns.c: note: in included file (through include/net/sctp/structs.h, include/net/sctp/sctp.h):
  ./include/linux/sctp.h:451:28: warning: nested flexible array
  ./include/linux/sctp.h:393:29: warning: nested flexible array

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     |  4 ++--
 net/sctp/outqueue.c      | 11 +++++++----
 net/sctp/sm_sideeffect.c |  3 +--
 net/sctp/sm_statefuns.c  |  2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 9815b801fec0..01a0eb7e9fa1 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -385,7 +385,7 @@ struct sctp_sackhdr {
 	__be32 a_rwnd;
 	__be16 num_gap_ack_blocks;
 	__be16 num_dup_tsns;
-	union sctp_sack_variable variable[];
+	/* union sctp_sack_variable variable[]; */
 };
 
 struct sctp_sack_chunk {
@@ -443,7 +443,7 @@ struct sctp_shutdown_chunk {
 struct sctp_errhdr {
 	__be16 cause;
 	__be16 length;
-	__u8  variable[];
+	/* __u8  variable[]; */
 };
 
 struct sctp_operr_chunk {
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 20831079fb09..0dc6b8ab9963 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1231,7 +1231,7 @@ static void sctp_sack_update_unack_data(struct sctp_association *assoc,
 
 	unack_data = assoc->next_tsn - assoc->ctsn_ack_point - 1;
 
-	frags = sack->variable;
+	frags = (union sctp_sack_variable *)(sack + 1);
 	for (i = 0; i < ntohs(sack->num_gap_ack_blocks); i++) {
 		unack_data -= ((ntohs(frags[i].gab.end) -
 				ntohs(frags[i].gab.start) + 1));
@@ -1252,7 +1252,6 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 	struct sctp_transport *transport;
 	struct sctp_chunk *tchunk = NULL;
 	struct list_head *lchunk, *transport_list, *temp;
-	union sctp_sack_variable *frags = sack->variable;
 	__u32 sack_ctsn, ctsn, tsn;
 	__u32 highest_tsn, highest_new_tsn;
 	__u32 sack_a_rwnd;
@@ -1313,8 +1312,12 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 
 	/* Get the highest TSN in the sack. */
 	highest_tsn = sack_ctsn;
-	if (gap_ack_blocks)
+	if (gap_ack_blocks) {
+		union sctp_sack_variable *frags =
+			(union sctp_sack_variable *)(sack + 1);
+
 		highest_tsn += ntohs(frags[gap_ack_blocks - 1].gab.end);
+	}
 
 	if (TSN_lt(asoc->highest_sacked, highest_tsn))
 		asoc->highest_sacked = highest_tsn;
@@ -1789,7 +1792,7 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 	 *  Block are assumed to have been received correctly.
 	 */
 
-	frags = sack->variable;
+	frags = (union sctp_sack_variable *)(sack + 1);
 	blocks = ntohs(sack->num_gap_ack_blocks);
 	tsn_offset = tsn - ctsn;
 	for (i = 0; i < blocks; ++i) {
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 463c4a58d2c3..7fbeb99d8d32 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -984,8 +984,7 @@ static void sctp_cmd_process_operr(struct sctp_cmd_seq *cmds,
 		{
 			struct sctp_chunkhdr *unk_chunk_hdr;
 
-			unk_chunk_hdr = (struct sctp_chunkhdr *)
-							err_hdr->variable;
+			unk_chunk_hdr = (struct sctp_chunkhdr *)(err_hdr + 1);
 			switch (unk_chunk_hdr->type) {
 			/* ADDIP 4.1 A9) If the peer responds to an ASCONF with
 			 * an ERROR chunk reporting that it did not recognized
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 39d416e7f795..8d0cfd689b20 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1337,7 +1337,7 @@ static int sctp_sf_send_restart_abort(struct net *net, union sctp_addr *ssa,
 	 * throughout the code today.
 	 */
 	errhdr = (struct sctp_errhdr *)buffer;
-	addrparm = (union sctp_addr_param *)errhdr->variable;
+	addrparm = (union sctp_addr_param *)(errhdr + 1);
 
 	/* Copy into a parm format. */
 	len = af->to_addr_param(ssa, addrparm);
-- 
2.39.1

