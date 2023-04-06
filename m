Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A319E6DA1D4
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbjDFTql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjDFTqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:46:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C978688
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 12:46:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so40351327ybg.21
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680810397;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kqTBetZeJEZAfE1b7iBbguTM38AcSrNLYr+CME4BWRg=;
        b=szLgtpPbr44LSNta3Ab9VgYjNlpVshHOGY71++M27G4myKigKL89nPEeAR1f8mdgQr
         bLTqvMV4gMWxNlOSByeFK2KsOnsEGFkxeSuepgLgiDu6gtOTfllghjxK9ixjKgcF8RDg
         6VmvmuWgb50pPJjbrsWulLtaUCY/+pcMn5k1vgmVafRXmKnOMZzERGwroJBB4BSij1pT
         p0EFva+azPrzAeDWuAc/Nk4Yz+Q+x5wKSCo/f+sVf13aZdT7EZ8Y8pBZgGMSQmZLOpFL
         WBBMA6WPUJEDRBKKo8Qy7jC8oNRdFBgY+cRNP1vQu4aO88N17dRTJugMIIH9ZOdoFJ4C
         Y3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680810397;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kqTBetZeJEZAfE1b7iBbguTM38AcSrNLYr+CME4BWRg=;
        b=FI8sHIuqnvD7Em1QIZvvvdba/EuRLQkE0TL7SptAPQzUMTGJ+KGFj/m2EtUfZr9NJb
         +O8QdhjKR77RTewvWTFLOmM8ghXbqenO8aVEXIeTZhOdGNj5OrSxdtG5IIxgibUF7urs
         tGxFJo4tv1BO9mzG8srI5T9hwzfyuKmn0jT1UviedYpXuY8gOIYtjtuM2kr/82rm/pih
         pZ1GauPDb69GSYVgc4kYf/M3OCj9L86plwaOhlxbt4SVbOat2IGCGpYkakXg16sZ1pAt
         H8AEvOTjfv9WH9zHzSYP5chCtZ0k/Vxmmm0KmUhOXpq4jrxd5J6aR//BeyNvkK2JPa8H
         /xiQ==
X-Gm-Message-State: AAQBX9dwqeTN8Hqn1rtbjNn/q/FPnxN6VXfslHKBe8AJXcgTkf6dNWBf
        rGzRFroAdpGOJMZoLdjL0XKIYbjH0xLe5w==
X-Google-Smtp-Source: AKy350akUygHBzO7eIqkSXYABYhGinWBtLvH1nqfBc9C2Ew7Hvd7v6FhJsqSX/j/jyBgfU1H8BsLfC3AfawYkA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:c509:0:b0:549:143f:3d3 with SMTP id
 k9-20020a81c509000000b00549143f03d3mr6539308ywi.0.1680810397600; Thu, 06 Apr
 2023 12:46:37 -0700 (PDT)
Date:   Thu,  6 Apr 2023 19:46:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230406194634.1804691-1-edumazet@google.com>
Subject: [PATCH net-next] net: make SO_BUSY_POLL available to all users
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 217f69743681 ("net: busy-poll: allow preemption
in sk_busy_loop()"), a thread willing to use busy polling
is not hurting other threads anymore in a non preempt kernel.

I think it is safe to remove CAP_NET_ADMIN check.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index c258887953905c340ad6deab8b66cbf45ecbf178..5440e67bcfe3b0874756fd87a9d79ded41c2e4a4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1396,15 +1396,10 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	case SO_BUSY_POLL:
-		/* allow unprivileged users to decrease the value */
-		if ((val > sk->sk_ll_usec) && !sockopt_capable(CAP_NET_ADMIN))
-			ret = -EPERM;
-		else {
-			if (val < 0)
-				ret = -EINVAL;
-			else
-				WRITE_ONCE(sk->sk_ll_usec, val);
-		}
+		if (val < 0)
+			ret = -EINVAL;
+		else
+			WRITE_ONCE(sk->sk_ll_usec, val);
 		break;
 	case SO_PREFER_BUSY_POLL:
 		if (valbool && !sockopt_capable(CAP_NET_ADMIN))
-- 
2.40.0.577.gac1e443424-goog

