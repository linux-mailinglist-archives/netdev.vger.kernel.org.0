Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957E6451D91
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351840AbhKPAbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42B0C0BC9AA
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:11 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x64so15889451pfd.6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sQgKlPPaZyaV7kL3H7TCeuNqjSO9ANGpYIIAyZja9Hk=;
        b=lnN3WOD2Ckzvxr52vbifCl4bfOE7TrecOhuoYtvrCmWbbcaWL7PW+CurHkDeUaUEjB
         K2dq73T4ZQ7rAQkGcCqf5KvZgeerbKcj380pl8U2beqNo31i2HRdQSmDfXBhXaZm8BL8
         D4ndnKPtVcODYPs+NeDh8j8eu4bXr+/u7bhUJk6dJzwMyLcAlSDZhSqWfRN9/3Xj2aLI
         biAKY3/BHcX2iSP868OB16thDx+BAwypt+oj/zbTCZFwKySiH1d28zQYwBZe3evqHLCT
         A/gZy45KUnwyi5hjJnZu0zKezxKuHWLJ7VELESn5k0ZP6eGlhHWFWDrz0Ha254S6aL1/
         Tjgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sQgKlPPaZyaV7kL3H7TCeuNqjSO9ANGpYIIAyZja9Hk=;
        b=tklNp5ttDnh5jF2bquUZ4jUfR9A2GAObYSmk8qMrgFrw97VzTYp8U1MNZdcxVPvNGT
         bY0bXbJECNOHYtGnaTxT2fgU+Lb/VfXwizvRdb7XqZ40wC2QBE0BkE666dRZWv5PZCHs
         oOdHoArr6NGA8KdePYFmiamPiR5wYerNQHeU3il23wb3XMvIF9WX3gWQaorckvogWzKC
         1DDYLmLSgxSaEB40tlV1POBYlzSQCmLMRXWSF6YV58uOXKfXvcwxs6q7/TM16rqrX0FW
         p9HFzYckk14EVQFcvCwFOMO0mJebYSOxt22Vu3d2ormETzq3MthCJuk0Nmprx+qRx69C
         goOw==
X-Gm-Message-State: AOAM532q2pDsmzLbn1UH8bhLaOrVBf+qGBU7wLFq4dkLQLaOtIHSSHLU
        2JCykPifsayKF36spFKxdJw=
X-Google-Smtp-Source: ABdhPJw6UNpZ66a8QBS48wN9m/kcrHoP999XBONMt1xD3xerqgeot/v51ZqlYI1AimgLNS4pUHfxZg==
X-Received: by 2002:a65:6187:: with SMTP id c7mr744355pgv.317.1637002991295;
        Mon, 15 Nov 2021 11:03:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 08/20] net: shrink struct sock by 8 bytes
Date:   Mon, 15 Nov 2021 11:02:37 -0800
Message-Id: <20211115190249.3936899-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Move sk_bind_phc next to sk_peer_lock to fill a hole.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 985ddcd335048068b78a0525500734ef96be44a0..2333ab08178903533cbc2dc1415a0de9545aa6db 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -489,6 +489,7 @@ struct sock {
 	u16			sk_busy_poll_budget;
 #endif
 	spinlock_t		sk_peer_lock;
+	int			sk_bind_phc;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
 
@@ -498,7 +499,6 @@ struct sock {
 	seqlock_t		sk_stamp_seq;
 #endif
 	u16			sk_tsflags;
-	int			sk_bind_phc;
 	u8			sk_shutdown;
 	u32			sk_tskey;
 	atomic_t		sk_zckey;
-- 
2.34.0.rc1.387.gb447b232ab-goog

