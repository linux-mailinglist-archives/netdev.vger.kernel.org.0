Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C4456A187
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiGGLv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiGGLvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:53 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3C84F65D;
        Thu,  7 Jul 2022 04:51:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q9so25948185wrd.8;
        Thu, 07 Jul 2022 04:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAPF64NM5veV9zuD1EMKVBq3GePhsL9jU8aHYc7hgeg=;
        b=BBX55NsOeI35IxC+ogKWcRNOW7ytm7tu8BkiB+WLNHc8y31QZqD6tbBcLIsnO7CnN1
         MCRt0dkOB4D+5ZO+EtPLhCmRyP9si8kl+Gre7wogUZ1Y0fmeQcWF3oHh6zD+ul+QjF3L
         CJhFX8aiF4n+d7p7bzcildSrjJRsJZ0MZ9rSyB+6CnJNA/8XTlAPMqAhE+5lHqVREPbI
         yWFCQv2r9TTrWhr3V0Z1VaC4PyomQGpnZUI/Nu9S3dXXkQkMfemGW85yf+4WdtkgjmUL
         8QMdzKVPqGxOMZqfAIKnLfG0q7MSvqHEvo3LkFsZImaz6ewPklOWvODG8qICqvVn8r96
         h9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAPF64NM5veV9zuD1EMKVBq3GePhsL9jU8aHYc7hgeg=;
        b=ghm3VQloCN9WlCzJx73pwWtmNB/sb5PjPjD4i+g5HOb1XPFCn2HXfn3VN5pylpeRBh
         HUccWwjHIwlQLLhSbXhrq0asXQqEF1cJHkV9iLSJj5/Z+yIQliySUPHFftmGSN1KY8Q5
         M5V1QX+OU67OMJumTstmXhbHPgt7rUMG5XcEe2p+7NEH39JlS/dEg+WzvMAxhGczriOo
         j1NMMBvnd/9yzpiI85KMN3PfVSCIOKHincuqQqdIFQL21UFJHK4GEaJMbzB9NriKehC8
         Nw9zL5C3w+yOZjW6jzdd1PKamMM+y3nUlWFhEUMEzQ+agstXeOD+oIO3YfXgxPzLFSKm
         YLhQ==
X-Gm-Message-State: AJIora9plbjnVlODCy2Frg0TX549nAiqEeTCbJWcQCKKWbOTPIUteNvY
        IFXaSOaj0Dzo0Ka49vIYwodUyLrB13IAlkPl9cs=
X-Google-Smtp-Source: AGRyM1vLeNDsB+tciFqXTTT+ToeahaP0DGonP10+Rc9J2nSubBDc7clFEL5ZjVyJpRbl8o7H8eL0cw==
X-Received: by 2002:a5d:64ad:0:b0:21b:b412:a34b with SMTP id m13-20020a5d64ad000000b0021bb412a34bmr43133664wrp.161.1657194710401;
        Thu, 07 Jul 2022 04:51:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 03/27] skbuff: don't mix ubuf_info from different sources
Date:   Thu,  7 Jul 2022 12:49:34 +0100
Message-Id: <8fc991e842a43fef95b09f2d387567d06999c11c.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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

We should not append MSG_ZEROCOPY requests to skbuff with non
MSG_ZEROCOPY ubuf_info, they might be not compatible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d82..09f56bfa2771 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1212,6 +1212,10 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 		const u32 byte_limit = 1 << 19;		/* limit to a few TSO */
 		u32 bytelen, next;
 
+		/* there might be non MSG_ZEROCOPY users */
+		if (uarg->callback != msg_zerocopy_callback)
+			return NULL;
+
 		/* realloc only when socket is locked (TCP, UDP cork),
 		 * so uarg->len and sk_zckey access is serialized
 		 */
-- 
2.36.1

