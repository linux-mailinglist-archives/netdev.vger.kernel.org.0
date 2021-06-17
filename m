Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D103AAA15
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFQE3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 00:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhFQE3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:29:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E7FC061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:27:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h12so3978142pfe.2
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zuAYjQFtuIQCmO1rMjR+p21Q0Trj1l5ASgWxbkTK9wA=;
        b=Uv2fCei424Ypp83aUrHk1FNQtzrzzxcWjmyFu4H68+GAxcC1lRAOT9+abTyzD1hADw
         NnfALb++pBhrvBW3H4jOX8zOzTkl9Yxam50FmCouTDs6gjvDglX4qj2JdER3MQ55UScC
         hYzydqWeqWBFbhr0clBEm5KZTNf/PvyhIp1aY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zuAYjQFtuIQCmO1rMjR+p21Q0Trj1l5ASgWxbkTK9wA=;
        b=dTppTy7MWlFhJej8HLoownI8izh9EdUfDLPq9O+KRyMLRNXEPidS4x38/nK/r1o3Jm
         kyDau4WlIOP70XGJQ+4UnfatdCjnIxRoxkXgxmTIiBOIRnudHNszXCqeDpYRvzph6A2F
         dQfAGwTzfEUSXhRwavBZxkuosJ/WouaySBLjLa8F5qkpIWEoLiNYD0oEp23lTEDJt/Ee
         lAg01cPEB8APz+D2u5JvnhJZHtOKZJFaq2AiWCvVmzHGzSuKTXoYVYY/01HScur33UN2
         9THJlTYr2ddzWiW/LWwaIIpooPxp7v7KSAGxWH+pAEHgpliJh9XCIlMJuD5mPOihSgtl
         v88Q==
X-Gm-Message-State: AOAM530fSvhlSsh1IMgzJ+POlDAo99pu9nR999QFCz1t6xWUjiita8qU
        UdUKUMbXuwrIKdE1hY5KYdIRBQ==
X-Google-Smtp-Source: ABdhPJzYMo1gT6vK0OEtP2ovZPyiyZaomQF4VL+8aJfBArMS2v9RGhR8Iqqd8U5ML6xgegxmo2943w==
X-Received: by 2002:a63:3d82:: with SMTP id k124mr3049823pga.401.1623904031759;
        Wed, 16 Jun 2021 21:27:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p6sm4473754pjh.24.2021.06.16.21.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 21:27:11 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] mac80211: Recast pointer for trailing memcpy()
Date:   Wed, 16 Jun 2021 21:27:09 -0700
Message-Id: <20210617042709.2170111-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=a59972a95d22e6cba17e8ca1ef339d3a3ef1b4e5; i=P4B4b65qJuhqVi5i2irgu0AhoblNfL65fECGIen2RpA=; m=ye9VNM2/KkSGCD7iU041Afv+zNGB2BR/2/Lf1/HGmmk=; p=jmhDm1u21oAA6abJCLcWjlq9egIRuBdVv23WaQ1b954=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKzxwACgkQiXL039xtwCZKsQ/+KRk qClgQaevJdpMV/HrC1/U+leuhMDzRHQ+71fiVOPofuqUOQVTtWE+ofVrBg5T6/rY7R3yAsr+M6jIl NJ5qwODjOmqe2eIHOtMdAd4junJjRi6O+8K7pH2Y8x7WLob4RubcXcogaPRTWlrcYGQiWAD14hyv2 mOkbE6mK0UWHeNnACpdecukYVYk5r3MTX0P/OlUO/FwEfnEhrM+DaXP/HWV9EbIQNqbEwsDmcTKY8 VtIggri22AUecFKn4TZKZJ7BIr1R7gMabDODg5vQRdnavOQ2LTaYprz+LO34lEaAsxfPU2onkBVet QIQBQS0Ti8XB+PcQuFsuIdTbu/qxP0yTqvwDq+C1bcSDkzsRMkDu/jGJfbA79rAt16c380/hh9eqP T78RVtzSJBOX+FpOA+/cQR5oZPQzKJpOjAIbdfbyazFb/+qaVakoDq6X0lmtF4MQgo0hrbhJg83Nc nQ4xKK6c6WN1Sno8eGF/JZl5GNKNNdolU2hEmyBJc46P/1CWCOqkhxON0XWPJWJVtqvea1i+WUYDn 7e9lU3+RyC8m/7yaBWVHyolrF+zityHQGiJKD0C6HZmACMw9nA/v5du3fLhtjD68HH8PhAdM8IEjt caIQX7Cm+K9rpWZB/2N/l5dXOIMPjx8g9R8DJtnr2znfH5CD4wW1DFjnlLen/Cco=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring array fields.

Give memcpy() a specific source pointer type so it can correctly
calculate the bounds of the copy.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac80211/rx.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index af0ef456eb0f..cb141bb788a8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -559,6 +559,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	if (status->encoding == RX_ENC_HE &&
 	    status->flag & RX_FLAG_RADIOTAP_HE) {
+		struct ieee80211_radiotap_he *he_ptr;
+
 #define HE_PREP(f, val)	le16_encode_bits(val, IEEE80211_RADIOTAP_HE_##f)
 
 		if (status->enc_flags & RX_ENC_FLAG_STBC_MASK) {
@@ -626,18 +628,22 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
-		memcpy(pos, &he, sizeof(he));
-		pos += sizeof(he);
+		he_ptr = (void *)pos;
+		memcpy(he_ptr, &he, sizeof(he));
+		pos += sizeof(*he_ptr);
 	}
 
 	if (status->encoding == RX_ENC_HE &&
 	    status->flag & RX_FLAG_RADIOTAP_HE_MU) {
+		struct ieee80211_radiotap_he_mu *he_mu_ptr;
+
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE_MU);
-		memcpy(pos, &he_mu, sizeof(he_mu));
-		pos += sizeof(he_mu);
+		he_mu_ptr = (void *)pos;
+		memcpy(he_mu_ptr, &he_mu, sizeof(he_mu));
+		pos += sizeof(*he_mu_ptr);
 	}
 
 	if (status->flag & RX_FLAG_NO_PSDU) {
@@ -647,12 +653,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
+		struct ieee80211_radiotap_lsig *lsig_ptr;
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_LSIG);
-		memcpy(pos, &lsig, sizeof(lsig));
-		pos += sizeof(lsig);
+		lsig_ptr = (void *)pos;
+		memcpy(lsig_ptr, &lsig, sizeof(lsig));
+		pos += sizeof(*lsig_ptr);
 	}
 
 	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
-- 
2.25.1

