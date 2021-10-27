Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA36143C584
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbhJ0Iwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbhJ0Iwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:52:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E5CC061570;
        Wed, 27 Oct 2021 01:50:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v1-20020a17090a088100b001a21156830bso4552864pjc.1;
        Wed, 27 Oct 2021 01:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5P3/alhJ1He0txyAzdck7/7d56+F/fzpzqghGnxQS8=;
        b=LrKScxu+Cucp9+VA8Fh1unPAtj/7zshPQgCWMkw5J8oT3efw8cbN3c4ai6VVR2qjpN
         yi6ZsVIyNWPig9umy3cp+99AlFO8qdLWV76TLgGeIeNWF3/tRQ2zYnfRmC+2+UURRejG
         SDtEQBMVHahz19Qr9pBqom8ZsBXt6Dl4yvS6cCvTtGQ2EoBnGUXTEiAaCT8pHI5cU2+B
         o6kaXpWDRsIthluNLtBQKcWa4saLe8syRy3lfJU7+9Z1iWLo6g7lDzDzQPVk85QvNQPr
         jULjI5hyjQKElSFa10vOV/3lzFpgefXX2q7ZVspwunbi53TxLhvc92tsXfz6DqIQA5yr
         SFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5P3/alhJ1He0txyAzdck7/7d56+F/fzpzqghGnxQS8=;
        b=vOxH9e/D1VXFd+vhKvGXidFk9KafLdIa3V355hHpkX13EVs1CUXrsrlvuOl9aRyY2f
         KKQnbq9GT0Kxn0S6v6quoxQG9up0Nk0ISOU+wJMmvlDipylkYgcKCN9XlnECtyKtprKZ
         9AAFRmo0EWeQRai0stJ7YpG3cob4BzPlt8w1SJf6HE/L6rbjn4FEWc7BfrtthFZ7Trve
         z4M+eeJquGYGcU1IwoGTa+2KePohi0zjeJuP1lKYwN/hAw51lcsnsdh442B0VahIfWre
         9b9djxrAdIl+G3A6Ll7j1o4VBn66/CW3NLzDne4HpNzRZi5kTYDfyzeirMEXD3Qyof7p
         xwQA==
X-Gm-Message-State: AOAM5326cX91tBDlKOiKtlGYJXO17AuXJkgwKw6J6TZWtriilTQxbwYx
        wnLBGwaCPIomAcU4tKeNG7o=
X-Google-Smtp-Source: ABdhPJzHbtpYZoghiArpc3WdPAyZOlRyOKbFVqo3wjB3HDjkVTNYVtaizG1t6Px7p7bQFEJ9zmoT3A==
X-Received: by 2002:a17:902:a70a:b0:140:44f9:6d75 with SMTP id w10-20020a170902a70a00b0014044f96d75mr19675029plq.58.1635324618570;
        Wed, 27 Oct 2021 01:50:18 -0700 (PDT)
Received: from localhost.localdomain ([154.86.159.246])
        by smtp.gmail.com with ESMTPSA id bg15sm3401055pjb.15.2021.10.27.01.50.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Oct 2021 01:50:18 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, bjorn@kernel.org, arnd@arndb.de,
        memxor@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <xingwanli@kuaishou.com>
Subject: [PATCH net] net: gro: flush the real oldest skb
Date:   Wed, 27 Oct 2021 16:49:44 +0800
Message-Id: <20211027084944.4508-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Prior to this patch, when the count of skbs of one flow is larger than
MAX_GRO_SKBS, gro_flush_oldest() flushes the tail of the list. However,
as we can see in the merge part of skb_gro_receive(), the tail of the
list is the newest, head oldest.

Here, we need to fetch the real oldest one and then process it to lower
the latency.

Fix: 07d78363dc ("net: Convert NAPI gro list into a small hash table.")
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7ee9fec..d52ebdb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6012,7 +6012,7 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 {
 	struct sk_buff *oldest;
 
-	oldest = list_last_entry(head, struct sk_buff, list);
+	oldest = list_first_entry(head, struct sk_buff, list);
 
 	/* We are called with head length >= MAX_GRO_SKBS, so this is
 	 * impossible.
-- 
1.8.3.1

