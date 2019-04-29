Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5BEAC5
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfD2TTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:19:42 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39546 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfD2TTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 15:19:42 -0400
Received: by mail-qt1-f195.google.com with SMTP id h16so7634781qtk.6
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 12:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ts2NGvtl8UVhXGMi9AB/U89mSoY7ePVBmx6sxZMKuAg=;
        b=tOQDFwRNW50G2TbLAYitFB1O2CiYQG7lD7mkzkRaxI1coGcHQPRGGKg+UqhRUy3Ch4
         QwUJdJqaNwj2nt1t6s4EamwhShqu/E07kOVggTGmKFJxeCBYyHwG/FIrXOGOJa+FSaq9
         I0VI01hFtM0MF9EW7ZmspaEHgI88xqGmdAW/JZywJqmiGHGwW0Kqxhq6PyaR8o9sBfWx
         BWY6V4czAfCxVelaeLfyc33OGfH34mYx4dCcTKParWWI+AytbUbnwZAhUY2fozZEBM3N
         3MvC5xqW0JJHXrNoyQqSJ5vXMrldRB4HiBPdedLj8pEGeJ8NHewV8EeA0LTMPcAn9g3H
         G+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ts2NGvtl8UVhXGMi9AB/U89mSoY7ePVBmx6sxZMKuAg=;
        b=oC0M0+HXmCikO0sNu746tcJOdS6L57Vh/4SHEfeDrH3UeNG1lhC20iZ2B+Pdls8hcc
         zqiMAPMQqFiX8tCL/pWLTx5vpJXK6dwF5bHvGiv0Exthij2i6lScD1KIew4vte9a+x1+
         2Xqhjl9y39106/AG0cxEmA/JiNgZ2LMUhiNUvbe2gXDGWVsRtwW2TrqARryflTI06SYD
         dcd+Hkd7yUu6fbHNx8TJLghchGWPxp7eVV1SzQOWxjtuqXrG/iwogcKzp1/RPmrkMFui
         wHP4z5OHAich7GCQEH2IMef2N5YhLD7sGuIPFQiXdKF/ikM5qGFLyrKkamUfIgCH4VFB
         +7Jg==
X-Gm-Message-State: APjAAAWDiYaPBIldywmXSq0vlHrTxL2waXxVron4PIKDXGNWViLR9z7V
        +uQyXWDK1cmXE8/7zdbDfaoZkQ==
X-Google-Smtp-Source: APXvYqwISF/Ahd7U+wLXZczgUcH3nNzxxbVvRNA95ecW3XFMbPFSYiucgxffyTBktJw+HPHUrKQRIw==
X-Received: by 2002:ac8:2272:: with SMTP id p47mr30752717qtp.202.1556565581495;
        Mon, 29 Apr 2019 12:19:41 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l59sm20547145qte.6.2019.04.29.12.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 12:19:40 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        alexei.starovoitov@gmail.com, saeedm@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net/tls: avoid NULL pointer deref on nskb->sk in fallback
Date:   Mon, 29 Apr 2019 12:19:12 -0700
Message-Id: <20190429191912.13189-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

update_chksum() accesses nskb->sk before it has been set
by complete_skb(), move the init up.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_device_fallback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index a3ebd4b02714..c3a5fe624b4e 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -201,13 +201,14 @@ static void complete_skb(struct sk_buff *nskb, struct sk_buff *skb, int headln)
 
 	skb_put(nskb, skb->len);
 	memcpy(nskb->data, skb->data, headln);
-	update_chksum(nskb, headln);
 
 	nskb->destructor = skb->destructor;
 	nskb->sk = sk;
 	skb->destructor = NULL;
 	skb->sk = NULL;
 
+	update_chksum(nskb, headln);
+
 	delta = nskb->truesize - skb->truesize;
 	if (likely(delta < 0))
 		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));
-- 
2.21.0

