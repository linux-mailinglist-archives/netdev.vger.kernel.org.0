Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85C3748CB
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhEETl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhEETl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 15:41:58 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5CBC061574;
        Wed,  5 May 2021 12:41:01 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id jm10so1886854qvb.5;
        Wed, 05 May 2021 12:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gHCXIKLtd7G4osYiFCozm7gObpwo0FT29jyc+aZ4+CQ=;
        b=Oyli+aKqiMyxdTExPzpx1etD/OMlIFbaed0jcCRkzYvYX34lhh7nbeILsTYOKyvuEl
         /NIbonTrOwjB/CHaTDVZQC/vqdAFxK/XZUn2FxjmtVM4jD565n9/CNfV9qU+A6ursw4/
         qSsOULO2a4/wC+sHwS34gp3cmI9tCmgvGjo70o4U0GMHdvz7GWLXA9M9VSzNZfZYDJUQ
         JW6pMG6NlqMbncyYgJeVr0UksdCcmXbRkc4+9AM2OAx+WZZA5Ajtxyr5U/e7csEbNwXj
         VZ5/j8q3/fGFxAYvGwrj/IMUqSGZpytrzw0WTXHMRAQ2SlpUbRH1jSIm9uoIVFBt5JSN
         RTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gHCXIKLtd7G4osYiFCozm7gObpwo0FT29jyc+aZ4+CQ=;
        b=iH1qVO1attZ1a70spxCl7jytI5jEymg15Lx3Rs0+cXN7MuM4gDwzjSLqeV2k4K43qx
         mRhAEMu8qcBE+hwix4gxZ/yzjl0WphuD/XQKQbeEcMjCzg0md92oQsfkIcNQq5M8P55s
         jchHOO+FKfqUGNm8kyd2gx8w7J5yMI9CDYLf30XuIvs+9JT2wbG5raGv9E6QtNBG7ETs
         PS4LdKMg/s+s9mgIWt6ckopN9Q1Uf3hRxpz56XzmJ1HIwIpg5tQ3V2+RZHwpHmJ7R4d9
         3bhldi7BxHYHLehJWPO4htNr7oogUraLFPc5HhdTDV1LB+yE07FqnkOw7CYtIlAwZssE
         XnHA==
X-Gm-Message-State: AOAM531q+s5jLjsmTjcQ4S6adEC894b+4kuCA8UCK1XGtZ7HCngKN71I
        0ZbT7k+kAlT8VzVIKkZAolq/BDMqdqZeBg==
X-Google-Smtp-Source: ABdhPJwjr7S2wt1XDOenurA4mWNVLhhJSr6z2X2QF+kC1NO9zdspoSby7Bloa1RtB4Bxv00o1kR3Rw==
X-Received: by 2002:a05:6214:851:: with SMTP id dg17mr485096qvb.56.1620243660163;
        Wed, 05 May 2021 12:41:00 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id m15sm191166qtn.47.2021.05.05.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:40:59 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [Patch net v2] smc: disallow TCP_ULP in smc_setsockopt()
Date:   Wed,  5 May 2021 12:40:48 -0700
Message-Id: <20210505194048.8377-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

syzbot is able to setup kTLS on an SMC socket which coincidentally
uses sk_user_data too. Later, kTLS treats it as psock so triggers a
refcnt warning. The root cause is that smc_setsockopt() simply calls
TCP setsockopt() which includes TCP_ULP. I do not think it makes
sense to setup kTLS on top of SMC sockets, so we should just disallow
this setup.

It is hard to find a commit to blame, but we can apply this patch
since the beginning of TCP_ULP.

Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index be3e80b3e27f..5eff7cccceff 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2161,6 +2161,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int val, rc;
 
+	if (level == SOL_TCP && optname == TCP_ULP)
+		return -EOPNOTSUPP;
+
 	smc = smc_sk(sk);
 
 	/* generic setsockopts reaching us here always apply to the
@@ -2185,7 +2188,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (rc || smc->use_fallback)
 		goto out;
 	switch (optname) {
-	case TCP_ULP:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_KEY:
-- 
2.25.1

