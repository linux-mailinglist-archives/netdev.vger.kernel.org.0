Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6FE3D8170
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhG0VSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbhG0VQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF43C06179B
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a20so118522plm.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vvNgpOkYohlzmozRH90jT3va3z9rMWChvsz40h8+RkY=;
        b=cI7pDAEV+fAYh/9IrkMcLzlca5EW1ooun6AivPtj97ng/WaVF+mQDkhXwA/1Z2+AJr
         4Nn77aehsUrpK6SIapNlZq0hcL6Ffryk3x8aHwWk5fGDWlq2H7uxwsPJ/4q0+5tNCXsZ
         hD+zPYAIV3KQDQDjzvXrg9fukVcidGdotaa4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vvNgpOkYohlzmozRH90jT3va3z9rMWChvsz40h8+RkY=;
        b=jJi1VO6MSedPchJbTLaiWWjNlxQ0r2r25znov7ZZDjVwAS9l96JGSiW2DtWdU3PWLP
         uvlqMam6xyuuD73tdZs7z+KTdTWu7ESU4UcWB3a5cKlI55+Oo+acE+UBThS/ZHB12EC/
         cOIbuePdBpRDFKZh4Avq5qv/sa04H3lQvtZvWYFbM4vyOc6AMQiKFErjlue2yWtCS1if
         JwW06kjWC1eykyphQN8G17o7qi0oHp7u8AAHhnWquXGrCpIXOvV9D+vH13N9eHNZC3S4
         lmnx/vYJ0tAGFGUOtQ2Sf5suALUxGBLgERrD7Z5FvvZ+aRoGhqI2dyELr32ja/mZar/v
         9K/g==
X-Gm-Message-State: AOAM530zUzd/G0K2kvATLjJxdFNQhxRE5wVdkw9bjLkFx0w8dg55REPp
        0vgWW4Gd/MdPJLD4eJ2NrDN3gA==
X-Google-Smtp-Source: ABdhPJzE9AoOQUL4/giBdYIFX1uIcw2uVNeNuZFEGRMkEqN+EwkPLwt/9C4Lcpy6fWzjXCsTHLO9Mg==
X-Received: by 2002:a17:90a:5201:: with SMTP id v1mr23545012pjh.46.1627420618454;
        Tue, 27 Jul 2021 14:16:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 19sm5431637pgg.36.2021.07.27.14.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:55 -0700 (PDT)
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
Subject: [PATCH 24/64] staging: wlan-ng: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:15 -0700
Message-Id: <20210727205855.411487-25-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2375; h=from:subject; bh=c/SxbSrw72JMwWGBAhjNbuucRJa6d830VHNx2pfQMmY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOF2QDCtL/erQWj7ox+a3ncXLGvlzCwDIvWXZkH qHjzBFyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhQAKCRCJcvTf3G3AJtV+D/ 0fO+YtYcaNoJFtJLfaoehtt1+wVJemFnhzXbO8zron27IVuMZAcUQZRTvfedVY+1vq9YmKpR1jLhu6 TonAYm/QSoolsRdIvr0usi+NR+eRkXR1ZnyvV5rnOc9YaBWbZRrQq3ZcX6YCjqPkK8p8WRxt9Bj0Sg q5zK3/CNl56vrOTzTCCoxMsajE9vAxySqiSXHSeiMfp2xd3+QR3kRFCFU0ZSA0xfMcnR2JvGQBggJS RkdJjwLCK+kENWJtvHtlX4elSv2P/OtT8hnnPRvud1yeMq+QpTzPeNdW7PxhWE2RwZNA2NugGVRSlX 3jR4hhDV+6JtngiZjWbObIbIUZuegWEMH0zZW7dNgjbeuJq60bTRCUm4kANVmgMnCpvv/gmJ/eOGF+ Cy3TIZB46rpL4aRD/GZgx7Z3LlwLOdMudLK7tK9BsLfb7ORVmmEeOisNmyspYO6/AqlMjaI1/ZZlV3 812R76a18N3vOrFFTOfbqpkITezkVwlqkVE+0wU0/No7R2jwKaEwkopqHCE2H8k4ufJ2CY+2fLArN9 RN/NT2xb7COyOrwRuX1S423r0L/eefO2fysMApU+RwzbiD/oDAlU7jx19jPFBWMojjzIhrQhJlkdja x1kg9JKYzfTYl3DgElyjMkkBql860vUUs21cPgyOy5TcZ8V0tBlTLOvGWnpg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct hfa384x_tx_frame around members
frame_control, duration_id, address[1-4], and sequence_control, so they
can be referenced together. This will allow memcpy() and sizeof() to
more easily reason about sizes, improve readability, and avoid future
warnings about writing beyond the end of frame_control.

"pahole" shows no size nor member offset changes to struct
hfa384x_tx_frame. "objdump -d" shows no meaningful object code changes
(i.e. only source line number induced differences.)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/wlan-ng/hfa384x.h     | 16 +++++++++-------
 drivers/staging/wlan-ng/hfa384x_usb.c |  4 +++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 88e894dd3568..87eb87e3beab 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -476,13 +476,15 @@ struct hfa384x_tx_frame {
 
 	/*-- 802.11 Header Information --*/
 
-	u16 frame_control;
-	u16 duration_id;
-	u8 address1[6];
-	u8 address2[6];
-	u8 address3[6];
-	u16 sequence_control;
-	u8 address4[6];
+	struct_group(p80211,
+		u16 frame_control;
+		u16 duration_id;
+		u8 address1[6];
+		u8 address2[6];
+		u8 address3[6];
+		u16 sequence_control;
+		u8 address4[6];
+	);
 	__le16 data_len;		/* little endian format */
 
 	/*-- 802.3 Header Information --*/
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index f2a0e16b0318..38aaae7a2d69 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2516,7 +2516,9 @@ int hfa384x_drvr_txframe(struct hfa384x *hw, struct sk_buff *skb,
 	cpu_to_le16s(&hw->txbuff.txfrm.desc.tx_control);
 
 	/* copy the header over to the txdesc */
-	memcpy(&hw->txbuff.txfrm.desc.frame_control, p80211_hdr,
+	BUILD_BUG_ON(sizeof(hw->txbuff.txfrm.desc.p80211) !=
+		     sizeof(union p80211_hdr));
+	memcpy(&hw->txbuff.txfrm.desc.p80211, p80211_hdr,
 	       sizeof(union p80211_hdr));
 
 	/* if we're using host WEP, increase size by IV+ICV */
-- 
2.30.2

