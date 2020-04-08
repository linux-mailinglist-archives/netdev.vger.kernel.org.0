Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A081A1A4E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 05:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDHDfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 23:35:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46143 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHDfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 23:35:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so2698950pgc.13;
        Tue, 07 Apr 2020 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oiq7K7zLDFU84F9c9eJl6byk3/OrOSVZXOPC7EzP7mc=;
        b=GN40wtIqU5GWVhPr3ciSa0FUwnyy4Sn9QRJyAVxYC5RxYcYRP4t4F2sgoOgrc7LW50
         lPDmsR0aiQ3VM5pcnskJslmyQKHMDXO4kynKnBjFBTl8eq5Q+nFwITQfp2vU9ynK9K4S
         bRUpVW5xNLDki0BZmfaOZS+Lt/Z6KCAnkf2woBZWD+b4Ft3ZMBS+7vM7OL/VSXLagBKv
         UbOTWufCM8zAjICYZmkGwl4xexKsb9aMWODr3SNRD22+A3s/1R4dUvYk0b7Ze2bPV1aD
         KJQACieXPvb/DmnXhvUeA3ywfJP+hz+CCAXniKex1ysyNH36hiI0yQaUGvzyn7Bglmo3
         uqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Oiq7K7zLDFU84F9c9eJl6byk3/OrOSVZXOPC7EzP7mc=;
        b=DxZIqb/Cyizwqc6cvCHiSf2LNifE2QmhrfIYK101iv6/VRL4x28tRw1ewlr1mXzGKr
         H0/OcSmoiQQR8Uxj1BKE/aKB2omuDy24h/k0BaeaAOpTdcQiMUpgJ64YFB+a26fvYJiI
         zaZI+gETe7EHfCfG9kG+AAzMaY28I6JT27DrqgBeRpBF9jAAB3tJvszBSBlLt7+4YA+S
         +PSzWXdIWylYMcN4BlNTK6jLeG26JwMjNZ2qZ+FtetHWJPrTqCC2lyt9GOFmKxcg7+8Z
         mUql9kDWyUKolf2yx2HW5HdR/aX44CWzfLKMf8Mgo1eFIge4Qh4k79QBjYva/8sFIA/6
         kLrA==
X-Gm-Message-State: AGi0Pua2Sbk1wzXkPZ0leBl2ZixFY7ljCDJkux9GfTWHjHi0oe1i6Bum
        +uZtIG63LuZrgVU8DYLs1Krp23NY
X-Google-Smtp-Source: APiQypKNQ1pzIRrnlKWyIqCYvREfTIper/LGecQSpV5k4bgf3q8s589euFvjkLlkSA5VNskW8HLfyQ==
X-Received: by 2002:a63:5f8e:: with SMTP id t136mr4984053pgb.7.1586316944349;
        Tue, 07 Apr 2020 20:35:44 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id u13sm14290098pgp.49.2020.04.07.20.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 20:35:43 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org
Subject: [PATCH bpf] bpf: Fix use of sk->sk_reuseport from sk_assign
Date:   Tue,  7 Apr 2020 20:35:40 -0700
Message-Id: <20200408033540.10339-1-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In testing, we found that for request sockets the sk->sk_reuseport field
may yet be uninitialized, which caused bpf_sk_assign() to randomly
succeed or return -ESOCKTNOSUPPORT when handling the forward ACK in a
three-way handshake.

Fix it by only applying the reuseport check for full sockets.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7628b947dbc3..7d6ceaa54d21 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5925,7 +5925,7 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -EOPNOTSUPP;
 	if (unlikely(dev_net(skb->dev) != sock_net(sk)))
 		return -ENETUNREACH;
-	if (unlikely(sk->sk_reuseport))
+	if (unlikely(sk_fullsock(sk) && sk->sk_reuseport))
 		return -ESOCKTNOSUPPORT;
 	if (sk_is_refcounted(sk) &&
 	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
-- 
2.20.1

