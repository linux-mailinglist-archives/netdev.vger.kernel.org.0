Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A201A434A64
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJTLpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhJTLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:15 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1B0C06161C;
        Wed, 20 Oct 2021 04:43:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b15-20020a1c800f000000b0030d60716239so893313wmd.4;
        Wed, 20 Oct 2021 04:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FarTkLRebExhGKreJ7mi4+JKxhz1j+d7AdI9cqJAodg=;
        b=GqhaUQJ/C4NKL0Tlri+qRhCIq59MKlZsR+OlyLGEr2ny8oLAVilup93lVL+FKJKYup
         fGnOR6SRXmiK5duXgoGbSc6bFSxfSuroMEzH2gFujm64TX5IlwLfVZDrrZuexXSz4vow
         Q9XQnQ/ARLwMTeuLy1gEAzVCKhQ4EXAmYhGienOJLxwvjALXGeBPvCpolNsx5ND21xGF
         OnbHnsMDsYpU+kQxkYgbviQaV2Y632WePtD0mj3r2uZfyoqhzZhBC/nDqd+I2pBWrHsb
         y8GkM5I1sUi0hjMjf2tndw5HNuJGNpl8M0usAtexiaMja9b6Pz4QGrX3DJWrDpX1RaCt
         FfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FarTkLRebExhGKreJ7mi4+JKxhz1j+d7AdI9cqJAodg=;
        b=CUlj7DAbCsIjXLzxJr48yAc9dqWhOihqgbtFvl35alpP32mtCfAQsL7xgXjU4ZTi8b
         7gsmfrLhNQrCLk6w+qQGLIAkYCTbInd5vV2RtCpE7x3QUsmXuNksgt+5F82RkAfc+HPq
         fa2DWB8wXEKAjpdN08ZYjMq1jjs7v2LVJ+1n4N/niS223hp2clAoUKL/cOGgddKk/qKG
         U/OXm0qSDfUTHyOx6D0b4X65CS1Efgj76AopONeHtyfeEFEyQYcKE23Qx5nfoj9CMvAD
         zq8cRXzDQVaDd+j3OmEsTnVo3Qk4+MJyaM8VqjcZ3WI0cFFCFgLuekW/9+OkdgfVDoWZ
         /3eQ==
X-Gm-Message-State: AOAM530JlMJz+3uWZH8LG9UmyFO4E+HuU/0OGPbZaAnZ8RySQHnLWcCL
        W0JcCnvbgGed7GkohayiDuLwV92GgH05UA==
X-Google-Smtp-Source: ABdhPJz2PD/dP0n/+TWZaEopOn1ImArqYSmABDkGmhk+R3LR199GvR3DR3EgEl2Qx9rokvxtHBE8Zg==
X-Received: by 2002:a05:600c:4e88:: with SMTP id f8mr13078050wmq.185.1634730178964;
        Wed, 20 Oct 2021 04:42:58 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 6/7] sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
Date:   Wed, 20 Oct 2021 07:42:46 -0400
Message-Id: <eb2a030b3a2985675a958f41e4eaec2b878a4d48.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_sf_do_8_5_1_E_sa() is called when processing SHUTDOWN_ACK chunk
in cookie_wait and cookie_echoed state.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

Note that when fails to verify the vtag from SHUTDOWN-ACK chunk,
SHUTDOWN COMPLETE message will still be sent back to peer, but
with the vtag from SHUTDOWN-ACK chunk, as said in 5) of
rfc4960#section-8.4.

While at it, also remove the unnecessary chunk length check from
sctp_sf_shut_8_4_5(), as it's already done in both places where
it calls sctp_sf_shut_8_4_5().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 36328ab88bdd..a3545498a038 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3803,12 +3803,6 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 
 	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
 
-	/* If the chunk length is invalid, we don't want to process
-	 * the reset of the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* We need to discard the rest of the packet to prevent
 	 * potential boomming attacks from additional bundled chunks.
 	 * This is documented in SCTP Threats ID.
@@ -3836,6 +3830,9 @@ enum sctp_disposition sctp_sf_do_8_5_1_E_sa(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		asoc = NULL;
+
 	/* Make sure that the SHUTDOWN_ACK chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.27.0

