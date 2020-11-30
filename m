Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445392C837A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgK3Ltr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3Ltq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 06:49:46 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6DBC0613D2;
        Mon, 30 Nov 2020 03:49:00 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so10255530pfu.1;
        Mon, 30 Nov 2020 03:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NCRdmUn/vEWPXajvNRm52WRgCvk1LJ5o574yy3r7HmY=;
        b=D6i5DHVoSrhlot0bDJiAzrAI0sZrULz2hoq+hn4IdQ1AJD0CCfKd6Sn/lZ8mEyvJo9
         CYCkZ75/e8ptfvPPQNa4I0gKGRolaQP7V+BVaOC18+YADCEN/NYVZ0xaFka5J0GVO8/X
         oZZ/oneNdRBJzDg/tpTkCkEMeteQVcSQfDu+ELY/oyQGKo1BrlGKMBdXryNpRCCG078T
         HGy9ULR7QDOrMgAIc4TQRe7DIGvHIFB2RvI11wx2fzz5nK9QISpqoNeFAiEP2wHK4XSi
         SX9jfGZmna2YQ89+RkaF0NOEGQAWWlqglnjozdsqYhJgADkOSfFmFiil3whwJi5hwGcK
         1Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NCRdmUn/vEWPXajvNRm52WRgCvk1LJ5o574yy3r7HmY=;
        b=hS4Y4PlIESc3pAYnb950KcGLoa2EVxNOGI7KnG1nfe0gBmJheW0kImo75z/9LQJe6J
         mO1tll8ttEsWv6hpQO5zNPWLDXN3E5GQDuU1XCHT9khieWZn0oshoPj+pOGevIpuhY6u
         qXcj44f0cUz55loQkZ7Xd3s9cUFOdyFt8orKQTg2hbHOlav4K5UiTDYALX60ieeHmH4n
         JVEh7wcEHfciM9KpZP3LXwjCbT71tgwOQOqZ4RP6B2Sh10cESr1vYLx7q8MpcSgsfR7Z
         K+Gglg/6M5Hi2lDDvn7I4KLrMW05tEGXdBEvx5mJSnLE07kaFrvrakUdUsrDvg0oU3qF
         nGBQ==
X-Gm-Message-State: AOAM531/0xKLJi/kXelozyRXomP8wzJ7XMzcHgBJ1mlrxT6kWul99wdm
        +Ner9p2u41wxHbMhG6uegfs=
X-Google-Smtp-Source: ABdhPJxFr98QjZIGw6WnKEKyOh22wInQBJIQormgHY8T7BmpgiLsNvlmPyepjwUcsQ/pqwU0bxGWSA==
X-Received: by 2002:a65:6219:: with SMTP id d25mr6600834pgv.154.1606736940421;
        Mon, 30 Nov 2020 03:49:00 -0800 (PST)
Received: from localhost.localdomain ([49.236.93.237])
        by smtp.gmail.com with ESMTPSA id p1sm3781653pfb.208.2020.11.30.03.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 03:48:59 -0800 (PST)
Sender: Leesoo Ahn <yisooan.dev@gmail.com>
From:   Leesoo Ahn <dev@ooseel.net>
X-Google-Original-From: Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: xdp: Give compiler __always_inline hint for xdp_rxq_info_init()
Date:   Mon, 30 Nov 2020 20:48:25 +0900
Message-Id: <20201130114825.10898-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function has only a statement of calling memset() to
clear xdp_rxq object. Let it always be an inline function.

Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..dab72b9a71a1 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -151,7 +151,7 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg);
 
-static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
+static __always_inline void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
 {
 	memset(xdp_rxq, 0, sizeof(*xdp_rxq));
 }
-- 
2.26.2

