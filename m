Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58343FCD3C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhHaSxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhHaSxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 14:53:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45830C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:52:54 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s10so854399lfr.11
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgf472b2g1DolTkwcFzFHbrCtJ8S8RAubSBTuQ4ufTc=;
        b=BZvZRD26QqpnFRWqwKtezgZIuqV602Iv7JexZlFu/yiZnvEwPGXM3pqx6JgcurJtxW
         TuVBTkStCjexGRclFU9Y7eUApjHgy7swnJScAbOkFl4WMKHqnzqp0gV5tOeBWkqNow+A
         DALJSZwa4Fmja+aHH9grEMkcRR5dVcLwosoQ+e6skZcyEisiGQhfWR/r/wblSRQcyFAr
         NvdcrcFp9qt5yYu+NUKeBMxdXbKWfrSUrbiYIEVMHJB9NQxZiAMkbS09oifpeNM+vKhJ
         ptjUm512JVQbVsSPkaz6GaEdCTfgen8+LOQEmcmAufBr1w5Hh7etdGv/AbQr71pGx4Fj
         xGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgf472b2g1DolTkwcFzFHbrCtJ8S8RAubSBTuQ4ufTc=;
        b=qHdCA7Pqy29bSPFbaB5oHK7e0yfj3Pm6Iv0hEFlr+tY3FLFx8B+OKwqwQOvZ8rmz8Q
         gYJjeut2ThxtgbLjz71vdR3AiLO7V/Z2TFDQnBeB8/GJA0+U2mw/5wQtX6nbKGEb/Kh3
         wAmkqPnmAEdxH55R45Dm1/R/zgBJwrtBXvWM4WqW/WwAIGeLNU4KQu4LBSpcbrZkHNYv
         /lhCUx5jn3/eYeNFCeCYIqVAFzgJJD1T2at1sns8S4TrfIswvv3/zF1aiZxaPpu/tzK9
         rDRdWiB35xM5RJ0RSdZQTs16xWOSIN/50Y2uHYqS3k2DzkFBYFscY/d4kzJ6Ejf0j5f+
         4Qcg==
X-Gm-Message-State: AOAM531WAQ4MtCU2yYAcNDRJzYeTVyFxHUYuoNyRq9+qLPXQiVgjY639
        fstcyRJFiGPsWqF6y0Dp4gYictJY1vWNDA==
X-Google-Smtp-Source: ABdhPJxOVa+EEDEiCquyhSO8Lp76YuT31DRqTn0Mu8tfJNUgPXgKL9YoJT03NVpfhTWotc5mgXcERA==
X-Received: by 2002:ac2:4294:: with SMTP id m20mr22877171lfh.6.1630435972587;
        Tue, 31 Aug 2021 11:52:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id b2sm1799739lfi.283.2021.08.31.11.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 11:52:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [PATCH net v2] net: dsa: tag_rtl4_a: Fix egress tags
Date:   Tue, 31 Aug 2021 20:50:50 +0200
Message-Id: <20210831185050.435767-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed that only port 0 worked on the RTL8366RB since we
started to use custom tags.

It turns out that the format of egress custom tags is actually
different from ingress custom tags. While the lower bits just
contain the port number in ingress tags, egress tags need to
indicate destination port by setting the bit for the
corresponding port.

It was working on port 0 because port 0 added 0x00 as port
number in the lower bits, and if you do this the packet appears
at all ports, including the intended port. Ooops.

Fix this and all ports work again. Use the define for shifting
the "type A" into place while we're at it.

Tested on the D-Link DIR-685 by sending traffic to each of
the ports in turn. It works.

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Drop the removal of bit 9 (2 << 8) so as to not stir up unwanted
  side effects.
---
 net/dsa/tag_rtl4_a.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 57c46b4ab2b3..e34b80fa52e1 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -54,9 +54,10 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
-	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port number */
-	out |= (u8)dp->index;
+	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT) | (2 << 8);
+	/* The lower bits indicate the port number */
+	out |= BIT(dp->index);
+
 	p = (__be16 *)(tag + 2);
 	*p = htons(out);
 
-- 
2.31.1

