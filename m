Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552E4219409
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGHXEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgGHXEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:04:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C2AC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:04:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s9so504519ybj.18
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jny5Jx5rRXxMy/sC2H9QJqimOZ5hbGj1rz6/5Fw+2UM=;
        b=qBuqwOKV7bQlTsZUh6QG8X200PnhiWCcbV0CYfl/19ebuoYpaCjHciGfnwc4xpERiT
         oGPwUKczb7e640dhE0Aetn212ws5ZrUM3c/EQj5xTcSKYbcE5ExNgxomuuDJ+acfv71V
         MJaEaoZJycaKvBSrcwpO2oNt5soZHpkv881Iu5Jf4BTm7TVwPgMQVIrq+Y4batucKEz6
         on/7aQN4fzu871sdsToAy7qBev0UAp1EEg6tXuHsLfTp/e15QD/vrV5NTyRXFtj7HfMI
         xA8Kz5pTqUGoY7ZjHluAxocSkJAJtR+nFsshyr1oRyruKJ0sXpixnNJIo2xRa0f9R5Ar
         REyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Jny5Jx5rRXxMy/sC2H9QJqimOZ5hbGj1rz6/5Fw+2UM=;
        b=QqWOCAF1N1Vk0lJnhQJgBqklnvzxM6RtHfgmSidRli3qoyzdBL3evvGPo4hLxEOPgj
         hIWj6uC85coXQlsquDa9hLvkcghLrtN1oKVwPTk2YQYGorYfFD8l6XN5m7eLnw7s7owd
         8RR78DXqWYmGOaauk315VFuu8xj565j0OXQdhSmLPCkwhbSOIpA8zllO7ItumGJrcLY7
         ZA4muIMckHweSilkS+ZZCL//Zr9E3IQlWn4L5O3knO1d+HzDxe51jki0SvUMnFj+LzCX
         hgiON//SgKg8w5jkhnk3M7rxGvZCij71De9QMdlS87CxQlsRHuaZ35UfG0nxVgbgBa3r
         J6Vg==
X-Gm-Message-State: AOAM5332i+v7O3gGrdIHMmVBzlz+E7tl+pZ4gqUnIa/yGLaZ71BNIORr
        YVZAc+IizcgimoJYLZ+yZGgsxhO4QKxhSmjCBa8=
X-Google-Smtp-Source: ABdhPJx6jLZ9Y3bCf7Mw+P2PyuwSU2tVMYJaFk4lhhD9G80zH3tVnFyX+9w1cgH2JUvzLVddrT8iwMoEC8RM5uAoVTs=
X-Received: by 2002:a25:bf8c:: with SMTP id l12mr106119503ybk.447.1594249482233;
 Wed, 08 Jul 2020 16:04:42 -0700 (PDT)
Date:   Wed,  8 Jul 2020 16:04:02 -0700
In-Reply-To: <20200708230402.1644819-1-ndesaulniers@google.com>
Message-Id: <20200708230402.1644819-3-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 2/2] bitfield.h: split up __BF_FIELD_CHECK macro
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This macro has a few expansion sites that pass literal 0s as parameters.
Split these up so that we do the precise checks where we care about
them.

Suggested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1-V2:
* New patch in v2.
* Rebased on 0001.

 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 11 ++++----
 include/linux/bitfield.h                      | 26 +++++++++++++------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 311a5be25acb..938fc733fccb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -492,11 +492,12 @@ nfp_eth_set_bit_config(struct nfp_nsp *nsp, unsigned int raw_idx,
 	return 0;
 }
 
-#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)	\
-	({								\
-		__BF_FIELD_CHECK(mask, 0ULL, val, "NFP_ETH_SET_BIT_CONFIG: "); \
-		nfp_eth_set_bit_config(nsp, raw_idx, mask, __bf_shf(mask), \
-				       val, ctrl_bit);			\
+#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)		\
+	({									\
+		__BF_FIELD_CHECK_MASK(mask, "NFP_ETH_SET_BIT_CONFIG: ");	\
+		__BF_FIELD_CHECK_VAL(mask, val, "NFP_ETH_SET_BIT_CONFIG: ");	\
+		nfp_eth_set_bit_config(nsp, raw_idx, mask, __bf_shf(mask),	\
+				       val, ctrl_bit);				\
 	})
 
 /**
diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 4e035aca6f7e..79651867beb3 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -41,18 +41,26 @@
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
 
-#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+#define __BF_FIELD_CHECK_MASK(_mask, _pfx)				\
 	({								\
 		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
 				 _pfx "mask is not constant");		\
 		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
+		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
+					      (1ULL << __bf_shf(_mask))); \
+	})
+
+#define __BF_FIELD_CHECK_VAL(_mask, _val, _pfx)				\
+	({								\
 		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
 				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
 				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
+	})
+
+#define __BF_FIELD_CHECK_REG(_mask, _reg, _pfx)				\
+	({								\
+		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ULL,		\
 				 _pfx "type of reg too small for mask"); \
-		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
-					      (1ULL << __bf_shf(_mask))); \
 	})
 
 /**
@@ -64,7 +72,7 @@
  */
 #define FIELD_MAX(_mask)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");	\
+		__BF_FIELD_CHECK_MASK(_mask, "FIELD_MAX: ");		\
 		(typeof(_mask))((_mask) >> __bf_shf(_mask));		\
 	})
 
@@ -77,7 +85,7 @@
  */
 #define FIELD_FIT(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
+		__BF_FIELD_CHECK_MASK(_mask, "FIELD_FIT: ");		\
 		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
 	})
 
@@ -91,7 +99,8 @@
  */
 #define FIELD_PREP(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
+		__BF_FIELD_CHECK_MASK(_mask, "FIELD_PREP: ");		\
+		__BF_FIELD_CHECK_VAL(_mask, _val, "FIELD_PREP: ");	\
 		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
 	})
 
@@ -105,7 +114,8 @@
  */
 #define FIELD_GET(_mask, _reg)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
+		__BF_FIELD_CHECK_MASK(_mask, "FIELD_GET: ");		\
+		__BF_FIELD_CHECK_REG(_mask, _reg,  "FIELD_GET: ");	\
 		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
 	})
 
-- 
2.27.0.383.g050319c2ae-goog

