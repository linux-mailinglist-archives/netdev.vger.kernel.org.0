Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717F332A313
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381810AbhCBIql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444135AbhCBCjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:39:45 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D555C0617AA;
        Mon,  1 Mar 2021 18:38:05 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id v12so17502191ott.10;
        Mon, 01 Mar 2021 18:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tCjVfOBpsxyYlXVTXml2C2itPEUYXHFIwvXt6TaQXvU=;
        b=vQlmYwLFDUKxl8+LJSykwCdcFPOBtdcAz1uBaqpMn0bzEfGN6NOLoCIyUDMRHMvAfM
         1nGUrAg1bv+OO2ALNVCObNE5ak3cDdlCKRC5a9nPXA436404CahNQUcnzSx3i91nBPHR
         Hp6MEdtTGJezKLbcqzmuioe4CvQOHEoUXlVihRxWs0Y5Ddz1jvM365W6FlIKLfhiAlCK
         6GTSq4OCKR0Sb+Po5ED2ifeUM21CgGShXqVJKhOuqcEjIuog3UfLsE08HLHC21J9fWa6
         pUNLCgdbnBrvR/oZMvqIOr4hOirREC4JqcVvphOgK0voW8ukCT4TGrhBp0uZ8JartGmi
         2Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tCjVfOBpsxyYlXVTXml2C2itPEUYXHFIwvXt6TaQXvU=;
        b=STGR4rLbkD0yA9QNB/lhYET5QsYTd8jCu9NKmYYxfRAbGaUztNfcRzxtx0wjETAbUZ
         xfjkAjtLCDcVspzWc/tiZgBowG7WLHDMaMPY/ftYpIv2af+4umKimCxaWVAuWaF1f5Q7
         eFZWG5ayPm4MGUMUOFNBRaqxL1dlQrkrL0s+qN/YjERqWgFPCstHyhzatSNMR2zII6/3
         au9UdwIqZaz5nBuQGPi7/pkZC4X6TY1ne2KZDzkZ4O6nA6WuwF4NbDDCpggNRylfch0k
         3ymcAIFWicaM3Kkr+O4qM7/yza2iwbeWtHYh9ffAQR6fIm7YipsaNhn5SdBB0ERmVQrw
         pTRQ==
X-Gm-Message-State: AOAM530cwbLVAzZbyrt9O1GaqLvijAdWxie/ZuHTWhyARjHzz44NCRp0
        GhVGofskoe5K7ArA18JYiQtOV4kwzdO0sw==
X-Google-Smtp-Source: ABdhPJyvxw9GreDsJcpj3JFfgeWqyCP/h0GXPqD+SvFLoTXh0nN65wp3IlR9PrFiNuxaNxliaTjfug==
X-Received: by 2002:a9d:2e4:: with SMTP id 91mr16357634otl.60.1614652684830;
        Mon, 01 Mar 2021 18:38:04 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:38:04 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 8/9] sock_map: update sock type checks for UDP
Date:   Mon,  1 Mar 2021 18:37:42 -0800
Message-Id: <20210302023743.24123-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now UDP supports sockmap and redirection, we can safely update
the sock type checks for it accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 13d2af5bb81c..f7eee4b7b994 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
 
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
-- 
2.25.1

