Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E921E584C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgE1HP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE1HP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:15:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43C2C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:15:27 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so12989200pgb.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RoTMM0rU2xs2N0FcIrbtixRYpf+IwVXl5DV8l8P8Eo=;
        b=UyEUqtf1bFEsh3Uixyk9hVOJADGgttYRYjZXYyzE2hCwH1sbxq0h+xXb/Pr0Aspk3R
         myOjjYzWnZSq+RMx6LsQkBV1Cczgls+fYDKK+1o04KUrAMazQ42sfQMs0/mX1u1svtSF
         bOEv8P5uNHcanSgzckuVc6NZCxeOJvlWQIWWt/bP+FYXsmJB4VVeFrrLl0K0Zx7Dwd68
         spYC+wv2TFN4FGjkbXmI6/0fvJbhmaH0BEpSCczAFMp9XxabgviuBLYCbnHXidWrm0cb
         XAsI0MqwqXU1XstmMrufpgrT63Q/wPkGOLqn7i8Pm9i/GobFd80MIuDZMrLeT8IN+lcM
         8FOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RoTMM0rU2xs2N0FcIrbtixRYpf+IwVXl5DV8l8P8Eo=;
        b=VaCuyJ7iwNoSUVolCe6FAZlespnT6UKFv/WLpKU34nuz3IbAx+i3+uXgQv+D+7FzIW
         B/PQeBZgVEMH3ZIIXkJk23ASaghTSJkx04t42K6TAmGEbDuvBSK1iNrAr/FDt5ybTMCM
         lOu4//S9XLenQUc9knlhh/AhAebnfuZc2lRvYtvQ2OCmdzyhwovMiDmelQUscNu7EL4/
         VZ79zKmyp8/qxbqksupU2WWvigUiQ1fcE4RUIPnJuoNyBgo0jftwhYRWpKwK507jXnyM
         cslg+7fspMlwbBKFaCRjASAoVUkMVNyMzwLH+rA1xBGrYccyuym7YphmkD87nIu2le9x
         eR+Q==
X-Gm-Message-State: AOAM530SReoz1f0hzScm+FulPIANlCC+GJC1/BlXhw3HF+fC63qu5726
        cYF3ERLzlJQUVVaXXfCeZ/+dtdLji67I7A==
X-Google-Smtp-Source: ABdhPJxRM8ZBxfEXeWQHdt2xBpQV/0mECJjDj2P1MX1mbFJ+4A+AdC2XUDmbQuvdRubHvdKgzhDnQg==
X-Received: by 2002:a63:514:: with SMTP id 20mr1620480pgf.150.1590650127098;
        Thu, 28 May 2020 00:15:27 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g1sm3792509pfo.142.2020.05.28.00.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 00:15:26 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianwen Ji <jiji@redhat.com>
Subject: [PATCH net] neigh: fix ARP retransmit timer guard
Date:   Thu, 28 May 2020 15:15:13 +0800
Message-Id: <20200528071513.3404686-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 19e16d220f0a ("neigh: support smaller retrans_time settting")
we add more accurate control for ARP and NS. But for ARP I forgot to
update the latest guard in neigh_timer_handler(), then the next
retransmit would be reset to jiffies + HZ/2 if we set the retrans_time
less than 500ms. Fix it by setting the time_before() check to HZ/100.

IPv6 does not have this issue.

Reported-by: Jianwen Ji <jiji@redhat.com>
Fixes: 19e16d220f0a ("neigh: support smaller retrans_time settting")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/neighbour.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 116139233d57..dbe0c6ead773 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1082,8 +1082,8 @@ static void neigh_timer_handler(struct timer_list *t)
 	}
 
 	if (neigh->nud_state & NUD_IN_TIMER) {
-		if (time_before(next, jiffies + HZ/2))
-			next = jiffies + HZ/2;
+		if (time_before(next, jiffies + HZ/100))
+			next = jiffies + HZ/100;
 		if (!mod_timer(&neigh->timer, next))
 			neigh_hold(neigh);
 	}
-- 
2.25.4

