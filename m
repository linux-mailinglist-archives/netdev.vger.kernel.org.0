Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7471F8B62
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgFNX5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgFNX5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:57:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D57FC05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id o26so10198515edq.0
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rgTjsaP11dbLudZjdMdFXrjVySbOKRJcv7BkvXpvbww=;
        b=H43+HvUrJpYMhXxVHyOGvEhyadWHEesQ7CAP1CFCRm/C6VgrFElDFWBjY8Ivc2vWCO
         SLKW4p+HpJwoz8Hd5l86vZDGhz6FY6F64rjyQySX0nqhll3ECiIX624HE6CkjxhsVJio
         MM5HjKO9x47AfulUct5fCi1JJZboavlwO4608=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rgTjsaP11dbLudZjdMdFXrjVySbOKRJcv7BkvXpvbww=;
        b=stcGJeaWtwGwTqckFiqeDEXx8eE5VY+2rCXdbDfX1l0WglPT0vt0sVtPQ49xA32m85
         yKsJ7XPNdJPi31fVtuVOPZxp/FmK93zbk8WBCgcuhMantROIFiK+LL+j6wDpLBWf71qR
         S8jTRHI7Z+uUD2vGO5N0OptQGw98XsRna5kRQyaHGiAjxu9Qru36pd7eFA64AGGAf+Z2
         dW7tZpgmxMZmfT8L5b/ppI7oNbh1tmA9N2zaHwUZPy6Mjkxw+DqQa/LzMaIxuHHVkj+T
         Otrc1xpQZEjN09RMYqUBtTlLZFJJNeoG0RPRhouRQw582BlcAMi9xsDdedeN8TUKgoQG
         3FJQ==
X-Gm-Message-State: AOAM5335FkoT2xSLi7oXkJJE94iggXd1GAH4KryvxNlUYOgUdJTwXivr
        2lZGStuKZ2ApKy8yfzJRkfgZyQ==
X-Google-Smtp-Source: ABdhPJz/mCfIt7nPKceCS88xuJwwGnd35xwTNZQ6hS4sND4r9fl/7GyPcLMoAX/daYSNsBlMY9MN6g==
X-Received: by 2002:a05:6402:8d8:: with SMTP id d24mr20977888edz.287.1592179060217;
        Sun, 14 Jun 2020 16:57:40 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj10sm7891398ejb.61.2020.06.14.16.57.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 16:57:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 4/4] bnxt_en: Return from timer if interface is not in open state.
Date:   Sun, 14 Jun 2020 19:57:10 -0400
Message-Id: <1592179030-4533-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
References: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This will avoid many uneccessary error logs when driver or firmware is
in reset.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 47b45ea..b93e05f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10037,7 +10037,7 @@ static void bnxt_timer(struct timer_list *t)
 	struct bnxt *bp = from_timer(bp, t, timer);
 	struct net_device *dev = bp->dev;
 
-	if (!netif_running(dev))
+	if (!netif_running(dev) || !test_bit(BNXT_STATE_OPEN, &bp->state))
 		return;
 
 	if (atomic_read(&bp->intr_sem) != 0)
-- 
1.8.3.1

