Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504FE22A0D7
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbgGVUj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVUj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:39:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99845C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:39:28 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b25so2887809qto.2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDfea+uG51I8kFnlthybjJlwwYYSz9eqlYVwH8wM4xc=;
        b=V/iUEr4wtHrRXVcahM726i7S0Yb6pg4fnQsrv349k9t8tfqj6q7/Pdnt+nZUR75rij
         7k8RIyXJr/cV6okHeiu5WGNwdpccEsliHI7Fs66JsqtkAi8t+9myAbK+DvdIATq7t6sr
         jM2QOUOfnIBpxaZDIvg6P+TWX0UpIp89LUrcJP7XdGfAM/lRLbtpf61ltPvOwXeoubUC
         2qmrGvwEP7Yz6CxtzVuxOFINGR2x565di7iJ+rRe8XmEXjECLKIswwyACnyDcipiQnr8
         VBWvR9WH6hzdPYATx2wgtsqCKW2u+sVw+wZpNdWokLqbIb+cN4L9lI5O4ivoGYIi/mMH
         GoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDfea+uG51I8kFnlthybjJlwwYYSz9eqlYVwH8wM4xc=;
        b=UpkMhwjIqCKoagb6sTybpjKxe2Tq/fPB33IjX6h+Zu/jUVoMpjN5TPSFtsJbD7sWTj
         0Xd9FLtN6M4nTU9DNIDHqBtWIGpGRrHVr4sRbXAWWirnZkhj7yPEhnkXIv+Un3csF73S
         KBh8TZU6TaC1hdDjqMntLYZiMUNcQFR0KWrkug9ocAKPNK+mNhkYKg2PUpU9ImKzGNxp
         RnvOzVruy/tLDxzRe+MPr2iBAGC4y6CZVlaPpWE42+q9LPGyrUjk5ni98xmpHDeyFarp
         U7NtLCmptPwgezir8RQgZMi9dSefqT8+Ag98ggGJU7DtWf5qtYvRaq7QklTJJPib0GT2
         APvQ==
X-Gm-Message-State: AOAM532U4p7qekIuh9t4uC+7ldnu8ZoPXFr4Cvn+qYTdFKAkMOawJ39h
        dkrHxkiVy5cUETPH1AghAyY=
X-Google-Smtp-Source: ABdhPJwu8Js0d9nQvGWWFn2JAyepK49tq7PwSTvQ/4YQp4LnNZ/H6yIWYcdMCKBZV04hWK/3RrBu8g==
X-Received: by 2002:ac8:1e99:: with SMTP id c25mr1233513qtm.133.1595450367659;
        Wed, 22 Jul 2020 13:39:27 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.96])
        by smtp.gmail.com with ESMTPSA id e9sm564486qtq.70.2020.07.22.13.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 13:39:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7C22CC18B3; Wed, 22 Jul 2020 17:39:24 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Date:   Wed, 22 Jul 2020 17:38:58 -0300
Message-Id: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sockopt accepts two kinds of parameters, using struct
sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
notice an implicit cast from the smaller (latter) struct to the bigger
one (former) when copying the data from the user space, which now leads
to an attempt to write beyond the buffer (because it assumes the storing
buffer is bigger than the parameter itself).

Fix it by giving it a special buffer if the smaller struct is used by
the application.

Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9a767f35971865f46b39131fc8d96d8c3c2aa1a8..b71c36af7687247b4fc9e160219b76f5c41b2fe2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2756,6 +2756,7 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
+	struct sctp_sack_info _params;
 
 	if (optlen == sizeof(struct sctp_sack_info)) {
 		if (params->sack_delay == 0 && params->sack_freq == 0)
@@ -2767,7 +2768,9 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
 
-		if (params->sack_delay == 0)
+		memcpy(&_params, params, sizeof(struct sctp_assoc_value));
+		params = &_params;
+		if (((struct sctp_assoc_value *)params)->assoc_value == 0)
 			params->sack_freq = 1;
 		else
 			params->sack_freq = 0;
-- 
2.25.4

