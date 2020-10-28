Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E509129D68D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgJ1WP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731371AbgJ1WP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:15:56 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5F3C0613CF;
        Wed, 28 Oct 2020 15:15:56 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id v18so1102102ilg.1;
        Wed, 28 Oct 2020 15:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=donn2UFyzsp8o09AnMw1yDwf0O8qrUs8C67gnMkzFZo=;
        b=ELUyTpRX5cW/picKo2/7a2EtmOuSOwFPG8ebEecIw1uNEDer6Oxk3kZt1WqqVa07bD
         0ImQsjHIsBh4abYwpQ3sdH8pmeSDhxRcoT86o6RsEK/RKCtmW2+MUZxuz1XKfOI5cj7d
         gi8LKGDCJZ+xoa1z/oSGhewmc2tbmTyiIC1X6BhG2me+L6I9CIU3rCa3LkfgnluunbXG
         UsXOfM0sffB53/vLXwsNnsRvFvptP5KcX79onFiHyrsguWqwDnopPja3IASi4vr2FFiN
         XgvdDLy0KrunaDCd765qMM1kJZ/GdJELNz+5Mlpi2wBwA4iV2Yoxparl8sEnYZbsVgM1
         aTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=donn2UFyzsp8o09AnMw1yDwf0O8qrUs8C67gnMkzFZo=;
        b=MEjfnOJwJIuJEgWvCVHIXl1NNDpMckuA/qz+Kg2bOskXDlFbtgDIJ6kF6b1/rOOhw4
         mPejN1kWdwj0bORGl+/Wch/mDY0tI63bWogHhPRqt9JIWqoFAHs3k4Iw/EI3mRH13pZm
         ECHR3uAPZsnwfgubg2Wh+y8ZD1TJvS61ii6YEyBZ3idOGNDecSXP8DOQi6L84hZ5X32Q
         WUF/UK53/rIjuBHjrC4XsK/x8/WHGEF5JwlQ04lneVorgmJaxYwN4HKx1BLl7e1tRBvH
         1hhvtsTmhs7OtIFaO4QmhSmnkXTWQ4q1XrIfEhi1H1qgcnkYpDfkMESra1GYZ3AsfJqD
         4YFw==
X-Gm-Message-State: AOAM533Xmaj8GsFGT4SLFss2qn1X3SYSIuj15696Vik5XizQpYJ8pP0R
        i0V33Bp4SXBHT86oDmb+Ute8FwP4BlM=
X-Google-Smtp-Source: ABdhPJyr23yVrHvfodwKoqy5O6DIyu3UdTD+a8qCeNf+c00gUGG4djPtxJM9CVqvrQUAnVo9izofbA==
X-Received: by 2002:a63:4e09:: with SMTP id c9mr705917pgb.128.1603910606371;
        Wed, 28 Oct 2020 11:43:26 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id y27sm309785pfr.122.2020.10.28.11.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:43:25 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3 3/4] net: hdlc_fr: Improve the initial checks when we receive an skb
Date:   Wed, 28 Oct 2020 11:43:09 -0700
Message-Id: <20201028184310.7017-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028184310.7017-1-xie.he.0141@gmail.com>
References: <20201028184310.7017-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
Change the skb->len check from "<= 4" to "< 4".
At first we only need to ensure a 4-byte header is present. We indeed
normally need the 5th byte, too, but it'd be more logical and cleaner
to check its existence when we actually need it.

2.
Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
the second address byte is the final address byte. We only support the
case where the address length is 2 bytes.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index ac65f5c435ef..3639c2bfb141 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -882,7 +882,7 @@ static int fr_rx(struct sk_buff *skb)
 	struct pvc_device *pvc;
 	struct net_device *dev;
 
-	if (skb->len <= 4 || fh->ea1 || data[2] != FR_UI)
+	if (skb->len < 4 || fh->ea1 || !fh->ea2 || data[2] != FR_UI)
 		goto rx_error;
 
 	dlci = q922_to_dlci(skb->data);
-- 
2.25.1

