Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA7B4EB8A8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbiC3DIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiC3DIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:08:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7359419B07F;
        Tue, 29 Mar 2022 20:06:16 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x31so11004508pfh.9;
        Tue, 29 Mar 2022 20:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9nJ17wToVkz2ZPcG9CwbZfW5kPgnDX2ZPn+nnPNEjM=;
        b=YIHFHgdA6n5W2gWzuxkP+FNng+eXZoaQaWsmrB9/EI8v0sRimGtYE3l8bRMt/4nFjL
         mLH5Ku+zm/8uWi41VEimc4+wXh6eiM2UeQXbiqClg4nAvKJ1BS1mB75k/2z/E1synHV0
         HSOVNFod0/FvprNgcEPPBEk9FVUd691ajUaxp8q8a27sJjuuAKnWuQ9HOFLmW3lmpaxj
         rcPk4Plz5LhfkHwk4t8XFTxbUxS/OT18gbOlsBN+QDIS29y3RxTifdoYz12IlR9QwM1w
         iM6EzEb2FArDEiftWl2RvcHHsbA4Lwee58CbLVajegQD3MHPS/+eDRE4qrpPi93POJVK
         hmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9nJ17wToVkz2ZPcG9CwbZfW5kPgnDX2ZPn+nnPNEjM=;
        b=TeE2R96tdvUlwsPg9PbNQk2Y2rsoQcVJOdSR2fxtocqDK0RUQKrEBJlHWIrhLF4taJ
         XmjsDUyPQnQPnGhH+ERiDGIo5zCfVC9mXdDg9g4xsLHVSjfuBf4igcYiWbhwMVxLJlOz
         FADIW1iVwwqDHQho4lD4vtDz5y7zXNkayPw/sYXPv+jdAORV9uynqppPSSzZPfCwi/R8
         ZAT00HqXcQpBOmr5QlxoixdzVxqw7pUAdEKtYIBs4E22f+ybKv8WujuBiN7p9TyecFdg
         ZLlbyg8WMwaYQ2PbN5b+aJyZMdA73y2bvpDMBg6EOqyqztef6GslPhnf1/6XI/fS70ui
         tNIg==
X-Gm-Message-State: AOAM531FT7PsFPtTqgxKvZaSq3iWwEnZ8qCYEGbNvbpa+MWiulzT4imD
        SnXmO+s0bzaIr15fFOOgXh4=
X-Google-Smtp-Source: ABdhPJziKwrQwsTEiolYXFJ3wetNXgLmuTtWkwyIBw14VdXaIU0xHOdCnk0egF+JR4qdaKH6hvYORw==
X-Received: by 2002:a63:17:0:b0:37f:f283:24b with SMTP id 23-20020a630017000000b0037ff283024bmr4390753pga.407.1648609575963;
        Tue, 29 Mar 2022 20:06:15 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id u14-20020a056a00124e00b004fab8f3245fsm22067326pfi.149.2022.03.29.20.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 20:06:15 -0700 (PDT)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net] sctp: count singleton chunks in assoc user stats
Date:   Wed, 30 Mar 2022 13:06:02 +1000
Message-Id: <0dfee8c9d17c20f9a87c39dbc57f635d998b08d2.1648609552.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
counter available to the assoc owner.

These are all control chunks so they should be counted as such.

Add counting of singleton chunks so they are properly accounted for.

Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 net/sctp/outqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a18609f608fb786b2532a4febbd72a9737ab906c..bed34918b41f24810677adc0cd4fbd0859396a02 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -939,6 +940,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		case SCTP_CID_HEARTBEAT:
 			if (chunk->pmtu_probe) {
 				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
+				ctx->asoc->stats.octrlchunks++;
 				break;
 			}
 			fallthrough;
-- 
2.35.1

