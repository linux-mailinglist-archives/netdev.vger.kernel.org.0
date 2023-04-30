Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0956F2B74
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjD3Wvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjD3Wvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:51:44 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBBEE41
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:42 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-5ef420b51adso9477926d6.0
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682895102; x=1685487102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CuMZJDNdlBPhsaNe3nGFmn6Zi+QbsqBU0fvx7rf4gw=;
        b=fyHX921Mo7yOLxAmErKEsQ3NAnZYKB53rDzxn4BgbUD0LCpQZQzlxI+5iz12StY4RG
         M37RjeoUF2DO7v06hOUVDzhgDiCRZkZYeZe2eUInP4amF5uc7sTBCJTS1rAnnpw18LX8
         joliTTkQBe+bWPzrWOSMGUdmq5dHvAb2zcgXIokHstNOMmb6IO0xyfxe3hRiZpHr0kW+
         KirJuzom4umSNwBkeZPqAn2fVPKQL04glWYw4DbHsymi4wIOvajGI7UGzePOXKnchVHP
         Po5ic7k3pJKfVFByI2LbKLQXH7GQRX807+gpYN8Uq+MKz9nao7ipyuPB7VJfzzmDyFB2
         yR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682895102; x=1685487102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CuMZJDNdlBPhsaNe3nGFmn6Zi+QbsqBU0fvx7rf4gw=;
        b=VtFcpUwkMrxfhebNZlY4VsYy19WEWZwV993+V60iE8+HJDNXuPUwY34BQ7xBzwF1pl
         +pgxMVzQiaQ458R4CV2oedCnDYeekUGND2rIoXtLPJ5GF4Ka2ytpSR49nQAgWMGEze6C
         eeu0zQbsExTa5O+NHCLBM3CkrPDjFHNaP9bbThN6aZkhq5au8MYgQRop6dEqUmS3itQc
         3MInB1SMY6TPhx5/7zibNF4FgkOYT4QvgL444W9cdoVwoiMqyI0VoSCgUDNC3qfnFbkY
         rb/i4WPq80XATsLj/qPrClScbrT49m9yXS+Q0hOkXkkyKcHex7YkZARj/6I1bCUReppL
         2+tA==
X-Gm-Message-State: AC+VfDwdRjNUeq/UlBkINaehP5WvfmZC6my/XzycI7iLCDPZ+YuK+TDb
        9o90C2rG8Y3q/wH4QdZLi6k=
X-Google-Smtp-Source: ACHHUZ6BpX5NizXq63y6lqCqUT08IE0cZptQLXpAE5HMz6nfW+P3U8RCYdLs2ABgt6UXwQhNY9TJKA==
X-Received: by 2002:a05:6214:dce:b0:5b3:e172:b63e with SMTP id 14-20020a0562140dce00b005b3e172b63emr21213430qvt.22.1682895101954;
        Sun, 30 Apr 2023 15:51:41 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:e747:e271:3de5:4c78])
        by smtp.googlemail.com with ESMTPSA id i5-20020a0cf105000000b0061b5a3d1d54sm189310qvl.87.2023.04.30.15.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 15:51:41 -0700 (PDT)
From:   Nicholas Vinson <nvinson234@gmail.com>
To:     mkubecek@suse.cz
Cc:     Nicholas Vinson <nvinson234@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH ethtool 2/3] Fix reported memory leak.
Date:   Sun, 30 Apr 2023 18:50:51 -0400
Message-Id: <853fd3b0ec3d38ee5ffbdc95abc0367dd05db7d3.1682894692.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1682894692.git.nvinson234@gmail.com>
References: <cover.1682894692.git.nvinson234@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found via gcc -fanalyzer. In the function nl_sfeatures() malloc() is
called to allocate a block of memory; however, that memory block is
never explictily freed.

Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 netlink/features.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index a93f3e7..5711ff4 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -534,24 +534,36 @@ int nl_sfeatures(struct cmd_context *ctx)
 	nlctx->devname = ctx->devname;
 	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_FEATURES_SET,
 		       NLM_F_REQUEST | NLM_F_ACK);
-	if (ret < 0)
+	if (ret < 0) {
+		free(sfctx);
 		return 2;
+	}
 	if (ethnla_fill_header(msgbuff, ETHTOOL_A_FEATURES_HEADER, ctx->devname,
-			       ETHTOOL_FLAG_COMPACT_BITSETS))
+			       ETHTOOL_FLAG_COMPACT_BITSETS)) {
+		free(sfctx);
 		return -EMSGSIZE;
+	}
 	ret = fill_sfeatures_bitmap(nlctx, feature_names);
-	if (ret < 0)
+	if (ret < 0) {
+		free(sfctx);
 		return ret;
+	}
 
 	ret = nlsock_sendmsg(nlsk, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		free(sfctx);
 		return 92;
+	}
 	ret = nlsock_process_reply(nlsk, sfeatures_reply_cb, nlctx);
 	if (sfctx->nothing_changed) {
 		fprintf(stderr, "Could not change any device features\n");
+		free(sfctx);
 		return nlctx->exit_code ?: 1;
 	}
-	if (ret == 0)
+	if (ret == 0) {
+		free(sfctx);
 		return 0;
+	}
+	free(sfctx);
 	return nlctx->exit_code ?: 92;
 }
-- 
2.40.1

