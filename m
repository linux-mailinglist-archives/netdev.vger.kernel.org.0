Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45F434A66
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJTLpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhJTLpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:16 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7524C061753;
        Wed, 20 Oct 2021 04:43:01 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v127so18296294wme.5;
        Wed, 20 Oct 2021 04:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HFyrP4xf/vjyif5jcCbukB7GgRz8CODvpNLw/aSEVuA=;
        b=aFz0ZAqi0X6Vvap21RZooZG/XBO4Qx9keXzwFgihxZOTVdOj3s0WTaqaJ202SXwoXG
         ufHMVYu6TZIuAQgfm73AzAMvbRrta6DgV4+IkE+2df0QghgLKb07/HTmloPtuhjp1KGo
         a7TeeaJDT4RfipcCW8ctQFnXfSa3DCaqI4QjsiSNk1V4g6OBB5I+qMpg/a1w21JCcJxF
         9dhK0PZJL82uGYspqOy/BHg6Jx5ZoY+ovztww21znem5oimAsglrnP6nTPKXnTfpKB0q
         rQHmGY2BxK2MGYaOE4Z/5FFx3VDNTy4BVHQfyG/RJS6xFyAbvhfjHe3YdJ8a4LuLecEm
         Mz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HFyrP4xf/vjyif5jcCbukB7GgRz8CODvpNLw/aSEVuA=;
        b=yNzdaxfrpIxcPRZZXY2iOS3Snz7bnE0kEjqxsopmQVviX/O9DEnULrsRDTyXm6o4EW
         8axqPnuqHHID60bOjdFatlQ316pedCSrCFZ+vP1fUPGveswVTk/bIuo7mQGLzyz11khD
         9QgbwJtYUGdY+eS40NB0Vn6VibHUb/Er4Bb+lEQfDQUNVarL1GAQ4yyAERUEmYD0++nh
         ERY3ROPgo9VatWkyY+CrzzgFbeGvFonWSOurSCHGM0UqSzhM9SRxgnnQx3GLFVpKanIl
         cZjvQ9bi38T23kzm/w8t6T4ArMIp3fg8VOtxqJQzde56P7uMMP4sqM2EA2IVGNqHWIyk
         JPrw==
X-Gm-Message-State: AOAM532MT8iijtDNn3Nr9SGvVFLIV6a+iLK8BYj/nP4N/YX+17qZBsuN
        PdWz2aH/R+L5jSGttQ+8F3orv2Osq5ODug==
X-Google-Smtp-Source: ABdhPJzm7delf5tC6EQL30lMsyIMz/z2bB6AWV32DDx0qT6cJvUAif63MrAwr3VrB1ekLMUGoaCLeg==
X-Received: by 2002:a1c:5413:: with SMTP id i19mr13038238wmb.31.1634730180439;
        Wed, 20 Oct 2021 04:43:00 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:43:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 7/7] sctp: add vtag check in sctp_sf_ootb
Date:   Wed, 20 Oct 2021 07:42:47 -0400
Message-Id: <b7221eca9f9d31c4efcaedb9ed63816d2e19db22.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_sf_ootb() is called when processing DATA chunk in closed state,
and many other places are also using it.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

When fails to verify the vtag from the chunk, this patch sets asoc
to NULL, so that the abort will be made with the vtag from the
received chunk later.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a3545498a038..fb3da4d8f4a3 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3688,6 +3688,9 @@ enum sctp_disposition sctp_sf_ootb(struct net *net,
 
 	SCTP_INC_STATS(net, SCTP_MIB_OUTOFBLUES);
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		asoc = NULL;
+
 	ch = (struct sctp_chunkhdr *)chunk->chunk_hdr;
 	do {
 		/* Report violation if the chunk is less then minimal */
-- 
2.27.0

