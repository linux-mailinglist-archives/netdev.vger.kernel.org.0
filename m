Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E4E48168B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhL2UJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhL2UJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:09:51 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07501C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 12:09:51 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id g15so20195853qvi.6
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 12:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KSj2+qUZCgU1K73aKvHjqzbhp6fcaLzAfINrbI7Epr4=;
        b=h+kemzMDFcfAtOETgBmeigo9ANgl4aaMCEtzNp+5V+/785hkeZGQYd/Dzn7jICxCti
         NmoBvx+kIl3R9kyLf1tSnx/iivv+uCgQ7vWEx5t+TlORDaLHUHUIu7Lm8Df2yRRTEd5K
         79jaRd8DcjI9fptqsTzyoOQREKdzlc9xQFy1yllw8aOW2tC+TMzh+v24jWjAIM3KPgAj
         PU54FHtgGWx6NB+GZ4N2gu84sgRWV16mATgErFD5LyA4CbJRYVhow7YXdr2k0pkxKfXZ
         QndIoIfBi1EsyCdFpsPYmAtzxsxI3JIecfMB3MrpvbjeaCJfM0ltnrD5sdo2WQ5CCcqJ
         G6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KSj2+qUZCgU1K73aKvHjqzbhp6fcaLzAfINrbI7Epr4=;
        b=oj5+pqAmo5G/Mf1WwV7JIx1ezVFTJOMZZz20DkwXYNT0Vj8SZGT+/phrt4AP0CrN+6
         ysXj2Eqiw6nc1Mendpz5w8BlwLCR8iEBqq6+8OR+Uu0fTXxBgXJxhjn/aQaKjrYtXkf7
         q74Z9pyYUUDXh/zQw3vXzj1DlOZUibaG0teRBeXunudY74H9hCybHNuJulYeo0fxZT6R
         mtxqsBH0Vn9+f1iwzdfFrAoj7+cK7Eq/tGKhplO/bVeS/ywGD2zb4uxbn35/5b5/fELa
         +EuyTx4yBAKTR9mkaKuaQSzuNJvAzMjYIUWil6tKokwW1DXlRl4eViZbFprvB9ilz4CO
         DavQ==
X-Gm-Message-State: AOAM533FiQJi/o144AQ6bU4k/xhC3p5mk3glN453IGQamK7rRrVUF00Z
        ET/TZbAAisJRvU4TxXurWGEqrpVmDHA=
X-Google-Smtp-Source: ABdhPJzb1kAL61LS5SBKZjjZXwHnEZVIYiYM8YzLBn2hBXOPeog1PXdsDGRsZ+nDC2TEoDAC3qSHRw==
X-Received: by 2002:a05:6214:27ee:: with SMTP id jt14mr24949562qvb.119.1640808590167;
        Wed, 29 Dec 2021 12:09:50 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id de38sm13504346qkb.5.2021.12.29.12.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 12:09:49 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Tamir Duberstein <tamird@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] ipv6: raw: check passed optlen before reading
Date:   Wed, 29 Dec 2021 15:09:47 -0500
Message-Id: <20211229200947.2862255-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tamir Duberstein <tamird@gmail.com>

Add a check that the user-provided option is at least as long as the
number of bytes we intend to read. Before this patch we would blindly
read sizeof(int) bytes even in cases where the user passed
optlen<sizeof(int), which would potentially read garbage or fault.

Discovered by new tests in https://github.com/google/gvisor/pull/6957 .

The original get_user call predates history in the git repo.

Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 60f1e4f5be5a..c51d5ce3711c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk, int level, int optname,
 	struct raw6_sock *rp = raw6_sk(sk);
 	int val;
 
+	if (optlen < sizeof(val))
+		return -EINVAL;
+
 	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
-- 
2.34.1.448.ga2b2bfdf31-goog

