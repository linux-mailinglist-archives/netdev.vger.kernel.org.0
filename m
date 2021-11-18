Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7676B45644C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhKRUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhKRUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:37:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D1EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:34:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v23so6094521pjr.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rr6pVb1kreHii7h3owvqhylogoz7efHCoA5piVhQdcM=;
        b=HrsvfUCXT0gBKwJkPUg1l03es9F4vmWH0F+oP580ZvRXFAV+QGSgA7gQ/ZYmGl0tY3
         1MPcWdu49JSDL87rftHbpJ+2ivLnmNOW0WalVevz64uUyLr8bKO3sKaGwsoRLrfXC5MP
         zWk3muyC/y7MkqtZFsjDuf0BeVWxedFrwBkw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rr6pVb1kreHii7h3owvqhylogoz7efHCoA5piVhQdcM=;
        b=m6svBWYBwMy30h6TNe2lEp0Rb0bEADZQocP5MoH+7mPgnJc/WW+rhyzX1sc+XHk40u
         aVSHS8IRMqDVxR6/Yk3LPEQiWggSeW3hmOu0ZwdSjPAFxZoEfw8i+JiBZsKBhxX3ygM+
         GZe2ktmAbQj0CRnRjZPAp8fRF4jT+8xIFHLDHwUEmyWSxc2VpeWrFj4b56Kk1k7MJQCa
         aOZIbhdLC6WJ9VSDGFHfpfM3iLFuc8kizVPiEBSdK7Le0gNf1aZh5k1sVS9cTacWnnNW
         /E0hqGdbT8nPj/IDQ3cfUt17izdQB3DHNVyP9fW4ZpsIh9bAa3fGQB9nXyWy+/IU4Pht
         uGDw==
X-Gm-Message-State: AOAM5326Hw+V6JOder9ACKkHJzw/V3GlDWseR+pMoPmjD2VNTRIsO0+/
        JYdZrA4e7xudxBQhItRrMc+kdA==
X-Google-Smtp-Source: ABdhPJzi9Z8Wro0uG9DSk6dqAdfOvApTISmjQgGDVRnaiJ1C0pp5+zl2nN2g/iIJMJLetNb9Q3ENYA==
X-Received: by 2002:a17:903:2004:b0:142:6344:2c08 with SMTP id s4-20020a170903200400b0014263442c08mr69671413pla.51.1637267649182;
        Thu, 18 Nov 2021 12:34:09 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c1sm526468pfv.54.2021.11.18.12.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:34:08 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net/af_iucv: Use struct_group() to zero struct iucv_sock region
Date:   Thu, 18 Nov 2021 12:34:07 -0800
Message-Id: <20211118203407.1287756-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2141; h=from:subject; bh=VmpjIxRv8nvqUNUz90kONYh3X1XPNBqPtO7KlwDBGYg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlri+9C59IrgIZordTCohSomw5OzihK4DRxTC1FsR SEo58EeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa4vgAKCRCJcvTf3G3AJnRKD/ 92nDQMb68IMNKv8eGnelNS0HG0pPS+ROK4Yq0KZVVW9WCoirh/ef6Z5ZvfNz99jfcduDPDfdeirKlq j6rgokttc3qliSt4wBGROehNHaTC9x3j2aVuqN9l+Ys5C4mBdrr9MrgZ8hyW532l6bP6II8s1v4S4U w3+1KVOSQNs5y+x53gNpkS1BupPwj+kefq121UR+Ve6LOgU340uFCsWWzNXg65q6elV64otBDLSv2o ZhZLZbNiNQxD3s7ChpwtSzugWdQgFLx/Ba/a8vTU4RLtggIqBTvqh4Eeqz+lgAlkp1JBRMUsBVW1Ha kplo7xablxQHAFohYlA//or4tU92bQ97BizASRzyYWp0m0oPWC5PdC8EzuK1q5sNtAxPbowayDhXGG ncYShLB0Kz4W66ACA5ZEkOik1zdMmYIdGroKUX92RQClWZWsjuzCTtpV6pJBEllI+r5q8tSPgsp4aR PhxwL/be8b+0zWywXHEYRvlaz+1Dhylb3nvv8C8C+UJ83xDiksdovLacG7ML5cKMCGRAk+ubaux41Y 2/1sR3SatiHEPnqtgEjS84UOPTTPgIZQSXfLwtj0HJyE2q7k+SNJgTA4RfFXTUATPYYblQXxpPPzQs ps9qxyVstw220it3ImpG1NzYuI3CjsUxKXDyKwD357shHTcU0SEM2toz/4JQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark the region of struct iucv_sock that gets
initialized to zero. Avoid the future warning:

In function 'fortify_memset_chk',
    inlined from 'iucv_sock_alloc' at net/iucv/af_iucv.c:476:2:
./include/linux/fortify-string.h:199:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  199 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/lkml/19ff61a0-0cda-6000-ce56-dc6b367c00d6@linux.ibm.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/iucv/af_iucv.h | 10 ++++++----
 net/iucv/af_iucv.c         |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index ff06246dbbb9..df85d19fbf84 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -112,10 +112,12 @@ enum iucv_tx_notify {
 
 struct iucv_sock {
 	struct sock		sk;
-	char			src_user_id[8];
-	char			src_name[8];
-	char			dst_user_id[8];
-	char			dst_name[8];
+	struct_group(init,
+		char		src_user_id[8];
+		char		src_name[8];
+		char		dst_user_id[8];
+		char		dst_name[8];
+	);
 	struct list_head	accept_q;
 	spinlock_t		accept_q_lock;
 	struct sock		*parent;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 18316ee3c692..9446e2771d31 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -473,7 +473,7 @@ static struct sock *iucv_sock_alloc(struct socket *sock, int proto, gfp_t prio,
 	atomic_set(&iucv->msg_recv, 0);
 	iucv->path = NULL;
 	iucv->sk_txnotify = afiucv_hs_callback_txnotify;
-	memset(&iucv->src_user_id , 0, 32);
+	memset(&iucv->init, 0, sizeof(iucv->init));
 	if (pr_iucv)
 		iucv->transport = AF_IUCV_TRANS_IUCV;
 	else
-- 
2.30.2

