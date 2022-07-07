Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C4156AA64
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiGGSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235693AbiGGSWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:22:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C370457247
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:22:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v1-20020a259d81000000b0066ec7dff8feso769143ybp.18
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R1WcdFk/TWy+sEGVd4Eg6xNGBTF47VVsySZzXRRJmuQ=;
        b=p0IZo4quADAm9LtBXYER13jRilXxoEbNNtWctNbyaz94erFfW+/Ae4hr4rVCQ6taf0
         RmvqWwPSaYaZpN4RAUiJKaeUTKAWY6RA2Ge7MirqMcudrm05hCquBdlmHuCtPCgW16Xz
         8dFkgNLraPLJDys+pHz0L/ELmkfeGXC+ojce8v36eAWvM8/4fimra2bPU+YQzvuk8kTO
         cMj85XWyMp3nRUmvJfof1bHn8YbcbePJGEB8tVkbFN0MosoJiWlKlcUiwIOFvOlp719z
         KZr2S/fCabh/SdU+11LuCoGVEAFPO1dgHcFjbmOlMSMcFuvAaXi2snaZ6PZpE7Vsmds3
         /0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R1WcdFk/TWy+sEGVd4Eg6xNGBTF47VVsySZzXRRJmuQ=;
        b=nlHgBU9SSJZ+2D9Wa+BEZ7iJ0LWmOuh3pQhYNirNcKpTDkxcci3OvVVymiRR4Amo8M
         BdvpXZfgFnZKwsXAaq9fCrwE+OZKhOtFA/8gLujfqJbjTjILtJ2thtH+XL5esUn5wnog
         dRvnZtpwY76Hf8x99Q2uSLkh0FyoOqnxqhm7pNcuLURBXZtqMmHgsciEGXQXdKtfeoYH
         JE51QseSmt4DTHpCeBdq+75KJK0VVcBwK1kQo7CZINLUQp/SDcZSXQUuVWTYoVp7NaJ9
         jjqoZW/4TeDy4dZOXBeAUx37tlVdTXTO/CbQ+v1GgI8V6b6XFoqnnzatGVq6KNrNBZOw
         4Wfw==
X-Gm-Message-State: AJIora8d6GEthdHutQ6/qQqkUCqnqJSPFAmZsYRpITedQ1ZW97c27sFS
        WRJlC2mRLwP5wX1qJJsUvB1Tgfh7GqqwNaxaCg==
X-Google-Smtp-Source: AGRyM1tmNx0T2KWxtxST94klObq1uh9KpQnah6fe41ByOMvHcjrVTSMEGMhluBFJBCjdo2HJ7Z4GUvoKoyA7AFMMDw==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:4640:519a:f833:9a5])
 (user=justinstitt job=sendgmr) by 2002:a25:9345:0:b0:66e:3100:c83d with SMTP
 id g5-20020a259345000000b0066e3100c83dmr29236559ybo.185.1657218138053; Thu,
 07 Jul 2022 11:22:18 -0700 (PDT)
Date:   Thu,  7 Jul 2022 11:20:52 -0700
In-Reply-To: <20220706235648.594609-1-justinstitt@google.com>
Message-Id: <20220707182052.769989-1-justinstitt@google.com>
Mime-Version: 1.0
References: <20220706235648.594609-1-justinstitt@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2] net: rxrpc: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     justinstitt@google.com
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        marc.dionne@auristor.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        trix@redhat.com
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
diff from v1 -> v2: 
* Change format specifier from %u to %x to properly represent hexadecimal.

 net/rxrpc/rxkad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 08aab5c01437..258917a714c8 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -431,7 +431,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 		break;
 	}
 
-	_leave(" = %d [set %hx]", ret, y);
+	_leave(" = %d [set %x]", ret, y);
 	return ret;
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

