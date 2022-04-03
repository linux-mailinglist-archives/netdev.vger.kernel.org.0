Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFC4F0D09
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376714AbiDCXt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376708AbiDCXt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:49:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EBC31DC6;
        Sun,  3 Apr 2022 16:48:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b15so7403406pfm.5;
        Sun, 03 Apr 2022 16:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHih5qYud3gwpc0kA7gSc5BqdIQcNRcXvWHha6d+ce0=;
        b=BR0rWxkyXqCP7l/hxG8IZYf+m0YGHDPslCSycero7GItNmX6XbmmpgFmbMCvyYUQG1
         abPjh6QBjobeWr+4ZfybH7oMBPngEOx1+icNUPT942qz6jk8xdGoVPf5rapYW5cCNJl7
         WVLItsUpmbL8WZ7bRZGZUDn5yv+wFImjYGJgaEVjaV1KVHW7Iv9z/cvJCjUqZH2Tt0aq
         7+naqm9fGQBeAKaXcpR5bluoEIKwM5iMYUgFNoVVP8A4HZKGqKUXuwQFhe3rlgLha6U8
         qAGU0PfhxZzbVOVNSS0S8kida6I35dg1IFK0bAPmBwQxguR0173BOZPrgk8fyhxSidQj
         vSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHih5qYud3gwpc0kA7gSc5BqdIQcNRcXvWHha6d+ce0=;
        b=OKfBLm/t1UnTYSnxQrqEWIfpvTP7Htb7DY8yJh1UzMfQAnUuNczOKz0V5HiBqEuAPt
         TbmBE7uA9diPxNGZOcF/L+Ckp8+ZiuWCFkeO9cKmz8AXDxdFN9anEGqwiX4GmgQhcDNN
         OgAtmi/7QtPYxbSC2+LjbCWcDPrcxAPRUE33nTRehqUlLUqBOe8VUc1nXJkBE/8SaV0y
         Rgweuda8VeM6orB2qN5ZiMMbUl23hBWy2e2IkYCxsk2CQgscjHNQ03F73qSKVjwMNwZ8
         fYhUxZGinjfLVl7gPNPz5DyGiCnJoc1pGjI48GrrL66GSgnnXLBSXtTE4hMkjMSzLAcw
         wjlA==
X-Gm-Message-State: AOAM531c8GLGqZOGdct+UzGXpY+Gfb5UhB3AIAiIY1+rxoW6JMwMjPe4
        zWht7JJqsziFoJRiHmR2AHS28j6ISmu2Gg==
X-Google-Smtp-Source: ABdhPJx3b1l0Y3DLl8daAMSMMuGia5ETy4HN5zpZE5n4aef18Uo4SCdWIkjHHJ2JrN2NirgFQmjx3Q==
X-Received: by 2002:a63:7945:0:b0:398:19c4:14d3 with SMTP id u66-20020a637945000000b0039819c414d3mr23668846pgc.20.1649029681130;
        Sun, 03 Apr 2022 16:48:01 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm19102989pjl.39.2022.04.03.16.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 16:48:00 -0700 (PDT)
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
Subject: [PATCH v4 net] sctp: count singleton chunks in assoc user stats
Date:   Mon,  4 Apr 2022 09:47:48 +1000
Message-Id: <c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com>
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
 net/sctp/outqueue.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a18609f608fb786b2532a4febbd72a9737ab906c..e213aaf45d67c61edbd22abc8be6cd4a197a9ed8 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -938,7 +939,10 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 
 		case SCTP_CID_HEARTBEAT:
 			if (chunk->pmtu_probe) {
-				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
+				error = sctp_packet_singleton(ctx->transport,
+							      chunk, ctx->gfp);
+				if (!error)
+					ctx->asoc->stats.octrlchunks++;
 				break;
 			}
 			fallthrough;
-- 
2.35.1

