Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715AC439C0E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhJYQvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbhJYQvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:51:03 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA43C061243
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m21so11500317pgu.13
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yW6wdXGI1aTedsTHKwfr06XOVK5hGfaHSHYVe7iixmE=;
        b=AAK8ozfKOhjIB//MhFNly4p0EzPTQIFlmyVoA9jzygnGKe0zmF51BJgCsH1qM6vX6g
         PP+lsukjauvc497q/EFUzoiac5BeJjAR4beuHUZHTsNDNKVwijB4Q/yfuusoUKyXmeUZ
         VnX2AiXgI2a3zLdY/9/AWgFXVAj9Mg7IPWkZngYfyN9N63WsVYL7bI43XAyqepNs9mQf
         cJTlDxel5TDOWFa0xsjwnQOOt2eirTuBv+kI2muaJeu3Ue381B3VJVgLoJIYVVA17RL1
         ifmXj7A5t99UK6qicZiYER/4CS3rivtUtjrSRQjDqP8WcFRdpKoG1i0Rt8gUcU0ae4n2
         exRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yW6wdXGI1aTedsTHKwfr06XOVK5hGfaHSHYVe7iixmE=;
        b=MfJqj2jemmAlGxo7jjhKhuwAEhW7fzeRI4kuqQPJCjzIOLmyS3VBxGN1VaA45l6KFw
         E73vVaRLMt22D/vFBg/UZt0qUBR58NiH+Cij8TXPhQ7M9hdoODBUCHAbWIFFaxy9QKck
         T/VGuggIPU+k77CTvwvbuK9+o0KjMpGdzkMPAV7MUw6QJD6w8jcrrIseGgj1arYtiIOi
         wepSiMrEBVDVueyFRQmAgvX7ztDE6Dtn9LPXCho98Tjc5gbBnbQRJ2gbIGKB0Hajt9XA
         /2zcHbZCOg/y8SbcEIsZ79cRtCx+hF1FMXsd/yzwpqnfLcNrEQ9VefDb8Cr5p6KCRZ0R
         lnNQ==
X-Gm-Message-State: AOAM532vL3Jif3u5+Pfk855OKMoQ4ruI9kxwpwr4H24p39HiY7kH5GRX
        ctLcCTKenKFhNDTpe3GCSd4=
X-Google-Smtp-Source: ABdhPJzKbGa3YXdrHxHVv6mV77H3gkZnM8yV9I1celHS8YV8NPt1F7z1CBal6XWN/cePDwmSgTJedg==
X-Received: by 2002:a05:6a00:1707:b0:44d:47e1:9ffe with SMTP id h7-20020a056a00170700b0044d47e19ffemr20013728pfc.53.1635180520774;
        Mon, 25 Oct 2021 09:48:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 10/10] ipv6/tcp: small drop monitor changes
Date:   Mon, 25 Oct 2021 09:48:25 -0700
Message-Id: <20211025164825.259415-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two kfree_skb() calls must be replaced by consume_skb()
for skbs that are not technically dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv6/tcp_ipv6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 6945583c0fa48256db5510866342e4aab672fd71..c678e778c1fb8f8cb7300c23cb876ef0d8e750c8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -572,7 +572,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
 	kfree(inet_rsk(req)->ipv6_opt);
-	kfree_skb(inet_rsk(req)->pktopts);
+	consume_skb(inet_rsk(req)->pktopts);
 }
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1594,7 +1594,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	kfree_skb(opt_skb);
+	consume_skb(opt_skb);
 	return 0;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

