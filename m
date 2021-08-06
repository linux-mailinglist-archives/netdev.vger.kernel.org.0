Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEF03E3170
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242203AbhHFVx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbhHFVxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 17:53:25 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B69EC061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 14:53:09 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a20so8935741plm.0
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 14:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fl84p+xysP6AB2l/hihiICphduq4Sq1Mlhhi22j77F0=;
        b=fLUUzWCdWgjWzaVQtWF39lVb3u4CpbC62haKkT9QefCrNahRNB/hNVyvsoNxIwYR6A
         y4VcIYg/Y0Pel44OEtKyqDU+CZ++YCLqYxDqGN5yYwd90cA3Uizjes5NXVUCbx797GmS
         CPs9YpONuuf17+AcOhLbkKxAaZsPVnsX3sYsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fl84p+xysP6AB2l/hihiICphduq4Sq1Mlhhi22j77F0=;
        b=ZwxiEB58W+kGQiBjG6dPmKoxBX96LWdMGH6ooBJhmYqawQWI6oiKXbGEckLkC0fbd6
         zvJoris03cvQSTh5LGpTPzL+ufE0AwjdS3+OLpbTOdBOVa8FoR930y5rBTPji7af+cV4
         vugWr42/FDhPordV3WuV4vo48uFo9Y9PzP2sQ2mAujmE7QeK3ykL3n3KXd8y+qsedfAS
         snEwk46jyAjPtNgTbw6zX/SfyDixGdmRSCCfAASMK6YVhjLrq8NFWXDCS2ovjaDbtlzM
         PNauRTVj1o5E6WsS4MP04BtCNMZRwvOJ2fHjMKgd5a5ALiBobRhrG6NJJFkpBNqInvc2
         J+wA==
X-Gm-Message-State: AOAM533YoxS4F1l+kXj1+bCaVQ2BM+HN6WiietyYfkqpOTu3X+djcKbu
        fDNWXGO2cwEVZB2Bp6jQ9OwANw==
X-Google-Smtp-Source: ABdhPJwHq7KmH6xi7My6g9FWVyFXC33n4QjGWSGUKLW13137lkqBzkcgKwjRr+vS4ysHDuw+bkP5Iw==
X-Received: by 2002:a63:5153:: with SMTP id r19mr1218197pgl.56.1628286788954;
        Fri, 06 Aug 2021 14:53:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x81sm11699524pfc.22.2021.08.06.14.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:53:08 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] mac80211: Use flex-array for radiotap header bitmap
Date:   Fri,  6 Aug 2021 14:53:05 -0700
Message-Id: <20210806215305.2875621-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3027; h=from:subject; bh=nSxGvyUo7OEzP3mLXXxASonhC3Vjw4BHa0bqzCW6SeM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhDa9A9RTUHqidNfMpH0wWsYz9M+GpIQDZS5YZ+oPS wd3imheJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQ2vQAAKCRCJcvTf3G3AJi4MD/ wPb1AljxGZOdesdD+OlcFXZD+MpzQa76k/9wnbr0ajzpHapsWmZGOWVxwbtp1Sw3MOFp//BSGIgomr dLRE9PSoxQOt6eo1+dJ5M3CXUAAgAFvEh3OZx/3GHraMErZx5+Qq+dfHSjMM67Onlv6lK/QTovrCO7 zJXLO2yzeIkypN1+b/L6HNguWflmaXh1FS88eVN7BcBQ1zSbmxFEN7icWsNFFRZWO411yRbA8hSJfm GxZ7wvVYCUlY9jMriW7PlOVKTup09VU122TVtnHEwn+Dv3XTFAo7EtbeP4mspPqiKvIGDq9mTxzBfJ bkQaEHI5BAvWC8Z4vFi0IVlhXwK8hjitA1KLB1XKgoXVoCjHyJ/WGmoQ+qBPbHWLtaq4UtttJdtKYx 6vG9dRhJO/SGp/IbRHPIaKHe58dxbSAL+LhtonFjSgImxhSSVYwmFtVR49QQq+7jotNYqQe6BRWewt EKBki3K18PJbo3NstEuH5hqtdAB2zNY7Su/VgWEcbL2ey7dTXm3x1IETDH1pXHTJ9gGFDZWV37QoO9 gGWk++JijMalclpEwb+WedkrdYLEycJSPmVJA6ojueQJiVrLpQUUgGsmva89C5tkmyk/AS517ORWqT xVyXwn/SiyKcbU3U4JZMzluqq/uAou5KL22dlgyTwdTFpx2mxmwHpAXrctdQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

The it_present member of struct ieee80211_radiotap_header is treated as a
flexible array (multiple u32s can be conditionally present). In order for
memcpy() to reason (or really, not reason) about the size of operations
against this struct, use of bytes beyond it_present need to be treated
as part of the flexible array. Add a trailing flexible array and
initialize its initial index via pointer arithmetic.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/ieee80211_radiotap.h | 4 ++++
 net/mac80211/rx.c                | 7 ++++++-
 net/wireless/radiotap.c          | 5 ++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c0854933e24f..6b7274edb3c6 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -43,6 +43,10 @@ struct ieee80211_radiotap_header {
 	 * @it_present: (first) present word
 	 */
 	__le32 it_present;
+	/**
+	 * @it_optional: all remaining presence bitmaps
+	 */
+	__le32 it_optional[];
 } __packed;
 
 /* version is always 0 */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3eb7b03b23c6..33c56eab07fc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -359,7 +359,12 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	put_unaligned_le32(it_present_val, it_present);
 
-	pos = (void *)(it_present + 1);
+	/* This references through an offset into it_optional[] rather
+	 * than via it_present otherwise later uses of pos will cause
+	 * the compiler to think we have walked past the end of the
+	 * struct member.
+	 */
+	pos = (void *)&rthdr->it_optional[it_present - rthdr->it_optional];
 
 	/* the order of the following fields is important */
 
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 8099c9564a59..ae2e1a896461 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -115,10 +115,9 @@ int ieee80211_radiotap_iterator_init(
 	iterator->_max_length = get_unaligned_le16(&radiotap_header->it_len);
 	iterator->_arg_index = 0;
 	iterator->_bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
-	iterator->_arg = (uint8_t *)radiotap_header + sizeof(*radiotap_header);
+	iterator->_arg = (uint8_t *)radiotap_header->it_optional;
 	iterator->_reset_on_ext = 0;
-	iterator->_next_bitmap = &radiotap_header->it_present;
-	iterator->_next_bitmap++;
+	iterator->_next_bitmap = radiotap_header->it_optional;
 	iterator->_vns = vns;
 	iterator->current_namespace = &radiotap_ns;
 	iterator->is_radiotap_ns = 1;
-- 
2.30.2

