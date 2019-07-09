Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C59B62E60
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGICyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:54:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41148 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfGICyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:54:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so18785920qtj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHwuAVDAnHBzY93Rjaat7Cr9DpSuN7v3XHX8XwLT/Jk=;
        b=RFRVy5mVYXmMOjCyRzHxXOhTlZ8HREr2Gwa1Y9+8mFCfVUvkN5nxVWsuezZQO0BzUC
         tay6omeZSyRuNWJaYqNujzrTkJ4nxyOvhtQsc2AGq65tpmuePcCiD1VcjG27HHeYn84N
         BLaHG+n8cOahd9ztMeYD1VVuiSTRDS552Odzml9pmJS0DVMZRLaDdz3zRs+YTI/UjfBM
         AyJQ2FBWj6GSywvXls3zyZH39/TgAwr21uU0SE3hbaHv6MH251StUoATHE/vvUdZS8IF
         GDzt7N8KXUhNLWO1WxCp8dta8h2rajA29gO8Ek6t1rqSL6vyTRuPqmGYmTxekel4bds1
         yhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHwuAVDAnHBzY93Rjaat7Cr9DpSuN7v3XHX8XwLT/Jk=;
        b=DT9vxJaxI8DssYu0ZqfaURzRZ/0ye/YnspQmlmIq17VUZWN5A+fbiEoQyv1LXJt/OP
         fTNAJLZpMMgqJl8WPg7w+CtOa+wFWZLotvkiNLnthIoZIfmVdJTBDSK/18EulyOpIlcP
         L1N0CdC6SbggNrTz7I7XeHu0KfP0RV5E6fPW6agQ8hd7foF3FE9XOIO5CVJh/+Ll2Hce
         LRip4WS3Z+ePbv9viNTdqGpInP7SmIGzQtC+AyGKfWstzWyw+pyB5Hp4IjXCccc8AcSL
         7fWqZ68UX+VdIfh6xBYZ3BdARuf9D9JUtVRMleiAWnUVvCs8Ylj4I2i1k7ZyNhUpL7yh
         iq8Q==
X-Gm-Message-State: APjAAAUe/Fg4XSso8dZMPB5HQILlCjrEMZ8ITZNRsC4r2TpND7QPQwNg
        HCivf/JXA4PbuZPf2YQ5DXlzsw==
X-Google-Smtp-Source: APXvYqwuw/TT1vHOJEjfbM8J9ZLjijTgcioA4AfBom9mJQEC37kVoAGsQ7CYeuCeIH3dQpyhjXCHyQ==
X-Received: by 2002:ac8:21f2:: with SMTP id 47mr16788081qtz.38.1562640839363;
        Mon, 08 Jul 2019 19:53:59 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:58 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 11/11] net/tls: fix socket wmem accounting on fallback with netem
Date:   Mon,  8 Jul 2019 19:53:18 -0700
Message-Id: <20190709025318.5534-12-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netem runs skb_orphan_partial() which "disconnects" the skb
from normal TCP write memory accounting.  We should not adjust
sk->sk_wmem_alloc on the fallback path for such skbs.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device_fallback.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 1d2d804ac633..9070d68a92a4 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -209,6 +209,10 @@ static void complete_skb(struct sk_buff *nskb, struct sk_buff *skb, int headln)
 
 	update_chksum(nskb, headln);
 
+	/* sock_efree means skb must gone through skb_orphan_partial() */
+	if (nskb->destructor == sock_efree)
+		return;
+
 	delta = nskb->truesize - skb->truesize;
 	if (likely(delta < 0))
 		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));
-- 
2.21.0

