Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CF35696A8
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiGFX5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiGFX5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:57:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375F2D1DF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:57:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e4-20020a631e04000000b004128f83af17so1691385pge.16
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 16:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=k9hDQgqSg1c2GNzkRo9fr1J72XmUY4xT6POWi8tSVkY=;
        b=b+veUf+iMso1W0ftcosbsD8+NgfUr189mS3pBVAnhKIcsdjKd5MsOnAeYW2GWJktDA
         G8ia/rJSdXr7xfLbaGbUbUdfCLJ0ntBVijcDrT3CQbF5tkoUMYs6+B2A/JhKMH+d0XTq
         ORmyIyn2MtusUg/rSGYPZmRPd7Pk1z2iVveXM6yq0ItEU4IDD9wqrflC9jXoHkBVRvzM
         flgOFk0xah1QthCRP4KCx+DXAhj8hdueOKG6jffabcZwDAfsk08IhZVNpm1LouULdMN5
         b/XVTfXHm3+LJS4tgIfp1FxM0m1t3zW/LIJhBvUi3ew3e7k/9dRl6380lkdDEBMq4bwm
         BKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=k9hDQgqSg1c2GNzkRo9fr1J72XmUY4xT6POWi8tSVkY=;
        b=Sj2yQZD52wZh4WlbTLc/npxxrW8w7TwuBdKIodu3X7EYj5muBXBr3ixx8LlRYAyfLK
         4SXeYX8klwocnzoPP9z3gOj1pYr9DPPRB65CV6NNzvHOpm3VEtuVlmrM4aZWOAw02c6X
         PNQ3K3GyTEmKCW914ih045Zd+8nrbu9l+ahurAlBiEw1s8iKwiWI2j4TxjU4zAeKFxKc
         AsBf69BqOiBMMWND9GV0U/o8XIM0Smcw3gxucgF1e9bSdT0cPWfSZweXubBiaXYHdYmQ
         43CANOJ+nhVchiMg2m/P0tXQayVpTv40IwuNo1zlKKUKMb/2UpQkMcmrD2ssCw5Tprxy
         89RA==
X-Gm-Message-State: AJIora/Dy9u+cac/JYi1WpxlzahtX/jgzN/UTZfYz9+/5J5wnw3cpUl9
        HCJMwaCzMPr7jxVJRux3t0REpCrX49gWCIZ8Fw==
X-Google-Smtp-Source: AGRyM1vIo1TA1ajKwpu+A4H7vkncJ06KptHjEuCXN0h6KsKXFUR1Mnw+ULsk3fWD1HDKgEsrB91/09YqM3y/Wxf+Tw==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:aab2:e000:4b5a:a767])
 (user=justinstitt job=sendgmr) by 2002:a17:902:d544:b0:16b:d981:5c2e with
 SMTP id z4-20020a170902d54400b0016bd9815c2emr23605823plf.22.1657151819813;
 Wed, 06 Jul 2022 16:56:59 -0700 (PDT)
Date:   Wed,  6 Jul 2022 16:56:48 -0700
Message-Id: <20220706235648.594609-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] net: rxrpc: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter this warning:
| net/rxrpc/rxkad.c:434:33: error: format specifies type 'unsigned short'
| but the argument has type 'u32' (aka 'unsigned int') [-Werror,-Wformat]
| _leave(" = %d [set %hx]", ret, y);

y is a u32 but the format specifier is `%hx`. Going from unsigned int to
short int results in a loss of data. This is surely not intended
behavior. If it is intended, the warning should be suppressed through
other means.

This patch should get us closer to the goal of enabling the -Wformat
flag for Clang builds.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 net/rxrpc/rxkad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 08aab5c01437..aa180464ec37 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -431,7 +431,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 		break;
 	}
 
-	_leave(" = %d [set %hx]", ret, y);
+	_leave(" = %d [set %u]", ret, y);
 	return ret;
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

