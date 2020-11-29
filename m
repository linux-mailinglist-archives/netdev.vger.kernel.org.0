Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443682C78A0
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 11:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgK2KYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 05:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgK2KYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 05:24:52 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CD5C0613D3
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 02:24:11 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id a16so15027762ejj.5
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 02:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=newoldbits-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XfQxuv+mk4On68Z9GyUaCS9f7676/xjDmg+HojCRC94=;
        b=JYJ561j/wsTKdlH9aN2rEexJtlr/7xBM3z9jiIZ3tCP8MaeKKESMUTI02S62iUqqoV
         O5dPlx+lYfLpNt8Ia5FoT/gpswGc9qnakRS9UfVaYcLr1pJw7q+0i7VThiyMkFcRAIWZ
         am6Xk+sj7n3xOTgrFG/BrVqG5m60YFPIeORC7B0lYlBzXVv79pTmj2qeit0AUWuZc2K5
         Df7BRQnIsC9z8Xn5I4YqWphGPS2qfHFhcWAjOvDe22fxBBSGiLarNpY7X9Bf5kiq2q2w
         95GBlUd/VS3SGnIk1d3esSjgkLMbXJb9jPIxrVjfEnjEIkCC176PfM73Oqh0Jx1nr2mx
         CBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XfQxuv+mk4On68Z9GyUaCS9f7676/xjDmg+HojCRC94=;
        b=WLZx/H7Hai7gjF0umrJqPHRWlJ2N6+O5Re36o384t1sm/yzT+dffStsvdgmW2ctZ/z
         w0CGpEUojlaR20u1k+usvHtuvpAo7d7bYxjik73UixFSSKQuiwqpN273HsnxpGTKFgNo
         U/0LT5Is3ZpRuA/4GWoBlXmb3RRhNglcF2uVICmNouHUs+eQ/JPFTEoL4UvDIRe46R6/
         4IL0hQQmVXabFWfd28P4yDJUfZ6TXGpCyCaiQCVUpg22OOf2/KxGPQgxeWTkcFOEhThO
         AD+N6djockRpTtGyMuddZ0sC+b2kSDRPGj8y9iaTrIX9U6JvrBSGYBHdk1SYD1TD9QTd
         kTkQ==
X-Gm-Message-State: AOAM5306AnZrWqNkXPvEDXicp3HRXBY8pkJSuwwQzr9BeZds+BiYuBEz
        TY1VBq1c0GCE4i1Gk2A8a9FgdfUjcpvjKA==
X-Google-Smtp-Source: ABdhPJxcAj1VGX54j4kb5BgsuOpIjXkmjgHmMqfQUCcGK+jeqElfLc9jg4KMfV/6Q/BVjh5Zu+VqXw==
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr15932735ejc.13.1606645450218;
        Sun, 29 Nov 2020 02:24:10 -0800 (PST)
Received: from nuc1.lan (208.2-240-81.adsl-dyn.isp.belgacom.be. [81.240.2.208])
        by smtp.gmail.com with ESMTPSA id gq19sm4605244ejb.10.2020.11.29.02.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 02:24:09 -0800 (PST)
From:   Jean Pihet <jean.pihet@newoldbits.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>,
        Jean Pihet <jean.pihet@newoldbits.com>
Subject: [PATCH 1/2] net: dsa: ksz: pad frame to 64 bytes for transmission
Date:   Sun, 29 Nov 2020 11:23:59 +0100
Message-Id: <20201129102400.157786-1-jean.pihet@newoldbits.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ethernet controllers (e.g. TI CPSW) pad the frames to a minimum
of 64 bytes before the FCS is appended. This causes an issue with the
KSZ tail tag which could not be the last byte before the FCS.
Solve this by padding the frame to 64 bytes minus the tail tag size,
before the tail tag is added and the frame is passed for transmission.

Signed-off-by: Jean Pihet <jean.pihet@newoldbits.com>
---
 net/dsa/tag_ksz.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0a5aa982c60d..0074702dcbbc 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -19,8 +19,13 @@ static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
 {
 	struct sk_buff *nskb;
 	int padlen;
+	const int min_len = ETH_ZLEN + ETH_FCS_LEN;
 
-	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
+	/*
+	 * Pad to the minimum ethernet frame size, minus the size of the
+	 * tail tag which will be appended at the very end, before the FCS.
+	 */
+	padlen = (skb->len >= min_len) ? 0 : min_len - skb->len - len;
 
 	if (skb_tailroom(skb) >= padlen + len) {
 		/* Let dsa_slave_xmit() free skb */
-- 
2.26.2

