Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF673EFAC2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhHRGGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbhHRGGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:06:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40014C0612A7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:54 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i133so1065889pfe.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AY970ncUJAZ3XFO8vIsQqriyIPN/r8JHpDac7fWieeM=;
        b=gbrUissyxbKZh6+i0ydJTqtK9dcNQZphsHveN5seaLCfNDXMIh3ilxLvzPdFIjcbS6
         ddg41mxoHyF/8KJzOVxpCn2bKQHr17ZwagJLPbkX2GFQVMXp1x1p/FbwBHa8OZJGdGTB
         alLj8ZdYgBfl1SXL2avtmcGtF15Znkwn+zGUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AY970ncUJAZ3XFO8vIsQqriyIPN/r8JHpDac7fWieeM=;
        b=LeDbQ3i51caWtZsCeiWDjsN/MMin+Bag9wZ5KZSxI3v3NKYbdSaJkMic/Wumkjn1bO
         /N2uDhSiOY6icJglPasvbkUEKGJV3306zZszK6fFo1w5xZA5yeIutcS8BLs0Tu19S82f
         5hnoAyohln36NYaoauiwzHb/U81+NnfyimFYLpV6nr5M69J1DQj+YNt8uduwVFPtJMOq
         HguCTqZ6oqPboNrSHIa8PaYy3NOFhwPCSXlZ/CezGcqUMnOv82V00oapAwMMyfLQeFkz
         h4dl+HKJvGT1tbL9y9kgt5idAxCxBLeRBfGFbLUdFhmPPs2+umWMdsjz2uAxqdhdHHZV
         gmSw==
X-Gm-Message-State: AOAM531YUVVGb5U6gNVfmE4TdwdOJ9HtJ253/EoPUrV21dzuOiiydlVM
        pn55n0eW/1CyZ4QkHokVLrg++w==
X-Google-Smtp-Source: ABdhPJw+QAs+bUA8VMXSWCnpCQCxnqdBvH9bhTwAcH150K7mW9Y7PmVnff+kXCe01FlrLRXhBhq+/Q==
X-Received: by 2002:a62:cf01:0:b029:3cd:ee82:2ee with SMTP id b1-20020a62cf010000b02903cdee8202eemr7462718pfg.78.1629266753732;
        Tue, 17 Aug 2021 23:05:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v7sm3785867pjk.37.2021.08.17.23.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 04/63] pcmcia: ray_cs: Split memcpy() to avoid bounds check warning
Date:   Tue, 17 Aug 2021 23:04:34 -0700
Message-Id: <20210818060533.3569517-5-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1806; h=from:subject; bh=MoN9sZmmdDw0lR5vW36Fdr39zzqTtcOilmLJ144gA30=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMeeJZHHO3+hbAJbiz+YaA05/E7kfaAlhhB+qwX bgM8lUWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjHgAKCRCJcvTf3G3AJtxMEA CDE0x/VuR2ilrvgKGfyTDw1N7+A+OmcMMY6KEuirMzNaQoRp+CPej+AIOz4iZ4YR2w/YDSXsCBANOw K5b6FAZFcHd15dHuy0PHAu+t2wf8+a3LvZgMLeRVlO+k9h6oSr2WGMYO39iapHt3B4Hws0oVkh8NWy 0kI1PrCe5WRCiSu4x3jvUSNQhd6157DS2THCGpKJU2Ohcc4ZZzPKzDttnQBP825XysZzujJgtmp2W/ uwnApWbjaQlev0TzuwRYz5R/ARZ7MhuJYrMe2R9OENKkUQeMW93/Nfw5nTLnSsP/BdFZZcwqlamFTV tgJj36zb3bSbbWtFABkmCdVGvriei7S5s0Nzc2nLVfQb20sxUkWetJM+GmYMeGLfN4BhBeIHcKWVC0 Aj+LGMayAdp/W4t3nVbPAg/TlfR76sc/XwdjpXjNaJp/8GkyyVZkJOgAc9+8oheOZIccG3fCFmuAJf XWHNpEcmYrSvY9JP0CNQIsmgE/a9O437lSmu6bRy71Sex0/QvPbdpZBU0bMxAqgihbSllbeOeYytUg RbErVsVrqCl2m1h09j0e/PiZURm8UI4xWRcHupED1wTamnDG9QrcNHdTzFlM3/dYIU4ooyZySLeioj JNWySYCBKT6ERqzpI3hwtkiH0jo9acVRnX0ABbUt8WOMelIC2mwM5j7Div0g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Split memcpy() for each address range to help memcpy() correctly reason
about the bounds checking. Avoids the future warning:

In function 'fortify_memcpy_chk',
    inlined from 'memcpy_toio' at ./include/asm-generic/io.h:1204:2,
    inlined from 'ray_build_header.constprop' at drivers/net/wireless/ray_cs.c:984:3:
./include/linux/fortify-string.h:285:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  285 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ray_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 590bd974d94f..d57bbe551630 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -982,7 +982,9 @@ AP to AP	1	1	dest AP		src AP		dest	source
 	if (local->net_type == ADHOC) {
 		writeb(0, &ptx->mac.frame_ctl_2);
 		memcpy_toio(ptx->mac.addr_1, ((struct ethhdr *)data)->h_dest,
-			    2 * ADDRLEN);
+			    ADDRLEN);
+		memcpy_toio(ptx->mac.addr_2, ((struct ethhdr *)data)->h_source,
+			    ADDRLEN);
 		memcpy_toio(ptx->mac.addr_3, local->bss_id, ADDRLEN);
 	} else { /* infrastructure */
 
-- 
2.30.2

