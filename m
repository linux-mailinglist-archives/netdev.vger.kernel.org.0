Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39304566FB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 01:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhKSAtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 19:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhKSAty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 19:49:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF0BC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 16:46:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n8so6798079plf.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 16:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZT1iG7+0+T8P3rfUSOYrrKI2G5W7nv68HnCCWdsEXCw=;
        b=HobjTeddfRRQcGJk+XkhzsQSfS58o+IU5voWeA3xC5zvznT5suEw9/WjTWzrrTkIlK
         HISMB2VIJNAz6HIoMUjGQImgyb1ywoBmRMWbkfi/PzgH2962mnDehKbUdlTCwSX/gqWz
         /84oh2aY9PIRzfgHNPP0/m3wRDtCJOmltGs14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZT1iG7+0+T8P3rfUSOYrrKI2G5W7nv68HnCCWdsEXCw=;
        b=LKZUzVPCeHCP8jX2FZi0G0GilAWxZnYjzYVom6ZU6oFNLo11jROaCoMNpy3rLO5hSX
         3zHUrqDKE1vajK9XGz1KVVOAHm9MmqLlIfKfrrbnJAoAM7WivGeuiNYA8B2zWtYoYO0H
         34l6/SnRNFQZOIijFBo8celRy5rBeS7+58HOEvF5cHLskUOi4ifrrAhKB2+Su5sK6rCg
         3EogQVwXLxI3WAKd2nTCrBtnbBMevm+lMTImTdXTvGVsfoEp3fPD+IFg5A8W1Ahgh9SG
         K35wRkFFCEY1pxbeCvBdOIrtAsJq2WwxoJlq+cod0/zq0feZhZ1t5dF0lZJxpDGQyMus
         BAcQ==
X-Gm-Message-State: AOAM533Lg5Dsx3JYI3BV7C/R4ioEwswIyINSPCu3nXBb/G8dBwzW3aX8
        DYjJVdy2ErzZaohWcD6UAECi2Q==
X-Google-Smtp-Source: ABdhPJyv639lg1pLRyYgeRdj3wF+Hn0NzW8M+lZTk58Npccq7L+pczv//omx8Da7ngXlDyZTotZpow==
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr135653pjb.173.1637282813204;
        Thu, 18 Nov 2021 16:46:53 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id mg12sm9236477pjb.10.2021.11.18.16.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 16:46:52 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jouni Malinen <j@w1.fi>
Cc:     Kees Cook <keescook@chromium.org>,
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
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] intersil: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 16:46:46 -0800
Message-Id: <20211119004646.2347920-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2635; h=from:subject; bh=YsQ+ZCDrVqrDtxvnMcMU6Cxw83EB3GFNn/tVgcCBKYc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlvP2ybmT5SP1sgJUGnCcAz8QQT3eUQgvyBjXCASQ cKJDqb+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZbz9gAKCRCJcvTf3G3AJiBYEA CwW65xXbKOStSluO7TqWoGVpcEZWUZB/l3IgGB5mD2EiwmapB2/xSO9Y8MLErgpFQjbZ5Il67td3yt 3/ysqTqflgTgYkfcAEOhVCglDluzqNBFuNTx+5f44BKcGtlgktJp8d/DyGtApELGq0sP9rDAPG+dps wGND8d0PHG3kyUzixHIuEM/pWrD5dstrsGxwEpPtg0fuv/Vwas+LeVzmsrNfZRiDQ7W3URhnfstPFC qHpIp8ES7JqETe8lj6tagAjdUfZqbX4Joni/ckCjGWBdq9sKxGK7silkOJXoQxFrDxzqCEAUVy8clU ei+E3A+O+B6PUWE4/X9e4htX7WxzhYEjvs5OMLT+I3PMv94bRRmZYyshHBqZRQLhtMvT3sWlhpuJ46 QZ/ywFVc5Tdz2alOZG4H+yhghMDPPX+71+OYQJX82mHrq++w6l23C6YfzrOPHt9gQlefpja4NPfCkO YKrUJesfbyjnvlt8pT2iiGXC7SUK1Sl9+iOCOsHVID94RDP6F09vwCCK47Evr8zfXNz2sYyLuYBdVF aWhg6VsBNrD22ETGVp2Tn6TrfWlWuByuH6vLQ7z2E2vjjDLZPixgPuXvlyrq5PsbmSUQlIfMq/c9lL yP84cPQ2j0tLWQ2TbxmGeLlr8dQtS/M2YHWjEWpTekpU+spz+pG4Xbzxl/fQ==
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v1->v2: rename "frame" to "header"
---
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |  5 +++--
 drivers/net/wireless/intersil/hostap/hostap_wlan.h | 14 ++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index e459e7192ae9..b74f4cb5d6d3 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -1815,8 +1815,9 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	memset(&txdesc, 0, sizeof(txdesc));
 
 	/* skb->data starts with txdesc->frame_control */
-	hdr_len = 24;
-	skb_copy_from_linear_data(skb, &txdesc.frame_control, hdr_len);
+	hdr_len = sizeof(txdesc.header);
+	BUILD_BUG_ON(hdr_len != 24);
+	skb_copy_from_linear_data(skb, &txdesc.header, hdr_len);
 	if (ieee80211_is_data(txdesc.frame_control) &&
 	    ieee80211_has_a4(txdesc.frame_control) &&
 	    skb->len >= 30) {
diff --git a/drivers/net/wireless/intersil/hostap/hostap_wlan.h b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
index dd2603d9b5d3..c25cd21d18bd 100644
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
+	struct_group(header,
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

