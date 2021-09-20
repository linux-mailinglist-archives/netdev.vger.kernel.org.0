Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CF2410EA4
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhITDLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhITDK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F5FC0613E0;
        Sun, 19 Sep 2021 20:09:18 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q68so15891371pga.9;
        Sun, 19 Sep 2021 20:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SD6TUaTysMr9VbomNxG6XTtL1KVslrTC3ehz6KVrhuY=;
        b=PZAZufPgOPGU9cmaXjPnjuYiKgEQw0ng7Bh7KjKn6NgQmcYHLMeQfjiwUepm5yShq3
         xuyjmXHpivpbMtI0wWFYzt7KBFPEzSQ90iFu5aO3tNCE/X5RFtWxw8usdBb2QfTaBOzi
         8FxVOga6o8j+ROvnkfhlmpirTb2m4AQPay+LRzZS+qwYcXmUWrENLYU/9HXDMaoegPve
         fr5Lu709DHDMsBJXa0DiseuCWNRap1/UW9osJ/bfjKakqc2xBf8SQMyB07FRIFekzYqJ
         L8OzVJFWECEfeHRd4oH8Spp8Iu94mmM4RcHCKhZB32EGsp4fZq5ToxGWBQKTEAWzZqBa
         IHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SD6TUaTysMr9VbomNxG6XTtL1KVslrTC3ehz6KVrhuY=;
        b=6F/6SwFr43IYo5hrIKO+at5GysZRzD6cjZYYQZuk26BJVNDlbtnRiPhLQaj/N7JLPN
         OS1eanigGOs+UDDu/EaTOtY5lFqsm+wMfR0GPcdfTYi9Ml1F2pxNa+CyXwSMHsX+PIF6
         Rh+x8+kHm0V+rzJk7e69opeDU1x1I5vR11RoIxwOky7xIC1VqCNOIkHjcqGx8SlEpEBT
         C5oLEbdx4NPWmagRilYnifNO6+YZ06R2F8acnh+p0APCd2kT2anUE7e8tA+ovvvdnX4q
         2/u/pCcwLSMlQRWmT/rqhd70f3PVtaVoZHXTwET02t1PY48Rl9AFMnV6ZcKVuJy4TRDp
         kT0g==
X-Gm-Message-State: AOAM532+jOb944irDpK6CBPDqq43J4wsGm4a5N5MS1vjjlu0xVfFiXQS
        mTFBSxX0bMWjlpWqYHVSteJPlW3/CSvyEg6q
X-Google-Smtp-Source: ABdhPJy9x8/tPXaq1b/8OZRU6zEejY00lLIS0HTHEdnEsE4Ib74Dw08ApXSEohvLDQSldOE7dkvUaA==
X-Received: by 2002:a65:404d:: with SMTP id h13mr21649467pgp.130.1632107357415;
        Sun, 19 Sep 2021 20:09:17 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:17 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 08/17] net: ipa: Add support for IPA v2.x interrupts
Date:   Mon, 20 Sep 2021 08:38:02 +0530
Message-Id: <20210920030811.57273-9-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

Interrupts on IPA v2.x have different numbers from the v3.x and above
interrupts. IPA v2.x also doesn't support the TX_SUSPEND irq, like v3.0

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_interrupt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 94708a23a597..37b5932253aa 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -63,6 +63,11 @@ static bool ipa_interrupt_check_fixup(enum ipa_irq_id *irq_id, enum ipa_version
 
 	if (*irq_id >= IPA_IRQ_DRBIP_PKT_EXCEED_MAX_SIZE_EN)
 		return version >= IPA_VERSION_4_9;
+	else if (*irq_id > IPA_IRQ_BAM_GSI_IDLE)
+		return version >= IPA_VERSION_3_0;
+	else if (version <= IPA_VERSION_2_6L &&
+			*irq_id >= IPA_IRQ_PROC_UC_ACK_Q_NOT_EMPTY)
+		*irq_id += 2;
 
 	return true;
 }
@@ -152,8 +157,8 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 
 	WARN_ON(!(mask & ipa->available));
 
-	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
-	if (ipa->version == IPA_VERSION_3_0)
+	/* IPA version <=3.0 does not support TX_SUSPEND interrupt control */
+	if (ipa->version <= IPA_VERSION_3_0)
 		return;
 
 	offset = ipa_reg_irq_suspend_en_offset(ipa->version);
@@ -190,7 +195,7 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 	val = ioread32(ipa->reg_virt + offset);
 
 	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
-	if (ipa->version == IPA_VERSION_3_0)
+	if (ipa->version <= IPA_VERSION_3_0)
 		return;
 
 	offset = ipa_reg_irq_suspend_clr_offset(ipa->version);
-- 
2.33.0

