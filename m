Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D386835AF85
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 20:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhDJSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJSRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 14:17:54 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7E8C06138A;
        Sat, 10 Apr 2021 11:17:40 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so8883500otr.4;
        Sat, 10 Apr 2021 11:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLw4wtMWwxuf/ANKZFLWG5uXUKgR5C1H9OVIBIUwrsw=;
        b=I2nLWSvp+/FZuGKqqNUVMLFwEy1nRxDOfc1VBnucKo7Z06JMozoFUNi2afT2YlRlpy
         dLi0VOFQOUB+a4LtLoBVFE80fha4o/qxzKnxLCiDExjHqD0KPkCMNDGIOCRaMaV7QwCS
         s2tf3hRm3+vVBt0+s5ug5sxt2bYKklbe9HXwKemsb1PlRyLe5bFmX3wR5qGcPCgobIRw
         X7P/THRqKc1GU62pdlKPbAIkaMSSH59JO02OB6yfqYhFla7OIplFhZA2+ZU22lAfqTuN
         eMS33hNwcWVJkqK+QN3YRUY7pKPe8UhCiCgcsmccTew8vonkzuPZKwBmTTHD0DgksFFY
         Ij6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLw4wtMWwxuf/ANKZFLWG5uXUKgR5C1H9OVIBIUwrsw=;
        b=lidY1SnC/s2+mzip7aelgF+EMbCx0bvum7nCO67jdN8DlAYswKLrjvkDm866d6Z16G
         sp0g8K7LYJ2jpJ+z6m1zRwuFWRNlbX6wrgo8eaGeJJptRAuGyIoD3nhVpYvNhZxzpZuA
         UpTyrBvOBjL/fWXRqhTwWWYFfioWzRz6vwOJnSWEaHHgCFCa7o2ANg3Q7SUTMOdmyRPY
         a/hRHAZCZyB30y8eQ0ntNIhuEGcqR6l8P2lCuHd9kfbr3UX4pcvH36kvTDpofIrUK5f2
         BN1S+PxfFRu2MXCL9TWPUQpu3ox8VgQQOhGL9PefEnYFrzH8/5MRGNnkbFROqsuXyGpj
         GWmw==
X-Gm-Message-State: AOAM531pMQ0JZVPOfn79KVlc2vwKj+FTyNmr6Dbm8RvMwY6PDffzXiJq
        t681mp1bazjNHwEPt//NeMm7/Nwz2jMfAg==
X-Google-Smtp-Source: ABdhPJyQO6jZRklTmCr7rFscLevmRxF1kcyacPlty8u0O0CKK/jzKJSBtEPXg4LrjlO+hpYmDd/UOQ==
X-Received: by 2002:a05:6830:1af6:: with SMTP id c22mr16490528otd.291.1618078659328;
        Sat, 10 Apr 2021 11:17:39 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:2c33:87fb:37f2:b1f1])
        by smtp.gmail.com with ESMTPSA id x3sm1503046otj.8.2021.04.10.11.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 11:17:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [Patch net] smc: disallow TCP_ULP in smc_setsockopt()
Date:   Sat, 10 Apr 2021 11:17:32 -0700
Message-Id: <20210410181732.25995-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

syzbot is able to setup kTLS on an SMC socket, which coincidentally
uses sk_user_data too, later, kTLS treats it as psock so triggers a
refcnt warning. The cause is that smc_setsockopt() simply calls
TCP setsockopt(). I do not think it makes sense to setup kTLS on
top of SMC, so we can just disallow this.

Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 47340b3b514f..0d4d6d28f20c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2162,6 +2162,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int val, rc;
 
+	if (optname == TCP_ULP)
+		return -EOPNOTSUPP;
+
 	smc = smc_sk(sk);
 
 	/* generic setsockopts reaching us here always apply to the
@@ -2186,7 +2189,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (rc || smc->use_fallback)
 		goto out;
 	switch (optname) {
-	case TCP_ULP:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_KEY:
-- 
2.25.1

