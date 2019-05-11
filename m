Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BDD1A95C
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEKUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 16:16:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51772 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfEKUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 16:16:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id o189so10436709wmb.1
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 13:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oFNu5V4437RfWuwqQqW1Oi8bzMEKmaJKuacTlqlURsA=;
        b=T/jyTPNZpzZ4hyg7b47bHn/TyhnpTboMEdyMJPHU4xy6V9hUc7w9gSfnkWY6JblJTM
         qXDqg+289qodMIlflpDg9pFTWofZ0mB1MG3+zwKxxBWa7HRd733JvWw7xTCWY2QpKXll
         eoYA/NXMGGQYcHOfuTZKSJ4tkPL+45Fv9GpdMFZMcIknU874nasq3ySSNuj6VK56tRWT
         tj9WMSDgke7jTxpKJGuoim28R2ldRKRhUd0FvF7dbBeagIHuqU3QG5cHzy2ujxGyA3K5
         56FFbxvtXsewIYDBe82lngPNPjVhFLUwG1kAmyAeYAtH2sj4KXbzcmqBM+6g4WGZSPPO
         slFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oFNu5V4437RfWuwqQqW1Oi8bzMEKmaJKuacTlqlURsA=;
        b=U4M9hu3lmmNrQ7YAAm/KPVFh3R4KpCg7WXIX2yFrue7000S8RheAr4q+Unp5Zxq9ZT
         /k0RN3yDZdunn/L/1tJOxfA/VZvgj/xMaCpLRkz+bQc/cnxnZ+Ort7H81hMMxcqz8gOr
         /3Fjdj6eLMdBvuusHNTvqUvAT2zPnca6D9kFHL5SGMvpf2WGs62hei9GHf2cwEkJ7k7E
         hkOAPRedbGZua9Kcx0zmSwMeG4YyG3mMN2imuir+gkJ/K7b6mCREaCvGEPzDRirlKntd
         0OP0bXqBRTb6RlwsQLeWWrYuWASrILugGYlzQGPlAjDk0TuoS1ery1lbsFZjSrGFS3nE
         cRIg==
X-Gm-Message-State: APjAAAWVBmy+4BB/ueyXBPgYNQ5dlInCFA2UqAoe+wIQiwwChAcUrVPB
        Q7UEgSntyf+MMmaZhAcEeys=
X-Google-Smtp-Source: APXvYqyQjQhkkUYwCv+eD3nWVyC83XdC19X7Qiw6WRLJDnwApvnEkV/pXSBkFsJVKMukK9NSm1kSDA==
X-Received: by 2002:a7b:c74e:: with SMTP id w14mr10666679wmk.19.1557605771009;
        Sat, 11 May 2019 13:16:11 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id c20sm11853275wre.28.2019.05.11.13.16.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 13:16:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/3] net: dsa: Remove dangerous DSA_SKB_CLONE() macro
Date:   Sat, 11 May 2019 23:14:46 +0300
Message-Id: <20190511201447.15662-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190511201447.15662-1-olteanv@gmail.com>
References: <20190511201447.15662-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This does not cause any bug now because it has no users, but its body
contains two pointer definitions within a code block:

		struct sk_buff *clone = _clone;	\
		struct sk_buff *skb = _skb;	\

When calling the macro as DSA_SKB_CLONE(clone, skb), these variables
would obscure the arguments that the macro was called with, and the
initializers would be a no-op instead of doing their job (undefined
behavior, by the way, but GCC nicely puts NULL pointers instead).

So simply remove this broken macro and leave users to simply call
"DSA_SKB_CB(skb)->clone = clone" by hand when needed.

There is one functional difference when doing what I just suggested
above: the control block won't be transferred from the original skb into
the clone. Since there's no foreseen need for the control block in the
clone ATM, this is ok.

Fixes: b68b0dd0fb2d ("net: dsa: Keep private info in the skb->cb")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35ca1f2c6e28..1f6b8608b0b7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -105,15 +105,6 @@ struct __dsa_skb_cb {
 #define DSA_SKB_CB_PRIV(skb)			\
 	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
 
-#define DSA_SKB_CB_CLONE(_clone, _skb)		\
-	{					\
-		struct sk_buff *clone = _clone;	\
-		struct sk_buff *skb = _skb;	\
-						\
-		DSA_SKB_CB_COPY(clone, skb);	\
-		DSA_SKB_CB(skb)->clone = clone; \
-	}
-
 struct dsa_switch_tree {
 	struct list_head	list;
 
-- 
2.17.1

