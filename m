Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D8D4562AC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhKRSpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhKRSpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:45:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AABCC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gt5so5856404pjb.1
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLdAi6o6FBcZW9AN3DbgERTMdYP9HSq61k/WVHULtZ4=;
        b=HjqZmQiiYsr/8BUOTbI928lO46ic6kIm32IjDf6Bc1wuayWIoN2rbhlHN829hZmiJ/
         +VUewKoaSojWWeZDtFmzNp07Rj6mUs6Vjs+m23WQUVUJtT3pJbVL04coaRAzkaH7Uo1H
         AAdOhVAyFkby/VFSyceW5Mr2QWjoNxfYrkvz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLdAi6o6FBcZW9AN3DbgERTMdYP9HSq61k/WVHULtZ4=;
        b=X9xMfsv+6ATt5O2VQwsG07ehCEqPsyjm0zWE/VYeejQi5k01g9kmuXNVcRGDeXB+7B
         a8e7UFeyc7y7fgJioKXOPRZ/G+x2REozhnnemZrTmUg7Sek/t0NnFMglyRKjImdUDqt2
         +cAOgCTFMtqRd8NkLR/7ky2fWgR8fkOaNc7ixbuVpd+OK4sFER1sUlXEjJnLh3ZPuWEV
         y5SqF/SzRrz4LZLRIKvp4/Uh4XMyb29tT0IcsU/JD9wAeJi2cThe6E7qbArYwQ4+6Rjj
         IIDPq06X73MvSYO291DG/vJnZtaeFSb1Cdx+zyP6ck42oKXmzRDDXVJ5CPjmn/thdtmq
         LfNg==
X-Gm-Message-State: AOAM532ZMVmDd5O+Czdw6GzU8XceD+62ZKvDExaQyM5VFqj60CcXvrqE
        QMu/+7D6PRCQT6X2fPqeISN5Xg==
X-Google-Smtp-Source: ABdhPJxvM5tp/bqVNdujo6JpHnhy1nqPfO+rTGMecu/gtHNCVNQTvIfUyjDlEFl+GDuJL3r/69bLcw==
X-Received: by 2002:a17:902:b084:b0:141:f5f8:1c5a with SMTP id p4-20020a170902b08400b00141f5f81c5amr69242025plr.40.1637260920804;
        Thu, 18 Nov 2021 10:42:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d12sm294720pgf.19.2021.11.18.10.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:42:00 -0800 (PST)
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
Subject: [PATCH] intersil: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:41:58 -0800
Message-Id: <20211118184158.1284180-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2591; h=from:subject; bh=miSF2gf2abPEVRMOENvim46Cpo5/erdvCVGiWTz8mCE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp5271Q5EEUtYsTlxk8CWtzRcew2cnKosVYlA18w zQyXh5+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZaedgAKCRCJcvTf3G3AJtXTD/ 9KDpSczNe/aQ9RlJXgLXq8c+5TRiFs53bgu6Tj77JxLcIF5XLJ8pj4G0JkijTKSp7JhquxsIxDmxg/ JqCcqOfwNLU1JBOPLrRh3pudVu6GD8NWaR4dswiUQM0jIYZf5zkQiRb+0EoLb/p2Sq3NfhatQpmZKy Ghjdl4h+w+NRG9CIfecorIwMzhJpVuTzwjhLxw9Jzt2XKDlHf2gsIaKAmD3jRtvianZzIVp1jnj5m7 lQhhokkUVw+dVXnmUF9GfR3XyiG36vUafZluUDnkqGH14sLR2Y5bf6V3/QZoHSLReanEfVH/D+ccr/ ruH7U210HM7lJGwwYnPFaCZI63U7CDPcub5RFLPk++PUB5zCM/+8cu3bKsOZmMGqZiAWJ1dZlzs1/L 8AJdlBe7uhaPssgCweyWFBphhJIoPR95dZL2fz6h8MM34xL0ADn2KMO9jcx1xf77Madizf2X0fnnVc mYDOm3ksMBPd8Hb6sH+BOjkrvY942xUfHNfkyYNgKqBS9di01+vlXSWBHxi6ZVEdxlMsiW9tD4KoZ7 7dOtU3FAypadGBaAdl5k5X9sdT4I+KRQB14l0357zQMo4G4Pz+7lLAqTA34Lg676UZaXrdJmZrtvLU gccTcoRe+K2Uv6tfp0w9wEoNdWZH5jKHHGvl9epcwc7qB72D4pp98OQcgiMg==
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
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |  5 +++--
 drivers/net/wireless/intersil/hostap/hostap_wlan.h | 14 ++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index e459e7192ae9..8b7374023659 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -1815,8 +1815,9 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
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

