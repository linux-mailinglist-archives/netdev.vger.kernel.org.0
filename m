Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F76629D0A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390955AbfEXRer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:34:47 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38710 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfEXReq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:34:46 -0400
Received: by mail-ua1-f66.google.com with SMTP id r19so3894778uap.5
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVLRj2A4cU1W2dC8iW5qwUQhtbqu4yav2jX/d+48yyA=;
        b=bb3nx3d0sLh6FimdlLBjLGjOxVrlnES9kQFqLS10sBFxFsH/eEgpfy/Qe8VKoR++Ga
         IUd9V8bCT+I/DVdk8hYRE9xIShTY043AxhfIEa2Tbz64YDV+Q4+d9+DwkKG+vFNrTwVc
         sJSJ+NbT5GyxVEB4NLJnuh8A6QibcJs5HOlaijOBwGRrcNsf2zOLKXcAaslPutKFcZ3v
         A2lV7DQuT0Br2+LNp4n0/ehIiTqzfQbF1jupZalYOAlCRVTrs9R4BA5Fp+Cc7dFyc1o2
         6piZWORGSi+ysQWutPEQGLUDY/aJRsqLYqF+VpXNDZcENifmOdB/dnONS/wK4ef8bkuE
         FUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVLRj2A4cU1W2dC8iW5qwUQhtbqu4yav2jX/d+48yyA=;
        b=bQtEKUGf9bMCWWfCuTIaLL1ZlgC0gxM+6TZtkBv/xShXJf6UMJpsSJ1LhjCwYAyDRH
         k9nNwzoQ0CCDsRP9csXG1GqP1QoFfu+hT1DNk3yewTls8nGtz5hYI5hcjFZzRZRpfuVq
         Dz21tuMvgkgJ8IFYei1NPCu+5PB5KybGyOaw72Ru0kcYi8RbahtB/fYsJSLoOstlo0JZ
         bLjVokNQKLvEMoHfx2jllsJwYp5qTsE9tzpEOFJFAeOYXITM96N2ygEaP6hIxdLH3CdZ
         vjL6zhwDWZduEEjVI8Hy6i3Nq1deNS90o/BrNbAlbZE/P6Z0tKbz+my1MrJo7FHskFx3
         gpTA==
X-Gm-Message-State: APjAAAWk4hP335DZKjrwVEyKfs7IuyEnQveZRkimhpsTkCIje4tT9hER
        E92/59500f1UjzVNKCj4tCgIDg==
X-Google-Smtp-Source: APXvYqwv7lGpi4xnlTMea2euZV3PZyDrTHrb8MeB8CNfoOUvCerTJmaGIiWLE3p617l8mN+m+BQxPA==
X-Received: by 2002:ab0:6083:: with SMTP id i3mr19087004ual.128.1558719285043;
        Fri, 24 May 2019 10:34:45 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2025647vsj.27.2019.05.24.10.34.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:34:44 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        David Beckett <david.beckett@netronome.com>
Subject: [PATCH net 1/4] net/tls: fix lowat calculation if some data came from previous record
Date:   Fri, 24 May 2019 10:34:30 -0700
Message-Id: <20190524173433.9196-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190524173433.9196-1-jakub.kicinski@netronome.com>
References: <20190524173433.9196-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If some of the data came from the previous record, i.e. from
the rx_list it had already been decrypted, so it's not counted
towards the "decrypted" variable, but the "copied" variable.
Take that into account when checking lowat.

When calculating lowat target we need to pass the original len.
E.g. if lowat is at 80, len is 100 and we had 30 bytes on rx_list
target would currently be incorrectly calculated as 70, even though
we only need 50 more bytes to make up the 80.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Tested-by: David Beckett <david.beckett@netronome.com>
---
 net/tls/tls_sw.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d93f83f77864..fc13234db74a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1712,13 +1712,12 @@ int tls_sw_recvmsg(struct sock *sk,
 		copied = err;
 	}
 
-	len = len - copied;
-	if (len) {
-		target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-	} else {
+	if (len <= copied)
 		goto recv_end;
-	}
+
+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+	len = len - copied;
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	do {
 		bool retain_skb = false;
@@ -1853,7 +1852,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		}
 
 		/* If we have a new message from strparser, continue now. */
-		if (decrypted >= target && !ctx->recv_pkt)
+		if (decrypted + copied >= target && !ctx->recv_pkt)
 			break;
 	} while (len);
 
-- 
2.21.0

