Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E404950F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfFQWUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:20:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40638 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbfFQWUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:20:46 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so18412674eds.7
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USll/BQoEMD9h/5s/gE0+mUmlLpHN4EGkzRtmNYNT3A=;
        b=XXCcsuXdBLEAzoW4Q0iFd/MXLh5QWWfm78sqt3zu2fHUonh0V8LavMmoN01/z5QdJx
         /ed5/IyPxtpljecFaqRxB1Q3YdFaUgv4b/Y11K02MMu4S7luK9GzzAhiGD9bBrppB/s1
         G1orGY3AX26Go/+3eRWO0azz4qITQUxmGOZKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USll/BQoEMD9h/5s/gE0+mUmlLpHN4EGkzRtmNYNT3A=;
        b=Du/9GznJYlGthV3KDqskYmNz7M2T2j4m+WysteHOmp3E4b0hrycXD1lJLs5BWiPYKj
         1kP+Z8tYQ+9lAaUEFWSrdr8ohFifXP2sPJFZKPG6Dp+Kh54UyTZnKJybwGGb5dF70kB7
         b1kLWLEPmrOx+LHB3Z9wKVoc5pDcQGihhKpDXLY+sPUbuCEoUvaQQfAybrUWJnJLZV4j
         RwO5uixqgb+KqN5ZJuUzL9H59BZSgQnoXwNCjCQE3IBl69m5CkAzfN5wTNGFFbuV1+tV
         vRrnMiPdNjCfmDxWfFvj0cDc0Wt1GH4CBsI5ZVqu7C+E5nAMbYAJv+bKne6oFGQkafD5
         +QgQ==
X-Gm-Message-State: APjAAAU2F0qX7BK1lW/NIlpUGkd4Lpg6U+3VM+r0Fhf211Tz0o8evNVW
        0TiFWJ19OQLYXC0yRem3J08/dQ==
X-Google-Smtp-Source: APXvYqxILhC7W+hcTx2f5lyVXRTW0CzNQaSIZVhNA5PQLCCOyRUjqKrrJhYzf/q6cehRDbaouKMMTw==
X-Received: by 2002:a05:6402:1557:: with SMTP id p23mr45110600edx.207.1560810044811;
        Mon, 17 Jun 2019 15:20:44 -0700 (PDT)
Received: from prevas-ravi.prevas.se (ip-5-186-113-204.cgn.fibianet.dk. [5.186.113.204])
        by smtp.gmail.com with ESMTPSA id 9sm1034852ejg.49.2019.06.17.15.20.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:20:44 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Baron <jbaron@akamai.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v6 2/8] linux/net.h: use unique identifier for each struct _ddebug
Date:   Tue, 18 Jun 2019 00:20:28 +0200
Message-Id: <20190617222034.10799-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190617222034.10799-1-linux@rasmusvillemoes.dk>
References: <20190617222034.10799-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes on x86-64 later in this series require that all struct _ddebug
descriptors in a translation unit uses distinct identifiers. Realize
that for net_dbg_ratelimited by generating such an identifier via
__UNIQUE_ID and pass that to an extra level of macros.

No functional change.

Cc: netdev@vger.kernel.org
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/net.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index f7d672cf25b5..a080ede95b47 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -264,7 +264,7 @@ do {								\
 #define net_info_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
 #if defined(CONFIG_DYNAMIC_DEBUG)
-#define net_dbg_ratelimited(fmt, ...)					\
+#define _net_dbg_ratelimited(descriptor, fmt, ...)			\
 do {									\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
 	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
@@ -272,6 +272,8 @@ do {									\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
 		                   ##__VA_ARGS__);			\
 } while (0)
+#define net_dbg_ratelimited(fmt, ...)					\
+	_net_dbg_ratelimited(__UNIQUE_ID(ddebug), fmt, ##__VA_ARGS__)
 #elif defined(DEBUG)
 #define net_dbg_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
-- 
2.20.1

