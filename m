Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3733CDADD
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfJGEKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:03 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42050 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id f16so11353961qkl.9
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RJ60GjUODTjMnVGqKqoT02zjlIJ7RYFGZHfb8y3lCE=;
        b=Uo4u9t11RUlrlb66RXt5w1hPLPwJRw6KwAs2/wK4svnIz9GNP99JM7oq+tRJmtkSoC
         jef1YOqg+2aUZL41BY4wxUtBoL1tooZRzqlbbNAL2qScvgLs2OIwo1XoAzkLZd0oONeS
         uOW6maOCauSmSQuFk95QFkUw3twjbWV5rpr+PbToc34CLNIvcSuKpMsCmfHRPMe9qS/c
         IbduRdEg6ySNBgkak7CHhmK6Ssd8bMDh+2TRtNLJK0uJXgQ4vYoqrG+dgXgeNNa2i41f
         5V0/BpgQZpauWOg+Y/wL3Nh4B1b+JK4xVg1ZxSCxt+SSd7jSG4MUUe0t7LJdGLo84xpR
         g9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RJ60GjUODTjMnVGqKqoT02zjlIJ7RYFGZHfb8y3lCE=;
        b=pQnD9SgrJ1ixkiVggCW19nHcOVOg07mAZROzHbfMkUKj+i7J+mv/3HV6xkZ4LpHi0j
         tdKTmyfyxqZnsF/kTT7kelAtnyWhvbsWhhYO0esL7HyTcbj4wb89gXWrpFoQDdLZJoyq
         /5/33YkNo8FN6e90W+RhGRf6JErz/WOCVcs2KbMc80L22EZvj/2OxF1LFEVzSCjrRoHB
         guxf/jRa+LNsRyBvbDF4WYGtAmJkfvZNtPs9Z4BPlySzNvHD8dT/d24+YhMgvMfYgp0b
         uNIgdXbhK4mhszv5YS4w04sbChMdNYAREBGWmcxwlpPfajOaIhV9DsufJJktHJyIn3TP
         RWpg==
X-Gm-Message-State: APjAAAVKkokEkbfjPxQBedkXsXoMBkMcwoShT8KVIwV2QGzog+0rZAiq
        DmKkJA5ZzwyGIqKt+2xQKtR5Dw==
X-Google-Smtp-Source: APXvYqxVJ0AvSLS5DKETZBkIZclrY7aalzlqKgUfV70SOGAs2fN45ic2n+PyzmCyCQcOpZC8ld9hyg==
X-Received: by 2002:a37:c0f:: with SMTP id 15mr21884504qkm.73.1570421402459;
        Sun, 06 Oct 2019 21:10:02 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.10.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:01 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 2/6] net/tls: mark sk->err being set as unlikely
Date:   Sun,  6 Oct 2019 21:09:28 -0700
Message-Id: <20191007040932.26395-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tell GCC sk->err is not likely to be set.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f306e4c7bf15..fcf38edc07d6 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -431,7 +431,7 @@ static int tls_push_data(struct sock *sk,
 	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
 		return -ENOTSUPP;
 
-	if (sk->sk_err)
+	if (unlikely(sk->sk_err))
 		return -sk->sk_err;
 
 	flags |= MSG_SENDPAGE_DECRYPTED;
-- 
2.21.0

