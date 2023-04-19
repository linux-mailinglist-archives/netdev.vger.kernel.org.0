Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C79E6E7E03
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbjDSPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDSPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:02 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39D55276;
        Wed, 19 Apr 2023 08:18:26 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-187dc84637aso7415837fac.2;
        Wed, 19 Apr 2023 08:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917397; x=1684509397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gy/aHQhJo3z37sbDf6ajKje4fKZ5wE8Tq3mhw1LqkKc=;
        b=jX6InRAIyTjD1cOfVFHpDWJt1VEls3KZi/E6astHG2Ys1CjaqPC2qTCDR1cYn0wEXy
         MtstKn+7qISxdyyktJJpFgv8uo3uoNgD6iKlViQ13jHEGlkLM2sfKx6JOKTXAZGTm8FG
         GSq1cS2lfjzGFpNYHK/lKGJFNXkwEagqMk0s+Hf6I5ILm/6k2kWpCmLfiV+tKftriLG5
         m0ubnhzrw6X701oErmo6rr/nBnN8V3RMqJpYcqRNKoME3eEzNXuNi1ipbWTdogcu0ppv
         UVnVf4aEmnTuzGxUaiZc9JkTiy2a2Fe6bZ23eqE8LmHIyZfV/Zb9v5fAxC+VwRWWoqBU
         qTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917397; x=1684509397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gy/aHQhJo3z37sbDf6ajKje4fKZ5wE8Tq3mhw1LqkKc=;
        b=Az4ppt0Ncaa9Ar+t6qWIYPrUy5FFSPl+P5j3UD1QIsT3VdTzNk3rvFX/My3O6553X6
         fhVo1oNdbS2TeLX6ayW7RtQSv8DAk9RHdD4on1Bi+88sQpboTsTGw1ilMumRK81EQQaW
         xXbNbqXYkgGAUepCuvUYcBre68AMlsDXqQ0GX6BTAJdE+i8O7M3DLsTqATobH3WAY5Hl
         uNzyN1iohbynLiZdx+xr9foA5MXfk3Q9uITuXocJE9KrwKwCsU5RvNBS9ieMSQyUnvzw
         nx1NWQvVqhzbPoGaEDkOfCE9AJkq5G9tD5TTJhwqCvS+IadcIZzBcIj7uQlj21EADRsj
         /P+Q==
X-Gm-Message-State: AAQBX9ccXhu228We3Ud6JCcBL1avgCaWu8qd3GV0PGWd8PDVuIeFWtbk
        SfhIriOQoVEiVYZjA3wPnROQhdBidC2Yyg==
X-Google-Smtp-Source: AKy350Z+0ei2gpizHYdeBbAlRLc+NVhM7qYrlOBAUDUVod7sMaTG+NaP14YW7O4PcjuUrLkbu1d4ow==
X-Received: by 2002:a05:6358:c6a5:b0:118:1a32:fcef with SMTP id fe37-20020a056358c6a500b001181a32fcefmr10488rwb.6.1681917396702;
        Wed, 19 Apr 2023 08:16:36 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 2/6] sctp: delete the nested flexible array skip
Date:   Wed, 19 Apr 2023 11:16:29 -0400
Message-Id: <48a8d405dd4d81f7be75b7f39685e090867d858b.1681917361.git.lucien.xin@gmail.com>
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

This patch deletes the flexible-array skip[] from the structure
sctp_ifwdtsn/fwdtsn_hdr to avoid some sparse warnings:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  net/sctp/stream_interleave.c: note: in included file (through include/net/sctp/structs.h, include/net/sctp/sctp.h):
  ./include/linux/sctp.h:611:32: warning: nested flexible array
  ./include/linux/sctp.h:628:33: warning: nested flexible array

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h         | 4 ++--
 include/net/sctp/sctp.h      | 4 ++--
 net/sctp/stream_interleave.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 0ff36a2737a3..9815b801fec0 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -603,7 +603,7 @@ struct sctp_fwdtsn_skip {
 
 struct sctp_fwdtsn_hdr {
 	__be32 new_cum_tsn;
-	struct sctp_fwdtsn_skip skip[];
+	/* struct sctp_fwdtsn_skip skip[]; */
 };
 
 struct sctp_fwdtsn_chunk {
@@ -620,7 +620,7 @@ struct sctp_ifwdtsn_skip {
 
 struct sctp_ifwdtsn_hdr {
 	__be32 new_cum_tsn;
-	struct sctp_ifwdtsn_skip skip[];
+	/* struct sctp_ifwdtsn_skip skip[]; */
 };
 
 struct sctp_ifwdtsn_chunk {
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 74fae532b944..2a67100b2a17 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -452,8 +452,8 @@ for (err = (struct sctp_errhdr *)((void *)chunk_hdr + \
 _sctp_walk_fwdtsn((pos), (chunk), ntohs((chunk)->chunk_hdr->length) - sizeof(struct sctp_fwdtsn_chunk))
 
 #define _sctp_walk_fwdtsn(pos, chunk, end)\
-for (pos = chunk->subh.fwdtsn_hdr->skip;\
-     (void *)pos <= (void *)chunk->subh.fwdtsn_hdr->skip + end - sizeof(struct sctp_fwdtsn_skip);\
+for (pos = (void *)(chunk->subh.fwdtsn_hdr + 1);\
+     (void *)pos <= (void *)(chunk->subh.fwdtsn_hdr + 1) + end - sizeof(struct sctp_fwdtsn_skip);\
      pos++)
 
 /* External references. */
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index b046b11200c9..840f24045ae2 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1153,8 +1153,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 }
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
-	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+	for (pos = (void *)(chunk->subh.ifwdtsn_hdr + 1); \
+	     (void *)pos <= (void *)(chunk->subh.ifwdtsn_hdr + 1) + (end) - \
 			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
-- 
2.39.1

