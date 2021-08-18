Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D03EFB6F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbhHRGNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbhHRGL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:11:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355E0C0698D7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id n18so1138939pgm.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vtwcSVdVTFoZmc04BzBkMsZrmW9WU0SQRrViE0dMhIM=;
        b=Z1gB5H+T4fVxQ9g7C046IHH7yRTsOIIkoqVD70Mvn7Km3k9/+QRqPilFblkj1uhpqQ
         HJP2ZYOXSNYzlbKXjxf/6OiulCTO42svSQHjQHTNwmpWThK5Q3l30wWPG5s2IE7kBDhy
         /v6uHno+sopqjj1/YM8w60Afemeq49IhOrlYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtwcSVdVTFoZmc04BzBkMsZrmW9WU0SQRrViE0dMhIM=;
        b=TgDLBKt08Bglwg35p3HG+DbCAewfgdwCegCG/cJFwOorwCzsFuQW6p+HEwTS+j4w6Y
         K0GYQvIsNiejcVc6rHNgLBnYnLg8udFiiBT//TQsrxeG6Ga2OKVov9E6iJ+Vyxu2nCq1
         C0cXhzGEsjj6mf6mEfubHwSiGC+2a405kl+aYieB7njlprtxZVDkm/2+Vz2nqOjBbNrg
         VY3ZzLco64a/ndUbBw3taicwl546n9UiLrkNxvatLlST245GiCeqiXji04kwzHBnAmMB
         hra+iwHMHmB7G/1aY3tALfOly+VRb55Tzoox1XFphOe+tn9liCqEMfS5TQ2pZNA8oA9e
         fvyQ==
X-Gm-Message-State: AOAM531o8skS9K508rE5Ij2vf1xu6zEYVXkQ9LJ1EafSL5D6L3iQNnDA
        2Uejapbri7a/PQuDdMlMsnUWIw==
X-Google-Smtp-Source: ABdhPJx3FtQFX8RskWrausYNddXgw3mS8wwHMQa70n9fNMHoQAnpneqhnt2vKRb+O5Y6R98gISV33w==
X-Received: by 2002:a05:6a00:1ad3:b029:3e0:c106:2dea with SMTP id f19-20020a056a001ad3b02903e0c1062deamr7475031pfv.8.1629266764822;
        Tue, 17 Aug 2021 23:06:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n30sm1015079pfv.87.2021.08.17.23.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, dccp@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 42/63] net: dccp: Use memset_startat() for TP zeroing
Date:   Tue, 17 Aug 2021 23:05:12 -0700
Message-Id: <20210818060533.3569517-43-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1093; h=from:subject; bh=oy6iBSCr9kyZzvyYymYY57kzNqoaMnV5JLYgBAUoJm0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMn1SkgQ8BjGsCq2GdMgGzLdaT1ETjcggbTd7md ILaTjp+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJwAKCRCJcvTf3G3AJuyaD/ 4sQC9WJISdx2sivmaYm8XFbYloHqwWeRooJB9Xn5LQlXYeixqdc3xt1r2gvg66w3xCH+tVVrX9xwZ8 j4rOz0Jnr4M4+XoPft5UNGFK5WHVSQxM1uFZ6yYUAzKW8y+4UNCClX7NR8hlCV6VzksxhefmAPPtmS wOq7tQbgdvsAdVIszxfGUQEQ/lsjPMC/whKeduyJAGzs1zzly6D2vtwy0ZqcaAksRvJiZQJ40aB4zR mW+la1HOBIsMfVxsqbEcAWaJPSQAIOhZNkyVHQp6hsVB1RDZN3i3KFqmpmAkeVu2vlJF1EKcdgGaEn jyCwLPfogMCZn9L/uBRkh+ra5YX7NEEWpVHUFB3qfY8BR7bV/cmBNHN9o9xE2BB2e5L9mVlsgzLs5N +ZgL0eXIWi7FZf8+kVbThu2pP/RPDsS+237VGqD842n6pSszz+Ef+1o6GC8dcy1e/RD0ca/bTNa5N4 IxUAbV/MpfsG0SAYjf5hGJPBD5JnPZKJypzRlhJyPq16auQMT6oq3Br8H9Bqrol1u3NMiDR5o+pwtf tVZXMStjqtGmw0i8+SVL+bnPCzcw4UxGNNF0OxZi7Xh5YdVPsWcdXNWPjX4cWWnd8R6sNMzlOOLjqy +W6jas5qQpj5s60ah2DQNcBu2uwwUtZ3ce3UAMyWXl/MPjF/Wzb6mFfp/Anw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: dccp@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/dccp/trace.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dccp/trace.h b/net/dccp/trace.h
index 5062421beee9..5a43b3508c7f 100644
--- a/net/dccp/trace.h
+++ b/net/dccp/trace.h
@@ -60,9 +60,7 @@ TRACE_EVENT(dccp_probe,
 			__entry->tx_t_ipi = hc->tx_t_ipi;
 		} else {
 			__entry->tx_s = 0;
-			memset(&__entry->tx_rtt, 0, (void *)&__entry->tx_t_ipi -
-			       (void *)&__entry->tx_rtt +
-			       sizeof(__entry->tx_t_ipi));
+			memset_startat(__entry, 0, tx_rtt);
 		}
 	),
 
-- 
2.30.2

