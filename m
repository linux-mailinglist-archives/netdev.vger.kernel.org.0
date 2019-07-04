Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1E5FE41
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfGDVvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:51:00 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37440 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfGDVvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:51:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so7120985qtk.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N0kLC5iQW4l++HnbRhXzNrsN94ZrzzJBmo9rxxQxVZY=;
        b=oiH3+O5M3qjc2+53PDHOJ3t6xZUad8065KMEZ907tzhO9DGu7LPuH/ivERa0iKovGM
         apz3Atyja9ukZQxUj8bQKcWJv3LcY5t3hLvLMuXeMKispmtrS+1ZQXdU8OS5OPSV4ni8
         PiFkZGRC9bswGr2qojiPlOtVdNML64kQtPSpwGAfBCrDlP+8UuWfyMxI55diYrnG0ItF
         2flDZ3zGohPc7uEJ5gP3Ai5MZZsJPFB0QVUNkjjU4JZP7dTVhxkxiGJbNFDMcFfH0v8X
         HAkuDxeBJVe4QB9NBLy8qKnl38kRbcSATh/Xe5qpkZN+u8FOVdBGdoBK65Y7vMgTebGm
         PZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N0kLC5iQW4l++HnbRhXzNrsN94ZrzzJBmo9rxxQxVZY=;
        b=YSiP1TDdS8bEScHA6WSXaqzgrBnGv1nHoEiyCfWOOCiL7FJUC5jEGG+qqpdGoOsYxP
         wIa709iKR5nKClYI27vtAvqvDR/4qSGSjwKE9XBS52xK/sv591+BgPmL7dxCwPYgAYZu
         Q5n8lZORXoTeANeA4PWS9HNl1x4mzsf7YdYn1J5oaNfhL9CcD05mXvMfXcyANaUsteC7
         sKQjS0x4hBwggsXAVp5nJzLYqzh6giL3IJGksoSNOT+hinDOyswJnwkzF0u0vxFiK6za
         6ATPJJOWp9roFozezztmeAgmjT8xAL6GCgFjHT97Q3+ChdeEuWxf4IV3qVTMlVwXlKIN
         TteQ==
X-Gm-Message-State: APjAAAV/KYJniIJHsucdhWd+nucqiOYmE987Zw3UWJ2EiGMOHvbnn+wU
        6/EM8QKnQMT3AitMvxPbyO764w==
X-Google-Smtp-Source: APXvYqzoCmxet8n9hxJ846b/ALNVZpRFhOqE1VXeuGV5MJUW8zgOQxw4IK1A9BGMRlEnZ12rBVQRgw==
X-Received: by 2002:a0c:887c:: with SMTP id 57mr401891qvm.192.1562277059146;
        Thu, 04 Jul 2019 14:50:59 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm3542329qth.33.2019.07.04.14.50.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 14:50:58 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 1/2] net/tls: fix poll ignoring partially copied records
Date:   Thu,  4 Jul 2019 14:50:36 -0700
Message-Id: <20190704215037.6008-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704215037.6008-1-jakub.kicinski@netronome.com>
References: <20190704215037.6008-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David reports that RPC applications which use epoll() occasionally
get stuck, and that TLS ULP causes the kernel to not wake applications,
even though read() will return data.

This is indeed true. The ctx->rx_list which holds partially copied
records is not consulted when deciding whether socket is readable.

Note that SO_RCVLOWAT with epoll() is and has always been broken for
kernel TLS. We'd need to parse all records from the TCP layer, instead
of just the first one.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_sw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 455a782c7658..e2385183526e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1958,7 +1958,8 @@ bool tls_sw_stream_read(const struct sock *sk)
 		ingress_empty = list_empty(&psock->ingress_msg);
 	rcu_read_unlock();
 
-	return !ingress_empty || ctx->recv_pkt;
+	return !ingress_empty || ctx->recv_pkt ||
+		!skb_queue_empty(&ctx->rx_list);
 }
 
 static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
-- 
2.21.0

