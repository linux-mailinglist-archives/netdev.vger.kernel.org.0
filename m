Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9619370F13
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 22:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhEBUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 16:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBUmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 16:42:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D58AC06174A;
        Sun,  2 May 2021 13:41:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so4630223pjz.0;
        Sun, 02 May 2021 13:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aw7aqZtKf2/M8s/erFYFqJ+AMQB8zXKf4LYmpiXo9ec=;
        b=SR6sxRm253n01t8fVsBSF1AEFl8xqkI6TUbCyiKYvNou9gKLZ1D669rj0XFnXYuQeL
         uspVNsRbdlh7EVV/Og6eEg9dwtH3nLQ5aIICWTKxyOEauPQA5hyZVpiYCwXzPg7WQIFo
         yMWxsWC5Qlsd1zhYfyb3jqPlGuxSfAYblFvUMJc4XfCk12GX1JTfLm4yLMn7NKqgLWBu
         PTbyh3KR4GRCpnG7tmOnoFoMFY6zYLgG4+WNxioWwRjlhCRHHoYSx3zKg3GDtucJ/V2M
         OAf994t0cQ+6nSu8IAD6wCh2LubruGyZFjnasufhHEJq+RjGNPOTnY6sM6njfVQEUB6n
         35+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aw7aqZtKf2/M8s/erFYFqJ+AMQB8zXKf4LYmpiXo9ec=;
        b=FEuvWGJL67UCm/VVwrTrGf+X/cXfFyYw+IK+RRaMJrB513A8q667huf6HTNPW2lY6s
         HuAfDVz64PSMnao1kIIkfqqZmyecmB+dLekM+UA9y4HmNdiigX1Z07SNq61EU+vU/ESB
         so1uOuBdYcUzC3t0rYZfpWwLhiQLw4ZyE78ayNb/1ZuIpXLOMWY47Rcsm0oEvPNMOc19
         tfjeIM2W7iymJ0WYXvX19bGBfdPsFLEAclBY1J6k+PXbf5jyMxcmV6xMxURWniPolAhX
         OosP14F8LeOYmdb/JJtnE/qOhazjtknqGjjJ/9meBmLz3ZIHHr1wUiDu5ZB+Ol2N2lZg
         ZmNg==
X-Gm-Message-State: AOAM530amR7RuK4V6Q2WMSCtGEDrWcpN5liT4l4pleD7HPfmR4JJfad1
        tcKe1MfLeaB4RpX0BVHiBGPOb1YvnvstjXbx
X-Google-Smtp-Source: ABdhPJwYzrTy+/LFPBAjW8mW9FLZ74lsmX+UxXXoqCWVSjbefsb2kzGU28eYKFZ8NKRpWGJD0n/H6A==
X-Received: by 2002:a17:90b:17d1:: with SMTP id me17mr14343030pjb.143.1619988088402;
        Sun, 02 May 2021 13:41:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j23sm7431086pfh.179.2021.05.02.13.41.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 13:41:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b
Date:   Mon,  3 May 2021 04:41:20 +0800
Message-Id: <98b2f435ec48fba6c9bbb63908c887f15f67a98d.1619988080.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally SCTP_MIB_CURRESTAB is always incremented once asoc enter into
ESTABLISHED from the state < ESTABLISHED and decremented when the asoc
is being deleted.

However, in sctp_sf_do_dupcook_b(), the asoc's state can be changed to
ESTABLISHED from the state >= ESTABLISHED where it shouldn't increment
SCTP_MIB_CURRESTAB. Otherwise, one asoc may increment MIB_CURRESTAB
multiple times but only decrement once at the end.

I was able to reproduce it by using scapy to do the 4-way shakehands,
after that I replayed the COOKIE-ECHO chunk with 'peer_vtag' field
changed to different values, and SCTP_MIB_CURRESTAB was incremented
multiple times and never went back to 0 even when the asoc was freed.

This patch is to fix it by only incrementing SCTP_MIB_CURRESTAB when
the state < ESTABLISHED in sctp_sf_do_dupcook_b().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 5fc3f3a..fd1e319 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1953,7 +1953,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
-	SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
+	if (asoc->state < SCTP_STATE_ESTABLISHED)
+		SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 
 	/* Update the content of current association.  */
-- 
2.1.0

