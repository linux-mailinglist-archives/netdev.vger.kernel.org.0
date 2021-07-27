Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E088B3D8059
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhG0VBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbhG0VAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:00:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A9C0617A5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1036152pjh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkEBu3cyC8P91iNzwefz43r+qwwsnaf9Um6lJSfLX/U=;
        b=dnENAk9DzH5dgHVppNp1v9l3w86qTmdkLa9Jj4LakaevVCf/iS+sojLxHAr89q9wGa
         1fCabL74Qjnciuh4GbRWY0QMtJihWUHg9slAdVEVJB+IsGbTLEE8Dlb87gC23UZGTKB+
         ZbpL1Gb9H/xRsxA/XACoxQ6NacgDHZVJ/L9f8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkEBu3cyC8P91iNzwefz43r+qwwsnaf9Um6lJSfLX/U=;
        b=A9bNnj67S4SD98jwa9Z6HpV7snwMQ10jR+pSCVcIZp/oMK29oPAm2+vmGhqgOHUqyN
         +P6OKen/WMe8GEHhX1IXfrqoJxFFeI+yyfZ2fkwl92Ba/XKlHZaZ8ZBhj4sCj0/qP7sX
         JXY0Y949vjrg3i7puvptzcLJvD4QO312/pLHB9raDidjc/r8RxchKDaVEFRQzFGJsybD
         9o0GmnzBKG5i2mjp1ohjRfCU6CjBbWmrbkRvqRUAbITV4y8Iz2CS4X7IVG2jDI6Goxuy
         DNTjhS0g4eHJ0HOtp8IwcoweISq5lT/BnaMbD2zK7xNFY3QSqLYJ7d19vLQl0mprAEIe
         3suA==
X-Gm-Message-State: AOAM532hTHkogkAvwb8WrwYuCHxn0XJpXRm2wQtL/U7Dp/nHP08fUgfc
        ig9HO3dnIh/YszqbRe3RYFUenA==
X-Google-Smtp-Source: ABdhPJxk0cC72IDwqrlYB1bp1QpRSwhRFLNYtyZi3PbioBLkTbjhG7cCOwJvpMi1oBzdvFnMDhIhyw==
X-Received: by 2002:a63:1658:: with SMTP id 24mr25466811pgw.307.1627419554930;
        Tue, 27 Jul 2021 13:59:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g27sm4893301pgl.19.2021.07.27.13.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 64/64] fortify: Add run-time WARN for cross-field memcpy()
Date:   Tue, 27 Jul 2021 13:58:55 -0700
Message-Id: <20210727205855.411487-65-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1942; h=from:subject; bh=RTdC1l2OZqdjmeHWbAdwbLJoQzG6khjndsQEFnTv5CQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOOoYe9sIhYxHQvPTRJ442xiTpScfryHfKvIe1i sHyzRDqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjgAKCRCJcvTf3G3AJgaOEA ChcfQRhtSTlAFifX9KeThgQ0Uq0d8HgqX9d7L7di9/gmd2+q9a2jOeVLC8gckPM5zLCPjGAPeADcAJ d66hhTLJ1w+E4pD+VvWPPeopnlvv/UVfWd8PB4LJbpoWEceJ6eDTiiC/iLcY/ccmaowSsyM+RD0OP5 pMnkTErmHRoT4p4KW6sBF/D5BjOB39tfSy91Re1raHesEqaFybA9fcJflSdn9W1aI0bHciireUFofB T7rpT4s4qFia+UxE36sxzshuQHwig6S/H7514YsynGyxfM2Qklu8gbfDJ6LAQkHClc0bfyTIiXESyg ywDP93+de3A/S6fGfgl93xa940kRjzrhL1qnzlP0zaVOVbpcgLzsYJ545IJ+TmM8HpJfojPa8GKSuj R4VLih6/XrTEQA2B5d0z/qwYFEm2tk1ALTz5bfkiQLeNBQmj07WzORr0H4yRF3LHyo1EMp06zJeCss ob/ijvKIueEYm1x2q9NTIgloeNO+GTCHYSFzMjtXiJQtqMTwWCPDd7OHie3E3Zdy5kLslb0XwSb4bI 13oeoYOHrWStAAAcuZNIxS1XS1W9LtGkezYc7wGb1YsgX/cpuksW4RJ70bOOYlCUI7ORAmfo/O5xvj 2M/YGfM4cY13yTZbLkY8Kekpx9XUxEtviQZlLWMI0ntWBHVrpbS8XpEjS9xA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables the run-time checking of dynamic memcpy() and memmove()
lengths, issuing a WARN when a write would exceed the size of the
target field.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 4afd42079d3b..0d0acd959ba0 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -260,7 +260,7 @@ __FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
  * V = vulnerable to run-time overflow
  *
  */
-__FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
+__FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 					 const size_t p_size,
 					 const size_t q_size,
 					 const size_t p_size_field,
@@ -309,13 +309,25 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 	if ((p_size != (size_t)(-1) && p_size < size) ||
 	    (q_size != (size_t)(-1) && q_size < size))
 		fortify_panic(func);
+
+	/*
+	 * Warn when writing beyond destination field size. Since
+	 * flexible-arrays are considered 0 bytes, we must ignore 0 sizes
+	 * at runtime for now.
+	 */
+	if (p_size_field && p_size != p_size_field && p_size_field < size)
+		return true;
+
+	return false;
 }
 
 #define __fortify_memcpy_chk(p, q, size, p_size, q_size,		\
 			     p_size_field, q_size_field, op) ({		\
 	size_t __fortify_size = (size_t)(size);				\
-	fortify_memcpy_chk(__fortify_size, p_size, q_size,		\
-			   p_size_field, q_size_field, #op);		\
+	WARN_ONCE(fortify_memcpy_chk(__fortify_size, p_size, q_size,	\
+				     p_size_field, q_size_field, #op),	\
+		  #op ": detected field-spanning write (size %zu) of single field (size %zu)\n", \
+		  __fortify_size, p_size_field);			\
 	__underlying_##op(p, q, __fortify_size);			\
 })
 
-- 
2.30.2

