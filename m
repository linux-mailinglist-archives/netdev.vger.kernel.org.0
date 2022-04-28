Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E325131F4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiD1LDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345216AbiD1LCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:02:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E37FA144F;
        Thu, 28 Apr 2022 03:58:57 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so4051165wms.3;
        Thu, 28 Apr 2022 03:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s+kT6lElZGiyXPNFYxpX9dPigb8JGxp1Ty3OtCWIYZk=;
        b=KAsXqQiXisUum9sr3vDWSaGkLIRSGm9RTKRR66bEjq2G75ZFXff4MTatYHQFZiRovd
         X4d1MfhVT76VMxJ1LBwPkeRJiJ3cCOpChI6+YON/M6w6JEEhpdOvJfE6CfEcjbsAWoDV
         jWy4P9D7PshHJynG5LjSSuIIzeSq9K3vRNMnBGGfdsmLhOx0J3HHWqHsQ1fe1ATH7iqn
         Gw3GMzcL96MMruiho87+F/RQmG3NavWTDdsGR5xwunqnfcFotiRHetAemSGTHOFXsqf7
         xReGqk9clcO5qDR1t9GyVoDelpgJGe2CNgOI0sgPNb2biAbp7Uz8ztMr+mWtN2O6E1fv
         ZsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s+kT6lElZGiyXPNFYxpX9dPigb8JGxp1Ty3OtCWIYZk=;
        b=Ko9OKZB9YhMWOyG1WNaYpGeZ/r8MsAsJ73OzixH72ZfsjvzPBN3Qi/jhtcQ4H6Y87w
         ldDRLhNkBeF0DWtrA9r1Od1AjygZ3GwUPt8lmNDz5jLV0FIvapsuikpplGKryWnmBzgu
         /TmY/OiZfQ/WnARjX+mK8VKfMdVjml39moYcxwKqBagerP6PeTRc5zX5IvaTuzjsWJze
         YanoqEqxYPkiTUb3g7HyhCWQitNHQcfTS+Ojt6Li1wmRieCqT4xgsyY3t1vyzBlwCl1E
         c/IB8uFOPHQNCop8f1W/NzgluUKCnaXSGixU+3iQlztvDGI5mbBIWbnO2C/YdLy5yLUs
         xprg==
X-Gm-Message-State: AOAM5303OZ8RLaoLvq3ggzLDKwETKPn4TePB38rRlfvRAyUphjzUgBOk
        WeHNlZMa9+BxJvqWkbaTiIZuX2kWlIU=
X-Google-Smtp-Source: ABdhPJwX28qMZnoY4F1Mv77Ag5sVbXb3Rj3kDgaPd57XubYoJBHS5TrQISuueViQvDdvqOi0U5a6Uw==
X-Received: by 2002:a05:600c:ad1:b0:394:1585:a164 with SMTP id c17-20020a05600c0ad100b003941585a164mr1597209wmr.101.1651143535845;
        Thu, 28 Apr 2022 03:58:55 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id p4-20020a1c5444000000b00391ca5976c8sm4628139wmi.0.2022.04.28.03.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:58:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/3] sock: dedup sock_def_write_space wmem_alloc checks
Date:   Thu, 28 Apr 2022 11:58:17 +0100
Message-Id: <95d349fee6504dc8bc1e8123d80915d1fe9ce91a.1650891417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650891417.git.asml.silence@gmail.com>
References: <cover.1650891417.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Except for minor rounding differences the first ->sk_wmem_alloc test in
sock_def_write_space() is a hand coded version of sock_writeable().
Replace it with the helper, and also kill the following if duplicating
the check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 29abec3eabd8..976ff871969e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3194,15 +3194,14 @@ static void sock_def_write_space(struct sock *sk)
 	/* Do not wake up a writer until he can make "significant"
 	 * progress.  --DaveM
 	 */
-	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= READ_ONCE(sk->sk_sndbuf)) {
+	if (sock_writeable(sk)) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
 						EPOLLWRNORM | EPOLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
-		if (sock_writeable(sk))
-			sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
 	}
 
 	rcu_read_unlock();
-- 
2.36.0

