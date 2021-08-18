Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0063EFC0F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhHRGSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbhHRGQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:16:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70470C035411
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:19 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y190so1079301pfg.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3Iemq6IfMq8jyV2u9omGTepmgQD8wDuqLYjs8itz1Y=;
        b=TxRwedVVvF+R1Lfnd1UxRNt4KDV9rNjmqnlR6ek55RYna0VF5FhXLYO+lYfDjL3lub
         nJUaKphm8EO0FLwlYusMyQ7Zdz/KysFN+HKlkrQtKiJpAlXfQa/iisDbdKvMF/6dslTq
         ZIzUo34Moo/ZceEV9eGHlI6bz1A5KD4Wfh1Nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3Iemq6IfMq8jyV2u9omGTepmgQD8wDuqLYjs8itz1Y=;
        b=VrF9kFlldV6PyA9TsS0FdpsKZeMmSsaWnz1rxqfYHVbGzBngKWdEd/+B9zbvIvLsU9
         U46gggJevdB07rR8h4pEQQxLQEOfH1MuJiHdo82PMajANNrXI5x57bPTeRl8vKHJrdTo
         63zLWXxdz/fRroLNAhCRRPHnOVLgRviXvf7d6MkmpmSQsiPIHDtZpgHylBF/96XLCyiN
         u93WTHZdHzIG60XL2/95WdqOiGmW3XV0lKPK9AbDLdwxwa067ut+NDidJL2RNwep/A5S
         EVCPASfCkju+649OWnxc5V/wLzwx5lWIlOVc3ZH0yhx31yfYeV606q8aowKLIKbZoRxW
         gg6w==
X-Gm-Message-State: AOAM5333bjhIZWHD5NNxpLepM1BjITE6iqDr7rmE/BCJJMNUSpprgb/p
        YcmrsUl0NPKjkNPxGJCwuGEB7Q==
X-Google-Smtp-Source: ABdhPJzbX3ZWnssMxhh5s/pWLIyPLFLmkxT6FRbi0vBpDllDzQCsAGSzrNp4dT0eMcLnMaiF/0hcZg==
X-Received: by 2002:a63:cd02:: with SMTP id i2mr7277459pgg.116.1629267259068;
        Tue, 17 Aug 2021 23:14:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9sm4655621pfa.2.2021.08.17.23.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 15/63] intersil: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:45 -0700
Message-Id: <20210818060533.3569517-16-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3106; h=from:subject; bh=zQZGxBfl7dAgG5tBG/ZLbaDQfVLnlG18JlpAF80qB7s=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMhrEzcBPUO2fJ4Pn+xRO14SATLeMOS42x+QUKW 6CMu31qJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIQAKCRCJcvTf3G3AJjCpD/ 0bIdtbe2MXXc36t6JnE/BOu31oCVMunfUwVmUuWjcW5QZKCJKHCaWynEtZ43tRXaPeLyqe2eluQQLX mxQinp+l5Gk6QLjrZ/2gCmzu5dy3Ll0/1wKJHvFSLUCL4ll73Dl/CpGN9Gflki+/WsFSYz93ibz/z0 M39dEpmzX3sxWiz9mnlMByQXhV/tSjSUHsC/tgcT8GzKyWO3TMpyWD1XDQCrzLJtKSQi8YpAM59d9v mfq1ifJj8/Pr227Kk8ZL7KuWz86p/CiKS6R/QqrQ43x+fO1u8dB+xui76UQiHTj+vGBAUCqvW30Bfd g2qbVS2IkFYfjmpfNjvavGsEMxqM5stGW4RqB9jSuZ4tiEXwey6K9+85Nx5lTJyKlU4YCadcNdpEr3 4/oZM06OB8PnSr4lwMAjzFhI6R0fChF5uJxb5fb6pm5hRzt5+5hlgmAopQdTaxyhDK7JO8aZOWd6oV HIrlagRF1x3sVhMuP2UMukVaahRXE6seQlBvx68gpW8OolKr9O58KEWnVxisYzpFhd2vATCBNfT5be wFUq5DxkidJPPpbEzvf40Fgl8vb7r1fbY9+Tnjy4SrwOMGmE63TRwUAhpjgQSgYHKdQMk/8OplMa30 BXm38AUk8ZEnYTmCoH5mEsYfE0KahJm/YgOEspR8zcg/IvsloK8a6Dl/Fx5w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct hfa384x_tx_frame around members
frame_control, duration_id, addr1, addr2, addr3, and seq_ctrl, so they
can be referenced together. This will allow memcpy() and sizeof() to
more easily reason about sizes, improve readability, and avoid future
warnings about writing beyond the end of frame_control.

"pahole" shows no size nor member offset changes to struct
hfa384x_tx_frame. "objdump -d" shows no object code changes.

Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Allen Pais <allen.lkml@gmail.com>
Cc: Romain Perier <romain.perier@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |  5 +++--
 drivers/net/wireless/intersil/hostap/hostap_wlan.h | 14 ++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 9a19046217df..cea8a9ddc4da 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -1812,8 +1812,9 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	memset(&txdesc, 0, sizeof(txdesc));
 
 	/* skb->data starts with txdesc->frame_control */
-	hdr_len = 24;
-	skb_copy_from_linear_data(skb, &txdesc.frame_control, hdr_len);
+	hdr_len = sizeof(txdesc.frame);
+	BUILD_BUG_ON(hdr_len != 24);
+	skb_copy_from_linear_data(skb, &txdesc.frame, hdr_len);
 	if (ieee80211_is_data(txdesc.frame_control) &&
 	    ieee80211_has_a4(txdesc.frame_control) &&
 	    skb->len >= 30) {
diff --git a/drivers/net/wireless/intersil/hostap/hostap_wlan.h b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
index dd2603d9b5d3..174735a137c5 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
@@ -115,12 +115,14 @@ struct hfa384x_tx_frame {
 	__le16 tx_control; /* HFA384X_TX_CTRL_ flags */
 
 	/* 802.11 */
-	__le16 frame_control; /* parts not used */
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN]; /* filled by firmware */
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctrl; /* filled by firmware */
+	struct_group(frame,
+		__le16 frame_control; /* parts not used */
+		__le16 duration_id;
+		u8 addr1[ETH_ALEN];
+		u8 addr2[ETH_ALEN]; /* filled by firmware */
+		u8 addr3[ETH_ALEN];
+		__le16 seq_ctrl; /* filled by firmware */
+	);
 	u8 addr4[ETH_ALEN];
 	__le16 data_len;
 
-- 
2.30.2

