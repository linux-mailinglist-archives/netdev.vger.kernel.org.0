Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F759434A58
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhJTLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhJTLpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:08 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF76BC06161C;
        Wed, 20 Oct 2021 04:42:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o24so10883175wms.0;
        Wed, 20 Oct 2021 04:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VwHJhYODjs1JSakaHf2SUd7FFDGYoerS9uZirIeSeZA=;
        b=XL6TcxdzCHgzWt635ibKqiwgHKJJfEf/xzN4qReUVE6u0dsDDFfDFvk1aUOXzVfwvG
         Y72b+L3Rz8HGFPD14o20q+A3kfYa8qaZJ+iikukZyBnbFLSU0lvn2JpqUtiysDsQmRmy
         aWAtypA1f6k0JS25RsbYD1qWqrivAdCQvvhWdWlVXcHhrlgX91TWLyfhMqaWQ4/HESRU
         jpTvLg3/4AwKH1CvS4j14yA/NQ+btx4vN8hDV/Z8yypGn8u+z6rig2Cu+ZffHiDvG20o
         GdCNGkeBsryItAEfLnJqa8O6KvFS2ewEXz4pDBIu7WG3qPErAoP7HHz4fOaNxHzYpZ7R
         X87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwHJhYODjs1JSakaHf2SUd7FFDGYoerS9uZirIeSeZA=;
        b=jXyHlIolTwcgq5lQZCxO07AxVF9H2YkDpLxnCcHCS9Z9GAiUuaQJn5jeoik+sd7YGY
         uaKfRhTvSGmWMIyADx/qVfemQ7OG+QOEHiPLtDODmF4xgIRS7lBpsyJ9aKanL8tyE08S
         IOZy23BRDY5ewOF1GzeeAV9vkLj1nEWzgoXjOH67yzZUpBOgZjC0cZHiX9mOUE1a4SLs
         0PCjZnsp5WruTFgKAUeZADp/HUiLs2wMs0HpOyJcsY2FQRgjgR1MgINQFm4xNLfItps1
         /2j2c/cDtyL3fMc3IbkLm/j8AaiV0gD73MHhtrSMYu531VBlTx7xrlcphjPeDCOwYnw+
         OZuw==
X-Gm-Message-State: AOAM530aw9wEUmZ2Cj47RprQy0fxJ8WLPcWVsLd96iNdc300VNnmXCYZ
        dRhp7d5iIThHTWjw3IhLcGjpDt7xZwi7ZQ==
X-Google-Smtp-Source: ABdhPJyuw2w6Z7MFDaSvdNxk8Ec8Y879r3oYhqzANIdSZDhPQUmhaKtwGUTIUUo5aJDscUx7hrAvkg==
X-Received: by 2002:a1c:3b06:: with SMTP id i6mr13134171wma.172.1634730172188;
        Wed, 20 Oct 2021 04:42:52 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 1/7] sctp: use init_tag from inithdr for ABORT chunk
Date:   Wed, 20 Oct 2021 07:42:41 -0400
Message-Id: <c89756464182e3010232c63eb02791be8d743bfa.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently Linux SCTP uses the verification tag of the existing SCTP
asoc when failing to process and sending the packet with the ABORT
chunk. This will result in the peer accepting the ABORT chunk and
removing the SCTP asoc. One could exploit this to terminate a SCTP
asoc.

This patch is to fix it by always using the initiate tag of the
received INIT chunk for the ABORT chunk to be sent.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 32df65f68c12..7f8306968c39 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6348,6 +6348,7 @@ static struct sctp_packet *sctp_ootb_pkt_new(
 		 * yet.
 		 */
 		switch (chunk->chunk_hdr->type) {
+		case SCTP_CID_INIT:
 		case SCTP_CID_INIT_ACK:
 		{
 			struct sctp_initack_chunk *initack;
-- 
2.27.0

