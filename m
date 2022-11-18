Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167262ECD2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbiKREWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240951AbiKREV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:21:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB68DA64
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:21:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h14so3462387pjv.4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Qim7psr6z8bosgDJRr3cI7ZwHqx7o7Lgluf38w3Bl4=;
        b=WlsCnLzG79oJ51eFf09JHlJ6OHsOGT1QogLgLYTheoyY0iENw3r9UFMm3TSNBbCPRM
         icLoL//EVewsNrFWqgPxtcp5xSiWRr0yRIDDy26i6TPG1Eg1/WlqvEp32x+dZKai5yDG
         tGa8NcYhogrQqZ+mUBIYDV3qHmv7oiDBZLmg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Qim7psr6z8bosgDJRr3cI7ZwHqx7o7Lgluf38w3Bl4=;
        b=HZSXKLR1a14pm8waAs39tUSjrqI2KpmiB9w6gK6eZfQ2aH60boTCzmYjvJuZFAyafu
         WH0DbriOHj91iACwl59c1YTmgDNLG1yU5sM175dARGXoyCQbUB7ix1Xtn9zallItWQcy
         ZgeWCYhqS1zzJKah39NmFx3kR02z55n/CXLR4p+8eWHnqX7cblYWejiWsoo8YY874Gsv
         zLb6YIE+s4jkvzr8+jOy8fzb608mst30p362j+X79wA4aM7szyGeeZlOqjeBMuLJnk+W
         ONmImQa7pbhpJpUOa/r6t/g/SBSA96pu70h/6syd9BF8iQdA0srxzzFJFJOHqo+yMBV1
         PI0g==
X-Gm-Message-State: ANoB5pkhSsdeNJnDK9eGJDWiCetPU3lbjKHAi5YHY/mp45Ybn5dN76jh
        DmDL+JJP7s7jSp6KJbYo0N1O8g==
X-Google-Smtp-Source: AA0mqf7hHKPx+Uh781MQFlo9oPO4uTiCz8D7w3ry5eEW6RDV4JVGveojjjUVH5mLrbAVw5yDrvYRoQ==
X-Received: by 2002:a17:902:f08a:b0:176:a6fb:801a with SMTP id p10-20020a170902f08a00b00176a6fb801amr5833696pla.97.1668745315609;
        Thu, 17 Nov 2022 20:21:55 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902654500b00168dadc7354sm2355047pln.78.2022.11.17.20.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 20:21:55 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] ipv4/fib: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
Date:   Thu, 17 Nov 2022 20:21:52 -0800
Message-Id: <20221118042142.never.400-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1386; h=from:subject:message-id; bh=fFZ7BsSh6I+lvLxvLX9AR5VAcfq0y3IDjOCczrsHj6E=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjdwhgXbx04oa27BZVboxhNu5hfZbzkLHTbQj10nRn 0wq7qU6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY3cIYAAKCRCJcvTf3G3AJoFED/ 0dF3JkzVUseze5YyF+MX7fMxnfUfNmFHOo6CclirkpyXjw6vhQOeNAQFumERISpJ+kxvRpBTP1kE1M MgaIdDuFcFA0VBGcS+8bgRDbagW1SAzRPLFSb7JGm8IYeKyBLi4CRfoX/qLrz6+rrrqGOZuhRaEwpd o8oZFEAFw1s1DNvHpLn0BhAf6ulpdqnbNfiqVXAjjlRZRTNIDEqMe4Upa8Z+Ywj+DDtF8qhLgyMik4 7fuMGR0fpS5jURfwxsqztTlwWEzw5d32j5BxobQ2uzVn6GPiiQFK245kMdFvnYcgohce6poXTIOnYE +TO+b4FODBFRCWouG54VGIvLNRccM27ntQ9tWRPnj6xAI0Vk7Be0gn7k0X5hcmJhGSpeY6Rg4szr7x /c9udCAjOSK4XrsbGFA3Ubtc5Txg3CagE7mr1rTTROCrOawwUz4s2tHalljy8roYLQa4fYGP4WLsUP 00nrEI8zpHsncjIZn7piaGNzmpp6V5/NOtBDKsFFinbDksbwRQzHZlETsH5WzhvPOVC+AsCUBSGuCk XVCqGFPYOcAbGx/srr90xRHOv1O7m4RoN6n2zePZFy0fHt7o5uPLs96sNwrqvppu9vt2xn/5p+dI2U esu+A6exiTLxMuKOw+Bbtx4qZyvesZvP0Xo7JVm33DuQiQpkxXltsFG+Otkw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1] and are being replaced with
flexible array members in support of the ongoing efforts to tighten the
FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.

Replace zero-length array with flexible-array member in struct key_vector.

This results in no differences in binary output.

[1] https://github.com/KSPP/linux/issues/78

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv4/fib_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 452ff177e4da..c88bf856c443 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -126,7 +126,7 @@ struct key_vector {
 		/* This list pointer if valid if (pos | bits) == 0 (LEAF) */
 		struct hlist_head leaf;
 		/* This array is valid if (pos | bits) > 0 (TNODE) */
-		struct key_vector __rcu *tnode[0];
+		DECLARE_FLEX_ARRAY(struct key_vector __rcu *, tnode);
 	};
 };
 
-- 
2.34.1

