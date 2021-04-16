Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5E361844
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhDPDko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbhDPDkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:40:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E560C061574;
        Thu, 15 Apr 2021 20:40:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z22so8119285plo.3;
        Thu, 15 Apr 2021 20:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oUo2JF9IqQjyidp0K1ig13iO9lu64qKuODrfboUEIYg=;
        b=NKerWLiU/PngmgzC+YgS5OEkEywnl5gAo6qr0GOYcup3sJNuOIm+oUZf+6zf4CBk2I
         AJg7NWZ0YTUpx4AZNzIe/ylxvmuGF3uAwb+by30KES9wv9q6g3K3iZyvxzOBik8CBqV6
         7TtwYps3GkGEjsHCTsWPVZSMJG2ceu7K7olcBLQS+bMYanZABsQa9qt7z0F07vxuoUw/
         ZreQ6eQtbqpwBGCYdJ75s1QF5ZhykxN0TADTsryfvkvPt3R3INSGKAGEtXFDi5ikpfOn
         f2dR+781Sjb69/G8TmLzJf/Z3B7EK+woBDv2NEw0G7XJQUODCvDqo6gXXVnhwK8t1Z1f
         gKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oUo2JF9IqQjyidp0K1ig13iO9lu64qKuODrfboUEIYg=;
        b=RTdnd4NGYJOckMUS4sDywfLS76LbPy0Sz4ZbVgXVR3zupobXtsyj1z8/v75pQF2t+L
         Dmu9+1kxoNVUx4c6FbjY3BqaQXKHOJC2kx6YsVuN0RG0drCdOKlxRG7qREX2bhIdZ9+V
         Do0NUyUCMsYL3Gedlul7B6t7rlYOgFKAS+MyMaaGtLypdLYHnQNpkXfhmogWxxqi3mSS
         XzegBZI+SfNLcoO1j9QI/53lstiajtnPQyU8RTraBu9Vq5rFRtAaZ2Dx4uWBr4O2qlvE
         oj1qPcQ3JukqnB1opthQdN0QX2PzhxN++kjYUoWAV+EBux/LEZxGzBYitBQVqgJeDsVg
         DVzQ==
X-Gm-Message-State: AOAM531/TyDJQA/jw/MgQkyncnFYnc6yFvUXgET/sxjumAY+8J4J8Fdu
        B4yZKPYu+1GfPK4VGliOwhKUNByBLoFxmJ+vtR8=
X-Google-Smtp-Source: ABdhPJzjXiGOtKd9NQalcbApfIT9Bc4vfqr02DsuG2Rw/zNfNIG5Ke8lQmouwjZoVFYWjgyZzKddWg==
X-Received: by 2002:a17:902:c404:b029:ea:f0a9:6060 with SMTP id k4-20020a170902c404b02900eaf0a96060mr7297686plk.9.1618544416311;
        Thu, 15 Apr 2021 20:40:16 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id r26sm3473902pfq.17.2021.04.15.20.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 20:40:15 -0700 (PDT)
From:   zhuguangqing83@gmail.com
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guangqing Zhu <zhuguangqing83@gmail.com>
Subject: [PATCH] drivers: ipa: Fix missing IRQF_ONESHOT as only threaded handler
Date:   Fri, 16 Apr 2021 11:40:07 +0800
Message-Id: <20210416034007.31222-1-zhuguangqing83@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangqing Zhu <zhuguangqing83@gmail.com>

Coccinelle noticed:
drivers/net/ipa/ipa_smp2p.c:186:7-27: ERROR: Threaded IRQ with no primary
handler requested without IRQF_ONESHOT

Signed-off-by: Guangqing Zhu <zhuguangqing83@gmail.com>
---
 drivers/net/ipa/ipa_smp2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index a5f7a79a1923..74e04427a711 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -183,7 +183,8 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
 	}
 	irq = ret;
 
-	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
+	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT,
+				   name, smp2p);
 	if (ret) {
 		dev_err(dev, "error %d requesting \"%s\" IRQ\n", ret, name);
 		return ret;
-- 
2.17.1

